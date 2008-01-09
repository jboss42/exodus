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
  ComCtrls, 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fRosterTree, buttonFrame, Menus, StdCtrls, TntStdCtrls, ExtCtrls;

type
  TfrmSelContact = class(TForm)
    frameButtons1: TframeButtons;
    frameTreeRoster1: TframeTreeRoster;
    PopupMenu1: TPopupMenu;
    ShowOnlineOnly1: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    txtJID: TTntEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure frameTreeRoster1treeRosterDblClick(Sender: TObject);
    procedure ShowOnlineOnly1Click(Sender: TObject);
    procedure frameTreeRoster1treeRosterChange(Sender: TObject;
      Node: TTreeNode);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetSelectedJID(): Widestring;
  end;

var
  frmSelContact: TfrmSelContact;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    GnuGetText, Session, Roster;

{---------------------------------------}
procedure TfrmSelContact.FormCreate(Sender: TObject);
begin
    TranslateProperties(Self);
    frameTreeRoster1.Initialize();
    ShowOnlineOnly1.Checked := MainSession.Prefs.getBool('roster_only_online');
    frameTreeRoster1.DrawRoster(ShowOnlineOnly1.Checked);
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

    frameTreeRoster1treeRosterChange(Self, frameTreeRoster1.treeRoster.Selected);

    Self.ModalResult := mrOK;
    Self.Hide();
end;

{---------------------------------------}
function TfrmSelContact.GetSelectedJID(): Widestring;
begin
    Result := txtJid.Text;
end;

{---------------------------------------}
procedure TfrmSelContact.ShowOnlineOnly1Click(Sender: TObject);
begin
    // toggle online on/off
    ShowOnlineOnly1.Checked := not ShowOnlineOnly1.Checked;
    frameTreeRoster1.DrawRoster(ShowOnlineOnly1.Checked);
end;

{---------------------------------------}
procedure TfrmSelContact.frameTreeRoster1treeRosterChange(Sender: TObject;
  Node: TTreeNode);
begin
    if (Node = nil) then exit;
    if (Node.Level = 0) then exit;

    txtJid.Text := TJabberRosterItem(Node.Data).jid.full;
end;

end.
