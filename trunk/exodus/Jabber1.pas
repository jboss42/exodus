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
    Buttons, OleCtrls, AppEvnts, ToolWin;

const
    UpdateKey = '001';

    WM_TRAY = WM_USER + 5269;
    WM_PREFS = WM_USER + 5272;

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
  TExodus = class(TForm)
    Tabs: TPageControl;
    tbsMsg: TTabSheet;
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
    nextTimer: TTimer;
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
    btnExpanded: TToolButton;
    imgYahooEmoticons: TImageList;
    btnFind: TToolButton;
    imgMSNEmoticons: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure nextTimerTimer(Sender: TObject);
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

    _version: TVersionResponder;
    _time: TTimeResponder;
    _last: TLastResponder;
    _browse: TBrowseResponder;

    _tray: NOTIFYICONDATA;
    _hidden: boolean;
    _shutdown: boolean;
    _close_min: boolean;

    _sessioncb: integer;
    _msgcb: integer;
    _iqcb: integer;


    procedure presCustomPresClick(Sender: TObject);

    procedure restoreEvents(expanded: boolean);
    procedure restoreToolbar;
    procedure restoreAlpha;
    procedure restoreMenus(enable: boolean);

    procedure setTrayInfo(tip: string);

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
  published
    // Callbacks
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure MsgCallback(event: string; tag: TXMLTag);
    procedure iqCallback(event: string; tag: TXMLTag);

  public
    // other stuff..
    last_tick: longword;
    function getTabForm(tab: TTabSheet): TForm;
    function IsAutoAway(): boolean;
    function IsAutoXA(): boolean;

    procedure RenderEvent(e: TJabberEvent);
    procedure Startup;
    procedure CTCPCallback(event: string; tag: TXMLTag);
    procedure ResetLastTick(value: longint);
  end;

var
    frmJabber: TExodus;


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

    ico_down = 27;
    ico_right = 28;


    ico_Error = 21;
    ico_Unread = 23;

    ico_user = 20;
    ico_conf = 21;
    ico_render = 25;
    ico_keyword = 24;
    ico_service = 22;
    ico_headline = 23;
    ico_application = 19;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    MsgDisplay, MsgQueue, JoinRoom, Login, ChatWin, RosterAdd,
    iq, JUD, Bookmark, CustomPres,
    MsgRecv, Prefs, Dockable,
    RiserWindow, RemoveContact,
    Session, Debug, About, getOpt, JabberID, XMLUtils, ExUtils,
    Transfer, Profile,
    VCard, PrefController, Roster;

{$R *.DFM}

{---------------------------------------}
procedure TExodus.CreateParams(var Params: TCreateParams);
begin
    // Make each window appear on the task bar.
    inherited CreateParams(Params);
    with Params do begin
        ExStyle := ExStyle or WS_EX_APPWINDOW;
        WndParent := GetDesktopWindow();
        end;
end;

{---------------------------------------}
procedure TExodus.WMSysCommand(var msg: TWmSysCommand);
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
            end
        else
            inherited;
        msg.Result := 0;
        end;
    else
        inherited;
    end;
end;

{---------------------------------------}
procedure TExodus.WMTray(var msg: TMessage);
var
    cp: TPoint;
begin
    // this gets fired when the user clicks on the tray icon
    if ((Msg.LParam = WM_LBUTTONDBLCLK) and (_hidden)) then begin
        // restore our app
        _hidden := false;
        ShowWindow(Handle, SW_RESTORE);
        msg.Result := 0;
        end
    else if (Msg.LParam = WM_RBUTTONDOWN) then begin
        GetCursorPos(cp);
        SetForegroundWindow(Self.Handle);
        Application.ProcessMessages;
        popTray.Popup(cp.x, cp.y);
        end;
end;

{---------------------------------------}
procedure TExodus.WMQueryEndSession(var msg: TMessage);
begin
    //
    _shutdown := true;
    msg.Result := 1;
