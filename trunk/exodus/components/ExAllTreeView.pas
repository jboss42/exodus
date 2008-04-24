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
        COMExodusItemList, Session, TntComCtrls, Windows;

const
    sConfirmDeleteCaption: Widestring = 'Delete Items';
    sConfirmDeleteSingleTxt: Widestring = 'Are you sure you want to delete %s?';
    sConfirmDeleteMultiTxt: Widestring = 'Are you sure you want to delete these %d items?';
    sWarnSingleNotDeletedTxt: Widestring = 'The group %s is not empty and could not be deleted.' + #13#10 + 'Make sure all items in the group are removed, then try again.';
    sWarnMultiNotDeletedTxt: Widestring = '%d groups are not empty and could not be deleted.' + #13#10 + 'Make sure all items in the groups areremoved, then try again.';

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
    pt: TPoint;
begin
    if Assigned(PopupMenu) and PopupMenu.InheritsFrom(TExActionPopupMenu) then begin
        actPM := TExActionPopupMenu(PopupMenu);
        actPM.Targets := GetSelectedItems();
        _mnuCopy.Visible := (SelectionCount > 0);
        _mnuMove.Visible := (SelectionCount > 0);
        _mnuDelete.Visible := (SelectionCount > 0);

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
    ops: TList;
    path, msg, uid: Widestring;
    idx, jdx, rst: Integer;
    itemCtrl: IExodusItemController;
    postitems, collateralitems: IExodusItemList;
    item: IExodusItem;
    node: TTntTreeNode;

    function EmptyGroup(gpath: Widestring): Boolean;
    var
        idx: Integer;
        subitems: IExodusItemList;
    begin
        Result := true;
        subitems := itemCtrl.GetGroupItems(gpath);
        for idx := 0 to subitems.Count - 1 do begin
            if (subitems.Item[idx].Type_ = 'group') then
                Result := EmptyGroup(subitems.Item[idx].UID)
            else
                Result := false;

            if not Result then exit;
        end;
    end;
begin
    //confirm
    case SelectionCount of
        0: exit;
        1: msg := WideFormat(_(sConfirmDeleteSingleTxt), [Selections[0].Text]);
    else
        msg := WideFormat(_(sConfirmDeleteMultiTxt), [SelectionCount]);
    end;

    rst := MessageBoxW(Self.Handle,
            PWideChar(msg),
            PWideChar(_(sConfirmDeleteCaption)),
            MB_ICONQUESTION or MB_YESNO);
    if (rst <> IDYES) then exit;

    ops := TList.Create();
    for idx := 0 to SelectionCount - 1 do
        ops.Add(Pointer(Selections[idx]));

    //process non-groups
    itemCtrl := TJabberSession(Session).ItemController;
    postitems := TExodusItemList.Create();
    for idx := 0 to ops.Count - 1 do begin
        node := TTntTreeNode(ops[idx]);
        if (node.Data = nil) then continue;

        item := IExodusItem(node.Data);
        if (item.Type_ = 'group') then
            postitems.Add(item)
        else begin
            if (item.GroupCount > 1) then begin
                //TODO:  remove from group (parent node)
                path := GetNodePath(node.Parent);
                item.RemoveGroup(path);
            end
            else begin
                //remove from existence!
                itemCtrl.RemoveItem(item.UID);
            end;
        end;
    end;

    //process groups
    collateralitems := TExodusItemList.Create();
    for idx := postitems.Count - 1 downto 0 do begin
        collateralitems.Clear();
        item := postitems.Item[idx];

        //validate target is empty
        if not EmptyGroup(item.UID) then continue;

        //delete collateral groups
        for jdx := 0 to collateralitems.Count - 1 do begin
            itemCtrl.RemoveItem(collateralitems.Item[idx].UID);
        end;

        //delete target group
        postitems.Delete(idx);
        itemCtrl.RemoveItem(item.UID);
    end;

    //alert
    if postitems.Count > 0 then begin
        case postitems.Count of
            1: msg := WideFormat(_(sWarnSingleNotDeletedTxt), [postitems.Item[0].Text]);
        else
            msg := WideFormat(_(sWarnMultiNotDeletedTxt), [postitems.Count]);
        end;
        MessageBoxW(Self.Handle,
            PWideChar(msg),
            PWideChar(_(sConfirmDeleteCaption)),
            MB_OK or MB_ICONWARNING);
    end;
end;

end.
