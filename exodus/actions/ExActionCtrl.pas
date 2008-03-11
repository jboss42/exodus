unit ExActionCtrl;

interface

uses ActiveX, ExActions, ExActionMap, Classes, ComObj, Contnrs, Unicode, Exodus_TLB, StdVcl;

type TActionProxy = class(TObject)
private
    _itemtype: Widestring;
    _name: Widestring;
    _delegate: IExodusAction;
    _enabling: TWidestringList; //List of name/value pairs
    _disabling: TWidestringList; //List of name/value pairs

    function containsAny(expected, actual: TWidestringList): Boolean;
public
    constructor Create(itemtype, actname: Widestring);
    destructor Destroy(); override;

    procedure addToEnabling(filter: Widestring);
    procedure addToDisabling(filter: Widestring);
    function applies(enabling, disabling: TWidestringList): Boolean;

    property ItemType: Widestring read _itemtype;
    property Name: Widestring read _name;
    property Action: IExodusAction read _delegate write _delegate;
    property EnablingFilter: TWidestringList read _enabling;
    property DisablingFilter: TWidestringList read _disabling;
end;

type TFilteringItem = class(TObject)
private
    _key, _val: Widestring;

public
    constructor CreateString(item: Widestring);
    constructor CreatePair(key, val: Widestring);
    destructor Destroy; override;

    property Key: Widestring read _key;
    property Value: Widestring read _val;

end;
type TFilteringSet = class(TObject)
private
    _items: TInterfaceList;
    _enableHints, _disableHints: TWidestringList;
    _enableSet, _disableSet: TWidestringList;

public
    constructor Create(enableHints, disableHints: TWidestringList);
    destructor Destroy; override;

    procedure update(item: IExodusItem);
    property Items: TInterfaceList read _items;
    property Enabling: TWidestringList read _enableSet;
    property Disabling: TWidestringList read _disableSet;
end;

type TPotentialActions = class(TObject)
private
    _itemtype: Widestring;
    _proxies: TWidestringList;
    _enableHints, _disableHints: TWidestringList;

    function GetProxyCount: Integer;
    function GetProxyAt(idx: Integer): TActionProxy;

public
    constructor Create(itemtype: Widestring);
    destructor Destroy; override;

    procedure updateProxy(proxy: TActionProxy);

    function GetProxyNamed(actname: Widestring): TActionProxy;

    property ItemType: Widestring read _itemtype;
    property ProxyCount: Integer read GetProxyCount;
    property Proxy[idx: Integer]: TActionProxy read GetProxyAt;

    property EnableHints: TWidestringList read _enableHints;
    property DisableHints: TWidestringList read _disableHints;
end;

type TExodusActionController = class(TAutoObject, IExodusActionController)
private
    _actions: TWidestringList;

    function lookupActionsFor(itemtype: Widestring; create: boolean): TPotentialActions;

public
    constructor Create;
    destructor Destroy; override;

    procedure registerAction(const itemtype: Widestring; const act: IExodusAction); safecall;
    procedure addEnableFilter(const ItemType, actname, filter: WideString);
      safecall;
    procedure addDisableFilter(const ItemType, actname, filter: WideString);
      safecall;
    function buildActions(const items: IExodusItemList): IExodusActionMap; safecall;
end;

function GetActionController: IExodusActionController;

var FILTER_SELECTION_SINGLE, FILTER_SELECTION_MULTI: TFilteringItem;

implementation

uses ComServ, SysUtils;

var g_ActCtrl: IExodusActionController;

{
    TProxyAction implementation
}
Constructor TActionProxy.Create(itemtype, actname: Widestring);
begin
    inherited Create;

    _name := Copy(actname, 1, Length(actname));
    _itemtype := Copy(itemtype, 1, Length(itemtype));

    _enabling := TWidestringList.Create;
    _enabling.Duplicates := dupAccept;

    _disabling := TWidestringList.Create;
    _disabling.Duplicates := dupAccept;
end;
Destructor TActionProxy.Destroy;
begin
    _enabling.Free;
    _disabling.Free;

    inherited;
end;

function TActionProxy.containsAny(expected, actual: TWidestringList): Boolean;
var
    idx, jdx: Integer;
    name: Widestring;
    eval, aval: TFilteringItem;
