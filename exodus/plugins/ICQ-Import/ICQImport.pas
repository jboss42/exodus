unit ICQImport;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Project1_TLB, StdVcl;

type
  TICQImportPlugin = class(TAutoObject, IICQImportPlugin)
  protected
    { Protected declarations }
  end;

implementation

uses ComServ;

initialization
  TAutoObjectFactory.Create(ComServer, TICQImportPlugin, Class_ICQImportPlugin,
    ciMultiInstance, tmApartment);
end.
