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
    Dockable, 
    ExEvents,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls, ComCtrls, Grids, ExtCtrls, ExRichEdit;

type
  TfrmMsgRecv = class(TfrmDockable)
    frameButtons1: TframeButtons;
    pnlFrom: TPanel;
    StaticText1: TStaticText;
    txtFrom: TStaticText;
    pnlSubject: TPanel;
    StaticText3: TStaticText;
    txtSubject: TStaticText;
    pnlReply: TPanel;
    MsgOut: TRichEdit;
    frameButtons2: TframeButtons;
    Splitter1: TSplitter;
    txtMsg: TExRichEdit;
    pnlSendSubject: TPanel;
    Label1: TLabel;
    txtSendSubject: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons2btnOKClick(Sender: TObject);
    procedure frameButtons2btnCancelClick(Sender: TObject);
    procedure txtMsgURLClick(Sender: TObject; url: String);
  private
    { Private declarations }
  public
    { Public declarations }
    eType: TJabberEventType;
  end;

var
  frmMsgRecv: TfrmMsgRecv;

function StartMsg(jid: string): TfrmMsgRecv;
function ShowEvent(e: TJabberEvent): TfrmMsgRecv;

implementation
uses
    ShellAPI, 
    JabberMsg,
    Room,
    Session;

{$R *.DFM}

function ShowEvent(e: TJabberEvent): TfrmMsgRecv;
begin
    // display this msg in a new window
    Result := TfrmMsgRecv.Create(nil);
    with Result do begin
        eType := e.eType;
        txtFrom.Caption := e.from;
        txtSubject.Caption := e.data_type;
        txtMsg.Lines.Assign(e.Data);

        if eType = evt_Invite then begin
            frameButtons1.btnOK.Caption := 'Accept';
            frameButtons1.btnCancel.Caption := 'Decline';
            end;
        ShowDefault;
        end;
end;

function StartMsg(jid: string): TfrmMsgRecv;
begin
    // send a normal msg to this person
    Result := TfrmMsgRecv.Create(nil);
    with Result do begin
        eType := evt_Message;

        // setup the form for sending a msg
        txtFrom.Caption := jid;
        pnlSubject.Visible := false;
        pnlSendSubject.Visible := true;
        frameButtons1.Visible := false;
        txtMsg.Visible := false;
        pnlReply.Visible := true;
        pnlReply.Align := alClient;
        ShowDefault;
        end;
end;

procedure TfrmMsgRecv.FormCreate(Sender: TObject);
begin
    // pre-fill parts of the header grid
    with MainSession.Prefs do begin
        txtMsg.Font.Name := getString('font_name');
        txtMsg.Font.Size := getInt('font_size');
        txtMsg.Font.Style := [];
        txtMsg.Color := TColor(getInt('color_bg'));
        txtMsg.Font.Color := TColor(getInt('font_color'));
        if getBool('font_bold') then
            txtMsg.Font.Style := txtMsg.Font.Style + [fsBold];
        if getBool('font_italic') then
            txtMsg.Font.Style := txtMsg.Font.Style + [fsItalic];
        if getBool('font_underline') then
            txtMsg.Font.Style := txtMsg.Font.Style + [fsUnderline];
        end;
    Self.ClientHeight := 200;
end;

procedure TfrmMsgRecv.FormResize(Sender: TObject);
begin
    // Resize some of the form elements
end;

procedure TfrmMsgRecv.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmMsgRecv.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmMsgRecv.frameButtons1btnOKClick(Sender: TObject);
var
    jid: string;
begin
    // Do something...
    if eType = evt_Invite then begin
        // join this grp... grp is in the subject
        jid := txtSubject.Caption;
        StartRoom(jid, MainSession.Username);
        Self.Close;
        end
    else begin
        Self.ClientHeight := Self.ClientHeight + pnlReply.Height - frameButtons1.Height - 3;
        frameButtons1.Visible := false;
        pnlReply.Visible := true;
        MsgOut.SetFocus;
        end;
end;

procedure TfrmMsgRecv.frameButtons2btnOKClick(Sender: TObject);
var
    m: TJabberMessage;
    s: string;
begin
    // Send the outgoing msg
    if (pnlSendSubject.Visible) then
        s := txtSendSubject.Lines.Text
    else
        s := txtSubject.Caption;
    m := TJabberMessage.Create(txtFrom.Caption, '', MsgOut.Lines.Text, s);
    MainSession.SendTag(m.Tag);
    Self.Close;
end;

procedure TfrmMsgRecv.frameButtons2btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmMsgRecv.txtMsgURLClick(Sender: TObject; url: String);
begin
    ShellExecute(0, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

end.

