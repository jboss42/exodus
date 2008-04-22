unit ActionMenus;

interface

uses Classes, Menus, TntMenus, Exodus_TLB;

type TExActionPopupMenu = class(TTntPopupMenu)
private
    _actCtrl: IExodusActionController;
    _actMap: IExodusActionMap;
    _targets: IExodusItemList;
    _splitIdx: Integer;

    procedure SetTargets(targets: IExodusItemList);

    procedure rebuild;
    function createTypedMenu(actList: IExodusTypedActions; parent: TMenuItem; offset: Integer = -1): Integer;
    function createSubMenu(itemtype: Widestring; act: IExodusAction; parent: TMenuItem): Integer;

protected
    procedure HandleClick(Sender: TObject);

public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Popup(X, Y: Integer); override;

    property Targets: IExodusItemList read _targets write SetTargets;
    property ActionController: IExodusActionController read _actCtrl write _actCtrl;
end;

procedure Register;

implementation

uses SysUtils, TntComCtrls, gnugettext, Variants, Unicode;

type TExActionMenuItem = class(TTntMenuItem)
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
constructor TExActionMenuItem.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
end;
destructor TExActionMenuItem.Destroy;
begin
    inherited;
end;

{

}
constructor TExActionPopupMenu.Create(AOwner: TComponent);
begin
    inherited;
end;
destructor TExActionPopupMenu.Destroy;
begin
    Targets := nil;

    inherited;
end;

procedure TExActionPopupMenu.SetTargets(targets: IExodusItemList);
begin
    if (targets <> _targets) then begin
        _actMap := nil;
        _targets := targets;
    end;
end;

procedure TExActionPopupMenu.HandleClick(Sender: TObject);
begin
    with TExActionMenuItem(sender) do begin
        _actMap.GetActionsFor(ItemType).execute(ActionName);
    end;
end;

procedure TExActionPopupMenu.rebuild;
var
    mainActs, grpActs, typedActs: IExodusTypedActions;
    itemtype: Widestring;
    idx, typeCount, miCount: Integer;
    mi: TTntMenuItem;
begin
    typeCount := _actMap.TypedActionsCount;
    miCount := 0;

    //Clear out the old (but not the static items)
    if (_splitIdx > 0) then begin
        for idx := _splitIdx - 1 downto 0 do begin
            Items.Delete(idx);
        end;
    end;

    //Remember the main actions...
    mainActs := _actMap.GetActionsFor('');
    if (mainActs <> nil) then Dec(typeCount);

    //Remember group actions...
    grpActs := _actMap.GetActionsFor('group');
    if (grpActs <> nil) then Dec(typeCount);

    //build type-specific actions
    if (typeCount > 1) then begin
        for idx := 0 to _actMap.TypedActionsCount - 1 do begin
            typedActs := _actMap.TypedActions[idx];
            itemtype := typedActs.ItemType;

            if (itemtype = '') or (itemtype = 'group') then continue;

            //TODO:  better item type captions!
            mi := TExActionMenuItem.Create(Items);
            mi.Caption := _(itemtype + 's');
            Items.Insert(0, mi);
            createTypedMenu(typedActs, mi, miCount);
            Inc(miCount);
        end;
    end
    else if (typeCount = 1) then begin
        //treat the "only" type-specific actions as the main actions
        for idx := 0 to _actMap.TypedActionsCount - 1 do begin
            typedActs := _actMap.TypedActions[idx];
            itemtype := typedActs.ItemType;

            if (itemtype = '') or (itemtype = 'group') then continue;

            mainActs := typedActs;
        end;
    end
    else if (typeCount = 0) then begin
        //We didn't get anything other than main actions and/or group actions
        if (mainActs = nil) or (mainActs.ActionCount = 0) then begin
            mainActs := grpActs;
            grpActs := nil;
        end;
    end;

    //build main actions
    if (mainActs <> nil) and (mainActs.ActionCount > 0) then begin
        //check to see if we need a separator
        if (miCount > 0) then begin
            if not Items.Items[miCount - 1].IsLine then begin
                mi := TTntMenuItem.Create(Items);
                mi.Caption := '-';
                Items.Insert(miCount, mi);
                Inc(miCount);
            end;
        end;

        miCount := miCount + createTypedMenu(mainActs, Items, miCount);
    end;

    //build group actions
    if (grpActs <> nil) and (grpActs.ActionCount > 0) then begin
        //check to see if we need a separator
        if (miCount > 0) then begin
            if not Items.Items[miCount - 1].IsLine then begin
                mi := TTntMenuItem.Create(Items);
                mi.Caption := '-';
                Items.Insert(miCount, mi);
                Inc(miCount);
            end;
        end;

        miCount := miCount + createTypedMenu(grpActs, Items, miCount);
    end;

    if (miCount <> Items.Count) then begin
        //add splitter between dynamic and static actions
        mi := TTntMenuItem.Create(Items);
        mi.Caption := '-';
        Items.Insert(miCount, mi);
    end;

    //Remember where we're at...
    _splitIdx := miCount;
end;

function TExActionPopupMenu.createTypedMenu(
        actList: IExodusTypedActions;
        parent: TMenuItem;
        offset: Integer): Integer;
var
    idx: Integer;
    act: IExodusAction;
    mi: TExActionMenuItem;
begin
    if (offset < 0) or (offset > parent.Count) then
        offset := parent.Count;

    for idx := 0 to actList.ActionCount - 1 do begin
        act := actlist.Action[idx];
        mi := TExActionMenuItem.Create(parent);

        mi.ItemType := actList.ItemType;
        mi.ActionName := act.Name;
        mi.Caption := act.Caption;
        mi.ImageIndex := act.ImageIndex;

        if createSubMenu(actList.ItemType, act, mi) = 0 then
            mi.OnClick := HandleClick;

        parent.Insert(offset, mi);
        Inc(offset);
    end;

    Result := actList.ActionCount;
end;
function TExActionPopupMenu.createSubMenu(
        itemtype: Widestring;
        act: IExodusAction;
        parent: TMenuItem): Integer;
var
    idx, amt: Integer;
    subact: IExodusAction;
    mi: TExActionMenuItem;
begin
    amt := act.SubActionCount;
    Result := amt;

    for idx := 0 to amt - 1 do begin
        subact := act.SubAction[idx];
        mi := TExActionMenuItem.Create(parent);

        mi.ItemType := itemtype;
        mi.ActionName := subact.Name;
        mi.Caption := subact.Caption;
        mi.ImageIndex := subact.ImageIndex;

        if createSubMenu(itemtype, subact, mi) = 0 then
            mi.OnClick := HandleClick;

        parent.Add(mi);
    end;
end;

procedure TExActionPopupMenu.Popup(X: Integer; Y: Integer);
begin
    _actMap := ActionController.buildActions(Targets);
    rebuild;

    inherited Popup(X, Y);
end;

procedure Register;
begin
    RegisterComponents('Exodus Components', [TExActionPopupMenu]);
end;

end.
