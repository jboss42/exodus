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
        _sub: longint;
        _subd: longint;
        _unsub: longint;
        _unsubd: longint;
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
    Dialogs,
    Presence,
    JabberID,
    Subscribe,
    Roster,
    Forms;

{---------------------------------------}
Constructor TSubController.Create;
begin
    inherited Create;

    _sub    := MainSession.RegisterCallback(Subscribe, '/packet/presence[@type="subscribe"]');
    _subd   := MainSession.RegisterCallback(Subscribed, '/packet/presence[@type="subscribed"]');
    _unsub  := MainSession.RegisterCallback(UnSubscribe, '/packet/presence[@type="unsubscribe"]');
    _unsubd := MainSession.RegisterCallback(UnSubscribed, '/packet/presence[@type="unsubscribed"]');
end;

{---------------------------------------}
Destructor TSubController.Destroy;
begin
    MainSession.UnRegisterCallback(_sub);
    MainSession.UnRegisterCallback(_subd);
    MainSession.UnRegisterCallback(_unsub);
    MainSession.UnRegisterCallback(_unsubd);

    inherited Destroy;
end;

{---------------------------------------}
procedure TSubController.Subscribe(event: string; tag: TXMLTag);
var
    enable_add: boolean;
    sjid: string;
    ri: TJabberRosterItem;
    fsub: TfrmSubscribe;
    tmp_jid: TJabberID;
begin
    // getting a s10n request
    sjid := tag.getAttribute('from');
    tmp_jid := TJabberID.Create(sjid);
    sjid := tmp_jid.jid;

    ri := MainSession.Roster.Find(sjid);
    enable_add := true;
    if (ri <> nil) then begin
        if ((ri.subscription = 'from') or (ri.subscription = 'both')) then
            exit;
        if ((ri.subscription = 'to')) then
            enable_add := false;
        end;

    fsub := TfrmSubscribe.Create(Application);
    with fsub do begin
        lblJID.Caption := sjid;
        chkSubscribe.Checked := enable_add;
        chkSubscribe.Enabled := enable_add;
        boxAdd.Enabled := enable_add;
        if (enable_add) then begin
            txtNickname.Text := tmp_jid.user;
            cboGroup.Items.Assign(MainSession.Roster.GrpList);
            if cboGroup.Items.Count > 0 then
                cboGroup.ItemIndex := 0;
            end;
        end;
    tmp_jid.Free;

    fsub.Show;
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
