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
    Buttons, TntStdCtrls, Menus, TntMenus, StrUtils, EntityCache, Entity,
    TntSysUtils, ToolWin, TntForms, ExFrame;

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
    popContact: TTntPopupMenu;
    pnlTop: TPanel;
    pnlHeader: TPanel;
    pnlSendSubject: TPanel;
    lblSubject1: TTntLabel;
    txtSendSubject: TTntMemo;
    pnlSubject: TPanel;
    txtSubject: TTntLabel;
    lblSubject2: TTntStaticText;
    frameButtons1: TframeButtons;
    popClipboard: TTntPopupMenu;
    N2: TTntMenuItem;
    mnuResources: TTntMenuItem;
    N1: TTntMenuItem;
    mnuSendFile: TTntMenuItem;
    mnuBlock: TTntMenuItem;
    C1: TTntMenuItem;
    mnuProfile: TTntMenuItem;
    popClearHistory: TTntMenuItem;
    mnuHistory: TTntMenuItem;
    popPaste: TTntMenuItem;
    popCopy: TTntMenuItem;
    MsgPanel: TPanel;
    mnuLastActivity: TMenuItem;
    mnuTimeRequest: TMenuItem;
    mnuVersionRequest: TMenuItem;
    pnlTop2: TPanel;
    lblFrom: TTntLabel;
    txtFrom: TTntLabel;
    pnlError: TPanel;
    Image1: TImage;
    
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
    _callback_id: integer;
    _password: Widestring;

    procedure SetupResources();
    procedure DisablePopup();
    procedure mnuResourceClick(Sender: TObject);

    procedure NextOrClose();

  protected
      procedure sizeHeaders();

  public
    { Public declarations }
    cid: integer;
    eType: TJabberEventType;
    recips: TWideStringlist;
    ComController: TObject;

    procedure PushEvent(e: TJabberEvent);
    procedure DisplayEvent(e: TJabberEvent);

    procedure SetupSend();

    procedure SetupRecips(jid: Widestring); overload;
    procedure SetupRecips(jidlist: TWidestringlist); overload;

    procedure setFrom(jid: WideString);

    procedure AddOutgoing(txt: Widestring);
    procedure AddXTagXML(xml: Widestring);

    procedure pluginMenuClick(Sender: TObject);
    function JID: Widestring;
    procedure OnCallback(event: string; tag: TXMLTag);

    // TMsgController
    function getObject(): TObject;
    procedure MessageEvent(tag: TXMLTag);
    property Controller: TExMsgController read _controller;
  end;

var
  frmMsgRecv: TfrmMsgRecv;

function StartRecvMsg(e: TJabberEvent): TfrmMsgRecv;

function StartMsg(msg_jid: WideString): TfrmMsgRecv;
function BroadcastMsg(jids: TWideStringlist): TfrmMsgRecv;

const
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

    sDeclineReason = 'Reason for declining invitation';
    SE_DISCONNECTED = '/session/disconnected';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    RosterRecv,
    DisplayName,
    chatWin,
    Clipbrd, COMChatController, JabberConst, ShellAPI, Profile,
    XferManager, GnuGetText,
    ExSession, JabberUtils, ExUtils,  JabberMsg, JabberID,
    RemoveContact, Room, ContactController,
    Presence, Session, Jabber1, InputPassword, MsgDisplay;

{$R *.DFM}

{---------------------------------------}
function StartRecvMsg(e: TJabberEvent): TfrmMsgRecv;
var
    c: TMsgController;
    frmRosterRecv : TfrmRosterRecv;
