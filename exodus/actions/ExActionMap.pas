unit ExActionMap;

interface

uses ActiveX, Classes, ExActions, Exodus_TLB;

type IExodusActionList = interface
    function GetItemType: Widestring;
    function GetActionCount: Integer;
    function GetActionAt(idx: Integer): IExodusAction;

    property ItemType: Widestring read GetItemType;
    property ActionCount: Integer read GetActionCount;
    property Action[idx:Integer]: IExodusAction read GetActionAt;

    function GetActionNamed(name: Widestring): IExodusAction;
    procedure execute(act: IExodusAction);
end;

type IExodusActionMap = interface
    function GetItemCount: Integer;
    function GetItemAt(idx: Integer): IExodusItem;
    function GetActionListCount: Integer;
    function GetActionListAt(idx: Integer): IExodusActionList;
    function GetActionListFor(itemtype: Widestring): IExodusActionList;
    function GetMainActionCount: Integer;
    function GetMainActionAt(idx: Integer): IExodusAction;

    property ItemCount: Integer read GetItemCount;
    property Item[idx:Integer]: IExodusItem read GetItemAt;

    property ActionListCount: Integer read GetActionListCount;
    property ActionList[idx:Integer]: IExodusActionList read GetActionListAt;

    property MainActionCount: Integer read GetMainActionCount;
    property MainAction[idx:Integer]: IExodusAction read GetMainActionAt;

    function GetActionNamed(name: Widestring): IExodusAction;
    procedure execute(act: IExodusAction);
end;

type TExodusActionList = class(TInterfacedObject, IExodusActionList)
private
    _itemtype: Widestring;
    _items: IExodusItemList;
    _actions: TInterfaceList;

public
    constructor Create(itemtype: Widestring);
    destructor Destroy; override;

    function GetItemType: Widestring;
    function GetItemCount: Integer;
    function GetItemAt(idx: Integer): IExodusItem;
    procedure AddItem(item: IExodusItem);

    function GetActionCount: Integer;
    function GetActionAt(idx: Integer): IExodusAction;
    function IndexOfAction(act: IExodusAction): Integer;
    procedure AddAction(act: IExodusAction);

    function GetActionNamed(name: Widestring): IExodusAction;
    procedure execute(act: IExodusAction);
end;

type TExodusActionMap = class(TInterfacedObject, IExodusActionMap)
private
    _items: IExodusItemList;
    _actLists: TInterfaceList;
    _allActs: TInterfaceList;
    _mainActs: TInterfaceList;

public
    constructor Create(items: IExodusItemList);
    destructor Destroy; override;

    function GetItemCount: Integer;
    function GetItemAt(idx: Integer): IExodusItem;
    function GetActionListCount: Integer;
    function GetActionListAt(idx: Integer): IExodusActionList;
    function GetActionListFor(itemtype: Widestring): IExodusActionList;
    function GetMainActionCount: Integer;
    function GetMainActionAt(idx: Integer): IExodusAction;

    procedure AddAction(itemtype: Widestring; act: IExodusAction);
    procedure Collate;

    function GetActionNamed(name: Widestring): IExodusAction;
    procedure execute(act: IExodusAction);
end;

implementation

uses SysUtils, COMExodusItemList;

{
    TExodusActionList implementation
}

constructor TExodusActionList.Create(itemtype: WideString);
begin
    inherited Create;

    _itemtype := itemtype;
    _items := TExodusItemList.Create;
    _actions := TInterfaceList.Create;
end;
destructor TExodusActionList.Destroy;
begin
    _items := nil;
    _actions.Free;

    inherited;
end;

function TExodusActionList.GetItemType: Widestring;
begin
    Result := _itemtype;
end;

function TexodusActionList.GetItemCount: Integer;
begin
    Result := _items.Count;
end;
function TExodusActionList.GetItemAt(idx: Integer): IExodusItem;
begin
    Result := _items.Item[idx] as IExodusItem;
end;
procedure TExodusActionList.AddItem(item: IExodusItem);
begin
    _items.Add(item);
end;

function TExodusActionList.GetActionCount: Integer;
begin
    Result := _actions.Count;
end;
function TExodusActionList.GetActionAt(idx: Integer): IExodusAction;
begin
    Result := IExodusAction(_actions[idx]);
end;
function TExodusActionList.IndexOfAction(act: IExodusAction): Integer;
begin
    Result := _actions.IndexOf(act);
end;
procedure TExodusActionList.AddAction(act: IExodusAction);
begin
    _actions.Add(act);
end;

function TExodusActionList.GetActionNamed(name: WideString): IExodusAction;
var
    idx: Integer;
begin
    for idx := 0 to _actions.Count - 1 do begin
        Result := IExodusAction(_actions[idx]);

        if Result.Name = name then exit;
        Result := nil;
    end;
end;
procedure TExodusActionList.execute(act: IExodusAction);
begin
    if _actions.IndexOf(act) = -1 then exit;

    act.execute(_items);
end;

{
    TExodusActionMap implementation
}

constructor TExodusActionMap.Create(items: IExodusItemList);
begin
    inherited Create;

    if (items = nil) then items := TExodusItemList.Create;

    _items := items;
    _allActs := TInterfaceList.Create;
    _mainActs := TInterfaceList.Create;
    _actLists := TInterfaceList.Create;
end;
destructor TExodusActionMap.Destroy;
begin
    _actLists.Free;
    _mainActs.Free;
    _allActs.Free;
    _items := nil;

    inherited;
end;

function TExodusActionMap.GetItemCount: Integer;
begin
    Result := _items.Count;
end;
function TExodusActionMap.GetItemAt(idx: Integer): IExodusItem;
begin
    Result := _items.Item[idx];
end;

function TExodusActionMap.GetActionListCount: Integer;
begin
    Result := _actLists.Count;
end;
function TExodusActionMap.GetActionListAt(idx: Integer): IExodusActionList;
begin
    Result := IExodusActionList(_actLists[idx]);
end;
function TExodusActionMap.GetActionListFor(itemtype: WideString): IExodusActionList;
var
    idx: Integer;
begin
    for idx := 0 to _actLists.Count - 1 do begin
        Result := IExodusActionList(_actLists[idx]);

        if (Result.ItemType = itemtype) then exit;
        Result := nil;
    end;
end;

function TExodusActionMap.GetMainActionCount: Integer;
begin
    Result := _mainActs.Count;
end;
function TExodusActionMap.GetMainActionAt(idx: Integer): IExodusAction;
begin
    Result := IExodusAction(_mainActs[idx]);
end;
function TExodusActionMap.GetActionNamed(name: WideString): IExodusAction;
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
    actList: TExodusActionList;
begin
    if (_allActs.IndexOf(act) = -1) then _allActs.Add(act);

    actList := TExodusActionList(GetActionListFor(itemtype));
    if (actList = nil) then begin
        actList := TExodusActionList.Create(itemtype);

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
    actList: TExodusActionList;
    act: IExodusAction;
    idx: Integer;
begin
    _mainActs.Clear;

end;

procedure TExodusActionMap.execute(act: IExodusAction);
begin

end;

end.
