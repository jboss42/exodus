unit ExActionMap;

interface

uses ActiveX, ComObj, Classes, Contnrs, ExActions, Unicode, Exodus_TLB;

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
    _allActs: TInterfaceList;
    _mainActs: TExodusTypedActions;
    _actLists: TWidestringList;

public
    constructor Create(items: IExodusItemList);
    destructor Destroy; override;

    function Get_ItemCount: Integer; safecall;
    function Get_Item(idx: Integer): IExodusItem; safecall;
    function Get_TypedActionsCount: Integer; safecall;
    function Get_TypedActions(idx: Integer): IExodusTypedActions; safecall;

    procedure AddAction(itemtype: Widestring; act: IExodusAction);

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
        Result := _actions[idx] as IExodusAction;

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
    _mainActs := TExodusTypedActions.Create(Self as IExodusActionMap, '');
    _allActs := TInterfaceList.Create;

    _actLists := TWidestringList.Create;
    _actLists.AddObject('', _mainActs);
end;
destructor TExodusActionMap.Destroy;
begin
    FreeAndNil(_actLists);
    
    _items := nil;
    _allActs := nil;
    _mainActs := nil;

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
    Result := TExodusTypedActions(_actLists.Objects[idx]) as IExodusTypedActions;
end;
function TExodusActionMap.GetActionsFor(const itemtype: WideString): IExodusTypedActions;
var
    idx: Integer;
begin
    Result := nil;
    idx := _actLists.IndexOf(itemtype);
    if (idx <> -1) then
        Result := TExodusTypedActions(_actLists.Objects[idx]) as IExodusTypedActions
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

    idx := _actLists.IndexOf(itemtype);
    if (idx <> -1) then
        actList := TExodusTypedActions(_actLists.Objects[idx])
    else begin
        actList := TExodusTypedActions.Create(Self as IExodusActionMap, itemtype);

        _actLists.AddObject(actList.Get_ItemType, actList);
    end;

    actList.AddAction(act);
end;

end.
