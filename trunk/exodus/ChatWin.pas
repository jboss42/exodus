unit ChatWin;
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
    Clipbrd,
{$IFDEF LINUX}
    Xlib,
{$ELSE}
    RichEdit,
{$ENDIF}
    JabberID,
    Chat, Dockable,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ComCtrls, ExtCtrls, Buttons, Menus, ToolWin, ExRichEdit,
    AppEvnts;

type
  TfrmChat = class(TfrmDockable)
    Splitter1: TSplitter;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    Clear1: TMenuItem;
    CopyAll1: TMenuItem;
    Panel3: TPanel;
    pnlInput: TPanel;
    SaveDialog1: TSaveDialog;
    Copy1: TMenuItem;
    MsgOut: TMemo;
    Panel7: TPanel;
    MsgList: TExRichEdit;
    pnlFrom: TPanel;
    StaticText1: TStaticText;
    lblJID: TStaticText;
    pnlSubject: TPanel;
    StaticText3: TStaticText;
    lblSubject: TStaticText;
    popContact: TPopupMenu;
    mnuHistory: TMenuItem;
    mnuBlock: TMenuItem;
    mnuProfile: TMenuItem;
    mnuSendFile: TMenuItem;
    mnuSave: TMenuItem;
    N1: TMenuItem;
    mnuReturns: TMenuItem;
    mnuEncrypt: TMenuItem;
    mnuAdd: TMenuItem;
    lblNick: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure MsgOutKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MsgOutKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnHistoryClick(Sender: TObject);
    procedure btnProfileClick(Sender: TObject);
    procedure btnAddRosterClick(Sender: TObject);
    procedure MsgListURLClick(Sender: TObject; url: String);
    procedure lblJIDClick(Sender: TObject);
    procedure mnuReturnsClick(Sender: TObject);
    procedure mnuSendFileClick(Sender: TObject);
  private
    { Private declarations }
    jid: string;            // jid of the person we are talking to
    _jid: TJabberID;
    _callback: integer;     // Message Callback
    _pcallback: integer;    // Presence Callback
    _scallback: integer;    // Session callback
    _thread : string;       // thread for conversation

    procedure MsgCallback(event: string; tag: TXMLTag);
    procedure PresCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);

    function GetThread: String;
  protected
    {protected stuff}
  public
    { Public declarations }
    OtherNick: string;
    chat_object: TJabberChat;

    procedure showMsg(tag: TXMLTag);
    procedure showPres(tag: TXMLTag);
    procedure sendMsg;
    procedure SetJID(cjid: string);
  end;

var
  frmChat: TfrmChat;

function StartChat(sjid, resource: string; show_window: boolean): TfrmChat;
procedure CloseAllChats;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.DFM}

uses
    PrefController,
    Transfer, RosterAdd, RiserWindow, 
    Jabber1, Profile, ExUtils, MsgDisplay,
    JabberMsg, Roster, Session, XMLUtils,
    ShellAPI;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function StartChat(sjid, resource: string; show_window: boolean): TfrmChat;
var
    chat: TJabberChat;
    win: TfrmChat;
    tmp_jid: TJabberID;
    cjid: string;
begin
    // either show an existing chat or start one.
    chat := MainSession.ChatList.FindChat(sjid, resource, '');
    if chat = nil then begin
        // Create one
        chat := MainSession.ChatList.AddChat(sjid, resource);
        win := TfrmChat.Create(nil);
        chat.window := win;
        win.chat_object := chat;
        end;

    with TfrmChat(chat.window) do begin
        tmp_jid := TJabberID.Create(sjid);
        OtherNick := tmp_jid.user;
        if resource <> '' then
            cjid := sjid + '/' + resource
        else
            cjid := sjid;
        tmp_jid.Free;
        SetJID(cjid);

        // setup prefs
        with MainSession.Prefs do begin
            MsgList.Font.Name := getString('font_name');
            MsgList.Font.Size := getInt('font_size');
            MsgList.Font.Style := [];
            MsgList.Color := TColor(getInt('color_bg'));
            MsgList.Font.Color := TColor(getInt('font_color'));
            if getBool('font_bold') then
                MsgList.Font.Style := MsgList.Font.Style + [fsBold];
            if getBool('font_italic') then
                MsgList.Font.Style := MsgList.Font.Style + [fsItalic];
            if getBool('font_underline') then
                MsgList.Font.Style := MsgList.Font.Style + [fsUnderline];
            end;

        MsgOut.Color := MsgList.Color;
        MsgOut.Font.Assign(MsgList.Font);

        ShowDefault();
        if (show_window) then
            Show();
        end;

    Result := TfrmChat(chat.window);
