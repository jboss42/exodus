unit COMPPDB;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, ExodusCOM_TLB, StdVcl;

type
  TExodusPPDB = class(TAutoObject, IExodusPPDB)
  protected
    { Protected declarations }
  end;

implementation

uses ComServ;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusPPDB, Class_ExodusPPDB,
    ciMultiInstance, tmApartment);
end.
