unit COMExodusHover;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl, PLUGINCONTROLLib_TLB, ExFrame;

type
  TCOMExodusHover = class(TAutoObject, IExodusHover)
  public
    constructor Create(ItemType: WideString; GUID: WideString);
    destructor Destroy(); override;
  protected
    function Get_Listener: IExodusHoverListener; safecall;
    procedure Set_Listener(const Value: IExodusHoverListener); safecall;
    function Get_AXControl: IUnknown; safecall;
    procedure Show(const Item: IExodusItem); safecall;
    procedure Hide(const Item: IExodusItem); safecall;

  private
    _AxControl: TAxControl;
    _ItemType: WideString;
    _Listener: IExodusHoverListener;
    _HoverFrame: TExFrame;
  end;

implementation

uses
    ComServ,
    RosterForm,
    ExItemHoverForm,
    Controls,
    SysUtils;

constructor TCOMExodusHover.Create(ItemType: WideString; GUID: WideString);
begin
    _Listener := nil;
    _ItemType := ItemType;
    try
       _AxControl := TAXControl.Create(nil, StringToGuid(GUID));
       _HoverFrame := TExFrame.Create(nil);
       _AxControl.Parent := _HoverFrame;
       _AXControl.Align := alClient;
    except
        _AxControl := nil;
    end;
end;

destructor TCOMExodusHover.Destroy();
begin
   _AxControl.Free();
   _HoverFrame.Free();
end;

function TCOMExodusHover.Get_Listener: IExodusHoverListener;
begin
    Result := _Listener;
end;

procedure TCOMExodusHover.Set_Listener(const Value: IExodusHoverListener);
begin
    _Listener  := Value;
end;

function TCOMExodusHover.Get_AXControl: IUnknown;
begin
    Result := IUnknown(_AxControl.OleObject);
end;

procedure TCOMExodusHover.Show(const Item: IExodusItem);
begin
    _HoverFrame.Parent := GetRosterWindow().HoverWindow;
    GetRosterWindow().HoverWindow.CurrentFrame := _HoverFrame;
    if (_Listener <> nil) then
        _Listener.OnShow(Item);
end;

procedure TCOMExodusHover.Hide(const Item: IExodusItem);
begin
    if (_Listener <> nil) then
        _Listener.OnHide(Item);
    GetRosterWindow().HoverWindow.CurrentFrame := nil;
    _HoverFrame.Parent := nil;
end;



initialization
  TAutoObjectFactory.Create(ComServer, TCOMExodusHover, Class_COMExodusHover,
    ciMultiInstance, tmApartment);
end.
