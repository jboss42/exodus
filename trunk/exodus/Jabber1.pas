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
    GUIFactory, Register, Notify, S10n,
    ExResponders, ExEvents,
    RosterWindow, Presence, XMLTag,
    ShellAPI, Registry,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ScktComp, StdCtrls, ComCtrls, Menus, ImgList, ExtCtrls,
    Buttons, OleCtrls, AppEvnts, ToolWin, SelContact;

const
    UpdateKey = '001';

    WM_TRAY = WM_USER + 5269;
    WM_PREFS = WM_USER + 5272;
    WM_SHOWLOGIN = WM_USER + 5273;
    WM_CLOSEAPP = WM_USER + 5274;

type
    TNextEventType = (next_none, next_Exit, next_Login, next_Disconnect);

    THookRec = packed record
        InstanceCount: integer;
        KeyHook: HHOOK;
        MouseHook: HHOOK;
        LastTick: longint;
        end;
    PHookRec = ^THookRec;

    TGetHookPointer = function: pointer; stdcall;
    TInitHooks = procedure; stdcall;
    TStopHooks = procedure; stdcall;

type
  TfrmExodus = class(TForm)
    Tabs: TPageControl;
    tbsRoster: TTabSheet;
    pnlRoster: TPanel;
    MainMenu1: TMainMenu;
    WInJab1: TMenuItem;
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
    JabberorgWebsite1: TMenuItem;
    N12: TMenuItem;
    WinJabWebsite1: TMenuItem;
    ShowXML1: TMenuItem;
    SearchforPerson1: TMenuItem;
    JabberBugzilla1: TMenuItem;
    mnuPassword: TMenuItem;
    N6: TMenuItem;
    N14: TMenuItem;
    NewGroup2: TMenuItem;
    mnuFilters: TMenuItem;
    Test1: TMenuItem;
    PGPTools1: TMenuItem;
    mnuBrowser: TMenuItem;
    mnuServer: TMenuItem;
    mnuVersion: TMenuItem;
    mnuTime: TMenuItem;
    mnuServerVCard: TMenuItem;
    mnuVCard: TMenuItem;
    N13: TMenuItem;
    JabberCentralWebsite1: TMenuItem;
    mnuMyVCard: TMenuItem;
    N17: TMenuItem;
    mnuBookmark: TMenuItem;
    ImageList2: TImageList;
    mnuExpanded: TMenuItem;
    Splitter1: TSplitter;
    N1: TMenuItem;
    N2: TMenuItem;
    timFlasher: TTimer;
    N3: TMenuItem;
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
    RegisterwithaService1: TMenuItem;
    btnExpanded: TToolButton;
    trayMessage: TMenuItem;
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
    procedure Splitter1Moved(Sender: TObject);
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
    procedure RegisterwithaService1Click(Sender: TObject);
    procedure TabsUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure TabsDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure mnuMessageClick(Sender: TObject);
    procedure Test1Click(Sender: TObject);
    procedure trayMessageClick(Sender: TObject);
  private
    { Private declarations }
    _event: TNextEventType;
    _noMoveCheck: boolean;
    _flash: boolean;
    _edge_snap: integer;
    _prof_index: integer;
    _auto_login: boolean;
    _auto_away: boolean;

    // Various other key controllers
    _guibuilder: TGUIFactory;
    _regController: TRegController;
    _Notify: TNotifyController;
    _subcontroller: TSubController;

    _windows_ver: integer;
    _is_broadcast: boolean;
    _is_autoaway: boolean;
    _is_autoxa: boolean;
    _is_min: boolean;
    _last_show: string;
    _last_status: string;
    _hookLib: THandle;
    _getHookPointer: TGetHookPointer;
    _InitHooks: TInitHooks;
    _StopHooks: TStopHooks;
    _lpHookRec: PHookRec;
    _richedit: THandle;

    _version: TVersionResponder;
    _time: TTimeResponder;
    _last: TLastResponder;
    _browse: TBrowseResponder;

    _tray: NOTIFYICONDATA;
    _tray_icon: TIcon;
    _hidden: boolean;
    _shutdown: boolean;
    _close_min: boolean;
    _appclosing: boolean;
    _testaa: boolean;

    _sessioncb: integer;
    _msgcb: integer;
    _iqcb: integer;

    _auto_away_interval: integer;
    last_tick: dword;             

    procedure presCustomPresClick(Sender: TObject);

    procedure restoreEvents(expanded: boolean);
    procedure restoreToolbar;
    procedure restoreAlpha;
    procedure restoreMenus(enable: boolean);

    procedure setTrayInfo(tip: string);
    procedure setTrayIcon(iconNum: integer);

    procedure SetAutoAway();
    procedure SetAutoXA();
    procedure SetAutoAvailable();
    procedure SetupAutoAwayTimer();
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
  published
    // Callbacks
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure MsgCallback(event: string; tag: TXMLTag);
    procedure iqCallback(event: string; tag: TXMLTag);
    procedure ChangePasswordCallback(event: string; tag: TXMLTag);

  public

    function getLastTick(): dword;
    function getTabForm(tab: TTabSheet): TForm;
    function IsAutoAway(): boolean;
    function IsAutoXA(): boolean;

    procedure RenderEvent(e: TJabberEvent);
    procedure Startup();
    procedure DoConnect();
    procedure CTCPCallback(event: string; tag: TXMLTag);
    procedure ResetLastTick(value: longint);
    procedure AcceptFiles( var msg : TWMDropFiles ); message WM_DROPFILES;
    procedure DefaultHandler(var msg); override;
  end;

