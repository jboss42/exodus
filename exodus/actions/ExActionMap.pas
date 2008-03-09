unit ExActionMap;

interface

uses ActiveX, ComObj, Classes, ExActions, Exodus_TLB;

type TExodusTypedActions = class(TAutoIntfObject, IExodusTypedActions)
private
    _itemtype: Widestring;
    _items: IExodusItemList;
    _actions: TInterfaceList;

public
    constructor Create(itemtype: Widestring);
    destructor Destroy; override;

    function Get_ItemType: Widestring; safecall;
    function Get_ItemCount: Integer; safecall;
    function Get_Item(idx: Integer): IExodusItem; safecall;
    procedure AddItem(item: IExodusItem);

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
    _mainActs: TExodusTypedActions;

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

constructor TExodusTypedActions.Create(itemtype: WideString);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusTypedActions);
    
    _itemtype := itemtype;
    _items := TExodusItemList.Create;
    _actions := TInterfaceList.Create;
end;
destructor TExodusTypedActions.Destroy;
begin
    _items := nil;
    _actions.Free;

    inherited;
end;

function TExodusTypedActions.Get_ItemType: Widestring;
begin
    Result := _itemtype;
end;

function TExodusTypedActions.Get_ItemCount: Integer;
begin
    Result := _items.Count;
end;
function TExodusTypedActions.Get_Item(idx: Integer): IExodusItem;
begin
    Result := _items.Item[idx] as IExodusItem;
end;
procedure TExodusTypedActions.AddItem(item: IExodusItem);
begin
    _items.Add(item);
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
begin
    act := GetActionNamed(actname);
    if (act = nil) then exit;

    act.execute(_items);
end;

{
    TExodusActionMap implementation
}

constructor TExodusActionMap.Create(items: IExodusItemList);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusActionMap);

    if (items = nil) then items := TExodusItemList.Create;

    _items := items;
    _mainActs := TExodusTypedActions.Create('');
    _allActs := TInterfaceList.Create;
    _actLists := TInterfaceList.Create;
    _actLists.Add(_mainActs);
end;
destructor TExodusActionMap.Destroy;
begin
    _actLists.Free;
    _allActs.Free;
    _mainActs := nil;
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
        Result := IExodusTypedActions(_actLists[idx]);

        if (Result.ItemType = itemtype) then exit;
        Result := nil;
    end;
end;

function TExodusActionMap.GetActionNamed(const name: WideString): IExodusAction;
var
    idx: Integer;
begin
    for idx := 0 to _allActs.Count - 1 do begin
        Result := IExodusAction(_allActs[idx]);

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
    if (_allActs.IndexOf(act) = -1) then _allActs.Add(act);

    actList := TExodusTypedActions(GetActionsFor(itemtype));
    if (actList = nil) then begin
        actList := TExodusTypedActions.Create(itemtype);

        //setup Items for type
        for idx := 0 to _items.Count - 1 do begin
            item := _items.Item[idx];

            if (item.Type_ = itemtype) then actList.AddItem(item);
        end;
            
        _actLists.Add(actList);
    end;

    actList.AddAction(act);
end;
procedure TExodusActionMap.Collate;
var
    actList: TExodusTypedActions;
    act: IExodusAction;
    idx, jdx: Integer;
    found: Boolean;
begin
    _mainActs.Clear;

    //Start index at 1, since 0 == main actions
    for idx := 1 to _allActs.Count - 1 do begin
        act := IExodusAction(_allActs.Items[idx]);
        found := true;

        for jdx := 0 to _actLists.Count - 1 do begin
            actList := TExodusTypedActions(_actLists.Items[jdx]);
            found := actList.IndexOfAction(act) <> -1;

            if not found then break;
        end;

        if found then _mainActs.AddAction(act);
    end;
end;

end.
