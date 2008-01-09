unit Subscribe;
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, buttonFrame, ExtCtrls, Menus, TntStdCtrls;

type
  TfrmSubscribe = class(TForm)
    Label1: TLabel;
    chkSubscribe: TCheckBox;
    boxAdd: TGroupBox;
    frameButtons1: TframeButtons;
    Label2: TLabel;
    txtNickname: TEdit;
    Label3: TLabel;
    cboGroup: TComboBox;
    Bevel1: TBevel;
    PopupMenu1: TPopupMenu;
    mnuProfile: TMenuItem;
    mnuChat: TMenuItem;
    mnuMessage: TMenuItem;
    lblJID: TTntLabel;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuMessageClick(Sender: TObject);
    procedure mnuChatClick(Sender: TObject);
    procedure mnuProfileClick(Sender: TObject);
    procedure lblJIDClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSubscribe: TfrmSubscribe;

procedure CloseSubscribeWindows();

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    ChatWin, GnuGetText, JabberID, MsgRecv, Session, Profile, Presence;

var
    _subscribe_windows: TList;

{$R *.DFM}

{---------------------------------------}
procedure TfrmSubscribe.frameButtons1btnOKClick(Sender: TObject);
var
    sjid, snick, sgrp: string;
    p1: TJabberPres;
begin
    // send a subscribed and possible add..
    sjid := lblJID.Caption;
    snick := txtNickname.Text;
    sgrp := cboGroup.Text;

    p1 := TJabberPres.Create;
    p1.toJID := TJabberID.Create(sjid);
    p1.PresType := 'subscribed';
    MainSession.SendTag(p1);

    // do an iq-set
    if chkSubscribe.Checked then
        MainSession.Roster.AddItem(sjid, snick, sgrp, true);
    Self.Close;
end;

{---------------------------------------}
procedure TfrmSubscribe.frameButtons1btnCancelClick(Sender: TObject);
var
    p: TJabberPres;
    sjid: string;
begin
    sjid := lblJID.Caption;
    p := TJabberPres.Create;
    p.toJID := TJabberID.Create(sjid);
    p.PresType := 'unsubscribed';

    MainSession.SendTag(p);
    Self.Close;
end;

{---------------------------------------}
procedure TfrmSubscribe.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmSubscribe.mnuMessageClick(Sender: TObject);
begin
    StartMsg(lblJID.Caption);
end;

{---------------------------------------}
procedure TfrmSubscribe.mnuChatClick(Sender: TObject);
begin
    StartChat(lblJID.Caption, '', true);
end;

{---------------------------------------}
procedure TfrmSubscribe.mnuProfileClick(Sender: TObject);
begin
    // muh.  not exactly right, but at least it isn't *wrong*.
    ShowProfile(lblJID.Caption).FormStyle := fsStayOnTop;
end;

{---------------------------------------}
procedure TfrmSubscribe.lblJIDClick(Sender: TObject);
var
    cp: TPoint;
begin
    GetCursorPos(cp);
    PopupMenu1.popup(cp.x, cp.y);
end;

{---------------------------------------}
procedure TfrmSubscribe.FormCreate(Sender: TObject);
begin
    TranslateProperties(Self);

    _subscribe_windows.Add(Self);
end;

{---------------------------------------}
procedure TfrmSubscribe.FormDestroy(Sender: TObject);
var
    idx: integer;
begin
    idx := _subscribe_windows.IndexOf(Self);
    if (idx > -1) then
        _subscribe_windows.Delete(idx);
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure CloseSubscribeWindows();
var
    i: integer;
begin
    for i := 0 to _subscribe_windows.Count - 1 do
        TfrmSubscribe(_subscribe_windows[i]).Close();
end;

initialization
    _subscribe_windows := TList.Create();

finalization
    _subscribe_windows.Free();

end.
