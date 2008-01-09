unit MsgRecv;
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
    Unicode, Dockable, ExEvents, MsgController, XMLTag, Contnrs,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls, ComCtrls, Grids, ExtCtrls, ExRichEdit, RichEdit2,
    Buttons, TntStdCtrls, Menus;

type

    TExMessageEvent = procedure(tag: TXMLTag) of object;

    TExMsgController = class(TMsgController)
    public
        MessageEvent: TExMessageEvent;
        constructor Create;
        procedure HandleMessage(tag: TXMLTag); override;
    end;

type
  TfrmMsgRecv = class(TfrmDockable)
    pnlReply: TPanel;
    frameButtons2: TframeButtons;
    Splitter1: TSplitter;
    txtMsg: TExRichEdit;
    MsgOut: TExRichEdit;
    popContact: TPopupMenu;
    mnuHistory: TMenuItem;
    popClearHistory: TMenuItem;
    mnuProfile: TMenuItem;
    C1: TMenuItem;
    mnuVersionRequest: TMenuItem;
    mnuTimeRequest: TMenuItem;
    mnuLastActivity: TMenuItem;
    mnuBlock: TMenuItem;
    mnuSendFile: TMenuItem;
    N1: TMenuItem;
    mnuResources: TMenuItem;
    pnlTop: TPanel;
    pnlHeader: TPanel;
    pnlSendSubject: TPanel;
    lblSubject1: TLabel;
    txtSendSubject: TTntMemo;
    pnlSubject: TPanel;
    txtSubject: TTntLabel;
    lblSubject2: TStaticText;
    pnlFrom: TPanel;
    btnClose: TSpeedButton;
    lblFrom: TStaticText;
    pnlError: TPanel;
    Image1: TImage;
    frameButtons1: TframeButtons;
    N2: TMenuItem;
    popClipboard: TPopupMenu;
    popCopy: TMenuItem;
    popPaste: TMenuItem;
    txtFrom: TTntLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons2btnOKClick(Sender: TObject);
    procedure txtMsgURLClick(Sender: TObject; url: String);
    procedure MsgOutKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure mnuHistoryClick(Sender: TObject);
    procedure popClearHistoryClick(Sender: TObject);
    procedure mnuProfileClick(Sender: TObject);
    procedure mnuVersionRequestClick(Sender: TObject);
    procedure mnuBlockClick(Sender: TObject);
    procedure mnuSendFileClick(Sender: TObject);
    procedure txtFromClick(Sender: TObject);
    procedure MsgOutKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure popCopyClick(Sender: TObject);
    procedure popPasteClick(Sender: TObject);
    procedure popClipboardPopup(Sender: TObject);
    procedure frameButtons2btnCancelClick(Sender: TObject);
    procedure MsgOutKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    _base_jid: WideString;
    _xtags: Widestring;
    _events: TQueue;
    _controller: TExMsgController;

    procedure SetupResources();
    procedure DisablePopup();
    procedure mnuResourceClick(Sender: TObject);

    procedure NextOrClose();
  public
    { Public declarations }
    cid: integer;
    eType: TJabberEventType;
    recips: TWideStringlist;
    ComController: TObject;

    procedure PushEvent(e: TJabberEvent);
    procedure DisplayEvent(e: TJabberEvent);

    procedure SetupSend();
    procedure setFrom(jid: WideString);

    procedure AddOutgoing(txt: Widestring);
    procedure AddXTagXML(xml: Widestring);

    procedure pluginMenuClick(Sender: TObject);
    function JID: Widestring;

    // TMsgController
    function getObject(): TObject;
    procedure MessageEvent(tag: TXMLTag);

    property Controller: TExMsgController read _controller;

  end;

var
  frmMsgRecv: TfrmMsgRecv;

procedure StartRecvMsg(e: TJabberEvent);

function StartMsg(msg_jid: WideString): TfrmMsgRecv;
function BroadcastMsg(jids: TWideStringlist): TfrmMsgRecv;