begin
    Result := false;

    if not expected.Sorted then expected.Sorted := true;
    if not actual.Sorted then actual.Sorted := true;

    for idx := 0 to expected.Count - 1 do begin
        name := expected[idx];
        eval := TFilteringItem(expected.Objects[idx]);

        jdx := actual.IndexOf(name);
        if (jdx <> -1) then begin
            aval := TFilteringItem(actual.Objects[jdx]);
            Result := (eval.Key = aval.Key);
        end;

        if (Result) then exit;
    end;
end;


procedure TActionProxy.addToEnabling(filter: Widestring);
var
    fitem :TFilteringItem;
begin
    fitem := TFilteringItem.CreateString(filter);

    if _enabling.Sorted then
        _enabling.Sorted := false;
    _enabling.AddObject(fitem.Key, fitem);
end;
procedure TActionProxy.addToDisabling(filter: Widestring);
var
    fitem :TFilteringItem;
begin
    fitem := TFilteringItem.CreateString(filter);

    if _disabling.Sorted then
        _disabling.Sorted := false;
    _disabling.AddObject(fitem.Key, fitem);
end;

function TActionProxy.applies(enabling, disabling: TWideStringList): Boolean;
var
    idx: Integer;
begin
    //Check for "Do I exist?"
    If (Action = nil) then begin
        Result := false;
        exit;
    end;

    //Check for "do or die"!
    If not Action.Enabled then begin
        Result := false;
        exit;
    end;

    //Check enabling (if any are present)
    Result := containsAny(_enabling, enabling);
    if not Result then exit;

    //Check disabling
    Result := not containsAny(_disabling, disabling);
    if not Result then exit;

    Result := true;
end;

{
    TFilteringItem implementation
}
constructor TFilteringItem.CreateString(item: WideString);
var
    place: Integer;

begin
    inherited Create;

    place := Pos('=', item);
    if (place > 0) then begin
        _key := Copy(item, 1, place-1);
        _val := Copy(item, place+1, Length(item));
    end else begin
        _key := item;
        _val := 'true';
    end;

    _key := StrLowerW(PWideChar(_key));
end;
constructor TFilteringItem.CreatePair(key: WideString; val: WideString);
begin
    inherited Create;

    _key := StrLowerW(PWideChar(key));
    _val := val;
end;

destructor TFilteringItem.Destroy;
begin
    inherited Destroy;
end;
{
    TFilteringSet implementation
}
constructor TFilteringSet.Create(
        enableHints: TWideStringList;
        disableHints: TWideStringList);
begin
    _items := TInterfaceList.Create;

    _enableSet := TWidestringList.Create;
    _enableHints := TWidestringList.Create;
    if (enableHints <> nil) and (enableHints.Count > 0) then
        _enableHints.Assign(enableHints);

    _disableSet := TWidestringList.Create;
    _disableHints := TWidestringList.Create;
    if (disableHints <> nil) and (disableHints.Count > 0) then
        _disableHints.Assign(disableHints);
end;
destructor TFilteringSet.Destroy;
var
    idx: Integer;
    fitem: TFilteringItem;
begin
    for idx := 0 to _enableHints.Count - 1 do begin
        _enableHints.Objects[idx] := nil;
    end;
    _enableHints.Free;

    for idx := 0 to _enableSet.Count - 1 do begin
        fitem := TFilteringItem(_enableSet.Objects[idx]);
        _enableSet.Objects[idx] := nil;

        if (fitem <> FILTER_SELECTION_SINGLE) and (fitem <> FILTER_SELECTION_MULTI) then
            fitem.Free;
    end;
    _enableSet.Free;

    for idx := 0 to _disableHints.Count - 1 do begin
        _disableHints.Objects[idx] := nil;
    end;
    _disableHints.Free;
    for idx := 0 to _disableSet.Count - 1 do begin
        fitem := TFilteringItem(_disableSet.Objects[idx]);
        _disableSet.Objects[idx] := nil;

        if (fitem <> FILTER_SELECTION_SINGLE) and (fitem <> FILTER_SELECTION_MULTI) then
            fitem.Free;
    end;
    _disableSet.Free;

    _items.Free;

    inherited Destroy;
end;

procedure TFilteringSet.update(item: IExodusItem);
var
    key, val: Widestring;
    idx, place: Integer;
    currItem, foundItem: TFilteringItem;