begin
    Result := nil;
    if (e = nil) then exit;
    if (e.eType = evt_RosterItems) then begin
        frmRosterRecv := TfrmRosterRecv.Create(Application);
        frmRosterRecv.Restore(e);
        frmRosterRecv.ShowDefault();
    end
    else if (e.eType = evt_Chat) then begin
        // startChat will automatically play the queue of msgs
        StartChat(e.from_jid.jid, e.from_jid.resource, true);
    end
    else begin
        // display this msg in a new window
        c := MainSession.MsgList.FindJid(e.from);
        if (c = nil) then begin
            Result := TfrmMsgRecv.Create(Application);
            Result.cid := MainSession.MsgList.AddController(e.from, Result.Controller);
            Result.DisplayEvent(e);
            Result.sizeHeaders();
            Result.ShowDefault();
        end
        else begin
            Result := TfrmMsgRecv(c.Data);
            Result.ShowDefault(); //bring the message window to front
            Result.PushEvent(e);
        end;
        ExComController.fireNewIncomingIM(e.from, TExodusChat(Result.ComController));        
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
        SetupSend();
        SetupRecips(jids);

        // if none of our recips can receive this msg, bail
        if (recips.Count <= 0) then begin
            Free();
            exit;
        end;

        DisablePopup();

        // setup the form for sending a msg
        txtFrom.Caption := '';
        for i := 0 to recips.Count - 1 do begin
            txtFrom.Caption := txtFrom.Caption + recips[i];
            if (i < recips.Count - 1) then
                txtFrom.Caption := txtFrom.Caption + ', ';
        end;

        sizeHeaders();
        ShowDefault;
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
        SetupRecips(msg_jid);
        if (recips.Count <= 0) then begin
            Free();
            exit;
        end;
        SetupResources();
        setFrom(msg_jid);
        sizeHeaders();
        ShowDefault();
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
    s: Widestring;
    echat: TExodusChat;
begin
    inherited;
    // pre-fill parts of the header grid
    AssignUnicodeFont(Self);
    AssignUnicodeURL(txtFrom.Font, 8);
    TranslateComponent(Self);

    lblFrom.Font.Style := [fsBold];
    lblSubject1.Font.Style := [fsBold];
    lblSubject2.Font.Style := [fsBold];

    // ugh.. some translations use the old caption w/ trailing spaces
    s := _('Subject') + ':';
    lblSubject1.Caption := s;
    lblSubject2.Caption := s;

    AssignDefaultFont(txtMsg.Font);
    txtMsg.Color := TColor(MainSession.Prefs.getInt('color_bg'));
    AssignDefaultFont(MsgOut.Font);
    MsgOut.Color := TColor(MainSession.Prefs.getInt('color_bg'));

    Self.ClientHeight := 350;
    recips := TWideStringlist.Create();
    pnlTop.Height := pnlSubject.Top + pnlSubject.Height + 3;

    //branding
    mnuSendFile.Visible := MainSession.Prefs.getBool('brand_ft');

    _xtags := '';
    _events := TQueue.Create();
    _controller := TExMsgController.Create();
    _controller.MessageEvent := Self.MessageEvent;
    _controller.Data := Self;
    cid := -1;

    // COM interface for this MsgWindow
    echat := TExodusChat.Create();
    echat.setIM(Self);
    echat.ObjAddRef();
    ComController := echat;

    //register for callbacks
    _callback_id := MainSession.RegisterCallback(OnCallback, SE_DISCONNECTED);
end;

{---------------------------------------}
procedure TfrmMsgRecv.OnCallback(event: string; tag: TXMLTag);
begin
    if (event = SE_DISCONNECTED) then begin
        Self.Close;
    end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.sizeHeaders();
var
    w: integer;
begin
    // Ensure all headers are the same width
    w := lblFrom.Width;
    if (lblSubject1.Width > w) then w := lblSubject1.Width;
    if (lblSubject2.Width > w) then w := lblSubject2.Width;
    lblFrom.Width := w;
    lblSubject1.Width := w;
    lblSubject2.Width := w;
end;

{---------------------------------------}
procedure TfrmMsgRecv.DisablePopup();
//var
//    i: integer;
begin
    // Don't know why all of these are disabled.
    // But, changed to individual disables from
    // loop because loop was disabling plugin added menus.
    mnuHistory.Enabled := false;
    popClearHistory.Enabled := false;
    mnuProfile.Enabled := false;
    C1.Enabled := false;
    mnuBlock.Enabled := false;
    mnuSendFile.Enabled := false;
    mnuResources.Enabled := false;

{
    for i := 0 to popContact.Items.Count - 1 do
         popContact.Items[i].Enabled := false;
}
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
var
    tempjid: TJabberID;
