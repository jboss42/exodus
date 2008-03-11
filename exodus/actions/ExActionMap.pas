unit ExActionMap;

interface

uses ActiveX, ComObj, Classes, Contnrs, ExActions, Exodus_TLB;

type TExodusTypedActions = class(TAutoIntfObject, IExodusTypedActions)
private
    _actMap: IExodusActionMap;
    _itemtype: Widestring;
    _actions: TInterfaceList;

public
    constructor Create(actmap: IExodusActionMap; itemtype: Widestring);
    destructor Destroy; override;

    function Get_ItemType: Widestring; safecall;
    function Get_ItemCount: Integer; safecall;
    function Get_Item(idx: Integer): IExodusItem; safecall;

    function Get_ActionCount: Integer; safecall;
    function Get_Action(idx: Integer): IExodusAction; safecall;
    function IndexOfAction(act: IExodusAction): Integer;
    procedure AddAction(act: IExodusAction);
    procedure Clear;

    function GetActionNamed(const name: Widestring): IExodusAction; safecall;
    procedure execute(const actname: Widestring); safecall;
end;

type TExodusActionMap = class(TAutoIntfObject, IExodusActionMap)
private
    _items: IExodusItemList;
    _actLists: TInterfaceList;
    _allActs: TInterfaceList;

public
    constructor Create(items: IExodusItemList);
    destructor Destroy; override;

    function Get_ItemCount: Integer; safecall;
    function Get_Item(idx: Integer): IExodusItem; safecall;
    function Get_TypedActionsCount: Integer; safecall;
    function Get_TypedActions(idx: Integer): IExodusTypedActions; safecall;

    procedure AddAction(itemtype: Widestring; act: IExodusAction);
    procedure Collate;

    function GetActionsFor(const itemtype: Widestring): IExodusTypedActions; safecall;
    function GetActionNamed(const name: Widestring): IExodusAction; safecall;
end;

implementation

uses SysUtils, ComServ, COMExodusItemList;

{
    TTypedActions implementation
}

constructor TExodusTypedActions.Create(actmap: IExodusActionMap; itemtype: WideString);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusTypedActions);

    _actMap := actmap;
    _itemtype := itemtype;
    _actions := TInterfaceList.Create;
end;
destructor TExodusTypedActions.Destroy;
begin
    _actions := nil;

    inherited;
end;

function TExodusTypedActions.Get_ItemType: Widestring;
begin
    Result := _itemtype;
end;

function TExodusTypedActions.Get_ItemCount: Integer;
begin
    Result := 0;
end;
function TExodusTypedActions.Get_Item(idx: Integer): IExodusItem;
begin
    Result := nil;
end;

function TExodusTypedActions.Get_ActionCount: Integer;
begin
    Result := _actions.Count;
end;
function TExodusTypedActions.Get_Action(idx: Integer): IExodusAction;
begin
    Result := IExodusAction(_actions[idx]);
end;
function TExodusTypedActions.IndexOfAction(act: IExodusAction): Integer;
begin
    Result := _actions.IndexOf(act);
end;
procedure TExodusTypedActions.AddAction(act: IExodusAction);
begin
    _actions.Add(act);
end;
procedure TExodusTypedActions.Clear;
begin
    _actions.Clear;
end;

function TExodusTypedActions.GetActionNamed(const name: WideString): IExodusAction;
var
    idx: Integer;
begin
    for idx := 0 to _actions.Count - 1 do begin
        Result := IExodusAction(_actions[idx]);

        if Result.Name = name then exit;
        Result := nil;
    end;
end;
procedure TExodusTypedActions.execute(const actname: Widestring);
var
    act: IExodusAction;
    items: IExodusItemList;
    item: IExodusItem;
    idx: Integer;
begin
    act := GetActionNamed(actname);
    if (act = nil) then exit;

    items := TExodusItemList.Create();
    for idx := 0 to _actMap.itemCount - 1 do begin
        item := _actMap.Item[idx];

        if (_itemtype = '') or (_itemtype = item.Type_) then
            items.Add(_actMap.Item[idx]);
    end;

    act.execute(items);
    items := nil;
end;

{
    TExodusActionMap implementation
}

constructor TExodusActionMap.Create(items: IExodusItemList);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusActionMap);

    if (items = nil) then items := TExodusItemList.Create;

    _items := items;
    _allActs := TInterfaceList.Create;
    _actLists := TInterfaceList.Create;
end;
destructor TExodusActionMap.Destroy;
begin
    _allActs := nil;
    _actLists := nil;
    _items := nil;

    inherited;
end;

function TExodusActionMap.Get_ItemCount: Integer;
begin
    Result := _items.Count;
end;
function TExodusActionMap.Get_Item(idx: Integer): IExodusItem;
begin
    Result := _items.Item[idx];
end;

function TExodusActionMap.Get_TypedActionsCount: Integer;
begin
    Result := _actLists.Count;
end;
function TExodusActionMap.Get_TypedActions(idx: Integer): IExodusTypedActions;
begin
    Result := IExodusTypedActions(_actLists[idx]);
end;
function TExodusActionMap.GetActionsFor(const itemtype: WideString): IExodusTypedActions;
var
    idx: Integer;
begin
    for idx := 0 to _actLists.Count - 1 do begin
        Result := _actLists[idx] as IExodusTypedActions;

        if (Result.ItemType = itemtype) then exit;
        Result := nil;
    end;
end;

function TExodusActionMap.GetActionNamed(const name: WideString): IExodusAction;
var
    idx: Integer;
begin
    for idx := 0 to _allActs.Count - 1 do begin
        Result := _allActs[idx] as IExodusAction;

        if (Result.Name = name) then exit;
        Result := nil;
    end;
end;

procedure TExodusActionMap.AddAction(itemtype: WideString; act: IExodusAction);
var
    idx: Integer;
    item: IExodusItem;
    actList: TExodusTypedActions;
begin
    idx := _allActs.IndexOf(act);
    if (idx = -1) then
        _allActs.Add(act as IExodusAction);

    actList := TExodusTypedActions(GetActionsFor(itemtype));
    if (actList = nil) then begin
        actList := TExodusTypedActions.Create(Self as IExodusActionMap, itemtype);

        _actLists.Add(actList as IExodusTypedActions);
    end;

    actList.AddAction(act);
end;
procedure TExodusActionMap.Collate;
var
    mainActs, actList: TExodusTypedActions;
    act: IExodusAction;
    idx, jdx: Integer;
    found: Boolean;
begin
    mainActs := TExodusTypedActions(GetActionsFor(''));
    if (mainActs <> nil) then
        mainActs.Clear()
    else begin
        mainActs := TExodusTypedActions.Create(Self as IExodusActionMap, '');
        _actLists.Add(mainActs as IExodusTypedActions);
    end;


    //Walk all actions, to see if they apply to all types
    for idx := 0 to _allActs.Count - 1 do begin
        act := _allActs.Items[idx] as IExodusAction;
        found := true;

        for jdx := 0 to _actLists.Count - 1 do begin
            actList := TExodusTypedActions(_actLists.Items[jdx] as IExodusTypedActions);
            if (actList._itemtype = '') then continue;
            
            found := actList.IndexOfAction(act) <> -1;

            if not found then break;
        end;

        if found then mainActs.AddAction(act);
    end;
end;

end.
