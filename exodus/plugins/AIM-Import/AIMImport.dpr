library AIMImport;

uses
  ComServ,
  AIMImport_TLB in 'AIMImport_TLB.pas',
  AIMPlugin in 'AIMPlugin.pas' {AIMImportPlugin: CoClass},
  ExodusCOM_TLB in 'ExodusCOM_TLB.pas',
  Importer in 'Importer.pas' {frmImport};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
