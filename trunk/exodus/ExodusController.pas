unit ExodusController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    XMLTag,
    ExodusPlugin_TLB, 
    Classes, ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusController = class(TAutoObject, IExodusController)
  protected
    function Get_Connected: WordBool; safecall;
    function Get_Server: WideString; safecall;
    function Get_Username: WideString; safecall;
    procedure AddRosterItem(const jid, nickname, group: WideString); safecall;
    procedure ChangePresence; safecall;
    function isRosterJID(const jid: WideString): WordBool; safecall;
    function isSubscribed(const jid: WideString): WordBool; safecall;
    procedure RegisterCallback(const xpath: WideString;
      var callback: OleVariant); safecall;
    procedure RemoveRosterItem(const jid: WideString); safecall;
    procedure Send(const xml: WideString); safecall;
    procedure UnRegisterCallback(callback_id: Integer); safecall;
    procedure GetProfile(const jid: WideString); safecall;
    procedure StartChat(const jid, resource, nickname: WideString); safecall;
    procedure RegisterChatPlugin(var Plugin: OleVariant); safecall;
    procedure RegisterRoomPlugin(var Plugin: OleVariant); safecall;
    procedure CreateDockableWindow(HWND: Integer); safecall;
    { Protected declarations }
  end;

  TPlugin = class
    com: IExodusPlugin;
    end;

  TPluginProxy = class
    id: integer;
    com: OleVariant;
    constructor Create(xpath: string; obj: OleVariant);
    destructor Destroy; override;

    procedure Callback(event: string; tag: TXMLTag);
    end;


// Forward declares for plugin utils
procedure InitPlugins();
procedure LoadPlugin(com_name: string);
procedure UnloadPlugins();

implementation

uses
    Jabber1, Session, Roster, PrefController, Unicode, 
    Dialogs, Variants, Forms, SysUtils, ComServ;

var
    plugs: TStringList;
    proxies: TStringList;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure InitPlugins();
var
    s: TWideStringlist;
    i: integer;
begin
    // load all of the plugins listed in the prefs
    s := TWideStringlist.Create();
    MainSession.Prefs.fillStringList('plugins', s);

    for i := 0 to s.count - 1 do
        LoadPlugin(s[i]);
end;

{---------------------------------------}
procedure LoadPlugin(com_name: string);
var
    idisp: IDispatch;
    plugin: IExodusPlugin;
    p: TPlugin;
begin
    // Fire up an instance of the specified COM object
    if (plugs.indexof(com_name) > -1) then exit;

    //try
        idisp := CreateOleObject(com_name);
    {
    except
        on EOleSysError do begin
            MessageDlg('Plugin class could not be initialized.',
                mtError, [mbOK], 0);
            exit;
            end;
    end;
    }

    plugin := idisp as IExodusPlugin;
    p := TPlugin.Create();
    p.com := plugin;
    plugs.Add(com_name);
    try
        p.com.Startup(frmExodus.ComController as IExodusController);
    except
        MessageDlg('Plugin class could not be initialized.',
            mtError, [mbOK], 0);
        exit;
    end;
end;

{---------------------------------------}
procedure UnloadPlugins();
var
    i: integer;
begin
    // kill all of the various plugins which are loaded.
    for i := proxies.Count -1 downto 0 do
        TPluginProxy(proxies.Objects[i]).Free();

    for i := plugs.Count - 1 downto 0 do
        TPlugin(plugs.Objects[i]).Free();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TPluginProxy.Create(xpath: string; obj: OleVariant);
begin
    inherited Create;

    id := MainSession.RegisterCallback(Self.Callback, xpath);
    com := obj;

    proxies.AddObject(IntToStr(id), Self)
end;

{---------------------------------------}
destructor TPluginProxy.Destroy;
var
    idx: integer;
begin
    if (MainSession <> nil) and (id <> -1) then
        MainSession.UnRegisterCallback(id);

    idx := proxies.IndexOfObject(Self);
    if (idx <> -1) then
        proxies.Delete(idx);

    inherited Destroy;
end;

{---------------------------------------}
procedure TPluginProxy.Callback(event: string; tag: TXMLTag);
var
    plugin: IExodusPlugin;
begin
    // call the plugin back
    plugin := IUnknown(com) as IExodusPlugin;
    plugin.Process(tag.xml);
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function TExodusController.Get_Connected: WordBool;
begin
    Result := MainSession.Active;
end;

{---------------------------------------}
function TExodusController.Get_Server: WideString;
begin
    Result := MainSession.Profile.Server;
end;

{---------------------------------------}
function TExodusController.Get_Username: WideString;
begin
    Result := MainSession.Profile.Username;
end;

{---------------------------------------}
procedure TExodusController.AddRosterItem(const jid, nickname,
  group: WideString);
begin
    MainSession.roster.AddItem(jid, nickname, group, true);
end;

{---------------------------------------}
procedure TExodusController.ChangePresence;
begin

end;

{---------------------------------------}
function TExodusController.isRosterJID(const jid: WideString): WordBool;
begin
    Result := (MainSession.Roster.Find(jid) <> nil);
end;

{---------------------------------------}
function TExodusController.isSubscribed(const jid: WideString): WordBool;
var
    ritem: TJabberRosterItem;
begin
    Result := false;
    ritem := MainSession.Roster.Find(jid);
    if (ritem <> nil) then begin
        if (ritem.subscription = 'to') or
        (ritem.subscription = 'both') then
            Result := true;
        end;
end;

{---------------------------------------}
procedure TExodusController.RegisterCallback(const xpath: WideString;
  var callback: OleVariant);
begin
    TPluginProxy.Create(xpath, callback);
end;

{---------------------------------------}
procedure TExodusController.RemoveRosterItem(const jid: WideString);
begin
    // todo: remove roster item for COM
end;

{---------------------------------------}
procedure TExodusController.Send(const xml: WideString);
begin
    MainSession.Stream.Send(xml);
end;

{---------------------------------------}
procedure TExodusController.UnRegisterCallback(callback_id: Integer);
var
    idx: integer;
begin
    idx := proxies.indexOf(IntToStr(callback_id));
    if (idx <> -1) then begin
        TPluginProxy(proxies.Objects[idx]).Free;
        proxies.Delete(idx);
        end;

end;

{---------------------------------------}
procedure TExodusController.GetProfile(const jid: WideString);
begin
    // todo: fetch profile for COM
end;

{---------------------------------------}
procedure TExodusController.StartChat(const jid, resource,
  nickname: WideString);
begin
    // todo: start chat for COM
end;

procedure TExodusController.RegisterChatPlugin(var Plugin: OleVariant);
begin

end;

procedure TExodusController.RegisterRoomPlugin(var Plugin: OleVariant);
begin

end;

procedure TExodusController.CreateDockableWindow(HWND: Integer);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusController, Class_ExodusController,
    ciMultiInstance, tmApartment);

  plugs := TStringList.Create();
  proxies := TStringList.Create();

finalization
    plugs.Free();
    proxies.Free();

end.
