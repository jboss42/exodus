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
    XMLTag, Unicode, 
    Forms, Classes, SysUtils;

type
    TGUIFactory = class
    private
        _js: TObject;
        _cb: integer;
        _blockers: TWidestringlist;
    published
        procedure SessionCallback(event: string; tag: TXMLTag);
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetSession(js: TObject);
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    Dialogs, GnuGetText, AutoUpdateStatus,
    InvalidRoster, ChatWin, ExEvents, ExUtils, Subscribe, Notify, Jabber1,
    MsgQueue, NodeItem, Roster, JabberID, Session;

const
    sPrefWriteError = 'There was an error attempting to save your options. Another process may be accessing your options file. Some options may be lost. ';
    sNotifyChat = 'Chat with ';

{---------------------------------------}
constructor TGUIFactory.Create();
begin
    _blockers := TWideStringList.Create();
end;

{---------------------------------------}
destructor TGUIFactory.Destroy();
begin
    _blockers.Free();
end;

{---------------------------------------}
procedure TGUIFactory.setSession(js: TObject);
var
    s: TJabberSession;
begin
    _js := js;
    s := TJabberSession(js);
    _cb := s.RegisterCallback(SessionCallback, '/session');
    _blockers.Clear();
    s.Prefs.fillStringlist('blockers', _blockers);
end;

{---------------------------------------}
procedure TGUIFactory.SessionCallback(event: string; tag: TXMLTag);
var
    i: integer;
    sjid: Widestring;
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
        DoNotify(chat, 'notify_newchat', _(sNotifyChat) +
                 chat.Othernick, ico_user)
    end

    else if (event = '/session/gui/headline') then begin
        e := CreateJabberEvent(tag);
        q := getMsgQueue();
        q.LogEvent(e, e.data_type, ico_headline);
        if (not q.visible) then q.ShowDefault();
    end

    else if (event = '/session/gui/msgevent') then begin
        // New Msg-Event style window
        e := CreateJabberEvent(tag);
        RenderEvent(e);
    end

    else if (event = '/session/gui/reg-not-supported') then begin
        MessageDlgW(_('Your authentication mechanism does not support registration.'),
            mtError, [mbOK], 0);
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

    else if (event = '/session/gui/prefs-write-error') then begin
        MessageDlgW(_(sPrefWriteError), mtError, [mbOK], 0);
    end

    else if (event = '/session/block') then begin
        _blockers.Add(tag.getAttribute('jid'));
    end

    else if (event = '/session/unblock') then begin
        i := _blockers.IndexOf(tag.getAttribute('jid'));
        if (i >= 0) then _blockers.Delete(i);
    end

    else if (event = '/session/gui/autoupdate') then begin
        ShowAutoUpdateStatus(tag.GetAttribute('url'));
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
        // Don't use MainSession.IsBlocked since it also
        // blocks people not on my roster. Just check our sync'd blocker list.
        if (_blockers.IndexOf(tmp_jid.jid) >= 0) then exit;

        sub := TfrmSubscribe.Create(Application);
        with sub do begin
            lblJID.Caption := sjid;
            chkSubscribe.Checked := tmp_b;
            chkSubscribe.Enabled := tmp_b;
            boxAdd.Enabled := tmp_b;
            MainSession.Roster.AssignGroups(cboGroup.Items);
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
