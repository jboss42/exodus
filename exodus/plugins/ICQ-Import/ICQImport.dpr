library ICQImport;

uses
  ComServ,
  ICQImport_TLB in 'ICQImport_TLB.pas',
  ICQPlugin in 'ICQPlugin.pas' {ICQImportPlugin: CoClass},
  Importer in 'Importer.pas' {frmImport},
  icqUtils in 'icqUtils.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
