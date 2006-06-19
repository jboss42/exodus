library TestPlugin;

uses
  ComServ,
  Tester in 'Tester.pas' {TesterPlugin: CoClass},
  TestPlugin_TLB in 'TestPlugin_TLB.pas',
  TesterIQCallback in 'TesterIQCallback.pas' {TesterIQCallback: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
