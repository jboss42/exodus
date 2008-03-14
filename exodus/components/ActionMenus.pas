unit ActionMenus;

interface

uses Classes, Menus, TntMenus, Exodus_TLB;

type TExActionPopupMenu = class(TTntPopupMenu)
private
    _actCtrl: IExodusActionController;
    _actMap: IExodusActionMap;
    _targets: IExodusItemList;

    procedure SetTargets(targets: IExodusItemList);

    procedure rebuild;
    function createTypedMenu(actList: IExodusTypedActions; parent: TMenuItem): Integer;

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
var
    mi: TExActionMenuItem;
begin
    mi := TExActionMenuItem(sender);

    _actMap.GetActionsFor(mi.ItemType).execute(mi.ActionName);
end;

procedure TExActionPopupMenu.rebuild;
var
    mainActs, grpActs, typedActs: IExodusTypedActions;
    itemtype: Widestring;
    idx, typeCount, miCount: Integer;
    mi: TTntMenuItem;
begin
    typeCount := 0;
    miCount := 0;

    Items.Clear();
    mainActs := _actMap.GetActionsFor('');
    if (mainActs <> nil) then Dec(typeCount);

    grpActs := _actMap.GetActionsFor('group');
    if (grpActs <> nil) then Dec(typeCount);

    typeCount := typeCount + _actMap.TypedActionsCount;
    if (typeCount > 1) then begin
        for idx := 0 to _actMap.TypedActionsCount - 1 do begin
            typedActs := _actMap.TypedActions[idx];
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
end;
function TExActionPopupMenu.createTypedMenu(actList: IExodusTypedActions; parent: TMenuItem): Integer;
var
    idx: Integer;
    act: IExodusAction;
    mi: TExActionMenuItem;
begin
    for idx := 0 to actList.ActionCount - 1 do begin
        act := actlist.Action[idx];
        mi := TExActionMenuItem.Create(parent);

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
