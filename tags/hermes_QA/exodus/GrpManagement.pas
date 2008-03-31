unit GrpManagement;
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, buttonFrame, ExForm, TntForms, ExFrame;

type
  TfrmGrpManagement = class(TExForm)
    frameButtons1: TframeButtons;
    optMove: TTntRadioButton;
    optCopy: TTntRadioButton;
    lstGroups: TTntListBox;
    procedure FormCreate(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    _items: TList;
  public
    { Public declarations }
    procedure setItems(items: TList);
  end;

var
  frmGrpManagement: TfrmGrpManagement;

function ShowGrpManagement(items: TList): TfrmGrpManagement;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    ContactController, Session, JabberUtils, ExUtils,  GnuGetText;

{---------------------------------------}
function ShowGrpManagement(items: TList): TfrmGrpManagement;
begin
    Result := TfrmGrpManagement.Create(Application);
    Result.setItems(items);
    Result.Show;
end;

{---------------------------------------}
procedure TfrmGrpManagement.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
        { TODO : Roster refactor }
    //MainSession.Roster.AssignGroups(lstGroups.Items);
    lstGroups.ItemIndex := lstGroups.Items.IndexOf(MainSession.Prefs.getString('roster_default'));
end;

{---------------------------------------}
procedure TfrmGrpManagement.setItems(items: TList);
begin
    _items := items;
end;

{---------------------------------------}
procedure TfrmGrpManagement.frameButtons1btnOKClick(Sender: TObject);
//var
//    new_grp: Widestring;
//    i: integer;
//    ritem: TJabberRosterItem;
begin
 { TODO : Roster refactor }
//    // Move or copy _items;
//    if ((_items = nil) or (_items.Count <= 0)) then begin
//        Self.Close();
//        exit;
//    end;
//
//    new_grp := lstGroups.Items[lstGroups.ItemIndex];
//    for i := 0 to _items.Count - 1 do begin
//        ritem := TJabberRosterItem(_items[i]);
//        if (optMove.Checked) then begin
//            ritem.ClearGroups();
//            ritem.AddGroup(new_grp);
//            ritem.Update();
//        end
//        else begin
//            if (not ritem.IsInGroup(new_grp)) then begin
//                ritem.AddGroup(new_grp);
//                ritem.Update();
//            end;
//        end;
//    end;

//    Self.Close();
end;

{---------------------------------------}
procedure TfrmGrpManagement.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

{---------------------------------------}
procedure TfrmGrpManagement.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmGrpManagement.FormDestroy(Sender: TObject);
begin
    if (_items <> nil) then FreeAndNil(_items);
end;

end.
