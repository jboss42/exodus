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
    mnuEncrypt: TMenuItem;
    timFlash: TTimer;
    SaveDialog1: TSaveDialog;
    C1: TMenuItem;
    mnuVersionRequest: TMenuItem;
    mnuTimeRequest: TMenuItem;
    mnuLastActivity: TMenuItem;
    mnuOnTop: TMenuItem;
    btnClose: TSpeedButton;
    pnlJID: TPanel;
    lblJID: TStaticText;
    lblNick: TStaticText;
    imgStatus: TPaintBox;
    popClearHistory: TMenuItem;
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
  private
    { Private declarations }
    jid: string;            // jid of the person we are talking to
    _jid: TJabberID;        // JID object of jid
    _pcallback: integer;    // Presence Callback
    _scallback: integer;    // Session callback
    _thread : string;       // thread for conversation
    _pres_img: integer;     // current index of the presence image

    // Stuff for composing events
    _flash_ticks: integer;
    _cur_img: integer;
    _old_img: integer;
    _old_hint: string;
    _last_id: string;
    _reply_id: string;
    _check_event: boolean;
    _send_composing: boolean;

    procedure ChangePresImage(show: string; status: string);
    procedure ResetPresImage;

    function GetThread: String;
  published
    procedure PresCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure CTCPCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
    OtherNick: string;
    chat_object: TChatController;

    procedure PlayQueue();
    procedure MessageEvent(tag: TXMLTag);
    procedure showMsg(tag: TXMLTag);
    procedure showPres(tag: TXMLTag);
    procedure sendMsg; override;
    procedure SetJID(cjid: string);
    procedure AcceptFiles( var msg : TWMDropFiles ); message WM_DROPFILES;
    procedure DockForm; override;
    procedure FloatForm; override;
  end;

var
  frmChat: TfrmChat;

function StartChat(sjid, resource: string; show_window: boolean; chat_nick: string=''): TfrmChat;
procedure CloseAllChats;

resourcestring
    sReplying = ' is replying.';
    sChatActivity = 'Chat Activity: ';
    sUserBlocked = 'This user is now blocked.';
    sIsNow = 'is now';
    sAvailable = 'available';
    sOffline = 'offline';


implementation

{$R *.dfm}

uses
    ExUtils, Presence, PrefController, Room,
    Transfer, RosterAdd, RiserWindow, Notify,
    Jabber1, Profile, MsgDisplay, IQ,
    JabberMsg, Roster, Session, XMLUtils,
    ShellAPI, RosterWindow, Emoticons;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function StartChat(sjid, resource: string; show_window: boolean; chat_nick: string=''): TfrmChat;
var
    chat: TChatController;
    win: TfrmChat;
    tmp_jid: TJabberID;
    cjid: string;
    ritem: TJabberRosterItem;
begin
    // either show an existing chat or start one.
    chat := MainSession.ChatList.FindChat(sjid, resource, '');

    if chat = nil then
        // Create one
        chat := MainSession.ChatList.AddChat(sjid, resource);

    if (chat.window = nil) then begin
        // if we don't have a window, then create one.
        win := TfrmChat.Create(Application);
        chat.window := win;
        win.chat_object := chat;
        end;

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

        ShowDefault();
        if (show_window) then
            Show();

        PlayQueue();
        end;

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
                    TfrmChat(c.window).Close();
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
    _pres_img := -1;
    _check_event := false;
    _last_id := '';
    _reply_id := '';

    if (MainSession.Profile.ConnectionType = conn_normal) then
        DragAcceptFiles( Handle, True );

    // setup prefs
    AssignDefaultFont(MsgList.Font);
    MsgList.Color := TColor(MainSession.Prefs.getInt('color_bg'));
    MsgOut.Color := MsgList.Color;
    MsgOut.Font.Assign(MsgList.Font);

    mnuSendFile.Enabled := (MainSession.Profile.ConnectionType = conn_normal);
end;

{---------------------------------------}
procedure TfrmChat.SetJID(cjid: string);
var
    ritem: TJabberRosterItem;
    p: TJabberPres;
    i: integer;
begin
    jid := cjid;
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
        lblNick.Caption := ' ' + ritem.Nickname;
        Caption := ritem.Nickname + ' - ' + sChat;
        lblJID.Caption := '<' + _jid.full + '>';
        end
    else begin
        lblNick.Caption := ' ';
        lblJID.Caption := cjid;
        if OtherNick <> '' then
            Caption := OtherNick + ' - ' + sChat
        else
            Caption := _jid.user + ' - ' + sChat;
        end;

    if (p = nil) then
        ChangePresImage('offline', 'offline')
    else
        ChangePresImage(p.show, p.status);

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
var
    i: integer;
begin
    // Unregister the callbacks + stuff
    MainSession.UnRegisterCallback(_pcallback);
    MainSession.UnRegisterCallback(_scallback);

    if chat_object <> nil then begin
        i := MainSession.ChatList.IndexOfObject(chat_object);
        if i >= 0 then
            MainSession.ChatList.Delete(i);
        chat_object.Free;
        end;

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
    while (chat_object.msg_queue.AtLeast(1)) do begin
        t := TXMLTag(chat_object.msg_queue.Pop());
        Self.MessageEvent(t);
        end;
