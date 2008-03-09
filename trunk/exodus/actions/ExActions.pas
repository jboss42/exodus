unit ExActions;

interface

uses Classes, Contnrs, Unicode, Exodus_TLB;

{
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
}
type TBaseAction = class(TInterfacedObject)
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

implementation

uses SysUtils;

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

end.
