unit COMExodusTab;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl, PLUGINCONTROLLib_TLB, TntComCtrls;

type
  TExodusTab = class(TAutoObject, IExodusTab)
  protected
      function Get_Caption: WideString; safecall;
      function Get_ImageIndex: Integer; safecall;
      function Get_Name: WideString; safecall;
      function Get_Visible: Integer; safecall;
      procedure Hide; safecall;
      procedure Set_Caption(const Value: WideString); safecall;
      procedure Set_ImageIndex(Value: Integer); safecall;
      procedure Set_Name(const Value: WideString); safecall;
      procedure Show; safecall;
      procedure Activate; safecall;
      function Get_Handle: Integer; safecall;
      function Get_UID: WideString; safecall;
  private
      _AxControl: TAXControl;
      _Page: TTntTabSheet;
      _UID:  WideString;
  public
      constructor Create(Page: TTntTabSheet; ActiveX_GUID: WideString);
      destructor Destroy; override;
  end;

implementation

uses ComServ, RosterForm, SysUtils;

{---------------------------------------}
constructor TExodusTab.Create(Page: TTntTabSheet; ActiveX_GUID: WideString);
var
    //Guid: WideString;
    g: TGUID;
    //guid: string;
begin
    _AxControl := nil;
    _Page :=  Page;
    _UID := ActiveX_GUID;
    if (_UID <> '') then
        _AxControl := TAXControl.Create(_Page, StringToGuid(_UID))
    else
    begin
        CreateGUID(g);
        _UID := GUIDToString(g);
    end;
end;

{---------------------------------------}
destructor TExodusTab.Destroy();
begin
    _AxControl.Free;
    _Page.Free;
    inherited;
end;

function TExodusTab.Get_Caption: WideString;
begin

end;

function TExodusTab.Get_ImageIndex: Integer;
begin
   Result := _Page.ImageIndex;
end;

function TExodusTab.Get_Name: WideString;
begin

end;

function TExodusTab.Get_Visible: Integer;
begin

end;

procedure TExodusTab.Hide;
begin

end;

procedure TExodusTab.Set_Caption(const Value: WideString);
begin

end;

procedure TExodusTab.Set_ImageIndex(Value: Integer);
begin
    _Page.ImageIndex := Value;
end;

procedure TExodusTab.Set_Name(const Value: WideString);
begin

end;

procedure TExodusTab.Show;
begin

end;

procedure TExodusTab.Activate;
begin
    _Page.SetFocus;
end;

function TExodusTab.Get_Handle: Integer;
begin
    Result := _Page.Handle;
end;

function TExodusTab.Get_UID: WideString;
begin
   Result := _UID;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusTab, Class_ExodusTab,
    ciMultiInstance, tmApartment);
end.