resourcestring
    sMessageFrom = 'Message from ';
    sMessageTo = 'Message to ';

    sRemove = 'Remove';
    sAccept = 'Accept';
    sDecline = 'Decline';
    sTo = 'To:';
    sError = 'Error:';
    sBtnClose = 'Close';
    sBtnNext = 'Next';
    sMsgsPending = 'You have unread messages. Read all messages before closing the window.';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Clipbrd, COMChatController, JabberConst, ShellAPI, Profile, Transfer,
    ExSession, ExUtils, JabberMsg, JabberID,
    RosterWindow, RemoveContact, RosterRecv, Room, Roster,
    Presence, Session, Jabber1;

{$R *.DFM}

{---------------------------------------}
procedure StartRecvMsg(e: TJabberEvent);
var
    fmsg: TfrmMsgRecv;
    fcts: TfrmRosterRecv;
begin
    // display this msg in a new window
    case e.eType of
    evt_RosterItems: begin
        // roster items
        fcts := TfrmRosterRecv.Create(Application);
        fcts.Restore(e);
    end
    else begin
        // other things
        fmsg := TfrmMsgRecv.Create(Application);
        fmsg.cid := MainSession.MsgList.AddController(e.from, fmsg.Controller);
        fmsg.DisplayEvent(e);
        fmsg.ShowDefault();
        e.Free();
    end;
    end;
end;

{---------------------------------------}
function BroadcastMsg(jids: TWideStringlist): TfrmMsgRecv;
var
    i: integer;
begin
    // send a normal msg to this person
    Result := TfrmMsgRecv.Create(Application);
    with Result do begin
        eType := evt_Message;
        recips.Assign(jids);
        SetupSend();
        DisablePopup();

        // setup the form for sending a msg
        txtFrom.Caption := '';
        for i := 0 to recips.Count - 1 do begin
            txtFrom.Caption := txtFrom.Caption + recips[i];
            if (i < recips.Count - 1) then
                txtFrom.Caption := txtFrom.Caption + ', ';
        end;

        ShowDefault;
        btnClose.Visible := Docked;
        FormResize(nil);
    end;
end;

{---------------------------------------}
function StartMsg(msg_jid: WideString): TfrmMsgRecv;
begin
    // send a normal msg to this person
    Result := TfrmMsgRecv.Create(Application);
    with Result do begin
        eType := evt_Message;

        // setup the form for sending a msg
        SetupSend();
        recips.Add(msg_jid);
        SetupResources();
        setFrom(msg_jid);
        ShowDefault;
        btnClose.Visible := Docked;
        FormResize(nil);
        if (txtSendSubject.Showing) then
            txtSendSubject.SetFocus();
    end;
    ExComController.fireNewOutgoingIM(msg_jid, TExodusChat(Result.ComController));
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TExMsgController.Create;
begin
    MessageEvent := nil;
end;

procedure TExMsgController.HandleMessage(tag: TXMLTag);
begin
    if (assigned(MessageEvent)) then
        MessageEvent(tag);
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmMsgRecv.FormCreate(Sender: TObject);
var
    echat: TExodusChat;
begin
    // pre-fill parts of the header grid
    AssignDefaultFont(txtMsg.Font);
    txtMsg.Color := TColor(MainSession.Prefs.getInt('color_bg'));
    AssignDefaultFont(MsgOut.Font);
    MsgOut.Color := TColor(MainSession.Prefs.getInt('color_bg'));

    AssignDefaultFont(txtSubject.Font);
    AssignDefaultFont(txtSendSubject.Font);

    Self.ClientHeight := 200;
    recips := TWideStringlist.Create();

    pnlTop.Height := pnlSubject.Top + pnlSubject.Height + 3;

    _xtags := '';
    _events := TQueue.Create();
    _controller := TExMsgController.Create();
    _controller.MessageEvent := Self.MessageEvent;
    cid := -1;

    // COM interface for this MsgWindow
    echat := TExodusChat.Create();
    echat.setIM(Self);
    echat.ObjAddRef();
    ComController := echat;
end;

{---------------------------------------}
procedure TfrmMsgRecv.DisablePopup();
var
    i: integer;
begin
    for i := 0 to popContact.Items.Count - 1 do
        popContact.Items[i].Enabled := false;
end;

{---------------------------------------}
procedure TfrmMsgRecv.SetupResources();
var
    p: TJabberPres;
    m: TMenuItem;
