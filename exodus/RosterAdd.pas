unit RosterAdd;
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
  buttonFrame, StdCtrls;

type
  TfrmAdd = class(TForm)
    Label1: TLabel;
    txtJID: TEdit;
    Label2: TLabel;
    txtNickname: TEdit;
    Label3: TLabel;
    cboGroup: TComboBox;
    frameButtons1: TframeButtons;
    lblAddGrp: TLabel;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure lblAddGrpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure txtJIDExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdd: TfrmAdd;

function ShowAddContact: TfrmAdd;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberID,
    Presence,
    Session;
{$R *.DFM}
{---------------------------------------}
function ShowAddContact: TfrmAdd;
begin
    Result := TfrmAdd.Create(Application);
    Result.Show;
end;

{---------------------------------------}
procedure TfrmAdd.frameButtons1btnOKClick(Sender: TObject);
var
    sjid, snick, sgrp: string;
begin
    // Add the new roster item..
    sjid := txtJID.Text;
    snick := txtNickname.Text;
    sgrp := cboGroup.Text;

    MainSession.Roster.AddItem(sjid, snick, sgrp, true);
    Self.Close;
end;

{---------------------------------------}
procedure TfrmAdd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmAdd.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmAdd.lblAddGrpClick(Sender: TObject);
var
    ngrp: String;
begin
    // Add a new group to the list...
    ngrp := 'Untitled Group';
    if InputQuery('Add Group', 'New Group Name', ngrp) then begin
        MainSession.Roster.GrpList.Add(ngrp);
        cboGroup.Items.Assign(MainSession.Roster.GrpList);
        end;
end;

{---------------------------------------}
procedure TfrmAdd.FormCreate(Sender: TObject);
begin
    cboGroup.Items.Assign(MainSession.Roster.GrpList);
    if cboGroup.Items.Count > 0 then
        cboGroup.ItemIndex := 0;
end;

{---------------------------------------}
procedure TfrmAdd.txtJIDExit(Sender: TObject);
var
    tmp_id: TJabberID;
begin
    // add the nickname if it's not there.
    if (txtNickname.Text = '') then begin
        tmp_id := TJabberID.Create(txtJID.Text);
        txtNickname.Text := tmp_id.user;
        end;
end;

end.

