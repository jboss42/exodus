unit presence;
{
    Copyright 2001, Peter Millard

    This file is part of Exodus.

    Exodus is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Exodus is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Exodus; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

interface

uses
    XMLTag,
    JabberID,
    Signals, 
    Contnrs, SysUtils, classes;

type
    // <presence type="subscribe"
    TJabberPres = class(TXMLTag)
    private
    public
        toJID: TJabberID;
        fromJID: TJabberID;
        PresType: string;
        Status: string;
        Show: string;
        Priority: integer;
        error_code: string;

        constructor Create; override;
        destructor Destroy; override;

        function xml: string; override;
        function isSubscription: boolean;
        procedure parse(tag: TXMLTag);
    end;

    TJabberPPDB = class;

    TPresenceEvent = procedure(event: string; tag: TXMLTag; p: TJabberPres) of object;
    TPresenceListener = class(TSignalListener)
    public
    end;

    TPresenceSignal = class(TSignal)
    public
        procedure Invoke(event: string; tag: TXMLTag; p: TJabberPres = nil); overload;
        function addListener(callback: TPresenceEvent): TPresenceListener; overload;
    end;

    TJabberPPDB = class(TStringList)
    private
        _js: TObject;
        _last_pres: TJabberPres;

        procedure Callback(event: string; tag: TXMLTag);
        procedure DeletePres(p: TJabberPres);
        procedure AddPres(p: TJabberPres);
        function  GetPresList(sjid: string): TStringList;
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetSession(js: TObject);

        function FindPres(sjid, resource: string): TJabberPres;
        function NextPres(last: TJabberPres): TJabberPres;

        property LastPres: TJabberPres read _last_pres;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef linux}
    QDialogs,
    {$else}
    Dialogs,
    {$endif}
    Session,
    XMLStream,
    XMLUtils;

{---------------------------------------}
constructor TJabberPres.Create;
begin
    inherited Create;

    toJID := TJabberID.Create('');
    fromJID := TJabberID.Create('');
    PresType := '';
    Status := '';
    Show := '';
    Priority := -1;
    Self.name := 'presence';
    error_code := '';
end;

{---------------------------------------}
destructor TJabberPres.Destroy;
begin
    toJID.Free;
    fromJID.Free;
    inherited Destroy;
end;

{---------------------------------------}
function TJabberPres.xml: string;
begin
    if toJID.jid <> '' then
        PutAttribute('to', toJID.full);

    if fromJID.jid <> '' then
        PutAttribute('from', fromJID.jid);

    if Status <> '' then
        Self.AddBasicTag('status', Status);

    if Show <> '' then
        Self.AddBasicTag('show', Show);

    if PresType <> '' then
        PutAttribute('type', PresType);

    if Priority >= 0 then
        Self.AddBasicTag('priority', IntToStr(priority));

    Result := inherited xml;
end;

{---------------------------------------}
function TJabberPres.isSubscription: boolean;
begin
    // is this a subscription packet
    Result :=   (PresType = 'subscribe') or
                (PresType = 'subscribed') or
                (PresType = 'unsubscribe') or
                (PresType = 'unsubscribed');
end;

{---------------------------------------}
procedure TJabberPres.parse(tag: TXMLTag);
var
    err_tag, pri_tag, stat_tag, show_tag: TXMLTag;
    f,t: string;
begin
    // parse the tag into the proper elements
    stat_tag := tag.GetFirstTag('status');
    show_tag := tag.GetFirstTag('show');
    pri_tag  := tag.GetFirstTag('priority');
    PresType := tag.GetAttribute('type');

    if stat_tag <> nil then
        Status := stat_tag.Data;
    if show_tag <> nil then
        Show := show_tag.Data;
    if pri_tag <> nil then
        Priority := SToInt(Trim(pri_tag.Data));

    f := tag.GetAttribute('from');
    t := tag.GetAttribute('to');
    if f <> '' then
        fromJID.ParseJID(f);
    if t <> '' then
        toJID.ParseJID(t);

    if (presType = 'error') then begin
        // get the error code.
        err_tag := tag.GetFirstTag('error');
        if (err_tag <> nil) then
            error_code := err_tag.getAttribute('code');
        end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberPPDB.Create;
begin
    inherited Create;
end;

{---------------------------------------}
destructor TJabberPPDB.Destroy;
begin
    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberPPDB.SetSession(js: TObject);
begin
    _js := js;
    with TJabberSession(_js) do begin
        RegisterCallback(Callback, '/packet/presence');
        end;
end;

{---------------------------------------}
procedure TJabberPPDB.Callback(event: string; tag: TXMLTag);
var
    p, curp: TJabberPres;
    pi: integer;
    s: TJabberSession;
    t: TXMLTag;
