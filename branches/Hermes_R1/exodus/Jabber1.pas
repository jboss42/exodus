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
    ShellAPI, Registry, SelContact, Emote, NodeItem, 

    // Delphi stuff
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ScktComp, StdCtrls, ComCtrls, Menus, ImgList, ExtCtrls,
    Buttons, OleCtrls, AppEvnts, ToolWin,
    IdHttp, TntComCtrls, DdeMan, IdBaseComponent, IdComponent, IdUDPBase,
    IdUDPClient, IdDNSResolver, TntMenus, IdAntiFreezeBase, IdAntiFreeze;

const
    RECONNECT_RETRIES = 3;

    DT_UNKNOWN=0;	    // unknown desktop status
    DT_OPEN=1;	        // the default desktop is active
    DT_LOCKED=2;	    // the winlogon desktop is active, and a user is logged
    DT_NO_LOG=3;	    // the winlogon desktop is active, and no user is logged
    DT_SCREENSAVER=4;	// the screensaver desktop is active
    DT_FULLSCREEN=5;    // Something like PowerPoint is running full screen

    // FROM pbt.h in the win32 SDK
    PBT_APMQUERYSUSPEND = $0000;
    PBT_APMQUERYSTANDBY = $0001;
    PBT_APMQUERYSUSPENDFAILED = $0002;
    PBT_APMQUERYSTANDBYFAILED = $0003;
    PBT_APMSUSPEND = $0004;
    PBT_APMSTANDBY = $0005;
    PBT_APMRESUMECRITICAL = $0006;
    PBT_APMRESUMESUSPEND = $0007;
    PBT_APMRESUMESTANDBY = $0008;
    PBT_APMBATTERYLOW = $0009;
    PBT_APMPOWERSTATUSCHANGE = $000A;
    PBT_APMOEMEVENT = $000B;
    PBTF_APMRESUMEFROMFAILURE = $0000001;

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
    TGetLastInputFunc = function(var lii: tagLASTINPUTINFO): Bool; stdcall;
    TInitHooks = procedure; stdcall;
    TStopHooks = procedure; stdcall;

