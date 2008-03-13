unit ActionMenus;

interface

uses Classes, Menus, TntMenus, ExTreeView, Exodus_TLB;

type TActionPopupMenu = class(TTntPopupMenu)
private
    _actMap: IExodusActionMap;

    function createTypedMenu(actList: IExodusTypedActions; parent: TMenuItem): Integer;

protected
    procedure HandleClick(Sender: TObject);

public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Popup(X, Y: Integer); override;
end;

implementation

uses Session, SysUtils, COMExodusItem, COMExodusItemList, ExActionCtrl,
        TntComCtrls, gnugettext, Variants, Unicode;

type TSelectionBuilder = class
private
    _tree: TExTreeView;
    _items: IExodusItemList;

    procedure buildFromNode(node: TTntTreeNode);

public
    constructor Create(tv: TExTreeView);
    destructor Destroy; override;

    property Items: IExodusItemList read _items;
end;
type TActionMenuItem = class(TTntMenuItem)
private
    _itemtype: Widestring;
    _actname: Widestring;

public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ItemType: Widestring read _itemtype write _itemtype;
    property ActionName: Widestring read _actname write _actname;
end;

{

}
constructor TSelectionBuilder.Create(tv: TExTreeView);
var
    idx: Integer;
    node: TTntTreeNode;
begin
    inherited Create;

    _tree := tv;
    _items := TExodusItemList.Create;

    for idx := 0 to _tree.SelectionCount - 1 do begin
        node := _tree.Selections[idx];

        buildFromNode(node);
    end;
end;
destructor TSelectionBuilder.Destroy;
begin
    _items := nil;

    inherited Destroy;
end;

procedure TSelectionBuilder.buildFromNode(node: TTntTreeNode);
var
    idx: Integer;
    item: IExodusItem;
begin
    item := IExodusItem(node.Data);
    if item = nil then begin
        //Group -- walk the kids
        for idx := 0 to node.Count - 1 do begin
            buildFromNode(node.Item[idx]);
        end;
    end else if item.IsVisible then begin
        _items.Add(item);
    end;
end;

{

}
constructor TActionMenuItem.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
end;
destructor TActionMenuItem.Destroy;
begin
    inherited;
end;


{

}
constructor TActionPopupMenu.Create(AOwner: TComponent);
begin
    inherited;
end;
destructor TActionPopupMenu.Destroy;
begin
    inherited;
end;

procedure TActionPopupMenu.HandleClick(Sender: TObject);
var
    mi: TActionMenuItem;
begin
    mi := TActionMenuItem(sender);

    _actMap.GetActionsFor(mi.ItemType).execute(mi.ActionName);
end;

function TActionPopupMenu.createTypedMenu(actList: IExodusTypedActions; parent: TMenuItem): Integer;
var
    idx: Integer;
    act: IExodusAction;
    mi: TActionMenuItem;
begin
    for idx := 0 to actList.ActionCount - 1 do begin
        act := actlist.Action[idx];
        mi := TActionMenuItem.Create(parent);

        mi.ItemType := actList.ItemType;
        mi.ActionName := act.Name;
        mi.Caption := act.Caption;
        mi.ImageIndex := act.ImageIndex;
        mi.OnClick := HandleClick;

        parent.Add(mi);

        //TODO:  subactions...
    end;

    Result := actList.ActionCount;
end;

procedure TActionPopupMenu.Popup(X: Integer; Y: Integer);
var
    tv: TExTreeView;
    idx, typeCount, miCount: Integer;
    selected: TSelectionBuilder;
    actmap: IExodusActionMap;
    itemType: Widestring;
    typedActs, mainActs, grpActs: IExodusTypedActions;
    mi: TTntMenuItem;
begin
    _actMap := nil;
    
    tv := TExTreeView(Self.Owner);

    selected := TSelectionBuilder.Create(tv);
    actmap := GetActionController().buildActions(selected.Items);
    typeCount := 0;
    miCount := 0;

    //build menus
    Items.Clear();
    mainActs := actmap.GetActionsFor('');
    if (mainActs <> nil) then Dec(typeCount);
    
    grpActs := actmap.GetActionsFor('group');
    if (grpActs <> nil) then Dec(typeCount);

    typeCount := typeCount + actmap.TypedActionsCount;
    if (typeCount > 1) then begin
        for idx := 0 to actmap.TypedActionsCount - 1 do begin
            typedActs := actmap.TypedActions[idx];
            itemtype := typedActs.ItemType;

            if (itemtype = '') or (itemtype = 'group') then continue;
            
            //TODO:  better item type captions!
            mi := TTntMenuItem.Create(Items);
            mi.Caption := _(itemtype + 's');
            Items.Add(mi);
            miCount := miCount + createTypedMenu(typedActs, mi);
        end;
    end;

    if (mainActs <> nil) and (mainActs.ActionCount > 0) then begin
        //check to see if we need a separator
        if (miCount > 0) then begin
            if not Items.Items[miCount - 1].IsLine then begin
                mi := TTntMenuItem.Create(Items);
                mi.Caption := '-';
                Items.Add(mi);
                Inc(miCount);
            end;
        end;

        createTypedMenu(mainActs, Items);
    end;
    if (grpActs <> nil) and (typeCount >= 0) and (grpActs.ActionCount > 0) then begin
        //check to see if we need a separator
        if (miCount > 0) then begin
            if not Items.Items[miCount - 1].IsLine then begin
                mi := TTntMenuItem.Create(Items);
                mi.Caption := '-';
                Items.Add(mi);
                Inc(miCount);
            end;
        end;

        createTypedMenu(grpActs, Items);
    end;
        
    _actMap := actmap;

    inherited Popup(X, Y);

    selected.Free;
end;

end.
