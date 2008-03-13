unit ExActionMap;

interface

uses ActiveX, ComObj, Classes, Contnrs, ExActions, Unicode, Exodus_TLB;

type TActionRef = packed record
    action: IExodusAction;
end;
type TExodusTypedActions = class(TAutoIntfObject, IExodusTypedActions)
private
    _itemtype: Widestring;
    _items: IExodusItemList;
    _actions: TWidestringList;

    procedure Collate;

public
    constructor Create(actmap: IExodusActionMap; itemtype: Widestring);
    destructor Destroy; override;

    function Get_ItemType: Widestring; safecall;
    function Get_ItemCount: Integer; safecall;
    function Get_Item(idx: Integer): IExodusItem; safecall;

    function Get_ActionCount: Integer; safecall;
    function Get_Action(idx: Integer): IExodusAction; safecall;
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

    procedure Collate;
end;

implementation

uses SysUtils, ComServ, COMExodusItemList;

{
    TTypedActions implementation
}

constructor TExodusTypedActions.Create(actmap: IExodusActionMap; itemtype: WideString);
var
    idx: Integer;
    item: IExodusItem;
begin
    inherited Create(ComServer.TypeLib, IID_IExodusTypedActions);

    _itemtype := itemtype;
    _actions := TWidestringList.Create;

    _items := TExodusItemList.Create as IExodusItemList;
    for idx := 0 to actmap.itemCount - 1 do begin
        item := actmap.Item[idx];
        if (itemtype = '') or (itemtype = item.Type_) then
            _items.Add(actmap.Item[idx]);
    end;
end;
destructor TExodusTypedActions.Destroy;
begin
    Clear;
    _actions.Free;
    _items := nil;

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
    Result := nil;
    if (idx < 0) or (idx >= _items.Count) then exit;

    Result := _items.Item[idx];
end;

function TExodusTypedActions.Get_ActionCount: Integer;
begin
    Result := _actions.Count;
end;
function TExodusTypedActions.Get_Action(idx: Integer): IExodusAction;
begin
    Result := nil;
    if (idx < 0) or (idx >= _actions.Count) then exit;

    Result := IExodusAction(Pointer(_actions.Objects[idx]));
end;
procedure TExodusTypedActions.AddAction(act: IExodusAction);
var
    idx: Integer;
    currRef: Pointer;
    nextRef: Pointer;
begin
    if _actions.Sorted then _actions.Sorted := false;

    nextRef := Pointer(act);
    idx := _actions.IndexOf(act.Name);
    if (idx <> -1) then begin
        currRef := Pointer(_actions.Objects[idx]);

        if (currRef = nextRef) then
            exit;       //already present, so do nothing!
        IExodusAction(currRef)._Release;
        _actions.Delete(idx);
    end;

    act._AddRef;
    _actions.AddObject(act.Name, TObject(Pointer(act)));
end;
procedure TExodusTypedActions.Clear;
var
    idx: Integer;
begin
    if _actions.Sorted then _actions.Sorted := false;

    for idx := _actions.Count - 1 downto 0 do begin
        IExodusAction(Pointer(_actions.Objects[idx]))._Release;
        _actions.Delete(idx);
    end;
end;

function TExodusTypedActions.GetActionNamed(const name: WideString): IExodusAction;
var
    idx: Integer;
begin
    idx := _actions.IndexOf(name);
    Result := Get_Action(idx);
end;
procedure TExodusTypedActions.execute(const actname: Widestring);
var
    act: IExodusAction;
begin
    act := GetActionNamed(actname);
    if (act = nil) then exit;

    act.execute(_items);
end;

procedure TExodusTypedActions.Collate;
begin
    _actions.Sorted := true;
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

    _mainActs := TExodusTypedActions.Create(Self as IExodusActionMap, '');
    _mainActs._AddRef;
    
    _actLists := TWidestringList.Create;
    _actLists.AddObject('', _mainActs);
end;
destructor TExodusActionMap.Destroy;
var
    idx: Integer;
begin
    for idx := 0 to _actLists.Count - 1 do begin
        TExodusTypedActions(_actLists.Objects[idx])._Release;
    end;
    FreeAndNil(_actLists);

    _items := nil;
    _allActs := nil;

    _mainActs._Release;
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
var
    actList: TExodusTypedActions;
begin
    Result := nil;
    if (idx < 0) or (idx > _actLists.Count) then exit;
    
    actList := TExodusTypedActions(_actLists.Objects[idx]);
    Result := actList as IExodusTypedActions;
end;
function TExodusActionMap.GetActionsFor(const itemtype: WideString): IExodusTypedActions;
var
    idx: Integer;
    actList: TExodusTypedActions;
begin
    Result := nil;
    idx := _actLists.IndexOf(itemtype);
    if (idx = -1) then exit;

    actList := TExodusTypedActions(_actLists.Objects[idx]);
    Result := actList as IExodusTypedActions
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
        actList._AddRef;
        
        if _actLists.Sorted then _actLists.Sorted := false;
        _actLists.AddObject(actList.Get_ItemType, actList);
    end;

    actList.AddAction(act);
end;

procedure TExodusActionMap.Collate;
var
    idx: Integer;
    main: IExodusTypedActions;
    act: IExodusAction;
begin
    if (_actLists.Count = 2) then begin
        //there's only one typed actions, copy it into main actions...
        main := Get_TypedActions(1);

        for idx := 0 to main.ActionCount - 1 do begin
            act := main.Action[idx];
            _mainActs.AddAction(act);
        end;
    end;

    for idx := 0 to _actLists.Count - 1 do begin
        //Collate (sort) all actions for types
        TExodusTypedActions(_actLists.Objects[idx]).Collate;
    end;

    //Sort the type list
    _actLists.Sorted := true;
end;

end.
