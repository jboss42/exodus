unit SelContact;
{
    Copyright 2002, Peter Millard

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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fRosterTree, buttonFrame;

type
  TfrmSelContact = class(TForm)
    frameButtons1: TframeButtons;
    frameTreeRoster1: TframeTreeRoster;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure frameTreeRoster1treeRosterDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetSelectedJID(): string;
  end;

var
  frmSelContact: TfrmSelContact;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    Roster, ComCtrls;

{---------------------------------------}
procedure TfrmSelContact.FormCreate(Sender: TObject);
begin
    frameTreeRoster1.Initialize();
end;

{---------------------------------------}
procedure TfrmSelContact.FormDestroy(Sender: TObject);
begin
    frameTreeRoster1.Cleanup();
end;

{---------------------------------------}
procedure TfrmSelContact.frameTreeRoster1treeRosterDblClick(
  Sender: TObject);
begin
    if (frameTreeRoster1.treeRoster.Selected = nil) then exit;
    if (frameTreeRoster1.treeRoster.Selected.Level = 0) then exit;

    Self.ModalResult := mrOK;
    Self.Hide();
end;

{---------------------------------------}
function TfrmSelContact.GetSelectedJID(): string;
var
    n: TTreeNode;
begin
    Result := '';
    n := frameTreeRoster1.treeRoster.Selected;
    if (n = nil) then exit;
    if (n.Level = 0) then exit;

    Result := TJabberRosterItem(n.Data).jid.full;
end;

end.
