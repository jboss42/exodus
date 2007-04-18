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
    ExtCtrls, ChatController,
    Presence, NodeItem, XMLParser, XMLTag, Unicode, Menus,
    Windows, Classes, ComObj, ActiveX, Exodus_TLB, StdVcl;

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
    function CreateDockableWindow(const Caption: WideString): Integer;
      safecall;
    function AddPluginMenu(const caption: WideString;
      const menuListener: IExodusMenuListener): WideString; safecall;
    procedure removePluginMenu(const ID: WideString); safecall;
    procedure monitorImplicitRegJID(const JabberID: WideString;
      FullJID: WordBool); safecall;
    function getAgentService(const Server, Service: WideString): WideString;
      safecall;
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
    function GetPrefAsBool(const Key: WideString): WordBool; safecall;
    function GetPrefAsInt(const Key: WideString): Integer; safecall;
    function GetPrefAsString(const Key: WideString): WideString; safecall;
    procedure SetPrefAsBool(const Key: WideString; Value: WordBool); safecall;
    procedure SetPrefAsInt(const Key: WideString; Value: Integer); safecall;
    procedure SetPrefAsString(const Key, Value: WideString); safecall;
    function FindChat(const JabberID, resource: WideString): Integer; safecall;
    procedure StartInstantMsg(const JabberID: WideString); safecall;
    procedure StartRoom(const roomJID, Nickname, password: WideString; sendPresence,
      defaultConfig, useRegisteredNickname: WordBool); safecall;
    procedure StartSearch(const SearchJID: WideString); safecall;
    procedure ShowJoinRoom(const RoomJID, nickname, Password: WideString); safecall;
    procedure StartBrowser(const BrowseJID: WideString); safecall;
    procedure ShowCustomPresDialog; safecall;
    procedure ShowDebug; safecall;
    procedure ShowLogin; safecall;
    procedure ShowPrefs; safecall;
    procedure ShowToast(const Message: WideString; wndHandle, imageIndex: Integer);
      safecall;
    procedure SetPresence(const Show, Status: WideString; Priority: Integer);
      safecall;
    function Get_Roster: IExodusRoster; safecall;
    function Get_PPDB: IExodusPPDB; safecall;
    function RegisterDiscoItem(const JabberID, Name: WideString): WideString;
      safecall;
    procedure RemoveDiscoItem(const ID: WideString); safecall;
    function RegisterPresenceXML(const xml: WideString): WideString; safecall;
    procedure RemovePresenceXML(const ID: WideString); safecall;
    procedure TrackWindowsMsg(Message: Integer); safecall;
    function AddContactMenu(const caption: WideString;
      const menuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveContactMenu(const ID: WideString); safecall;
    function GetActiveContact: WideString; safecall;
    function GetActiveGroup: WideString; safecall;
    function GetActiveContacts(Online: WordBool): OleVariant; safecall;
    function Get_LocalIP: WideString; safecall;
    procedure setPluginAuth(const AuthAgent: IExodusAuth); safecall;
    procedure setAuthenticated(Authed: WordBool; const XML: WideString);
      safecall;
    procedure setAuthJID(const Username, Host, Resource: WideString); safecall;
    function AddMessageMenu(const caption: WideString;
      const menuListener: IExodusMenuListener): WideString; safecall;
    function AddGroupMenu(const caption: WideString;
      const menuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveGroupMenu(const ID: WideString); safecall;
    procedure RegisterWithService(const JabberID: WideString); safecall;
    procedure lastRelease(var Shutdown: boolean);
    procedure ShowAddContact(const jid: WideString); safecall;
    procedure RegisterCapExtension(const ext, feature: WideString); safecall;
    procedure UnregisterCapExtension(const ext: WideString); safecall;
    function Get_RosterImages: IExodusRosterImages; safecall;
    function Get_EntityCache: IExodusEntityCache; safecall;
    procedure Debug(const Value: WideString); safecall;
    function TrackIQ(const XML: WideString; const Listener: IExodusIQListener;
      Timeout: Integer): WideString; safecall;
    procedure FireEvent(const Event, XML, Arg: WideString); safecall;
    function RegisterListener(const xpath: WideString;
      const Listener: IExodusListener): Integer; safecall;
    function Get_Toolbar: IExodusToolbar; safecall;
    function Get_ContactLogger: IExodusLogger; safecall;
    procedure Set_ContactLogger(const Value: IExodusLogger); safecall;
    function Get_RoomLogger: IExodusLogger; safecall;
    procedure Set_RoomLogger(const Value: IExodusLogger); safecall;
    procedure AddStringlistValue(const Key, Value: WideString); safecall;
    procedure RemoveMessageMenu(const menuID: WideString); safecall;
    function GetStringlistCount(const key: WideString): Integer; safecall;
    function GetStringlistValue(const key: WideString; index: Integer): WideString;
      safecall;
    procedure RemoveStringlistValue(const key, value: WideString); safecall;
    function Get_BookmarkManager: IExodusBookmarkManager; safecall;

    { Protected declarations }
  private
    _menu_items: TWideStringList;
    _roster_menus: TWidestringlist;
    _msg_menus: TWidestringList;
    _nextid: longint;
    _parser: TXMLTagParser;
    // XXX: _cookie: integer;

    _contact_logger: IExodusLogger;
    _room_logger: IExodusLogger;
    
  public
    constructor Create();
    procedure Initialize(); override;
    destructor Destroy(); override;

    procedure fireNewChat(jid: WideString; ExodusChat: IExodusChat);
    procedure fireNewRoom(jid: Widestring; ExodusChat: IExodusChat);
    procedure fireNewOutgoingIM(jid: Widestring; ExodusChat: IExodusChat);
    procedure fireNewIncomingIM(jid: Widestring; ExodusChat: IExodusChat);    
    procedure fireMenuClick(Sender: TObject);
    procedure fireRosterMenuClick(Sender: TObject);
    function fireIM(Jid: Widestring; var Body: Widestring;
        var Subject: Widestring; xtags: Widestring): Widestring;
    procedure fireMsgMenuClick(idx: integer; jid: Widestring;
        var Body: Widestring; var Subject: Widestring);

    procedure populateMsgMenus(parent: TPopupMenu; event: TNotifyEvent);

    property ContactLogger: IExodusLogger read _contact_logger write Set_ContactLogger;
    property RoomLogger: IExodusLogger read _room_logger write Set_RoomLogger; 

  end;

    TPlugin = class
        com: IExodusPlugin;
    end;

    // This class is a local object which receives events which a plugin has
    // registered for, and sends them thru the COM interface to the actual
    // plugin. Using this method, the dispatcher never needs to understand COM.
    TPluginProxy = class
    private
        _xpath: Widestring;

        procedure init(xpath: Widestring);

    public
        proxy_idx: integer;
        id: integer;

        com: IExodusPlugin;
        l: IExodusListener;

        constructor Create(xpath: Widestring; obj: IExodusPlugin); overload;
        constructor Create(xpath: Widestring; obj: IExodusListener); overload;

        destructor Destroy; override;
        procedure RosterCallback(event: string; tag: TXMLTag; ritem: TJabberRosterItem);
        procedure PresenceCallback(event: string; tag: TXMLTag; p: TJabberPres);
        procedure DataCallback(event: string; tag: TXMLTag; data: Widestring);
        procedure ChatCallback(event: string; tag: TXMLTag; controller: TChatController);
        procedure Callback(event: string; tag: TXMLTag);
    end;

    TIQProxy = class
    Private
        _iqid: integer;
        _disid: integer;
        _timer: TTimer;

    Public
        iqid: Widestring;
        com: IExodusIQListener;

        constructor Create(x: TXMLTag; Timeout_val: integer; obj: IExodusIQListener);
        destructor  Destroy; override;

        procedure Callback(event: string; tag: TXMLTag);
        procedure Timeout(Sender: TObject);

    end;

    TMenuContainer = class
    public
        idx: integer;
        id: Widestring;
        caption: Widestring;
        listener : IExodusMenuListener;
    end;


// Forward declares for plugin utils
function CheckPluginDll(dll : WideString; var progID: Widestring; var doc: Widestring): boolean;
function LoadPlugin(com_name: string; var errorStr: WideString): boolean;

procedure InitPlugins();
procedure UnloadPlugins();
procedure ConfigurePlugin(com_name: string);
function IsPluginConfigurable(com_name: string): boolean;
procedure ReloadPlugins(sl: TWidestringlist);

var
    plugs: TStringList;

implementation

uses
    DockContainer, Profile,
    ExResponders, ExSession, GnuGetText, JabberUtils, ExUtils,  EntityCache, Entity,
    Chat, JabberID, MsgRecv, Room, Browser, Jud,
    ChatWin, JoinRoom, CustomPres, Prefs, RiserWindow, Debug,
    COMChatController, Dockable, RegForm,
    Jabber1, Session, RemoveContact, Roster, RosterAdd, RosterWindow, PluginAuth, PrefController,
    Controls, Dialogs, Variants, Forms, StrUtils, SysUtils, shellapi, ComServ;

const
    sPluginErrCreate = 'Plugin could not be created. (%s)';
    sPluginErrNoIntf = 'Plugin class does not support IExodusPlugin. (%s)';
    sPluginErrInit   = 'Plugin class could not be initialized. (%s)';
    sPluginRemove    = 'Remove this plugin from the list of plugins to be loaded at startup?';
    sPluginErrNoLib  = 'A library containing (%s) could not be found.';
    sPluginErrNoReg  = 'The library containing (%s) could not be registered.';
    sPluginNotCOM    = 'The library (%s) does not support COM';


type
    TRegProc = function: HResult; stdcall;
var
    proxies: TStringList;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure InitPlugins();
var
    s, ok: TWideStringlist;
    i: integer;
    errorStr: WideString;
begin
    // load all of the plugins listed in the prefs
    s := TWideStringlist.Create();
    ok := TWidestringList.Create();
    MainSession.Prefs.fillStringList('plugin_selected', s);

    for i := 0 to s.count - 1 do begin
        if (not LoadPlugin(s[i], errorStr)) then begin
            // remove from list?
            if (MessageDlgW(errorStr + #13#10#13#10 + _(sPluginRemove), mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
                ok.Add(s[i]);
        end
        else
            ok.Add(s[i]);
    end;

    // re-save the "ok" ones.
    if (ok.Count <> s.Count) then
        MainSession.Prefs.setStringlist('plugin_selected', ok);

    s.Free();
    ok.Free();
end;

function TrimVersion(const S: string): string;
var
  P: PChar;
begin
  Result := S;
  P := AnsiLastChar(Result);
  while (Length(Result) > 0) and (P^ in ['0'..'9', '.']) do
  begin
    SetLength(Result, P - PChar(Result));
    P := AnsiLastChar(Result);
  end;
end;


function isRegistered(guid : TGUID): boolean;overload;
begin
    try
        ClassIDToProgID(guid);
        Result := true;
    except
        Result := false;
    end;
end;

function isRegistered(progID : String): boolean;overload;
begin
    try
        ProgIDToClassID(PChar(progID));
        Result := true;
    except
        Result := false;
    end;
end;

function registerPlugin(dll: WideString) : boolean;
var
    LibHandle: THandle;
    RegProc: TRegProc;
    tstr : String;
begin
    Result := false;
    tstr := dll;
    try
        LibHandle := LoadLibrary(PChar(tstr));
        if (LibHandle <> 0) then begin
            try
                @RegProc := GetProcAddress(LibHandle, 'DllRegisterServer');
                if (RegProc() = 0) then
                    Result := true;
            finally
                FreeLibrary(LibHandle);
            end;
        end;
    except
    end;
end;

function unregisterPlugin(dll: WideString) : boolean;
var
    LibHandle: THandle;
    RegProc: TRegProc;
    tstr : String;
begin
    Result := false;
    tstr := dll;
    try
        LibHandle := LoadLibrary(PChar(tstr));
        if (LibHandle <> 0) then begin
            try
                @RegProc := GetProcAddress(LibHandle, 'DllUnregisterServer');
                if (RegProc() = 0) then
                    Result := true;
            finally
                FreeLibrary(LibHandle);
            end;
        end;
    except
    end;
end;

{---------------------------------------}
{
    try to get a progid from the given DLL

    Will leave the registration state of a plugin unchanged. Will temporarily
    register plugins to the the prog ID associated with the plugin co-class.
}
function CheckPluginDll(dll : WideString; var progID: Widestring; var doc: Widestring): boolean;
var
    lib : ITypeLib;
    i, j : integer;
    tinfo, iface : ITypeInfo;
    tattr, iattr: PTypeAttr;
    libname, obname, docos: WideString;
    r: cardinal;
    iunk: IUnknown;
    tplug: IExodusPlugin;
    inReg: boolean;
begin

    Result := false;
    try
        OleCheck(LoadTypeLibEx(PWideChar(dll), REGKIND_NONE, lib));
    except
        on EOleSysError do exit;
        on Exception do exit; //probably problems registering the dll
    end;

    // for each type in the project
    for i := 0 to lib.GetTypeInfoCount() - 1 do begin
        // get the info about the type
        try
            OleCheck(lib.GetTypeInfo(i, tinfo));
            // get attributes of the type
            OleCheck(tinfo.GetTypeAttr(tattr));
        except
            on EOleSysError do exit;
        end;
        try
            // is this a coclass?
            if (tattr.typekind <> TKIND_COCLASS) then continue;

            // for each interface that the coclass implements
            for j := 0 to tattr.cImplTypes - 1 do begin
                // get the type info for the interface
                try
                    OleCheck(tinfo.GetRefTypeOfImplType(j, r));
                    OleCheck(tinfo.GetRefTypeInfo(r, iface));

                    // get the attributes of the interface
                    OleCheck(iface.GetTypeAttr(iattr));
                except
                    on EOleSysError do continue;
                end;
                try
                    // is this the IExodusPlugin interface?
                    if  (IsEqualGUID(iattr.guid, Exodus_TLB.IID_IExodusPlugin) or
                         IsEqualGUID(iattr.guid, Exodus_TLB.IID_IExodusPlugin2)) then begin
                        // oho!  it IS.  Get the name of this coclass, so we can show
                        // what we did.  Get the doc string, just to show off.
                        //get current registration state
                        inReg := isRegistered(tattr.guid);
                        try
                            //temporarily register to get progid
                            if (not inReg) then
                                registerPlugin(dll);
                            try
                                //get class name that implements IExodusPlugin
                                //this *requires* the plugin to be registered but addresses
                                //some issue in VS 2003, 2005 plugins where libname
                                //is not neccessarily what gets registered.
                                //progID could contain version info, classlib.classname.version. Strip off
                                //version if it is there
                                progID := TrimVersion(ClassIDToProgID(tattr.guid));
                            finally
                                if (not inReg) then
                                    unregisterPlugin(dll);
                            end;
                        except
                            //well, that failed. Probably not registerable
                            //Try to dummy up the progID by using info from type lib documentation
                            //this is essentially how Exodus has always done it.
                            OleCheck(lib.GetDocumentation(-1, @libname, nil, nil, nil));
                            OleCheck(tinfo.GetDocumentation(-1, @obname, nil, nil, nil));
                            progID := libname + '.' + obname;
                        end;
                        //finally get docos
                        try
                            OleCheck(tinfo.GetDocumentation(-1, nil, @docos, nil, nil));
                            doc := docos;
                            // SysFreeString of obname and doc needed?  In C, yes, but here?
                            Result := true;
                            exit;
                        except
                            on EOleSysError do exit;
                        end;
                    end;
                finally
                    iface.ReleaseTypeAttr(iattr);
                end;
            end; //for each implemented interface

            //ATL 2003, 2005 plugins don't neccessarily put that they
            //implement IExodusPlugin in their type libs. As a secondary
            //discovery method, try loading the class and seeinging
            //if it does in fact implement IExodusPlugin. This will only
            //work correctly if the library has been registered.
            try
                //see if class is registered
                inReg := isRegistered(tattr.guid);

                if (not inReg) then
                    registerPlugin(dll);
                try
                    iunk := CreateComObject(tattr.guid);
                    //see if iunk is an IExodusPlugin. Throws exception if not
                    //tplug := (iunk as IExodusPlugin);
                    try
                      tplug := (iunk as IExodusPlugin);
                    except
                      on EIntfCastError do begin
                          try
                            tplug := (iunk as IExodusPlugin2);
                          except
                            on EIntfCastError do begin
                               continue;
                            end;
                          end;
                      end;
                    end;
                    //type cast above will throw exception if not IExodusPlugin
                    //nil check here is to force the compiler to generate the
                    //typecast code.
                    if (tplug <> nil) then begin
                        //found one, get progID, docs
                        //progID could contain version info, classlib.classname.version. Strip off
                        //version if it is there
                        progID := TrimVersion(ClassIDToProgID(tattr.guid));
                        OleCheck(tinfo.GetDocumentation(-1, nil, @doc, nil, nil));
                        Result := true;
                        exit;
                    end;
                finally
                    tplug := nil;
                    iunk := nil;
                    if (not inReg) then
                        unregisterPlugin(dll);
                end;
            except
                //eat any exceptions. These would be thrown when creating
                //object or if object is not IExodusPlugin
            end;
        finally
            tinfo.ReleaseTypeAttr(tattr);
        end;
    end; //for each type in lib
end;

function scanPluginsForProgID(dir: WideString; progID: string; var dll: WideString) : boolean;
var
    sr: TSearchRec;
    doc: WideString;
    tdll: WideString;
    tpi: WideString;
begin
    Result := false;
    if (not DirectoryExists(dir)) then exit;
    if (FindFirst(dir + '\\*.dll', faAnyFile, sr) = 0) then begin
        repeat
            tdll := dir + '\' + sr.Name;
            if (CheckPluginDll(tdll, tpi, doc) and (tpi = progID)) then begin
                dll := tdll;
                Result := true
            end;
        until ((FindNext(sr) <> 0) or Result);
        FindClose(sr);
    end;
end;

{---------------------------------------}
function LoadPlugin(com_name: string; var errorStr: WideString): boolean;
var
    idisp: IDispatch;
    plugin: IExodusPlugin;
    p: TPlugin;
    dll: WideString;
    dir: WideString;
    reged: boolean;
begin
    // Fire up an instance of the specified COM object
    Result := false;
    if (plugs.indexof(com_name) > -1) then exit;

    reged := false;
    try
        if (not isRegistered(com_name)) then begin
            //scan plugin directory and see if there is a lib with this object
            dir := MainSession.Prefs.getString('plugin_dir');
            if (dir = '') then
               dir := ExtractFilePath(Application.ExeName) + 'plugins';

            if (not scanPluginsForProgID(dir, com_name, dll)) then begin
                errorStr := WideFormat(_(sPluginErrNoLib), [com_name]);
                exit;
            end;
            reged := registerPlugin(dll);
            if (not reged) then begin
                errorStr := WideFormat(_(sPluginErrNoReg), [com_name]);
                exit;
            end;
        end;

        try
            idisp := CreateOleObject(com_name);
        except
            on EOleSysError do begin
                errorStr := WideFormat(_(sPluginErrCreate), [com_name]);
                exit;
            end;
        end;

        try
            plugin := IUnknown(idisp) as IExodusPlugin;
        except
            on EIntfCastError do begin
               try
                  plugin := IUnknown(idisp) as IExodusPlugin2;
                except
                  on EIntfCastError do begin
                     errorStr := WideFormat(_(sPluginErrNoIntf), [com_name]);
                     exit;
                  end;  //begin
                end; //try
            end; //begin
        end;  //try


        p := TPlugin.Create();
        p.com := plugin;
        plugs.AddObject(com_name, p);
        try
            p.com.Startup(ExComController);
        except
            //hmm, fails startup but is left in loaded list
            errorStr := WideFormat(_(sPluginErrInit), [com_name]);
            exit;
        end;
        Result := true;
    finally
        //cleanup if we hit an error case
        if (reged and not Result) then
            unregisterPlugin(dll);
    end;
end;

{---------------------------------------}
procedure ConfigurePlugin(com_name: string);
var
    idx: integer;
    p: TPlugin;
    errorStr: WideString;
begin
    //
    idx := plugs.IndexOf(com_name);
    if (idx < 0) then begin
        LoadPlugin(com_name, errorStr);
        idx := plugs.IndexOf(com_name);
    end;

    if (idx < 0) then begin
        MessageDlgW(errorStr + #13#10#13#10 + _('Plugin could not be initialized or configured.'),
            mtError, [mbOK], 0);
        exit;
    end;

    p := TPlugin(plugs.Objects[idx]);
    try
        p.com.Configure();
    except
        DebugMessage('COM Exception in ConfigurePlugin');
    end;
end;

function IsPluginConfigurable(com_name: string): boolean;
var
    idx: integer;
    p: TPlugin;
    errorStr: WideString;
    com2: IExodusPlugin2;
begin
    //
    Result := false;
    idx := plugs.IndexOf(com_name);
    if (idx < 0) then begin
        LoadPlugin(com_name, errorStr);
        idx := plugs.IndexOf(com_name);
    end;

    if (idx < 0) then begin
        MessageDlgW(errorStr + #13#10#13#10 + _('Plugin could not be initialized or configured.'),
            mtError, [mbOK], 0);
        exit;
    end;

    p := TPlugin(plugs.Objects[idx]);
    try
       com2 := p.com as IExodusPlugin2;
    except
        on EIntfCastError do begin
          com2 := nil
        end;
    end;

    if (com2 <> nil) then
      Result := com2.Configurable
    else
      Result := false;
end;

{---------------------------------------}
procedure ReloadPlugins(sl: TWidestringlist);
var
    i, idx: integer;
    loaded: TStringlist;
    p: TPlugin;
    errorStr: WideString;
begin
    // load all plugins listed, if they are not already loaded.
    loaded := TStringlist.Create();
    for i := 0 to sl.Count -1  do begin
        idx := plugs.IndexOf(sl[i]);
        if (idx < 0) then begin
            if (not LoadPlugin(sl[i], errorStr)) then
                MessageDlgW(errorStr, mtError, [mbOK], 0);
        end;
        loaded.Add(sl[i]);
    end;

    // unload any plugins not in the loaded list
    for i := plugs.Count - 1 downto 0 do begin
        try
            idx := loaded.IndexOf(plugs[i]);
            if (idx < 0) then begin
                // unload the plugin
                p := TPlugin(plugs.Objects[i]);
                plugs.Delete(i);
                p.com.Shutdown;
            end;
        except
            DebugMessage('COM Exception in ReloadPlugins');
        end;
    end;
    loaded.Free();
end;

{---------------------------------------}
procedure UnloadPlugins();
var
    pp: TPlugin;
    i: integer;
begin
    try
        // kill all of the various plugins which are loaded.
        for i := proxies.Count -1 downto 0 do
            TPluginProxy(proxies.Objects[i]).Free();

        // pgm Dec 12, 2002 - Don't free pp, or call pp.com._Release,
        // or else bad things can happen here... assume that mem is getting
        // cleared.
        // JJF 8/14/06 This needs to be addressed
        //todo JJF get definitive answer to when COM objects should be released!

        for i := plugs.Count - 1 downto 0 do begin
          try
            pp := TPlugin(plugs.Objects[i]);
            plugs.Delete(i);
            pp.com.Shutdown;
          except
            DebugMessage('COM Exception in TExodusChat.UnloadPlugins');
            continue;
          end;

        end;
       plugs.Clear();
    except
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TPluginProxy.Create(xpath: Widestring; obj: IExodusPlugin);
begin
    inherited Create;

    com := obj;
    l := nil;

    init(xpath);
end;

{---------------------------------------}
constructor TPluginProxy.Create(xpath: Widestring; obj: IExodusListener);
begin
    inherited Create;

    com := nil;
    l := obj;

    init(xpath);
end;


{---------------------------------------}
procedure TPluginProxy.init(xpath: Widestring);
begin
    _xpath := xpath;

    // check for special signals
    if (LeftStr(xpath, Length('/roster')) = '/roster') then
        id := MainSession.RegisterCallback(Self.RosterCallback, xpath)
    else if (LeftStr(xpath, Length('/presence')) = '/presence') then
        id := MainSession.RegisterCallback(Self.PresenceCallback)
    else if (LeftStr(xpath, Length('/data')) = '/data') then
        id := MainSession.RegisterCallback(Self.DataCallback)
    else if (LeftStr(xpath, Length('/chat')) = '/chat') then
        id := MainSession.RegisterCallback(Self.ChatCallback)
    else
        id := MainSession.RegisterCallback(Self.Callback, xpath);

    proxy_idx := proxies.AddObject(IntToStr(id), Self)
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
    xml: WideString;
begin
    // call the plugin back
    // Lets just wholesale catch exceptions here. This will prevent
    // Exodus show catastrophic errors when plugins are bad
    // TODO: think about unregistering the plugin if it throws an exception.
    try
        if (tag = nil) then
            xml := ''
        else if (tag.Name = 'junk') then
            // Must have come from datacallback with nil tag.
            // Thus using "fake" tag to pass data.
            xml := tag.Data
        else
            xml := tag.xml;

        if (com <> nil) then begin
            try
                com.Process(_xpath, event, xml);
            except
                DebugMessage('COM Exception in TPluginProxy.Callback');
            end;
        end
        else if (l <> nil) then
            l.ProcessEvent(event, xml);
    except
        self.Free();
    end;
end;

{---------------------------------------}
procedure TPluginProxy.RosterCallback(event: string; tag: TXMLTag; ritem: TJabberRosterItem);
begin
    Callback(event, tag);
end;

{---------------------------------------}
procedure TPluginProxy.PresenceCallback(event: string; tag: TXMLTag; p: TJabberPres);
begin
    Callback(event, tag);
end;

{---------------------------------------}
procedure TPluginProxy.DataCallback(event: string; tag: TXMLTag; data: Widestring);
begin
    if (tag = nil) then begin
        // Create a short term tag object to pass data through.
        // XXX: find a beter solution
        tag := TXMLTag.Create('junk', data);
        Callback(event, tag);
        tag.Destroy;
    end
    else
        Callback(event, tag);
end;

{---------------------------------------}
procedure TPluginProxy.ChatCallback(event: string; tag: TXMLTag; controller: TChatController);
begin
    Callback(event, tag);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TIQProxy.Create(x: TXMLTag; Timeout_val: integer; obj: IExodusIQListener);
var
    xp: Widestring;
begin
    assert(x.Name = 'iq');
    iqid := MainSession.generateID();
    x.setAttribute('id', iqid);

    xp := '/packet/iq[@id="' + iqid + '"]';

    // register with the dispatcher
    _iqid := MainSession.RegisterCallback(Self.Callback, xp);
    _disid := MainSession.RegisterCallback(Self.Callback, '/session/disconnected');

    // setup our timer
    com := obj;
    _timer := TTimer.Create(nil);
    _timer.Interval := Timeout_val * 1000;
    _timer.OnTimer := Self.Timeout;

    // send the iq
    _timer.Enabled := true;
    MainSession.SendTag(x);
end;

{---------------------------------------}
destructor  TIQProxy.Destroy;
begin
    if (MainSession <> nil) then begin
        MainSession.UnRegisterCallback(_iqid);
        MainSession.UnRegisterCallback(_disid);
    end;

    _timer.Free();
end;

{---------------------------------------}
procedure TIQProxy.Callback(event: string; tag: TXMLTag);
begin
    //
    try
        _timer.Enabled := false;

        if ((event = 'xml') and (tag <> nil)) then
            com.ProcessIQ(iqid, tag.xml)
        else
            com.ProcessIQ(iqid, '');
    except
        DebugMessage('COM Exception in TIQProxy.Callback');
    end;

    Self.Free();
end;

{---------------------------------------}
procedure TIQProxy.Timeout(Sender: TObject);
begin
    try
        // we got a timeout event
        _timer.Enabled := false;

        // callback our listener
        com.TimeoutIQ(iqid);
    except
        DebugMessage('COM Exception in TIQProxy.Timeout');
    end;

    Self.Free;
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TExodusController.Create();
begin
    inherited Create();
end;

{---------------------------------------}
procedure TExodusController.Initialize();
begin
    inherited Initialize();
    _menu_items := TWidestringList.Create();
    _roster_menus := Twidestringlist.Create();
    _msg_menus := TWidestringlist.Create();
    _nextid := 0;
    _parser := TXMLTagParser.Create();
    
    (*
    // XXX: Joe: figure out this OLE stuff please so it doesn't core on exit

    ComServer.OnLastRelease := lastRelease;

    // This registers Exodus in the Running Object Table (ROT)
    // so that other apps can use GetObject("Exodus")
    OleCheck(RegisterActiveObject(self as IExodusController, CLASS_ExodusController,
        ACTIVEOBJECT_WEAK, _cookie));

    // this makes it so no one can unload us before we are ready
    OleCheck(CoLockObjectExternal(self as IExodusController, true, true));
    *)
end;

{---------------------------------------}
destructor TExodusController.Destroy();
begin
   try

    if (_menu_items <> nil) then begin

        OutputDebugString('Destroying TExodusController');

        (*
        OleCheck(CoLockObjectExternal(self as IExodusController, false, false));
        OleCheck(RevokeActiveObject(_cookie, nil));
        OleCheck(CoDisconnectObject(self as IExodusController, 0));
        *)

        // should we cleanup these menu items???
        FreeAndNil(_menu_items);
        FreeAndNil(_roster_menus);
        FreeAndNil(_msg_menus);
        FreeAndNil(_parser);
        inherited;

    end;
   except

   end;
end;

{---------------------------------------}
procedure TExodusController.fireNewChat(jid: WideString; ExodusChat: IExodusChat);
var
    i: integer;
begin
    for i := 0 to plugs.count - 1 do begin
        try
            TPlugin(plugs.Objects[i]).com.NewChat(jid, ExodusChat);
        except
            DebugMessage('COM Exception in TExodusController.fireNewChat');
        end;
    end;
end;

{---------------------------------------}
procedure TExodusController.fireNewOutgoingIM(jid: Widestring; ExodusChat: IExodusChat);
var
    i: integer;
begin
    for i := 0 to plugs.Count - 1 do begin
        try
            TPlugin(plugs.Objects[i]).com.NewOutgoingIM(jid, ExodusChat);
        except
            DebugMessage('COM Exception in TExodusController.fireNewOutgoingIM');
        end;
    end;
end;

procedure TExodusController.fireNewIncomingIM(jid: Widestring; ExodusChat: IExodusChat);
var
    i: integer;
    iep2: IExodusPlugin2;
begin
    for i := 0 to plugs.Count - 1 do
        try
           iep2 := (TPlugin(plugs.Objects[i]).com as IExodusPlugin2);
        except
            on EIntfCastError do begin
              iep2 := nil;
            end;
        end;
        if (iep2 <> nil) then
          iep2.NewIncomingIM(jid, ExodusChat);

       
end;
{---------------------------------------}
procedure TExodusController.fireNewRoom(jid: Widestring; ExodusChat: IExodusChat);
var
    i: integer;
begin
    for i := 0 to plugs.Count - 1 do begin
        try
            TPlugin(plugs.Objects[i]).com.NewRoom(jid, ExodusChat);
        except
            DebugMessage('COM Exception in TExodusController.fireNewRoom');
        end;
    end;
end;

{---------------------------------------}
function TExodusController.fireIM(Jid: Widestring; var Body: Widestring;
    var Subject: Widestring; xtags: Widestring): Widestring;
var
    i: integer;
    xml: Widestring;
begin
    xml := '';
    for i := 0 to plugs.Count - 1 do begin
        try
            xml := xml + TPlugin(plugs.Objects[i]).com.NewIM(jid, body, subject, xtags);
        except
            DebugMessage('COM Exception in TExodusController.fireIM');
        end;
    end;
    Result := xml;
end;

{---------------------------------------}
procedure TExodusController.fireMsgMenuClick(idx: integer; jid: Widestring;
        var Body: Widestring; var Subject: Widestring);
var
//    i: integer;
    txml : TXMLTag;
    mc: TMenuContainer;
begin
    if (idx >= _msg_menus.Count) then exit;
    //create xml to pass onto event
    txml := TXMLTag.Create('msg-menu-data');
    txml.AddBasicTag('jid', jid);
    txml.AddBasicTag('body', body);
    txml.AddBasicTag('subject', subject);
    mc := TMenuContainer(_msg_menus.Objects[idx]);
    mc.listener.OnMenuItemClick(_msg_menus[idx], txml.XML);
{*
    for i := 0 to plugs.Count - 1 do
        TPlugin(plugs.Objects[i]).com.MsgMenuClick(_msg_menus[idx], jid,
            Body, Subject);
*}            
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
procedure TExodusController.ChangePresence(const Show, Status: WideString;
        Priority: Integer);
begin
    // Change our presence
    MainSession.setPresence(Show, Status, Priority);
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
var
    pp: TPluginProxy;
begin
    pp := TPluginProxy.Create(xpath, callback);
    Result := pp.id;
end;

{---------------------------------------}
procedure TExodusController.RemoveRosterItem(const jid: WideString);
begin
    // todo: plugin remove roster item
    QuietRemoveRosterItem(jid);
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
    end;
end;

{---------------------------------------}
procedure TExodusController.GetProfile(const jid: WideString);
begin
    // Fetch and display a profile
    ShowProfile(jid);
end;

{---------------------------------------}
procedure TExodusController.StartChat(const jid, resource,
  nickname: WideString);
begin
    // start chat
    ChatWin.StartChat(jid, resource, true, nickname);
    // force window to front
    frmExodus.doRestore();
end;

{---------------------------------------}
function TExodusController.CreateDockableWindow(
  const Caption: WideString): Integer;
var
    p: Pointer;
    f: TfrmDockContainer;
    tstr: Widestring;
begin
EXutils.OutputDebugMsg('creating TfrmDockContainer');
    Application.CreateForm(TfrmDockContainer, f);
EXutils.OutputDebugMsg('showing dock container');
    f.ShowDefault();
    Application.ProcessMessages();
    //hack alert! Info Broker work.
    tstr := Copy(Caption, 1, Length('vcl_'));
EXutils.OutputDebugMsg('Caption: ' + caption + ', tstr: ' + tstr);
    if (tstr = 'vcl_') then begin
EXutils.OutputDebugMsg('found delphi caption, returning tpanel');
      f.Caption := Copy(Caption, Length('vcl_') + 1, Length(Caption));
      p := @(TPanel(f.panel1));
      Result := Integer(p);
    end else begin
EXutils.OutputDebugMsg('found normal caption, returning hwnd');
      f.Caption := Caption;
      Result := f.Panel1.Handle;
    end;
end;

{---------------------------------------}
function TExodusController.AddPluginMenu(const caption: WideString;
  const menuListener: IExodusMenuListener): WideString;
var
    id: Widestring;
    mi: TMenuItem;
begin
    // add a new TMenuItem to the Plugins menu
    mi := TMenuItem.Create(frmExodus);
    frmExodus.mnuOptions_Plugins.Add(mi); 
    mi.Caption := caption;
    mi.OnClick := frmExodus.mnuPluginDummyClick; //calls fireMenuClick
    inc(_nextid);
    id := 'plugin_' + IntToStr(_nextid);
    mi.Name := id;
    //add menulistener as menu items tag
    mi.tag := Integer(menuListener);
    _menu_items.AddObject(id, mi);
    Result := id;
end;

{---------------------------------------}
procedure TExodusController.removePluginMenu(const ID: WideString);
var
    idx: integer;
    o: TObject;
begin
    idx := _menu_items.IndexOf(id);
    if (idx >= 0) then begin
        o := _menu_items.Objects[idx];
        if assigned(o) then begin
            TMenuItem(o).Tag := 0;
            TMenuItem(o).Free();
            _menu_items.Delete(idx);
        end;
    end;
end;

{---------------------------------------}
procedure TExodusController.fireMenuClick(Sender: TObject);
var
    idx : Integer;
{$IFDEF OLD_MENU_EVENTS}
    i: integer;
{$ELSE}
    mListener : IExodusMenuListener;
{$ENDIF}
begin
    idx := _menu_items.IndexOfObject(Sender);
    if (idx >= 0) then begin
{$IFDEF OLD_MENU_EVENTS}
        //broadcast to all plugins the menu selection
        for i := 0 to plugs.count - 1 do begin
            try
                TPlugin(plugs.Objects[i]).com.menuClick(_menu_items[idx]);
            except
                DebugMessage('COM Exception in TExodusController.fireMenuClick');
            end;
        end;
{$ELSE}
        //fire event on one menu listener
        mListener := IExodusMenuListener(TMenuItem(_menu_items.Objects[idx]).Tag);
        if (mListener <> nil) then
            mListener.OnMenuItemClick(_menu_items[idx], '');
{$ENDIF}
    end;
end;

{---------------------------------------}
procedure TExodusController.fireRosterMenuClick(Sender: TObject);
var
    idx : Integer;
{$IFDEF OLD_MENU_EVENTS}
    i: integer;
{$ELSE}
    mListener : IExodusMenuListener;
{$ENDIF}
begin
    idx := _roster_menus.indexOfObject(Sender);
    if (idx >= 0) then begin
{$IFDEF OLD_MENU_EVENTS}
        for i := 0 to plugs.count - 1 do begin
            try
                TPlugin(plugs.Objects[i]).com.menuClick(_roster_menus[idx]);
            except
                DebugMessage('COM Exception in TExodusController.fireRosterMenuClick');
            end
        end;
{$ELSE}
        //fire event on one menu listener
        mListener := IExodusMenuListener(TMenuItem(_roster_menus.Objects[idx]).Tag);
        if (mListener <> nil) then
            mListener.OnMenuItemClick(_roster_menus[idx], '');
{$ENDIF}
    end;
end;

{---------------------------------------}
procedure TExodusController.monitorImplicitRegJID(
  const JabberID: WideString; FullJID: WordBool);
begin
    ExRegController.MonitorJid(JabberID, FullJID);
end;

{---------------------------------------}
function TExodusController.getAgentService(const Server,
  Service: WideString): WideString;
var
    e: TJabberEntity;
begin
    result := '';
    e := jEntityCache.getByJid(Server);
    if (e = nil) then
        exit;
    e := e.getItemByFeature(Service);
    if (e = nil) then
        exit;
    result := e.Jid.full;
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
    // This must go against frmExodus, not MainSession
    // otherwise some strange reconnect issues get triggered
    // by there being no profile selected.
    if ((not MainSession.Active) and (frmExodus.Showing)) then
        frmExodus.DoConnect();
end;

{---------------------------------------}
procedure TExodusController.Disconnect;
begin
    // This must go against frmExodus, not MainsSession
    // as MainSession.Disconnect() triggers the reconnect
    // logic.
    if MainSession.Active then
        frmExodus.mnuDisconnectClick(nil);
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
function TExodusController.GetPrefAsBool(const Key: WideString): WordBool;
begin
    Result := MainSession.Prefs.getBool(key);
end;

{---------------------------------------}
function TExodusController.GetPrefAsInt(const Key: WideString): Integer;
begin
    Result := MainSession.Prefs.getInt(key);
end;

{---------------------------------------}
function TExodusController.GetPrefAsString(const Key: WideString): WideString;
begin
    Result := MainSession.Prefs.getString(key);
end;

{---------------------------------------}
procedure TExodusController.SetPrefAsBool(const Key: WideString;
  Value: WordBool);
begin
    MainSession.Prefs.setBool(key, value);
end;

{---------------------------------------}
procedure TExodusController.SetPrefAsInt(const Key: WideString; Value: Integer);
begin
    MainSession.Prefs.setInt(key, value);
end;

{---------------------------------------}
procedure TExodusController.SetPrefAsString(const Key, Value: WideString);
begin
    MainSession.Prefs.setString(Key, value);
end;

{---------------------------------------}
function TExodusController.FindChat(const JabberID,
  resource: WideString): Integer;
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
procedure TExodusController.StartInstantMsg(const JabberID: WideString);
begin
    startMsg(JabberID);
end;

{---------------------------------------}
procedure TExodusController.StartRoom(const roomJID, Nickname,
  password: WideString; sendPresence, defaultConfig,
  useRegisteredNickname: WordBool);
begin
    Room.startRoom(RoomJID, Nickname, Password, SendPresence, defaultConfig, useRegisteredNickname);
end;

{---------------------------------------}
procedure TExodusController.StartSearch(const SearchJID: WideString);
begin
    JUD.StartSearch(SearchJID);
end;

{---------------------------------------}
procedure TExodusController.ShowJoinRoom(const RoomJID, nickname,
  Password: WideString);
var
    tmpjid: TJabberID;
begin
    tmpjid := TJabberID.Create(RoomJID);
    startJoinRoom(tmpjid, NickName, Password);
    tmpjid.free();
end;

{---------------------------------------}
procedure TExodusController.StartBrowser(const BrowseJID: WideString);
begin
    showBrowser(BrowseJID);
end;

{---------------------------------------}
procedure TExodusController.ShowCustomPresDialog;
begin
    ShowCustomPresence();
end;

{---------------------------------------}
procedure TExodusController.ShowDebug;
begin
    ShowDebugForm();
end;

{---------------------------------------}
procedure TExodusController.ShowLogin;
begin
    PostMessage(frmExodus.Handle, WM_SHOWLOGIN, 0, 0);
end;

{---------------------------------------}
procedure TExodusController.ShowPrefs;
begin
    startPrefs();
end;

{---------------------------------------}
procedure TExodusController.ShowToast(const Message: WideString; wndHandle,
  imageIndex: Integer);
begin
    showRiserWindow(wndHandle, Message, imageIndex);
end;

{---------------------------------------}
procedure TExodusController.SetPresence(const Show, Status: WideString;
  Priority: Integer);
begin
    MainSession.setPresence(Show, Status, Priority);
end;

{---------------------------------------}
function TExodusController.Get_Roster: IExodusRoster;
begin
    ExCOMRoster.ObjAddRef();
    Result := ExCOMRoster;
end;

{---------------------------------------}
function TExodusController.Get_PPDB: IExodusPPDB;
begin
    ExCOMPPDB.ObjAddRef();
    Result := ExCOMPPDB;
end;

{---------------------------------------}
function TExodusController.RegisterDiscoItem(const JabberID,
  Name: WideString): WideString;
begin
    Result := Exodus_Disco_Items.addItem(Name, JabberID);
end;

{---------------------------------------}
procedure TExodusController.RemoveDiscoItem(const ID: WideString);
begin
    Exodus_Disco_Items.removeItem(ID);
end;

{---------------------------------------}
function TExodusController.RegisterPresenceXML(
  const xml: WideString): WideString;
begin
    Result := IntToStr(MainSession.Presence_XML.Add(XML));
end;

{---------------------------------------}
procedure TExodusController.RemovePresenceXML(const ID: WideString);
var
    idx: integer;
begin
    idx := StrToIntDef(ID, -1);
    if ((idx >= 0) and (idx < MainSession.Presence_XML.Count)) then
        MainSession.Presence_XML.Delete(idx);
end;

{---------------------------------------}
procedure TExodusController.TrackWindowsMsg(Message: Integer);
begin
    frmExodus.TrackWindowsMsg(Message);
end;

{---------------------------------------}
function TExodusController.AddContactMenu(const caption: WideString;
  const menuListener: IExodusMenuListener): WideString;
var
    id: Widestring;
    mi: TMenuItem;
begin
    // add a new TMenuItem to the Plugins menu
    mi := TMenuItem.Create(frmRosterWindow);
    frmRosterWindow.popRoster.Items.Add(mi);
    mi.Caption := caption;
    mi.OnClick := frmRosterWindow.pluginClick;
    id := 'ct_menu_' + IntToStr(_roster_menus.Count);
    mi.Name := id;
    //add menu listener as menu items tag
    mi.Tag := Integer(menuListener);
    _roster_menus.AddObject(id, mi);
    Result := id;
end;

{---------------------------------------}
procedure TExodusController.RemoveContactMenu(const ID: WideString);
var
    idx: integer;
begin
    idx := _roster_menus.IndexOf(ID);
    if (idx >= 0) then begin
        TMenuItem(_roster_menus.Objects[idx]).Tag := 0; //loose IExodusMenuListener ref
        TMenuItem(_roster_menus.Objects[idx]).Free();
        _roster_menus.Delete(idx);
    end;
end;

{---------------------------------------}
function TExodusController.GetActiveContact: WideString;
var
    ritem: TJabberRosterItem;
begin
    ritem := frmRosterWindow.CurRosterItem;
    if (ritem <> nil) then
        Result := ritem.jid.full
    else
        Result := '';
end;

{---------------------------------------}
function TExodusController.GetActiveGroup: WideString;
begin
    Result := frmRosterWindow.CurGroup;
end;

{---------------------------------------}
function TExodusController.GetActiveContacts(Online: WordBool): OleVariant;
var
    clist: TList;
    i: integer;
    ritem: TJabberRosterItem;
    va : Variant;
begin
    clist := frmRosterWindow.getSelectedContacts(Online);
    va := VarArrayCreate([0,clist.Count], varOleStr);

    for i := 0 to clist.count - 1 do begin
        ritem := TJabberRosterItem(clist[i]);
        VarArrayPut(va, ritem.jid.full, i);
    end;
    clist.Free();
    result := va;
end;

{---------------------------------------}
function TExodusController.Get_LocalIP: WideString;
begin
    Result := MainSession.Stream.LocalIP;
end;

{---------------------------------------}
procedure TExodusController.setPluginAuth(const AuthAgent: IExodusAuth);
var
    aa: TExPluginAuth;
begin
    // spin up a new auth agent, and register it w/ the session.
    if (authAgent <> nil) then begin
        aa := TExPluginAuth.Create();
        aa.plugin := AuthAgent;
        MainSession.setAuthAgent(aa);
    end
    else MainSession.setAuthAgent(nil);
end;

{---------------------------------------}
procedure TExodusController.setAuthenticated(Authed: WordBool;
  const XML: WideString);
begin
    // todo: parse & pass along the XML Tag for auth plugins
    MainSession.setAuthenticated(authed, nil, false);
end;

{---------------------------------------}
procedure TExodusController.setAuthJID(const Username, Host,
  Resource: WideString);
begin
    MainSession.setAuthdJID(username, host, resource);
end;

{---------------------------------------}
function TExodusController.AddMessageMenu(const caption: WideString;
  const menuListener: IExodusMenuListener): WideString;
var
    mc: TMenuContainer;
    id: Widestring;
begin
    // add a new TMenuItem to the Msg-Plugins menu
    id := 'msg_menu_' + IntToStr(_msg_menus.Count);
    mc := TMenuContainer.Create();
    mc.id := id;
    mc.caption := Caption;
    mc.idx := _msg_menus.AddObject(id, mc);
    mc.listener := menuListener;
    Result := id;
end;

{---------------------------------------}
procedure TExodusController.populateMsgMenus(parent: TPopupMenu;
    event: TNotifyEvent);
var
    i: integer;
    mc: TMenuContainer;
    mi: TMenuItem;
begin

    for i := 0 to parent.Items.Count - 1 do begin
        mi := parent.Items[i];
        if (LeftStr(mi.Name, 9) = 'msg_menu_') then begin
            parent.Items.Delete(i);
            mi.Free();
        end;
    end;

    for i := 0 to _msg_menus.Count - 1 do begin
        mc := TMenuContainer(_msg_menus.Objects[i]);
        mi := TMenuItem.Create(parent.Owner);
        mi.Name := mc.id;
        mi.Caption := mc.caption;
        mi.Tag := i;
        mi.OnClick := event;
        parent.Items.Add(mi);
    end;
end;

{---------------------------------------}
function TExodusController.AddGroupMenu(const caption: WideString;
  const menuListener: IExodusMenuListener): WideString;
var
    id: Widestring;
    mi: TMenuItem;
begin
    // add a new TMenuItem to the Plugins menu
    mi := TMenuItem.Create(frmRosterWindow);
    frmRosterWindow.popGroup.Items.Add(mi);
    mi.Caption := caption;
    mi.OnClick := frmRosterWindow.pluginClick;
    id := 'group_menu_' + IntToStr(_roster_menus.Count);
    mi.Name := id;
    mi.Tag := Integer(menuListener);
    _roster_menus.AddObject(id, mi);
    Result := id;
end;

{---------------------------------------}
procedure TExodusController.RemoveGroupMenu(const ID: WideString);
var
    idx: integer;
begin
    idx := _roster_menus.IndexOf(ID);
    if (idx >= 0) then begin
        TMenuItem(_roster_menus.Objects[idx]).Tag := 0;
        TMenuItem(_roster_menus.Objects[idx]).Free();
        _roster_menus.Delete(idx);
    end;
end;

{---------------------------------------}
procedure TExodusController.RegisterWithService(const JabberID: WideString);
begin
    StartServiceReg(JabberID);
end;


{---------------------------------------}
procedure TExodusController.lastRelease(var shutdown: boolean);
begin
    shutdown := false;
end;

{---------------------------------------}
procedure TExodusController.ShowAddContact(const jid: WideString);
begin
    RosterAdd.ShowAddContact(jid);
end;

{---------------------------------------}
procedure TExodusController.RegisterCapExtension(const ext,
  feature: WideString);
begin
    MainSession.AddExtension(ext, feature);
end;

{---------------------------------------}
procedure TExodusController.UnregisterCapExtension(const ext: WideString);
begin
    MainSession.RemoveExtension(ext);
end;

{---------------------------------------}
function TExodusController.Get_RosterImages: IExodusRosterImages;
begin
    ExCOMRosterImages.ObjAddRef();
    Result := ExCOMRosterImages;
end;

{---------------------------------------}
function TExodusController.Get_EntityCache: IExodusEntityCache;
begin
    ExCOMEntityCache.ObjAddRef();
    Result := ExCOMEntityCache;
end;

{---------------------------------------}
procedure TExodusController.Debug(const Value: WideString);
begin
    DebugMessage(Value);
end;

{---------------------------------------}
function TExodusController.TrackIQ(const XML: WideString;
  const Listener: IExodusIQListener; Timeout: Integer): WideString;
var
    p: TIQProxy;
    iqt: Widestring;
    x: TXMLTag;
begin
    // parse and track this IQ
    Result := '';
    _parser.Clear();
    _parser.ParseString(XML, '');
    if (_parser.Count > 0) then begin
        x := _parser.popTag();
        iqt := x.GetAttribute('type');
        if ((x.Name = 'iq') and ((iqt = 'get') or (iqt = 'set'))) then begin
            p := TIQProxy.Create(x, Timeout, Listener);
            Result := p.iqid;
        end
        else
            DebugMsg('TrackIQ must be called with a valid iq element with type="set" or type="get".');
    end;

    _parser.Clear();
end;

{---------------------------------------}
procedure TExodusController.FireEvent(const Event, XML, Arg: WideString);
var
    jid: TJabberID;
    x: TXMLTag;
    ri: TJabberRosterItem;
    p: TJabberPres;
begin
    _parser.Clear();
    _parser.ParseString(XML, '');
    if (_parser.Count > 0) then
        x := _parser.popTag() // We now own this memory
    else
        x := nil;
    _parser.Clear();

    if (LeftStr(Event, Length('/roster')) = '/roster') then begin
        ri := nil;
        if (Arg <> '') then begin
            ri := MainSession.roster.Find(Arg);
            x := TXmlTag.Create(ri.Tag); // copy the ri tag so it is good for freeing below
        end;
        MainSession.FireEvent(Event, x, ri);
    end
    else if (LeftStr(Event, Length('/presence')) = '/presence') then begin
        p := nil;
        if (Arg <> '') then begin
            jid := TJabberID.Create(Arg);
            p := MainSession.ppdb.FindPres(jid.jid, jid.resource);
            jid.Free();
        end;
        MainSession.FireEvent(Event, x, p);
    end
    else if (LeftStr(Event, Length('/data')) = '/data') then
        MainSession.FireEvent(Event, x, Arg)
    else
        MainSession.FireEvent(Event, x);

    x.Free();
end;

{---------------------------------------}
function TExodusController.RegisterListener(const xpath: WideString;
  const Listener: IExodusListener): Integer;
var
    pp: TPluginProxy;
begin
    pp := TPluginProxy.Create(xpath, Listener);
    Result := pp.proxy_idx;
end;

{---------------------------------------}
function TExodusController.Get_Toolbar: IExodusToolbar;
begin
    ExCOMToolbar.ObjAddRef();
    Result := ExCOMToolbar;
end;

{---------------------------------------}
function TExodusController.Get_ContactLogger: IExodusLogger;
begin
    Result := _contact_logger;
end;

{---------------------------------------}
procedure TExodusController.Set_ContactLogger(const Value: IExodusLogger);
var
    x: TXMLTag;
begin
    _contact_logger := Value;
    if (Value = nil) then
        x := TXMLTag.Create('off')
    else begin
        x := TXMLTag.Create('on');
        x.setAttribute('date_enabled', BoolToStr(Value.IsDateEnabled));
    end;
    MainSession.FireEvent('/session/logger', x);
    x.Free();
end;

{---------------------------------------}
function TExodusController.Get_RoomLogger: IExodusLogger;
begin
    Result := _room_logger;
end;

{---------------------------------------}
procedure TExodusController.Set_RoomLogger(const Value: IExodusLogger);
var
    x: TXMLTag;
begin
    _room_logger := Value;
    if (Value = nil) then
        x := TXMLTag.Create('off')
    else begin
        x := TXMLTag.Create('on');
        x.setAttribute('date_enabled', BoolToStr(Value.IsDateEnabled));
    end;
    MainSession.FireEvent('/session/room-logger', x);
    x.Free();
end;

procedure TExodusController.AddStringlistValue(const Key, Value: WideString);
begin
    MainSession.Prefs.AddStringlistValue(key, value);
end;

procedure TExodusController.RemoveMessageMenu(const menuID: WideString);
var
    i, idx: integer;
    mc: TMenuContainer;
begin
    idx := -1;
    for i := 0 to _msg_menus.Count - 1 do begin
        mc := TMenuContainer(_msg_menus.Objects[i]);
        if (mc.id = menuID) then
            idx := i;
    end;
    
    if (idx >= 0) then begin
        mc := TMenuContainer(_msg_menus.Objects[idx]);
        _msg_menus.Delete(idx);
        mc.Free();
    end;
end;

function TExodusController.GetStringlistCount(const key: WideString): Integer;
begin
    Result := MainSession.Prefs.getStringlistCount(key);
end;

function TExodusController.GetStringlistValue(const key: WideString;
  index: Integer): WideString;
begin
    Result := MainSession.Prefs.getStringlistValue(key, index);
end;

procedure TExodusController.RemoveStringlistValue(const key, value: WideString);
begin
    MainSession.Prefs.RemoveStringlistValue(key, value);
end;

function TExodusController.Get_BookmarkManager: IExodusBookmarkManager;
begin
    ExCOMBookmarkManager.ObjAddRef();
    Result := ExCOMBookmarkManager;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TExodusController, Class_ExodusController,
    ciMultiInstance, tmApartment);

  // WARNING: this is somewhat dangerous.  If we are running, and there are COM
  // clients, and we exit, leaving those clients with pointers to us that are no
  // longer valid, this says not to warn the Exodus user.  The reason for this
  // is that the warning comes too late, and just leads to cores.
  // TODO: figure out how to disconnect from all of the clients that are
  // connected to us, using CoDisconnectObject.
  // UPDATE:  The Dialog Delphi pops up comes too late to be of any good.
  // Added own Dialog that informs user he is doing something "bad" and allows
  // them to continue or abort the application exit.  Thus, if they do abort,
  // we are still in a "good" state.  This is brandable.
  ComServer.UIInteractive := false;

  plugs := TStringList.Create();
  proxies := TStringList.Create();

finalization
    plugs.Free();
    proxies.Free();

end.
