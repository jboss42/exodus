{
    Copyright 2008, Peter Millard

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
unit ExAllTreeView;

interface

uses SysUtils, Classes, ExTreeView, Exodus_TLB, Types, TntMenus;

type TExAllTreeView = class(TExTreeView)
private
    _mnuCopy: TTntMenuItem;
    _mnuMove: TTntMenuItem;
    _mnuDelete: TTntMenuItem;

protected
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure mnuMoveClick(Sender: TObject); virtual;
    procedure mnuCopyClick(Sender: TObject); virtual;
    procedure mnuDeleteClick(Sender: TObject); virtual;
public
    constructor Create(AOwner: TComponent; Session: TObject); override;
end;

implementation

uses ActionMenus, Graphics, ExActionCtrl, gnugettext, GrpManagement,
        COMExodusItemList, Session;

{---------------------------------------}
constructor TExAllTreeView.Create(AOwner: TComponent; Session: TObject);
var
    popup: TExActionPopupMenu;
    mi: TTntMenuItem;
begin
    inherited Create(AOwner, Session);

    popup := TExActionPopupMenu.Create(Self);
    popup.ActionController := GetActionController();
    
    mi := TTntMenuItem.Create(popup.Items);
    mi.Caption := _('Move...');
    mi.OnClick := mnuMoveClick;
    popup.Items.Add(mi);
    _mnuMove := mi;

    mi := TTntMenuItem.Create(popup.Items);
    mi.Caption := _('Copy...');
    mi.OnClick := mnuCopyClick;
    popup.Items.Add(mi);
    _mnuCopy := mi;

    mi := TTntMenuItem.Create(popup.Items);
    mi.Caption := _('Delete');
    mi.OnClick := mnuDeleteClick;
    popup.Items.Add(mi);
    _mnuDelete := mi;

    PopupMenu := popup;
end;
procedure TExAllTreeView.DoContextPopup(MousePos: TPoint; var Handled: Boolean);
var
    actPM: TExActionPopupMenu;
    items: IExodusItemList;
    idx: Integer;
    pt: TPoint;
begin
    if Assigned(PopupMenu) and PopupMenu.InheritsFrom(TExActionPopupMenu) then begin
        actPM := TExActionPopupMenu(PopupMenu);
        actPM.Targets := GetSelectedItems();
        _mnuCopy.Visible := (SelectionCount > 0);
        _mnuMove.Visible := (SelectionCount > 0);
        _mnuDelete.Visible := (SelectionCount = 1);

        if InvalidPoint(MousePos) then
            pt := Point(0,0)
        else
            pt := MousePos;

        pt := ClientToScreen(pt);
        actPM.Popup(pt.X, pt.Y);

        Handled := true;
    end;
end;

procedure TExAllTreeView.mnuMoveClick(Sender: TObject);
var
    idx: Integer;
    items: IExodusItemList;
begin
    items := TExodusItemList.Create();
    for idx := 0 to SelectionCount - 1 do
        items.Add(IExodusItem(Selections[idx].Data));
        
    ShowGrpManagement(items, tgoMove);
end;
procedure TExAllTreeView.mnuCopyClick(Sender: TObject);
var
    idx: Integer;
    items: IExodusItemList;
begin
    items := TExodusItemList.Create();
    for idx := 0 to SelectionCount - 1 do
        items.Add(IExodusItem(Selections[idx].Data));

    ShowGrpManagement(items, tgoCopy);
end;
procedure TExAllTreeView.mnuDeleteClick(Sender: TObject);
var
    item: IExodusItem;
begin
    if (Selected = nil) or (Selected.Data = nil) then exit;

    item := IExodusItem(Selected.Data);
    if (item.Type_ = 'group') then begin
        //TODO:  show group remove
    end
    else begin
        //TODO:  show other remove
    end;
end;

end.