begin
    eType := e.eType;
    recips.Add(e.from);
    setFrom(e.from);
    frameButtons1.btnOK.Enabled := true;
    frameButtons1.btnCancel.Enabled := true;

    tempjid := TJabberID.Create(e.str_content);
    _base_JID := tempjid.removeJEP106(tempjid.full);
    txtSubject.Caption := Tnt_WideStringReplace(_base_JID, '&', '&&', [rfReplaceAll, rfIgnoreCase]);

    txtMsg.InputFormat := ifUnicode;
    txtMsg.WideText := e.Data.Text;


    DisablePopup();

    if (eType = evt_Invite) then begin
        // Change button captions for TC Invites
        _password := e.password;
        frameButtons1.btnOK.Caption := _(sAccept);
        frameButtons1.btnCancel.Caption := _(sDecline);
    end

    else if (e.error) then begin
        // This is an error.. show the error panel
        frameButtons1.btnOK.Visible := false;
        pnlError.Visible := true;
        lblSubject2.Caption := _(sError);
    end

    else
        // normally, we don't want a REPLY button
        frameButtons1.btnOK.Visible := (eType = evt_Message);

    pnlTop.Height := pnlSubject.Top + pnlSubject.Height + 3;
    HighlightKeywords(txtMsg, 0);
    tempjid.Free;
end;

{---------------------------------------}
procedure TfrmMsgRecv.SetupSend();
begin
    pnlSubject.Visible := false;
    pnlSendSubject.Visible := true;
    frameButtons1.Visible := false;
    txtMsg.Visible := false;
    MsgPanel.Align := alTop;
    MsgPanel.ClientHeight := pnlTop.ClientHeight;
    pnlReply.ClientHeight := Self.ClientHeight - pnlTop.ClientHeight; 
    pnlReply.Visible := true;
    pnlReply.Align := alClient;
    Splitter1.Visible := false;
    ActiveControl := MsgOut;
    lblFrom.Caption := _(sTo);
    pnlTop.Height := pnlSendSubject.Top + pnlSendSubject.Height + 3;

end;

{---------------------------------------}
procedure TfrmMsgRecv.SetupRecips(jid: Widestring);
//var
//    msg: Widestring;
//    id: TJabberID;
//    p: TJabberPres;
//    ri: TJabberRosterItem;
begin
    // check to see if this user is online, can receive offlines, etc
{ TODO : Roster refactor }    
//    id := TJabberID.Create(jid);
//    p := MainSession.ppdb.FindPres(id.jid, id.resource);
//    if (p = nil) then begin
//        ri := MainSession.Roster.Find(id.jid);
//        if (ri = nil) then
//            ri := MainSession.Roster.Find(id.full);
//
//        if ((ri <> nil) and (not ri.CanOffline)) then begin
//            msg := _('This contact (%s) can not receive offline messages.');
//            msg := WideFormat(msg, [id.full]);
//            MessageDlgW(msg, mtError, [mbOK], 0);
//            id.Free();
//            exit;
//        end;
//    end;
//
//    id.Free();
//    recips.add(jid);
end;

{---------------------------------------}
procedure TfrmMsgRecv.SetupRecips(jidlist: TWidestringlist);
var
    i: integer;
begin
    for i := 0 to jidlist.Count - 1 do
        SetupRecips(jidlist[i]);
end;

{---------------------------------------}
procedure TfrmMsgRecv.FormResize(Sender: TObject);
begin
    // Resize some of the form element
    {
    if pnlError.Visible then
        btnClose.Left := Self.ClientWidth - btnClose.Width - pnlError.Width - 5
    else
        btnClose.Left := Self.ClientWidth - btnClose.Width - 2;
    }
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
            frameButtons1.btnCancel.Caption := _(sBtnClose)
        else
            frameButtons1.btnCancel.Caption := _(sBtnNext);
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

    //JJF hmm, if cid is just an index into the MsgList list, this probably
    //won't work right (ie another msg form is open before this one and closed
    //after this one is opened but before it closes)
    if ((cid <> -1) and (MainSession <> nil) and (cid < MainSession.MsgList.Count)) then
        MainSession.MsgList.Delete(cid);

    Action := caFree;
    inherited;
end;

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons1btnCancelClick(Sender: TObject);
var
    messagetag: TXmlTag;
    xTag: TXmlTag;
    declineTag: TXmlTag;
    reasonTag: TXmlTag;
    rjid: TJabberID;
    reason: Widestring;
