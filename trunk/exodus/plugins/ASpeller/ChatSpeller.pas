unit ChatSpeller;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ExodusCOM_TLB, 
    ComObj, ActiveX, ExASpell_TLB, StdVcl;

type
  TChatSpeller = class(TAutoObject, IExodusChatPlugin)
  protected
    function onAfterMessage(var Body: WideString): WideString; safecall;
    procedure onBeforeMessage(var Body: WideString); safecall;
    procedure onClose; safecall;
    procedure onContextMenu(const ID: WideString); safecall;
    procedure onKeyPress(const Key: WideString); safecall;
    procedure onMenu(const ID: WideString); safecall;
    procedure onNewWindow(HWND: Integer); safecall;
    procedure onRecvMessage(const Body, xml: WideString); safecall;

  end;

implementation

uses ComServ;

function TChatSpeller.onAfterMessage(var Body: WideString): WideString;
begin

end;

procedure TChatSpeller.onBeforeMessage(var Body: WideString);
begin

end;

procedure TChatSpeller.onClose;
begin

end;

procedure TChatSpeller.onContextMenu(const ID: WideString);
begin

end;

procedure TChatSpeller.onKeyPress(const Key: WideString);
begin

end;

procedure TChatSpeller.onMenu(const ID: WideString);
begin

end;

procedure TChatSpeller.onNewWindow(HWND: Integer);
begin

end;

procedure TChatSpeller.onRecvMessage(const Body, xml: WideString);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TChatSpeller, Class_ChatSpeller,
    ciMultiInstance, tmApartment);
end.
