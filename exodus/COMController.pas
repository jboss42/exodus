unit COMController;
{
    Copyright 2003, Peter Millard

    This file is part of Exodus.

    Exodus is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Exodus is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Exodus; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    XMLTag, Unicode,
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
    function addPluginMenu(const Caption: WideString): WideString; safecall;
    procedure removePluginMenu(const ID: WideString); safecall;
    procedure monitorImplicitRegJID(const JabberID: WideString;
      FullJID: WordBool); safecall;
    function getAgentService(const Server, Service: WideString): WideString;
      safecall;
    procedure getAgentList(const Server: WideString); safecall;
    function generateID: WideString; safecall;
    function Get_IsInvisible: WordBool; safecall;
    function Get_IsPaused: WordBool; safecall;
    function Get_Port: Integer; safecall;
    function Get_PresenceShow: WideString; safecall;
    function Get_PresenceStatus: WideString; safecall;
    function Get_Priority: Integer; safecall;
    function Get_Resource: WideString; safecall;
    function isBlocked(const JabberID: WideString): WordBool; safecall;
    procedure Block(const JabberID: WideString); safecall;
    procedure Connect; safecall;
    procedure Disconnect; safecall;
    procedure UnBlock(const JabberID: WideString); safecall;
    function getPrefAsBool(const Key: WideString): WordBool; safecall;
    function getPrefAsInt(const Key: WideString): Integer; safecall;
    function getPrefAsString(const Key: WideString): WideString; safecall;
    procedure setPrefAsBool(const Key: WideString; Value: WordBool); safecall;
    procedure setPrefAsInt(const Key: WideString; Value: Integer); safecall;
    procedure setPrefAsString(const Key_, Value: WideString); safecall;
    function findChat(const JabberID, Resource: WideString): Integer; safecall;
    procedure startInstantMsg(const JabberID: WideString); safecall;
    procedure startRoom(const RoomJID, Nickname, Password: WideString);
      safecall;
    procedure startSearch(const SearchJID: WideString); safecall;
    procedure showJoinRoom(const RoomJID, Nickname, Password: WideString);
      safecall;
    procedure startBrowser(const BrowseJID: WideString); safecall;
    procedure showCustomPresDialog; safecall;
    procedure showDebug; safecall;
    procedure showLogin; safecall;
    procedure showPrefs; safecall;
    procedure showToast(const Message: WideString; wndHandle,
      imageIndex: Integer); safecall;
    procedure setPresence(const Show, Status: WideString; Priority: Integer);
      safecall;
    function Get_Roster: IExodusRoster; safecall;
    function Get_PPDB: IExodusPPDB; safecall;
    function registerBrowseNS(const Namespace: WideString): WideString;
      safecall;
    function registerDiscoFeature(const Feature: WideString): WideString;
      safecall;
    function registerDiscoItem(const JabberID, Name: WideString): WideString;
      safecall;
    procedure removeBrowseNS(const ID: WideString); safecall;
    procedure removeDiscoFeature(const ID: WideString); safecall;
    procedure removeDiscoItem(const ID: WideString); safecall;
    function registerPresenceXML(const XML: WideString): WideString; safecall;
    procedure removePresenceXML(const ID: WideString); safecall;
    { Protected declarations }
  private
    _menu_items: TWideStringList;

  public
    constructor Create();

    procedure fireNewChat(jid: WideString; ExodusChat: IExodusChat);
    procedure fireMenuClick(Sender: TObject);
  end;

  TPlugin = class
    com: IExodusPlugin;
  end;

  TPluginProxy = class
    private
        _xpath: Widestring;
    public
        id: integer;
        com: OleVariant;
        constructor Create(xpath: Widestring; obj: OleVariant);
        destructor Destroy; override;
        procedure Callback(event: string; tag: TXMLTag);
    end;


// Forward declares for plugin utils
procedure InitPlugins();
procedure LoadPlugin(com_name: string);
procedure UnloadPlugins();

implementation

uses
    ExResponders, 
    Chat, ChatController, JabberID, MsgRecv, Room, Browser, Jud,
    ChatWin, JoinRoom, CustomPres, Prefs, RiserWindow, Debug, 
    COMChatController, Dockable, Agents,
    Jabber1, Session, Roster, PrefController, 
    Menus, Dialogs, Variants, Forms, SysUtils, ComServ;

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
constructor TPluginProxy.Create(xpath: Widestring; obj: OleVariant);
begin
    inherited Create;

    _xpath := xpath;

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
    plugin.Process(_xpath, event, tag.xml);
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TExodusController.Create();
begin
    inherited Create();
    _menu_items := TWidestringList.Create();
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

{---------------------------------------}
function TExodusController.addPluginMenu(
  const Caption: WideString): WideString;
var
    id: Widestring;
    mi: TMenuItem;
begin
    // add a new TMenuItem to the Plugins menu
    mi := TMenuItem.Create(frmExodus);
    frmExodus.mnuPlugins.Add(mi);
    mi.Caption := caption;
    mi.OnClick := frmExodus.mnuPluginDummyClick;

    id := 'plugin_' + IntToStr(_menu_items.Count);
    _menu_items.AddObject(id, mi);
    Result := id;
end;

{---------------------------------------}
procedure TExodusController.removePluginMenu(const ID: WideString);
var
    idx: integer;
begin
    idx := _menu_items.IndexOf(id);
    if (idx >= 0) then begin
        TMenuItem(_menu_items.Objects[idx]).Free();
        _menu_items.Delete(idx);
    end;
end;

{---------------------------------------}
procedure TExodusController.fireMenuClick(Sender: TObject);
var
    i, idx: integer;
begin
    idx := _menu_items.IndexOfObject(Sender);
    if (idx >= 0) then begin
        for i := 0 to plugs.count - 1 do
            TPlugin(plugs.Objects[i]).com.menuClick(_menu_items[idx]);
    end;
end;

{---------------------------------------}
procedure TExodusController.monitorImplicitRegJID(
  const JabberID: WideString; FullJID: WordBool);
begin
    frmExodus.RegisterController.MonitorJid(JabberID, FullJID);
end;

{---------------------------------------}
function TExodusController.getAgentService(const Server,
  Service: WideString): WideString;
var
    al: TAgents;
    a: TAgentItem;
begin
    Result := '';
    al := MainSession.GetAgentsList(Server);
    if (al <> nil) then begin
        a := al.findService(Lowercase(Service));
        if (a <> nil) then
            Result := a.jid;
    end;
end;

{---------------------------------------}
procedure TExodusController.getAgentList(const Server: WideString);
var
    al: TAgents;
begin
    al := MainSession.GetAgentsList(Server);
    if (al =  nil) then begin
        al := MainSession.NewAgentsList(Server);
        al.Fetch(Server);
    end
    else begin
        // we already have it, fire now.
        // fireAgentsList(Server);
    end;
end;

{---------------------------------------}
function TExodusController.generateID: WideString;
begin
    Result := MainSession.generateID();
end;

function TExodusController.Get_IsInvisible: WordBool;
begin
    Result := MainSession.Invisible;
end;

function TExodusController.Get_IsPaused: WordBool;
begin
    Result := MainSession.IsPaused;
end;

function TExodusController.Get_Port: Integer;
begin
    Result := MainSession.Port;
end;

function TExodusController.Get_PresenceShow: WideString;
begin
    Result := MainSession.Show;
end;

function TExodusController.Get_PresenceStatus: WideString;
begin
    Result := MainSession.Status;
end;

function TExodusController.Get_Priority: Integer;
begin
    Result := MainSession.Priority;
end;

function TExodusController.Get_Resource: WideString;
begin
    Result := MainSession.Resource;
end;

function TExodusController.isBlocked(const JabberID: WideString): WordBool;
begin
    Result := MainSession.IsBlocked(JabberID);
end;

{---------------------------------------}
procedure TExodusController.Block(const JabberID: WideString);
var
    tmpjid: TJabberID;
begin
    tmpjid := TJabberID.Create(jabberID);
    MainSession.Block(tmpjid);
    tmpjid.Free();
end;

{---------------------------------------}
procedure TExodusController.Connect;
begin
    if not MainSession.Active then
        MainSession.Connect();
end;

{---------------------------------------}
procedure TExodusController.Disconnect;
begin
    if MainSession.Active then
        MainSession.Disconnect();
end;

{---------------------------------------}
procedure TExodusController.UnBlock(const JabberID: WideString);
var
    tmpjid: TJabberID;
begin
    tmpjid := TJabberID.Create(JabberID);
    MainSession.UnBlock(tmpjid);
    tmpjid.Free();
end;

{---------------------------------------}
function TExodusController.getPrefAsBool(const Key: WideString): WordBool;
begin
    Result := MainSession.Prefs.getBool(key);
end;

{---------------------------------------}
function TExodusController.getPrefAsInt(const Key: WideString): Integer;
begin
    Result := MainSession.Prefs.getInt(key);
end;

{---------------------------------------}
function TExodusController.getPrefAsString(
  const Key: WideString): WideString;
begin
    Result := MainSession.Prefs.getString(key);
end;

{---------------------------------------}
procedure TExodusController.setPrefAsBool(const Key: WideString;
  Value: WordBool);
begin
    MainSession.Prefs.setBool(key, value);
end;

{---------------------------------------}
procedure TExodusController.setPrefAsInt(const Key: WideString;
  Value: Integer);
begin
    MainSession.Prefs.setInt(key, value);
end;

{---------------------------------------}
procedure TExodusController.setPrefAsString(const Key_, Value: WideString);
begin
    MainSession.Prefs.setString(Key_, value);
end;

{---------------------------------------}
function TExodusController.findChat(const JabberID,
  Resource: WideString): Integer;
var
    c: TChatController;
begin
    c := MainSession.ChatList.FindChat(JabberID, Resource, '');
    if (c = nil) then
        Result := 0
    else
        Result := TForm(c.window).Handle;
end;

{---------------------------------------}
procedure TExodusController.startInstantMsg(const JabberID: WideString);
begin
    startMsg(JabberID);
end;

{---------------------------------------}
procedure TExodusController.startRoom(const RoomJID, Nickname,
  Password: WideString);
begin
    startRoom(RoomJID, Nickname, Password);
end;

{---------------------------------------}
procedure TExodusController.startSearch(const SearchJID: WideString);
begin
    startSearch(SearchJID);
end;

{---------------------------------------}
procedure TExodusController.showJoinRoom(const RoomJID, Nickname,
  Password: WideString);
var
    tmpjid: TJabberID;
begin
    tmpjid := TJabberID.Create(RoomJID);
    startJoinRoom(tmpjid, NickName, Password);
    tmpjid.free();
end;

{---------------------------------------}
procedure TExodusController.startBrowser(const BrowseJID: WideString);
begin
    showBrowser(BrowseJID);
end;

{---------------------------------------}
procedure TExodusController.showCustomPresDialog;
begin
    ShowCustomPresence();
end;

{---------------------------------------}
procedure TExodusController.showDebug;
begin
    ShowDebugForm();
end;

{---------------------------------------}
procedure TExodusController.showLogin;
begin
    PostMessage(frmExodus.Handle, WM_SHOWLOGIN, 0, 0);
end;

{---------------------------------------}
procedure TExodusController.showPrefs;
begin
    startPrefs();
end;

{---------------------------------------}
procedure TExodusController.showToast(const Message: WideString; wndHandle,
  imageIndex: Integer);
begin
    showRiserWindow(wndHandle, Message, imageIndex);
end;

{---------------------------------------}
procedure TExodusController.setPresence(const Show, Status: WideString;
  Priority: Integer);
begin
    MainSession.setPresence(Show, Status, Priority);
end;

{---------------------------------------}
function TExodusController.Get_Roster: IExodusRoster;
begin
    Result := frmExodus.COMRoster;
end;

{---------------------------------------}
function TExodusController.Get_PPDB: IExodusPPDB;
begin
    Result := frmExodus.COMPPDB;
end;

{---------------------------------------}
function TExodusController.registerBrowseNS(
  const Namespace: WideString): WideString;
begin
    Result := IntToStr(Exodus_Browse.Namespaces.Add(namespace));
end;

{---------------------------------------}
function TExodusController.registerDiscoFeature(
  const Feature: WideString): WideString;
begin
    Result := IntToStr(Exodus_Disco_Info.Features.Add(Feature));
end;

{---------------------------------------}
function TExodusController.registerDiscoItem(const JabberID,
  Name: WideString): WideString;
begin
    Result := Exodus_Disco_Items.addItem(Name, JabberID);
end;

{---------------------------------------}
procedure TExodusController.removeBrowseNS(const ID: WideString);
var
    idx: integer;
begin
    idx := StrToIntDef(ID, -1);
    if ((idx >= 0) and (idx < Exodus_Browse.Namespaces.Count)) then
        Exodus_Browse.Namespaces.Delete(idx);
end;

{---------------------------------------}
procedure TExodusController.removeDiscoFeature(const ID: WideString);
var
    idx: integer;
begin
    idx := StrToIntDef(ID, -1);
    if ((idx >= 0) and (idx < Exodus_Disco_Info.Features.Count)) then
        Exodus_Disco_Info.Features.Delete(idx);
end;

{---------------------------------------}
procedure TExodusController.removeDiscoItem(const ID: WideString);
begin
    Exodus_Disco_Items.removeItem(ID);
end;

{---------------------------------------}
function TExodusController.registerPresenceXML(
  const XML: WideString): WideString;
begin
    Result := IntToStr(MainSession.Presence_XML.Add(XML));
end;

{---------------------------------------}
procedure TExodusController.removePresenceXML(const ID: WideString);
var
    idx: integer;
begin
    idx := StrToIntDef(ID, -1);
    if ((idx >= 0) and (idx < MainSession.Presence_XML.Count)) then
        MainSession.Presence_XML.Delete(idx);
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
