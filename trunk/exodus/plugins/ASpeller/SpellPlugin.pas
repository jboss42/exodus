unit SpellPlugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ExodusCOM_TLB, 
    ComObj, ActiveX, ExASpell_TLB, StdVcl;

type
  TSpellPlugin = class(TAutoObject, IExodusPlugin)
  protected
    function NewIM(const jid: WideString; var Body, Subject: WideString;
      const XTags: WideString): WideString; safecall;
    procedure Configure; safecall;
    procedure MenuClick(const ID: WideString); safecall;
    procedure MsgMenuClick(const ID, jid: WideString; var Body,
      Subject: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;

  end;

implementation

uses ComServ;

function TSpellPlugin.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

procedure TSpellPlugin.Configure;
begin

end;

procedure TSpellPlugin.MenuClick(const ID: WideString);
begin

end;

procedure TSpellPlugin.MsgMenuClick(const ID, jid: WideString; var Body,
  Subject: WideString);
begin

end;

procedure TSpellPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

procedure TSpellPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

procedure TSpellPlugin.Process(const xpath, event, xml: WideString);
begin

end;

procedure TSpellPlugin.Shutdown;
begin

end;

procedure TSpellPlugin.Startup(const ExodusController: IExodusController);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TSpellPlugin, Class_SpellPlugin,
    ciMultiInstance, tmApartment);
end.
