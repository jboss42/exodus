unit ExActions;

interface

uses Classes, Contnrs, Unicode, Exodus_TLB;

type
    IExodusAction = interface
        function getName: Widestring;
        function getCaption: Widestring;
        function getImageIndex: Integer;
        function getEnabled: Boolean;
        function getSubactionCount: Integer;
        function getSubactionAt(idx: Integer): IExodusAction;

        procedure execute(items: IExodusItemList);

        property Name: Widestring read getName;
        property Caption: Widestring read getCaption;
        property ImageIndex: Integer read getImageIndex;
        property Enabled: boolean read getEnabled;
        property SubactionCount: Integer read getSubactionCount;
        property Subaction[idx: Integer]: IExodusAction read getSubactionAt;
    end;

    TBaseAction = class(TInterfacedObject, IExodusAction)
    private
        _name: Widestring;
        _caption: Widestring;
        _imgIdx: Integer;
        _enabled: Boolean;
        _subactions: TList;

    protected
        procedure setCaption(txt: Widestring);
        procedure setImageIndex(idx: Integer);
        procedure setEnabled(flag: Boolean);

        function getSubactions(): TList;
        procedure setSubactions(acts: TList);
        procedure addSubaction(act: IExodusAction);
        procedure remSubaction(act: IExodusAction);

    public
        constructor Create(name: Widestring);
        destructor Destroy(); override;

        function getName: Widestring;
        function getCaption: Widestring;
        function getImageIndex: Integer;
        function getEnabled: Boolean;
        function getSubactionCount: Integer;
        function getSubactionAt(idx: Integer): IExodusAction;

        procedure execute(items: IExodusItemList); virtual; abstract;
    end;
    
    TProxyAction = class(TInterfacedObject, IExodusAction)
    private
        _itemtype: Widestring;
        _name: Widestring;
        _delegate: IExodusAction;
        _enabling: TWidestringList;
        _disabling: TWidestringList;

    public
        constructor Create(itemtype, actname: Widestring);
        destructor Destroy(); override;

        function getName: Widestring;
        function getCaption: Widestring;
        function getImageIndex: Integer;
        function getEnabled: Boolean;
        function getSubactionCount: Integer;
        function getSubactionAt(idx: Integer): IExodusAction;

        procedure execute(items: IExodusItemList);

        procedure addToEnabling(filter: TWidestringList);
        procedure addToDisabling(filter: TWidestringList);
        function applies(items: TWidestringList): Boolean;

        property ItemType: Widestring read _itemtype;
        property Delegate: IExodusAction read _delegate write _delegate;
        property EnablingFilter: TWidestringList read _enabling;
        property DisablingFilter: TWidestringList read _disabling;
    end;

implementation

uses SysUtils;

{
    (Hidden) Helpers
}
function subsetOf(expected, actual: TWideStringList): Boolean;
var
    idx: Integer;
begin
    if expected.Count > actual.Count then begin
        Result := false;
        exit;
    end;

    for idx := 0 to expected.Count - 1 do begin
        if actual.IndexOf(expected[idx]) = -1 then begin
            result := false;
            exit;
        end;
    end;

    Result := true;
end;

{
    TBaseAction implementation
}
constructor TBaseAction.Create(name: Widestring);
begin
    inherited Create;

    _name := name;
    _subactions := TList.Create;
end;
destructor TBaseAction.Destroy;
begin
    FreeAndNil(_subactions);

    inherited;
end;

function TBaseAction.getName: Widestring;
begin
    Result := _name;
end;

function TBaseAction.getCaption: Widestring;
begin
    Result := _caption;
end;
procedure TBaseAction.setCaption(txt: WideString);
begin
     _caption := txt;
end;

function TBaseAction.getImageIndex: Integer;
begin
    Result := _imgIdx;
end;
procedure TBaseAction.setImageIndex(idx: Integer);
begin
    _imgIdx := idx;
end;

function TBaseAction.getEnabled: Boolean;
begin
    Result := _enabled;
