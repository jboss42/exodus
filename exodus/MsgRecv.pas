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
    Buttons, TntStdCtrls;

type
  TfrmMsgRecv = class(TfrmDockable)
    frameButtons1: TframeButtons;
    pnlFrom: TPanel;
    StaticText1: TStaticText;
    txtFrom: TStaticText;
    pnlSubject: TPanel;
    StaticText3: TStaticText;
    pnlReply: TPanel;
    frameButtons2: TframeButtons;
    Splitter1: TSplitter;
    txtMsg: TExRichEdit;
    pnlSendSubject: TPanel;
    Label1: TLabel;
    MsgOut: TExRichEdit;
    btnClose: TSpeedButton;
    txtSubject: TTntLabel;
    txtSendSubject: TTntMemo;
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
  private
    { Private declarations }
  public
    { Public declarations }
    eType: TJabberEventType;
    recips: TStringlist;

    procedure SetupSend();
  end;

var
  frmMsgRecv: TfrmMsgRecv;

function StartMsg(jid: WideString): TfrmMsgRecv;
function BroadcastMsg(jids: TWideStringlist): TfrmMsgRecv;

procedure ShowEvent(e: TJabberEvent);

resourcestring
    sRemove = 'Remove';
    sAccept = 'Accept';
    sDecline = 'Decline';
    sTo = 'To:';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    ShellAPI,
    ExUtils, JabberMsg,
    RemoveContact, RosterRecv, Room,
    Session, Jabber1;

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
            txtFrom.Caption := e.from;
            txtSubject.Caption := e.data_type;
            txtMsg.InputFormat := ifUnicode;
            txtMsg.WideText := e.Data.Text;

            if eType = evt_Invite then begin
                // Change button captions for TC Invites
                frameButtons1.btnOK.Caption := sAccept;
                frameButtons1.btnCancel.Caption := sDecline;
                end

            else
                // normally, we don't want a REPLY button
                frameButtons1.btnOK.Visible := (eType = evt_Message);

            ShowDefault;
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

        txtFrom.Caption := jid;
        ShowDefault;
        btnClose.Visible := Docked;
        FormResize(nil);
        txtSendSubject.SetFocus();
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
    recips := TStringlist.Create();
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
    StaticText1.Caption := sTo;
    btnClose.Visible := Docked;
end;

{---------------------------------------}
procedure TfrmMsgRecv.FormResize(Sender: TObject);
begin
    // Resize some of the form element
    btnClose.Left := Self.ClientWidth - btnClose.Width - 2;
    txtFrom.Width := pnlFrom.Width - btnClose.Width - StaticText1.Width - 5;
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


procedure TfrmMsgRecv.FormEndDock(Sender, Target: TObject; X, Y: Integer);
begin
  inherited;
    btnClose.Visible := Docked;
end;

end.

