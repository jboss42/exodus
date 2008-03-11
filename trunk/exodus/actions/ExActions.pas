unit ExActions;

interface

uses ActiveX, Classes, ComObj, Contnrs, Unicode, Exodus_TLB;

type TBaseAction = class(TAutoIntfObject, IExodusAction)
    private
        _name: Widestring;
        _caption: Widestring;
        _imgIdx: Integer;
        _enabled: Boolean;
        _subactions: TInterfaceList;

    protected
        procedure set_Caption(txt: Widestring);
        procedure set_ImageIndex(idx: Integer);
        procedure set_Enabled(flag: WordBool);

        function Get_SubActionsList(): TInterfaceList;
        procedure Set_SubActionsList(acts: TInterfaceList);
        procedure addSubaction(act: IExodusAction);
        procedure remSubaction(act: IExodusAction);

    public
        constructor Create(name: Widestring);
        destructor Destroy(); override;

        function Get_Name: Widestring; safecall;
        function Get_Caption: Widestring; safecall;
        function Get_ImageIndex: Integer; safecall;
        function Get_Enabled: WordBool; safecall;
        function Get_SubActionCount: Integer; safecall;
        function Get_SubAction(idx: Integer): IExodusAction; safecall;

        procedure execute(const items: IExodusItemList); virtual; safecall;
    end;

implementation

uses ComServ, SysUtils;

{
    TBaseAction implementation
}
constructor TBaseAction.Create(name: Widestring);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusAction);

    _name := name;
    _imgIdx:= -1;
    _enabled := true;
    _subactions := TInterfaceList.Create;
end;
destructor TBaseAction.Destroy;
begin
    FreeAndNil(_subactions);

    inherited;
end;

function TBaseAction.Get_Name: Widestring;
begin
    Result := _name;
end;

function TBaseAction.Get_Caption: Widestring;
begin
    Result := _caption;
end;
procedure TBaseAction.set_Caption(txt: WideString);
begin
     _caption := txt;
end;

function TBaseAction.Get_ImageIndex: Integer;
begin
    Result := _imgIdx;
end;
procedure TBaseAction.set_ImageIndex(idx: Integer);
begin
    _imgIdx := idx;
end;

function TBaseAction.Get_Enabled: WordBool;
begin
    Result := _enabled;
end;
procedure TBaseAction.set_Enabled(flag: WordBool);
begin
    _enabled := flag;
end;

function TBaseAction.Get_SubActionsList: TInterfaceList;
begin
    Result := _subactions;
end;
procedure TBaseAction.Set_SubActionsList(acts: TInterfaceList);
var
    idx: Integer;
    act: IExodusAction;
begin
    if (acts = _subactions) then exit;
    
    _subactions.Clear();
    if (acts <> nil) and (acts.Count > 0) then begin
        for idx := 0 to acts.Count - 1 do begin
            act := IExodusAction(acts[idx]);
            _subactions.Add(act);
        end;
    end;
end;

function TBaseAction.Get_SubActionCount: Integer;
begin
    Result := _subactions.Count;
end;
function TBaseAction.Get_SubAction(idx: Integer): IExodusAction;
begin
    Result := IExodusAction(_subactions[idx]);
end;
procedure TBaseAction.addSubaction(act: IExodusAction);
begin
    if (act <> nil) and (_subactions.IndexOf(act) = -1) then
        _subactions.Add(act);
end;
procedure TBaseAction.remSubaction(act: IExodusAction);
begin
    if (act <> nil) then
        _subactions.Remove(act);
end;

procedure TBaseAction.execute(const items: IExodusItemList);
begin
    //DO NOTHING
end;

end.
