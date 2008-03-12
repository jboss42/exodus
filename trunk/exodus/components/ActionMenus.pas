unit ActionMenus;

interface

uses Classes, TntMenus, Exodus_TLB;

type TActionPopupMenu = class(TTntPopupMenu)
private
    _actMap: IExodusActionMap;
protected
    procedure HandleClick(Sender: TObject);

public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure Popup(X, Y: Integer); override;
end;

implementation

uses COMExodusItemList, ExTreeView, ExActionCtrl, TntComCtrls;

type TActionMenuItem = class(TTntMenuItem)
private
    _itemtype: Widestring;
    _actname: Widestring;

public
    constructor Create(itemtype, actname: Widestring; AOwner: TComponent);
    destructor Destroy; override;

    property ItemType: Widestring read _itemtype;
    property ActionName: Widestring read _actname;
end;

constructor TActionMenuItem.Create(itemtype: WideString; actname: WideString; AOwner: TComponent);
begin
    inherited Create(AOwner);

    _itemtype := itemtype;
    _actname := actname;
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

procedure TActionPopupMenu.Popup(X: Integer; Y: Integer);
var
    tv: TExTreeView;
    idx: Integer;
    node: TTntTreeNode;
    selected: IExodusItemList;
    actmap: IExodusActionMap;
    actlist: IExodusTypedActions;
    act: IExodusAction;
    mi: TActionMenuItem;
begin
    tv := TExTreeView(Self.Owner);

    _actMap := nil;
    
    selected := TExodusItemList.Create;
    for idx := 0 to tv.SelectionCount - 1 do begin
        node := tv.Selections[idx];
        if (node.Data <> nil) then
            selected.Add(IExodusItem(node.Data));
    end;

    _actMap := GetActionController().buildActions(selected);
    //TODO: build menus
    Items.Clear();
    actlist := _actmap.GetActionsFor('');
    if (actlist = nil) then
        exit;
        
    for idx := 0 to actlist.ActionCount - 1 do begin
        act := actlist.Action[idx];
        mi := TActionMenuItem.Create(actlist.ItemType, act.Name, Items);

        mi.Caption := act.Caption;
        mi.ImageIndex := act.ImageIndex;
        mi.OnClick := HandleClick;

        Items.Add(mi);
    end;

    inherited Popup(X, Y);
end;

end.
