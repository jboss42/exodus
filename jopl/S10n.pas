unit S10n;
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
    XMLTag, Session,
    SysUtils, Classes;

type
    TSubController = class
    private
        _transports: TStringList;
        _session: longint;
        _sub: longint;
        _subd: longint;
        _unsub: longint;
        _unsubd: longint;
    published
        procedure SessionCallback(event: string; tag: TXMLTag);
    public
        Constructor Create;
        Destructor Destroy; override;

        procedure Subscribe(event: string; tag: TXMLTag);
        procedure Subscribed(event: string; tag: TXMLTag);
        procedure UnSubscribe(event: string; tag: TXMLTag);
        procedure UnSubscribed(event: string; tag: TXMLTag);
end;

var
    SubController: TSubController;

resourcestring
    sS10nDeny = 'The contact: %s did not grant your subscription request.'#13#10'This user may not exist.';


procedure SendSubscribe(sjid: string; Session: TJabberSession);
procedure SendSubscribed(sjid: string; Session: TJabberSession);
procedure SendUnSubscribe(sjid: string; Session: TJabberSession);
procedure SendUnSubscribed(sjid: string; Session: TJabberSession);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef Win32}
    Dialogs,
    {$else}
    QDialogs,
    {$endif}
    Presence,
    JabberID,
    Roster;

{---------------------------------------}
Constructor TSubController.Create;
begin
    inherited;
    
    _sub    := MainSession.RegisterCallback(Subscribe, '/packet/presence[@type="subscribe"]');
    _subd   := MainSession.RegisterCallback(Subscribed, '/packet/presence[@type="subscribed"]');
    _unsub  := MainSession.RegisterCallback(UnSubscribe, '/packet/presence[@type="unsubscribe"]');
    _unsubd := MainSession.RegisterCallback(UnSubscribed, '/packet/presence[@type="unsubscribed"]');
    _session := MainSession.RegisterCallback(SessionCallback, '/session');

    _transports := TStringList.Create();
end;

{---------------------------------------}
Destructor TSubController.Destroy;
begin
    MainSession.UnRegisterCallback(_sub);
    MainSession.UnRegisterCallback(_subd);
    MainSession.UnRegisterCallback(_unsub);
    MainSession.UnRegisterCallback(_unsubd);
    MainSession.UnRegisterCallback(_session);
    _transports.Free();
    inherited Destroy;
end;

{---------------------------------------}
procedure TSubController.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/transport') then
        _transports.Add(TJabberID.Create(tag.getAttribute('jid')).jid);
end;

{---------------------------------------}
procedure TSubController.Subscribe(event: string; tag: TXMLTag);
var
    j: TJabberID;
    incoming: integer;
    prompt: boolean;
    ritem: TJabberRosterItem;
begin
    // getting a s10n request
    j := TJabberID.Create(tag.GetAttribute('from'));

    // deal w/ transports
    if (_transports.IndexOf(j.jid) >= 0) then
        SendSubscribed(j.full, MainSession)

    // deal w/ normal subscription requests
    else begin
        incoming := MainSession.Prefs.getInt('s10n_auto_accept');
        ritem := MainSession.roster.Find(j.jid);

        prompt := false; // auto-accept all
        if (incoming = 0) then // auto-accept from none
            prompt := true
        else if (incoming = 1) then // auto-accept from roster
            prompt := (ritem = nil);

        if (prompt) then
            MainSession.FireEvent('/session/gui/subscribe', tag)
        else begin
            if ((ritem = nil) or (ritem.subscription = 'none')) then begin
                SendSubscribe(j.jid, MainSession);
                SendSubscribed(j.jid, MainSession);
            end
            else if (ritem.subscription = 'to') then
                SendSubscribed(j.jid, MainSession);
        end;

    end;
    j.Free;
end;

{---------------------------------------}
procedure TSubController.Subscribed(event: string; tag: TXMLTag);
begin
    // getting a s10n ack
end;

{---------------------------------------}
procedure TSubController.UnSubscribe(event: string; tag: TXMLTag);
begin
    // someone is removing us
end;

{---------------------------------------}
procedure TSubController.UnSubscribed(event: string; tag: TXMLTag);
var
    from: TJabberID;
    ritem: TJabberRosterItem;
begin
    // getting a s10n denial or someone is revoking us
    from := TJabberID.Create(tag.getAttribute('from'));
    ritem := MainSession.roster.Find(from.jid);
    if ((ritem <> nil) and (ritem.ask = 'subscribe')) then begin
        // we are got denied by this person
        MessageDlg(Format(sS10nDeny, [from.jid]), mtInformation, [mbOK], 0);
        ritem.remove();
    end;
    from.Free();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure SendSubscribe(sjid: string; Session: TJabberSession);
var
    p: TJabberPres;
    j: TJabberID;
begin
    p := TJabberPres.Create;
    j := TJabberID.Create(sjid);
    p.toJID := j;
    p.PresType := 'subscribe';
    Session.SendTag(p);
end;

{---------------------------------------}
procedure SendSubscribed(sjid: string; Session: TJabberSession);
var
    p: TJabberPres;
    j: TJabberID;
begin
    p := TJabberPres.Create;
    j := TJabberID.Create(sjid);
    p.toJID := j;
    p.PresType := 'subscribed';
    Session.SendTag(p);
end;

{---------------------------------------}
procedure SendUnSubscribe(sjid: string; Session: TJabberSession);
var
    p: TJabberPres;
    j: TJabberID;
begin
    p := TJabberPres.Create;
    j := TJabberID.Create(sjid);
    p.toJID := j;
    p.PresType := 'unsubscribe';
    Session.SendTag(p);
end;

{---------------------------------------}
procedure SendUnSubscribed(sjid: string; Session: TJabberSession);
var
    p: TJabberPres;
    j: TJabberID;
begin
    p := TJabberPres.Create;
    j := TJabberID.Create(sjid);
    p.toJID := j;
    p.PresType := 'unsubscribed';
    Session.SendTag(p);
end;

{---------------------------------------}


end.