end;
procedure TBaseAction.setEnabled(flag: Boolean);
begin
    _enabled := flag;
end;

function TBaseAction.getSubactions: TList;
begin
    Result := _subactions;
end;
procedure TBaseAction.setSubactions(acts: TList);
var
    idx: Integer;
    act: IExodusAction;
begin
    if (acts = _subactions) then exit;
    
    _subactions.Clear();
    if (acts <> nil) and (acts.Count > 0) then begin
        for idx := 0 to acts.Count - 1 do begin
            act := IExodusAction(acts[idx]);
            _subactions.Add(TObject(act));
        end;
    end;
end;

function TBaseAction.getSubactionCount: Integer;
begin
    Result := _subactions.Count;
end;
function TBaseAction.getSubactionAt(idx: Integer): IExodusAction;
begin
    Result := IExodusAction(_subactions[idx]);
end;
procedure TBaseAction.addSubaction(act: IExodusAction);
begin
    if (act <> nil) and (_subactions.IndexOf(TObject(act)) = -1) then
        _subactions.Add(TObject(act));
end;
procedure TBaseAction.remSubaction(act: IExodusAction);
begin
    if (act <> nil) then
        _subactions.Remove(TObject(act));
end;

{
    TProxyAction implementation
}
Constructor TProxyAction.Create(itemtype, actname: Widestring);
begin
    inherited Create;

    _name := actname;
    _itemtype := itemtype;

    _enabling := TWidestringList.Create;
    _enabling.Duplicates := dupIgnore;
    _enabling.Sorted := true;

    _disabling := TWidestringList.Create;
    _disabling.Duplicates := dupIgnore;
    _disabling.Sorted := true;
end;
Destructor TProxyAction.Destroy;
begin
    FreeAndNil(_enabling);
    FreeAndNil(_disabling);

    inherited;
end;

function TProxyAction.getName: Widestring;
begin
    Result := _name;
end;

function TProxyAction.getCaption: Widestring;
begin
    if (Delegate <> nil) then
        Result := Delegate.Caption
    else
        Result := '';
end;
function TProxyAction.getImageIndex: Integer;
begin
    if (Delegate <> nil) then
        Result := Delegate.ImageIndex
    else
        Result := -1;
end;
function TProxyAction.getEnabled: Boolean;
begin
    if (Delegate <> nil) then
        Result := Delegate.Enabled
    else
        Result := false;
end;
function TProxyAction.getSubactionCount: Integer;
begin
    if (Delegate <> nil) then
        Result := Delegate.SubactionCount
    else
        Result := 0;
end;
function TProxyAction.getSubactionAt(idx: Integer): IExodusAction;
begin
    if (Delegate <> nil) then
        Result := Delegate.Subaction[idx]
    else
        Result := nil;
end;

procedure TProxyAction.execute(items: IExodusItemList);
begin
    if (Delegate <> nil) then Delegate.execute(items);
end;

procedure TProxyAction.addToEnabling(filter: TWidestringList);
var
    val: Widestring;
    idx: Integer;
begin
    if (filter = nil) or (filter.Count = 0) then exit;

    if (_enabling.Count = 0) then begin
        _enabling.AddStrings(filter);
    end
    else begin
        for idx := _enabling.Count - 1 downto 0 do begin
            val := _enabling[idx];
            if (filter.IndexOf(val) = -1) then _enabling.Delete(idx);
        end;
    end;
end;
procedure TProxyAction.addToDisabling(filter: TWidestringList);
begin
    if (filter = nil) or (filter.Count = 0) then exit;

    _disabling.AddStrings(filter);
end;

function TProxyAction.applies(items: TWideStringList): Boolean;
begin
    //Check for "do or die"!
    Result := Self.getEnabled;

    //Check enabling
    if Result and (_enabling.Count > 0) then
        Result := subsetOf(_enabling, items);

    //Check disabling
    if Result and (_disabling.Count > 0) then
        Result := subsetOf(_disabling, items);
end;

end.
