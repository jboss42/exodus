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
    buttonFrame, StdCtrls, ComCtrls, Grids, ExtCtrls, ExRichEdit,
    OLERichEdit;

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
    recips: TStringlist;

    procedure SetupSend();
  end;

var
  frmMsgRecv: TfrmMsgRecv;

function StartMsg(jid: string): TfrmMsgRecv;
function BroadcastMsg(jids: TStringlist): TfrmMsgRecv;

procedure ShowEvent(e: TJabberEvent);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    ShellAPI,
    ExUtils, JabberMsg,
    RosterRecv, Room,
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
        fcts := TfrmRosterRecv.Create(nil);
        fcts.Restore(e);
        end
    else begin
        // other things
        fmsg := TfrmMsgRecv.Create(nil);
        with fmsg do begin
            eType := e.eType;
            txtFrom.Caption := e.from;
            txtSubject.Caption := e.data_type;
            txtMsg.Lines.Assign(e.Data);

            if eType = evt_Invite then begin
                // Change button captions for TC Invites
                frameButtons1.btnOK.Caption := 'Accept';
                frameButtons1.btnCancel.Caption := 'Decline';
                end
            else
                // normally, we don't want a REPLY button
                frameButtons1.btnOK.Visible := (eType = evt_Message);

            ShowDefault;
            end;
        end;
    end;
end;

{---------------------------------------}
function BroadcastMsg(jids: TStringlist): TfrmMsgRecv;
var
    i: integer;
begin
    // send a normal msg to this person
    Result := TfrmMsgRecv.Create(nil);
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
        end;
end;

{---------------------------------------}
function StartMsg(jid: string): TfrmMsgRecv;
begin
    // send a normal msg to this person
    Result := TfrmMsgRecv.Create(nil);
    with Result do begin
        eType := evt_Message;

        // setup the form for sending a msg
        SetupSend();
        recips.Add(jid);

        txtFrom.Caption := jid;
        ShowDefault;
        end;
end;

{---------------------------------------}
procedure TfrmMsgRecv.FormCreate(Sender: TObject);
begin
    // pre-fill parts of the header grid
    AssignDefaultFont(txtMsg.Font);
    txtMsg.Color := TColor(MainSession.Prefs.getInt('color_bg'));
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
    StaticText1.Caption := 'To: ';
end;

{---------------------------------------}
procedure TfrmMsgRecv.FormResize(Sender: TObject);
begin
    // Resize some of the form elements
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

{---------------------------------------}
procedure TfrmMsgRecv.frameButtons2btnOKClick(Sender: TObject);
var
    m: TJabberMessage;
    s: string;
    i: integer;
begin
    // Send the outgoing msg
    if (pnlSendSubject.Visible) then
        s := txtSendSubject.Lines.Text
    else
        s := txtSubject.Caption;

    // send to ALL recips
    for i := 0 to recips.Count - 1 do begin
        m := TJabberMessage.Create(recips[i], '', MsgOut.Lines.Text, s);
        MainSession.SendTag(m.Tag);
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

end.