begin
    //remember item
    if _items.IndexOf(item) = -1 then _items.Add(item);

    //Update disabling (walk backwards, so we can remove things)
    for idx := _disableHints.Count - 1 downto 0 do begin
        key := _disableHints[idx];

        if (key = 'selection') then
            continue    //ignore this hint (always present)
        else if (key = 'active') then
            val := StrLowerW(PWideChar(BoolToStr(item.Active, true)))
        else if (key = 'visible') then
            val := StrLowerW(PWideChar(BoolToStr(item.Active, true)))
        else if (key = 'uid') then
            val := item.UID
        else begin
            //TODO:  strip off "property." ?
            val := item.value[key];
        end;

        //don't care if it's already present...
        currItem := TFilteringItem.CreatePair(key, val);
        _disableSet.AddObject(key, currItem);
    end;

    //Update enabling
    for idx := _enableHints.Count - 1 downto 0 do begin
        key := _enableHints[idx];

        if (key = 'active') then
            val := StrLowerW(PWideChar(BoolToStr(item.Active, true)))
        else if (key = 'visible') then
            val := StrLowerW(PWideChar(BoolToStr(item.Active, true)))
        else if (key = 'uid') then
            val := item.UID
        else begin
            //TODO:  strip off "property." ?
            val := item.value[key];
        end;

        //now we care if it's already there...
        place := _enableSet.IndexOf(key);
        if place = -1 then //brand-new!
            _enableSet.AddObject(key, TFilteringItem.CreatePair(key, val))
        else begin
            foundItem := TFilteringItem(_enableSet.Objects[place]);
            if foundItem.Value <> val then begin
                //remove item and hint
                foundItem.Free;
                _enableSet.Delete(place);
                _enableHints.Delete(idx);
            end;
        end;
    end;
end;

{
    TPotentialActions implementation
}
constructor TPotentialActions.Create(itemtype: WideString);
begin
    inherited Create;

    _itemtype := Copy(itemtype, 1, Length(itemtype));
    _proxies := TWidestringList.Create;
    _enableHints := TWidestringList.Create;
    _disableHints := TWidestringList.Create;
end;
destructor TPotentialActions.Destroy;
begin
    _enableHints.Free;
    _disableHints.Free;
    _proxies.Free;

    inherited;
end;

function TPotentialActions.GetProxyCount;
begin
    Result := _proxies.Count;
end;
function TPotentialActions.GetProxyAt(idx: Integer): TActionProxy;
begin
    Result := TActionProxy(_proxies.Objects[idx]);
end;
function TPotentialActions.GetProxyNamed(actname: WideString): TActionProxy;
var
    idx: Integer;
begin
    idx := _proxies.IndexOf(actname);
    if (idx <> -1) then
        Result := TActionProxy(_proxies.Objects[idx])
    else
        Result := nil;
end;

procedure TPotentialActions.updateProxy(proxy: TActionProxy);
var
    idx: Integer;
    filter: TWidestringList;
    hint: Widestring;
begin
    //add if missing
    if (_proxies.IndexOf(proxy.Name) = -1) then
        _proxies.AddObject(proxy.Name, proxy);

    //update hints
    filter := proxy.EnablingFilter;
    for idx := 0 to filter.Count - 1 do begin
        hint := filter[idx];
        if (_enableHints.IndexOf(hint) = -1) then _enableHints.Add(hint);
    end;

    filter := proxy.DisablingFilter;
    for idx := 0 to filter.Count - 1 do begin
        hint := filter[idx];
        if (_disableHints.IndexOf(hint) = -1) then _disableHints.Add(hint);
    end;
end;

{
    TExodusActionController implementation
}
constructor TExodusActionController.Create;
begin
    inherited;

    _actions := TWidestringList.Create;
end;
destructor TExodusActionController.Destroy;
begin
    _actions.Clear;
    _actions.Free;

    inherited;
end;

function TExodusActionController.lookupActionsFor(
        itemtype: WideString;
        create: Boolean): TPotentialActions;
var
    idx: Integer;
begin
    idx := _actions.IndexOf(itemtype);
    if (idx <> -1) then
        Result := TPotentialActions(_actions.Objects[idx])
    else if not create then
        Result := nil
    else begin
        Result := TPotentialActions.Create(itemtype);
        _actions.AddObject(itemtype, Result);
    end;
end;

procedure TExodusActionController.registerAction(
        const itemtype: WideString;
        const act: IExodusAction);
var
    list: TPotentialActions;
    proxy: TActionProxy;
