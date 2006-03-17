library ExHTMLLogger;

uses
  ComServ,
  ExHTMLLogger_TLB in 'ExHTMLLogger_TLB.pas',
  LoggerPlugin in 'LoggerPlugin.pas' {HTMLLogger: CoClass},
  Prefs in 'Prefs.pas' {frmPrefs};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
