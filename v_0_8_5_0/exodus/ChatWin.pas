unit ChatWin;
{
    Copyright 2002, Peter Millard

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
    Chat, ChatController, JabberID, XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, BaseChat, ExtCtrls, StdCtrls, Menus, ComCtrls, ExRichEdit, RichEdit2,
    TntStdCtrls, Buttons;

type
  TfrmChat = class(TfrmBaseChat)
    popContact: TPopupMenu;
    mnuHistory: TMenuItem;
    mnuProfile: TMenuItem;
    mnuBlock: TMenuItem;
    mnuSendFile: TMenuItem;
    mnuSave: TMenuItem;
    N1: TMenuItem;
    mnuReturns: TMenuItem;
    timFlash: TTimer;
    SaveDialog1: TSaveDialog;
    C1: TMenuItem;
    mnuVersionRequest: TMenuItem;
    mnuTimeRequest: TMenuItem;
    mnuLastActivity: TMenuItem;
    mnuOnTop: TMenuItem;
    btnClose: TSpeedButton;
    pnlJID: TPanel;
    imgStatus: TPaintBox;
    popClearHistory: TMenuItem;
    lblNick: TTntLabel;
    mnuWordwrap: TMenuItem;
    NotificationOptions1: TMenuItem;
    timBusy: TTimer;
    popAddContact: TMenuItem;
    lblJID: TTntLabel;
    N3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MsgOutKeyPress(Sender: TObject; var Key: Char);
    procedure doHistory(Sender: TObject);
    procedure doProfile(Sender: TObject);
    procedure doAddToRoster(Sender: TObject);
    procedure lblJIDClick(Sender: TObject);
    procedure mnuReturnsClick(Sender: TObject);
    procedure mnuSendFileClick(Sender: TObject);
    procedure imgStatusPaint(Sender: TObject);
    procedure timFlashTimer(Sender: TObject);
    procedure MsgOutChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CTCPClick(Sender: TObject);
    procedure mnuBlockClick(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure mnuSaveClick(Sender: TObject);
    procedure mnuOnTopClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure popClearHistoryClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    // procedure timMemoryTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure mnuWordwrapClick(Sender: TObject);
    procedure btnCloseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NotificationOptions1Click(Sender: TObject);
    procedure timBusyTimer(Sender: TObject);
  private
    { Private declarations }
    jid: widestring;        // jid of the person we are talking to
    _jid: TJabberID;        // JID object of jid
    _pcallback: integer;    // Presence Callback
    _scallback: integer;    // Session callback
    _thread : string;       // thread for conversation
    _pres_img: integer;     // current index of the presence image
    _msg_out: boolean;

    // Stuff for composing events
    _flash_ticks: integer;
    _cur_img: integer;
    _old_img: integer;
    _old_hint: string;
    _last_id: string;
    _reply_id: string;
    _check_event: boolean;
    _send_composing: boolean;
    _warn_busyclose: boolean;

    _destroying: boolean;
    _redock: boolean;

    // custom notification options to use..
    _notify: array[0..3] of integer;

    procedure SetupPrefs();
    procedure ChangePresImage(show: widestring; status: widestring);
    procedure ResetPresImage;
    procedure freeChatObject();
    procedure _sendMsg(txt: Widestring);

    function GetThread: String;
  published
    procedure PresCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure CTCPCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
    OtherNick: widestring;
    chat_object: TChatController;

    procedure PlayQueue();
    procedure MessageEvent(tag: TXMLTag);
    procedure showMsg(tag: TXMLTag);
    procedure showPres(tag: TXMLTag);
    procedure sendMsg; override;
    procedure SetJID(cjid: widestring);
    procedure AcceptFiles( var msg : TWMDropFiles ); message WM_DROPFILES;
    procedure DockForm; override;
    procedure FloatForm; override;

    procedure pluginMenuClick(Sender: TObject); override;

    property getJid: Widestring read jid;
    property redock: boolean read _redock;
  end;

var
  frmChat: TfrmChat;

function StartChat(sjid, resource: widestring; show_window: boolean; chat_nick: widestring=''): TfrmChat;
procedure CloseAllChats;

resourcestring
    sReplying = ' is replying.';
    sChatActivity = 'Chat Activity: ';
    sUserBlocked = 'This user is now blocked.';
    sIsNow = 'is now';
    sAvailable = 'available';
    sOffline = 'offline';
    sCloseBusy = 'This chat window is busy. Close anyways?';

implementation

{$R *.dfm}

uses
    CustomNotify, COMChatController, Debug, ExEvents,
    JabberConst, ExSession, ExUtils, Presence, PrefController, Room,
    Transfer, RosterAdd, RiserWindow, Notify,
    Jabber1, Profile, MsgDisplay, IQ,
    JabberMsg, Roster, Session, Unicode, XMLUtils,
    ShellAPI, RosterWindow, Emoticons;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function StartChat(sjid, resource: widestring; show_window: boolean; chat_nick: widestring=''): TfrmChat;
var
    r, m: integer;
    chat: TChatController;
    win: TfrmChat;
    tmp_jid: TJabberID;
    cjid: widestring;
    ritem: TJabberRosterItem;
    new_chat: boolean;
    do_scroll: boolean;
    hist: string;
begin
    // either show an existing chat or start one.
    chat := MainSession.ChatList.FindChat(sjid, resource, '');
    new_chat := false;
    do_scroll := false;

    // If we have an existing chat, we may just want to raise it
    // or redock it, etc...
    r := MainSession.Prefs.getInt(P_CHAT);
    m := MainSession.Prefs.getInt('chat_memory');

    if (((r = msg_existing_chat) or (m > 0)) and (chat <> nil)) then begin
        win := TfrmChat(chat.window);
        if (win <> nil) then begin
            if ((win.Docked) or (win.Redock)) then begin
                if (not win.Visible) then
                    win.ShowDefault()
                else if (win.TabSheet <> nil) then
                    frmExodus.Tabs.ActivePage := win.TabSheet;
            end
            else
                win.ShowDefault();
            Result := win;
            exit;
        end;
    end;

    // Create a new chat controller if we don't have one
    if chat = nil then begin
        chat := MainSession.ChatList.AddChat(sjid, resource);
        new_chat := true;
    end;

    // Create a window if we don't have one.
    if (chat.window = nil) then begin
        win := TfrmChat.Create(Application);
        chat.Window := win;
        chat.stopTimer();
        win.chat_object := chat;
        hist := TrimRight(chat.getHistory());
        if (hist <> '') then with win.MsgList do begin
            // repopulate history..
            InputFormat := ifRTF;
            RTFSelText := hist;
            InputFormat := ifUnicode;

            // always remove the last line..
            Lines.Delete(Lines.Count - 1);
            do_scroll := true;
        end;
    end;

    // Setup the properties of the window,
    // and hook it up to the chat controller.
    with TfrmChat(chat.window) do begin
        tmp_jid := TJabberID.Create(sjid);
        if (chat_nick = '') then begin
            ritem := MainSession.roster.Find(sjid);
            if (ritem = nil) then begin
                // If not in our roster, check for a TC room
                if (IsRoom(sjid)) then
                    chat_nick := FindRoomNick(sjid + '/' + resource);

                if (chat_nick = '') then
                    OtherNick := tmp_jid.user
                else
                    OtherNick := chat_nick;
            end
            else
                OtherNick := ritem.Nickname;
        end
        else
            OtherNick := chat_nick;

        if resource <> '' then
            cjid := sjid + '/' + resource
        else
            cjid := sjid;
        tmp_jid.Free;
        SetJID(cjid);

        chat.OnMessage := MessageEvent;

        // handle setting position for this window
        if (not MainSession.Prefs.RestorePosition(TfrmChat(chat.window),
            MungeName(Caption))) then
            Position := poDefaultPosOnly;

        ShowDefault();
        if ((show_window) and (Application.Active)) then
            Show();

        PlayQueue();

        // scroll to the bottom..
        if (do_scroll) then
            _scrollBottom();
    end;

    if (new_chat) then
        ExCOMController.fireNewChat(sjid, TExodusChat(chat.ComController));



    Result := TfrmChat(chat.window);
end;

{---------------------------------------}
procedure CloseAllChats;
var
    i: integer;
    c: TChatController;
begin
    with MainSession.ChatList do begin
        for i := Count - 1 downto 0 do begin
            c := TChatController(Objects[i]);
            if c <> nil then begin
                if c.window <> nil then
                    TfrmChat(c.window).chat_object := nil;
                    TfrmChat(c.window).Free();
            end;
            c.Free;
            Delete(i);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmChat.FormCreate(Sender: TObject);
begin
    inherited;
    _thread := '';
    _pcallback := -1;
    _scallback := -1;
    OtherNick := '';
    _pres_img := ico_Unknown;
    _check_event := false;
    _last_id := '';
    _reply_id := '';
    _msg_out := false;
    _jid := nil;
    _destroying := false;
    _redock := false;

    {
        _notify[0]  := getInt('notify_online');
        _notify[1]  := getInt('notify_offline');
        _notify[2]  := getInt('notify_newchat');
        _notify[3]  := getInt('notify_normalmsg');
        _notify[4]  := getInt('notify_s10n');
        _notify[5]  := getInt('notify_invite');
        _notify[6]  := getInt('notify_keyword');
        _notify[7]  := getInt('notify_chatactivity');
        _notify[8]  := getInt('notify_roomactivity');
        _notify[9]  := getInt('notify_oob');
        _notify[10] := getInt('notify_autoresponse');
    }

    _notify[0] := MainSession.Prefs.getInt('notify_chatactivity');

    if (MainSession.Profile.ConnectionType = conn_normal) then
        DragAcceptFiles( Handle, True );

    SetupPrefs();

    mnuSendFile.Enabled := (MainSession.Profile.ConnectionType = conn_normal);

end;

{---------------------------------------}
procedure TfrmChat.SetupPrefs();
begin
    AssignDefaultFont(Self.Font);

    lblJID.Font.Color := clBlue;
    lblJID.Font.Style := [fsUnderline];

    // setup prefs
    MsgList.Color := TColor(MainSession.Prefs.getInt('color_bg'));
    MsgOut.Color := MsgList.Color;
    MsgOut.Font.Assign(MsgList.Font);

    _embed_returns := MainSession.Prefs.getBool('embed_returns');
    _wrap_input := MainSession.Prefs.getBool('wrap_input');
    _warn_busyclose := MainSession.Prefs.getBool('warn_closebusy');
    mnuReturns.Checked := _embed_returns;
    mnuWordwrap.Checked := _wrap_input;
    MsgOut.WantReturns := _embed_returns;
    MsgOut.WordWrap := _wrap_input;
end;


{---------------------------------------}
procedure TfrmChat.SetJID(cjid: widestring);
var
    ritem: TJabberRosterItem;
    p: TJabberPres;
    i: integer;
begin
    jid := cjid;
    if (_jid <> nil) then _jid.Free();

    _jid := TJabberID.Create(cjid);

    // setup the callbacks if we don't have them already
    if (_pcallback = -1) then
        _pcallback := MainSession.RegisterCallback(PresCallback,
            '/packet/presence[@from="' + Lowercase(cjid) + '*"]');

    if (_scallback = -1) then
        _scallback := MainSession.RegisterCallback(SessionCallback, '/session');


    // setup the captions, etc..
    ritem := MainSession.Roster.Find(_jid.jid);
    p := MainSession.ppdb.FindPres(_jid.jid, _jid.resource);

    if ritem <> nil then begin
        lblNick.Caption := ' ' + ritem.Nickname + ' ';
        Caption := ritem.Nickname + ' - ' + sChat;
        lblJID.Caption := '<' + _jid.full + '>';
        if (p = nil) then
            ChangePresImage('offline', 'offline')
        else
            ChangePresImage(p.show, p.status);
    end

    else begin
        lblNick.Caption := ' ';
        lblJID.Caption := cjid;
        if OtherNick <> '' then
            Caption := OtherNick + ' - ' + sChat
        else
            Caption := _jid.user + ' - ' + sChat;
        if (p = nil) then
            ChangePresImage('unknown', 'Unknown Presence')
        else
            ChangePresImage(p.show, p.status);
    end;

    // synchronize the session chat list with this JID
    i := MainSession.ChatList.indexOfObject(chat_object);
    if (i >= 0) then
        MainSession.ChatList[i] := cjid;
end;

{---------------------------------------}
function TfrmChat.GetThread: String;
Var
    seed: string;
begin
    if _thread <> '' then exit;

    seed := FormatDateTime('MMDDYYYYHHMM',now);
    seed := seed + jid + MainSession.Username + MainSession.Server;

    // hash the seed to get the thread
    _thread := Sha1Hash(seed);
    Result := _thread;
end;

{---------------------------------------}
procedure TfrmChat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
    inherited;
end;

{---------------------------------------}
procedure TfrmChat.PlayQueue();
var
    t: TXMLTag;
begin
    // pull all of the msgs from the controller queue,
    // and feed them into this window
    if (chat_object = nil) then exit;

    while (chat_object.msg_queue.AtLeast(1)) do begin
        t := TXMLTag(chat_object.msg_queue.Pop());
        Self.MessageEvent(t);
    end;
end;

{---------------------------------------}
procedure TfrmChat.MessageEvent(tag: TXMLTag);
var
    xml, body: Widestring;
    msg_type, from_jid: WideString;
    etag, tagThread : TXMLTag;
begin
    // callback for messages
    // check for a jabber:x:event tag
    msg_type := tag.GetAttribute('type');
    from_jid := tag.getAttribute('from');

    if from_jid <> jid then begin
        chat_object.SetJID(from_jid);
        SetJID(from_jid);
    end;

    if (_check_event) then begin
        // check for composing events
        etag := tag.QueryXPTag(XP_MSGXEVENT);
        if ((etag <> nil) and (etag.GetFirstTag('composing') <> nil))then begin
            // we got a composing a message
            if (etag.GetBasicText('id') = _last_id) then begin
                _flash_ticks := 0;

                // Setup the cache'd old versions in ChangePresImage
                _cur_img := _pres_img;
                imgStatus.Hint := OtherNick + sReplying;
                timFlashTimer(Self);
                timFlash.Enabled := true;

                {
                should we really bail here??
                Gabber sends type=chat for msg events so it'll get into the
                next block of code anyways. If we don't bail,
                then we'll have to check to see if we have a body in the
                next block of code. ICK
                }

                exit;
            end
            else if ((etag.GetFirstTag('id') <> nil) and
                (timFlash.Enabled)) then begin
                Self.ResetPresImage();
            end;
        end;
    end;

    // process the msg
    etag := tag.QueryXPTag(XP_MSGCOMPOSING);
    _send_composing := (etag <> nil);
    if (_send_composing) then
        _reply_id := tag.GetAttribute('id');

    // plugin
    xml := tag.xml();
    body := tag.GetBasicText('body');
    TExodusChat(chat_object.ComController).fireRecvMsg(body, xml);

    // make sure we are visible..
    if (not visible) then begin
        ShowDefault();
    end;

    showMsg(tag);
    if _thread = '' then begin
        // cache thread from message
        tagThread := tag.GetFirstTag('thread');
        if tagThread <> nil then
            _thread := tagThread.Data;
   end;
end;

{---------------------------------------}
procedure TfrmChat.showMsg(tag: TXMLTag);
var
    m, etag: TXMLTag;
    subj_msg, msg: TJabberMessage;
begin
    // display the body of the msg
    if (timFlash.Enabled) then
        Self.ResetPresImage();
        
    if (_warn_busyclose) then begin
        timBusy.Enabled := false;
        timBusy.Enabled := true;
    end;
    
    _check_event := false;

    Msg := TJabberMessage.Create(tag);
    Msg.Nick := OtherNick;
    Msg.IsMe := false;

    // only display + notify if we have something to display :)
    if (Msg.Subject <> '') then begin
        subj_msg := TJabberMessage.Create(tag);
        subj_msg.Body := 'The subject has been changed to: ' + subj_msg.Subject;
        subj_msg.Subject := '';
        subj_msg.Nick := '';
        DisplayMsg(subj_msg, MsgList);
        subj_msg.Free();
    end;

    if (Msg.Body <> '') then begin
        DoNotify(Self, _notify[0], sChatActivity + OtherNick, ico_user, 'notify_chatactivity');
        DisplayMsg(Msg, MsgList);

        // log if we want..
        if (MainSession.Prefs.getBool('log')) then
            LogMessage(Msg);

        // check for displayed events
        etag := tag.QueryXPTag(XP_MSGXEVENT);
        if ((etag <> nil) and (etag.GetFirstTag('id') = nil)) then begin
            if (etag.GetFirstTag('displayed') <> nil) then begin
                // send back a displayed event
                m := generateEventMsg(tag, 'displayed');
                MainSession.SendTag(m);
            end;
        end;
    end;

    Msg.Free();
end;

procedure TfrmChat._sendMsg(txt: Widestring);
var
    xml: WideString;
    msg: TJabberMessage;
    mtag: TXMLTag;
begin
    // plugin madness
    if (chat_object <> nil) then
        TExodusChat(chat_object.ComController).fireBeforeMsg(txt);

    if (txt = '') then exit;

    if _thread = '' then begin   //get thread from message
        _thread := GetThread;
    end;

    // send the msg
    msg := TJabberMessage.Create(jid, 'chat', Trim(txt), '');
    msg.thread := _thread;
    msg.nick := MainSession.Username;
    msg.isMe := true;

    _last_id := MainSession.generateID();
    _check_event := true;
    msg.id := _last_id;

    mtag := msg.Tag;
    with mtag.AddTag('x') do begin
        setAttribute('xmlns', XMLNS_XEVENT);
        AddTag('composing');
    end;

    // additional plugin madness
    if (chat_object <> nil) then
        xml := TExodusChat(chat_object.ComController).fireAfterMsg(txt);
    if (xml <> '') then
        mtag.addInsertedXML(xml);
    MainSession.SendTag(mtag);
    DisplayMsg(Msg, MsgList);

    // log the msg
    if (MainSession.Prefs.getBool('log')) then
        LogMessage(Msg);

    Msg.Free();
end;

{---------------------------------------}
procedure TfrmChat.SendMsg;
var
    txt: Widestring;
begin
    // Send the actual message out
    txt := getInputText(MsgOut);
    _sendMsg(txt);

    inherited;
end;

{---------------------------------------}
procedure TfrmChat.MsgOutKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #0) then exit;
    if (chat_object = nil) then exit;

    // dispatch key-presses to Plugins
    TExodusChat(chat_object.ComController).fireMsgKeyPress(Key);

    inherited;
end;

{---------------------------------------}
procedure TfrmChat.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/disconnected') then begin
        DisplayPresence(sDisconnected, MsgList);
        MainSession.UnRegisterCallback(_pcallback);
        _pcallback := -1;

        // this should make sure that hidden windows
        // just go away when we get disconnected.
        if (not Visible) then
            Self.Free();
    end
    else if (event = '/session/connected') then begin
        Self.SetJID(jid);
    end
    else if (event = '/session/prefs') then
        SetupPrefs()
    else if (event = '/session/block') then begin
        // if this jid just got blocked, just close the window.
        if (_jid.jid = tag.GetAttribute('jid')) then begin
            DisplayPresence(sUserBlocked, Self.MsgList);
            MainSession.UnRegisterCallback(_pcallback);
            _pcallback := -1;
            freeChatObject();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmChat.PresCallback(event: string; tag: TXMLTag);
begin
    // display some presence packet
    if Event = 'xml' then
        showPres(tag);
end;

{---------------------------------------}
procedure TfrmChat.ChangePresImage(show: WideString; status: WideString);
begin
    // Change the bulb
    if (show = 'offline') then
        _pres_img := ico_Offline
    else if (show = 'unknown') then
        _pres_img := ico_Unknown
    else if (show = 'away') then
        _pres_img := ico_Away
    else if (show = 'xa') then
        _pres_img := ico_XA
    else if (show = 'dnd') then
        _pres_img := ico_DND
    else if (show = 'chat') then
        _pres_img := ico_Chat
    else
        _pres_img := ico_Online;

    if (status = '') then
        imgStatus.Hint := show
    else
        imgStatus.Hint := status;

    _old_img := _pres_img;
    _old_hint := imgStatus.Hint;

    Self.imgStatusPaint(Self);
end;

{---------------------------------------}
procedure TfrmChat.showPres(tag: TXMLTag);
var
    txt: WideString;
    status, show, User  : String;
    p: TJabberPres;
    j: TJabberID;
begin
    // Get the user
    user := tag.GetAttribute('from');

    //check to see if this is the person you are chatting with...
    if pos(jid, user) = 0 then Exit;

    // make sure the user is still connected
    j := TJabberID.Create(jid);
    p := MainSession.ppdb.FindPres(j.jid, j.resource);
    j.Free();
    if (p = nil) then begin
        show := sOffline;
        status := sOffline;
    end
    else begin
        show := tag.GetBasicText('show');
        status := tag.GetBasicText('status');
    end;

    ChangePresImage(show, status);
    if (status = '') then
        txt := show
    else
        txt := status;

    if (txt = '') then
        txt := sAvailable;

    if (MainSession.Prefs.getBool('timestamp')) then
        txt := '[' + formatdatetime(MainSession.Prefs.getString('timestamp_format'),now) + '] ' +
                jid + ' ' + sIsNow + ' ' + txt
    else
        txt :=  jid + ' ' + sIsNow + ' ' + txt;

    DisplayPresence(txt, MsgList);
end;

{---------------------------------------}
procedure TfrmChat.doHistory(Sender: TObject);
begin
  inherited;
    ShowLog(_jid.jid);
end;

{---------------------------------------}
procedure TfrmChat.doProfile(Sender: TObject);
begin
  inherited;
    ShowProfile(_jid.jid);
end;

{---------------------------------------}
procedure TfrmChat.doAddToRoster(Sender: TObject);
var
    ritem: TJabberRosterItem;
    add: TfrmAdd;
begin
  inherited;
    // check to see if we're already subscribed...
    ritem := MainSession.roster.find(_jid.jid);
    if ((ritem <> nil) and ((ritem.subscription = 'both') or (ritem.subscription = 'to'))) then begin
        MessageDlg(sAlreadySubscribed, mtInformation,
            [mbOK], 0);
        exit;
    end
    else begin
        add := ShowAddContact();
        add.txtJID.Text := _jid.jid;
        add.txtNickname.Text := _jid.user;
    end;

end;

{---------------------------------------}
procedure TfrmChat.lblJIDClick(Sender: TObject);
var
    cp: TPoint;
begin
  inherited;
    GetCursorPos(cp);
    popContact.popup(cp.x, cp.y);
end;

{---------------------------------------}
procedure TfrmChat.mnuReturnsClick(Sender: TObject);
begin
  inherited;
    mnuReturns.Checked := not mnuReturns.Checked;
    MsgOut.WantReturns := mnuReturns.Checked;
    _embed_returns := mnuReturns.Checked;
    MainSession.Prefs.setBool('embed_returns', _embed_returns);
end;

{---------------------------------------}
procedure TfrmChat.mnuWordwrapClick(Sender: TObject);
begin
    inherited;
    mnuWordwrap.Checked := not mnuWordWrap.Checked;
    _wrap_input := mnuWordwrap.Checked;
    MsgOut.WordWrap := _wrap_input;
    MainSession.Prefs.setBool('wrap_input', _wrap_input);
end;

{---------------------------------------}
procedure TfrmChat.mnuSendFileClick(Sender: TObject);
begin
  inherited;
    FileSend(_jid.full);
end;

{---------------------------------------}
procedure TfrmChat.imgStatusPaint(Sender: TObject);
begin
  inherited;
    // repaint
    frmExodus.ImageList2.Draw(imgStatus.Canvas, 1, 1, _pres_img);
end;

{---------------------------------------}
procedure TfrmChat.ResetPresImage;
begin
    // turn off flashing of the presence icon
    timFlash.Enabled := false;
    _pres_img := _old_img;
    imgStatus.Hint := _old_hint;
    imgStatus.Repaint();
    imgStatus.Refresh();
end;

{---------------------------------------}
procedure TfrmChat.timFlashTimer(Sender: TObject);
begin
  inherited;
    // Flash the presence image for 30 seconds..
    inc(_flash_ticks);
    if (_cur_img = _old_img) then begin
        _cur_img := _old_img + 33;
        if (_cur_img > 38) then _cur_img := 38;
    end
    else
        _cur_img := _old_img;

    _pres_img := _cur_img;
    imgStatus.Refresh();
    imgStatus.Repaint();

    if (_flash_ticks >= 60) then
        resetPresImage();
end;

{---------------------------------------}
procedure TfrmChat.MsgOutChange(Sender: TObject);
var
    c: TXMLTag;
begin
  inherited;
    if (_send_composing) then begin
        _send_composing := false;
        c := TXMLTag.Create('message');
        with c do begin
            setAttribute('to', jid);
            with AddTag('x') do begin
                setAttribute('xmlns', XMLNS_XEVENT);
                AddTag('composing');
                AddBasicTag('id', _reply_id);
            end;
        end;
        MainSession.SendTag(c);
    end;
end;

{---------------------------------------}
procedure TfrmChat.AcceptFiles( var msg : TWMDropFiles );
const
    cnMaxFileNameLen = 255;
var
    i,
    nCount     : integer;
    acFileName : array [0..cnMaxFileNameLen] of char;
begin
    // find out how many files we're accepting
    nCount := DragQueryFile( msg.Drop, $FFFFFFFF, acFileName, cnMaxFileNameLen );

    // query Windows one at a time for the file name
    for i := 0 to nCount-1 do begin
        DragQueryFile( msg.Drop, i, acFileName, cnMaxFileNameLen );
        // do your thing with the acFileName
        FileSend(_jid.full, acFileName);
    end;

    // let Windows know that you're done
    DragFinish( msg.Drop );
end;

{---------------------------------------}
procedure TfrmChat.freeChatObject();
var
    idx: integer;
begin
    if (chat_object = nil) then exit;
    idx := MainSession.ChatList.IndexOfObject(chat_object);
    if (idx >= 0) then
        MainSession.ChatList.Delete(idx);
    FreeAndNil(chat_object);
end;

{---------------------------------------}
procedure TfrmChat.FormDestroy(Sender: TObject);
begin
    // Unregister the callbacks + stuff
    if (MainSession <> nil) then begin
        MainSession.UnRegisterCallback(_pcallback);
        MainSession.UnRegisterCallback(_scallback);
    end;

    if (chat_object <> nil) then
        freeChatObject();

    if (_jid <> nil) then
        FreeAndNil(_jid);

    DragAcceptFiles(Handle, false);

    inherited;
end;

{---------------------------------------}
procedure TfrmChat.CTCPClick(Sender: TObject);
var
    jid: WideString;
    p: TJabberPres;
begin
    // get some CTCP query sent out
    p := MainSession.ppdb.FindPres(_jid.jid, '');
    if p = nil then
        // this person isn't online.
        jid := _jid.jid
    else
        jid := p.fromJID.full;

    if Sender = mnuVersionRequest then
        jabberSendCTCP(jid, XMLNS_VERSION, CTCPCallback)
    else if Sender = mnuTimeRequest then
        jabberSendCTCP(jid, XMLNS_TIME, CTCPCallback)
    else if Sender = mnuLastActivity then
        jabberSendCTCP(jid, XMLNS_LAST, CTCPCallback);
end;

{---------------------------------------}
procedure TfrmChat.CTCPCallback(event: string; tag: TXMLTag);
var
    from: WideString;
    s: WideString;
    ns: WideString;
    qtag: TXMLTag;
    tmp_tag: TXMLTag;
    msg: WideString;
    procedure DispString(str: WideString);
    var
        subj_msg: TJabberMessage;
    begin
        subj_msg := TJabberMessage.Create();
        subj_msg.Body := str;
        subj_msg.Subject := '';
        subj_msg.Nick := '';
        DisplayMsg(subj_msg, MsgList);
        subj_msg.Free();
    end;
begin
    // record some kind of CTCP result
    if ((tag <> nil) and (tag.getAttribute('type') = 'result')) then begin
        from := tag.getAttribute('from');

        ns := tag.Namespace(true);
        if ns = XMLNS_TIME then begin
            qTag := tag.getFirstTag('query');
            msg := sMsgTime;

            tmp_tag := qtag.getFirstTag('display');
            if (tmp_tag <> nil) then
                msg := msg + #13 + sMsgLocalTime + tmp_tag.Data;
            s := tag.GetAttribute('iq_elapsed_time');
            if (s <> '') then
                msg := msg + #13 + Format(sMsgPing, [s]);
            DispString(msg);
        end

        else if ns = XMLNS_VERSION then begin
            qTag := tag.getFirstTag('query');
            tmp_tag := qtag.getFirstTag('name');
            msg := sMsgVersion + #13 + sMsgVerClient + tmp_tag.Data + #13;

            tmp_tag := qtag.getFirstTag('version');
            msg := msg + sMsgVerVersion + tmp_tag.Data + #13;

            tmp_tag := qtag.getFirstTag('os');
            DispString(msg + sMsgVerOS + tmp_tag.Data);
        end

        else if ns = XMLNS_LAST then begin
            qTag := tag.getFirstTag('query');
            DispString(sMsgLastInfo + secsToDuration(qTag.getAttribute('seconds')) + '.');
        end;

    end;
end;

{---------------------------------------}
procedure TfrmChat.mnuBlockClick(Sender: TObject);
begin
    MainSession.Block(_jid);
    freeChatObject();
end;

{---------------------------------------}
procedure TfrmChat.DockForm;
begin
    inherited;
    btnClose.Visible := true;
    DragAcceptFiles( Handle, False );
end;

{---------------------------------------}
procedure TfrmChat.FloatForm;
begin
    inherited;
    btnClose.Visible := false;
    DragAcceptFiles( Handle, True );
end;

{---------------------------------------}
procedure TfrmChat.FormEndDock(Sender, Target: TObject; X, Y: Integer);
begin
    inherited;
    btnClose.Visible := Docked;
    if ((Docked) and (TabSheet <> nil)) then Self.TabSheet.ImageIndex := -1;
    DragAcceptFiles(Handle, not Docked);

    // scroll the MsgView to the bottom.
    _scrollBottom();
    Self.Refresh();
end;

{---------------------------------------}
procedure TfrmChat.mnuSaveClick(Sender: TObject);
begin
  inherited;
    // save the conversation as RTF
    if SaveDialog1.Execute then begin
        MsgList.PlainRTF := false;
        MsgList.WideLines.SaveToFile(SaveDialog1.Filename);
    end;
end;

{---------------------------------------}
procedure TfrmChat.mnuOnTopClick(Sender: TObject);
begin
  inherited;
    mnuOnTop.Checked := not mnuOnTop.Checked;

    if (mnuOnTop.Checked) then
        Self.FormStyle := fsStayOnTop
    else
        Self.FormStyle := fsNormal;
end;

{---------------------------------------}
procedure TfrmChat.FormResize(Sender: TObject);
begin
  inherited;
    // make the close btn be right justified..
    btnClose.Left := Panel1.Width - btnClose.Width - 2;
    pnlJID.Width := Panel1.Width - btnClose.Width - 5;
end;

{---------------------------------------}
procedure TfrmChat.btnCloseClick(Sender: TObject);
begin
    Self.Close();
end;

{---------------------------------------}
procedure TfrmChat.popClearHistoryClick(Sender: TObject);
begin
    inherited;
    ClearLog(Self._jid.jid)
end;

{---------------------------------------}
procedure TfrmChat.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
    s: String;
begin
    if ((_warn_busyclose) and
        ((timBusy.Enabled) or (timFlash.Enabled))) then begin
        if MessageDlg(sCloseBusy, mtConfirmation, [mbYes, mbNo], 0) = mrNo then begin
            CanClose := false;
            exit;
        end;
    end;

    if ((MainSession.Prefs.getInt('chat_memory') > 0) and
        (MsgList.Lines.Count > 0) and
        (chat_object <> nil) and
        (not _destroying)) then begin
        MsgList.Visible := false;
        MsgList.SelectAll();
        s := MsgList.RTFSelText;
        chat_object.SetHistory(s);
        chat_object.unassignEvent();
        chat_object.startTimer();
        chat_object.window := nil;
        chat_object := nil;
    end;

    inherited;
end;

{---------------------------------------}
procedure TfrmChat.FormShow(Sender: TObject);
begin
  inherited;
end;

{---------------------------------------}
procedure TfrmChat.FormActivate(Sender: TObject);
begin
  inherited;
    if (_redock) then _redock := false;
end;

{---------------------------------------}
procedure TfrmChat.btnCloseMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    _destroying := (ssCtrl in Shift);
end;

{---------------------------------------}
procedure TfrmChat.NotificationOptions1Click(Sender: TObject);
var
    f: TfrmCustomNotify;
begin
    // change notification options..
    f := TfrmCustomNotify.Create(Application);

    f.addItem('Chat activity');
    f.setVal(0, _notify[0]);
    if (f.ShowModal) = mrOK then begin
        _notify[0] := f.getVal(0);
    end;

    f.Free();
end;

{---------------------------------------}
procedure TfrmChat.timBusyTimer(Sender: TObject);
begin
  inherited;
    timBusy.Enabled := false;
end;

{---------------------------------------}
procedure TfrmChat.pluginMenuClick(Sender: TObject);
begin
    if (chat_object <> nil) then
        TExodusChat(chat_object.ComController).fireMenuClick(Sender);
end;


end.