begin
    //graceful fail
    if (itemtype = '') then exit;
    if (act = nil) then exit;

    list := lookupActionsFor(itemtype, true);
    proxy := list.GetProxyNamed(act.name);
    if (proxy = nil) then proxy := TActionProxy.Create(itemtype, act.name);

    proxy.Action := act;
    list.updateProxy(proxy);
end;

procedure TExodusActionController.addEnableFilter(const ItemType, actname,
  filter: WideString);
var
    list: TPotentialActions;
    proxy: TActionProxy;
begin
    //graceful fail
    if (itemtype = '') then exit;
    if (actname = '') then exit;
    if (filter = '') then exit;
    
    //get appropriate potentials and proxy
    list := lookupActionsFor(itemtype, true);
    proxy := list.GetProxyNamed(actname);
    if (proxy = nil) then proxy := TActionProxy.Create(itemtype, actname);

    proxy.addToEnabling(filter);
    list.updateProxy(proxy);
end;
procedure TExodusActionController.addDisableFilter(const ItemType, actname,
  filter: WideString);
var
    list: TPotentialActions;
    proxy: TActionProxy;
begin
    //graceful fail
    if (itemtype = '') then exit;
    if (actname = '') then exit;
    if (filter = '') then exit;

    //get appropriate potentials and proxy
    list := lookupActionsFor(itemtype, true);
    proxy := list.GetProxyNamed(itemtype);
    if (proxy = nil) then proxy := TActionProxy.Create(itemtype, actname);

    proxy.addToDisabling(filter);
    list.updateProxy(proxy);
end;

function TExodusActionController.buildActions(
        const items: IExodusItemList): IExodusActionMap;
var
    actmap: TExodusActionMap;
    potentials: TPotentialActions;
    proxy: TActionProxy;
    itemtype: Widestring;
    interestTypes: TWidestringList;
    interestSet: TFilteringSet;
    idx, jdx: Integer;
    item: IExodusItem;
begin
    actmap := TExodusActionMap.Create(items);
    Result := actmap;

    //quickly exit if we didn't actually select anything...
    if items.Count = 0 then exit;

    //walk items, building sets
    interestTypes := TWidestringList.Create;
    for idx := 0 to items.Count - 1 do begin
        item := items.Item[idx];

        potentials := lookupActionsFor(item.Type_, false);
        if (potentials <> nil) then begin
            jdx := interestTypes.IndexOf(potentials.ItemType);
            if (jdx <> -1) then begin
                interestSet := TFilteringSet(interestTypes.Objects[jdx]);
            end else begin
                interestSet := TFilteringSet.Create(potentials.EnableHints, potentials.DisableHints);
                interestTypes.AddObject(potentials.ItemType, interestSet);
            end;

            interestSet.update(item);
        end;
    end;

    //walk types, building action map
    for idx := 0 to interestTypes.Count - 1 do begin
        potentials := lookupActionsFor(interestTypes[idx], false);
        interestSet := TFilteringSet(interestTypes.Objects[idx]);

        if (items.Count = 0) then begin
            //don't touch anything!!
        end else if (items.Count = 1) then begin
            interestSet.Disabling.AddObject('selection', FILTER_SELECTION_SINGLE);
            interestSet.Enabling.AddObject('selection', FILTER_SELECTION_SINGLE);
        end else begin
            interestSet.Disabling.AddObject('selection', FILTER_SELECTION_MULTI);
            interestSet.Enabling.AddObject('selection', FILTER_SELECTION_MULTI);
        end;

        //TODO:  add typed actions to actionmap
        for jdx := 0 to potentials.ProxyCount - 1 do begin
            proxy := potentials.Proxy[idx];

            if proxy.applies(interestSet.Enabling, interestSet.Disabling) then
                actmap.AddAction(potentials.ItemType, proxy.Action);
        end;

        //Free it up now
        interestTypes.Objects[idx] := nil;
        interestSet.Free;
    end;

    //build the intersection
    actmap.Collate();
end;

function GetActionController: IExodusActionController;
begin
    if (g_ActCtrl = nil) then
        g_ActCtrl := TExodusActionController.Create;
    Result := g_actCtrl;
end;

initialization
    TAutoObjectFactory.Create(ComServer,
            TExodusActionController,
            CLASS_ExodusActionController,
            ciMultiInstance, tmApartment);
    FILTER_SELECTION_SINGLE := TFilteringItem.CreatePair('selection', 'single');
    FILTER_SELECTION_MULTI := TFilteringItem.CreatePair('selection', 'multi');
end.