begin
    // we are getting a new pres packet
    curp := TJabberPres.Create;
    curp.Parse(tag);
    _last_pres := curp;
    pi := Self.IndexOf(curp.fromJID.jid);
    s := TJabberSession(_js);
    if curp.PresType = 'unavailable' then begin
        // remove this resource from the PPDB
        p := FindPres(curp.fromJID.jid, curp.fromJID.resource);
        if p <> nil then begin
            DeletePres(p);
            s.FireEvent('/presence/unavailable', tag, curp);
            end;
        end
    else if curp.PresType = 'error' then begin
        // some kind of error presence
        if (curp.error_code = '407') then begin
            t := TXMLTag.Create('register');
            t.PutAttribute('jid', curp.fromJID.domain);
            s.FireEvent('/session/register', t);
            t.Free;
            end
        else
            s.FireEvent('/presence/error', tag, curp);
        end
    else if (curp.PresType = 'subscribe') or
        (curp.PresType = 'subscribed') or
        (curp.PresType = 'unsubscribe') or
        (curp.PresType = 'unsubscribed') then begin
        // do nothing... some kind of s10n request
        s.FireEvent('/presence/subscription', tag, curp);
        end
    else begin
        // some kind of available pres
        p := FindPres(curp.fromJID.jid, curp.fromJID.resource);
        if p <> nil then begin
            // this already exists, nuke it and put it back in
            Deletepres(p);
            end;
        AddPres(curp);

        if pi < 0 then begin
            // this person was offline
            MainSession.FireEvent('/presence/online', tag, curp);
            end;
        s.FireEvent('/presence/available', tag, curp);
        end;
end;

{---------------------------------------}
procedure TJabberPPDB.AddPres(p: TJabberPres);
var
    pl: TStringList;
    insert, i: integer;
    cp: TJabberPres;
begin
    // Add the presence packet to the PPDB
    pl := GetPresList(p.fromJID.jid);
    if pl <> nil then begin
        // list already exists
        insert := -1;

        // scan for the correct insertion point
        for i := 0 to pl.Count - 1 do begin
            cp := TJabberPres(pl.Objects[i]);
            if (cp.priority <= p.priority) then
                insert := i;
            end;

        if (insert = -1) then
            pl.AddObject(Lowercase(p.fromJID.resource), p)
        else
            pl.InsertObject(insert, Lowercase(p.fromJID.resource), p);
        end
    else begin
        // Create a string list for this JID..
        // and add it to our own list
        pl := TStringList.Create;
        pl.AddObject(Lowercase(p.fromJID.Resource), p);

        Self.AddObject(Lowercase(p.fromJID.jid), pl);
        end;
end;

{---------------------------------------}
procedure TJabberPPDB.DeletePres(p: TJabberPres);
var
    i: integer;
    pl: TStringList;
begin
    // delete this presence packet
    pl := GetPresList(p.fromJID.jid);
    if pl <> nil then begin
        i := pl.indexOfObject(p);
        p.Free;
        if i >= 0 then
            pl.Delete(i);

        if pl.Count <= 0 then begin
            i := self.indexOfObject(pl);
            pl.Free;
            if i >= 0 then Delete(i);
            end;
        end;
end;

{---------------------------------------}
function TJabberPPDB.GetPresList(sjid: string): TStringList;
var
    pi: integer;
begin
    pi := indexOf(Lowercase(sjid));
    if pi >= 0 then
        Result := TStringList(Objects[pi])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberPPDB.FindPres(sjid, resource: string): TJabberPres;
var
    pl: TStringList;
    pi: integer;
begin
    // find the next or pri presence packet
    Result := nil;

    pl := GetPresList(sjid);
    if pl <> nil then begin
        if resource <> '' then begin
            pi := pl.indexOf(Lowercase(resource));
            if pi >= 0 then
                Result := TJabberPres(pl.Objects[pi]);
            end
        else begin
            if pl.Count > 0 then
                Result := TJabberPres(pl.Objects[0]);
            end;
        end;
end;

{---------------------------------------}
function TJabberPPDB.NextPres(last: TJabberPres): TJabberPres;
var
    pl: TStringList;
    i: integer;
begin
    // find the next pres for this person
    Result := nil;
    pl := GetPresList(last.fromJID.jid);
    if pl <> nil then begin
        i := pl.IndexOfObject(last);
        if i >= 0 then begin
            i := i + 1;
            if i < pl.Count then
                Result := TJabberPres(pl.Objects[i]);
            end;
        end;
end;

function TPresenceSignal.addListener(callback: TPresenceEvent): TPresenceListener;
var
    l: TPresenceListener;
begin
    //
    l := TPresenceListener.Create();
    l.callback := TMethod(callback);
    Self.AddObject('', l);
    Result := l
end;

procedure TPresenceSignal.Invoke(event: string; tag: TXMLTag; p: TJabberPres);
var
    i: integer;
    l: TPresenceListener;
    cmp, e: string;
    sig: TPresenceEvent;
begin
    // dispatch this to all interested listeners
    cmp := Lowercase(Trim(event));
    for i := 0 to Self.Count - 1 do begin
        e := Strings[i];
        l := TPresenceListener(Objects[i]);
        sig := TPresenceEvent(l.callback);
        if (e <> '') then begin
            // check to see if the listener's string is a substring of the event
            if (Pos(e, cmp) >= 1) then
                sig(event, tag, p);
            end
        else
            sig(event, tag, p);
        end;
end;



end.