end;

{---------------------------------------}
procedure CloseAllChats;
var
    i: integer;
    c: TJabberChat;
begin
    with MainSession.ChatList do begin
        for i := Count - 1 downto 0 do begin
            c := TJabberChat(Objects[i]);
            if c <> nil then begin
                if c.window <> nil then
                    TfrmChat(c.window).chat_object := nil;
                    c.window.Close;
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
    _callback := -1;
    _pcallback := -1;
    _scallback := -1;
end;

{---------------------------------------}
procedure TfrmChat.SetJID(cjid: string);
var
    ritem: TJabberRosterItem;
    i: integer;
begin
    jid := cjid;
    _jid := TJabberID.Create(cjid);

    // setup the callbacks if we don't have them already
    if (_callback < 0) then begin
        _callback := MainSession.RegisterCallback(MsgCallback, '/packet/message[@type="chat"][@from="' + cjid + '*"]');
        _pcallback := MainSession.RegisterCallback(PresCallback, '/packet/presence[@from="' + cjid + '*"]');
        end;
    if (_scallback < 0) then
        _scallback := MainSession.RegisterCallback(SessionCallback, '/session');

    // setup the captions, etc..
    ritem := MainSession.Roster.Find(_jid.jid);
    if ritem <> nil then begin
        lblNick.Caption := ritem.Nickname;
        lblJID.Caption := '<' + _jid.full + '>';
        Caption := ritem.Nickname + ' - Chat';
        end
    else begin
        lblNick.Caption := '';
        lblJID.Caption := cjid;
        Caption := _jid.user + ' - Chat';
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
var
    i: integer;
begin
    if (_callback > 0) then begin
        MainSession.UnRegisterCallback(_pcallback);
        MainSession.UnRegisterCallback(_callback);
        MainSession.UnRegisterCallback(_scallback);
        end;

    if chat_object <> nil then begin
        i := MainSession.ChatList.IndexOfObject(chat_object);
        if i >= 0 then
            MainSession.ChatList.Delete(i);
        chat_object.Free;
        end;

    Action := caFree;
end;

{---------------------------------------}
procedure TfrmChat.btnCloseClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmChat.MsgCallback(event: string; tag: TXMLTag);
var
    from_jid: string;
    tagThread : TXMLTag;
begin
    // callback
    if Event = 'xml' then begin
        from_jid := tag.getAttribute('from');
        if from_jid <> jid then
            SetJID(from_jid);
        showMsg(tag);
        end;

    if _thread = '' then begin
        //get thread from message
        tagThread := tag.GetFirstTag('thread');
        if tagThread <> nil then
            _thread := tagThread.Data;
       end;
end;

{---------------------------------------}
procedure TfrmChat.showMsg(tag: TXMLTag);
var
    cn: integer;
    etag, btag: TXMLTag;
    Msg: TJabberMessage;
begin
    // display the body of the msg
    btag := tag.QueryXPTag('/message/body');
    etag := tag.QueryXPTag('/message/*@xmlns="jabber:iq:event"');
    if ((etag <> nil) and (btag = nil)) then begin
        // display the event type..
        end;

    cn := MainSession.Prefs.getInt('notify_chatactivity');

    if (not Application.Active) then begin
        // Pop toast
        if (cn and notify_toast) > 0 then begin
            ShowRiserWindow('Chat Activity: ' + OtherNick, 20);
            end;

        // Flash Window
        if (cn and notify_flash) > 0 then begin
            if (Self.Docked) then
                FlashWindow(frmJabber.Handle, true)
            else
                FlashWindow(Self.Handle, true);
            end;
        end;

    if ((btag = nil) or (btag.Data = '')) then exit;
    
    Msg := TJabberMessage.Create(tag);
    Msg.Nick := OtherNick;
    Msg.IsMe := false;
    DisplayMsg(Msg, MsgList);

    // log if we want..
    if (MainSession.Prefs.getBool('log')) then
        LogMessage(Msg);
end;

{---------------------------------------}
procedure TfrmChat.SendMsg;
var
    msg: TJabberMessage;