var
    frmExodus: TfrmExodus;
    sExodusPresence: Cardinal;

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

    sExodus = 'Exodus';
    sChat = 'Chat';

    sGrpBookmarks = 'Bookmarks';
    sGrpUnfiled = 'Unfiled';
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
    sAuthError = 'There was an error trying to authenticate you. Please try again, or create a new account';
    sAuthNoAccount = 'This account does not exist on this server. Create a new account?';


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

    sPasswordError = 'Error changing password.';
    sPasswordChanged = 'Password changed.';
    sPasswordOldError = 'Old password is incorrect.';
    sPasswordNewError = 'New password does not match.';

    sAlreadySubscribed = 'You are already subscribed to this contact';

    sSoundChatactivity = 'Activity in a chat window';
    sSoundInvite = 'Invited to a room';
    sSoundKeyword = 'Keyword in a room';
    sSoundNewchat = 'New conversation';
    sSoundNormalmsg = 'Received a normal message';
    sSoundOffline = 'Contact went offline';
    sSoundOnline = 'Contact came online';
    sSoundRoomactivity = 'Activity in a room';
    sSoundS10n = 'Subscription request';

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

    ico_key = 16;
    ico_application = 19;
    ico_user = 20;
    ico_Error = 21;
    ico_conf = 21;
    ico_service = 22;
    ico_headline = 23;
    ico_Unread = 23;
    ico_keyword = 24;
    ico_render = 25;
    ico_down = 27;
    ico_right = 28;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    InputPassword, 
    RegForm, MsgDisplay, MsgQueue, JoinRoom, Login, ChatWin, RosterAdd,
    iq, JUD, Bookmark, CustomPres,
    MsgRecv, Prefs, Dockable,
    RiserWindow, RemoveContact,
    Session, Debug, About, getOpt, JabberID, XMLUtils, ExUtils,
    Transfer, Profile, CommCtrl, 
    VCard, PrefController, Roster, Password;

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
    case (msg.CmdType and $FFF0) of
    SC_MINIMIZE: begin
        // ShowWindow(Handle, SW_MINIMIZE);
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
    if (Msg.LParam = WM_LBUTTONDBLCLK) then begin
        if (_hidden) then begin
            // restore our app
            _hidden := false;
            ShowWindow(Handle, SW_RESTORE);
            SetForegroundWindow(Self.Handle);
            msg.Result := 0;
            end
        else begin
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
    //
    _shutdown := true;
    msg.Result := 1;
end;

{---------------------------------------}
procedure TfrmExodus.WMEndSession(var msg: TMessage);
begin
    //
    _shutdown := true;
    msg.Result := 0;
end;

{---------------------------------------}
procedure TfrmExodus.WMShowLogin(var msg: TMessage);
begin
    ShowLogin();
end;

{---------------------------------------}
procedure TfrmExodus.WMCloseApp(var msg: TMessage);
begin
    Self.Close();
end;

{---------------------------------------}
procedure AddSound(reg: TRegistry; pref_name: string; user_text: string);
begin
    reg.CreateKey('\AppEvents\Schemes\Apps\Exodus\EXODUS_' + pref_name);
    reg.OpenKey('\AppEvents\EventLabels\EXODUS_' + pref_name, true);
    reg.WriteString('', user_text);
end;

{---------------------------------------}
procedure TfrmExodus.FormCreate(Sender: TObject);
var
    exp: boolean;
    profile: TJabberProfile;
    reg: TRegistry;

    show_help: boolean;
    debug: boolean;
    minimized: boolean;
    invisible: boolean;
    expanded: string;
    jid: TJabberID;
    pass: string;
    resource: string;
    priority: integer;
    profile_name: string;
    config: string;
    help_msg: string;
    win_ver: string;
    picon: TIcon;
