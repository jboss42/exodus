unit s10n;
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
    inherited Create;

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
begin
    // getting a s10n request
    j := TJabberID.Create(tag.GetAttribute('from'));
    if (_transports.IndexOf(j.jid) >= 0) then
        SendSubscribed(j.full, MainSession)
    else
        MainSession.FireEvent('/session/gui/subscribe', tag);
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
    msg: string;
    from: TJabberID;
    ritem: TJabberRosterItem;
begin
    // getting a s10n denial or someone is revoking us
    from := TJabberID.Create(tag.getAttribute('from'));
    ritem := MainSession.roster.Find(from.jid);
    if ((ritem <> nil) and (ritem.ask = 'subscribe')) then begin
        // we are got denied by this person
        msg := 'The contact: ' + from.jid + ' did not grant your subscription request.';
        msg := msg + #13#10 + 'This user may not exist.';
        MessageDlg(msg, mtInformation, [mbOK], 0);
        ritem.remove();
        end;
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
