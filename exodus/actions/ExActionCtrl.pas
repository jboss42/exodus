unit ExActionCtrl;

interface

uses ActiveX, ExActions, ExActionMap, Classes, ComObj, Contnrs, Unicode, Exodus_TLB, StdVcl;
{
type IExodusActionController = interface
    procedure registerAction(itemtype: Widestring; act: IExodusAction);
    procedure addEnableFilter(itemtype: Widestring; actname: Widestring; filter: OleVariant);
    procedure addDisableFilter(itemtype: Widestring; actname: Widestring; filter: OleVariant);
    function buildActions(items: IExodusItemList): IExodusActionMap;
end;
}

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

    procedure addToEnabling(filter: TWidestringList);
    procedure addToDisabling(filter: TWidestringList);
    function applies(enabling, disabling: TWidestringList): Boolean;

    property ItemType: Widestring read _itemtype;
    property Name: Widestring read _name;
    property Delegate: IExodusAction read _delegate write _delegate;
    property EnablingFilter: TWidestringList read _enabling;
    property DisablingFilter: TWidestringList read _disabling;
end;

type TPotentialActions = class(TObject)
private
    _itemtype: Widestring;
    _proxies: TWidestringList;
    _hints: TWidestringList;

    function GetProxyCount: Integer;
    function GetProxyAt(idx: Integer): TActionProxy;

    procedure updateHints(filter: TWidestringList);

public
    constructor Create(itemtype: Widestring);
    destructor Destroy; override;

    procedure update(act: TActionProxy);
    procedure buildInterests(item: IExodusItem; var interests: TWidestringList);

    function GetProxyNamed(actname: Widestring): TActionProxy;

    property ItemType: Widestring read _itemtype;
    property ProxyCount: Integer read GetProxyCount;
    property Proxy[idx: Integer]: TActionProxy read GetProxyAt;
end;

type TExodusActionController = class(TAutoObject, IExodusActionController)
private
    _actions: TWidestringList;

    function lookupActionsFor(itemtype: Widestring; create: boolean): TPotentialActions;

public
    constructor Create;
    destructor Destroy; override;

    procedure registerAction(const itemtype: Widestring; const act: IExodusAction); safecall;
    procedure addEnableFilter(
            const itemtype: Widestring;
            const actname: Widestring;
            filter: PSafeArray); safecall;
    procedure addDisableFilter(
            const itemtype: Widestring;
            const actname: Widestring;
            filter: PSafeArray); safecall;
    function buildActions(const items: IExodusItemList): IExodusActionMap; safecall;
end;

implementation

uses ComServ, SysUtils;

{
    TProxyAction implementation
}
Constructor TActionProxy.Create(itemtype, actname: Widestring);
begin
    inherited Create;

    _name := actname;
    _itemtype := itemtype;

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
    eval, aval: Widestring;
begin
    Result := false;

    for idx := 0 to expected.Count - 1 do begin
        name := expected[idx];
        eval := Widestring(expected.Objects[idx]);

        jdx := actual.IndexOfName(name);
        if (jdx <> -1) then begin
            aval := Widestring(actual.Objects[jdx]);
            Result := (eval = aval);
        end;

        if (Result) then exit;
    end;
end;


procedure TActionProxy.addToEnabling(filter: TWidestringList);
var
    fitem, name, val: Widestring;
    idx, place: Integer;
begin
    if (filter = nil) or (filter.Count = 0) then exit;

    for idx := 0 to filter.Count - 1 do begin
        fitem := filter[idx];

        place := Pos('=', fitem);
        if (place > 1) then begin
            //explicit name/value
            name := Copy(fitem, 1, place - 1);
            val := copy(fitem, place + 1, Length(fitem) - place);
        end else begin
            //no value; name=item and val='true'
            name := fitem;
            val := 'true';
        end;

        //_enabling.AddObject(name, val);
    end;
end;
procedure TActionProxy.addToDisabling(filter: TWidestringList);
var
    idx, place: Integer;
    fitem, name, val: Widestring;
begin
    if (filter = nil) or (filter.Count = 0) then exit;

    for idx := 0 to filter.Count - 1 do begin
        fitem := filter[idx];

        place := Pos('=', fitem);
        if (place > 1) then begin
            //explicit name/value
            name := Copy(fitem, 1, place - 1);
            val := copy(fitem, place + 1, Length(fitem) - place);
        end else begin
            //no value; name=item and val='true'
            name := fitem;
            val := 'true';
        end;

        //_disabling.AddObject(name, val);
    end;
end;

function TActionProxy.applies(enabling, disabling: TWideStringList): Boolean;
var
    idx: Integer;
begin
    //Check for "Do I exist?"
    If (Delegate = nil) then begin
        Result := false;
        exit;
    end;

    //Check for "do or die"!
    If not Delegate.Enabled then begin
        Result := false;
        exit;
    end;

    //Check enabling (if any are present)
    if (_enabling.Count > 0) then begin
        Result := containsAny(_enabling, enabling);

        if not Result then exit;
    end;

    //Check disabling
    if (_disabling.Count > 0) then begin
        Result := not containsAny(_disabling, disabling);

        if not Result then exit;
    end;

    Result := true;
end;

{
    TPotentialActions implementation
}
constructor TPotentialActions.Create(itemtype: WideString);
begin
    inherited Create;

    _itemtype := itemtype;
    _proxies := TWidestringList.Create;
    _hints := TWidestringList.Create;
