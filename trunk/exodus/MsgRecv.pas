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
    Unicode, Dockable, ExEvents,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls, ComCtrls, Grids, ExtCtrls, ExRichEdit, RichEdit2,
    Buttons, TntStdCtrls, Menus;

type
  TfrmMsgRecv = class(TfrmDockable)
    frameButtons1: TframeButtons;
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
    txtFrom: TStaticText;
    pnlError: TPanel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons2btnOKClick(Sender: TObject);
    procedure frameButtons2btnCancelClick(Sender: TObject);
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
  private
    { Private declarations }
    _base_jid: WideString;

    procedure SetupResources();
    procedure DisablePopup();
    procedure mnuResourceClick(Sender: TObject);
  public
    { Public declarations }
    eType: TJabberEventType;
    recips: TWideStringlist;

    procedure SetupSend();
    procedure setFrom(jid: WideString);
  end;

var
  frmMsgRecv: TfrmMsgRecv;

function StartMsg(jid: WideString): TfrmMsgRecv;
function BroadcastMsg(jids: TWideStringlist): TfrmMsgRecv;

procedure ShowEvent(e: TJabberEvent);

resourcestring
    sMessageFrom = 'Message from ';

    sRemove = 'Remove';
    sAccept = 'Accept';
    sDecline = 'Decline';
    sTo = 'To:';
    sError = 'Error:';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberConst, ShellAPI, Profile, Transfer,
    ExUtils, JabberMsg, JabberID,
    RosterWindow, RemoveContact, RosterRecv, Room, Roster, 
    Presence, Session, Jabber1;

{$R *.DFM}

{---------------------------------------}
procedure ShowEvent(e: TJabberEvent);
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
        with fmsg do begin
            eType := e.eType;
            recips.Add(e.from);
            setFrom(e.from);
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

            ShowDefault;
            pnlTop.Height := pnlSubject.Top + pnlSubject.Height + 3;
            btnClose.Visible := Docked;
            FormResize(nil);
            end;
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
function StartMsg(jid: WideString): TfrmMsgRecv;
begin
    // send a normal msg to this person
    Result := TfrmMsgRecv.Create(Application);
    with Result do begin
        eType := evt_Message;

        // setup the form for sending a msg
        SetupSend();
        recips.Add(jid);
        SetupResources();
        setFrom(jid);
        ShowDefault;
        btnClose.Visible := Docked;
        FormResize(nil);
        if (txtSendSubject.Showing) then
            txtSendSubject.SetFocus();
        end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.DisablePopup();
var
    i: integer;
begin
    for i := 0 to popContact.Items.Count - 1 do
        popCOntact.Items[i].Enabled := false;
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
procedure TfrmMsgRecv.FormCreate(Sender: TObject);
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
procedure TfrmMsgRecv.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    recips.Free();

    Action := caFree;
end;

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
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
        Self.ClientHeight := Self.ClientHeight + pnlReply.Height - frameButtons1.Height - 3;
        frameButtons1.Visible := false;
        pnlReply.Visible := true;
        MsgOut.SetFocus;
        end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons2btnOKClick(Sender: TObject);
var
    m: TJabberMessage;
    txt, s: WideString;
    i: integer;
begin
    // Send the outgoing msg
    txt := Trim(MsgOut.WideText);
    if (txt = '') then exit;

    if (pnlSendSubject.Visible) then
        s := txtSendSubject.Text
    else
        s := txtSubject.Caption;

    // send to ALL recips
    for i := 0 to recips.Count - 1 do begin
        m := TJabberMessage.Create(recips[i], '', Trim(txt), s);
        MainSession.SendTag(m.Tag);
        m.Free();
        end;

    Self.Close;
end;

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons2btnCancelClick(Sender: TObject);
begin
    Self.Close;
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
    if ((Key = 13) and (Shift = [ssCtrl])) then
        frameButtons2btnOKClick(self);
end;

{---------------------------------------}
procedure TfrmMsgRecv.btnCloseClick(Sender: TObject);
begin
  inherited;
    Self.Close;
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
        Self.Caption := sMessageFrom + ritem.Nickname;
        end
    else begin
        txtFrom.Caption := jid;
        Self.Caption := sMessageFrom + jid;
        end;
    tmp_jid.Free();
end;


end.

