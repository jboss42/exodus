unit COMController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    XMLTag,
    Windows,
    Classes, ComObj, ActiveX, ExodusCOM_TLB, StdVcl;

type
  TExodusController = class(TAutoObject, IExodusController)
  protected
    function Get_Connected: WordBool; safecall;
    function Get_Server: WideString; safecall;
    function Get_Username: WideString; safecall;
    procedure AddRosterItem(const jid, nickname, group: WideString); safecall;
    procedure ChangePresence(const Show, Status: WideString;
        Priority: Integer); safecall;
    function isRosterJID(const jid: WideString): WordBool; safecall;
    function isSubscribed(const jid: WideString): WordBool; safecall;
    function RegisterCallback(const xpath: WideString;
      const callback: IExodusPlugin): Integer; safecall;
    procedure RemoveRosterItem(const jid: WideString); safecall;
    procedure Send(const xml: WideString); safecall;
    procedure UnRegisterCallback(callback_id: Integer); safecall;
    procedure GetProfile(const jid: WideString); safecall;
    procedure StartChat(const jid, resource, nickname: WideString); safecall;
    procedure CreateDockableWindow(HWND: Integer; const Caption: WideString);
      safecall;
    { Protected declarations }
  public
    constructor Create();

    procedure fireNewChat(jid: WideString; ExodusChat: IExodusChat);

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
    COMChatController, Dockable, 
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
    s.Free();
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

    try
        idisp := CreateOleObject(com_name);
    except
        on EOleSysError do begin
            MessageDlg('Plugin class could not be initialized.',
                mtError, [mbOK], 0);
            exit;
        end;
end;

    try
        plugin := IUnknown(idisp) as IExodusPlugin;
    except
        on EIntfCastError do begin
            MessageDlg('Plugin class does not support IExodusPlugin',
                mtError, [mbOK], 0);
            exit;
        end;
end;

    p := TPlugin.Create();
    p.com := plugin;
    plugs.AddObject(com_name, p);
    try
        p.com.Startup(frmExodus.ComController);
    except
        MessageDlg('Plugin class could not be initialized.',
            mtError, [mbOK], 0);
        exit;
end;
end;

{---------------------------------------}
procedure UnloadPlugins();
var
    pp: TPlugin;
    i: integer;
begin
    // kill all of the various plugins which are loaded.
    for i := proxies.Count -1 downto 0 do
        TPluginProxy(proxies.Objects[i]).Free();

    // pgm Dec 12, 2002 - Don't free pp, or call pp.com._Release,
    // or else bad things can happen here... assume that mem is getting
    // cleared.
    for i := plugs.Count - 1 downto 0 do begin
        pp := TPlugin(plugs.Objects[i]);
        plugs.Delete(i);
        pp.com.Shutdown();
    end;

    plugs.Clear();
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
constructor TExodusController.Create();
begin
    inherited Create();
end;

{---------------------------------------}
procedure TExodusController.fireNewChat(jid: WideString; ExodusChat: IExodusChat);
var
    i: integer;
begin
    for i := 0 to plugs.count - 1 do
        TPlugin(plugs.Objects[i]).com.NewChat(jid, ExodusChat);
end;

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
    // todo: plugin change presence
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
function TExodusController.RegisterCallback(const xpath: WideString;
  const callback: IExodusPlugin): Integer;
begin
    TPluginProxy.Create(xpath, callback);
end;

{---------------------------------------}
procedure TExodusController.RemoveRosterItem(const jid: WideString);
begin
    // todo: plugin remove roster item
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

{---------------------------------------}
procedure TExodusController.CreateDockableWindow(HWND: Integer;
  const Caption: WideString);
var
    f: TfrmDockable;
begin
    // subclass frmDockable, and re-parent
    // this HWND to the new form
    f := TfrmDockable.Create(Application);
    SetParent(HWND, f.Handle);
    f.ShowDefault();
    ShowWindow(HWND, SW_SHOW);
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
