unit NMPlugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ExodusCOM_TLB, 
    ComObj, ActiveX, ExNetMeeting_TLB, StdVcl;

type
  TExNetmeetingPlugin = class(TAutoObject, IExodusPlugin)
  protected
    function onInstantMsg(const Body, Subject: WideString): WideString;
      safecall;
    procedure Configure; safecall;
    procedure menuClick(const ID: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;
    { Protected declarations }
  private
    _menu_id: Widestring;
    _exodus: IExodusController;
  end;

implementation

uses ComServ;

function TExNetmeetingPlugin.onInstantMsg(const Body,
  Subject: WideString): WideString;
begin

end;

procedure TExNetmeetingPlugin.Configure;
begin

end;

procedure TExNetmeetingPlugin.menuClick(const ID: WideString);
begin
    if (id <> _menu_id) then exit;

    // ok, we have our menu item..
end;

procedure TExNetmeetingPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

procedure TExNetmeetingPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

procedure TExNetmeetingPlugin.Process(const xpath, event, xml: WideString);
begin

end;

procedure TExNetmeetingPlugin.Shutdown;
begin
    _exodus.removeContactMenu(_menu_id);
end;

procedure TExNetmeetingPlugin.Startup(
  const ExodusController: IExodusController);
begin
    _exodus := ExodusController;
    _menu_id := _exodus.addContactMenu('Start NetMeeting Call ... ');
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExNetmeetingPlugin, Class_ExNetmeetingPlugin,
    ciMultiInstance, tmApartment);
end.