begin
    // initialize vars.  wish we were using a 'real' compiler.
    debug := false;
    minimized := false;
    invisible := false;
    show_help := false;
    _testaa := false;
    jid := nil;
    priority := -1;

    // Hide the application's window, and set our own
    // window to the proper parameters..
    ShowWindow(Application.Handle, SW_HIDE);
    SetWindowLong(Application.Handle, GWL_EXSTYLE,
        GetWindowLong(Application.Handle, GWL_EXSTYLE)
        and not WS_EX_APPWINDOW or WS_EX_TOOLWINDOW);
    ShowWindow(Application.Handle, SW_SHOW);

    // Initialize the Riched20.dll stuff
    _richedit := LoadLibrary('Riched20.dll');

    _tray_icon := TIcon.Create();
    _appclosing := false;
    _event := next_none;
    _noMoveCheck := true;
    //frmDebug := nil;

    try
        with TGetOpts.Create(nil) do begin
            try
                // -d          : debug
                // -m          : minimized
                // -v          : invisible
                // -?          : help
                // -x [yes|no] : expanded
                // -j [jid]    : jid
                // -p [pass]   : password
                // -r [res]    : resource
                // -i [pri]    : priority
                // -f [prof]   : profile name
                // -c [file]   : config file name
                Options  := 'dmva?xjprifc';
                OptFlags := '-----:::::::';
                ReqFlags := '            ';
                LongOpts := 'debug,minimized,invisible,aatest,help,expanded,jid,password,resource,priority,profile,config';
                while GetOpt do begin
                  case Ord(OptChar) of
                     0: raise EConfigException.Create('unknown argument');
                     Ord('d'): debug := true;
                     Ord('x'): expanded := OptArg;
                     Ord('m'): minimized := true;
                     Ord('a'): _testaa := true;
                     Ord('v'): invisible := true;
                     Ord('j'): jid := TJabberID.Create(OptArg);
                     Ord('p'): pass := OptArg;
                     Ord('r'): resource := OptArg;
                     Ord('i'): priority := SafeInt(OptArg);
                     Ord('f'): profile_name := OptArg;
                     Ord('c'): config := OptArg;
                     Ord('?'): show_help := true;
                  end;
                end;
            finally
                Free
            end;
        end;

        if (_testaa) then
            _auto_away_interval := 1
        else
            _auto_away_interval := 10;

        timAutoAway.Interval := _auto_away_interval * 1000;

        if (show_help) then begin
            // show the help message
            help_msg := sCommandLine;
            help_msg := help_msg + sCmdDebug;
            help_msg := help_msg + sCmdMinimized;
            help_msg := help_msg + sCmdInvisible;
            help_msg := help_msg + sCmdHelp;
            help_msg := help_msg + sCmdExpanded;
            help_msg := help_msg + sCmdJID;
            help_msg := help_msg + sCmdPassword;
            help_msg := help_msg + sCmdResource;
            help_msg := help_msg + sCmdPriority;
            help_msg := help_msg + sCmdProfile;
            help_msg := help_msg + sCmdConfig;
            MessageDlg(help_msg, mtInformation, [mbOK], 0);
            Halt;
            end;

        if (config = '') then
            config := getUserDir() + 'exodus.xml';

        // Create our main Session object
        MainSession := TJabberSession.Create(config);

        _guibuilder := TGUIFactory.Create();
        _guibuilder.SetSession(MainSession);

        _regController := TRegController.Create();
        _regController.SetSession(MainSession);

        _Notify := TNotifyController.Create;
        _Notify.SetSession(MainSession);

        _subcontroller := TSubController.Create();

        with MainSession.Prefs do begin
            RestorePosition(Self);

            if (expanded <> '') then
                SetBool('expanded', (expanded = 'yes'));

            // if a profile name was specified, use it.
            // otherwise, if a jid was specified, use it as the profile name.
            // otherwise, if we have no profiles yet, use the default profile name.
            if (profile_name = '') then begin
                if (jid <> nil) then
                    profile_name := jid.jid
                else if (Profiles.Count = 0) then
                    profile_name := sDefaultProfile;
                end;

            // if a profile was specified, use it, or create it if it doesn't exist.
            if (profile_name <> '') then begin
                _prof_index := Profiles.IndexOf(profile_name);

                if (_prof_index = -1) then begin
                    // no profile called this, yet
                    //if (jid = nil) or (pass = '') then
                    //    raise EConfigException.Create('need jid and password for new profile');

                    profile := CreateProfile(profile_name);
                    if (jid = nil) then
                        profile.Server := 'jabber.org';
                    if (resource = '') then
                        resource := 'Exodus';
                    if (priority = -1) then
                        priority := 0;
                    end
                else
                    profile := TJabberProfile(Profiles.Objects[_prof_index]);

                if (jid <> nil) then begin
                    profile.Username := jid.user;
                    profile.Server := jid.domain;
                    end;

                if (resource <> '') then
                    profile.Resource := resource;
                if (priority <> -1) then
                    profile.Priority := priority;
                if (pass <> '') then
                    profile.password := pass;

                SaveProfiles();
                _prof_index := Profiles.IndexOfObject(profile);

                if (profile.IsValid()) then begin
                    setInt('profile_active', _prof_index);
                    _auto_login := true;
                    end;
                end
            else begin
                _prof_index := getInt('profile_active');
                _auto_login := getBool('autologin');
                end;

            if (minimized) then begin
                _hidden := true;
                self.WindowState := wsMinimized;
                ShowWindow(Handle, SW_HIDE);
                PostMessage(Self.handle, WM_SYSCOMMAND, SC_MINIMIZE , 0);
                end;

            MainSession.Invisible := invisible;

            if (debug) then begin
                ShowDebugForm();
            {
                frmDebug := TfrmDebug.Create(nil);
                if getBool('expanded') then
                    frmDebug.DockForm;
                frmDebug.Show;
                }
                end;
            end;
    except
        on E : EConfigException do begin
            MessageDlg(E.Message, mtError, [mbOK], 0);
            Halt;
        end;
    end;

    // Setup callbacks
    _sessioncb := MainSession.RegisterCallback(SessionCallback, '/session');
    _msgcb := MainSession.RegisterCallback(MsgCallback, '/packet/message');
    _iqcb := MainSession.RegisterCallback(iqCallback, '/packet/iq[@type="set"]/query[@xmlns="jabber:iq:oob"]');

    // Create responders to other queries on us.
    _version := TVersionResponder.Create(MainSession);
    _time := TTimeResponder.Create(MainSession);
    _last := TLastResponder.Create(MainSession);
    _browse := TBrowseResponder.Create(MainSession);

    Tabs.ActivePage := tbsRoster;
    restoreToolbar();

    exp := MainSession.Prefs.getBool('expanded');

    pnlRight.Visible := exp;

    restoreEvents(exp);
    _noMoveCheck := false;
    _flash := false;

    // Setup the IdleUI stuff..
    _is_autoaway := false;
    _is_autoxa := false;
    _is_min := false;

    _is_broadcast := false;

    _windows_ver := WindowsVersion(win_ver);
    setupAutoAwayTimer();
    ConfigEmoticons();

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

    _hidden := false;
    _shutdown := false;
    _close_min := MainSession.prefs.getBool('close_min');

    // if we don't have sound registry settings, then add them
    // sigh.  If we had an installer, that would be the place to
    // do this.
    reg := TRegistry.Create();
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('\AppEvents\Schemes\Apps\Exodus', true);
    reg.WriteString('', sExodus);

    AddSound(reg, 'notify_chatactivity', sSoundChatactivity);
    AddSound(reg, 'notify_invite', sSoundInvite);
    AddSound(reg, 'notify_keyword', sSoundKeyword);
    AddSound(reg, 'notify_newchat', sSoundNewchat);
    AddSound(reg, 'notify_normalmsg', sSoundNormalmsg);
    AddSound(reg, 'notify_offline', sSoundOffline);
    AddSound(reg, 'notify_online', sSoundOnline);
    AddSound(reg, 'notify_roomactivity', sSoundRoomactivity);
    AddSound(reg, 'notify_s10n', sSoundS10n);
    reg.Free();

    // Make sure we read in and setup the prefs..
    Self.SessionCallback('/session/prefs', nil);

    // Accept files dragged from Explorer
    DragAcceptFiles(Handle, True);
