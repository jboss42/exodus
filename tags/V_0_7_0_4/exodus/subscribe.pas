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
  StdCtrls, buttonFrame, ExtCtrls;

type
  TfrmSubscribe = class(TForm)
    lblJID: TStaticText;
    Label1: TLabel;
    chkSubscribe: TCheckBox;
    boxAdd: TGroupBox;
    frameButtons1: TframeButtons;
    Label2: TLabel;
    txtNickname: TEdit;
    Label3: TLabel;
    cboGroup: TComboBox;
    Bevel1: TBevel;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblJIDClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSubscribe: TfrmSubscribe;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberID,
    Session,
    Profile,
    Presence;

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
procedure TfrmSubscribe.lblJIDClick(Sender: TObject);
begin
    // muh.  not exactly right, but at least it isn't *wrong*.
    ShowProfile(lblJID.Caption).FormStyle := fsStayOnTop;
end;

end.
