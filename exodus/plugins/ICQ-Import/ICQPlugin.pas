unit ICQPlugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ExodusCOM_TLB, ComObj, ActiveX, ICQImport_TLB, StdVcl;

type
  TICQImportPlugin = class(TAutoObject, IICQImportPlugin, IExodusPlugin)
  protected
    procedure menuClick(const ID: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;
    procedure onAgentsList(const Server: WideString); safecall;
    { Protected declarations }
  private
    _controller: IExodusController;
    _menu_id: Widestring;
  end;

{-----------------------------------------}
{-----------------------------------------}
{-----------------------------------------}
{-----------------------------------------}
implementation
uses
    Importer, StrUtils, SysUtils,
    Dialogs, ComServ;

{-----------------------------------------}
procedure TICQImportPlugin.menuClick(const ID: WideString);
var
    f: TfrmImport;
begin
    if (id = _menu_id) then begin
        // make sure we are online..
        if (_controller.Connected = false) then begin
            MessageDlg('You must be connected before trying to import a ICQ Contact List.',
                mtError, [mbOK], 0);
            exit;
        end;
        f := getImportForm(_controller, true);
        f.Show();
    end;
end;

{-----------------------------------------}
procedure TICQImportPlugin.onAgentsList(const Server: WideString);
var
    f: TfrmImport;
begin
    // we got back an agents list
    f := getImportForm(_controller, false);
    if (f <> nil) then begin
        if (AnsiSameText(Server, f.txtGateway.Text)) then begin
            f.processAgents();
        end;
    end;
end;

{-----------------------------------------}
procedure TICQImportPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

{-----------------------------------------}
procedure TICQImportPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

{-----------------------------------------}
procedure TICQImportPlugin.Process(const xml: WideString);
begin

end;

{-----------------------------------------}
procedure TICQImportPlugin.Shutdown;
begin

end;

{-----------------------------------------}
procedure TICQImportPlugin.Startup(
  const ExodusController: IExodusController);
begin
    _controller := ExodusController;
    _menu_id := _controller.addPluginMenu('Import ICQ Contacts');
end;

initialization
  TAutoObjectFactory.Create(ComServer, TICQImportPlugin, Class_ICQImportPlugin,
    ciMultiInstance, tmApartment);
end.