end;

{---------------------------------------}
procedure TfrmExodus.Startup;
begin
    if (MainSession.Prefs.getBool('expanded')) then begin
        getMsgQueue();
        frmMsgQueue.ManualDock(Self.pnlRight, nil, alClient);
        frmMsgQueue.Align := alClient;
        frmMsgQueue.Show;
        end;

    with MainSession.Prefs do begin
        if (_auto_login) then begin
            // snag default profile, etc..
            MainSession.ActivateProfile(_prof_index);
            Self.DoConnect();
            end
        else
            PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
        end;
end;

{---------------------------------------}
procedure TfrmExodus.DoConnect();
var
    pf: TfrmInputPass;
begin
    {
    Make sure that the active profile
    has the password field filled out.
    If not, pop up the password prompt,
    otherwise, just call connect
    }

    with MainSession do begin
        if Password = '' then begin
            pf := TfrmInputPass.Create(nil);
            if (pf.ShowModal) = mrOK then begin
                Password := pf.txtPassword.Text;
                Connect();
                end;
            pf.Close();
            end
        else
            Connect();
        end;
end;

{---------------------------------------}
procedure TfrmExodus.setupAutoAwayTimer();
begin
    DebugMsg(sSetupAutoAway);
    if ((_windows_ver < cWIN_2000) or (_windows_ver = cWIN_ME)) then begin
        // Use the DLL
        @_GetHookPointer := nil;
        @_InitHooks := nil;
        @_StopHooks := nil;
        _lpHookRec := nil;
        _hookLib := LoadLibrary('IdleHooks.dll');
        if (_hookLib <> 0) then begin
            // start the hooks
            @_GetHookPointer := GetProcAddress(_hookLib, 'GetHookPointer');
            @_InitHooks := GetProcAddress(_hookLib, 'InitHooks');
            @_StopHooks := GetProcAddress(_hookLib, 'StopHooks');
            _lpHookRec := _GetHookPointer();
            inc(_lpHookRec^.InstanceCount);
            // if (_lpHookRec^.KeyHook = 0) then
            _InitHooks();
            _lpHookRec^.LastTick := GetTickCount();
            end
        else
            DebugMsg(sAutoAwayFail);
        last_tick := GetTickCount();
        end
    else begin
        // Use the GetLastInputInfo API call
        // do nothing here..
        if (_GetLastInputInfo <> nil) then
            DebugMsg(sAutoAwayWin32)
        else
            DebugMsg(sAutoAwayFailWin32);
        end;
end;

{---------------------------------------}
procedure TfrmExodus.setTrayInfo(tip: string);
begin
    StrPCopy(@_tray.szTip, tip);
    Shell_NotifyIcon(NIM_MODIFY, @_tray);
end;

{---------------------------------------}
procedure TfrmExodus.setTrayIcon(iconNum: integer);
begin
    ImageList2.GetIcon(iconNum, _tray_icon);
    _tray.hIcon := _tray_icon.Handle;
    Shell_NotifyIcon(NIM_MODIFY, @_tray);
end;

{---------------------------------------}
procedure TfrmExodus.SessionCallback(event: string; tag: TXMLTag);
var
    p: TJabberPres;
    msg : TMessage;
