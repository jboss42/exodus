unit COMToolbarControl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, Variants, ComCtrls, ComObj, ActiveX, Exodus_TLB, StdVcl, PLUGINCONTROLLib_TLB ;

type
  TExodusToolbarControl = class(TAutoObject, IExodusToolbarControl)
  private
    MyControl: TMyControl;

  public
    constructor Create(MyControl: TMyControl);

  protected
    function  Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function  Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;

  end;

implementation

uses
    RosterImages, ComServ;

constructor TExodusToolbarControl.Create(MyControl: TMyControl);
begin
      Self.MyControl := MyControl;
end;

function TExodusToolbarControl.Get_Visible: WordBool;
begin
    Result := MyControl.Visible;
end;

procedure TExodusToolbarControl.Set_Visible(Value: WordBool);
begin
    MyControl.Visible := Value;
end;

function TExodusToolbarControl.Get_Enabled: WordBool;
begin
    Result := MyControl.Enabled;
end;

procedure TExodusToolbarControl.Set_Enabled(Value: WordBool);
begin
    MyControl.Enabled := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusToolbarControl, Class_ExodusToolbarControl,
    ciMultiInstance, tmApartment);
end.
