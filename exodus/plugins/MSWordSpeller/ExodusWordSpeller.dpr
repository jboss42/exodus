library ExodusWordSpeller;

uses
  ComServ,
  ExodusWordSpeller_TLB in 'ExodusWordSpeller_TLB.pas',
  WordSpeller in 'WordSpeller.pas' {WordSpeller: CoClass},
  ExodusCOM_TLB in 'ExodusCOM_TLB.pas',
  ChatSpeller in 'ChatSpeller.pas' {ChatSpeller: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