end;
destructor TPotentialActions.Destroy;
begin
    _hints.Free;
    _proxies.Free;

    inherited;
end;

procedure TPotentialActions.updateHints(filter: TWideStringList);
var
    idx, place: Integer;
    hint: Widestring;
    fitem: Widestring;
begin
    for idx := 0 to filter.Count - 1 do begin
        fitem := filter[idx];
        place := Pos('=', fitem);
        if (place > 0) then
            hint := Copy(fitem, 1, place)
        else
            hint := fitem;

        if (_hints.IndexOf(hint) = -1) then _hints.Add(hint);
    end;
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
    idx := _proxies.IndexOfName(actname);
    if (idx <> -1) then
        Result := TActionProxy(_proxies.Objects[idx])
    else
        Result := nil;
end;

procedure TPotentialActions.update(act: TActionProxy);
begin
    //add if missing
    if (_proxies.IndexOf(act.Name) = -1) then
        _proxies.AddObject(act.Name, act);

    //update hints
    //updateHints(act.Hints);
end;
procedure TPotentialActions.buildInterests(
        item: IExodusItem;
        var interests: TWideStringList);
var
    existing: Boolean;
    idx, place: Integer;
    name, rst: Widestring;
begin
    //create if non-existent
    if (interests <> nil) then
        existing := true
    else begin
        interests := TWidestringList.Create;
        interests.Duplicates := dupIgnore;
        interests.Sorted := true;
        existing := false;
    end;

    //walk hints, pulling out interesting information
    for idx := 0 to _hints.Count - 1 do begin
        name := _hints[idx];

        if (name = 'active') then
            rst := 'active=' + BoolToStr(item.Active, true)
        else if (name = 'uid') then
            rst := 'uid=' + item.UID
        else begin
            if (Pos('property.', name) = 1) then
                name := Copy(name, 10, Length(name)-10);
            rst := name + '=' + item.value[name];
        end;

        if (not existing) then
            interests.Add(rst);
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
    idx := _actions.IndexOfName(itemtype);
    if (idx <> -1) then
        Result := TPotentialActions(_actions[idx])
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

    proxy.Delegate := act;
    list.update(proxy);
end;

function coerceFilter(input: PSafeArray): TWidestringList;
var
    idx, first, last: Integer;
    fitem: Widestring;
begin
    Result := TWidestringList.Create;
    SafeArrayGetLBound(input, 0, first);
    SafeArrayGetUBound(input, 0, last);
    for idx := first to last do begin
        SafeArrayGetElement(input, idx, fitem);
        //fitem := Widestring(input[idx]);
        Result.Add(fitem);
    end;
end;
procedure TExodusActionController.addEnableFilter(
        const itemtype: WideString;
        const actname: WideString;
        filter: PSafeArray);
var
    list: TPotentialActions;
    proxy: TActionProxy;
    flist: TWidestringList;
begin
    //graceful fail
    if (itemtype = '') then exit;
    if (actname = '') then exit;

    flist := coerceFilter(filter);
    if (flist.Count = 0) then begin
        flist.Free;
        exit;
    end;

    //get appropriate potentials and proxy
    list := lookupActionsFor(itemtype, true);
    proxy := list.GetProxyNamed(actname);
    if (proxy = nil) then proxy := TActionProxy.Create(itemtype, actname);

    proxy.addToEnabling(flist);
    list.update(proxy);
end;
procedure TExodusActionController.addDisableFilter(
        const itemtype: WideString;
        const actname: WideString;
        filter: PSafeArray);
var
    list: TPotentialActions;
    proxy: TActionProxy;
    flist: TWidestringList;
begin
    //graceful fail
    if (itemtype = '') then exit;
    if (actname = '') then exit;

    flist := coerceFilter(filter);
    if (flist.Count = 0) then begin
        flist.Free;
        exit;
    end;

    //get appropriate potentials and proxy
    list := lookupActionsFor(itemtype, true);
    proxy := list.GetProxyNamed(itemtype);
    if (proxy = nil) then proxy := TActionProxy.Create(itemtype, actname);

    proxy.addToDisabling(flist);
    list.update(proxy);
end;

function TExodusActionController.buildActions(
        const items: IExodusItemList): IExodusActionMap;
var
    potentials: TPotentialActions;
    act: TActionProxy;
    interestTypes: TWidestringList;
    interestSet: TWidestringList;
    idx, jdx: Integer;
    item: IExodusItem;
begin
    Result := nil;

    //walk types, building sets
    interestTypes := TWidestringList.Create;
    for idx := 0 to items.Count - 1 do begin
        item := items.Item[idx];

        potentials := lookupActionsFor(item.Type_, false);
        if (potentials = nil) then continue;

        jdx := interestTypes.IndexOfName(potentials.ItemType);
        if (jdx <> -1) then begin
            interestSet := TWidestringList(interestTypes.Objects[idx]);
            potentials.buildInterests(item, interestSet);
        end else begin
            interestSet := nil;
            potentials.buildInterests(item, interestSet);
            interestTypes.AddObject(potentials.ItemType, interestSet);
        end;
        
    end;
end;

initialization
    TAutoObjectFactory.Create(ComServer,
            TExodusActionController,
            CLASS_ExodusActionController,
            ciMultiInstance, tmApartment);

end.
