unit GUIFactory;
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
    Forms, Classes, SysUtils;

type
    TGUIFactory = class
    private
        _js: TObject;
        _cb: integer;
    published
        procedure SessionCallback(event: string; tag: TXMLTag);
    public
        procedure SetSession(js: TObject);
    end;

implementation

uses
    ChatWin, Subscribe, Notify,
    Roster, JabberID, Session;

procedure TGUIFactory.setSession(js: TObject);
var
    s: TJabberSession;
begin
    _js := js;
    s := TJabberSession(js);
    _cb := s.RegisterCallback(SessionCallback, '/session')
end;

procedure TGUIFactory.SessionCallback(event: string; tag: TXMLTag);
var
    sjid: string;
    tmp_jid: TJabberID;
    tmp_b: boolean;
    chat: TfrmChat;
    sub: TfrmSubscribe;
    ri: TJabberRosterItem;
begin
    // check for various events to start GUIS
    
    if (event = '/session/gui/chat') then begin
        // New Chat Window
        tmp_jid := TJabberID.Create(tag.getAttribute('from'));
        chat := StartChat(tmp_jid.jid, tmp_jid.resource, false);
        chat.MsgCallback('xml', tag);
        tmp_jid.Free;
        end

    else if (event = '/session/gui/subscribe') then begin
        // Subscription window
        sjid := tag.getAttribute('from');
        tmp_jid := TJabberID.Create(sjid);
        sjid := tmp_jid.jid;

        ri := MainSession.Roster.Find(sjid);
        tmp_b := true;
        if (ri <> nil) then begin
            if ((ri.subscription = 'from') or (ri.subscription = 'both')) then
                exit;
            if ((ri.subscription = 'to')) then
                tmp_b := false;
            end;

        // block list?
        if (MainSession.IsBlocked(tmp_jid)) then exit;

        sub := TfrmSubscribe.Create(Application);
        with sub do begin
            lblJID.Caption := sjid;
            chkSubscribe.Checked := tmp_b;
            chkSubscribe.Enabled := tmp_b;
            boxAdd.Enabled := tmp_b;
            cboGroup.Items.Assign(MainSession.Roster.GrpList);
            if (tmp_b) then begin
                txtNickname.Text := tmp_jid.user;
                cboGroup.Items.Assign(MainSession.Roster.GrpList);
                if cboGroup.Items.Count > 0 then
                    cboGroup.ItemIndex := 0;
                end
            else if (ri <> nil) then begin
                txtNickName.Text := ri.nickname;
                if (ri.Groups.Count > 0) then
                    cboGroup.ItemIndex := cboGroup.Items.IndexOf(ri.Groups[0]);
                end;
            end;
        DoNotify(nil, 'notify_s10n',
                 'Subscription from '#10#13 + sjid, 16);
        tmp_jid.Free();
        sub.Show;

        end;


end;


end.
