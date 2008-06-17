unit COMExodusHover;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl, PLUGINCONTROLLib_TLB;

type
  TCOMExodusHover = class(TAutoObject, IExodusHover)
  public
    constructor Create(ItemType: WideString; GUID: WideString); 
    destructor Destroy(); override;
  protected
    function Get_Listener: IExodusHoverListener; safecall;
    procedure Set_Listener(const Value: IExodusHoverListener); safecall;
    function Get_AxControl: IUnknown; safecall;
  private
    _AxControl: TAxControl;
    _ItemType: WideString;
    _Listener: IExodusHoverListener;
  end;

implementation

uses ComServ;

constructor TCOMExodusHover.Create(ItemType: WideString; GUID: WideString);
begin
    _ItemType := ItemType;
    try
       _AxControl := TAXControl.Create(nil, StringToGuid(GUID));
    except
        _AxControl := nil;
    end;
end;

destructor TCOMExodusHover.Destroy();
begin
   _AxControl.Free();
end;

function TCOMExodusHover.Get_Listener: IExodusHoverListener;
begin
    Result := _Listener;
end;

procedure TCOMExodusHover.Set_Listener(const Value: IExodusHoverListener);
begin
    _Listener  := Value;
end;

function TCOMExodusHover.Get_AxControl: IUnknown;
begin
    Result := _AxControl as IUnknown;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCOMExodusHover, Class_COMExodusHover,
    ciMultiInstance, tmApartment);
end.
