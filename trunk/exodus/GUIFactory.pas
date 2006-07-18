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
    RosterImages, PrefController, MsgRecv, Room, Bookmark,  
    Dialogs, GnuGetText, AutoUpdateStatus, Controls,
    InvalidRoster, ChatWin, ExEvents, JabberUtils, ExUtils,  Subscribe, Notify, Jabber1,
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
    r, i: integer;
    sjid: Widestring;
    tmp_jid: TJabberID;
    win, chat: TfrmChat;
    room: TfrmRoom;
    sub: TfrmSubscribe;
    ri: TJabberRosterItem;
    ir: TfrmInvalidRoster;
    e: TJabberEvent;
    q: TfrmMsgQueue;
begin
    // check for various events to start GUIS
    if (event = '/session/gui/conference-props') then begin
        ShowBookmark(tag.GetAttribute('jid'), tag.GetAttribute('name'));
    end
    else if (event = '/session/gui/conference') then begin
        room := StartRoom(tag.GetAttribute('jid'), tag.GetBasicText('nick'),
            tag.GetBasicText('password'));

        // make sure it's not minimized
        if (room.WindowState <> wsNormal) then
            room.WindowState := wsNormal;

        // make sure it's visible
        room.Show();

        // make sure its in front
        if (not room.Docked) then
            room.BringToFront();
    end
    else if (event = '/session/gui/contact') then begin
        // new outgoing message/chat window
        tmp_jid := TJabberID.Create(tag.getAttribute('jid'));

        r := MainSession.Prefs.getInt(P_CHAT);

        if ((r = 0) or (r = 2)) then begin
            if (tmp_jid.resource <> '') then
                win := StartChat(tmp_jid.jid, tmp_jid.resource, true)
            else
                win := StartChat(tmp_jid.jid, '', true);

            if (win <> nil) then begin
                // make sure it's not minimized
                if (win.WindowState <> wsNormal) then
                    win.WindowState := wsNormal;

                // make sure it's visible
                win.Show();

                // make sure it's in front
                if (not win.Docked) then
                    win.BringToFront();

                if ((MainSession.Prefs.getBool('expanded')) and
                    (win.TabSheet <> nil) and
                    (frmExodus.Tabs.ActivePage <> win.TabSheet)) then begin
                    frmExodus.BringDockedToFront(win);
                end;
                // make sure to put the cursor in the outbound text entry box
                win.MsgOut.SetFocus();
            end;
        end
        else if (r = 1) then
            StartMsg(tmp_jid.jid);

        tmp_jid.Free();

    end
    else if (event = '/session/gui/chat') then begin
        // if we are DND, or this is an offline msg, then possibly queue it,
        // depending on prefs.
        if (((MainSession.Prefs.getBool('queue_dnd_chats')) and
             (MainSession.Show = 'dnd')) or
            ((MainSession.Prefs.getBool('queue_offline')) and
             (tag.QueryXPTag('/message/x[@xmlns="jabber:x:delay"]') <> nil))) then begin
            // queue the chat window
            e := CreateJabberEvent(tag);
            RenderEvent(e);
        end
        else begin
            // New Chat Window
            tmp_jid := TJabberID.Create(tag.getAttribute('from'));
            chat := StartChat(tmp_jid.jid, tmp_jid.resource, true);
            if (chat <> nil) then
                DoNotify(chat, 'notify_newchat', _(sNotifyChat) +
                     chat.Othernick, RosterTreeImages.Find('contact'));
            tmp_jid.Free;
        end;
    end

    else if (event = '/session/gui/headline') then begin
        e := CreateJabberEvent(tag);
        q := getMsgQueue();
        q.LogEvent(e, e.str_content, RosterTreeImages.Find('headline'));
        if (not q.visible) then q.ShowDefault();
    end

    else if (event = '/session/gui/msgevent') then begin
        // New Msg-Event style window
        e := CreateJabberEvent(tag);
        RenderEvent(e);
    end

    else if (event = '/session/gui/no-inband-reg') then begin
        if (MessageDlgW(_('This server does not advertise support for in-band registration. Try to register a new account anyway?'),
            mtError, [mbYes, mbNo], 0) = mrYes) then
            MainSession.CreateAccount()
        else
            MainSession.FireEvent('/session/error/reg', nil);
    end

    else if (event = '/session/gui/reg-not-supported') then begin
        MessageDlgW(_('Your authentication mechanism does not support registration.'),
            mtError, [mbOK], 0);
    end

    else if (event = '/session/error/presence') then begin
        // Presence errors
        ri := MainSession.Roster.Find(tag.GetAttribute('from'));
        if ((ri <> nil) and
        MainSession.Prefs.getBool('roster_pres_errors')) then begin
            ir := getInvalidRoster();
            ir.AddPacket(tag);
        end;
    end

    else if (event = '/session/error/prefs-write') then begin
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
        sjid := tmp_jid.getDisplayJID();

        ri := MainSession.Roster.Find(sjid);

        if (ri <> nil) then begin
            if ((ri.subscription = 'from') or (ri.subscription = 'both')) then
                exit;
        end;

        // block list?
        // Don't use MainSession.IsBlocked since it also
        // blocks people not on my roster. Just check our sync'd blocker list.
        if (_blockers.IndexOf(tmp_jid.jid) >= 0) then exit;

        sub := TfrmSubscribe.Create(Application);
        sub.setup(tmp_jid, ri, tag);
        DoNotify(nil, 'notify_s10n',
                 'Subscription from ' + sjid, RosterTreeImages.Find('key'));
        tmp_jid.Free();
        sub.Show;
    end;
end;


end.