begin
    // session events
    if event = '/session/connected' then begin
        btnConnect.Down := true;
        Self.Caption := 'Exodus - ' + MainSession.Username + '@' + MainSession.Server;
        setTrayInfo(Self.Caption);
        setTrayIcon(1);
        end

    else if event = '/session/autherror' then begin
        MessageDlg(sAuthError, mtError, [mbOK], 0);
        PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
        exit;
        end

    else if event = '/session/noaccount' then begin
        if (MessageDlg(sAuthNoAccount, mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
            // Just disconnect, they don't want an account
            MainSession.Disconnect()
        else
            // create the new account
            MainSession.CreateAccount();
        end

    else if event = '/session/authenticated' then with MainSession do begin
        Roster.Fetch;

        // Send invisible or Available presence..
        p := TJabberPres.Create;

        if (MainSession.Invisible) then
            p.PresType := 'invisible'
        else
            p.Status := 'available';
        p.Priority := MainSession.Profile.Priority;
        SendTag(p);
        Tabs.ActivePage := tbsRoster;
        restoreMenus(true);
        timAutoAway.Enabled := true;
        end

    else if (event = '/session/disconnected') then begin
        timAutoAway.Enabled := false;

        if (frmMsgQueue <> nil) then
            frmMsgQueue.lstEvents.Items.Clear;

        Self.Caption := sExodus;
        setTrayInfo(Self.Caption);
        setTrayIcon(0);

        btnConnect.Down := false;
        restoreMenus(false);

        if (_appclosing) then
            PostMessage(Self.Handle, WM_CLOSEAPP, 0, 0);
        end

    else if event = '/session/commerror' then begin
        timAutoAway.Enabled := false;
        MessageDlg(sCommError,  mtError, [mbOK], 0);
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

        // do other stuff
        restoreMenus(MainSession.Active);
        restoreToolbar();
        restoreAlpha();
        restoreEvents(MainSession.Prefs.getBool('expanded'));
        if not MainSession.Prefs.getBool('expanded') then
            tbsRoster.TabVisible := false;
        end

    else if (event = '/session/presence') then begin
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

        if (not MainSession.Prefs.getBool('presence_message_send')) then exit;
        msg.LParamHi := GetPresenceAtom(MainSession.Show);
        msg.LParamLo := GetPresenceAtom(MainSession.Status);
        PostMessage(HWND_BROADCAST, sExodusPresence, self.Handle, msg.LParam);
        end;
end;

{---------------------------------------}
procedure TfrmExodus.restoreToolbar;
begin
    with MainSession.Prefs do begin
        mnuExpanded.Checked := getBool('expanded');
        mnuOnline.Checked := getBool('roster_only_online');
        btnOnlineRoster.Down := getBool('roster_only_online');
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

    mnuContacts.Enabled := enable;
    mnuPresence.Enabled := enable;
    trayPresence.Enabled := enable;

    mnuMyVCard.Enabled := enable;
    mnuVCard.Enabled := enable;

    mnuBookmark.Enabled := enable;
    mnuFilters.Enabled := enable;
    mnuBrowser.Enabled := enable;
    mnuServer.Enabled := enable;

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
procedure TfrmExodus.iqCallback(event: string; tag: TXMLTag);
var
    qTag, tmp_tag: TXMLTag;
    from, url, desc: string;
begin
    from := tag.GetAttribute('from');

    qTag := tag.getFirstTag('query');
    tmp_tag := qtag.GetFirstTag('url');
    url := tmp_tag.Data;
    tmp_tag := qTag.GetFirstTag('desc');
    if (tmp_tag <> nil) then
        desc := tmp_tag.Data
    else
        desc := '';
    FileReceive(from, url, desc);
end;

{---------------------------------------}
procedure TfrmExodus.MsgCallback(event: string; tag: TXMLTag);
var
    b, mtype: string;
    e: TJabberEvent;
begin
    // record the event
    mtype := tag.getAttribute('type');
    b := Trim(tag.GetBasicText('body'));
    if ((mtype <> 'groupchat') and (mtype <> 'chat') and (b <> '')) then begin
        if MainSession.IsPaused then
            MainSession.QueueEvent(event, tag, Self.MsgCallback)
        else begin
            e := CreateJabberEvent(tag);
            RenderEvent(e);
            end;
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

{---------------------------------------}
procedure TfrmExodus.RenderEvent(e: TJabberEvent);
var
    msg: string;
    img_idx: integer;
    mqueue: TfrmMsgQueue;
begin
    // create a listview item for this event
    img_idx := 0;

    case e.etype of
    evt_Presence: begin
        if  (e.data_type = 'subscribe') or
            (e.data_type = 'subscribed') or
            (e.data_type = 'unsubscribe') or
            (e.data_type = 'unsubscribed') then
            img_idx := 16
        else if (e.data_type = 'available') then
            img_idx := 1
        else if (e.data_type = 'unavailable') then
            img_idx := 0
        else if (e.data_type = 'away') then
            img_idx := 2
        else if (e.data_type = 'dnd') then
            img_idx := 3
        else if (e.data_type = 'chat') then
            img_idx := 4
        else if (e.data_type = 'xa') then
            img_idx := 10;
        msg := e.Data[0];
        end;

    evt_Time: begin
        img_idx := 12;
        msg := e.data_type;
        e.Data.Add(Format(sMsgPing, [IntToStr(e.elapsed_time)]));
        end;

    evt_Message: begin
        img_idx := 18;
        msg := e.data_type;
        DoNotify(nil, 'notify_normalmsg',
                 sMsgMessage + TJabberID.Create(e.from).jid, img_idx);
        end;

    evt_Invite: begin
        img_idx := 21;
        msg := e.data_type;
        DoNotify(nil, 'notify_invite',
                 sMsgInvite + TJabberID.Create(e.from).jid, img_idx);
        end;

    evt_RosterItems: begin
        img_idx := 26;
        msg := e.data_type;
        end

    else begin
        img_idx := 12;
        msg := e.data_type;
        end;
    end;

    if MainSession.Prefs.getBool('expanded') then begin
        getMsgQueue().LogEvent(e, msg, img_idx);
        end
    else if (e.delayed) then begin
        // we are collapsed, but this event was delayed (offline'd)
        // so display it in the msg queue, not live
        mqueue := getMsgQueue();
        mqueue.Show;
        mqueue.LogEvent(e, msg, img_idx);
        end
    else
        // we are collapsed, just display in regular windows
        ShowEvent(e);
end;

{---------------------------------------}
procedure TfrmExodus.btnConnectClick(Sender: TObject);
begin
    // connect to the server
    if MainSession.Active then
        MainSession.Disconnect
    else
        ShowLogin;
end;

{---------------------------------------}
procedure TfrmExodus.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    // Unregister callbacks, etc.

    if ((MainSession.Active) and (not _appclosing))then begin
        _appclosing := true;
        MainSession.Stream.Disconnect();
        CanClose := false;
        exit;
        end;

    MainSession.UnRegisterCallback(_sessioncb);
    MainSession.UnRegisterCallback(_msgcb);
    MainSession.UnRegisterCallback(_iqcb);

    // Free the responders
    _version.Free();
    _time.Free();
    _last.Free();
    _browse.Free();

    if (_hookLib <> 0) then begin
        dec(_lpHookRec^.InstanceCount);
        _StopHooks();
        end;

    if (_richedit <> 0) then
        FreeLibrary(_richedit);

    MainSession.Prefs.SavePosition(Self);
    if (frmMsgQueue <> nil) then begin
        frmMsgQueue.lstEvents.Items.Clear;
        frmMsgQueue.Close;
        end;

    if MainSession <> nil then begin
        _event := next_Exit;
        {
        if frmDebug <> nil then
            frmDebug.Close;
        }
        CloseDebugForm();
        frmRosterWindow.ClearNodes();
        frmRosterWindow.Close;
        ChatWin.CloseAllChats();

        _notify.Free();
        _guiBuilder.Free();
        _regController.Free();
        _SubController.Free();

        MainSession.Free();
        MainSession := nil;
        end;

    _tray_icon.Free();
end;

{---------------------------------------}
procedure TfrmExodus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Shell_NotifyIcon(NIM_DELETE, @_tray);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmExodus.btnOnlineRosterClick(Sender: TObject);
var
    e: boolean;
begin
    // show only online
    with MainSession.Prefs do begin
        e := getBool('roster_only_online');
        e := not e;
        setBool('roster_only_online', e);
        btnOnlineRoster.Down := e;
        mnuOnline.Checked := e;
        end;

    if MainSession.Active then
        frmRosterWindow.Redraw;
end;

{---------------------------------------}
procedure TfrmExodus.btnAddContactClick(Sender: TObject);
begin
    // add a contact
    ShowAddContact;
end;

{---------------------------------------}
procedure TfrmExodus.mnuConferenceClick(Sender: TObject);
begin
    // Join a TC Room
    StartJoinRoom;
end;

{---------------------------------------}
procedure TfrmExodus.FormResize(Sender: TObject);
begin
    if MainSession <> nil then
        MainSession.Prefs.SavePosition(Self);
end;

{---------------------------------------}
procedure TfrmExodus.Preferences1Click(Sender: TObject);
begin
    // Show the prefs
    StartPrefs;
end;

{---------------------------------------}
procedure TfrmExodus.btnExpandedClick(Sender: TObject);
var
    delta, w: longint;
    newval: boolean;
    docked: TfrmDockable;
begin
    // either expand or compress the whole thing
    newval := not MainSession.Prefs.getBool('expanded');
    mnuExpanded.Checked := newval;
    delta := Self.ClientWidth - tbsRoster.Width + Splitter1.Width;

    if newval then begin
        // we are expanded now
        Tabs.DockSite := true;
        w := MainSession.Prefs.getInt('event_width');
        Self.ClientWidth := Self.ClientWidth + w - delta;
        pnlRight.Visible := true;
        getMsgQueue().ManualDock(pnlRight, nil, alClient);
        pnlRoster.Width := Self.ClientWidth - w;
        pnlRight.Width := w;
        getMsgQueue.Align := alClient;
        end
    else begin
        // we are compressed now
        w := pnlRight.Width;
        pnlRight.Visible := false;
        MainSession.Prefs.setInt('event_width', w);

        // Undock the MsgQueue... if it's empty, close it.
        if (frmMsgQueue <> nil) then begin
            if (frmMsgQueue.lstEvents.Items.Count > 0) then
                frmMsgQueue.FloatForm
            else
                frmMsgQueue.Close;
            end;

        // make sure we undock all of the tabs..
        while (Tabs.DockClientCount > 0) do begin
            docked := TfrmDockable(Tabs.DockClients[0]);
            docked.FloatForm;
            end;

        Self.ClientWidth := Self.ClientWidth - w;

        Tabs.DockSite := false;
        Self.Show;
        end;
    MainSession.Prefs.setBool('expanded', newval);
    restoreToolbar();
    restoreEvents(newval);
end;

{---------------------------------------}
procedure TfrmExodus.restoreEvents(expanded: boolean);
var
    ew, w: longint;
    activeTab: integer;
begin
    with MainSession.Prefs do begin
        w := getInt(P_EVENT_WIDTH);
        setBool('expanded', expanded);

        if expanded then begin
            Tabs.Docksite := true;
            pnlRoster.align := alLeft;
            Splitter1.align := alRight;
            Splitter1.align := alLeft;
            pnlRight.Width := w;
            ew := Self.ClientWidth - w;
            if (ew < 0) then ew := Self.ClientWidth div 2;
            pnlRoster.Width := ew;
            pnlRight.Visible := true;
            pnlRight.Width := w;
            tbsRoster.TabVisible := true;

            // make sure the MsgQueue window is docked
            if (frmMsgQueue <> nil) then begin
                frmMsgQueue.ManualDock(pnlRight, nil, alClient);
                frmMsgQueue.Show;
                end;

            // make sure the debug window is docked
            activeTab := Tabs.ActivePage.PageIndex;
            DockDebugForm();

            Tabs.ActivePage := Tabs.Pages[activeTab];
            end
        else begin
            w := pnlRight.Width;
            setInt('event_width', w);
            tbsRoster.TabVisible := false;
            //tbsDebug.TabVisible := false;
            Tabs.Docksite := false;
            Tabs.ActivePage := tbsRoster;
            pnlRoster.align := alClient;

            FloatDebugForm();
            end;
        end;
end;

{---------------------------------------}
procedure TfrmExodus.ClearMessages1Click(Sender: TObject);
begin
    // Clear events from the list view.
    if (frmMsgQueue <> nil) then
        frmMsgQueue.lstEvents.Items.Clear;
end;

{---------------------------------------}
procedure TfrmExodus.WMWindowPosChanging(var msg: TWMWindowPosChanging);
var
    r: TRect;
begin
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
var
    n: TTreeNode;
    ritem: TJabberRosterItem;
begin
    // delete the current
    n := frmRosterWindow.treeRoster.Selected;
    ritem := TJabberRosterItem(n.Data);
    if ritem <> nil then
        RemoveRosterItem(ritem.jid.jid);
end;

{---------------------------------------}
procedure TfrmExodus.ShowXML1Click(Sender: TObject);
begin
    // show the debug window if it's hidden
    {
    if (frmDebug = nil) then
        frmDebug := TfrmDebug.Create(nil);
    frmDebug.ShowDefault();
    }
    ShowDebugForm();
end;

{---------------------------------------}
procedure TfrmExodus.Splitter1Moved(Sender: TObject);
begin
    // Save the current width
    MainSession.Prefs.setInt('event_width', pnlRight.Width);
end;

{---------------------------------------}
procedure TfrmExodus.Exit2Click(Sender: TObject);
begin
    _shutdown := true;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmExodus.timFlasherTimer(Sender: TObject);
begin
    _flash := not _flash;
    FlashWindow(Application.Handle, _flash);
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
    // goto www.jabbecentral.org
    ShellExecute(0, 'open', 'http://www.jabbercentral.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.About1Click(Sender: TObject);
begin
    // Show some about dialog box
    frmAbout := TfrmAbout.Create(nil);
    frmAbout.ShowModal;
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
    new_grp: string;
    gl: TStringList;
begin
    // Add a roster grp.
    new_grp := sDefaultGroup;
    if InputQuery(sNewGroup, sNewGroupPrompt, new_grp) = false then exit;

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
        end;
end;

{---------------------------------------}
function TfrmExodus.getLastTick(): dword;
var
    last_info: TLastInputInfo;
begin
    Result := 0;
    if (_windows_ver < cWIN_2000) then begin
        if (_lpHookRec <> nil) then
            Result := _lpHookRec^.LastTick;
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
    // dmsg: string;
    avail: boolean;
begin
    // get the latest idle amount
    if (MainSession = nil) then exit;
    if (not MainSession.Active) then exit;

    with MainSession.Prefs do begin
        if ((_auto_away)) then begin

            last_tick := getLastTick();
            if (last_tick = 0) then exit;

            cur_idle := (GetTickCount() - last_tick) div 1000;
            if (not _testaa) then
                mins := cur_idle div 60
            else
                mins := cur_idle;

            {
            if (not _is_autoaway) and (not _is_autoxa) then begin
                dmsg := 'Idle Check: ' + BoolToStr(_is_autoaway, true) + ', ' +
                    BoolToStr(_is_autoxa, true) + ', ' +
                    IntToStr(cur_idle ) + ' secs'#13#10;
                DebugMsg(dmsg);
                end;
            }

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

    // must be before SetPresence
    _is_autoaway := true;
    _is_autoxa := false;

    MainSession.SetPresence('away', MainSession.prefs.getString('away_status'),
        MainSession.Priority);

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
    MainSession.SetPresence(_last_show, _last_status, MainSession.Priority);

    // must be *after* SetPresence
    _is_autoaway := false;
    _is_autoxa := false;
    timAutoAway.Enabled := true;

    MainSession.Play();
end;

{---------------------------------------}
procedure TfrmExodus.MessageHistory2Click(Sender: TObject);
begin
    frmRosterWindow.popHistoryClick(Sender);
end;

{---------------------------------------}
procedure TfrmExodus.Properties2Click(Sender: TObject);
begin
    frmRosterWindow.popPropertiesClick(Sender);
end;

{---------------------------------------}
procedure TfrmExodus.mnuVCardClick(Sender: TObject);
var
    jid: string;
begin
    // lookup some arbitrary vcard..
    if InputQuery(sLookupProfile, sEnterJID, jid) then
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
        EEK! this is really gross because the pagecontrol sucks.
        Make sure the tab is visible before fetching it's bounding rect,
        and checking the hit test.

        BUT, the pageindex we need is the "raw" tabindex. Apparently,
        the pagecontrol just makes tabs invisible when something gets
        undocked.
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
    if Tabs.TabIndex = 0 then exit;

    t := Tabs.ActivePage;
    f := getTabForm(t);
    if ((f <> nil) and (f is TfrmDockable)) then
        TfrmDockable(f).FloatForm();
end;

{---------------------------------------}
procedure TfrmExodus.mnuChatClick(Sender: TObject);
var
    n: TTreeNode;
    ritem: TJabberRosterItem;
    jid: string;
begin
    // Start a chat w/ a specific JID
    jid := '';
    if (frmRosterWindow.treeRoster.SelectionCount > 0) then begin
        n := frmRosterWindow.treeRoster.Selected;
        ritem := TJabberRosterItem(n.Data);
        if ritem <> nil then
            jid := ritem.jid.jid
        end;

    if InputQuery(sStartChat, sEnterJID, jid) then
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
procedure TfrmExodus.ResetLastTick(value: longint);
begin
    if (_windows_ver >= cWIN_2000) then exit;

    // DebugMsg('Setting LastTick to ' + IntToStr(value) + ', Current=' + IntToStr(GetTickCount()));
    _lpHookRec^.LastTick := value;
end;

{---------------------------------------}
procedure TfrmExodus.WinJabWebsite1Click(Sender: TObject);
begin
    // goto exodus.sf.net
    ShellExecute(0, 'open', 'http://exodus.sf.net', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.JabberBugzilla1Click(Sender: TObject);
begin
    // submit a bug on SF.
    ShellExecute(0, 'open', 'http://sourceforge.net/tracker/?func=add&group_id=2049&atid=202049', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.mnuVersionClick(Sender: TObject);
var
    iq: TJabberIQ;
begin
    iq := TJabberIQ.Create(MainSession, MainSession.generateID, Self.CTCPCallback);
    iq.iqType := 'get';
    iq.toJID := MainSession.Server;
    if Sender = mnuVersion then
        iq.Namespace := XMLNS_VERSION
    else if Sender = mnuTime then
        iq.Namespace := XMLNS_TIME;
    iq.Send;
end;

{---------------------------------------}
procedure TfrmExodus.mnuPasswordClick(Sender: TObject);
var
    iq: TJabberIQ;
    f : TfrmPassword;
begin
    {
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

    iq := TJabberIQ.Create(MainSession, MainSession.generateID, Self.ChangePasswordCallback);
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
    DragAcceptFiles(Handle, False);
end;

{---------------------------------------}
procedure TfrmExodus.RegisterwithaService1Click(Sender: TObject);
var
    tmps: string;
    f: TfrmRegister;
begin
    // kick off a registration..
    tmps := '';
    if (InputQuery(sRegService, sEnterSvcJID, tmps) = false) then
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
    if (Client is TfrmDockable) then
        TfrmDockable(Client).Docked := false;
end;

{---------------------------------------}
procedure TfrmExodus.TabsDockDrop(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer);
begin
    if (Source.Control is TfrmDockable) then
        TfrmDockable(Source.Control).Docked := true;
end;

{---------------------------------------}
procedure TfrmExodus.mnuMessageClick(Sender: TObject);
var
    jid: string;
    n: TTreeNode;
    ritem: TJabberRosterItem;
begin
    jid := '';
    if (frmRosterWindow.treeRoster.SelectionCount > 0) then begin
        n := frmRosterWindow.treeRoster.Selected;
        ritem := TJabberRosterItem(n.Data);
        if ritem <> nil then
            jid := ritem.jid.jid
        end;

    if InputQuery(sSendMessage, sEnterJID, jid) then
        StartMsg(jid);
end;

{---------------------------------------}
procedure TfrmExodus.Test1Click(Sender: TObject);
begin
    // Test something..
    _testaa := not _testaa;
    if (_testaa) then begin
        last_tick := GetTickCount() - 100000;
        Self.SetAutoAway();
        end
    else
        Self.SetAutoAvailable();
end;

{---------------------------------------}
procedure TfrmExodus.trayMessageClick(Sender: TObject);
var
    fsel: TfrmSelContact;
    jid : string;
begin
    //
    fsel := TfrmSelContact.Create(nil);
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
    m := TMessage(msg);
    if (m.Msg = sExodusPresence) then begin
        if (HWND(m.WParam) = Self.Handle) then exit;
        if (not MainSession.Prefs.getBool('presence_message_listen')) then exit;

        show := GetPresenceString(m.LParamHi);
        status := GetPresenceString(m.LParamLo);
        // already there.
        if ((MainSession.Show = show) and (MainSession.Status = status)) then exit;
        _is_broadcast := true;
        MainSession.setPresence(show, status, MainSession.Priority);
        _is_broadcast := false;
        end
    else
        inherited;
end;

initialization
    sExodusPresence := RegisterWindowMessage('EXODUS_PRESENCE');
end.

