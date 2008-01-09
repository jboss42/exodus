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

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    InvalidRoster, ChatWin, ExEvents, ExUtils, Subscribe, Notify, Jabber1,
    MsgQueue, Roster, JabberID, Session;

{---------------------------------------}
procedure TGUIFactory.setSession(js: TObject);
var
    s: TJabberSession;
begin
    _js := js;
    s := TJabberSession(js);
    _cb := s.RegisterCallback(SessionCallback, '/session')
end;

{---------------------------------------}
procedure TGUIFactory.SessionCallback(event: string; tag: TXMLTag);
var
    sjid: string;
    tmp_jid: TJabberID;
    tmp_b: boolean;
    chat: TfrmChat;
    sub: TfrmSubscribe;
    ri: TJabberRosterItem;
    ir: TfrmInvalidRoster;
    e: TJabberEvent;
    q: TfrmMsgQueue;
begin
    // check for various events to start GUIS
    if (event = '/session/gui/chat') then begin
        // New Chat Window
        tmp_jid := TJabberID.Create(tag.getAttribute('from'));
        chat := StartChat(tmp_jid.jid, tmp_jid.resource, true);
        tmp_jid.Free;
        DoNotify(chat, 'notify_newchat', sNotifyChat +
                 chat.Othernick, ico_user)
    end

    else if (event = '/session/gui/headline') then begin
        e := CreateJabberEvent(tag);
        q := getMsgQueue();
        q.LogEvent(e, e.caption, ico_headline);
        if (not q.visible) then q.ShowDefault();
    end

    else if (event = '/session/gui/msgevent') then begin
        // New Msg-Event style window
        e := CreateJabberEvent(tag);
        RenderEvent(e);
    end

    else if (event = '/session/gui/pres-error') then begin
        // Presence errors
        ri := MainSession.Roster.Find(tag.GetAttribute('from'));
        if ((ri <> nil) and
        MainSession.Prefs.getBool('roster_pres_errors')) then begin
            ir := getInvalidRoster();
            ir.AddPacket(tag);
        end;
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
            removeSpecialGroups(cboGroup.Items);
            if (tmp_b) then begin
                txtNickname.Text := tmp_jid.user;
                cboGroup.Text := MainSession.Prefs.getString('roster_default');
            end
            else if (ri <> nil) then begin
                txtNickName.Text := ri.nickname;
                if (ri.Groups.Count > 0) then
                    cboGroup.ItemIndex := cboGroup.Items.IndexOf(ri.Groups[0]);
            end;
        end;
        DoNotify(nil, 'notify_s10n',
                 'Subscription from ' + sjid, ico_key);
        tmp_jid.Free();
        sub.Show;
    end;
end;


end.
