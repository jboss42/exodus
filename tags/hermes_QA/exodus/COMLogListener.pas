unit COMLogListener;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusLogListener = class(TAutoObject, IExodusLogListener)
  protected
    procedure EndMessages(Day, Month, Year: Integer); safecall;
    procedure Error(Day, Month, Year: Integer); safecall;
    procedure ProcessMessages(Count: Integer; Messages: PSafeArray); safecall;
    procedure ProcessDates(Count: Integer; Dates: PSafeArray); safecall;

  end;

implementation

uses ComServ;

procedure TExodusLogListener.EndMessages(Day, Month, Year: Integer);
begin

end;

procedure TExodusLogListener.Error(Day, Month, Year: Integer);
begin

end;

procedure TExodusLogListener.ProcessMessages(Count: Integer;
  Messages: PSafeArray);
begin

end;

procedure TExodusLogListener.ProcessDates(Count: Integer;
  Dates: PSafeArray);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusLogListener, Class_ExodusLogListener,
    ciMultiInstance, tmApartment);
end.
