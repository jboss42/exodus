library ExNetMeeting;

uses
  ComServ,
  ExNetMeeting_TLB in 'ExNetMeeting_TLB.pas',
  NMPlugin in 'NMPlugin.pas' {ExNetmeetingPlugin: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
