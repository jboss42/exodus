unit Jabber1;
{
    Copyright 2001, Peter Millard

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

interface

uses
    // Exodus stuff
    BaseChat, ExResponders, ExEvents, RosterWindow, Presence, XMLTag,
    ShellAPI, Registry, SelContact,

    // Delphi stuff
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ScktComp, StdCtrls, ComCtrls, Menus, ImgList, ExtCtrls,
    Buttons, OleCtrls, AppEvnts, ToolWin,
    IdHttp, TntComCtrls, DdeMan;

const
    UpdateKey = '001';

    RECONNECT_RETRIES = 3;

    WM_TRAY = WM_USER + 5269;
    WM_PREFS = WM_USER + 5272;
    WM_SHOWLOGIN = WM_USER + 5273;
    WM_CLOSEAPP = WM_USER + 5274;
    WM_RECONNECT = WM_USER + 5300;
    WM_INSTALLER = WM_USER + 5350;
    WM_MUTEX = WM_USER + 5351;
    WM_DISCONNECT = WM_USER + 5352;

type
    TGetLastTick = function: dword; stdcall;
    TInitHooks = procedure; stdcall;
    TStopHooks = procedure; stdcall;

type
  TfrmExodus = class(TForm)
    Tabs: TPageControl;
    tbsRoster: TTabSheet;
    pnlRoster: TPanel;
    MainMenu1: TMainMenu;
    Exodus1: TMenuItem;
    Connect2: TMenuItem;
    Preferences1: TMenuItem;
    N7: TMenuItem;
    mnuPresence: TMenuItem;
    presOnline: TMenuItem;
    Exit2: TMenuItem;
    mnuContacts: TMenuItem;
    AddPerson1: TMenuItem;
    RemovePerson1: TMenuItem;
    N8: TMenuItem;
    SubscribetoPresence2: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    mnuMessage: TMenuItem;
    mnuChat: TMenuItem;
    N9: TMenuItem;
    mnuConference: TMenuItem;
    ClearMessages1: TMenuItem;
    Properties2: TMenuItem;
    MessageHistory2: TMenuItem;
    presAway: TMenuItem;
    Lunch3: TMenuItem;
    Bank1: TMenuItem;
    presXA: TMenuItem;
    GoneHome1: TMenuItem;
    GonetoWork1: TMenuItem;
    Sleeping1: TMenuItem;
    presDND: TMenuItem;
    presChat: TMenuItem;
    N10: TMenuItem;
    Away2: TMenuItem;
    ExtendedAway1: TMenuItem;
    Busy1: TMenuItem;
    Working1: TMenuItem;
    Mad1: TMenuItem;
    N11: TMenuItem;
    presCustom: TMenuItem;
    N12: TMenuItem;
    ShowXML1: TMenuItem;
    SearchforPerson1: TMenuItem;
    mnuPassword: TMenuItem;
    N6: TMenuItem;
    N14: TMenuItem;
    NewGroup2: TMenuItem;
    Test1: TMenuItem;
    Tools1: TMenuItem;
    mnuBrowser: TMenuItem;
    mnuServer: TMenuItem;
    mnuVersion: TMenuItem;
    mnuTime: TMenuItem;
    mnuServerVCard: TMenuItem;
    mnuVCard: TMenuItem;
    N13: TMenuItem;
    mnuMyVCard: TMenuItem;
    mnuBookmark: TMenuItem;
    ImageList2: TImageList;
    mnuExpanded: TMenuItem;
    SplitterRight: TSplitter;
    N1: TMenuItem;
    N2: TMenuItem;
    timFlasher: TTimer;
    mnuOnline: TMenuItem;
    mnuToolbar: TMenuItem;
    mnuStatBar: TMenuItem;
    View1: TMenuItem;
    ImageList1: TImageList;
    timAutoAway: TTimer;
    Meeting1: TMenuItem;
    popTabs: TPopupMenu;
    popCloseTab: TMenuItem;
    popFloatTab: TMenuItem;
    popTray: TPopupMenu;
    trayShow: TMenuItem;
    N4: TMenuItem;
    trayConnect: TMenuItem;
    N01: TMenuItem;
    trayExit: TMenuItem;
    trayPresence: TMenuItem;
    trayCustom: TMenuItem;
    N5: TMenuItem;
    DoNotDisturb1: TMenuItem;
    Mad2: TMenuItem;
    Working2: TMenuItem;
    Busy2: TMenuItem;
    XtendedAway1: TMenuItem;
    Sleeping2: TMenuItem;
    GonetoWork2: TMenuItem;
    GoneHome2: TMenuItem;
    ExtendedAway2: TMenuItem;
    Away1: TMenuItem;
    Bank2: TMenuItem;
    Meeting2: TMenuItem;
    Lunch1: TMenuItem;
    Away3: TMenuItem;
    N15: TMenuItem;
    FreeforChat1: TMenuItem;
    Online1: TMenuItem;
    Custom2: TMenuItem;
    N16: TMenuItem;
    Custom3: TMenuItem;
    N18: TMenuItem;
    pnlRight: TPanel;
    ApplicationEvents1: TApplicationEvents;
    Toolbar: TCoolBar;
    ToolBar1: TToolBar;
    btnConnect: TToolButton;
    btnOnlineRoster: TToolButton;
    btnAddContact: TToolButton;
    btnRoom: TToolButton;
    btnDelContact: TToolButton;
    imgYahooEmoticons: TImageList;
    btnFind: TToolButton;
    imgMSNEmoticons: TImageList;
    mnuRegisterService: TMenuItem;
    btnExpanded: TToolButton;
    trayMessage: TMenuItem;
    timReconnect: TTimer;
    ShowEventsWindow1: TMenuItem;
    presToggle: TMenuItem;
    ImageList3: TImageList;
    pnlLeft: TPanel;
    SplitterLeft: TSplitter;
    timTrayAlert: TTimer;
    mnuPlugins: TMenuItem;
    mnuRegistration: TMenuItem;
    N3: TMenuItem;
    XMPPAction: TDdeServerConv;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOnlineRosterClick(Sender: TObject);
    procedure btnAddContactClick(Sender: TObject);
    procedure mnuConferenceClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
    procedure btnExpandedClick(Sender: TObject);
    procedure ClearMessages1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDelPersonClick(Sender: TObject);
    procedure ShowXML1Click(Sender: TObject);
    procedure SplitterRightMoved(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure timFlasherTimer(Sender: TObject);
    procedure JabberorgWebsite1Click(Sender: TObject);
    procedure JabberCentralWebsite1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure presOnlineClick(Sender: TObject);
    procedure mnuMyVCardClick(Sender: TObject);
    procedure mnuToolbarClick(Sender: TObject);
    procedure NewGroup2Click(Sender: TObject);
    procedure timAutoAwayTimer(Sender: TObject);
    procedure MessageHistory2Click(Sender: TObject);
    procedure Properties2Click(Sender: TObject);
    procedure mnuVCardClick(Sender: TObject);
    procedure SearchforPerson1Click(Sender: TObject);
    procedure TabsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure popCloseTabClick(Sender: TObject);
    procedure popFloatTabClick(Sender: TObject);
    procedure mnuChatClick(Sender: TObject);
    procedure mnuBookmarkClick(Sender: TObject);
    procedure presCustomClick(Sender: TObject);
    procedure trayShowClick(Sender: TObject);
    procedure trayExitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure WinJabWebsite1Click(Sender: TObject);
    procedure JabberBugzilla1Click(Sender: TObject);
    procedure mnuVersionClick(Sender: TObject);
    procedure mnuPasswordClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuRegisterServiceClick(Sender: TObject);
    procedure TabsUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure TabsDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure mnuMessageClick(Sender: TObject);
    procedure Test1Click(Sender: TObject);
    procedure trayMessageClick(Sender: TObject);
    procedure mnuBrowserClick(Sender: TObject);
    procedure timReconnectTimer(Sender: TObject);
    procedure ShowEventsWindow1Click(Sender: TObject);
    procedure presToggleClick(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure ApplicationEvents1Deactivate(Sender: TObject);
    procedure TabsChange(Sender: TObject);
    procedure TabsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TabsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure timTrayAlertTimer(Sender: TObject);
    procedure JabberUserGuide1Click(Sender: TObject);
    procedure mnuPluginDummyClick(Sender: TObject);
    procedure SubmitExodusFeatureRequest1Click(Sender: TObject);
    procedure ShowBrandURL(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure mnuRegistrationClick(Sender: TObject);
    procedure XMPPActionExecuteMacro(Sender: TObject; Msg: TStrings);

  private
    { Private declarations }
    _noMoveCheck: boolean;              // don't check form moves
    _tray_notify: boolean;              // boolean for flashing tray icon
    _edge_snap: integer;                // edge snap fuzziness
    _auto_away: boolean;                // are we auto away
    _auto_away_interval: integer;
    _last_tick: dword;                  // last tick when something happened

    // Various state flags
    _windows_ver: integer;
    _is_broadcast: boolean;
    _is_autoaway: boolean;
    _is_autoxa: boolean;
    _is_min: boolean;
    _last_show: Widestring;             // last show for restoring after auto-away
    _last_status: Widestring;           // last status    (ditto)
    _last_priority: integer;            // last priority  (ditto)
    _hidden: boolean;                   // are we minimized to the tray
    _logoff: boolean;                   // are we logging off on purpose
    _shutdown: boolean;                 // are we being shutdown
    _close_min: boolean;                // should the close btn minimize, not close
    _appclosing: boolean;               // is the entire app closing
    _new_tabindex: integer;             // new tab which was just docked
    _new_account: boolean;              // is this a new account

    // Stuff for the Autoaway DLL
    _idle_hooks: THandle;               // handle the lib
    _GetLastTick: TGetLastTick;         // function ptrs inside the lib
    _InitHooks: TInitHooks;
    _StopHooks: TStopHooks;
    _valid_aa: boolean;                 // do we have a valid auto-away setup?

    // Tray Icon stuff
    _tray: NOTIFYICONDATA;
    _tray_tip: string;
    _tray_icon_idx: integer;
    _tray_icon: TIcon;

    // Some callbacks
    _sessioncb: integer;

    // Reconnect variables
    _reconnect_interval: integer;
    _reconnect_cur: integer;
    _reconnect_tries: integer;

    // Stuff for tracking win32 API events
    _win32_tracker: Array of integer;
    _win32_idx: integer;

    procedure presCustomPresClick(Sender: TObject);

    procedure setupTrayIcon();
    procedure setTrayInfo(tip: string);
    procedure setTrayIcon(iconNum: integer);
    procedure SetAutoAway();
    procedure SetAutoXA();
    procedure SetAutoAvailable();
    procedure SetupAutoAwayTimer();

    function win32TrackerIndex(windows_msg: integer): integer;

  protected
    // Hooks for the keyboard and the mouse
    _hook_keyboard: HHOOK;
    _hook_mouse: HHOOK;

    // Window message handlers
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSysCommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
    procedure WMWindowPosChanging(var msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WMTray(var msg: TMessage); message WM_TRAY;
    procedure WMQueryEndSession(var msg: TMessage); message WM_QUERYENDSESSION;
    procedure WMEndSession(var msg: TMessage); message WM_ENDSESSION;
    procedure WMShowLogin(var msg: TMessage); message WM_SHOWLOGIN;
    procedure WMCloseApp(var msg: TMessage); message WM_CLOSEAPP;
    procedure WMReconnect(var msg: TMessage); message WM_RECONNECT;
    procedure WMInstaller(var msg: TMessage); message WM_INSTALLER;
    procedure WMDisconnect(var msg: TMessage); message WM_DISCONNECT;

    function WMAppBar(dwMessage: DWORD; var pData: TAppBarData): UINT; stdcall;

  published
    // Callbacks
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure ChangePasswordCallback(event: string; tag: TXMLTag);

    // This is only used for testing..
    procedure BadCallback(event: string; tag: TXMLTag);

    procedure restoreToolbar;
    procedure restoreAlpha;
    procedure restoreMenus(enable: boolean);
    procedure restoreRoster();

  public
    ActiveChat: TfrmBaseChat;

    function getLastTick(): dword;
    function getTabForm(tab: TTabSheet): TForm;
    function IsAutoAway(): boolean;
    function IsAutoXA(): boolean;
    function isMinimized(): boolean;

    procedure Startup();
    procedure DoConnect();
    procedure CancelConnect();
    procedure CTCPCallback(event: string; tag: TXMLTag);
    procedure AcceptFiles( var msg : TWMDropFiles ); message WM_DROPFILES;
    procedure DefaultHandler(var msg); override;
    procedure TrackWindowsMsg(windows_msg: integer);
    procedure fireWndMessage(handle: HWND; msg: Cardinal;
        wParam: integer; lParam: integer);

    procedure PreModal(frm: TForm);
    procedure PostModal();

  end;


procedure StartTrayAlert();
procedure StopTrayAlert();

function ExodusGMHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
function ExodusCWPHook(code: integer; wParam: word; lParam: longword): longword; stdcall;

var
    frmExodus: TfrmExodus;
    sExodusPresence: Cardinal;
    sExodusMutex: Cardinal;
    sShellRestart: Cardinal;
    sExodusGMHook: HHOOK;
    sExodusCWPHook: HHOOK;

resourcestring
    sCommandLine =  'The following command line parameters are available in Exodus: '#13#10#13#10;
    sCmdDebug =     ' -d '#9#9' : Debug mode on'#13#10;
    sCmdMinimized = ' -m '#9#9' : Start minimized'#13#10;
    sCmdInvisible = ' -v '#9#9' : invisible mode'#13#10;
    sCmdHelp =      ' -? '#9#9' : Show Help'#13#10;
    sCmdExpanded =  ' -x [yes|no] '#9' : Expanded Mode'#13#10;
    sCmdJID =       ' -j [jid] '#9#9' : Jid'#13#10;
    sCmdPassword =  ' -p [pass] '#9' : Password'#13#10;
    sCmdResource =  ' -r [res] '#9' : Resource'#13#10;
    sCmdPriority =  ' -i [pri] '#9' : Priority'#13#10;
    sCmdProfile =   ' -f [prof] '#9' : Profile name'#13#10;
    sCmdConfig =    ' -c [file] '#9' : Config path name'#13#10;
    sUnkArg = 'Invalid command line:%s';

    sXMPP_Profile = '-*- Temp profile: %s -*-';
    
    sExodus = 'Exodus';
    sChat = 'Chat';

    sGrpUnfiled = 'Unfiled';
    sGrpOnline = 'Available';
    sGrpAway = 'Away';
    sGrpXA = 'Ext. Away';
    sGrpDND = 'Do Not Disturb';
    sGrpOffline = 'Offline';

    sRosterPending = ' (Pending)';
    sRosterAvail = 'Available';
    sRosterChat = 'Wants to chat';
    sRosterAway = 'Away';
    sRosterXA = 'Ext. Away';
    sRosterDND = 'Do Not Disturb';
    sRosterOffline = 'Offline';

    sDefaultProfile = 'Default Profile';
    sDefaultGroup = 'Untitled Group';

    sCommError = 'There was an error during communication with the Jabber Server';
    sDisconnected = 'You have been disconnected.';
    sAuthError = 'There was an error trying to authenticate you.'#13#10'Either you used the wrong password, or this account is already in use by someone else.';
    sRegError = 'An Error occurred trying to register your new account. This server may not allow open registration.';
    sAuthNoAccount = 'This account does not exist on this server. Create a new account?';
    sNewAccount = 'Your new jabber account is activated. Would you like to fill out additional registration information?';
    sCancelReconnect = 'Click to Cancel Reconnect';
    sReconnectIn = 'Reconnect in ';
    sSeconds = 'seconds.';

    sSetAutoAvailable = 'Setting Auto Available';
    sSetAutoAway = 'Setting AutoAway';
    sSetAutoXA = 'Setting AutoXA';
    sSetupAutoAway = 'Trying to setup the Auto Away timer.';
    sAutoAwayFail = 'AutoAway Setup FAILED!';
    sAutoAwayWin32 = 'Using Win32 API for Autoaway checks!!';
    sAutoAwayFailWin32 = 'ERROR GETTING WIN32 API ADDR FOR GetLastInputInfo!!';

    sMsgPing = 'Ping Time: %s seconds.';
    sMsgMessage = 'Msg from ';
    sMsgInvite = 'Invite from ';
    sMsgContacts = 'Contacts from ';
    sMsgRosterItems = 'This message contains %d roster items.';

    sNewGroup = 'New Roster Group';
    sNewGroupPrompt = 'Enter new group name: ';
    sNewGroupExists = 'This group already exists!';

    sLookupProfile = 'Lookup Profile';
    sSendMessage = 'Send a Message';
    sStartChat = 'Start Chat';
    sRegService = 'Register with Service';

    sJID = 'Jabber ID';
    sEnterJID = 'Enter Jabber ID: ';
    sEnterSvcJID = 'Enter Jabber ID of Service: ';
    sInvalidJID = 'The Jabber ID you entered is invalid.';

    sPasswordError = 'Error changing password.';
    sPasswordChanged = 'Password changed.';
    sPasswordOldError = 'Old password is incorrect.';
    sPasswordNewError = 'New password does not match.';
    sPasswordCaption = 'Exodus Password';
    sPasswordPrompt = 'Enter Password';

    sAlreadySubscribed = 'You are already subscribed to this contact';
    sBrandingError = 'Branding error!';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
const
    MaxIcons = 64;      // How many icons are in icons.res ??

    ico_Unassigned = -1;
    ico_Offline = 0;
    ico_None = 1;
    ico_Online = 1;
    ico_Chat = 4;
    ico_Away = 2;
    ico_XA = 10;
    ico_DND = 3;
    ico_Folder = 9;
    ico_ResFolder = 7;
    ico_Unknown = 6;
    ico_msg = 11;
    ico_info = 12;
    ico_userbook = 13;

    ico_key = 16;
    ico_application = 19;
    ico_user = 20;
    ico_conf = 21;
    ico_service = 22;
    ico_headline = 23;
    ico_Unread = 23;
    ico_keyword = 24;
    ico_render = 25;
    ico_down = 27;
    ico_right = 28;
    ico_blocked = 39;
    ico_blockoffline = 41;
    ico_error = 32;

{$ifdef TRACE_EXCEPTIONS}
procedure ExceptionTracker(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean);
{$endif}


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef TRACE_EXCEPTIONS}
    IdException,
    JclHookExcept, JclDebug, ExceptTracer,
    {$endif}

    About, AutoUpdate, AutoUpdateStatus, Bookmark, Browser, Chat,
    ChatController, ChatWin, Debug, Dockable, ExSession, ExUtils,
    GetOpt, InputPassword, Invite, GnuGetText,
    Iq, JUD, JabberID, JabberMsg, IdGlobal,
    JabberConst, ComController, CommCtrl, CustomPres,
    JoinRoom, Login, MsgController, MsgDisplay, MsgQueue, MsgRecv, Password,
    PrefController, Prefs, PrefNotify, Profile, RegForm, RemoveContact, RiserWindow, Room,
    Roster, RosterAdd, Session, StandardAuth, Subscribe, Transfer, Unicode, VCard, xData,
    XMLUtils, XMLParser;

{$R *.DFM}

{---------------------------------------}
procedure TfrmExodus.CreateParams(var Params: TCreateParams);
begin
    // Make each window appear on the task bar.
    inherited CreateParams(Params);
    with Params do begin
        ExStyle := ExStyle or WS_EX_APPWINDOW;
        WndParent := GetDesktopWindow();
    end;
end;

{---------------------------------------}
procedure TfrmExodus.WMSysCommand(var msg: TWmSysCommand);
begin
    // Catch some of the important windows msgs
    // so that we can handle minimizing & stuff properly
    case (msg.CmdType and $FFF0) of
    SC_MINIMIZE: begin
        _hidden := true;
        ShowWindow(Handle, SW_HIDE);
        msg.Result := 0;
    end;
    SC_RESTORE: begin
        ShowWindow(Handle, SW_RESTORE);
        msg.Result := 0;
    end;
    SC_CLOSE: begin
        if ((_close_min) and (not _shutdown)) then begin
            _hidden := true;
            ShowWindow(Handle, SW_HIDE);
            msg.Result := 0;
        end
        else
            inherited;
    end;
    else
        inherited;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.WMTray(var msg: TMessage);
var
    cp: TPoint;
begin
    // this gets fired when the user clicks on the tray icon
    // manually handle popping up the tray menu..
    // since the delphi/vcl impl isn't quite right.
    if (Msg.LParam = WM_LBUTTONDBLCLK) then begin
        if (_hidden) then begin
            // restore our app
            _hidden := false;
            ShowWindow(Handle, SW_RESTORE);
            SetForegroundWindow(Self.Handle);
            msg.Result := 0;
        end
        else begin
            // minimize our app
            _hidden := true;
            self.WindowState := wsMinimized;
            ShowWindow(Handle, SW_HIDE);
            PostMessage(Self.handle, WM_SYSCOMMAND, SC_MINIMIZE , 0);
        end;
    end
    else if ((Msg.LParam = WM_LBUTTONDOWN) and (not Application.Active) and (not _hidden))then begin
        SetForegroundWindow(Self.Handle);
    end

    else if (Msg.LParam = WM_RBUTTONDOWN) then begin
        GetCursorPos(cp);
        SetForegroundWindow(Self.Handle);
        Application.ProcessMessages;
        popTray.Popup(cp.x, cp.y);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.WMQueryEndSession(var msg: TMessage);
begin
    // Allow windows to shutdown
    _shutdown := true;
    msg.Result := 1;
end;

{---------------------------------------}
procedure TfrmExodus.WMEndSession(var msg: TMessage);
begin
    // Kill the application
    _shutdown := true;
    msg.Result := 0;
end;

{---------------------------------------}
procedure TfrmExodus.WMShowLogin(var msg: TMessage);
begin
    // Show the login window
    _reconnect_tries := 0;
    _new_account := false;
    ShowLogin();
end;

{---------------------------------------}
procedure TfrmExodus.WMCloseApp(var msg: TMessage);
begin
    // Close the main form
    Self.Close();
end;

{---------------------------------------}
procedure TfrmExodus.WMReconnect(var msg: TMessage);
begin
    // Enable the reconnect timer
    timReconnect.Enabled := true;
end;

{---------------------------------------}
procedure TfrmExodus.WMInstaller(var msg: TMessage);
var
    reg : TRegistry;
    cmd : string;
    i : integer;
begin
    // We are getting a Windows Msg from the installer
    if (not _shutdown) then begin
        reg := TRegistry.Create();
        reg.RootKey := HKEY_CURRENT_USER;
        reg.OpenKey('\Software\Jabber\Exodus\Restart\' + IntToStr(Application.Handle), true);

        for i := 1 to ParamCount do
            cmd := cmd + ' ' + ParamStr(i);
        reg.WriteString('cmdline', cmd);
        GetDir(0, cmd);
        reg.WriteString('cwd', cmd);
        reg.WriteString('show', MainSession.Show);
        reg.WriteString('status', MainSession.Status);
        if (MainSession.Priority = -1) then
            reg.WriteInteger('priority', 0)
        else
            reg.WriteInteger('priority', MainSession.Priority);

        if (MainSession.Profile <> nil) then
            reg.WriteString('profile', MainSession.Profile.Name);

        reg.CloseKey();
        reg.Free();

        _shutdown := true;
        Self.Close;
    end;
end;

procedure TfrmExodus.WMDisconnect(var msg: TMessage);
begin
    //
    MainSession.Disconnect();
end;


{---------------------------------------}
{---------------------------------------}
{$ifdef TRACE_EXCEPTIONS}
procedure ExceptionTracker(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean);
var
    e: Exception;
begin
    // trace := TStringList.Create();
    e := Exception(ExceptObj);
    if (e is EConvertError) then exit;
    if (e is EIdSocketError) then exit;
end;
{$endif}

{---------------------------------------}
{---------------------------------------}
procedure TfrmExodus.FormCreate(Sender: TObject);
var
    win_ver: string;
    menu_list: TWideStringList;
    i : integer;
    mi: TMenuItem;
begin
    {$ifdef TRACE_EXCEPTIONS}
    // Application.OnException := ApplicationException;
    Include(JclStackTrackingOptions, stRawMode);
    {$endif}

    ActiveChat := nil;
    _new_tabindex := -1;

    // Do translation magic
    TranslateProperties(Self);

    // setup our tray icon
    _tray_icon := TIcon.Create();

    // if we are testing auto-away, then fire the
    // timer every 1 second, instead of every 10 secs.
    if (ExStartup.testaa) then
        _auto_away_interval := 1
    else
        _auto_away_interval := 10;
    timAutoAway.Interval := _auto_away_interval * 1000;

    with MainSession.Prefs do begin
        // Setup our caption and the help menus.
        self.Caption := GetString('brand_caption');
        RestorePosition(Self);

        menu_list := TWideStringList.Create();
        fillStringlist('brand_help_menu_list', menu_list);
        for i := 0 to menu_list.Count-1 do begin
            mi := TMenuItem.Create(self);
            mi.Caption := menu_list.Strings[i];
            mi.OnClick := ShowBrandURL;
            Help1.Insert(i, mi);
        end;
        menu_list.Free();

        // If we are supposed to be hidden, make it so.
        if (ExStartup.minimized) then begin
            _hidden := true;
            self.WindowState := wsMinimized;
            ShowWindow(Handle, SW_HIDE);
            PostMessage(Self.handle, WM_SYSCOMMAND, SC_MINIMIZE , 0);
        end;

        // Show the debug form, if they've asked for it.
        if (ExStartup.debug) then ShowDebugForm();
    end;

    // Setup callbacks
    _sessioncb := MainSession.RegisterCallback(SessionCallback, '/session');

    // Setup the Tabs, toolbar, panel, and roster madness
    Tabs.ActivePage := tbsRoster;
    restoreToolbar();
    pnlRight.Visible := MainSession.Prefs.getBool('expanded');
    restoreRoster();

    // some gui related flags
    _appclosing := false;
    _noMoveCheck := true;
    _noMoveCheck := false;
    _tray_notify := false;
    _reconnect_tries := 0;
    _hidden := false;
    _shutdown := false;
    _close_min := MainSession.prefs.getBool('close_min');

    // Setup the IdleUI stuff..
    _is_autoaway := false;
    _is_autoxa := false;
    _is_min := false;
    _is_broadcast := false;
    _windows_ver := WindowsVersion(win_ver);

    // Setup various callbacks, timers, etc.
    setupAutoAwayTimer();
    Self.SessionCallback('/session/prefs', nil);
    Self.setupTrayIcon();
    ConfigEmoticons();

    MainSession.setPresence(ExStartup.show, ExStartup.Status, ExStartup.Priority);

    SetLength(_win32_tracker, 20);
    _win32_idx := 0;

    {$ifdef TRACE_EXCEPTIONS}
    Test1.Visible := true;
    {$endif}

    sExodusCWPHook := 0;
    sExodusGMHook := 0;

end;

{---------------------------------------}
function TfrmExodus.WMAppBar(dwMessage: DWORD; var pData: TAppBarData): UINT; stdcall;
begin
    // what the heck fires this?????
    Result := 0;
    MoveWindow(Self.Handle, pData.rc.Left, pData.rc.Top,
        Self.Width, Screen.Height, true);
end;

{---------------------------------------}
procedure TfrmExodus.setupTrayIcon();
var
    picon: TIcon;
begin
    // Create the tray icon, etc..
    picon := TIcon.Create();
    ImageList2.GetIcon(0, picon);
    with _tray do begin
        Wnd := Self.Handle;
        uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
        uCallbackMessage := WM_TRAY;
        hIcon := picon.Handle;
        strPCopy(szTip, sExodus);
        cbSize := SizeOf(_tray);
    end;
    Shell_NotifyIcon(NIM_ADD, @_tray);
    picon.Free();
end;

{---------------------------------------}
procedure TfrmExodus.Startup;
begin
    // load up all the plugins..
    InitPlugins();

    // Creat and dock the MsgQueue if we're in expanded mode
    if (MainSession.Prefs.getBool('expanded')) then begin
        getMsgQueue();
        frmMsgQueue.ManualDock(Self.pnlRight, nil, alClient);
        frmMsgQueue.Align := alClient;
        frmMsgQueue.Show;
    end;

    // auto-login if enabled, otherwise, show the login window
    // Note that we use a Windows Msg to do this to show the login
    // window async since it's a modal dialog.
    with MainSession.Prefs do begin
        if (ExStartup.auto_login) then begin
            // snag default profile, etc..
            if (ExStartup.priority <> -1) then
                MainSession.Priority := ExStartup.priority;
            Self.DoConnect();
        end
        else
            PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.DoConnect();
var
    pw : WideString;
begin
    // Make sure that the active profile
    // has the password field filled out.
    // If not, pop up the password prompt,
    // otherwise, just call connect.

    // NB: For non-std auth agents, set prompt_password
    // accordingly.
    if ((MainSession.password = '') and
        (MainSession.getAuthAgent().prompt_password)) then begin
        pw := '';
        if ((not InputQueryW(sPasswordCaption, sPasswordPrompt, pw, True)) or
            (pw = '')) then exit;
        MainSession.Password := pw;
    end;
    MainSession.FireEvent('/session/connecting', nil);
    MainSession.Connect();
end;

{---------------------------------------}
procedure TfrmExodus.setupAutoAwayTimer();
begin
    // Setup the auto-away timer
    // Note that for W2k and XP, we are just going to
    // use the special API calls for getting inactivity.
    // For other OS's we need to use the wicked nasty DLL
    _valid_aa := false;
    DebugMsg(sSetupAutoAway);
    if ((_windows_ver < cWIN_2000) or (_windows_ver = cWIN_ME)) then begin
        // Use the DLL
        @_GetLastTick := nil;
        @_InitHooks := nil;
        @_StopHooks := nil;

        _idle_hooks := LoadLibrary('IdleHooks.dll');
        if (_idle_hooks <> 0) then begin
            // start the hooks
            @_GetLastTick := GetProcAddress(_idle_hooks, 'GetLastTick');
            @_InitHooks := GetProcAddress(_idle_hooks, 'InitHooks');
            @_StopHooks := GetProcAddress(_idle_hooks, 'StopHooks');

            DebugMsg('_GetHookPointer = ' + IntToStr(integer(@_GetLastTick)));
            DebugMsg('_InitHooks = ' + IntToStr(integer(@_InitHooks)));
            DebugMsg('_StopHooks = ' + IntToStr(integer(@_StopHooks)));

            _InitHooks();
            _valid_aa := true;
        end
        else
            DebugMsg(sAutoAwayFail);
        _last_tick := GetTickCount();
    end
    else begin
        // Use the GetLastInputInfo API call
        // do nothing here..
        if (_GetLastInputInfo <> nil) then begin
            DebugMsg(sAutoAwayWin32);
            _valid_aa := true;
            end
        else
            DebugMsg(sAutoAwayFailWin32);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.setTrayInfo(tip: string);
begin
    // setup the tray tool-tip
    _tray_tip := tip;
    StrPCopy(@_tray. szTip, tip);
    Shell_NotifyIcon(NIM_MODIFY, @_tray);
end;

{---------------------------------------}
procedure TfrmExodus.setTrayIcon(iconNum: integer);
begin
    // setup the tray icon based on a specific icon index
    _tray_icon_idx := iconNum;
    ImageList2.GetIcon(iconNum, _tray_icon);
    _tray.hIcon := _tray_icon.Handle;
    Shell_NotifyIcon(NIM_MODIFY, @_tray);
end;

{---------------------------------------}
procedure TfrmExodus.CancelConnect();
begin
    _logoff := true;
    if (MainSession.Active) then
        MainSession.Stream.Disconnect()
    else
        timReconnect.Enabled := false;
    // MainSession.FireCallback('/session/disconnected', nil);
end;

{---------------------------------------}
procedure TfrmExodus.SessionCallback(event: string; tag: TXMLTag);
var
    rtries, rint: integer; 
    msg : TMessage;
begin
    // session related events
    if event = '/session/connected' then begin
        timReconnect.Enabled := false;
        _logoff := false;
        _reconnect_tries := 0;
        btnConnect.Down := true;
        setTrayIcon(1);
    end

    else if event = '/session/autherror' then begin
        _logoff := true;
        MessageDlg(sAuthError, mtError, [mbOK], 0);
        PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
        exit;
    end

    else if event = '/session/regerror' then begin
        _logoff := true;
        MessageDlg(sRegError, mtError, [mbOK], 0);
        exit;
    end

    else if event = '/session/noaccount' then begin
        if (MessageDlg(sAuthNoAccount, mtConfirmation, [mbYes, mbNo], 0) = mrNo) then begin
            // Just disconnect, they don't want an account
            _logoff := true;
            PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
        end
        else begin
            // create the new account
            _new_account := true;
            MainSession.CreateAccount();
        end;
    end

    else if event = '/session/authenticated' then with MainSession do begin
        Self.Caption := MainSession.Prefs.getString('brand_caption') + ' - ' + MainSession.Username + '@' + MainSession.Server;
        setTrayInfo(Self.Caption);

        // Accept files dragged from Explorer
        // Only do this for normal (non-polling) connections
        if (MainSession.Profile.ConnectionType = conn_normal) then
            DragAcceptFiles(Handle, True);

        // Fetch the roster
        Roster.Fetch;

        // Don't broadcast our initial presence
        _is_broadcast := true;
        if (_last_show <> '') then
            MainSession.setPresence(_last_show, _last_status, _last_priority)
        else
            MainSession.setPresence(MainSession.Show, MainSession.Status, MainSession.Priority);
        _is_broadcast := false;

        // Make the roster the active tab
        Tabs.ActivePage := tbsRoster;

        // Activate the menus
        restoreMenus(true);

        // turn on the auto-away timer
        if (_valid_aa) then timAutoAway.Enabled := true;

        // check for new brand.
        InitUpdateBranding();

        // check for new version
        InitAutoUpdate();

        // if we have a new account, prompt for reg info
        if (_new_account) then begin
            if (MessageDlg(sNewAccount, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
                mnuRegistrationClick(Self);
            end;
            _new_account := false;
        end;

        PlayXMPPActions();
    end

    else if (event = '/session/disconnected') then begin
        // Make sure windows knows we don't want files
        // dropped on us anymore.
        if (MainSession.Profile.ConnectionType = conn_normal) then
            DragAcceptFiles(Handle, False);

        timAutoAway.Enabled := false;
        CloseSubscribeWindows();

        Self.Caption := sExodus;
        setTrayInfo(Self.Caption);
        setTrayIcon(0);

        _new_account := false;
        btnConnect.Down := false;
        restoreMenus(false);

        if (_appclosing) then
            PostMessage(Self.Handle, WM_CLOSEAPP, 0, 0)
        else if (not _logoff) then with timReconnect do begin
            _last_show := MainSession.Show;
            _last_status := MainSession.Status;
            _last_priority := MainSession.Priority;

            inc(_reconnect_tries);

            rtries := MainSession.Prefs.getInt('recon_tries');
            if (rtries <= 0) then rtries := 3;
            rint := MainSession.Prefs.getInt('recon_time');

            if (_reconnect_tries < rtries) then begin
                Randomize();
                if (rint <= 0) then
                    _reconnect_interval := Trunc(Random(20)) + 2
                else
                    _reconnect_interval := rint;

                Interval := 1000;
                DebugMsg('Setting reconnect timer to: ' + IntToStr(_reconnect_interval));

                _reconnect_cur := 0;
                frmRosterWindow.aniWait.Visible := false;
                PostMessage(Self.Handle, WM_RECONNECT, 0, 0);
            end
            else
                DebugMsg('Attempted to reconnect too many times.');
        end
        else begin
            _last_show := '';
            _last_status := '';
        end;
    end
    else if event = '/session/commtimeout' then begin
        timAutoAway.Enabled := false;
        _logoff := true;
    end

    else if event = '/session/commerror' then begin
        timAutoAway.Enabled := false;
    end

    else if event = '/session/stream:error' then begin
        // we got a stream error.
        // _logoff is set to tell the client to NOT to auto-reconnect
        // This prevents the clients from resource-battling
        _logoff := true;
    end

    else if event = '/session/prefs' then begin
        // some private vars we want to cache
        with MainSession.prefs do begin
            if (getBool('snap_on')) then
                _edge_snap := getInt('edge_snap')
            else
                _edge_snap := -1;
            _close_min := getBool('close_min');
            _auto_away := getBool('auto_away');
            use_emoticons := getBool('emoticons');
        end;

        // setup the Exodus window..
        if (MainSession.Prefs.getBool('window_ontop')) then
            SetWindowPos(Self.Handle, HWND_TOPMOST, 0,0,0,0,
                SWP_NOMOVE + SWP_NOREPOSITION + SWP_NOSIZE)
        else
            SetWindowPos(Self.Handle, HWND_NOTOPMOST, 0,0,0,0,
                SWP_NOMOVE + SWP_NOREPOSITION + SWP_NOSIZE);

        if (MainSession.Prefs.getBool('window_toolbox')) then begin
            if (Self.BorderStyle <> bsSizeToolWin) then begin
                // requires a restart of the application
                Self.BorderStyle := bsSizeToolWin;
            end;
        end
        else begin
            if (Self.BorderStyle <> bsSizeable) then begin
                Self.BorderStyle := bsSizeable;
            end;
        end;

        // Setup the background colors for emoticons
        imgMSNEmoticons.BkColor := TColor(MainSession.Prefs.getInt('color_bg'));
        imgYahooEmoticons.BkColor := TColor(MainSession.Prefs.getInt('color_bg'));

        // reset the tray icon stuff
        Shell_NotifyIcon(NIM_DELETE, @_tray);
        Self.setupTrayIcon();
        setTrayInfo(_tray_tip);
        setTrayIcon(_tray_icon_idx);

        // do gui stuff
        restoreMenus(MainSession.Active);
        restoreToolbar();
        restoreAlpha();
        restoreRoster();

        if not MainSession.Prefs.getBool('expanded') then
            tbsRoster.TabVisible := false;
    end

    else if (event = '/session/presence') then begin
        // Our presence was changed.. reflect that in the tray icon
        if (MainSession.Show = '') then
            SetTrayIcon(1)
        else if (MainSession.Show = 'away') then
            SetTrayIcon(2)
        else if (MainSession.Show = 'dnd') then
            SetTrayIcon(3)
        else if (MainSession.Show = 'chat') then
            SetTrayIcon(4)
        else if (MainSession.Show = 'xa') then
            SetTrayIcon(10);

        // don't send message on autoaway or auto-return
        if (_is_autoaway or _is_autoxa or _is_broadcast) then exit;

        // Send a windows msg so other copies of Exodus will change their
        // status to match ours.
        if (not MainSession.Prefs.getBool('presence_message_send')) then exit;
        msg.LParamHi := GetPresenceAtom(MainSession.Show);
        msg.LParamLo := GetPresenceAtom(MainSession.Status);
        PostMessage(HWND_BROADCAST, sExodusPresence, self.Handle, msg.LParam);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.restoreToolbar;
begin
    // setup the toolbar based on prefs
    with MainSession.Prefs do begin
        mnuExpanded.Checked := getBool('expanded');

        btnOnlineRoster.Down := getBool('roster_only_online');
        mnuOnline.Checked := btnOnlineRoster.Down;

        if getBool('expanded') then begin
            btnExpanded.ImageIndex := 9;
        end
        else begin
            btnExpanded.ImageIndex := 8;
        end;
        Toolbar.Visible := getBool('toolbar');
        mnuToolbar.Checked := Toolbar.Visible;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.restoreAlpha;
var
    alpha: boolean;
begin
    // setup the alpha-transparency for the main window
    // based on the prefs
    with MainSession.Prefs do begin
        alpha := getBool('roster_alpha');
        Self.AlphaBlend := (alpha);
        if alpha then
            Self.AlphaBlendValue := MainSession.Prefs.getInt('roster_alpha_val')
        else
            Self.AlphaBlendValue := 255;
        if (frmMsgQueue <> nil) then begin
            frmMsgQueue.lstEvents.Color := TColor(getInt('roster_bg'));
            frmMsgQueue.txtMsg.Color := TColor(getInt('roster_bg'));
            AssignDefaultFont(frmMsgQueue.txtMsg.Font);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.restoreMenus(enable: boolean);
var
    plist: TList;
    imidx, i: integer;
    mnu: TMenuItem;
    cp: TJabberCustompres;
begin
    // (dis)enable the menus
    mnuMessage.Enabled := enable;
    mnuChat.Enabled := enable;
    mnuConference.Enabled := enable;
    mnuPassword.Enabled := enable;
    mnuRegisterService.Enabled := enable;

    mnuContacts.Enabled := enable;
    mnuPresence.Enabled := enable;
    trayPresence.Enabled := enable;

    mnuRegistration.Enabled := enable;
    mnuMyVCard.Enabled := enable;
    mnuVCard.Enabled := enable;

    mnuBookmark.Enabled := enable;
    mnuBrowser.Enabled := enable;
    mnuServer.Enabled := enable;

    // (dis)enable the tray menus
    trayPresence.Enabled := enable;
    trayMessage.Enabled := enable;


    // Enable toolbar btns
    btnOnlineRoster.Enabled := enable;
    btnAddContact.Enabled := enable;
    btnRoom.Enabled := enable;
    btnFind.Enabled := enable;

    // Build the custom presence menus.
    // make sure to leave the main "Custom" entry and the divider
    for i := presCustom.Count - 1 downto 2 do
        presCustom.Items[i].Free;
    for i := trayCustom.Count - 1 downto 2 do
        trayCustom.Items[i].Free;

    plist := MainSession.prefs.getAllPresence();
    for i := 0 to plist.count - 1 do begin
        cp := TJabberCustomPres(plist[i]);

        if (cp.show = 'chat') then imidx := ico_Chat
        else if (cp.show = 'away') then imidx := ico_Away
        else if (cp.Show = 'xa') then imidx := ico_XA
        else if (cp.show = 'dnd') then imidx := ico_DND
        else imidx := ico_Online;

        mnu := TMenuItem.Create(presCustom);
        mnu.Caption := cp.title;
        mnu.tag := i;
        mnu.OnClick := presCustomPresClick;
        mnu.ShortCut := TextToShortcut(cp.hotkey);
        mnu.ImageIndex := imidx;
        presCustom.Add(mnu);

        mnu := TMenuItem.Create(trayCustom);
        mnu.Caption := cp.title;
        mnu.tag := i;
        mnu.OnClick := presCustomPresClick;
        mnu.ImageIndex := imidx;

        trayCustom.Add(mnu);
        cp.Free();
    end;

    plist.Clear();
    plist.Free();
end;

{---------------------------------------}
procedure TfrmExodus.CTCPCallback(event: string; tag: TXMLTag);
var
    e: TJabberEvent;
begin
    // record some kind of CTCP result
    if ((tag <> nil) and (tag.getAttribute('type') = 'result')) then begin
        if MainSession.IsPaused then
            MainSession.QueueEvent(event, tag, Self.CTCPCallback)
        else begin
            e := CreateJabberEvent(tag);
            e.elapsed_time := SafeInt(tag.GetAttribute('iq_elapsed_time'));
            RenderEvent(e);
        end;
    end
end;

{---------------------------------------}
procedure TfrmExodus.btnConnectClick(Sender: TObject);
begin
    // connect to the server
    if MainSession.Active then begin
        _logoff := true;
        MainSession.Disconnect();
    end
    else begin
        _reconnect_tries := 0;
        ShowLogin;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    // If we are not already disconnected, then
    // disconnect. Once we successfully disconnect,
    // we'll close the form properly (xref _appclosing)
    if (MainSession <> nil) then begin

        if ((MainSession.Active) and (not _appclosing))then begin
            _appclosing := true;
            _logoff := true;
            MainSession.Stream.Disconnect();
            CanClose := false;
            exit;
        end;

    end;

    // Unhook the auto-away DLL
    if (_idle_hooks <> 0) then begin
        _StopHooks();
        _idle_hooks := 0;
    end;

    // Unhook the other Win32 hooks.
    if (sExodusGMHook <> 0) then begin
        UnHookWindowsHookEx(sExodusGMHook);
        sExodusGMHook := 0;
    end;
    if (sExodusCWPHook <> 0) then begin
        UnhookWindowsHookEx(sExodusCWPHook);
        sExodusCWPHook := 0;
    end;

    // Close up the msg queue
    if (frmMsgQueue <> nil) then begin
        frmMsgQueue.lstEvents.Items.Clear;
        frmMsgQueue.Close;
    end;

    // If we have a session, close it up
    // and all of the associated windows
    if MainSession <> nil then begin
        CloseDebugForm();
        frmRosterWindow.ClearNodes();
        frmRosterWindow.Close;
        CloseAllChats();

        // Unload all of the remaining plugins
        UnloadPlugins();

        // Unregister callbacks, etc.
        MainSession.UnRegisterCallback(_sessioncb);
        MainSession.Prefs.SavePosition(Self);

        TeardownSession();
    end;

    // Kill the tray icon stuff
    if (_tray_icon <> nil) then
        FreeAndNil(_tray_icon);
end;

{---------------------------------------}
procedure TfrmExodus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    // Kill the application
    Shell_NotifyIcon(NIM_DELETE, @_tray);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmExodus.btnOnlineRosterClick(Sender: TObject);
var
    filter: boolean;
begin
    // show only online
    with MainSession.Prefs do begin
        filter := not getBool('roster_only_online');
        setBool('roster_only_online', filter);
        btnOnlineRoster.Down := filter;
        mnuOnline.Checked := filter;
    end;

    if MainSession.Active then begin
        frmRosterWindow.SessionCallback('/session/prefs', nil);
        frmRosterWindow.Redraw;

        if ((MainSession.Prefs.getBool('expanded')) and
            (Tabs.ActivePage <> tbsRoster)) then
            Tabs.ActivePage := tbsRoster;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.btnAddContactClick(Sender: TObject);
begin
    // add a contact
    ShowAddContact();
end;

{---------------------------------------}
procedure TfrmExodus.mnuConferenceClick(Sender: TObject);
begin
    // Join a TC Room
    StartJoinRoom();
end;

{---------------------------------------}
procedure TfrmExodus.FormResize(Sender: TObject);
begin
    // When we are resized, save the new position
    if MainSession <> nil then
        MainSession.Prefs.SavePosition(Self);
end;

{---------------------------------------}
procedure TfrmExodus.Preferences1Click(Sender: TObject);
begin
    // Show the prefs
    StartPrefs();
end;

{---------------------------------------}
procedure TfrmExodus.btnExpandedClick(Sender: TObject);
var
    delta, w: longint;
    newval: boolean;
begin
    // either expand or compress the whole thing
    newval := not MainSession.Prefs.getBool('expanded');
    mnuExpanded.Checked := newval;

    // this is how much we're changing
    if ((pnlLeft.Visible) and (pnlLeft.Width > 0)) then
        delta := -SplitterRight.Width
    else
        delta := Self.ClientWidth - tbsRoster.Width + SplitterLeft.Width;

    MainSession.Prefs.setBool('expanded', newval);
    if newval then begin
        // we are expanded now
        // the width of the msg queue
        w := MainSession.Prefs.getInt('event_width');
        Self.ClientWidth := Self.ClientWidth + w - delta;
        restoreRoster();
    end
    else begin
        // we are compressed now
        w := pnlRight.Width;
        MainSession.Prefs.setInt('event_width', w);
        restoreRoster();
        Self.ClientWidth := Self.ClientWidth - w;
        Self.Show;
    end;


    MainSession.Prefs.RestorePosition(Self);
    restoreToolbar();
    restoreRoster();

    Self.Width := Self.Width + 1;
    Self.Width := Self.Width - 1;
end;

{---------------------------------------}
procedure TfrmExodus.restoreRoster();
var
    docked: TfrmDockable;
    expanded, messenger: boolean;
    roster_w, event_w: integer;
    i, active_tab: integer;
    rpanel: TPanel;
    cc: TChatController;
    cw: TfrmChat;
begin
    // figure out the width of the msg queue
    event_w := MainSession.Prefs.getInt(P_EVENT_WIDTH);
    roster_w := Self.ClientWidth - event_w;
    if (event_w < 0) then event_w := Self.ClientWidth div 2;

    // make sure the roster is docked in the appropriate place.
    messenger := MainSession.Prefs.getBool('roster_messenger');
    expanded := MainSession.Prefs.getBool('expanded');
    if (messenger) then begin
        if ((frmRosterWindow <> nil) and (not frmRosterWindow.inMessenger)) then
            frmRosterWindow.DockRoster();

        // setup panels for the roster
        pnlRoster.Visible := true;
        SplitterRight.Visible := (expanded);
        SplitterLeft.Visible := false;
        pnlLeft.Visible := false;
        pnlLeft.Width := 0;
        pnlRoster.Width := roster_w;

        rpanel := pnlRoster;
        if (expanded) then begin
            pnlRoster.Align := alLeft;
            SplitterRight.align := alRight;
            SplitterRight.align := alLeft;
        end
        else begin
            pnlRoster.Align := alClient;
        end;
    end
    else begin
        if ((frmRosterWindow <> nil) and (frmRosterWindow.inMessenger)) then
            frmRosterWindow.DockRoster();

        // setup panels for the roster
        pnlLeft.Visible := true;
        SplitterLeft.Visible := (expanded);
        SplitterRight.Visible := false;
        pnlRoster.Visible := false;
        if ((frmRosterWindow <> nil) and (frmRosterWindow.inMessenger)) then
            frmRosterWindow.DockRoster();
        pnlRoster.Width := 0;
        pnlLeft.Width := roster_w;

        rpanel := pnlLeft;
        if (expanded) then begin
            pnlLeft.Align := alLeft;
            SplitterLeft.align := alRight;
            SplitterLeft.Align := alLeft;
        end
        else begin
            pnlLeft.Align := alClient;
        end;
    end;

    // Show or hide the MsgQueue
    // Tabs.Visible := (expanded);
    Tabs.DockSite := (expanded);
    pnlRight.Visible := (expanded);
    tbsRoster.TabVisible := (expanded);
    if (expanded) then begin
        // Show the msg queue panel, and dock it.
        pnlRight.Visible := true;
        pnlRight.Width := event_w;
        getMsgQueue();
        if (frmMsgQueue <> nil) then begin
            frmMsgQueue.ManualDock(pnlRight, nil, alClient);
            frmMsgQueue.Show;
            frmMsgQueue.Align := alClient;
        end;

        // make sure the debug window is docked
        active_tab := Tabs.ActivePage.PageIndex;
        DockDebugForm();
        Tabs.ActivePage := Tabs.Pages[active_tab];
        if (frmRosterWindow <> nil) then
            frmRosterWindow.Refresh();
    end

    else begin
        // Undock the MsgQueue... if it's empty, close it.
        if (frmMsgQueue <> nil) then begin
            if ((frmMsgQueue.lstEvents.Items.Count > 0) and
                (not MainSession.Prefs.getBool('close_queue'))) then begin
                frmMsgQueue.Align := alNone;
                frmMsgQueue.FloatForm;
            end
            else
                frmMsgQueue.Close;
        end;

        // make sure we undock all of the tabs..
        while (Tabs.DockClientCount > 0) do begin
            docked := TfrmDockable(Tabs.DockClients[0]);
            docked.FloatForm;
        end;

        // make sure all invisible chat windows are undocked
        for i := 0 to MainSession.ChatList.Count - 1 do begin
            cc := TChatController(MainSession.ChatList.Objects[i]);
            cw := TfrmChat(cc.window);
            if ((cw <> nil) and (cw.Visible = false) and (cw.Docked)) then begin
                cw.FloatForm();
            end;
        end;

        Tabs.ActivePage := tbsRoster;
        FloatDebugForm();
        if (frmRosterWindow <> nil) then
            frmRosterWindow.Refresh();
        rpanel.Align := alClient;
        Self.Width := Self.Width + 1;
        Self.Refresh();
        Self.Width := Self.Width - 1;
        Self.Refresh;
    end;
end;


{---------------------------------------}
procedure TfrmExodus.ClearMessages1Click(Sender: TObject);
begin
    // Clear events from the list view.
    if (frmMsgQueue <> nil) then with frmMsgQueue do begin
        while (lstEvents.Items.Count > 0) do
            frmMsgQueue.RemoveItem(0);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.WMWindowPosChanging(var msg: TWMWindowPosChanging);
var
    r: TRect;
begin
    // Handle snapping this window to the screen edges.
    if _noMoveCheck then exit;
    if _edge_snap = -1 then exit;

    If ((SWP_NOMOVE or SWP_NOSIZE) and msg.WindowPos^.flags) <>
        (SWP_NOMOVE or SWP_NOSIZE) then begin
        {  Window is moved or sized, get usable screen area. }

        SystemParametersInfo( SPI_GETWORKAREA, 0, @r, 0 );

        {
        Check if operation would move part of the window out of this area.
        If so correct position and, if required, size, to keep window fully
        inside the workarea. Note that simply adding the SWM_NOMOVE and
        SWP_NOSIZE flags to the flags field does not work as intended if
        full dragging of windows is disabled. In this case the window would
        snap back to the start position instead of stopping at the edge of the
        workarea, and you could still move the drag rectangle outside that
        area.
        }

        with msg.WindowPos^ do begin
            if abs(x -  r.left) < _edge_snap then x:= r.left;
            if abs(y -  r.top) < _edge_snap then y := r.top;

            if abs( (x + cx) - r.right ) < _edge_snap then begin
                x := r.right - cx;
                if abs(x -  r.left) < _edge_snap then begin
                    cx := cx - (r.left - x);
                    x := r.Left;
                end; { if }
            end; { if }

            if abs( (y + cy) - r.bottom ) < _edge_snap then begin
                y := r.bottom - cy;
                if abs(y -  r.top) < _edge_snap then begin
                    cy := cy - (r.top - y);
                    y := r.top;
                end; { if }
            end; { if }
        end; { With }

    end;

    inherited;
end;

{---------------------------------------}
procedure TfrmExodus.FormShow(Sender: TObject);
begin
    _noMoveCheck := false;
end;

{---------------------------------------}
procedure TfrmExodus.btnDelPersonClick(Sender: TObject);
begin
    // delete the current contact
    frmRosterWindow.popRemoveClick(Self);
end;

{---------------------------------------}
procedure TfrmExodus.ShowXML1Click(Sender: TObject);
begin
    // show the debug window if it's hidden
    ShowDebugForm();
end;

{---------------------------------------}
procedure TfrmExodus.SplitterRightMoved(Sender: TObject);
begin
    // Save the current width
    MainSession.Prefs.setInt('event_width', pnlRight.Width);
end;

{---------------------------------------}
procedure TfrmExodus.Exit2Click(Sender: TObject);
begin
    // Close the whole honkin' thing
    _shutdown := true;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmExodus.timFlasherTimer(Sender: TObject);
begin
    // Flash the window
    FlashWindow(Application.Handle, true);
end;

{---------------------------------------}
procedure TfrmExodus.JabberorgWebsite1Click(Sender: TObject);
begin
    // goto www.jabber.org
    ShellExecute(0, 'open', 'http://www.jabber.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.JabberCentralWebsite1Click(Sender: TObject);
begin
    // goto www.jabberstudio.org
    ShellExecute(0, 'open', 'http://www.jabberstudio.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.SubmitExodusFeatureRequest1Click(Sender: TObject);
begin
    // goto http://www.jabberstudio.org/projects/exodus/features/add.php
    ShellExecute(0, 'open', 'http://www.jabberstudio.org', '', '', SW_SHOW);

end;

{---------------------------------------}
procedure TfrmExodus.About1Click(Sender: TObject);
begin
    // Show some about dialog box
    frmAbout := TfrmAbout.Create(Application);
    frmAbout.ShowModal();
end;

{---------------------------------------}
procedure TfrmExodus.presOnlineClick(Sender: TObject);
var
    m: TMenuItem;
    show, status: string;
begin
    // Set some presence..
    // TMenuItem.tag represent the show to use..

    m := TMenuItem(Sender);
    case m.Tag of
    0: Show := '';
    1: Show := 'chat';
    2: Show := 'away';
    3: Show := 'xa';
    4: Show := 'dnd';
    end;

    Status := m.Caption;
    MainSession.setPresence(show, status, MainSession.Priority);
end;

{---------------------------------------}
procedure TfrmExodus.mnuMyVCardClick(Sender: TObject);
begin
    ShowMyProfile();
end;

{---------------------------------------}
procedure TfrmExodus.mnuToolbarClick(Sender: TObject);
begin
    // toggle toolbar on/off
    Toolbar.Visible := not Toolbar.Visible;
    mnuToolbar.Checked := Toolbar.Visible;
    MainSession.Prefs.setBool('toolbar', Toolbar.Visible);
end;

{---------------------------------------}
procedure TfrmExodus.NewGroup2Click(Sender: TObject);
var
    new_grp: WideString;
    gl: TWideStringList;
    x: TXMLTag;
begin
    // Add a roster grp.
    new_grp := sDefaultGroup;
    if InputQueryW(sNewGroup, sNewGroupPrompt, new_grp) = false then exit;

    // add the new grp.
    gl := MainSession.Roster.GrpList;
    if (gl.IndexOf(new_grp) >= 0) then begin
        // this grp already exists
        MessageDlg(sNewGroupExists, mtError, [mbOK], 0);
    end
    else begin
        // add the new grp.
        gl.Add(new_grp);
        with frmRosterWindow do begin
            RenderGroup(gl.Count - 1);
            treeRoster.AlphaSort(true);
        end;
        x := TXMLTag.Create('group');
        x.setAttribute('name', new_grp);
        MainSession.FireEvent('/roster/newgroup', x);
        x.Free();
    end;
end;

{---------------------------------------}
function TfrmExodus.getLastTick(): dword;
var
    last_info: TLastInputInfo;
begin
    // Return the last tick count of activity
    Result := 0;
    if ((_windows_ver < cWIN_2000) or (_windows_ver = cWIN_ME)) then begin
        if ((_idle_hooks <> 0) and (@_GetLastTick <> nil)) then
            Result := _GetLastTick();
    end
    else begin
        // use GetLastInputInfo
        last_info.cbSize := sizeof(last_info);
        if (GetLastInputInfo(last_info)) then
            Result := last_info.dwTime
    end;
end;

{---------------------------------------}
procedure TfrmExodus.timAutoAwayTimer(Sender: TObject);
var
    mins, away, xa: integer;
    cur_idle: longword;
    {$ifdef TEST_AUTOAWAY}
    dmsg: string;
    {$endif}
    avail: boolean;
begin
    {
    Auto-away mad-ness......

    Get the current idle time, and based on that, "do the right thing".

    Note that we don't want to set a-away if we're already
    away, XA, or DND.

    getLasTick() uses either the idleHooks.dll or the appropriate
    API call if they are available (w2k and xp) to get the last
    tick count which had activity.
    }

    if (MainSession = nil) then exit;
    if (not MainSession.Active) then exit;

    with MainSession.Prefs do begin
        if ((_auto_away)) then begin

            _last_tick := getLastTick();
            if (_last_tick = 0) then exit;

            cur_idle := (GetTickCount() - _last_tick) div 1000;
            if (not ExStartup.testaa) then
                mins := cur_idle div 60
            else
                mins := cur_idle;

            {$ifdef TEST_AUTOAWAY}
            if (not _is_autoaway) and (not _is_autoxa) then begin
                dmsg := 'Idle Check: ' + SafeBoolStr(_is_autoaway) + ', ' +
                    SafeBoolStr(_is_autoxa) + ', ' +
                    IntToStr(cur_idle ) + ' secs'#13#10;
                DebugMsg(dmsg);
            end;
            {$endif}

            away := getInt('away_time');
            xa := getInt('xa_time');

            avail := (MainSession.Show <> 'dnd') and (MainSession.Show <> 'xa') and
                (MainSession.Show <> 'away');

            if ((mins = 0) and ((_is_autoaway) or (_is_autoxa))) then SetAutoAvailable()
            else if (_is_autoxa) then exit
            else if ((mins >= xa) and (_is_autoaway)) then SetAutoXA()
            else if ((mins >= away) and (not _is_autoaway) and (avail)) then SetAutoAway();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.SetAutoAway;
var
    new_pri: integer;
begin
    // set us to away
    DebugMsg(sSetAutoAway);
    Application.ProcessMessages;

    MainSession.Pause();
    if ((MainSession.Show = 'away') or
        (MainSession.Show = 'xa') or
        (MainSession.Show = 'dnd')) then exit;

    _last_show := MainSession.Show;
    _last_status := MainSession.Status;
    _last_priority := MainSession.Priority;

    // must be before SetPresence
    _is_autoaway := true;
    _is_autoxa := false;

    if MainSession.Prefs.getBool('aa_reduce_pri') then
        new_pri := 0
    else
        new_pri := _last_priority;

    MainSession.SetPresence('away', MainSession.prefs.getString('away_status'),
        new_pri);

    timAutoAway.Interval := 1000;
end;

{---------------------------------------}
procedure TfrmExodus.SetAutoXA;
begin
    // set us to xa
    DebugMsg(sSetAutoXA);

    // must be before SetPresence
    _is_autoaway := false;
    _is_autoxa := true;

    MainSession.SetPresence('xa', MainSession.prefs.getString('xa_status'),
        MainSession.Priority);
end;

{---------------------------------------}
procedure TfrmExodus.SetAutoAvailable;
begin
    // reset our status to available
    DebugMsg(sSetAutoAvailable);
    timAutoAway.Enabled := false;
    timAutoAway.Interval := _auto_away_interval * 1000;
    MainSession.SetPresence(_last_show, _last_status, _last_priority);

    // must be *after* SetPresence
    _is_autoaway := false;
    _is_autoxa := false;

    if (_valid_aa) then
        timAutoAway.Enabled := true;

    MainSession.Play();
end;

{---------------------------------------}
procedure TfrmExodus.MessageHistory2Click(Sender: TObject);
begin
    // show a history dialog
    frmRosterWindow.popHistoryClick(Sender);
end;

{---------------------------------------}
procedure TfrmExodus.Properties2Click(Sender: TObject);
begin
    // Show a properties dialog
    frmRosterWindow.popPropertiesClick(Sender);
end;

{---------------------------------------}
procedure TfrmExodus.mnuVCardClick(Sender: TObject);
var
    jid: WideString;
begin
    // lookup some arbitrary vcard..
    if InputQueryW(sLookupProfile, sEnterJID, jid) then
        ShowProfile(jid);
end;

{---------------------------------------}
procedure TfrmExodus.SearchforPerson1Click(Sender: TObject);
begin
    // Start a default search
    StartSearch(MainSession.MyAgents.getFirstSearch);
end;

{---------------------------------------}
procedure TfrmExodus.TabsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    v, i, tab: integer;
    R: TRect;
    cp: TTabSheet;
begin
    // select a tab automatically if we have a right click.
    if Button = mbRight then begin
        {
        pgm: EEK! this is really gross because the pagecontrol sucks.
        Make sure the tab is visible before fetching it's bounding rect,
        and checking the hit test.

        BUT, the pageindex we need is the "raw" tabindex. Apparently,
        the pagecontrol just makes tabs invisible when something gets
        undocked, or somthing equally insane.
        }
        tab := -1;
        v := 0;
        for i := 0 to Tabs.PageCount - 1 do begin
            if (Tabs.Pages[i].TabVisible) then begin
                SendMessage(Tabs.Handle, TCM_GETITEMRECT, v, lParam(@R));
                if PtInRect(R, Point(x, y)) then begin
                    tab := i;
                    break;
                end;
                inc(v);
            end;
        end;

        if (tab = -1) then exit;
        cp := Tabs.Pages[tab];
        if (cp <> Tabs.ActivePage) then
            Tabs.ActivePage := cp;
    end;
end;

{---------------------------------------}
function TfrmExodus.getTabForm(tab: TTabSheet): TForm;
begin
    // Get an associated form for a specific tabsheet
    Result := nil;
    if (tab.ControlCount = 1) then begin
        if (tab.Controls[0] is TForm) then begin
            Result := TForm(tab.Controls[0]);
            exit;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.popCloseTabClick(Sender: TObject);
var
    t: TTabSheet;
    f: TForm;
begin
    // Close the window docked to this tab..
    if Tabs.TabIndex = 0 then exit;
    t := Tabs.ActivePage;
    f := getTabForm(t);
    if (f <> nil) then
        f.Close();
end;

{---------------------------------------}
procedure TfrmExodus.popFloatTabClick(Sender: TObject);
var
    t: TTabSheet;
    f: TForm;
begin
    // Undock this window
    t := Tabs.ActivePage;
    if (t = tbsRoster) then begin
        // Float the msg queue window
        getMsgQueue().Align := alNone;
        getMsgQueue().FloatForm();
        //FloatMsgQueue();
    end
    else begin
        f := getTabForm(t);
        if ((f <> nil) and (f is TfrmDockable)) then
            TfrmDockable(f).FloatForm();
    end;
end;

{---------------------------------------}
procedure TfrmExodus.mnuChatClick(Sender: TObject);
var
    n: TTreeNode;
    ritem: TJabberRosterItem;
    jid: WideString;
begin
    // Start a chat w/ a specific JID
    jid := '';
    if (frmRosterWindow.treeRoster.SelectionCount > 0) then begin
        n := frmRosterWindow.treeRoster.Selected;
        if (TObject(n.Data) is TJabberRosterItem) then begin
            ritem := TJabberRosterItem(n.Data);
            if ritem <> nil then
                jid := ritem.jid.jid
        end;
    end;

    if InputQueryW(sStartChat, sEnterJID, jid) then
        StartChat(jid, '', true);
end;

{---------------------------------------}
procedure TfrmExodus.mnuBookmarkClick(Sender: TObject);
begin
    // Add a new bookmark to our list..
    ShowBookmark('');
end;

{---------------------------------------}
procedure TfrmExodus.presCustomClick(Sender: TObject);
begin
    // Custom presence
    ShowCustomPresence();
end;

{---------------------------------------}
procedure TfrmExodus.presCustomPresClick(Sender: TObject);
var
    i: integer;
    cp: TJabberCustomPres;
begin
    // Our own Custom presence
    i := TMenuItem(Sender).Tag;
    cp := MainSession.prefs.getPresIndex(i);
    if (cp <> nil) then
        MainSession.setPresence(cp.show, cp.status, cp.priority);
end;

{---------------------------------------}
procedure TfrmExodus.trayShowClick(Sender: TObject);
begin
    // Show the application from the popup Menu
    _hidden := false;
    ShowWindow(Handle, SW_RESTORE);
end;

{---------------------------------------}
procedure TfrmExodus.trayExitClick(Sender: TObject);
begin
    // Close the application
    Self.Close;
end;

{---------------------------------------}
procedure TfrmExodus.FormActivate(Sender: TObject);
begin
    // FlashWindow(Self.Handle, false);
    if (frmRosterWindow <> nil) then
        frmRosterWindow.treeRoster.Invalidate();
    StopTrayAlert();
end;

{---------------------------------------}
function TfrmExodus.IsAutoAway(): boolean;
begin
    Result := _is_autoaway;
end;

{---------------------------------------}
function TfrmExodus.IsAutoXA(): boolean;
begin
    Result := _is_autoxa;
end;

{---------------------------------------}
procedure TfrmExodus.WinJabWebsite1Click(Sender: TObject);
begin
    // goto exodus.jabberstudio.org
    ShellExecute(0, 'open', 'http://exodus.jabberstudio.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.JabberBugzilla1Click(Sender: TObject);
begin
    // submit a bug on JS.org
    ShellExecute(0, 'open', 'http://www.jabberstudio.org/projects/exodus/bugs/', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.mnuVersionClick(Sender: TObject);
begin
    // get either version of time request from the jabber server
    if Sender = mnuVersion then
        jabberSendCTCP(MainSession.Server, XMLNS_VERSION)
    else if Sender = mnuTime then
        jabberSendCTCP(MainSession.Server, XMLNS_TIME);
end;

{---------------------------------------}
procedure TfrmExodus.mnuPasswordClick(Sender: TObject);
var
    iq: TJabberIQ;
    f : TfrmPassword;
begin
    {
    // change the password.. send the following XML to do this
    // This only works if we're authenticated
    <iq type='set' to='jabberhostname[e.g., jabber.org]'>
      <query xmlns='jabber:iq:register'>
        <username>username</username>
        <password>newpassword</password>
      </query>
    </iq>
    }

    f := TfrmPassword.Create(self);
    if (f.ShowModal() = mrCancel) then
        exit;

    if (f.txtOldPassword.Text <> MainSession.Password) then begin
        MessageDlg(sPasswordOldError, mtError, [mbOK], 0);
        exit;
    end;
    if (f.txtNewPassword.Text <> f.txtConfirmPassword.Text) then begin
        MessageDlg(sPasswordNewError, mtError, [mbOK], 0);
        exit;
    end;

    iq := TJabberIQ.Create(MainSession, MainSession.generateID, Self.ChangePasswordCallback, 120);
    with iq do begin
        iqType := 'set';
        toJid := MainSession.Server;
        Namespace := XMLNS_REGISTER;
        qTag.AddBasicTag('username', MainSession.Username);
        qTag.AddBasicTag('password', f.txtNewPassword.Text);
    end;
    f.Free();
    iq.Send();
end;

{---------------------------------------}
procedure TfrmExodus.ChangePasswordCallback(event: string; tag: TXMLTag);
begin
    if (event <> 'xml') then
        MessageDlg(sPasswordError, mtError, [mbOK], 0)
    else begin
        if (tag.GetAttribute('type') = 'result') then
            MessageDlg(sPasswordChanged, mtInformation, [mbOK], 0)
        else
            MessageDlg(sPasswordError, mtError, [mbOK], 0);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.AcceptFiles( var msg : TWMDropFiles );
const
  cnMaxFileNameLen = 255;
var
    i,
    nCount     : integer;
    acFileName : array [0..cnMaxFileNameLen] of char;
    p          : TPoint;
    Node       : TTreeNode;
    ri         : TJabberRosterItem;
    f          : TForm;
begin
    // Accept some files being dropped on this form
    // If we are expaned, and not showing the roster tab,
    // and the current tab has a chat window, then
    // call the chat window's AcceptFiles() method.
    if ((MainSession.Prefs.getBool('expanded')) and
        (Tabs.ActivePage <> tbsRoster)) then begin
        f := getTabForm(Tabs.ActivePage);
        if (f is TfrmChat) then begin
            TfrmChat(f).AcceptFiles(msg);
        end;
        exit;
    end;

    // figure out which node was the drop site.
    if (DragQueryPoint(msg.Drop, p) = false) then exit;

    // Translate to screen coordinates, then back to client coordinates
    // for the roster window.  This would have been easier if RosterWindow
    // had worked as the target of DragAcceptFiles.
    p := ClientToScreen(p);
    p := frmRosterWindow.treeRoster.ScreenToClient(p);
    Node := frmRosterWindow.treeRoster.GetNodeAt(p.X, p.Y);
    if ((Node = nil) or (Node.Level = 0)) then exit;

    // get the roster item attached to this node.
    if (Node.Data = nil) then exit;
    if (TObject(Node.Data) is TJabberBookmark) then exit;
    ri := TJabberRosterItem(Node.Data);

    // find out how many files we're accepting
    nCount := DragQueryFile( msg.Drop,
                             $FFFFFFFF,
                             acFileName,
                             cnMaxFileNameLen );

    // query Windows one at a time for the file name
    for i := 0 to nCount-1 do begin
        DragQueryFile( msg.Drop, i,
                       acFileName, cnMaxFileNameLen );
        FileSend(ri.jid.full, acFileName);
    end;

    // let Windows know that we're done
    DragFinish( msg.Drop );
end;

{---------------------------------------}
procedure TfrmExodus.FormDestroy(Sender: TObject);
begin
    //
end;

{---------------------------------------}
procedure TfrmExodus.mnuRegisterServiceClick(Sender: TObject);
var
    tmps: WideString;
    f: TfrmRegister;
begin
    // kick off a service registration..
    tmps := '';
    if (InputQueryW(sRegService, sEnterSvcJID, tmps) = false) then
        exit;

    f := TfrmRegister.Create(Application);
    f.jid := tmps;
    f.Start();
end;

{---------------------------------------}
procedure TfrmExodus.TabsUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin
    // check to see if the tab is a frmDockable
    Allow := true;
    if (Client is TfrmDockable) then begin
        TfrmDockable(Client).Docked := false;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.TabsDockDrop(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer);
begin
    // We got a new form dropped on us.
    if (Source.Control is TfrmDockable) then begin
        TfrmDockable(Source.Control).Docked := true;
        TfrmDockable(Source.Control).TabSheet := Tabs.Pages[Tabs.PageCount - 1];
        _new_tabindex := Tabs.PageCount;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.mnuMessageClick(Sender: TObject);
var
    jid: WideString;
    n: TTreeNode;
    ritem: TJabberRosterItem;
begin
    // Message someone
    jid := '';
    if (frmRosterWindow.treeRoster.SelectionCount > 0) then begin
        n := frmRosterWindow.treeRoster.Selected;
        if (TObject(n.Data) is TJabberRosterItem) then begin
            ritem := TJabberRosterItem(n.Data);
            if ritem <> nil then
                jid := ritem.jid.jid
        end;
    end;

    if InputQueryW(sSendMessage, sEnterJID, jid) then
        StartMsg(jid);
end;

{---------------------------------------}
procedure TfrmExodus.Test1Click(Sender: TObject);
{
var
    i: integer;
}
{
var
    i: integer;
    c: TChatController;
}
begin
    // Test something..
    // LoadPlugin('RosterClean.ExodusRosterClean');

    // Cause an AV
    // PInteger(nil)^ := 0;

    // Show a toast window
    {
    i := Random(2);
    if (i = 0) then
        ShowRiserWindow(Self, 'Test Toast ' + IntToStr(i) + ' Some more text to Some more text to Some more text to Some more text to make toast really long.', i)
    else
        ShowRiserWindow(Self, 'Test Toast ' + IntToStr(i) + ' cvs commit from cvsnotify@jabberstudio.org', i);
    }
    //ShowRiserWindow(Self, 'Test Toast ' + IntToStr(i), i);

    //TrackWindowsMsg(WM_ACTIVATEAPP);
    //TrackWindowsMsg(WM_ACTIVATE);
    {
    TrackWindowsMsg(WM_LBUTTONDOWN);
    TrackWindowsMsg(BM_CLICK);
    TrackWindowsMsg(WM_SETTEXT);
    TrackWindowsMsg(WM_COMMAND);
    }

    {
    for i := MainSession.ChatList.Count - 1 downto 0 do begin
        c := TChatController(MainSession.ChatList.Objects[i]);
        if ((c <> nil) and (c.window is TfrmChat)) then
            c.window.Free();
    end;
    }

    //FileReceive('pgmillard@jabber.org', 'http://exodus.jabberstudio.org/indy_openssl096g.zip', 'SSL Zip Files');
    MainSession.RegisterCallback(BadCallback, '/packet/message/x[@xmlns="exodus:puke"]');
end;

{---------------------------------------}
procedure TfrmExodus.BadCallback(event: string; tag: TXMLTag);
begin
    // Cause an AV
    PInteger(nil)^ := 0;
end;

{---------------------------------------}
procedure TfrmExodus.trayMessageClick(Sender: TObject);
var
    fsel: TfrmSelContact;
    jid : string;
begin
    // Send a msg via the tray menu popup
    fsel := TfrmSelContact.Create(Application);
    fsel.frameTreeRoster1.DrawRoster(true);
    fsel.frameTreeRoster1.treeRoster.MultiSelect := false;

    if (fsel.ShowModal = mrOK) then begin
        jid := fsel.GetSelectedJID();
        if (jid = '') then exit;

        // do the send
        if (MainSession.Prefs.getBool(P_CHAT)) then
            StartChat(jid, '', true)
        else
            StartMsg(jid);

    end;
    fSel.Free();
end;

{---------------------------------------}
procedure TfrmExodus.DefaultHandler(var msg);
var
    m : TMessage;
    status: string;
    show: string;
begin
    // Is this a replacement defualt windows msg handler??
    m := TMessage(msg);
    if (m.Msg = sExodusPresence) then begin
        if (HWND(m.WParam) = Self.Handle) then exit;
        if (not MainSession.Prefs.getBool('presence_message_listen')) then
            exit;
        show := GetPresenceString(m.LParamHi);
        status := GetPresenceString(m.LParamLo);
        // already there.
        if ((MainSession.Show = show) and (MainSession.Status = status)) then exit;
        _is_broadcast := true;
        MainSession.setPresence(show, status, MainSession.Priority);
        _is_broadcast := false;
    end
    else if (m.Msg = sExodusMutex) then begin
        // show the form
        Self.Show;
        ShowWindow(Handle, SW_RESTORE);
        SetForegroundWindow(Self.Handle);
    end
    else if (m.Msg = sShellRestart) then begin
        // the shell was restarted...
        // reshow our tray icons
        setupTrayIcon();
        setTrayInfo(_tray_tip);
        setTrayIcon(_tray_icon_idx);
    end
    else
        inherited;
end;

{---------------------------------------}
procedure TfrmExodus.mnuBrowserClick(Sender: TObject);
begin
    // Show a jabber browser.
    ShowBrowser();
end;

{---------------------------------------}
procedure TfrmExodus.timReconnectTimer(Sender: TObject);
begin
    // try to reconnect...
    inc(_reconnect_cur);
    if (_reconnect_cur >= _reconnect_interval) then begin
        timReconnect.Enabled := false;
        DoConnect();
    end
    else begin
        frmRosterWindow.lblLogin.Caption := sCancelReconnect;
        frmRosterWindow.lblStatus.Caption := sReconnectIn +
            IntToStr(_reconnect_interval - _reconnect_cur) + ' ' + sSeconds;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.ShowEventsWindow1Click(Sender: TObject);
begin
    getMsgQueue.Show();
end;

{---------------------------------------}
procedure TfrmExodus.presToggleClick(Sender: TObject);
begin
    if (MainSession.Show = '') then
        MainSession.setPresence('away', sRosterAway, MainSession.Priority)
    else
        MainSession.setPresence('', sRosterAvail, MainSession.Priority)
end;

{---------------------------------------}
procedure TfrmExodus.ApplicationEvents1Activate(Sender: TObject);
begin
    // do something here maybe
end;

{---------------------------------------}
procedure TfrmExodus.PreModal(frm: TForm);
begin
    // make not on top.
    if (MainSession.Prefs.getBool('window_ontop')) then begin
        SetWindowPos(frmExodus.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE);
        BringWindowToTop(frm.Handle);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.PostModal();
begin
    // make on top if applicable.
    if (MainSession.Prefs.getBool('window_ontop')) then
        SetWindowPos(frmExodus.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE);
end;

{---------------------------------------}
procedure TfrmExodus.ApplicationEvents1Deactivate(Sender: TObject);
begin
    // app was deactivated..
    if (Self.ActiveChat <> nil) then begin
        Self.ActiveChat.HideEmoticons();
        Self.ActiveChat := nil;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.TabsChange(Sender: TObject);
begin
    // Don't show any notification images on the current tab
    if (Tabs.ActivePage.ImageIndex <> -1) then
        Tabs.ActivePage.ImageIndex := -1;
end;

{---------------------------------------}
procedure TfrmExodus.TabsDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
    form: TForm;
    dest_tab: integer;
begin
    // drag if the source is the roster,
    // and the target is a conf room tab
    Accept := false;
    dest_tab := Tabs.IndexOfTabAt(X,Y);
    if (dest_tab > -1) then begin
        form := getTabForm(Tabs.Pages[dest_tab]);
        Accept := ((Source = frmRosterWindow.treeRoster) and
                   ((form is TfrmRoom) or (form is TfrmChat)));
    end;
end;

{---------------------------------------}
procedure TfrmExodus.TabsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
    dest_tab: integer;
    form: TForm;
    sel_contacts: TList;
begin
    // dropping something on a tab.
    dest_tab := Tabs.IndexOfTabAt(X,Y);
    if (dest_tab > -1) then begin
        form := getTabForm(Tabs.Pages[dest_tab]);
        if (form <> nil) then begin
            if ((form is TfrmRoom) and (Source = frmRosterWindow.treeRoster)) then begin
                // fire up an invite for this room using the selected contacts
                sel_contacts := frmRosterWindow.getSelectedContacts(true);
                if (sel_contacts.count > 0) then
                    ShowInvite(TfrmRoom(form).getJid, sel_contacts)
                else
                    MessageDlg(sNoContactsSel, mtError, [mbOK], 0);
                sel_contacts.Free();
            end

            else if ((form is TfrmChat) and (Source = frmRosterWindow.treeRoster)) then begin
                // send roster items to this contact.
                sel_contacts := frmRosterWindow.getSelectedContacts(false);
                if (sel_contacts.count > 0) then
                    jabberSendRosterItems(TfrmChat(form).getJid, sel_contacts)
                else
                    MessageDlg(sNoContactsSel, mtError, [mbOK], 0);
                sel_contacts.Free();
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.timTrayAlertTimer(Sender: TObject);
var
    iconNum : integer;
begin
     _tray_notify := not _tray_notify;
     if (_tray_notify) then begin
        iconNum := _tray_icon_idx + 33;
        if (iconNum > 38) then iconNum := 38;
    end
     else
         iconNum := _tray_icon_idx;

    ImageList2.GetIcon(iconNum, _tray_icon);
    _tray.hIcon := _tray_icon.Handle;
    Shell_NotifyIcon(NIM_MODIFY, @_tray);
end;

{---------------------------------------}
procedure StartTrayAlert();
begin
     frmExodus.timTrayAlert.Enabled := true;
end;

{---------------------------------------}
procedure StopTrayAlert();
begin
     if (frmExodus.timTrayAlert.Enabled) then begin
         frmExodus.timTrayAlert.Enabled := false;
         frmExodus._tray_notify := false;
         frmExodus.setTrayIcon(frmExodus._tray_icon_idx);
     end;
end;

{---------------------------------------}
procedure TfrmExodus.JabberUserGuide1Click(Sender: TObject);
begin
    ShellExecute(0, 'open', pchar(string(MainSession.Prefs.getString('brand_help_userguide'))), '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.mnuPluginDummyClick(Sender: TObject);
begin
    // call the COM Controller
    ExCOMController.fireMenuClick(Sender);
end;

{---------------------------------------}
function TfrmExodus.win32TrackerIndex(windows_msg: integer): integer;
var
    i: integer;
begin
    Result := -1;
    for i := 0 to _win32_idx - 1 do begin
        if (_win32_tracker[i] = windows_msg) then begin
            Result := i;
            break;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.TrackWindowsMsg(windows_msg: integer);
var
    idx: integer;
begin

    if (sExodusCWPHook = 0) then begin
        sExodusCWPHook := SetWindowsHookEx(WH_CALLWNDPROC, @ExodusCWPHook,
            0, GetCurrentThreadID);
        sExodusGMHook := SetWindowsHookEx(WH_GETMESSAGE, @ExodusGMHook,
            0, GetCurrentThreadID);
    end;

    idx := win32TrackerIndex(windows_msg);
    if (idx = -1) then begin
        _win32_tracker[_win32_idx] := windows_msg;
        inc(_win32_idx);
        if (_win32_idx >= Length(_win32_tracker)) then begin
            SetLength(_win32_tracker, _win32_idx + 20);
        end;
    end;

    ApplicationEvents1.Activate();
end;

{---------------------------------------}
procedure TfrmExodus.fireWndMessage(handle: HWND; msg: Cardinal;
    wParam: integer; lParam: integer);
var
    etag: TXMLTag;
begin
    // check to see if this Msg is one we are tracking..
    // and fire the appropriate event if it is.
    etag := TXMLTag.Create('event');
    etag.setAttribute('msg', IntToStr(msg));
    etag.setAttribute('hwnd', IntToStr(Handle));
    etag.setAttribute('lparam', IntToStr(lParam));
    etag.setAttribute('wparam', IntToStr(wParam));
    MainSession.FireEvent('/windows/msg', etag);
end;

{---------------------------------------}
procedure TfrmExodus.ShowBrandURL(Sender: TObject);
var
    i : integer;
    url_list: TWideStringList;
begin
    i := Help1.IndexOf(TMenuItem(Sender));
    if (i < 0) then exit;

    url_list := TWideStringList.Create();
    MainSession.Prefs.fillStringlist('brand_help_url_list', url_list);

    if (i < url_list.Count) then
        ShellExecute(0, 'open',
                     pchar(string(url_list.Strings[i])),
                     '', '', SW_SHOW)
    else
        MessageDlg(sBrandingError, mtWarning, [mbOK], 0);

    url_list.Free();
end;

{---------------------------------------}
function ExodusGMHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
var
    idx: integer;
    msg: TMsg;
begin
    // Something is coming from our WH_GETMESSAGE Hook
    msg := TMsg(Ptr(lParam)^);

    if (frmExodus <> nil) then begin
        idx := frmExodus.win32TrackerIndex(msg.message);
        if (idx >= 0) then
            frmExodus.fireWndMessage(msg.hwnd, msg.message, msg.wParam, msg.lParam);
    end;

    Result := CallNextHookEx(sExodusGMHook, Code, wParam, lParam);
end;

{---------------------------------------}
function ExodusCWPHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
var
    idx: integer;
    cwp: TCWPStruct;
begin
    // Something is coming from CALLWNDPROC Hook
    if ((Code = HC_ACTION) and (frmExodus <> nil)) then begin
        cwp := TCWPStruct(Ptr(lParam)^);
        idx := frmExodus.win32TrackerIndex(cwp.message);
        if (idx >= 0) then
            frmExodus.fireWndMessage(cwp.hwnd, cwp.message, cwp.wParam, cwp.lParam);
    end;

    Result := CallNextHookEx(sExodusCWPHook, Code, wParam, lParam);
end;

{---------------------------------------}
procedure TfrmExodus.FormPaint(Sender: TObject);
begin
    StopTrayAlert();
end;

{---------------------------------------}
function TfrmExodus.isMinimized(): boolean;
begin
    Result := (_hidden) or (Self.Windowstate = wsMinimized);
end;

{---------------------------------------}
procedure TfrmExodus.mnuRegistrationClick(Sender: TObject);
var
    f: TfrmRegister;
begin
    // register with the server..
    f := TfrmRegister.Create(Application);
    f.jid := MainSession.Server;
    f.Start();
end;

procedure TfrmExodus.XMPPActionExecuteMacro(Sender: TObject;
  Msg: TStrings);
var
    c_node: TXMLTag;
    c_jid: TJabberID;
    m: string;
begin
    // Explorer is giving is something about a XMPP file..
    if (Msg.Count = 0) then exit;
    m := Msg[0];
    if (m = 'ignore') then exit;
    if (Pos('open', m) = 1) then begin
        Delete(m, 1, 6);
        Delete(m, Length(m), 1);
        c_node := nil;
        c_jid := nil;
        ParseXMPPFile(m, c_node, c_jid);
        if (MainSession.Active) then
            // ignore c_node, c_jid
            PlayXMPPActions()
        else begin
            // TODO: Handle xmpp connect's via DDE
        end;
    end;
end;

initialization
    sExodusPresence := RegisterWindowMessage('EXODUS_PRESENCE');
    sExodusMutex := RegisterWindowMessage('EXODUS_MESSAGE');
    sShellRestart := RegisterWindowMessage('TaskbarCreated');

end.