begin
    if eType = evt_Invite then begin
        // send back a decline message.
        messagetag := TXmlTag.Create('message');
        xTag := TXmlTag.Create('x');
        declineTag := TXmlTag.Create('decline');
        reasonTag := TXMLTag.Create('reason');

        rjid := TJabberID.Create(_base_jid, false);
        messagetag.setAttribute('from', MainSession.JID);
        messagetag.setAttribute('to', rjid.jid);
        xTag.setAttribute('xmlns', 'http://jabber.org/protocol/muc#user');
        declineTag.setAttribute('to', JID);
        reason := '';
        if (not InputQueryW(_(sDeclineReason), _(sDeclineReason), reason, False, False)) then begin
            reasonTag.Free();
            declineTag.Free();
            xTag.Free();
            messagetag.Free();
        end
        else begin
            reasonTag.AddCData(reason);
            declineTag.AddTag(reasonTag);
            xTag.AddTag(declineTag);
            messagetag.AddTag(xTag);
            MainSession.SendTag(messagetag);
            NextOrClose();
        end;
    end
    else
        NextOrClose();
end;

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons1btnOKClick(Sender: TObject);
var
    jid: TJabberID;
begin
    // Do something...
    if eType = evt_Invite then begin
        // join this grp... grp is in the subject
        jid := TJabberID.Create(_base_jid, false);
        StartRoom(jid.jid, '', _password, True, False, True);
        jid.Free();
        Self.Close();
    end

    else begin
        // reply
        pnlReply.ClientHeight := Self.ClientHeight div 2;
        frameButtons1.btnOK.Enabled := false;
        pnlReply.Align := alBottom;
        pnlReply.Visible := true;
        Splitter1.Visible := true;
        if (MsgOut.Visible and MsgOut.Enabled) then begin
            try
                MsgOut.SetFocus;
            except
               // To handle Cannot focus exception
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons2btnOKClick(Sender: TObject);
var
    m: TJabberMessage;
    x2, xml, txt, s: WideString;
    i: integer;
    mtag: TXMLTag;
    ent: TJabberEntity;
    allowed: WordBool;
    nick: Widestring;
begin
    // Send the outgoing msg
    txt := getInputText(MsgOut);
    if (txt = '') then exit;

    // let plugins know about message going out
    // if they don't want to allow it, they change txt to NULL
    if (ComController <> nil) then
        allowed := TExodusChat(ComController).fireBeforeMsg(txt)
    else
        allowed := true;

    if ((allowed = false) or (txt = '')) then exit;


    if (pnlSendSubject.Visible) then
        s := txtSendSubject.Text
    else
        s := txtSubject.Caption;

    // Check for multicast service
    ent := jEntityCache.getFirstFeature(XMLNS_ADDRESS);
    nick := MainSession.getDisplayUsername();
    if (ent = nil) then begin
        //  send to ALL recips - no multicast service include
        //  address element as hint to clients
        for i := 0 to recips.Count - 1 do begin
            m := TJabberMessage.Create(recips[i], '', txt, s);

            // these must be set so that logging works right
            m.ToJID := recips[i];
            m.AddRecipient(recips[i]); // Comptability hack
            m.isMe := true;
            m.Nick := nick;

            mtag := m.GetTag;

            // plugin stuff
            if (ComController <> nil) then
                x2 := TExodusChat(ComController).fireAfterMsg(txt);
            if (x2 <> '') then
                mtag.addInsertedXML(x2);

            // add any x-tags from inside Exodus
            if (xml <> '') then
                mtag.addInsertedXML(xml);

            // log the msg
            LogMessage(m);

            jabberSendMsg(recips[i], mtag, _xtags, txt, s);
            m.Free();
        end;
    end
    else begin
        // We have a multicast service - use it
        m := TJabberMessage.Create(ent.Jid.jid, '', txt, s);

        // add recipient <address> elements to the message
        for i := 0 to recips.Count - 1 do begin
            m.AddRecipient(recips[i]);
        end;

         m.isMe := true;
         m.Nick := nick;

         mtag := m.GetTag;

         // plugin stuff
         if (ComController <> nil) then
             x2 := TExodusChat(ComController).fireAfterMsg(txt);
         if (x2 <> '') then
             mtag.addInsertedXML(x2);

         // add any x-tags from inside Exodus
         if (xml <> '') then
            mtag.addInsertedXML(xml);

         // log the msg
         LogMessage(m);

         jabberSendMsg(ent.Jid.jid, mtag, _xtags, txt, s);
         m.Free();
    end;

    recips.Clear();
    MsgOut.WideLines.Clear();
    Splitter1.Visible := false;
    pnlReply.Visible := false;
    NextOrClose();