end;

{---------------------------------------}
procedure TExodus.WMEndSession(var msg: TMessage);
begin
    //
    _shutdown := true;
    msg.Result := 0;
end;

{---------------------------------------}
procedure TExodus.FormCreate(Sender: TObject);
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
begin
    // initialize vars.  wish we were using a 'real' compiler.
    debug := false;
    minimized := false;
    invisible := false;
    show_help := false;
    jid := nil;
    priority := -1;

    // Hide the application's window, and set our own
    // window to the proper parameters..
    ShowWindow(Application.Handle, SW_HIDE);
    SetWindowLong(Application.Handle, GWL_EXSTYLE,
        GetWindowLong(Application.Handle, GWL_EXSTYLE)
        and not WS_EX_APPWINDOW or WS_EX_TOOLWINDOW);
    ShowWindow(Application.Handle, SW_SHOW);

    _event := next_none;
    _noMoveCheck := true;
    frmDebug := nil;

    try
        with TGetOpts.Create(nil) do begin
            try
                // -d          : debug
                // -m          : minimized
                // -?          : help
                // -n          : invisible
                // -x [yes|no] : expanded
                // -j [jid]    : jid
                // -p [pass]   : password
                // -r [res]    : resource
                // -i [pri]    : priority
                // -f [prof]   : profile name
                // -c [file]   : config file name
                Options  := 'dmv?xjprifc';
                OptFlags := '----:::::::';
                ReqFlags := '           ';
                LongOpts := 'debug,minimized,invisible,help,expanded,jid,password,resource,priority,profile,config';
                while GetOpt do begin
                  case Ord(OptChar) of
                     0: raise EConfigException.Create('unknown argument');
                     Ord('d'): debug := true;
                     Ord('x'): expanded := OptArg;
                     Ord('m'): minimized := true;
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

        if (show_help) then begin
            // show the help message
            help_msg := 'The following command line parameters are available in Exodus: '#13#10#13#10;
            help_msg := help_msg + ' -d '#9#9' : Debug mode on'#13#10;
            help_msg := help_msg + ' -m '#9#9' : Start minimized'#13#10;
            help_msg := help_msg + ' -v '#9#9' : invisible mode'#13#10;
            help_msg := help_msg + ' -? '#9#9' : Show Help'#13#10;
            help_msg := help_msg + ' -x [yes|no] '#9' : Expanded Mode'#13#10;
            help_msg := help_msg + ' -j [jid] '#9#9' : Jid'#13#10;
            help_msg := help_msg + ' -p [pass] '#9' : Password'#13#10;
            help_msg := help_msg + ' -r [res] '#9' : Resource'#13#10;
            help_msg := help_msg + ' -i [pri] '#9#9' : Priority'#13#10;
            help_msg := help_msg + ' -f [prof] '#9' : Profile name'#13#10;
            help_msg := help_msg + ' -c [file] '#9' : Config path name'#13#10;
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
                    profile_name := 'Default Profile';
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
                frmDebug := TfrmDebug.Create(nil);
                if getBool('expanded') then
                    frmDebug.DockForm;
                frmDebug.Show;
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

    Tabs.ActivePage := tbsMsg;
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

    _windows_ver := WindowsVersion(win_ver);
    setupAutoAwayTimer();
    ConfigEmoticons();

    // Create the tray icon, etc..
    with _tray do begin
        Wnd := Self.Handle;
        uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
        uCallbackMessage := WM_TRAY;
        hIcon := Application.Icon.Handle;
        szTip := 'Exodus';
        cbSize := SizeOf(_tray);
        end;
    Shell_NotifyIcon(NIM_ADD, @_tray);

    _hidden := false;
    _shutdown := false;
    _close_min := MainSession.prefs.getBool('close_min');

    // if we have an old registry pref thing, then kill it.
    // todo: REMOVE EVENTUALLY
    reg := TRegistry.Create();
    reg.RootKey := HKEY_CURRENT_USER;
    if (reg.KeyExists('\SOFTWARE\Jabber\Exodus')) then
        reg.DeleteKey('\SOFTWARE\Jabber\Exodus');
    reg.Free();

    // Make sure we read in and setup the prefs..
    Self.SessionCallback('/session/prefs', nil);