begin
    _base_jid := recips[0];
    p := MainSession.ppdb.FindPres(recips[0], '');
    while (p <> nil) do begin
        m := TMenuItem.Create(popContact);
        m.Caption := p.fromJID.resource;
        m.OnClick := mnuResourceClick;
        mnuResources.Add(m);
        p := MainSession.ppdb.NextPres(p);
    end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.DisplayEvent(e: TJabberEvent);
begin
    eType := e.eType;
    recips.Add(e.from);
    setFrom(e.from);
    frameButtons1.btnOK.Enabled := true;
    frameButtons1.btnCancel.Enabled := true;
    txtSubject.Caption := e.data_type;
    txtMsg.InputFormat := ifUnicode;
    txtMsg.WideText := e.Data.Text;

    DisablePopup();

    if eType = evt_Invite then begin
        // Change button captions for TC Invites
        frameButtons1.btnOK.Caption := sAccept;
        frameButtons1.btnCancel.Caption := sDecline;
    end

    else if e.error then begin
        // This is an error.. show the error panel
        frameButtons1.btnOK.Visible := false;
        pnlError.Visible := true;
        lblSubject2.Caption := sError;
    end

    else
        // normally, we don't want a REPLY button
        frameButtons1.btnOK.Visible := (eType = evt_Message);

    pnlTop.Height := pnlSubject.Top + pnlSubject.Height + 3;
    btnClose.Visible := Docked;
    FormResize(nil);

end;

{---------------------------------------}
procedure TfrmMsgRecv.SetupSend();
begin
    pnlSubject.Visible := false;
    pnlSendSubject.Visible := true;
    frameButtons1.Visible := false;
    txtMsg.Visible := false;
    pnlReply.Visible := true;
    pnlReply.Align := alClient;
    ActiveControl := MsgOut;
    lblFrom.Caption := sTo;
    btnClose.Visible := Docked;

    pnlTop.Height := pnlSendSubject.Top + pnlSendSubject.Height + 3;
end;

{---------------------------------------}
procedure TfrmMsgRecv.FormResize(Sender: TObject);
begin
    // Resize some of the form element
    if pnlError.Visible then
        btnClose.Left := Self.ClientWidth - btnClose.Width - pnlError.Width - 5
    else
        btnClose.Left := Self.ClientWidth - btnClose.Width - 2;
    txtMsg.Repaint();
end;

{---------------------------------------}
procedure TfrmMsgRecv.NextOrClose();
var
    e: TJabberEvent;
begin
    if (_events.Count = 0) then
        // Close the dialog, the queue is empty
        Self.Close
    else begin
        // show the next event
        e := _events.Pop;
        DisplayEvent(e);
        if (_events.Count = 0) then
            frameButtons1.btnCancel.Caption := sBtnClose
        else
            frameButtons1.btnCancel.Caption := sBtnNext;
        e.Free();
    end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.FormClose(Sender: TObject; var Action: TCloseAction);
var
    e: TJabberEvent;
begin
    recips.Free();

    // make sure the queue is clear
    while (_events.Count > 0) do begin
        e := TJabberEvent(_events.Pop);
        e.Free();
    end;
    FreeAndNil(_events);

    if ((cid <> -1) and (MainSession <> nil)) then
        MainSession.MsgList.Delete(cid);
    FreeAndNil(_controller);

    Action := caFree;
end;

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons1btnCancelClick(Sender: TObject);
begin
    NextOrClose();
end;

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons1btnOKClick(Sender: TObject);
var
    jid: WideString;
begin
    // Do something...
    if eType = evt_Invite then begin
        // join this grp... grp is in the subject
        jid := txtSubject.Caption;
        StartRoom(jid, MainSession.Username);
        Self.Close();
    end

    else begin
        // reply
        Self.ClientHeight := Self.ClientHeight + pnlReply.Height - frameButtons1.Height - 3;
        frameButtons1.btnOK.Enabled := false;
        pnlReply.Visible := true;
        pnlReply.Align := alBottom;
        MsgOut.SetFocus;
    end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons2btnOKClick(Sender: TObject);
var
    m: TJabberMessage;
    x2, xml, txt, s: WideString;
    i: integer;
    mtag: TXMLTag;