end;

{---------------------------------------}
procedure TfrmMsgRecv.txtMsgURLClick(Sender: TObject; url: String);
begin
    ShellExecute(Application.Handle, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
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
        // can't send to offline contacts
        exit;
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
    ExComController.populateMsgMenus(popContact, self.pluginMenuClick);
    GetCursorPos(cp);
    popContact.popup(cp.x, cp.y);
end;

{---------------------------------------}
procedure TfrmMsgRecv.setFrom(jid: WideString);
var
    tmp_jid: TJabberID;
begin
    tmp_jid := TJabberID.Create(jid);
    txtFrom.Caption := DisplayName.getDisplayNameCache().getDisplayname(tmp_jid) + ' <' + tmp_jid.getDisplayFull + '>';
    txtFrom.Caption := Tnt_WideStringReplace(txtFrom.Caption, '&', '&&', [rfReplaceAll, rfIgnoreCase]);
    if (pnlSendSubject.Visible) then
        Self.Caption := _(sMessageTo) + DisplayName.getDisplayNameCache().getDisplayName(tmp_jid)
    else
        Self.Caption := _(sMessageFrom) + DisplayName.getDisplayNameCache().getDisplayName(tmp_jid);

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

    LogMsgEvent(e);

    e.Free();
    // plugin
    xml := tag.xml();
    body := tag.GetBasicText('body');
    TExodusChat(ComController).fireBeforeRecvMsg(body, xml);
    TExodusChat(ComController).fireAfterRecvMsg(body);
end;

{---------------------------------------}
procedure TfrmMsgRecv.PushEvent(e: TJabberEvent);
begin
    // Make sure we don't get dups
    //JJF well, there is no dup checking so I'm assuming this is unimplemented
    //so... Modifying so a copy of e gets pushed. Makes caller responisble
    //for free...
    //These windows could be open after user deletes event from msg queue
    _events.Push(TJabberEvent.create(e));
    frameButtons1.btnCancel.Caption := _(sBtnNext)
end;

{---------------------------------------}
procedure TfrmMsgRecv.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
    CanClose := true;
// This code was removed to prevent a situation with room invites
// that could cause getting stuck in a loop.
// Until this code can be reworked, it is now possible to dismiss the
// messages window without having actually read all messages.
// This is a short term fix with the understanding that this code will be
// reworked in the next release
//    if (_events.Count = 0) then
//        CanClose := true
//    else begin
//        CanClose := false;
//        MessageDlgW(_(sMsgsPending), mtError, [mbOK], 0);
//    end;
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
var
    mi: TMenuItem;
    subject: widestring;
    body: widestring;
    jid: widestring;
begin
    mi := TMenuItem(Sender);
    jid := _base_jid;
    subject := txtSubject.Caption;
    body := txtMsg.WideText;
    ExComController.fireMsgMenuClick(mi.Tag, jid, body, subject);
end;

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons2btnCancelClick(Sender: TObject);
begin
  inherited;
    // cancel the reply window
    if (not txtMsg.Visible) then
        Self.Close
    else begin
        frameButtons1.btnOK.Enabled := true;
        Splitter1.Visible := false;
        pnlReply.Visible := false;
        frameButtons1.Align := alBottom;
    end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.MsgOutKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #0) then exit;
    inherited;
end;

{---------------------------------------}
procedure TfrmMsgRecv.FormDestroy(Sender: TObject);
begin
    if (ComController <> nil) then
        ComController.Free();

    if (_events <> nil) then
        _events.Free();

    MainSession.UnRegisterCallback(_callback_id);

  inherited;
end;
end.