end;

{---------------------------------------}
procedure TExodus.Startup;
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
            MainSession.Connect;
            end
        else
            ShowLogin();
        end;
end;

{---------------------------------------}
procedure TExodus.setupAutoAwayTimer();
begin
    DebugMsg('Trying to setup the Auto Away timer.'#13#10);
    if (_windows_ver < cWIN_2000) then begin
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
            DebugMsg('AutoAway Setup FAILED!');
        last_tick := GetTickCount();
        end
    else begin
        // Use the GetLastInputInfo API call
        // do nothing here..
        if (_GetLastInputInfo <> nil) then
            DebugMsg('Using Win32 API for Autoaway checks!!'#13#10)
        else
            DebugMsg('ERROR GETTING WIN32 API ADDR FOR GetLastInputInfo!!'#13#10);
        end;
end;

{---------------------------------------}
procedure TExodus.setTrayInfo(tip: string);
begin
    StrPCopy(@_tray.szTip, tip);
    Shell_NotifyIcon(NIM_MODIFY, @_tray);
end;

{---------------------------------------}
procedure TExodus.SessionCallback(event: string; tag: TXMLTag);
var
    p: TJabberPres;
begin
    // session events
    if event = '/session/connected' then begin
        btnConnect.Down := true;
        Self.Caption := 'Exodus - ' + MainSession.Username + '@' + MainSession.Server;
        setTrayInfo(Self.Caption);
        end

    else if event = '/session/autherror' then begin
        MessageDlg('There was an error trying to authenticate you. Please try again, or create a new account',
            mtError, [mbOK], 0);
        ShowLogin();
        exit;
        end

    else if event = '/session/noaccount' then begin
        if (MessageDlg('This account does not exist on this server. Create a new account?',
        mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
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

        SendTag(p);
        Tabs.ActivePage := tbsMsg;
        restoreMenus(true);
        timAutoAway.Enabled := true;
        end

    else if (event = '/session/disconnected') then begin
        if _event <> next_none then
            nextTimer.Enabled := true;
        timAutoAway.Enabled := false;

        if (frmMsgQueue <> nil) then
            frmMsgQueue.lstEvents.Items.Clear;

        Self.Caption := 'Exodus';
        setTrayInfo(Self.Caption);

        btnConnect.Down := false;
        restoreMenus(false);
        end

    else if event = '/session/commerror' then begin
        MessageDlg('There was an error during communication with the Jabber Server',
            mtError, [mbOK], 0);
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
        restoreMenus(MainSession.Stream.Active);
        restoreToolbar();
        restoreAlpha();
        restoreEvents(MainSession.Prefs.getBool('expanded'));
        if not MainSession.Prefs.getBool('expanded') then
            tbsMsg.TabVisible := false;
        end

    else if ((event = '/session/presence') and (MainSession.IsPaused)) then begin
        // If the session is paused, and we're changing back
        // to available, or chat, then make sure we play the session
        if (MainSession.Show = 'xa') or (MainSession.show = 'xa') or
        (MainSession.Show = 'dnd') then
            // do nothing
        else
            MainSession.Play();
        end;

end;

{---------------------------------------}
procedure TExodus.restoreToolbar;
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
procedure TExodus.restoreAlpha;
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
procedure TExodus.restoreMenus(enable: boolean);
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
procedure TExodus.iqCallback(event: string; tag: TXMLTag);
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
procedure TExodus.MsgCallback(event: string; tag: TXMLTag);
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
procedure TExodus.CTCPCallback(event: string; tag: TXMLTag);
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
procedure TExodus.RenderEvent(e: TJabberEvent);
var
    toast, msg: string;
    img_idx, n_flag: integer;
    mqueue: TfrmMsgQueue;
begin
    // create a listview item for this event
    n_flag := 0;
    img_idx := 0;

    case e.eType of
    evt_Message: n_flag := MainSession.Prefs.getInt('notify_normalmsg');
    evt_Invite: n_flag := MainSession.Prefs.getInt('notify_invite');
    end;

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
        e.Data.Add('Ping Time: ' + IntToStr(e.elapsed_time) + ' seconds.');
        end;

    evt_Message: begin
        img_idx := 18;
        msg := e.data_type;
        toast := 'Msg from ' + TJabberID.Create(e.from).jid;
        end;

    evt_Invite: begin
        img_idx := 21;
        msg := e.data_type;
        toast := 'Invite from ' + TJabberID.Create(e.from).jid;
        end

    else begin
        img_idx := 12;
        msg := e.data_type;
        toast := msg;
        end;
    end;


    if (n_flag and notify_toast) > 0 then
        ShowRiserWindow(toast, img_idx);

    if (n_flag and notify_flash) > 0 then
        FlashWindow(Self.Handle, true);

    if MainSession.Prefs.getBool('expanded') then begin
        getMsgQueue().LogEvent(e, msg, img_idx);
        end
    else if (e.delayed) then begin
        // we are collapsed, just display in regular windows
        mqueue := getMsgQueue();
        mqueue.Show;
        mqueue.LogEvent(e, msg, img_idx);
        end
    else
        ShowEvent(e);
end;

{---------------------------------------}
procedure TExodus.btnConnectClick(Sender: TObject);
begin
    // connect to the server
    if MainSession.Stream.Active then
        MainSession.Disconnect
    else
        ShowLogin;
end;

{---------------------------------------}
procedure TExodus.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    // Unregister callbacks, etc.

    if (MainSession.Stream.Active) then
        MainSession.Disconnect();

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

    MainSession.Prefs.SavePosition(Self);
    if (frmMsgQueue <> nil) then begin
        frmMsgQueue.lstEvents.Items.Clear;
        frmMsgQueue.Close;
        end;

    if MainSession <> nil then begin
        _event := next_Exit;
        if frmDebug <> nil then
            frmDebug.Close;
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


end;

{---------------------------------------}
procedure TExodus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Shell_NotifyIcon(NIM_DELETE, @_tray);
    Action := caFree;
end;

{---------------------------------------}
procedure TExodus.nextTimerTimer(Sender: TObject);
begin
    if _event = next_Exit then
        Self.Close
    else if _event = next_Disconnect then
        MainSession.Disconnect();
end;

{---------------------------------------}
procedure TExodus.btnOnlineRosterClick(Sender: TObject);
var
    e: boolean;
begin
    // show only online
    with MainSession.Prefs do begin
        e := getBool('roster_only_online');
        e := not e;
        setBool('roster_only_online', e);
        btnOnlineRoster.Down := e;
        end;

    if MainSession.Stream.Active then
        frmRosterWindow.Redraw;
end;

{---------------------------------------}
procedure TExodus.btnAddContactClick(Sender: TObject);
begin
    // add a contact
    ShowAddContact;
end;

{---------------------------------------}
procedure TExodus.mnuConferenceClick(Sender: TObject);
begin
    // Join a TC Room
    StartJoinRoom;
end;

{---------------------------------------}
procedure TExodus.FormResize(Sender: TObject);
begin
    if MainSession <> nil then
        MainSession.Prefs.SavePosition(Self);
end;

{---------------------------------------}
procedure TExodus.Preferences1Click(Sender: TObject);
begin
    // Show the prefs
    StartPrefs;
end;

{---------------------------------------}
procedure TExodus.btnExpandedClick(Sender: TObject);
var
    delta, w: longint;
    newval: boolean;
    docked: TfrmDockable;
begin
    // either expand or compress the whole thing
    newval := not MainSession.Prefs.getBool('expanded');
    mnuExpanded.Checked := newval;
    delta := Self.ClientWidth - tbsMsg.Width + Splitter1.Width;

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
procedure TExodus.restoreEvents(expanded: boolean);
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
            tbsMsg.TabVisible := true;

            // make sure the MsgQueue window is docked
            if (frmMsgQueue <> nil) then begin
                frmMsgQueue.ManualDock(pnlRight, nil, alClient);
                frmMsgQueue.Show;
                end;

            // make sure the debug window is docked
            activeTab := Tabs.ActivePageIndex;
            if ((frmDebug <> nil) and (not frmDebug.Docked)) then begin
                frmDebug.DockForm;
                frmDebug.Show;
                end;

            Tabs.ActivePageIndex := activeTab;
            end
        else begin
            w := pnlRight.Width;
            setInt('event_width', w);
            tbsMsg.TabVisible := false;
            //tbsDebug.TabVisible := false;
            Tabs.Docksite := false;
            Tabs.ActivePage := tbsMsg;
            pnlRoster.align := alClient;

            // make sure debug window is hidden and undocked
            if ((frmDebug <> nil) and (frmDebug.Docked)) then begin
                frmDebug.Hide;
                frmDebug.FloatForm;
                end;
            end;
        end;
end;

{---------------------------------------}
procedure TExodus.ClearMessages1Click(Sender: TObject);
begin
    // Clear events from the list view.
    if (frmMsgQueue <> nil) then
        frmMsgQueue.lstEvents.Items.Clear;
end;

{---------------------------------------}
procedure TExodus.WMWindowPosChanging(var msg: TWMWindowPosChanging);
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
procedure TExodus.FormShow(Sender: TObject);
begin
    _noMoveCheck := false;
end;

{---------------------------------------}
procedure TExodus.btnDelPersonClick(Sender: TObject);
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
procedure TExodus.ShowXML1Click(Sender: TObject);
begin
    // show the debug window if it's hidden
    if (frmDebug = nil) then
        frmDebug := TfrmDebug.Create(nil);
    frmDebug.ShowDefault();
end;

{---------------------------------------}
procedure TExodus.Splitter1Moved(Sender: TObject);
begin
    // Save the current width
    MainSession.Prefs.setInt('event_width', pnlRight.Width);
end;

{---------------------------------------}
procedure TExodus.Exit2Click(Sender: TObject);
begin
    _shutdown := true;
    Self.Close;
end;

{---------------------------------------}
procedure TExodus.timFlasherTimer(Sender: TObject);
begin
    _flash := not _flash;
    FlashWindow(Application.Handle, _flash);
end;

{---------------------------------------}
procedure TExodus.JabberorgWebsite1Click(Sender: TObject);
begin
    // goto www.jabber.org
    ShellExecute(0, 'open', 'http://www.jabber.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TExodus.JabberCentralWebsite1Click(Sender: TObject);
begin
    // goto www.jabbecentral.org
    ShellExecute(0, 'open', 'http://www.jabbercentral.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TExodus.About1Click(Sender: TObject);
begin
    // Show some about dialog box
    frmAbout := TfrmAbout.Create(nil);
    frmAbout.ShowModal;
end;

{---------------------------------------}
procedure TExodus.presOnlineClick(Sender: TObject);
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
procedure TExodus.mnuMyVCardClick(Sender: TObject);
begin
    ShowMyProfile();
end;

{---------------------------------------}
procedure TExodus.mnuToolbarClick(Sender: TObject);
begin
    // toggle toolbar on/off
    Toolbar.Visible := not Toolbar.Visible;
    mnuToolbar.Checked := Toolbar.Visible;
    MainSession.Prefs.setBool('toolbar', Toolbar.Visible);
end;

{---------------------------------------}
procedure TExodus.NewGroup2Click(Sender: TObject);
var
    new_grp: string;
    gl: TStringList;
begin
    // Add a roster grp.
    new_grp := 'Untitled Group';
    if InputQuery('New Roster Group',
        'Enter new group name: ', new_grp) = false then exit;

    // add the new grp.
    gl := MainSession.Roster.GrpList;
    if (gl.IndexOf(new_grp) >= 0) then begin
        // this grp already exists
        MessageDlg('This group already exists!',
            mtError, [mbOK], 0);
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
procedure TExodus.timAutoAwayTimer(Sender: TObject);
var
    mins, away, xa: integer;
    cur_idle: longword;
    dmsg: string;
    last_info: TLastInputInfo;
begin
    // get the latest idle amount
    if (MainSession = nil) then exit;
    if (not MainSession.Stream.Active) then exit;

    with MainSession.Prefs do begin
        if ((_auto_away)) then begin
            if (_windows_ver < cWIN_2000) then begin
                if (_lpHookRec <> nil) then
                    last_tick := _lpHookRec^.LastTick
                else
                    exit;
                end
            else begin
                // use GetLastInputInfo
                last_info.cbSize := sizeof(last_info);
                if (GetLastInputInfo(last_info)) then
                    last_tick := last_info.dwTime
                else
                    exit;
                end;
            cur_idle := (GetTickCount() - last_tick) div 1000;
            mins := cur_idle div 60;

            if (not _is_autoaway) and (not _is_autoxa) then begin
                dmsg := 'Idle Check: ' + BoolToStr(_is_autoaway, true) + ', ' +
                    BoolToStr(_is_autoxa, true) + ', ' +
                    IntToStr(cur_idle ) + ' secs'#13#10;
                DebugMsg(dmsg);
                end;

            away := getInt('away_time');
            xa := getInt('xa_time');

            if ((mins = 0) and ((_is_autoaway) or (_is_autoxa))) then SetAutoAvailable()
            else if (_is_autoxa) then exit
            else if ((mins >= xa) and (_is_autoaway)) then SetAutoXA()
            else if ((mins >= away) and (not _is_autoaway)) then SetAutoAway();
            end;
        end;
end;

{---------------------------------------}
procedure TExodus.SetAutoAway;
begin
    // set us to away
    DebugMsg('Setting AutoAway '#13#10);
    Application.ProcessMessages;

    MainSession.Pause();
    if ((MainSession.Show = 'away') or
        (MainSession.Show = 'xa') or
        (MainSession.Show = 'dnd')) then exit;

    _last_show := MainSession.Show;
    _last_status := MainSession.Status;

    MainSession.SetPresence('away', MainSession.prefs.getString('away_status'),
        MainSession.Priority);

    _is_autoaway := true;
    _is_autoxa := false;

    timAutoAway.Interval := 1000;
end;

{---------------------------------------}
procedure TExodus.SetAutoXA;
begin
    // set us to xa
    DebugMsg('Setting AutoXA '#13#10);
    _is_autoaway := false;
    _is_autoxa := true;

    MainSession.SetPresence('xa', MainSession.prefs.getString('xa_status'),
        MainSession.Priority);
end;

{---------------------------------------}
procedure TExodus.SetAutoAvailable;
begin
    // reset our status to available
    DebugMsg('Setting Auto Available'#13#10);
    timAutoAway.Enabled := false;
    timAutoAway.Interval := 10000;
    _is_autoaway := false;
    _is_autoxa := false;
    MainSession.SetPresence(_last_show, _last_status, MainSession.Priority);
    timAutoAway.Enabled := true;

    MainSession.Play();
end;

{---------------------------------------}
procedure TExodus.MessageHistory2Click(Sender: TObject);
begin
    frmRosterWindow.popHistoryClick(Sender);
end;

{---------------------------------------}
procedure TExodus.Properties2Click(Sender: TObject);
begin
    frmRosterWindow.popPropertiesClick(Sender);
end;

{---------------------------------------}
procedure TExodus.mnuVCardClick(Sender: TObject);
var
    jid: string;
begin
    // lookup some arbitrary vcard..
    if InputQuery('Lookup Profile', 'Enter Jabber ID:', jid) then
        ShowProfile(jid);
end;

{---------------------------------------}
procedure TExodus.SearchforPerson1Click(Sender: TObject);
begin
    // Start a default search
    StartSearch(MainSession.MyAgents.getFirstSearch);
end;

{---------------------------------------}
procedure TExodus.TabsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    tab: integer;
begin
    // select a tab automatically if we have a right click.
    if Button = mbRight then begin
        tab := Tabs.IndexOfTabAt(X,Y);
        if (tab <> Tabs.ActivePageIndex) then
            Tabs.ActivePageIndex := tab;
        end;
end;

{---------------------------------------}
function TExodus.getTabForm(tab: TTabSheet): TForm;
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
procedure TExodus.popCloseTabClick(Sender: TObject);
var
    t: TTabSheet;
    f: TForm;
begin
    // Close the window docked to this tab..
    if Tabs.ActivePageIndex = 0 then exit;
    t := Tabs.ActivePage;
    f := getTabForm(t);
    if (f <> nil) then
        f.Close();
end;

{---------------------------------------}
procedure TExodus.popFloatTabClick(Sender: TObject);
var
    t: TTabSheet;
    f: TForm;
begin
    // Undock this window
    if Tabs.ActivePageIndex = 0 then exit;

    t := Tabs.ActivePage;
    f := getTabForm(t);
    if ((f <> nil) and (f is TfrmDockable)) then
        TfrmDockable(f).FloatForm();
end;

{---------------------------------------}
procedure TExodus.mnuChatClick(Sender: TObject);
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

    if InputQuery('Start Chat', 'Enter Jabber ID:', jid) then
        StartChat(jid, '', true);
end;

{---------------------------------------}
procedure TExodus.mnuBookmarkClick(Sender: TObject);
begin
    // Add a new bookmark to our list..
    ShowBookmark('');
end;

{---------------------------------------}
procedure TExodus.presCustomClick(Sender: TObject);
begin
    // Custom presence
    ShowCustomPresence();
end;

{---------------------------------------}
procedure TExodus.presCustomPresClick(Sender: TObject);
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
procedure TExodus.trayShowClick(Sender: TObject);
begin
    // Show the application from the popup Menu
    _hidden := false;
    ShowWindow(Handle, SW_RESTORE);
end;

{---------------------------------------}
procedure TExodus.trayExitClick(Sender: TObject);
begin
    // Close the application
    Self.Close;
end;

{---------------------------------------}
procedure TExodus.FormActivate(Sender: TObject);
begin
    // FlashWindow(Self.Handle, false);
end;

{---------------------------------------}
function TExodus.IsAutoAway(): boolean;
begin
    Result := _is_autoaway;
end;

{---------------------------------------}
function TExodus.IsAutoXA(): boolean;
begin
    Result := _is_autoxa;
end;

{---------------------------------------}
procedure TExodus.ResetLastTick(value: longint);
begin
    if (_windows_ver >= cWIN_2000) then exit;

    DebugMsg('Setting LastTick to ' + IntToStr(value) + ', Current=' + IntToStr(GetTickCount()) + ''#13#10);
    _lpHookRec^.LastTick := value;
end;

{---------------------------------------}
procedure TExodus.WinJabWebsite1Click(Sender: TObject);
begin
    // goto exodus.sf.net
    ShellExecute(0, 'open', 'http://exodus.sf.net', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TExodus.JabberBugzilla1Click(Sender: TObject);
begin
    // submit a bug on SF.
    ShellExecute(0, 'open', 'http://sourceforge.net/tracker/?func=add&group_id=2049&atid=202049', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TExodus.mnuVersionClick(Sender: TObject);
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


end.