begin
    // Send the outgoing msg
    txt := getInputText(MsgOut);
    if (txt = '') then exit;

    // let plugins know about message going out
    // if they don't want to allow it, they change txt to NULL
    if (ComController <> nil) then
        TExodusChat(ComController).fireBeforeMsg(txt);

    if (txt = '') then exit;

    if (pnlSendSubject.Visible) then
        s := txtSendSubject.Text
    else
        s := txtSubject.Caption;

    // send to ALL recips
    for i := 0 to recips.Count - 1 do begin
        m := TJabberMessage.Create(recips[i], '', txt, s);

        // these must be set so that logging works right
        m.ToJID := recips[i];
        m.isMe := true;
        m.Nick := MainSession.Username;

        mtag := m.Tag;

        // plugin stuff
        if (ComController <> nil) then
            x2 := TExodusChat(ComController).fireAfterMsg(txt);
        if (x2 <> '') then
            mtag.addInsertedXML(x2);

        // add any x-tags from inside Exodus
        if (xml <> '') then
            mtag.addInsertedXML(xml);

        // log the msg
        if (MainSession.Prefs.getBool('log')) then
            LogMessage(m);
        jabberSendMsg(recips[i], mtag, _xtags, txt, s);
        m.Free();
    end;
    recips.Clear();
    MsgOut.WideLines.Clear();
    pnlReply.Visible := false;
    NextOrClose();
end;

