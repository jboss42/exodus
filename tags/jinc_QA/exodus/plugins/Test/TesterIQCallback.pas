unit TesterIQCallback;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Exodus_TLB, ComObj, ActiveX, TestPlugin_TLB, StdVcl;

type
  TTesterIQCallback = class(TAutoObject, IExodusIQListener)
  protected
    procedure ProcessIQ(const Handle, xml: WideString); safecall;
    procedure TimeoutIQ(const Handle: WideString); safecall;

  end;

implementation

uses Dialogs, ComServ;

procedure TTesterIQCallback.ProcessIQ(const Handle, xml: WideString);
begin
    ShowMessage('IQTracker Result: ' + xml);
end;

procedure TTesterIQCallback.TimeoutIQ(const Handle: WideString);
begin
    ShowMessage('IQTracker Timeout!');
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTesterIQCallback, Class_TesterIQCallback,
    ciMultiInstance, tmApartment);
end.