type
  TfrmExodus = class(TForm)
    Tabs: TTntPageControl;
    tbsRoster: TTntTabSheet;
    pnlRoster: TPanel;
    MainMenu1: TTntMainMenu;
    ImageList2: TImageList;
    SplitterRight: TSplitter;
    timFlasher: TTimer;
    timAutoAway: TTimer;
    popTabs: TTntPopupMenu;
    popTray: TTntPopupMenu;
    pnlRight: TPanel;
    AppEvents: TApplicationEvents;
    Toolbar: TCoolBar;
    ToolBar1: TToolBar;
    btnOnlineRoster: TToolButton;
    btnAddContact: TToolButton;
    btnRoom: TToolButton;
    btnBrowser: TToolButton;
    btnFind: TToolButton;
    timReconnect: TTimer;
    pnlLeft: TPanel;
    SplitterLeft: TSplitter;
    timTrayAlert: TTimer;
    XMPPAction: TDdeServerConv;
    Resolver: TIdDNSResolver;
    Exit2: TTntMenuItem;
    N9: TTntMenuItem;
    mnuPassword: TTntMenuItem;
    mnuRegisterService: TTntMenuItem;
    mnuConference: TTntMenuItem;
    mnuChat: TTntMenuItem;
    mnuMessage: TTntMenuItem;
    N14: TTntMenuItem;
    ClearMessages1: TTntMenuItem;
    View1: TTntMenuItem;
    N7: TTntMenuItem;
    mnuDisconnect: TTntMenuItem;
    Test1: TTntMenuItem;
    Help1: TTntMenuItem;
    Tools1: TTntMenuItem;
    Exodus1: TTntMenuItem;
    ShowEventsWindow1: TTntMenuItem;
    mnuExpanded: TTntMenuItem;
    mnuStatBar: TTntMenuItem;
    mnuToolbar: TTntMenuItem;
    Preferences1: TTntMenuItem;
    N1: TTntMenuItem;
    mnuPlugins: TTntMenuItem;
    ShowXML1: TTntMenuItem;
    mnuServer: TTntMenuItem;
    mnuBrowser: TTntMenuItem;
    mnuBookmark: TTntMenuItem;
    mnuVCard: TTntMenuItem;
    N3: TTntMenuItem;
    mnuMyVCard: TTntMenuItem;
    mnuRegistration: TTntMenuItem;
    N2: TTntMenuItem;
    mnuPresence: TTntMenuItem;
    mnuContacts: TTntMenuItem;
    popFloatTab: TTntMenuItem;
    popCloseTab: TTntMenuItem;
    trayExit: TTntMenuItem;
    N01: TTntMenuItem;
    trayDisconnect: TTntMenuItem;
    N4: TTntMenuItem;
    trayMessage: TTntMenuItem;
    trayPresence: TTntMenuItem;
    trayShow: TTntMenuItem;
    mnuServerVCard: TTntMenuItem;
    mnuTime: TTntMenuItem;
    mnuVersion: TTntMenuItem;
    About1: TTntMenuItem;
    N12: TTntMenuItem;
    SubscribetoPresence2: TTntMenuItem;
    N8: TTntMenuItem;
    NewGroup2: TTntMenuItem;
    mnuOnline: TTntMenuItem;
    mnuSearch: TTntMenuItem;
    mnuFindAgain: TTntMenuItem;
    mnuFind: TTntMenuItem;
    N10: TTntMenuItem;
    Properties2: TTntMenuItem;
    MessageHistory2: TTntMenuItem;
    RemovePerson1: TTntMenuItem;
    AddPerson1: TTntMenuItem;
    presToggle: TTntMenuItem;
    Custom3: TTntMenuItem;
    N11: TTntMenuItem;
    presDND: TTntMenuItem;
    presXA: TTntMenuItem;
    presAway: TTntMenuItem;
    presChat: TTntMenuItem;
    presOnline: TTntMenuItem;
    Custom2: TTntMenuItem;
    N5: TTntMenuItem;
    trayPresDND: TTntMenuItem;
    trayPresXA: TTntMenuItem;
    trayPresAway: TTntMenuItem;
    trayPresChat: TTntMenuItem;
    trayPresOnline: TTntMenuItem;
    IdAntiFreeze1: TIdAntiFreeze;
    mnuPluginOpts: TTntMenuItem;
    N15: TTntMenuItem;
    bigImages: TImageList;

    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOnlineRosterClick(Sender: TObject);
    procedure btnAddContactClick(Sender: TObject);
    procedure mnuConferenceClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
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
    procedure mnuSearchClick(Sender: TObject);
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
    procedure AppEventsActivate(Sender: TObject);
    procedure AppEventsDeactivate(Sender: TObject);
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
    procedure mnuFindClick(Sender: TObject);
    procedure mnuFindAgainClick(Sender: TObject);
    procedure presDNDClick(Sender: TObject);
    procedure ResolverStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure mnuPluginOptsClick(Sender: TObject);
    procedure mnuDisconnectClick(Sender: TObject);

  private
    { Private declarations }
    _noMoveCheck: boolean;              // don't check form moves
    _tray_notify: boolean;              // boolean for flashing tray icon
    _edge_snap: integer;                // edge snap fuzziness
    _auto_login: boolean;
    _expanded: boolean;                 // are we expanded or not?
    _docked_forms: TList;               // list of all of the docked forms

    // Various state flags
    _windows_ver: integer;
    _is_broadcast: boolean;             // Should this copy broadcast pres changes
    _hidden: boolean;                   // are we minimized to the tray
    _was_max: boolean;                  // was the main window maximized before?
    _logoff: boolean;                   // are we logging off on purpose
    _shutdown: boolean;                 // are we being shutdown
    _cleanupComplete : boolean;        //all close events have fired and app is ready to terminate
    _close_min: boolean;                // should the close btn minimize, not close
    _appclosing: boolean;               // is the entire app closing
    _new_tabindex: integer;             // new tab which was just docked
    _new_account: boolean;              // is this a new account
    _pending_passwd: Widestring;

    // Stuff for the Autoaway
    _idle_hooks: THandle;               // handle the lib
    _GetLastTick: TGetLastTick;         // function ptrs inside the lib
    _InitHooks: TInitHooks;
    _StopHooks: TStopHooks;
    _valid_aa: boolean;                 // do we have a valid auto-away setup?
    _GetLastInput: TGetLastInputFunc;
    _is_autoaway: boolean;              // Are we currently auto-away
    _is_autoxa: boolean;                // Are we currently auto-xa

    _auto_away_interval: integer;       //# of seconds between checks when moving from availabel state
    _last_show: Widestring;             // last show for restoring after auto-away
    _last_status: Widestring;           // last status    (ditto)
    _last_priority: integer;            // last priority  (ditto)

    // Tray Icon stuff
    _tray: NOTIFYICONDATA;
    _tray_tip: string;
    _tray_icon_idx: integer;
    _tray_icon: TIcon;

    // Some callbacks
    _sessioncb: integer;
    _rostercb: integer;
    _dns_cb: integer;

    // Reconnect variables
    _reconnect_interval: integer;
    _reconnect_cur: integer;
    _reconnect_tries: integer;

    // Stuff for tracking win32 API events
    _win32_tracker: Array of integer;
    _win32_idx: integer;

    _currRosterPanel: TPanel; //what panel is roster being rendered in
    
    procedure setupReconnect();
    procedure setupTrayIcon();
    procedure setTrayInfo(tip: string);
    procedure setTrayIcon(iconNum: integer);
    procedure SetAutoAway();
    procedure SetAutoXA();
    procedure SetAutoAvailable();
    procedure SetupAutoAwayTimer();

    function win32TrackerIndex(windows_msg: integer): integer;

    procedure _sendInitPresence();
    {**
     *  Cleanup objects, registered callbacks etc. Prepare for shutdown
     **}
    procedure cleanup();

    {**
     *  Busywait until cleanupmethod is complete by checking _cleanupComplete flag
    **}
    procedure waitForCleanup();

  protected
    // Hooks for the keyboard and the mouse
    _hook_keyboard: HHOOK;
    _hook_mouse: HHOOK;

    // Window message handlers
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSysCommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
    procedure WMSize(var msg: TMessage); message WM_SIZE;
    procedure WMWindowPosChanging(var msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WMTray(var msg: TMessage); message WM_TRAY;
    procedure WMQueryEndSession(var msg: TMessage); message WM_QUERYENDSESSION;
    //procedure WMEndSession(var msg: TMessage); message WM_ENDSESSION;
    procedure WMShowLogin(var msg: TMessage); message WM_SHOWLOGIN;
    procedure WMCloseApp(var msg: TMessage); message WM_CLOSEAPP;
    procedure WMReconnect(var msg: TMessage); message WM_RECONNECT;
    procedure WMInstaller(var msg: TMessage); message WM_INSTALLER;
    procedure WMDisconnect(var msg: TMessage); message WM_DISCONNECT;
    procedure WMDisplayChange(var msg: TMessage); message WM_DISPLAYCHANGE;
    procedure WMPowerChange(var msg: TMessage); message WM_POWERBROADCAST;

    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;

    function WMAppBar(dwMessage: DWORD; var pData: TAppBarData): UINT; stdcall;

  published
    // Callbacks
    procedure DNSCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure RosterCallback(event: string; tag: TXMLTag; ri: TJabberRosterItem);
    procedure ChangePasswordCallback(event: string; tag: TXMLTag);

    // This is only used for testing..
    procedure BadCallback(event: string; tag: TXMLTag);

    procedure restoreToolbar;
    procedure restoreAlpha;
    procedure restoreMenus(enable: boolean);
    procedure restoreRoster();
    procedure setupExpanded(newval: boolean);

  public
    ActiveChat: TfrmBaseChat;

    function getLastTick(): dword;
    function screenStatus(): integer;
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

    procedure Flash();
    procedure doRestore();

    procedure PreModal(frm: TForm);
    procedure PostModal();

    procedure CloseDocked(frm: TForm);

    {**
     *  Get the panel the roster is being rendered in.
    **}
    function getCurrentRosterPanel() : TPanel;
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

const
    sXMPP_Profile = '-*- Temp profile: %s -*-';
{*
    sExodus = 'Exodus';
*}
    //sChat = 'Chat';

    sCommError = 'There was an error during communication with the Jabber Server';
    sDisconnected = 'You have been disconnected.';
    sAuthError = 'There was an error trying to authenticate you.'#13#10'Either you used the wrong password, or this account is already in use by someone else.';
    sRegError = 'An Error occurred trying to register your new account. This server may not allow open registration.';
    sAuthNoAccount = 'This account does not exist on this server. Create a new account?';
    sNewAccount = 'Your new jabber account is activated. Would you like to fill out additional registration information?';
    sNoContactsSel = 'You must select one or more contacts.';

    sSetAutoAvailable = 'Setting Auto Available';
    sSetAutoAway = 'Setting AutoAway';
    sSetAutoXA = 'Setting AutoXA';
    sSetupAutoAway = 'Trying to setup the Auto Away timer.';
    sAutoAwayFail = 'AutoAway Setup FAILED!';
    sAutoAwayWin32 = 'Using Win32 API for Autoaway checks!!';
    sAutoAwayFailWin32 = 'ERROR GETTING WIN32 API ADDR FOR GetLastInputInfo!!';

    sMsgContacts = 'Contacts from ';

    sLookupProfile = 'Lookup Profile';
    sSendMessage = 'Send a Message';
    sStartChat = 'Start Chat';
    sRegService = 'Register with Service';

    sJID = 'Jabber ID';
    sEnterJID = 'Enter Jabber ID: ';
    sEnterSvcJID = 'Enter Jabber ID of Service: ';

    sPasswordError = 'Error changing password.';
    sPasswordChanged = 'Password changed.';
    sPasswordCaption = 'Password';
    sPasswordPrompt = 'Enter Password';

    sBrandingError = 'Branding error!';
    sQueryTypeError = 'Unknown query type: ';
    sUserExistsErr = ''#13#10' ERROR: The username ''%s'' already exists.';

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
    ico_grpfolder = 26;
    ico_down = 27;
    ico_right = 28;
    ico_blocked = 39;
    ico_blockoffline = 41;
    ico_error = 32;

    ico_online_minus_one = 44;
    ico_away_minus_one = 45;
    ico_dnd_minus_one = 46;
    ico_chat_minus_one = 47;
    ico_xa_minus_one = 48;
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses

    // XXX: ZipMstr

    RosterImages,
    ExodusImageList,
    COMToolbar, COMToolbarButton,
    NewUser, CommandWizard, Exodus_TLB, Notify,
    About, AutoUpdate, AutoUpdateStatus, Bookmark, Browser, Chat,
    ChatController, ChatWin, Debug, Dockable, DNSUtils, Entity,
    EntityCache, ExSession, JabberUtils, ExUtils,
    InputPassword, Invite, GnuGetText,
    Iq, JUD, JabberID, JabberMsg, IdGlobal, LocalUtils,
    JabberConst, ComController, CommCtrl, CustomPres,
    JoinRoom, MsgController, MsgDisplay, MsgQueue, MsgRecv, Password,
    PrefController, Prefs, PrefNotify, Profile, RegForm, RemoveContact, RiserWindow, Room,
    XferManager, Stringprep, SSLWarn,
    Roster, RosterAdd, Session, StandardAuth, StrUtils, Subscribe, Unicode, VCard, xData,
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
procedure TfrmExodus.Flash();
begin
    // flash window
    if (_hidden) then begin
        Self.WindowState := wsMinimized;
        //Self.Visible := true;
        ShowWindow(Handle, SW_SHOWMINNOACTIVE);
    end;

    if MainSession.Prefs.getBool('notify_flasher') then begin
        timFlasher.Enabled := true;
    end
    else begin
        timFlasher.Enabled := false;
        timFlasherTimer(Self);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.doRestore();
begin
    if (_hidden) then begin
        Self.WindowState := wsNormal;
        Self.Visible := true;
        if (_was_max) then
            ShowWindow(Handle, SW_MAXIMIZE)
        else
            ShowWindow(Handle, SW_RESTORE);
        _hidden := false;
    end
    else if (Self.WindowState = wsMaximized) then begin
        ShowWindow(Handle, SW_RESTORE);
        _was_max := false;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.WMSize(var msg: TMessage);
begin
    // Windows-M and "Show Desktop" use this to hide all windows
    if ((msg.WParam = SIZE_MINIMIZED) and (not _hidden)) then begin
        _hidden := true;
        _was_max := (Self.WindowState = wsMaximized);
        msg.Result := 0;
    end
    else if ((msg.WParam = SIZE_RESTORED) and (_hidden)) then begin
        doRestore();
        msg.Result := 0;
    end
    else
        inherited;
end;

{---------------------------------------}
procedure TfrmExodus.WMDisplayChange(var msg: TMessage);
begin
    checkAndCenterForm(Self);
end;

{---------------------------------------}
procedure TfrmExodus.WMPowerChange(var msg: TMessage);
begin
    // APM event
    case msg.wParam of
    PBT_APMQUERYSUSPEND, PBT_APMQUERYSTANDBY: begin
        // system wants to be suspended
        DebugMsg('Got a PBT_APMQUERYSUSPEND. Logging off');
        MainSession.Prefs.SaveProfiles();
        MainSession.Prefs.SaveServerPrefs();
        if (MainSession.Active) then begin
            _logoff := true;
            PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
            _auto_login := true;
        end;
        msg.Result := 1;
        exit;
        end;
    PBT_APMSUSPEND, PBT_APMSTANDBY: begin
        // disconnect
        DebugMsg('Got a PBT_APMSUSPEND.');
        msg.Result := 1;
        end;
    PBT_APMRESUMECRITICAL, PBT_APMRESUMESUSPEND, PBT_APMRESUMESTANDBY: begin
        // connect
        DebugMsg('Got a PBT_RESUME*.');
        _logoff := false;
        _reconnect_tries := 0;
        if (_auto_login) then begin
            _auto_login := false;
            setupReconnect();
        end;
        msg.Result := 1;
        end;
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
        _was_max := (Self.WindowState = wsMaximized);
        ShowWindow(Handle, SW_HIDE);
        msg.Result := 0;
    end;
    SC_RESTORE: begin
        doRestore();
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
            doRestore();
            SetForegroundWindow(Self.Handle);
            msg.Result := 0;
        end
        else begin
            // minimize our app
            _hidden := true;
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
    end

    else if (Msg.LParam = WM_MOUSEMOVE) then begin
        DebugMsg('Move');
    end

    else if (Msg.LParam = WM_MOUSELAST) then begin
        DebugMsg('Out');
    end

    else begin
        DebugMsg('other');
    end;

end;

{---------------------------------------}
procedure TfrmExodus.WMQueryEndSession(var msg: TMessage);
begin
    _shutdown := true;
    inherited; //will eventually fire FormQueryClose event
    //busywait until app has a chance to cleanup
    waitForCleanup();
    msg.Result := 1;
end;

{---------------------------------------}
procedure TfrmExodus.WMShowLogin(var msg: TMessage);
begin
    // Show the login window
    _reconnect_tries := 0;
    _new_account := false;
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
begin
    // We are getting a Windows Msg from the installer
    if (not _shutdown) then begin
        reg := TRegistry.Create();
        reg.RootKey := HKEY_CURRENT_USER;
        reg.OpenKey('\Software\Jabber\' + getAppInfo().ID + '\Restart\' + IntToStr(Application.Handle), true);

        reg.WriteString('cmdline', '"' + ParamStr(0) +
                        '" -c "' + MainSession.Prefs.Filename + '"');
        GetDir(0, cmd);
        reg.WriteString('cwd', cmd);

        reg.CloseKey();
        reg.Free();

        _shutdown := true;
        Self.Close;
        waitForCleanup();
    end;
end;

{---------------------------------------}
procedure TfrmExodus.WMDisconnect(var msg: TMessage);
begin
    MainSession.Disconnect();
end;


{---------------------------------------}
{---------------------------------------}
procedure TfrmExodus.FormCreate(Sender: TObject);
var
    win_ver: string;
    menu_list: TWideStringList;
    i : integer;
    mi: TMenuItem;
    s: TXMLTag;
begin
    Randomize();
    ActiveChat := nil;
    _docked_forms := TList.Create;
    _new_tabindex := -1;
    _auto_login := false;

    // Do translation magic
    AssignUnicodeFont(Self);
    TranslateComponent(Self);

    // setup our tray icon
    _tray_icon := TIcon.Create();

    // setup our master image list
    RosterTreeImages.setImageList(Imagelist2);

    // if we are testing auto-away, then fire the
    // timer every 1 second, instead of every 10 secs.
    if (ExStartup.testaa) then
        _auto_away_interval := 1
    else
        _auto_away_interval := 10;
    timAutoAway.Interval := _auto_away_interval * 1000;

    // show the test menu if cmd line args say so.
    Test1.Visible := ExStartup.test_menu;

    // Init our emoticons
    InitializeEmoticonLists();

    // Setup our caption and the help menus.
    with MainSession.Prefs do begin
        self.Caption := GetString('brand_caption');
        trayShow.Caption := _('Show ') + getAppInfo.ID;
        trayExit.Caption := _('Exit ') + getAppInfo.ID;
        Exodus1.Caption := getAppInfo.ID;
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
    end;

    // Setup our session callback
    _sessioncb := MainSession.RegisterCallback(SessionCallback, '/session');
    _rostercb := MainSession.RegisterCallback(RosterCallback, '/roster/end');

    // setup some branding stuff
    with (MainSession.Prefs) do begin
        mnuConference.Visible := getBool('brand_muc');
        if (not mnuConference.Visible) then
            mnuConference.ShortCut := 0;
        btnRoom.Visible := getBool('brand_muc');

        mnuPlugins.Visible := getBool('brand_plugs');
        mnuVCard.Visible := getBool('brand_vcard');
        mnuMyVCard.Visible := getBool('brand_vcard');
        mnuRegistration.Visible := getBool('brand_registration');

        mnuBrowser.Visible := getBool('brand_browser');
        if (not mnuBrowser.Visible) then
            mnuBrowser.ShortCut := 0;
    end;

    // Make sure presence menus have unified captions
    setRosterMenuCaptions(presOnline, presChat, presAway, presXA, presDND);
    setRosterMenuCaptions(trayPresOnline, trayPresChat, trayPresAway,
        trayPresXA, trayPresDND);

    // Setup the Tabs, toolbar, panel, and roster madness
    Tabs.ActivePage := tbsRoster;
    restoreMenus(false);
    restoreToolbar();
    pnlRight.Visible := MainSession.Prefs.getBool('expanded');
    Tabs.MultiLine := MainSession.Prefs.getBool('stacked_tabs');
    restoreRoster();

    // some gui related flags
    _appclosing := false;
    _noMoveCheck := true;
    _noMoveCheck := false;
    _tray_notify := false;
    _reconnect_tries := 0;
    _hidden := false;
    _shutdown := false;
    _cleanupComplete := false;
    _close_min := MainSession.prefs.getBool('close_min');

    // Setup the IdleUI stuff..
    _is_autoaway := false;
    _is_autoxa := false;
    _is_broadcast := false;
    _windows_ver := WindowsVersion(win_ver);

    // Setup various callbacks, timers, etc.
    setupAutoAwayTimer();
    s := TXMLTag.Create('startup');
    Self.SessionCallback('/session/prefs', s);
    s.Free();

    Self.setupTrayIcon();

    // If we are supposed to be hidden, make it so.
    if (ExStartup.minimized) then begin
        Self.Visible := false;
        _hidden := true;
        Self.WindowState := wsMinimized;
        ShowWindow(Self.Handle, SW_HIDE);
        SendMessage(Self.Handle, WM_SYSCOMMAND, SC_MINIMIZE , 0);
    end
    else
        Self.Visible := true;

    // Show the debug form, if they've asked for it.
    if (ExStartup.debug) then ShowDebugForm();

    // If we are in expanded mode, make sure the roster is the active page.
    if Tabs.Visible then
        Tabs.ActivePage := tbsRoster;

    // Set our default presence info.
    MainSession.setPresence(ExStartup.show, ExStartup.Status, ExStartup.Priority);

    // Init our win32 msg tracker.
    SetLength(_win32_tracker, 20);
    _win32_idx := 0;
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
        strPCopy(szTip, getAppInfo().Caption);
        cbSize := SizeOf(_tray);
    end;
    Shell_NotifyIcon(NIM_ADD, @_tray);
    picon.Free();
end;

{---------------------------------------}
procedure TfrmExodus.Startup;
begin
    // load up all the plugins..
    if (MainSession.Prefs.getBool('brand_plugs')) then
        InitPlugins();

    // If they had logging turned on, warn them that they need to
    // enable a logging plugin now.
    if (MainSession.Prefs.getBool('log') and (ExCOMController.ContactLogger = nil)) then begin
        MainSession.Prefs.setBool('log', false);
        MessageDlgW(_('Message logging is now performed by plugins. Please enable a logging plugin to regain this functionality.'),
            mtWarning, [mbOK], 0);
    end;

    // Create and dock the MsgQueue if we're in expanded mode
    if (MainSession.Prefs.getBool('expanded')) then begin
        _expanded := true;
        getMsgQueue();
        frmMsgQueue.ManualDock(Self.pnlRight, nil, alClient);
        frmMsgQueue.Align := alClient;
        frmMsgQueue.Show;
    end
    else
        _expanded := false;

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
    rip: string;
    req_srv, req_a: string;
    pw : WideString;
begin
    // Make sure that the active profile
    // has the password field filled out.
    // If not, pop up the password prompt,
    // otherwise, just call connect.

    // NB: For non-std auth agents, set prompt_password
    // accordingly.
    //make sure we have an auth agent
    //JJF not sure why we have to check password before auth attempt. Shouldn't
    //the PW be checked by auth anyway and user prompted at that time???
    MainSession.checkAuthAgent();
    if ((not MainSession.Profile.WinLogin) and
        (MainSession.password = '') and
        ((MainSession.getAuthAgent() = nil) or (MainSession.getAuthAgent().prompt_password))) then begin
        pw := '';
        if ((not InputQueryW(_(sPasswordCaption), _(sPasswordPrompt), pw, True)) or
            (pw = '')) then
            begin
                frmRosterWindow.ToggleGUI(gui_disconnected);
                exit;
            end;
        MainSession.Password := pw;

        // resave this password if we're supposed to
        if (MainSession.Profile.SavePasswd) then begin
            MainSession.Profile.password := pw;
            MainSession.Prefs.SaveProfiles();
        end;
    end;
    MainSession.FireEvent('/session/connecting', nil);

    with MainSession.Profile do begin
        // These are fall-thru defaults..
        if (Host <> '') then
            ResolvedIP := Host
        else
            ResolvedIP := Server;
        ResolvedPort := Port;

        // If we should, do SRV lookups
        if (srv) then begin
            _dns_cb := MainSession.RegisterCallback(DNSCallback, '/session/dns');
            req_srv := '_xmpp-client._tcp.' + Server;
            req_a := Server;
            rip := '';

            DebugMsg('Looking up SRV: ' + req_srv);
            GetSRVAsync(MainSession, Resolver, req_srv, req_a);
        end
        else begin
            DebugMsg('Using specified Host/Port: ' + Host + '  ' + IntToStr(Port));
            MainSession.Connect();
        end;
    end;

end;

{---------------------------------------}
procedure TfrmExodus.DNSCallback(event: string; tag: TXMLTag);
var
    t, ip: string;
    p: Word;
begin
    // process the async DNS request
    MainSession.UnRegisterCallback(_dns_cb);
    _dns_cb := -1;
    t := tag.getAttribute('type');
    if (t = 'failed') then with MainSession.Profile do begin
        // stringprep here for idn's
        ResolvedIP := xmpp_nameprep(Server);
        if (ssl = ssl_port) then
            ResolvedPort := 5223
        else
            ResolvedPort := 5222;

        DebugMsg('Direct DNS failed.. Using server: ' + Server);
        MainSession.Connect();
        exit;
    end;

    // get the bits off the packet
    ip := Trim(tag.getAttribute('ip'));
    p := StrToIntDef(tag.getAttribute('port'), 0);

    with MainSession.Profile do begin
        if (ip <> '') then
            ResolvedIP := ip
        else
            ResolvedIP := Server;

        if (p > 0) then
            ResolvedPort := p
        else
            ResolvedPort := 5222;

        if ((ResolvedPort = 5222) and (ssl = ssl_port)) then
            ResolvedPort := 5223;

        if (p > 0) then
            DebugMsg('Got SRV: ' + ResolvedIP + '  ' + IntToStr(ResolvedPort))
        else
            DebugMsg('Got A: ' + ResolvedIP + '  ' + IntToStr(ResolvedPort));
    end;

    if (not MainSession.Active) then MainSession.Connect();
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

    // we don't care about DNS lookups anymore
    if (_dns_cb <> -1) then begin
        MainSession.UnRegisterCallback(_dns_cb);
        _dns_cb := -1;
        CancelDNS();
        MainSession.FireEvent('/session/disconnected', nil);
    end
    else if (MainSession.Active) then
        MainSession.Disconnect()
    else
        timReconnect.Enabled := false;
end;

{---------------------------------------}
procedure TfrmExodus.SessionCallback(event: string; tag: TXMLTag);
var
    ssl, rtries, code: integer;
    msg : TMessage;
    exp: boolean;
    tmp: TXMLTag;
    fp, m: Widestring;
    fps: TWidestringlist;
begin
    // session related events
    if event = '/session/connected' then begin
        timReconnect.Enabled := false;
        _logoff := false;
        _reconnect_tries := 0;
        setTrayIcon(1);
    end

    else if event = '/session/error/auth' then begin
        _logoff := true;
        MainSession.Profile.password := '';
        MessageDlgW(_(sAuthError), mtError, [mbOK], 0);

        // when the new user wizard is being used, NoAuth is set.
        if (not MainSession.NoAuth) then begin
            PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
            PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
        end;
        exit;
    end

    else if (event = '/session/error/tls') then begin
        MessageDlgW(_('There was an error trying to setup SSL.'), mtError,
            [mbOK], 0);
        _logoff := true;
        PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
        PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
    end

    else if ((event = '/session/error/ssl') and (tag <> nil)) then begin
        fp := tag.getAttribute('fingerprint');

        // check for an allowed cert.
        fps := TWidestringlist.Create();
        MainSession.Prefs.fillStringlist('allow-certs', fps);
        if (fps.IndexOf(fp) >= 0) then begin
            fps.Free();
            exit;
        end;

        ssl := ShowSSLWarn(tag.Data(), fp);
        if (ssl = sslAllowAlways) then begin
            // save this cert in prefs
            fps.Add(fp);
            MainSession.Prefs.setStringlist('allow-certs', fps);
        end
        else if (ssl = sslReject) then begin
            // kick the connection off
            _logoff := true;
            PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
            PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
        end;
        fps.Free();
    end

    else if event = '/session/compressionerrror' then begin
        if tag <> nil then
            DebugMsg(tag.xml);
        MessageDlgW(_('There was an error trying to setup compression.'), mtError,
            [mbOK], 0);
        _logoff := true;
        PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
        PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
    end

    else if event = '/session/error/reg' then begin
        _logoff := true;

        m := _(sRegError);
        if (tag <> nil) then begin
            // try to find out a more detailed error message
            tmp := tag.GetFirstTag('error');
            if (tmp <> nil) then begin
                code := StrToIntDef(tmp.GetAttribute('code'), 0);
                if (code = 409) then
                    m := m + WideFormat(_(sUserExistsErr), [MainSession.Profile.Username])
                else
                    m := m + ''#13#10' ERROR: ' + tmp.Data;
            end;
        end;

        MessageDlgW(m, mtError, [mbOK], 0);
        PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
        exit;
    end

    else if event = '/session/error/noaccount' then begin
        if (MessageDlgW(_(sAuthNoAccount), mtConfirmation, [mbYes, mbNo], 0) = mrNo) then begin
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
        Self.Caption := MainSession.Prefs.getString('brand_caption') + ' - ' + MainSession.Profile.getJabberID().getDisplayJID();
        setTrayInfo(Self.Caption);

        // Accept files dragged from Explorer
        // Only do this for normal (non-polling) connections
        if (MainSession.Profile.ConnectionType = conn_normal) then
            DragAcceptFiles(Handle, True);

        // 1. Fetch the roster
        // 2. Discover our server stuff..
        // 3. Make the roster the active tab
        // 4. Activate the menus
        // 5. turn on the auto-away timer
        // 6. check for new brand.xml file
        // 7. check for new version
        Roster.Fetch;
        jEntityCache.fetch(MainSession.Server, MainSession);
        Tabs.ActivePage := tbsRoster;
        restoreMenus(true);
        if (_valid_aa) then timAutoAway.Enabled := true;
        InitUpdateBranding();
        InitAutoUpdate();

        // if we have a new account, prompt for reg info
        if (_new_account) then begin
            if (MessageDlgW(_(sNewAccount), mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
                mnuRegistrationClick(Self);
            end;
            _new_account := false;
        end;

        // Play any pending XMPP actions
        PlayXMPPActions();
    end

    else if (event = '/session/disconnected') then begin
        // Make sure windows knows we don't want files
        // dropped on us anymore.
        if (MainSession.Profile.ConnectionType = conn_normal) then
            DragAcceptFiles(Handle, False);

        timAutoAway.Enabled := false;
        CloseSubscribeWindows();

        Self.Caption := getAppInfo().Caption;
        setTrayInfo(Self.Caption);
        setTrayIcon(0);

        _new_account := false;
        restoreMenus(false);
        //if disconnect happened because of a close request, post a message
        //so close can continue *after* every other listener has a chance
        //to respond to session disconnect event.
        if (_appclosing) then
            PostMessage(Self.Handle, WM_CLOSEAPP, 0, 0)
        else if (not _logoff) then with timReconnect do begin
            if ((_is_autoaway) or (_is_autoxa)) then
                // keep _last_* the same.. do nothing
            else begin
                _last_show := MainSession.Show;
                _last_status := MainSession.Status;
                _last_priority := MainSession.Priority;
            end;

            inc(_reconnect_tries);

            rtries := MainSession.Prefs.getInt('recon_tries');
            if (rtries < 0) then rtries := 3;

            if (_reconnect_tries < rtries) then begin
                setupReconnect();
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

    else if event = '/session/error/stream' then begin
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

        // reset the tray icon stuff
        Shell_NotifyIcon(NIM_DELETE, @_tray);
        Self.setupTrayIcon();
        setTrayInfo(_tray_tip);
        setTrayIcon(_tray_icon_idx);

        // do gui stuff
        restoreMenus(MainSession.Active);
        restoreToolbar();
        restoreAlpha();

        exp := MainSession.Prefs.getBool('expanded');
        tbsRoster.TabVisible := exp;
        if ((_expanded <> exp) and (tag = nil)) then begin
            _expanded := exp;
            setupExpanded(_expanded);
        end
        else
            restoreRoster();
        Tabs.MultiLine := MainSession.Prefs.getBool('stacked_tabs')
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

        // don't send message on autoaway
        if (_is_autoaway or _is_autoxa) then exit;
        
        //don't send message if auto-return
        if (_is_broadcast) then exit;
        
        // Send a windows msg so other copies of Exodus will change their
        // status to match ours.
        if (not MainSession.Prefs.getBool('presence_message_send')) then exit;
        msg.LParamHi := GetPresenceAtom(MainSession.Show);
        msg.LParamLo := GetPresenceAtom(MainSession.Status);
        PostMessage(HWND_BROADCAST, sExodusPresence, self.Handle, msg.LParam);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.RosterCallback(event: string; tag: TXMLTag; ri: TJabberRosterItem);
begin
    _sendInitPresence();
end;

{---------------------------------------}
procedure TfrmExodus._sendInitPresence();
begin
    // set our presence now that we have our roster

    // Don't broadcast our initial presence
    _is_broadcast := true;
    if (_is_autoxa) then
        setAutoXA()
    else if (_is_autoaway) then
        setAutoAway()
    else if (_last_show <> '') then
        MainSession.setPresence(_last_show, _last_status, _last_priority)
    else
        MainSession.setPresence(MainSession.Show, MainSession.Status, MainSession.Priority);
    _is_broadcast := false;

end;

{---------------------------------------}
procedure TfrmExodus.setupReconnect();
var
    rint: integer;
begin
    // Setup a reconnect timer
    rint := MainSession.Prefs.getInt('recon_time');
    if (rint <= 0) then
        _reconnect_interval := Trunc(Random(20)) + 2
    else
        _reconnect_interval := rint;

    // Make sure the timer is set to 1 second incs.
    timReconnect.Interval := 1000;
    DebugMsg('Setting reconnect timer to: ' + IntToStr(_reconnect_interval));

    _reconnect_cur := 0;
    frmRosterWindow.aniWait.Visible := false;
    PostMessage(Self.Handle, WM_RECONNECT, 0, 0);
end;

{---------------------------------------}
procedure TfrmExodus.restoreToolbar;
begin
    // setup the toolbar based on prefs
    with MainSession.Prefs do begin
        mnuExpanded.Checked := getBool('expanded');

        btnOnlineRoster.Down := getBool('roster_only_online');
        mnuOnline.Checked := btnOnlineRoster.Down;
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
begin
    // (dis)enable the menus
    mnuDisconnect.Enabled := enable;
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
    trayDisconnect.Enabled := enable;

    // Enable toolbar btns
    btnOnlineRoster.Enabled := enable;
    btnAddContact.Enabled := enable;
    btnRoom.Enabled := enable;
    btnFind.Enabled := enable;
    btnBrowser.Enabled := enable;

    // Build the custom presence menus.
    if (enable) then begin
        BuildPresMenus(mnuPresence, presOnlineClick);
        BuildPresMenus(trayPresence, presOnlineClick);
    end;
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

{**
 *  Cleanup objects, registered callbacks etc. Prepare for shutdown
**}
procedure TfrmExodus.cleanup();
begin
    //mainsession should never be nil here. It is created before this object
    //and only destroyed on ExSession finalization.
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

    // Close the roster window
    if (frmRosterWindow <> nil) then begin
        frmRosterWindow.ClearNodes();
        frmRosterWindow.Close;
    end;

    // Close whatever rooms we have
    CloseAllRooms();
    CloseDebugForm();
    CloseAllChats();

    // Unload all of the remaining plugins
    UnloadPlugins();

    // Unregister callbacks, etc.
    MainSession.UnRegisterCallback(_sessioncb);
    MainSession.Prefs.SavePosition(Self);

    // Clear our master icon list
    RosterTreeImages.Clear();

    // Kill the tray icon stuff
    if (_tray_icon <> nil) then
        FreeAndNil(_tray_icon);

    if (_docked_forms <> nil) then
        FreeAndNil(_docked_forms);

    Shell_NotifyIcon(NIM_DELETE, @_tray);

    _cleanupComplete := true;
end;

{**
 *  Busywait until cleanupmethod is complete by checking _cleanupComplete flag
**}
procedure TfrmExodus.waitForCleanup();
begin
    repeat
        Application.ProcessMessages();
    until (_cleanupComplete);
end;

{---------------------------------------}
{**
 *  Expect this method to be called twice when connected.
 *  once for the initial close request, once when Close is called
 *  in the WMCLoseApp message handler, which is posted by session/disconnect
 *  event.
**}
procedure TfrmExodus.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    //mainsession should never be nil here, it is created before this object
    //and destroyed in ExSession finalization

    // If we are not already disconnected, then
    // disconnect. Once we successfully disconnect,
    // we'll close the form properly (xref _appclosing)
    if (MainSession.Active) and (not _appclosing)then begin
        _appclosing := true;
        _logoff := true;
        MainSession.Disconnect();
        CanClose := false;
    end
    else
        cleanup();
end;

procedure TfrmExodus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
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
    if (timFlasher.Enabled) then
        timFlasher.Enabled := false;
end;

{---------------------------------------}
procedure TfrmExodus.Preferences1Click(Sender: TObject);
begin
    // Show the prefs
    StartPrefs();
end;

{---------------------------------------}
procedure TfrmExodus.setupExpanded(newval: boolean);
var
    delta, w: longint;
begin
    mnuExpanded.Checked := newval;

    // this is how much we're changing
    if ((pnlLeft.Visible) and (pnlLeft.Width > 0)) then
        delta := Self.ClientWidth - pnlLeft.Width + SplitterLeft.Width
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
    if (event_w <= 0) then event_w := Self.ClientWidth div 2;
    if (roster_w <= 0) then begin
        event_w := 2 * (Self.ClientWidth div 3);
        roster_w := Self.ClientWidth - event_w;
    end;

    // make sure the roster is docked in the appropriate place.
    messenger := MainSession.Prefs.getBool('roster_messenger');
    expanded := MainSession.Prefs.getBool('expanded');
    if (messenger) then begin
        if ((frmRosterWindow <> nil) and (not frmRosterWindow.inMessenger)) then
            frmRosterWindow.DockRoster();

        // setup panels for the roster
        pnlRoster.Visible := true;
        _currRosterPanel := pnlRoster;
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
        _currRosterPanel := pnlLeft;
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
            if (frmMsgQueue.lstEvents.Items.Count > 0) then begin
                frmMsgQueue.Align := alNone;
                frmMsgQueue.FloatForm;
            end
            else
                frmMsgQueue.Close;
        end;

        // pgm: 7/20/03 - This sucks, but apparently, the TNT Page control
        // doesn't track DockClients and things correctly. Thus, lets
        // track our docked windows directly. *sigh*
        {
        while (Tabs.DockClientCount > 0) do begin
            docked := TfrmDockable(Tabs.DockClients[0]);
            docked.FloatForm;
        end;
        }

        // make sure we undock all of the tabs..
        for i := _docked_forms.Count - 1 downto 0 do begin
            docked := TfrmDockable(_docked_forms[i]);
            docked.FloatForm();
        end;
        _docked_forms.Clear();

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
    FlashWindow(Self.Handle, true);
end;

{---------------------------------------}
procedure TfrmExodus.JabberorgWebsite1Click(Sender: TObject);
begin
    // goto www.jabber.org
    ShellExecute(Application.Handle, 'open', 'http://www.jabber.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.JabberCentralWebsite1Click(Sender: TObject);
begin
    // goto www.jabberstudio.org
    ShellExecute(Application.Handle, 'open', 'http://www.jabberstudio.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.SubmitExodusFeatureRequest1Click(Sender: TObject);
begin
    // goto http://www.jabberstudio.org/projects/exodus/features/add.php
    ShellExecute(Application.Handle, 'open', 'http://www.jabberstudio.org', '', '', SW_SHOW);

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
    stat, show: Widestring;
    cp: TJabberCustomPres;
    mi: TMenuItem;
    pri: integer;
begin
    // change our own presence
    mi := TMenuItem(sender);
    case mi.GroupIndex of
    0: show := '';
    1: show := 'away';
    2: show := 'xa';
    3: show := 'dnd';
    4: show := 'chat';
    end;
    stat := mi.Caption;
    pri := MainSession.Priority;
    if (mi.Tag >= 0) then begin
        cp := MainSession.Prefs.getPresIndex(mi.Tag);
        if (cp <> nil) then begin
            if (cp.Priority <> -1) then pri := cp.Priority;
            stat := cp.Status;
        end;
    end;
    MainSession.setPresence(show, stat, pri);
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
    go: TJabberGroup;
    x: TXMLTag;
begin
    // Add a roster grp.
    go := promptNewGroup();
    if (go = nil) then exit;

    with frmRosterWindow do begin
        RenderGroup(go);
        treeRoster.AlphaSort(true);
    end;
    x := TXMLTag.Create('group');
    x.setAttribute('name', go.FullName);

    // XXX: is this event right for new groups?
    MainSession.FireEvent('/roster/group', x, TJabberRosterItem(nil));
    x.Free();

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
    if InputQueryW(_(sLookupProfile), _(sEnterJID), jid) then
        ShowProfile(jid);
end;

{---------------------------------------}
procedure TfrmExodus.mnuSearchClick(Sender: TObject);
begin
    // Start a default search
    StartSearch(jEntityCache.getFirstSearch());
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
    tjid: TJabberID;
begin
    // Start a chat w/ a specific JID
    jid := '';
    if (frmRosterWindow.treeRoster.SelectionCount > 0) then begin
        n := frmRosterWindow.treeRoster.Selected;
        if (TObject(n.Data) is TJabberRosterItem) then begin
            ritem := TJabberRosterItem(n.Data);
            if ritem <> nil then
            begin
                jid := ritem.jid.getDisplayJID();
            end;
        end;
    end;

    if InputQueryW(_(sStartChat), _(sEnterJID), jid) then
    begin
        tjid := TJabberID.Create(jid, false);
        jid := tjid.jid();
        tjid.Free();
        StartChat(jid, '', true);
    end;
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
procedure TfrmExodus.trayShowClick(Sender: TObject);
begin
    // Show the application from the popup Menu
    doRestore();
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
    if (timFlasher.Enabled) then
        timFlasher.Enabled := false;

    if (frmRosterWindow <> nil) then
        frmRosterWindow.treeRoster.Invalidate();
    StopTrayAlert();
end;


{---------------------------------------}
procedure TfrmExodus.WinJabWebsite1Click(Sender: TObject);
begin
    // goto exodus.jabberstudio.org
    ShellExecute(Application.Handle, 'open', 'http://exodus.jabberstudio.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.JabberBugzilla1Click(Sender: TObject);
begin
    // submit a bug on JS.org
    ShellExecute(Application.Handle, 'open', 'http://www.jabberstudio.org/projects/exodus/bugs/', '', '', SW_SHOW);
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

    iq := TJabberIQ.Create(MainSession, MainSession.generateID, Self.ChangePasswordCallback, 120);
    with iq do begin
        iqType := 'set';
        toJid := MainSession.Server;
        Namespace := XMLNS_REGISTER;
        qTag.AddBasicTag('username', MainSession.Username);
        qTag.AddBasicTag('password', f.txtNewPassword.Text);
        _pending_passwd := f.txtNewPassword.Text;
    end;
    f.Free();
    iq.Send();
end;

{---------------------------------------}
procedure TfrmExodus.ChangePasswordCallback(event: string; tag: TXMLTag);
begin
    if (event <> 'xml') then
        MessageDlgW(_(sPasswordError), mtError, [mbOK], 0)
    else begin
        if (tag.GetAttribute('type') = 'result') then begin
            MessageDlgW(_(sPasswordChanged), mtInformation, [mbOK], 0);
            MainSession.Profile.password := _pending_passwd;
            MainSession.Prefs.SaveProfiles();
        end
        else
            MessageDlgW(_(sPasswordError), mtError, [mbOK], 0);
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
    j          : TJabberID;
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
    if (Node.Data = nil) then
        exit
    else if (TObject(Node.Data) is TJabberRosteritem) then begin
        ri := TJabberRosterItem(Node.Data);
        if (not ri.IsContact) then exit;
        j := ri.jid;

        // find out how many files we're accepting
        nCount := DragQueryFile( msg.Drop,
                                 $FFFFFFFF,
                                 acFileName,
                                 cnMaxFileNameLen );

        // query Windows one at a time for the file name
        for i := 0 to nCount-1 do begin
            DragQueryFile( msg.Drop, i,
                           acFileName, cnMaxFileNameLen );
            FileSend(j.full, acFileName);
        end;

        // let Windows know that we're done
        DragFinish( msg.Drop );
    end;
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
begin
    // kick off a service registration..
    tmps := '';
    if (InputQueryW(_(sRegService), _(sEnterSvcJID), tmps) = false) then
        exit;
    StartServiceReg(tmps);
end;

{---------------------------------------}
procedure TfrmExodus.TabsUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin
    // check to see if the tab is a frmDockable
    Allow := true;
    if (Client is TForm) then
        CloseDocked(TForm(Client));
end;

{---------------------------------------}
procedure TfrmExodus.CloseDocked(frm: TForm);
var
    idx: integer;
begin
    if (frm is TfrmDockable) then begin
        TfrmDockable(frm).Docked := false;
        TfrmDockable(frm).TabSheet := nil;
        idx := _docked_forms.IndexOf(TfrmDockable(frm));
        if (idx >= 0) then
            _docked_forms.Delete(idx);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.TabsDockDrop(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer);
begin
    // We got a new form dropped on us.
    if (Source.Control is TfrmDockable) then begin
        TfrmDockable(Source.Control).Docked := true;
        TfrmDockable(Source.Control).TabSheet := TTntTabSheet(Tabs.Pages[Tabs.PageCount - 1]);
        _new_tabindex := Tabs.PageCount;
        _docked_forms.Add(TfrmDockable(Source.Control));
    end;
end;

{---------------------------------------}
procedure TfrmExodus.mnuMessageClick(Sender: TObject);
var
    jid: WideString;
    n: TTreeNode;
    ritem: TJabberRosterItem;
    tjid: TJabberID;
begin
    // Message someone
    jid := '';
    if (frmRosterWindow.treeRoster.SelectionCount > 0) then begin
        n := frmRosterWindow.treeRoster.Selected;
        if (TObject(n.Data) is TJabberRosterItem) then begin
            ritem := TJabberRosterItem(n.Data);
            if ritem <> nil then
            begin
                jid := ritem.jid.getDisplayJID()
            end;
        end;
    end;

    if InputQueryW(_(sSendMessage), _(sEnterJID), jid) then
    begin
        tjid := TJabberID.Create(jid, false);
        jid := tjid.jid();
        tjid.Free();
        StartMsg(jid);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.Test1Click(Sender: TObject);
//var
    {
    i: IExodusController;
    btn: IExodusToolbarButton;
    }
    // btn: TToolButton;

    {
    h: integer;
    i: IExodusController;
    f, o, m, x: TXMLTag;
    }
    //i: integer;
    //z: TZipMaster;
    //go: TJabberGroup;
    //x: TXMLTag;
begin
    {
    i := ExCOMController as IExodusController;
    btn := i.Toolbar.addButton('contact');
    btn.Tooltip := 'Some tooltip';
    }

    {
    btn := TToolButton.Create(Self);
    btn.Parent := ToolBar1;
    btn.Left := ToolBar1.Buttons[ToolBar1.ButtonCount - 1].Left +
        ToolBar1.Buttons[ToolBar1.ButtonCount - 1].Width + 1;
    btn.ImageIndex := 10;
    }

    {
    go := MainSession.Roster.addGroup('aaaa');
    go.SortPriority := 900;
    go.KeepEmpty := true;
    go.ShowPresence := false;

    x := TXMLTag.Create('group');
    x.setAttribute('name', go.FullName);
    MainSession.FireEvent('/roster/group', x, TJabberRosterItem(nil));
    x.Free();

    go := MainSession.Roster.addGroup('bbbb');
    go.SortPriority := 900;
    go.KeepEmpty := true;
    go.ShowPresence := false;

    x := TXMLTag.Create('group');
    x.setAttribute('name', go.FullName);
    MainSession.FireEvent('/roster/group', x, TJabberRosterItem(nil));
    x.Free();
    }

    // ShowNewUserWizard();
    {
    z := TZipMaster.Create(nil);
    i := z.Load_Unz_Dll();
    ShowMessage(IntToStr(i));

    i := z.Load_Zip_Dll();
    ShowMessage(IntToStr(i));

    z.ZipFileName := 'd:\temp\jisp\emoticons\Ninja.jisp';
    i := z.Extract();
    ShowMessage(IntToStr(i));

    i := z.List();
    ShowMessage(IntToStr(i));
    }

    //
    //ShowMessage(BoolToStr(IsUnicodeEnabled()));
    {
    Application.CreateForm(TfrmTest1, frmTest1);
    frmTest1.ShowDefault();
    }
    {
    i := ExComController as IExodusController;
    h := i.CreateDockableWindow('foo');
    ShowMessage(IntToStr(h));
    }

    // Do some xdata tests
    {
    m := TXMLTag.Create('message');
    x := m.AddTag('x');
    x.setAttribute('xmlns', 'jabber:x:data');
    x.setAttribute('type', 'form');

    // just a simple edit field
    f := x.addTag('field');
    f.setAttribute('type',  'text');
    f.setAttribute('var',   'field1');
    f.setAttribute('label', 'field 1');
    f.AddBasicTag('value', 'Some basic text');

    // list-single
    f := x.addTag('field');
    f.setAttribute('type',  'list-single');
    f.setAttribute('var',   'single');
    f.setAttribute('label', 'A');
    f.AddBasicTag('value', '2');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 1');
    o.AddBasicTag('value', '1');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 2');
    o.AddBasicTag('value', '2');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 3');
    o.AddBasicTag('value', '3');

    // list-multi
    f := x.addTag('field');
    f.setAttribute('type',  'list-multi');
    f.setAttribute('var',   'B');
    f.setAttribute('label', 'Some choices');
    f.AddBasicTag('value', '1');
    f.AddBasicTag('value', '2');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 1');
    o.AddBasicTag('value', '1');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 2');
    o.AddBasicTag('value', '2');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 3');
    o.AddBasicTag('value', '3');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 4');
    o.AddBasicTag('value', '4');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 5');
    o.AddBasicTag('value', '5');

    // boolean
    f := x.addTag('field');
    f.setAttribute('type',  'boolean');
    f.setAttribute('var',   'C');
    f.setAttribute('label', 'Some really really really really really really really really long boolean');
    f.AddBasicTag('value', 'YES');

    // a bunch of fixed fields
    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.AddBasicTag('value', '111 This is some longish fixed label. Blah, blah, blah, blah, blah, blah.');

    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.addBasicTag('value', '222 A label with a url like http://www.yahoo.com voo blah.');

    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.addBasicTag('value', '333 A label with a url like http://www.yahoo.com blahlkjad;lasdlkasdlkasd;lksa;dlkasd;lkas;as;asa;ldakdalkda;ldka;kdasdla;kk.');

    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.addBasicTag('value', '444 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789.');

    f := x.AddTag('field');
    f.setAttribute('var', 'jidA');
    f.setAttribute('label', 'Select a Jid');
    f.setAttribute('type', 'jid-single');
    f.AddBasicTag('value', 'foo@bar.com');

    f := x.AddTag('field');
    f.setAttribute('var', 'jidB');
    f.setAttribute('label', 'Select several jids');
    f.setAttribute('type', 'jid-multi');
    f.AddBasicTag('value', 'a@bar.com');
    f.AddBasicTag('value', 'b@baz.com');
    f.AddBasicTag('value', 'c@thud.com');

    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.addBasicTag('value', '555 foo bar 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789.');

    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.addBasicTag('value', '666 foo bar'#13#10' sdkfjls'#13#10'kjdflksjdf;ljsf;'#13#10'klsjf;lkjsafkjsaldfj;lasjfd;klsajd;kljasdjf;ajdf;ljsfd;kjasdf;jas;fkja;df;ljaslfkj;asdf;klasdfklasdfj;ajdf;ljsf;ksafd;kjadsf;jkasdjfs;lf;lsdf');

    ShowXData(m);
    }
    
end;

{---------------------------------------}
procedure TfrmExodus.BadCallback(event: string; tag: TXMLTag);
begin
    // Cause an AV for testing
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
    fsel.frameTreeRoster1.DrawRoster(true, false);
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
        doRestore();
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
        frmRosterWindow.updateReconnect(_reconnect_interval - _reconnect_cur);
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
        MainSession.setPresence('away', _('Away'), MainSession.Priority)
    else
        MainSession.setPresence('', _('Available'), MainSession.Priority)
end;

{---------------------------------------}
procedure TfrmExodus.AppEventsActivate(Sender: TObject);
begin
    // do something here maybe
    if (timFlasher.Enabled) then
        timFlasher.Enabled := false;
    StopTrayAlert();        
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
procedure TfrmExodus.AppEventsDeactivate(Sender: TObject);
begin
    // app was deactivated..
    if (Self.ActiveChat <> nil) then begin
        Self.ActiveChat.HideEmoticons();
        Self.ActiveChat := nil;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.TabsChange(Sender: TObject);
var
    f: TForm;
begin
    // Don't show any notification images on the current tab
    if (Tabs.ActivePage = nil) then exit;

    f := getTabForm(Tabs.ActivePage);

    if (f is TfrmChat) then begin
        if (Tabs.ActivePage.ImageIndex = tab_notify) then
            Tabs.ActivePage.ImageIndex := TfrmChat(f).LastImage
    end
    else if (f is TfrmRoom) then begin
        Tabs.ActivePage.ImageIndex := RosterTreeImages.Find('conference');
    end
    else if ((Tabs.ActivePage = tbsRoster) and
        (tbsRoster.ImageIndex <> RosterTreeImages.Find('multiple'))) then
        tbsRoster.ImageIndex := RosterTreeImages.Find('multiple')
    else if (f is TfrmDockable) then
        Tabs.ActivePage.ImageIndex := TfrmDockable(f).ImageIndex;

    if (f is TfrmBaseChat) then begin
        if (TfrmBaseChat(f).MsgOut.Visible and TfrmBaseChat(f).MsgOut.Enabled) then
            TfrmBaseChat(f).MsgOut.SetFocus;
    end;
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
                    MessageDlgW(_(sNoContactsSel), mtError, [mbOK], 0);
                sel_contacts.Free();
            end

            else if ((form is TfrmChat) and (Source = frmRosterWindow.treeRoster)) then begin
                // send roster items to this contact.
                sel_contacts := frmRosterWindow.getSelectedContacts(false);
                if (sel_contacts.count > 0) then
                    jabberSendRosterItems(TfrmChat(form).getJid, sel_contacts)
                else
                    MessageDlgW(_(sNoContactsSel), mtError, [mbOK], 0);
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
    if (frmExodus = nil) then exit;

    if (frmExodus.timTrayAlert.Enabled) then begin
        frmExodus.timTrayAlert.Enabled := false;
        frmExodus._tray_notify := false;
        frmExodus.setTrayIcon(frmExodus._tray_icon_idx);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.JabberUserGuide1Click(Sender: TObject);
begin
    ShellExecute(Application.Handle, 'open', pchar(string(MainSession.Prefs.getString('brand_help_userguide'))), '', '', SW_SHOW);
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

    AppEvents.Activate();
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
        ShellExecute(Application.Handle, 'open',
                     pchar(string(url_list.Strings[i])),
                     '', '', SW_SHOW)
    else
        MessageDlgW(_(sBrandingError), mtWarning, [mbOK], 0);

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
//    StopTrayAlert();
end;

{---------------------------------------}
function TfrmExodus.isMinimized(): boolean;
begin
    Result := (_hidden) or (Self.Windowstate = wsMinimized);
end;

{---------------------------------------}
procedure TfrmExodus.mnuRegistrationClick(Sender: TObject);
begin
    // register with the server..
    StartServiceReg(MainSession.Server);
end;

{---------------------------------------}
procedure TfrmExodus.XMPPActionExecuteMacro(Sender: TObject;
  Msg: TStrings);
var
    c_node: TXMLTag;
    c_jid: TJabberID;
    m: string;
begin
    // Explorer is giving is something about a XMPP file..
    if (Msg.Count = 0) then exit;
    m := Lowercase(Msg[0]);
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
    end
    else if (Pos('uri', m) = 1) then begin
        m := Msg[0];
        Delete(m, 1, 5);
        if LeftStr(m, 1) = '''' then begin
            Delete(m, 1, 1);
        end;

        if RightStr(m, 1) = '''' then begin
            Delete(m, Length(m), 1);
        end;

        ParseURI(m, c_node, c_jid);
        if (MainSession.Active) then
            PlayXMPPActions()
        else begin
            // TODO: Handle xmpp connect's via DDE
        end;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.mnuFindClick(Sender: TObject);
begin
    frmRosterWindow.StartFind();
end;

{---------------------------------------}
procedure TfrmExodus.mnuFindAgainClick(Sender: TObject);
begin
    frmRosterWindow.FindAgain();
end;

{---------------------------------------}
procedure TfrmExodus.presDNDClick(Sender: TObject);
var
    m: TTntMenuItem;
    show: Widestring;
begin
    m := TTntMenuItem(Sender);
    if (m.Count > 0) then exit;

    case m.Tag of
    0: show := '';
    1: show := 'chat';
    2: show := 'away';
    3: show := 'xa';
    4: show := 'dnd';
    end;
    MainSession.setPresence(show, '', MainSession.Priority);

end;

{---------------------------------------}
procedure TfrmExodus.CMMouseEnter(var msg: TMessage);
begin
    //
end;

{---------------------------------------}
procedure TfrmExodus.CMMouseLeave(var msg: TMessage);
begin
    //
end;

{---------------------------------------}
procedure TfrmExodus.ResolverStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
    // DNS status
    DebugMsg('DNS Lookup status: ' + AStatusText);
end;

{---------------------------------------}
procedure TfrmExodus.mnuPluginOptsClick(Sender: TObject);
begin
    // Show the prefs/plugins page.
    StartPrefs(pref_plugins);
end;

{---------------------------------------}
procedure TfrmExodus.mnuDisconnectClick(Sender: TObject);
begin
    if MainSession.Active then begin
        _logoff := true;
        CloseAllRooms();
        CloseAllChats();
        MainSession.Disconnect();
    end
end;

{******************************************************************************
 ***************************** Auto Away **************************************
 *****************************************************************************}

{---------------------------------------}
procedure TfrmExodus.setupAutoAwayTimer();
var
    lii: TLastInputInfo;
begin
    // Setup the auto-away timer
    // Note that for W2k and XP, we are just going to
    // use the special API calls for getting inactivity.
    // For other OS's we need to use the wicked nasty DLL
    _valid_aa := false;
    DebugMsg(_(sSetupAutoAway));
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
            _InitHooks();
            _valid_aa := true;
        end
        else
            DebugMsg(_(sAutoAwayFail));
    end
    else begin
        // Use the GetLastInputInfo API call
        // Use GetProcAddress so we can still run on Win95/98/ME/NT which
        // don't have this function. If we just make the call, we end up
        // depending on that API call.
        @_GetLastInput := nil;
        @_GetLastInput := GetProcAddress(GetModuleHandle('user32'), 'GetLastInputInfo');
        if (@_GetLastInput <> nil) then begin
            lii.cbSize := sizeof(tagLASTINPUTINFO);
            if (_GetLastInput(lii)) then begin
                DebugMsg(_(sAutoAwayWin32));
                _valid_aa := true;
            end;
        end;
        if (not _valid_aa) then
            DebugMsg(_(sAutoAwayFailWin32));
    end;
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
function TfrmExodus.getLastTick(): dword;
var
    lii: TLastInputInfo;
begin
    // Return the last tick count of activity
    Result := 0;
    //if not (2k or xp)
    if ((_windows_ver < cWIN_2000) or (_windows_ver = cWIN_ME)) then begin
        //use idl dll
        if ((_idle_hooks <> 0) and (@_GetLastTick <> nil)) then
            Result := _GetLastTick();
    end
    else begin
        // use GetLastInputInfo
        lii.cbSize := sizeof(tagLASTINPUTINFO);
        if (_GetLastInput(lii)) then
            Result := lii.dwTime;
    end;
end;

function TfrmExodus.screenStatus(): integer;
var
    desk: HDESK;
    name: string;
    len: dword;
    hw: HWINSTA;
    w,d: HWND;
    wSize: TRect;
    mon: TMonitor;
begin
    if ((_windows_ver < cWIN_NT) or (_windows_ver = cWIN_ME)) then begin
        result := DT_UNKNOWN;
        exit;
    end;

    desk := OpenInputDesktop(0, False, MAXIMUM_ALLOWED);
    if desk = 0 then begin
        result := DT_LOCKED;
        exit;
    end;

    GetUserObjectInformation(desk, UOI_NAME, PChar(name), 0, len);
    SetLength(name, len + 1);
    if not GetUserObjectInformation(desk, UOI_NAME, PChar(name), len, len) then begin
        CloseDesktop(desk);
        result := DT_UNKNOWN;
        exit;
    end;
    CloseDesktop(desk);
    // there's a null on the end.  Not sure why this worked before the -1.
    SetLength(name, len-1);
    if name = 'Default' then begin  // NO I18N!
        // what about fullscreen mode, like PowerPoint shows?
        w := GetForegroundWindow();
        d := FindWindow('Progman', nil);
        if (w <> d) then begin
            // Got a window and it is NOT the program manager (desktop).
            Windows.GetClientRect(w, wSize);
            mon := Screen.MonitorFromWindow(w, mdNearest);
            if((mon.BoundsRect.Left = wSize.Left) and
               (mon.BoundsRect.Right = wSize.Right) and
               (mon.BoundsRect.Top = wSize.Top) and
               (mon.BoundsRect.Bottom = wSize.Bottom)) then begin
               result := DT_FULLSCREEN;
               exit;
            end;
        end;
        result := DT_OPEN;
        exit;
    end;
    if name = 'Screen-saver' then begin
        result := DT_SCREENSAVER;
        exit;
    end;

    if name = 'Winlogon' then begin
		hw := OpenWindowStation('winsta0', False, WINSTA_ENUMERATE or WINSTA_ENUMDESKTOPS);
		GetUserObjectInformation(hw, UOI_USER_SID, Nil, 0, len);
		CloseWindowStation(hw);

		// if no user is assosiated with winsta0, then no user is
		// is logged on:
		if len = 0 then
			// no one is logged on:
			result := DT_NO_LOG
		else
			// the station is locked
			result := DT_LOCKED;
        exit;
    end;
    result := DT_UNKNOWN;
end;
{---------------------------------------}
{**
 * Autoaway timer OnTimer event.

    Auto-away mad-ness......

    Get the current idle time, and based on that, "do the right thing".

    Note that we don't want to set a-away if we're already
    away, XA, or DND.

    getLasTick() uses either the idleHooks.dll or the appropriate
    API call if they are available (w2k and xp) to get the last
    tick count which had activity.

 * Will fire once every 10 seconds when the user is authenticated and available
 * Fires once every seconds when user is authenticated and not available.
**}
procedure TfrmExodus.timAutoAwayTimer(Sender: TObject);
var
    away, xa, dis: dword; //prefs defining elapsed minute triggers
//    dmsg: string;
    do_xa, do_dis: boolean;
    avail: boolean;
    _last_tick, cur_idle, mins: dword;      // last user input
    _auto_away: boolean;                // perform auto-away ops
    ss : integer;
begin
    //if we are not connected bail
    if (MainSession = nil) then exit;
    if (not MainSession.Active) then exit;

    with MainSession.Prefs do begin
        _auto_away := getBool('auto_away');
        //get autoway prefs
        away := getInt('away_time');
        xa := getInt('xa_time');
        dis := getInt('disconnect_time');
        do_xa := getBool('auto_xa');
        do_dis := getBool('auto_disconnect');
    end;
    //_autoAway is set when prefs are updatecd
    //if auto_away is enabled
    if ((_auto_away)) then begin
        ss := screenStatus();
        //if screen is locked, screensaver or full screen app the autoaway
        if ss > DT_OPEN then begin
            //if not already autoaway, make it so
            if not _is_autoaway then begin
                SetAutoAway();
            end;
            exit;
        end;
        //otherwise check to see if auto away should be triggered
        _last_tick := getLastTick();
        if (_last_tick = 0) then begin
            exit; //might return 0 if library setup failed
        end;
        //get number of seconds since last activity
        cur_idle := Windows.GetTickCount();
        cur_idle := (cur_idle - _last_tick);
        cur_idle := cur_idle div 1000;
        //if we are testing auto-away (via the -a command line) then
        //make mins = to seconds (to speed things up), otherwise determine
        //number of minutes since last input
        //if testing autoaway via the -a command line param, dump debug stmts
        if (ExStartup.testaa) then begin
            mins := cur_idle;
//            if (not _is_autoaway) and (not _is_autoxa) then begin
//                dmsg := 'Idle Check: ' + SafeBoolStr(_is_autoaway) + ', ' +
//                    SafeBoolStr(_is_autoxa) + ', ' +
//                    IntToStr(cur_idle ) + ' secs'#13#10;
//                DebugMsg(dmsg);
//            end;
        end
        else begin
            mins := cur_idle div 60
        end;
        //are we in an availabel show state?
        avail := (MainSession.Show <> 'dnd') and (MainSession.Show <> 'xa') and
            (MainSession.Show <> 'away');
        //if we had activity within the last minute and are currently
        //auto'd away, send available
        if ((mins = 0) and ((_is_autoaway) or (_is_autoxa))) then begin
            // we are available again
            SetAutoAvailable()
        //if we have auto-discnnect enabled and last input > disconnect time
        //and we are auto-etended away (hmm, thats seems wrong, you can have
        //auto-disconnect without auto-extaway, but must have auto-away
        end
        else if ((do_dis) and (mins >= dis) and (_is_autoxa)) then begin
            // Disconnect us
            _logoff := true;
            PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
        end
        // if auto-xa'd just exit, only state we could move to is
        //available or disconnect handled above
        else if (_is_autoxa) then begin
            exit
        end
        //if auto-away and auto-xa is enabled and idle time > xa time, go XA
        else if ((do_xa) and (mins >= xa) and (_is_autoaway)) then begin
            SetAutoXA()
        end
        //if available and auto-away enabled and idle time > away time, go away
        else if ((mins >= away) and (not _is_autoaway) and (avail)) then begin
            // We are avail, need to be away
            SetAutoAway();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.SetAutoAway;
var
    new_pri: integer;
begin
    // set us to away
    DebugMsg(_(sSetAutoAway));
    Application.ProcessMessages;
    MainSession.Pause();
    if ((MainSession.Show = 'away') or
        (MainSession.Show = 'xa') or
        (MainSession.Show = 'dnd')) then begin
        exit;
    end;

    _last_show := MainSession.Show;
    _last_status := MainSession.Status;
    _last_priority := MainSession.Priority;
    // must be before SetPresence
    _is_autoaway := true;

    // If we aren't doing auto-xa, then just set the flag now.
    if (not MainSession.Prefs.getBool('auto_xa')) then
        _is_autoxa := true
    else
        _is_autoxa := false;

    if MainSession.Prefs.getBool('aa_reduce_pri') then
        new_pri := 0
    else
        new_pri := _last_priority;

    MainSession.SetPresence('away', MainSession.prefs.getString('away_status'),
        new_pri);

    timAutoAway.Interval := 1000;
//    DebugMsg('SetAutoAway values:  _last_show: ' + _last_show + ' _last_status: ' + _last_status +
//             ' _last_priority: ' + IntToStr(_last_priority) + ' _is_autoaway: ' + BoolToStr(_is_autoaway) + ' _is_autoxa: ' +
//             BoolToStr(_is_autoxa) + ' new_pri: ' + IntToStr(new_pri));
end;

{---------------------------------------}
procedure TfrmExodus.SetAutoXA;
begin
    // set us to xa
    DebugMsg(_(sSetAutoXA));

    // must be before SetPresence
    _is_autoaway := false;
    _is_autoxa := true;

    MainSession.SetPresence('xa', MainSession.prefs.getString('xa_status'),
        MainSession.Priority);

    if (timAutoAway.Interval > 1000) then
        timAutoAway.Interval := 1000;

//    DebugMsg('SetAutoXA values:  _last_show: ' + _last_show + ' _last_status: ' + _last_status +
//             ' _last_priority: ' + IntToStr(_last_priority) + ' _is_autoaway: ' + BoolToStr(_is_autoaway) + ' _is_autoxa: ' +
//             BoolToStr(_is_autoxa));
end;

{---------------------------------------}
procedure TfrmExodus.SetAutoAvailable;
begin
    // reset our status to available
    DebugMsg(_(sSetAutoAvailable));
    timAutoAway.Enabled := false;
    timAutoAway.Interval := _auto_away_interval * 1000;
    MainSession.SetPresence(_last_show, _last_status, _last_priority);
    // must be *after* SetPresence
    _is_autoaway := false;
    _is_autoxa := false;

    if (_valid_aa) then begin
        timAutoAway.Enabled := true;
    end;
    MainSession.Play();
end;

{**
*  Get the panel the roster is being rendered in.
**}
function TfrmExodus.getCurrentRosterPanel() : TPanel;
begin
    Result := _currRosterPanel;
end;

initialization
    //JJF 5/5/06 not sure if registering for EXODUS_ messages will cause
    //problems for branded clients
    //(for instance when Exodus and brand are both running). Ask Joe H.
    //Joe H answered it is desirable for all Exodus based clients to  share presence
    sExodusPresence := RegisterWindowMessage('EXODUS_PRESENCE');
    sExodusMutex := RegisterWindowMessage('EXODUS_MESSAGE');
    sShellRestart := RegisterWindowMessage('TaskbarCreated');
end.