begin
    // Send the actual message out
    if _thread = '' then begin   //get thread from message
        _thread := GetThread;
        end;

    // send the msg
    msg := TJabberMessage.Create(jid, 'chat', MsgOut.Text, '');
    msg.thread := _thread;
    msg.nick := MainSession.Username;
    msg.isMe := true;
    msg.id := MainSession.generateID();
    MainSession.SendTag(msg.Tag);
    DisplayMsg(Msg, MsgList);

    // log the msg
    if (MainSession.Prefs.getBool('log')) then
        LogMessage(Msg);

    // Send cursor back to the txt entry box
    MsgOut.Text := '';
    MsgOut.SetFocus;
end;

{---------------------------------------}
procedure TfrmChat.MsgOutKeyPress(Sender: TObject; var Key: Char);
begin
    // Send the msg if they hit return
    if ( (Key = #13) and not(mnuReturns.Checked)) then
        SendMsg();
end;

{---------------------------------------}
procedure TfrmChat.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/disconnected') then begin
        DisplayPresence('You have been disconnected', MsgList);
        MainSession.UnRegisterCallback(_callback);
        MainSession.UnRegisterCallback(_pcallback);
        // MainSession.UnRegisterCallback(_scallback);
        _callback := -1;
        _pcallback := -1;
        // _scallback := -1;
        end
    else if (event = '/session/connected') then begin
        Self.SetJID(jid);
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
procedure TfrmChat.showPres(tag: TXMLTag);
var
    txt: string;
    stag: TXMLTag;
    User  : String;
begin
    // Get the user
    user := tag.GetAttribute('from');

    //check to see if this is the person you are chatting with...
    if pos(jid, user) = 0 then Exit;
    txt := '';
    stag := tag.GetFirstTag('status');

    if stag <> nil then
        txt := stag.Data
    else
        txt := tag.GetAttribute('type');

    if txt = '' then exit;

    txt := '[' + formatdatetime('HH:MM',now) + '] ' + jid + ' is now ' + txt;
    DisplayPresence(txt, MsgList);
end;

{---------------------------------------}
procedure TfrmChat.FormActivate(Sender: TObject);
begin
    if Self.Visible then
        MsgOut.SetFocus;
    // FlashWindow(Self.Handle, false);
end;

{---------------------------------------}
procedure TfrmChat.FormResize(Sender: TObject);
begin
  inherited;
    // check to make sure the JID and Subject fit..
    {
    lw := lblJID.width;
    tw := Panel7.Canvas.TextWidth(lblJID.Caption);
    }
end;

{---------------------------------------}
procedure TfrmChat.MsgOutKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);var    cur_buff: string;    s,e, i: integer;begin  inherited;
    if ((Key = VK_BACK) and (ssCtrl in Shift)) then begin
        // delete the last word
        cur_buff := MsgOut.Lines.Text;
        e := MsgOut.SelStart;
        s := -1;
        i := e;
        while (i > 0) do begin
            if (cur_buff[i] = ' ') then begin
                s := i;
                break;
                end
            else
                dec(i);
            end;

        if (s > 0) then with MsgOut do begin
            SelStart := s;
            SelLength := (e - s);
            SelText := '';
            Key := 0;
            end;
        end;
end;

procedure TfrmChat.btnHistoryClick(Sender: TObject);
begin
  inherited;
    ShowLog(_jid.jid);
end;

procedure TfrmChat.btnProfileClick(Sender: TObject);
begin
  inherited;
    ShowProfile(_jid.jid);
end;

procedure TfrmChat.btnAddRosterClick(Sender: TObject);
var
    ritem: TJabberRosterItem;
    add: TfrmAdd;
begin
  inherited;
    // check to see if we're already subscribed...
    ritem := MainSession.roster.find(_jid.jid);
    if ((ritem <> nil) and ((ritem.subscription = 'both') or (ritem.subscription = 'to'))) then begin
        MessageDlg('You are already subscribed to this contact', mtInformation,
            [mbOK], 0);
        exit;
        end
    else begin
        add := ShowAddContact();
        add.txtJID.Text := _jid.jid;
        add.txtNickname.Text := _jid.user;
        end;

end;

procedure TfrmChat.MsgListURLClick(Sender: TObject; url: String);
begin
  inherited;
    ShellExecute(0, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmChat.lblJIDClick(Sender: TObject);
var
    cp: TPoint;
begin
  inherited;
    GetCursorPos(cp);
    popContact.popup(cp.x, cp.y);
end;

procedure TfrmChat.mnuReturnsClick(Sender: TObject);
begin
  inherited;
    mnuReturns.Checked := not mnuReturns.Checked;
end;

procedure TfrmChat.mnuSendFileClick(Sender: TObject);
begin
  inherited;
    FileSend(_jid.full);
end;

end.