end;

{---------------------------------------}
procedure TfrmChat.MessageEvent(tag: TXMLTag);
var
    msg_type, from_jid: string;
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
        etag := tag.QueryXPTag('/message/*[@xmlns="jabber:x:event"]');
        if ((etag <> nil) and (etag.GetFirstTag('composing') <> nil))then begin
            // we are composing a message
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
                end;
            end;
        end;

    // if (msg_type = 'chat') then begin
    // normal chat message
    etag := tag.QueryXPTag('/message/*[@xmlns="jabber:x:event"]/composing');
    _send_composing := (etag <> nil);
    if (_send_composing) then
        _reply_id := tag.GetAttribute('id');

    showMsg(tag);
    if _thread = '' then begin
        //get thread from message
        tagThread := tag.GetFirstTag('thread');
        if tagThread <> nil then
            _thread := tagThread.Data;
       end;
    // end;
end;

{---------------------------------------}
procedure TfrmChat.showMsg(tag: TXMLTag);
var
    Msg: TJabberMessage;
begin
    // display the body of the msg
    if (timFlash.Enabled) then
        Self.ResetPresImage();
    _check_event := false;

    Msg := TJabberMessage.Create(tag);
    Msg.Nick := OtherNick;
    Msg.IsMe := false;

    // only display + notify if we have something to display :)
    if (Msg.Body <> '') then begin
        DoNotify(Self, 'notify_chatactivity', sChatActivity + OtherNick, ico_user);
        DisplayMsg(Msg, MsgList);

        // log if we want..
        if (MainSession.Prefs.getBool('log')) then
            LogMessage(Msg);
        end;

    Msg.Free();
end;

{---------------------------------------}
procedure TfrmChat.SendMsg;
var
    txt: Widestring;
    msg: TJabberMessage;
    mtag: TXMLTag;
begin
    // Send the actual message out
    // txt := getMemoText(MsgOut);
    txt := Trim(MsgOut.Text);

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
        PutAttribute('xmlns', XMLNS_MSGEVENTS);
        AddTag('composing');
        end;

    MainSession.SendTag(mtag);
    DisplayMsg(Msg, MsgList);

    // log the msg
    if (MainSession.Prefs.getBool('log')) then
        LogMessage(Msg);

    inherited;
end;

{---------------------------------------}
procedure TfrmChat.MsgOutKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #0) then exit;

    // Send the msg if they hit return
    if ((Key = #13) and (not mnuReturns.Checked)) then
        SendMsg()
    else
        inherited;

end;

{---------------------------------------}
procedure TfrmChat.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/disconnected') then begin
        DisplayPresence(sDisconnected, MsgList);
        MainSession.UnRegisterCallback(_pcallback);
        _pcallback := -1;
        end
    else if (event = '/session/connected') then begin
        Self.SetJID(jid);
        end
    else if (event = '/session/block') then begin
        // if this jid just got blocked, just close the window.
        if (_jid.jid = tag.GetAttribute('jid')) then begin
            DisplayPresence(sUserBlocked, Self.MsgList);
            MainSession.UnRegisterCallback(_pcallback);
            _pcallback := -1;
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
procedure TfrmChat.ChangePresImage(show: string; status: string);
begin
    // Change the bulb
    if (show = 'offline') then
        _pres_img := ico_Offline
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
    txt: string;
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
    frmRosterWindow.ImageList1.Draw(imgStatus.Canvas, 1, 1, _pres_img);
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
    if (_cur_img = _old_img) then
        _cur_img := ico_Chat
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
            PutAttribute('to', jid);
            with AddTag('x') do begin
                PutAttribute('xmlns', XMLNS_MSGEVENTS);
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
procedure TfrmChat.FormDestroy(Sender: TObject);
begin
    inherited;
    DragAcceptFiles( Handle, false );
end;

{---------------------------------------}
procedure TfrmChat.CTCPClick(Sender: TObject);
var
    jid: string;
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
        jabberSendCTCP(jid, XMLNS_VERSION)
    else if Sender = mnuTimeRequest then
        jabberSendCTCP(jid, XMLNS_TIME)
    else if Sender = mnuLastActivity then
        jabberSendCTCP(jid, XMLNS_LAST);
end;

{---------------------------------------}
procedure TfrmChat.CTCPCallback(event: string; tag: TXMLTag);
begin
    // record some kind of CTCP result
    if ((tag <> nil) and (tag.getAttribute('type') = 'result')) then begin
        //
        end
end;

{---------------------------------------}
procedure TfrmChat.mnuBlockClick(Sender: TObject);
begin
    MainSession.Block(_jid);
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
    DragAcceptFiles( Handle, not Docked);
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

procedure TfrmChat.btnCloseClick(Sender: TObject);
begin
  inherited;
    Self.Close();
end;

procedure TfrmChat.popClearHistoryClick(Sender: TObject);
begin
    inherited;
    ClearLog(Self._jid.jid)
end;

end.
