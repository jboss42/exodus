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
unit ExActionMap;

interface

uses ActiveX, ComObj, Classes, Contnrs, ExActions, Unicode, Exodus_TLB;



type
    TExodusActionMap = class;
    TExodusTypedActions = class(TAutoIntfObject, IExodusTypedActions)
    private
        _owner: TExodusActionMap;
        _itemtype: Widestring;
        _items: IExodusItemList;
        _actions: TWidestringList;

        constructor Create(actmap: TExodusActionMap; itemtype: Widestring);

        procedure Collate;

    public
        destructor Destroy; override;

        function Get_ItemType: Widestring; safecall;
        function Get_ItemCount: Integer; safecall;
        function Get_Item(idx: Integer): IExodusItem; safecall;

        function Get_ActionCount: Integer; safecall;
        function Get_Action(idx: Integer): IExodusAction; safecall;
        function IndexOfAction(act: IExodusAction): Integer;
        procedure AddAction(act: IExodusAction);
        procedure RemoveAction(act: IExodusAction);
        procedure Clear;

        function GetActionNamed(const name: Widestring): IExodusAction; safecall;
        procedure execute(const actname: Widestring); safecall;
    end;

    TExodusActionMap = class(TAutoIntfObject, IExodusActionMap)
    private
        _items: IExodusItemList;
        _allActs: TInterfaceList;
        _actLists: TWidestringList;

        procedure AddAction(act: IExodusAction);
    
    protected
        procedure DeleteTypedActions(actList: TExodusTypedActions);

    public
        constructor Create(items: IExodusItemList);
        destructor Destroy; override;

        function Get_ItemCount: Integer; safecall;
        function Get_Item(idx: Integer): IExodusItem; safecall;
        function Get_TypedActionsCount: Integer; safecall;
        function Get_TypedActions(idx: Integer): IExodusTypedActions; safecall;

        function LookupTypedActions(itemtype: Widestring; create: Boolean): TExodusTypedActions;

        function GetActionsFor(const itemtype: Widestring): IExodusTypedActions; safecall;
        function GetActionNamed(const name: Widestring): IExodusAction; safecall;

        procedure Collate;
    end;

implementation

uses SysUtils, ComServ, COMExodusItemList;

{
    TTypedActions implementation
}

constructor TExodusTypedActions.Create(actmap: TExodusActionMap; itemtype: WideString);
var
    idx: Integer;
    item: IExodusItem;
begin
    inherited Create(ComServer.TypeLib, IID_IExodusTypedActions);

    _owner := actmap as TExodusActionMap;
    _itemtype := itemtype;
    _actions := TWidestringList.Create;

    _items := TExodusItemList.Create as IExodusItemList;
    for idx := 0 to actmap.Get_ItemCount - 1 do begin
        item := actmap.Get_item(idx);
        if (itemtype = '') or (itemtype = item.Type_) then
            _items.Add(item);
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
function TExodusTypedActions.IndexOfAction(act: IExodusAction): Integer;
begin
    Result := _actions.IndexOfObject(TObject(Pointer(act)));
end;
procedure TExodusTypedActions.AddAction(act: IExodusAction);
var
    idx: Integer;
    currRef: Pointer;
    nextRef: Pointer;
begin
    if act = nil then exit;
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
    _owner.AddAction(act);
end;
procedure TExodusTypedActions.RemoveAction(act: IExodusAction);
var
    idx: Integer;
    prevAct: IExodusAction;
    currRef, prevRef: Pointer;
begin
    if act = nil then exit;

    currRef := Pointer(act);
    idx := _actions.IndexOf(act.Name);
    if (idx <> -1) then begin
        prevRef := Pointer(_actions.Objects[idx]);

        if (currRef = prevRef) then begin
            _actions.Delete(idx);
            act._Release;
        end;
    end;
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

    _actLists := TWidestringList.Create;
end;
destructor TExodusActionMap.Destroy;
var
    idx: Integer;
    actList: TExodusTypedActions;
begin
    for idx := _actLists.Count - 1 downto 0 do begin
        actList := TExodusTypedActions(_actLists.Objects[idx]);
        actList._Release;
    end;
    FreeAndNil(_actLists);

    _items := nil;
    _allActs := nil;

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
function TExodusActionMap.LookupTypedActions(
        itemtype: WideString;
        create: Boolean): TExodusTypedActions;
var
    idx: Integer;
begin
    Result := nil;
    idx := _actLists.IndexOf(itemtype);
    if (idx <> -1) then
        Result := TExodusTypedActions(_actLists.Objects[idx])
    else if create then begin
        if _actLists.Sorted then _actLists.Sorted := false;

         Result := TExodusTypedActions.Create(Self, itemtype);
         Result._AddRef;
         _actLists.AddObject(itemtype, Result);
    end;
end;
procedure TExodusActionMap.DeleteTypedActions(actList: TExodusTypedActions);
var
    idx: Integer;
begin
    idx := _actLists.IndexOfObject(actList);
    if (idx <> -1) then begin
        _actLists.Delete(idx);
        actList._Release;
    end;
end;

function TExodusActionMap.GetActionsFor(const itemtype: WideString): IExodusTypedActions;
var
    actList: TExodusTypedActions;
begin
    actList := LookupTypedActions(itemtype, false);
    if actList <> nil then
        Result := actList as IExodusTypedActions
    else
        Result := nil;
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

procedure TExodusActionMap.AddAction(act: IExodusAction);
var
    idx: Integer;
begin
    idx := _allActs.IndexOf(act);
    if (idx = -1) then
        _allActs.Add(act as IExodusAction);
end;

procedure TExodusActionMap.Collate;
var
    idx, jdx: Integer;
    mainActs, typedActs: TExodusTypedActions;
    act: IExodusAction;
begin
    mainActs := LookupTypedActions('', true);
    mainActs.Clear;

    //Let's (optimistically) asume that all actions should be in the main actions
    for idx := 0 to _allActs.Count - 1 do begin
        mainActs.AddAction(_allActs[idx] as IExodusAction);
    end;
    mainActs.Collate;

    for idx := 0 to _actLists.Count - 1 do begin
        //Collate (sort) all actions for types (other than '')
        typedActs := TExodusTypedActions(_actLists.Objects[idx]);

        //skip main actions
        if (typedActs = mainActs) then continue;

        //remove actions missing in typed from main
        for jdx := 0 to _allActs.Count - 1 do begin
            act := _allActs[jdx] as IExodusAction;
            if typedActs.IndexOfAction(act) = -1 then mainActs.RemoveAction(act);
        end;

        typedActs.Collate;
    end;

    //Sort the type list
    _actLists.Sorted := true;
end;

end.