{---------------------------------------}
procedure TfrmMsgRecv.txtMsgURLClick(Sender: TObject; url: String);
begin
    ShellExecute(0, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

{---------------------------------------}
procedure TfrmMsgRecv.MsgOutKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
    if ((Key = 13) and (Shift = [ssCtrl])) then begin
        Key := 0;
        frameButtons2btnOKClick(self);
    end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.btnCloseClick(Sender: TObject);
begin
    NextOrClose();
end;

{---------------------------------------}
procedure TfrmMsgRecv.FormEndDock(Sender, Target: TObject; X, Y: Integer);
begin
  inherited;
    btnClose.Visible := Docked;
end;

{---------------------------------------}
procedure TfrmMsgRecv.mnuHistoryClick(Sender: TObject);
begin
  inherited;
    if recips.count > 0 then
        ShowLog(recips[0]);
end;

{---------------------------------------}
procedure TfrmMsgRecv.popClearHistoryClick(Sender: TObject);
begin
  inherited;
    if recips.count <= 0 then exit;
    ClearLog(recips[0])
end;

{---------------------------------------}
procedure TfrmMsgRecv.mnuProfileClick(Sender: TObject);
begin
  inherited;
    if recips.count <= 0 then exit;
    ShowProfile(recips[0]);
end;

{---------------------------------------}
procedure TfrmMsgRecv.mnuVersionRequestClick(Sender: TObject);
var
    jid: WideString;
    p: TJabberPres;
begin
  inherited;
    // get some CTCP query sent out
    if recips.count <= 0 then exit;
    p := MainSession.ppdb.FindPres(recips[0], '');
    if p = nil then
        // this person isn't online.
        jid := recips[0]
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
procedure TfrmMsgRecv.mnuBlockClick(Sender: TObject);
begin
  inherited;
    if recips.count <= 0 then exit;
    MainSession.Block(TJabberID.Create(recips[0]));
end;

{---------------------------------------}
procedure TfrmMsgRecv.mnuSendFileClick(Sender: TObject);
var
    p: TJabberPres;
begin
  inherited;
    if recips.count <= 0 then exit;
    p := MainSession.ppdb.FindPres(recips[0], '');
    if (p = nil) then begin
        // xxx: can't send to offline contacts
    end;

    FileSend(p.fromJID.full);
end;

{---------------------------------------}
procedure TfrmMsgRecv.mnuResourceClick(Sender: TObject);
begin
  inherited;
    // set the message to this resource.
    recips[0] := _base_jid + '/' + TMenuItem(Sender).Caption;
    setFrom(recips[0]);
end;

{---------------------------------------}
procedure TfrmMsgRecv.txtFromClick(Sender: TObject);
var
    cp: TPoint;
begin
  inherited;
    GetCursorPos(cp);
    popContact.popup(cp.x, cp.y);
end;

{---------------------------------------}
procedure TfrmMsgRecv.setFrom(jid: WideString);
var
    tmp_jid: TJabberID;
    ritem: TJabberRosterItem;
begin
    tmp_jid := TJabberID.Create(jid);
    ritem := MainSession.roster.Find(tmp_jid.jid);
    if (ritem <> nil) then begin
        txtFrom.Caption := ritem.Nickname + ' <' + jid + '>';
        if (pnlSendSubject.Visible) then
            Self.Caption := sMessageTo + ritem.Nickname
        else
            Self.Caption := sMessageFrom + ritem.Nickname;
    end
    else begin
        txtFrom.Caption := jid;
        if (pnlSendSubject.Visible) then
            Self.Caption := sMessageTo + jid
        else
            Self.Caption := sMessageFrom + jid;
    end;
    tmp_jid.Free();
end;

{---------------------------------------}
procedure TfrmMsgRecv.MsgOutKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
    if (Key = 0) then exit;

    // handle Ctrl-ENTER and ENTER to send msgs
    if ((Key = VK_RETURN) and (Shift = [ssCtrl])) then begin
        Key := 0;
        frameButtons2btnOKClick(Self);
    end;

end;

{---------------------------------------}
procedure TfrmMsgRecv.AddOutgoing(txt: Widestring);
begin
    MsgOut.WideLines.Add(txt);
end;

{---------------------------------------}
procedure TfrmMsgRecv.AddXTagXML(xml: Widestring);
begin
    _xtags := _xtags + xml;
end;

{---------------------------------------}
function TfrmMsgRecv.getObject(): TObject;
begin
    Result := Self;
end;

{---------------------------------------}
procedure TfrmMsgRecv.MessageEvent(tag: TXMLTag);
var
    body, xml: Widestring;
    e: TJabberEvent;
begin
    // add this event to the queue.
    e := CreateJabberEvent(tag);
    PushEvent(e);

    // plugin
    xml := tag.xml();
    body := tag.GetBasicText('body');
    TExodusChat(ComController).fireRecvMsg(body, xml);
end;

{---------------------------------------}
procedure TfrmMsgRecv.PushEvent(e: TJabberEvent);
begin
    _events.Push(e);
    frameButtons1.btnCancel.Caption := sBtnNext
end;

{---------------------------------------}
procedure TfrmMsgRecv.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
    if (_events.Count = 0) then
        CanClose := true
    else begin
        CanClose := false;
        MessageDlg(sMsgsPending, mtError, [mbOK], 0);
    end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.popCopyClick(Sender: TObject);
begin
  inherited;
    //
    if (Self.ActiveControl = MsgOut) then
        MsgOut.CopyToClipboard()
    else
        txtMsg.CopyToClipboard();
end;

{---------------------------------------}
procedure TfrmMsgRecv.popPasteClick(Sender: TObject);
begin
  inherited;
    MsgOut.SelText := Clipboard.AsText;
end;

{---------------------------------------}
procedure TfrmMsgRecv.popClipboardPopup(Sender: TObject);
begin
  inherited;
    popPaste.Enabled := (Self.ActiveControl = MsgOut);
end;

{---------------------------------------}
function TfrmMsgRecv.JID: Widestring;
begin
    //
    if (recips.Count > 0) then
        Result := recips[0]
    else
        Result := txtFrom.Caption;
end;

{---------------------------------------}
procedure TfrmMsgRecv.pluginMenuClick(Sender: TObject);
begin
    TExodusChat(ComController).fireMenuClick(Sender);
end;

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons2btnCancelClick(Sender: TObject);
begin
  inherited;
    // cancel the reply window
    if (not txtMsg.Visible) then
        Self.Close
    else begin
        Self.ClientHeight := Self.ClientHeight - pnlReply.Height + frameButtons1.Height + 3;
        frameButtons1.btnOK.Enabled := true;
        pnlReply.Visible := false;
        frameButtons1.Align := alBottom;
    end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.MsgOutKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #0) then exit;
    if (ComController = nil) then exit;

    // dispatch key-presses to Plugins
    TExodusChat(ComController).fireMsgKeyPress(Key);
    inherited;
end;

{---------------------------------------}
procedure TfrmMsgRecv.FormDestroy(Sender: TObject);
begin
    if (ComController <> nil) then
        ComController.Free();

  inherited;
end;

end.

