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
    GUIFactory,
    ExResponders, 
    ExEvents,
    RosterWindow,
    Presence,
    XMLTag,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ScktComp, StdCtrls, ComCtrls, Menus, ImgList, ExtCtrls,
    Buttons, OleCtrls, AppEvnts, ToolWin;

const
    UpdateKey = '001';

type
    TNextEventType = (next_none, next_Exit, next_Login);

type
  TfrmJabber = class(TForm)
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
    Version1: TMenuItem;
    Time1: TMenuItem;
    vCard1: TMenuItem;
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
    lstEvents: TListView;
    N1: TMenuItem;
    N2: TMenuItem;
    timFader: TTimer;
    timFlasher: TTimer;
    N3: TMenuItem;
    mnuOnline: TMenuItem;
    mnuToolbar: TMenuItem;
    mnuStatBar: TMenuItem;
    View1: TMenuItem;
    Toolbar: TCoolBar;
    ToolBar1: TToolBar;
    btnConnect: TToolButton;
    ImageList1: TImageList;
    btnOnlineRoster: TToolButton;
    btnAddContact: TToolButton;
    btnDelContact: TToolButton;
    btnExpanded: TToolButton;
    timAutoAway: TTimer;
    Meeting1: TMenuItem;
    popTabs: TPopupMenu;
    popCloseTab: TMenuItem;
    popFloatTab: TMenuItem;
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
    procedure lstEventsDblClick(Sender: TObject);
    procedure lstEventsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnDelPersonClick(Sender: TObject);
    procedure ShowXML1Click(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure timFaderTimer(Sender: TObject);
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
  private
    { Private declarations }
    _event: TNextEventType;
    _noMoveCheck: boolean;
    _fade: boolean;
    _flash: boolean;
    _edge_snap: integer;
    _fade_limit: integer;
    _guibuilder: TGUIFactory;

    _is_autoaway: boolean;
    _is_autoxa: boolean;
    _is_min: boolean;
    _last_show: string;
    _last_status: string;

    _version: TVersionResponder;
    _time: TTimeResponder;
    _last: TLastResponder;
    _browse: TBrowseResponder;


    // Callbacks
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure MsgCallback(event: string; tag: TXMLTag);
    procedure iqCallback(event: string; tag: TXMLTag);

    procedure restoreEvents(expanded: boolean);
    procedure restoreToolbar;
    procedure restoreAlpha;
    procedure restoreMenus(enable: boolean);
  protected
    // Window message handlers
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSysCommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
    procedure WMWindowPosChanging(var msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
  public
    // other stuff..
    function  getTabForm(tab: TTabSheet): TForm;
    
    procedure RenderEvent(e: TJabberEvent);
    procedure CTCPCallback(event: string; tag: TXMLTag);
  end;

var
    frmJabber: TfrmJabber;

{$Warnings Off}
function IdleUIInit(): boolean; stdcall; external 'IdleUI.dll' index 2;
function IdleUIGetLastInputTime(): DWORD; stdcall; external 'IdleUI.dll' index 1;
procedure IdleUITerm(); stdcall; external 'IdleUI.dll' index 3;
{$Warnings On}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
const
    PosKey = '\Software\Jabber\Exodus\Positions';
    MaxIcons = 64;      // How many icons are in icons.res ??

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
    JUD,
    Transfer, Profile,
    RiserWindow, RemoveContact,
    ShellAPI,
    MsgRecv, Prefs, Dockable,
    JoinRoom, Login, ChatWin, RosterAdd,
    VCard, PrefController, Roster, S10n,
    Session, Debug, About;

{$R *.DFM}

{---------------------------------------}
procedure TfrmJabber.CreateParams(var Params: TCreateParams);
begin
    // Make each window appear on the task bar.
    inherited CreateParams(Params);
    with Params do begin
        ExStyle := ExStyle or WS_EX_APPWINDOW;
        WndParent := GetDesktopWindow();
        end;
end;

{---------------------------------------}
procedure TfrmJabber.WMSysCommand(var msg: TWmSysCommand);
begin
    case (msg.CmdType and $FFF0) of
    SC_MINIMIZE: begin
        ShowWindow(Handle, SW_MINIMIZE);
        msg.Result := 0;
        end;
    SC_RESTORE: begin
        ShowWindow(Handle, SW_RESTORE);
        msg.Result := 0;
        end;
    else
        inherited;
    end;
end;

{---------------------------------------}
procedure TfrmJabber.FormCreate(Sender: TObject);
var
    exp: boolean;
    profile: TJabberProfile;
begin
    // We should already have the wjSession

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

    // Create our main Session object
    MainSession := TJabberSession.Create;
    _guibuilder := TGUIFactory.Create();
    _guibuilder.SetSession(MainSession);
    
    with MainSession.Prefs do begin
        RestorePosition(Self);

        // If we have no profiles, setup some default
        if Profiles.Count = 0 then begin
            profile := MainSession.Prefs.CreateProfile('Default Profile');
            profile.Server := 'jabber.org';
            profile.Resource := 'Exodus';
            profile.Priority := 0;
            end;
        SaveProfiles();
        end;

    // Setup callbacks
    MainSession.RegisterCallback(SessionCallback, '/session');
    MainSession.RegisterCallback(MsgCallback, '/packet/message');
    MainSession.RegisterCallback(iqCallback, '/packet/iq[@type="set"]/query[@xmlns="jabber:iq:oob"]');

    // Create responders to other queries on us.
    _version := TVersionResponder.Create(MainSession);
    _time := TTimeResponder.Create(MainSession);
    _last := TLastResponder.Create(MainSession);
    _browse := TBrowseResponder.Create(MainSession);

    Tabs.ActivePage := tbsMsg;
    restoreToolbar();

    exp := MainSession.Prefs.getBool('expanded');

    if exp then begin
        lstEvents.Width := MainSession.Prefs.getInt('event_width')
        end
    else begin
        lstEvents.Visible := false;
        end;
    restoreEvents(exp);
    _noMoveCheck := false;
    _flash := false;
    restoreAlpha();
    restoreMenus(false);

    // Setup the IdleUI stuff..
    _is_autoaway := false;
    _is_autoxa := false;
    _is_min := false;
    IdleUIInit();

end;

{---------------------------------------}
procedure TfrmJabber.SessionCallback(event: string; tag: TXMLTag);
var
    p: TJabberPres;
begin
    // session events
    if event = '/session/connected' then begin
        btnConnect.Down := true;
        Self.Caption := 'Exodus - ' + MainSession.Username + '@' + MainSession.Server;
        end;

    if event = '/session/autherror' then begin
        MessageDlg('There was an error trying to authenticate you. Please try again, or create a new account',
            mtError, [mbOK], 0);
        ShowLogin();
        exit;
        end;

    if event = '/session/noaccount' then begin
        if (MessageDlg('This account does not exist on this server. Create a new account?',
            mtConfirmation, [mbYes, mbNo], 0) = mrNo) then exit;

        // create a new account
        MainSession.CreateAccount();
        end;

    if event = '/session/authenticated' then with MainSession do begin
        Roster.Fetch;
        p := TJabberPres.Create;
        p.Status := 'available';
        SendTag(p);
        SubController := TSubController.Create;
        Tabs.ActivePage := tbsMsg;
        restoreMenus(true);
        end;

    if event = '/session/disconnected' then begin
        if _event <> next_none then
            nextTimer.Enabled := true;
        lstEvents.Items.Clear;
        Self.Caption := 'Exodus';
        btnConnect.Down := false;
        restoreMenus(false);
        end;

    if event = '/session/commerror' then begin
        MessageDlg('There was an error during communication with the Jabber Server',
            mtError, [mbOK], 0);
        end;

    if event = '/session/prefs' then begin
        restoreToolbar();
        restoreAlpha();
        restoreEvents(MainSession.Prefs.getBool('expanded'));
        if not MainSession.Prefs.getBool('expanded') then
            tbsMsg.TabVisible := false;
        end;
end;

{---------------------------------------}
procedure TfrmJabber.restoreToolbar;
begin
    with MainSession.Prefs do begin
        _edge_snap := getInt('edge_snap');
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
procedure TfrmJabber.restoreAlpha;
var
    alpha: boolean;
begin
    with MainSession.Prefs do begin
        alpha := getBool('roster_alpha');
        _fade := getBool('roster_fade');
        _fade_limit := getInt('fade_limit');
        Self.AlphaBlend := (alpha or _fade);
        if alpha then
            Self.AlphaBlendValue := MainSession.Prefs.getInt('roster_alpha_val')
        else
            Self.AlphaBlendValue := 255;
        if _fade then
            Self.FormStyle := fsStayOnTop
        else
            Self.FormStyle := fsNormal;
        end;
end;

{---------------------------------------}
procedure TfrmJabber.restoreMenus(enable: boolean);
begin
    // (dis)enable the menus
    mnuMessage.Enabled := enable;
    mnuChat.Enabled := enable;
    mnuConference.Enabled := enable;
    mnuPassword.Enabled := enable;

    mnuContacts.Enabled := enable;
    mnuPresence.Enabled := enable;

    mnuMyVCard.Enabled := enable;
    mnuVCard.Enabled := enable;

    mnuBookmark.Enabled := enable;
    mnuFilters.Enabled := enable;
    mnuBrowser.Enabled := enable;
    mnuServer.Enabled := enable;
end;

{---------------------------------------}
procedure TfrmJabber.iqCallback(event: string; tag: TXMLTag);
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
procedure TfrmJabber.MsgCallback(event: string; tag: TXMLTag);
var
    mtype: string;
    e: TJabberEvent;
begin
    // record the event
    mtype := tag.getAttribute('type');
    if ((mtype <> 'groupchat') and (mtype <> 'chat')) then begin
        e := CreateJabberEvent(tag);
        RenderEvent(e);
        end;
end;

{---------------------------------------}
procedure TfrmJabber.CTCPCallback(event: string; tag: TXMLTag);
var
    e: TJabberEvent;
begin
    // record some kind of CTCP result
    if ((tag <> nil) and (tag.getAttribute('type') = 'result')) then begin
        e := CreateJabberEvent(tag);
        RenderEvent(e);
        end
end;

{---------------------------------------}
procedure TfrmJabber.RenderEvent(e: TJabberEvent);
var
    n_flag: integer;
    item: TListItem;
begin
    // create a listview item for this event
    case e.eType of
    evt_Message: begin
        n_flag := MainSession.Prefs.getInt('notify_normalmsg');
        if (n_flag and notify_toast) > 0 then
            ShowRiserWindow('Msg from ' + e.from, 18);
        end;
    end;

    if MainSession.Prefs.getBool('expanded') then begin
        item := lstEvents.Items.Add;
        item.Caption := e.from;
        item.Data := e;

        case e.etype of
        evt_Presence: begin
            if  (e.data_type = 'subscribe') or
                (e.data_type = 'subscribed') or
                (e.data_type = 'unsubscribe') or
                (e.data_type = 'unsubscribed') then
                item.ImageIndex := 16
            else if (e.data_type = 'available') then
                item.ImageIndex := 1
            else if (e.data_type = 'unavailable') then
                item.ImageIndex := 0
            else if (e.data_type = 'away') then
                item.ImageIndex := 2
            else if (e.data_type = 'dnd') then
                item.ImageIndex := 3
            else if (e.data_type = 'chat') then
                item.ImageIndex := 4
            else if (e.data_type = 'xa') then
                item.ImageIndex := 10;
            item.SubItems.Add(e.data[0]);
            end;

        evt_Message: begin
            item.ImageIndex := 18;
            item.SubItems.Add(e.data_type);
            end;

        evt_Invite: begin
            item.ImageIndex := 21;
            item.SubItems.Add(e.data_type);
            end

        else begin
            item.ImageIndex := 12;
            item.SubItems.Add(e.data_type);
            end;
        end;

        end
    else begin
        // we are collapsed, just display in regular windows
        ShowEvent(e);
        end;
end;

{---------------------------------------}
procedure TfrmJabber.btnConnectClick(Sender: TObject);
begin
    // connect to the server
    if MainSession.Stream.Active then
        MainSession.Disconnect
    else
        ShowLogin;
end;

{---------------------------------------}
procedure TfrmJabber.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    MainSession.Prefs.SavePosition(Self);
    lstEvents.Items.Clear;

    if MainSession <> nil then begin
        _event := next_Exit;
        frmDebug.Free;
        frmRosterWindow.Free;
        ChatWin.CloseAllChats();
        MainSession.Free;
        MainSession := nil;
        end;
end;

{---------------------------------------}
procedure TfrmJabber.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmJabber.nextTimerTimer(Sender: TObject);
begin
    if _event = next_Exit then
        Self.Close;
end;

{---------------------------------------}
procedure TfrmJabber.btnOnlineRosterClick(Sender: TObject);
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
procedure TfrmJabber.btnAddContactClick(Sender: TObject);
begin
    // add a contact
    ShowAddContact;
end;

{---------------------------------------}
procedure TfrmJabber.mnuConferenceClick(Sender: TObject);
begin
    // Join a TC Room
    StartJoinRoom;
end;

{---------------------------------------}
procedure TfrmJabber.FormResize(Sender: TObject);
begin
    if MainSession <> nil then
        MainSession.Prefs.SavePosition(Self);
end;

{---------------------------------------}
procedure TfrmJabber.Preferences1Click(Sender: TObject);
begin
    // Show the prefs
    StartPrefs;
end;

{---------------------------------------}
procedure TfrmJabber.btnExpandedClick(Sender: TObject);
var
    delta, w: longint;
    newval: boolean;
    docked: TfrmDockable;
begin
    // either expand or compress the whole thing
    newval := not MainSession.Prefs.getBool('expanded');
    delta := Self.ClientWidth - tbsMsg.Width + Splitter1.Width;

    if newval then begin
        // we are expanded now
        Tabs.DockSite := true;
        w := MainSession.Prefs.getInt('event_width');
        Self.ClientWidth := Self.ClientWidth + w - delta;
        lstEvents.Visible := true;
        pnlRoster.Width := Self.ClientWidth - w;
        lstEvents.Width := w;
        end
    else begin
        // we are compressed now
        w := lstEvents.Width;
        lstEvents.Visible := false;
        MainSession.Prefs.setInt('event_width', w);

        // make sure we undock all of the tabs..
        while (Tabs.DockClientCount > 0) do begin
            docked := TfrmDockable(Tabs.DockClients[0]);
            if (docked = frmDebug) then
                frmDebug.Hide;
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
procedure TfrmJabber.restoreEvents(expanded: boolean);
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
            ew := Self.ClientWidth - w;
            if (ew < 0) then ew := Self.ClientWidth div 2;
            pnlRoster.Width := ew;
            lstEvents.Visible := true;
            lstEvents.Width := w;
            tbsMsg.TabVisible := true;
            // tbsDebug.TabVisible := true;

            // make sure the debug window is docked
            activeTab := Tabs.ActivePageIndex;
            if ((frmDebug <> nil) and (not frmDebug.Docked)) then begin
                frmDebug.DockForm;
                frmDebug.Show;
                end;

            Tabs.ActivePageIndex := activeTab;
            lstEvents.Width := w;
            end
        else begin
            w := lstEvents.Width;
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
procedure TfrmJabber.ClearMessages1Click(Sender: TObject);
begin
    // Clear events from the list view.
    lstEvents.Items.Clear;
end;

{---------------------------------------}
procedure TfrmJabber.lstEventsDblClick(Sender: TObject);
var
    e: TJabberEvent;
begin
    // show info for this node
    if (lstEvents.Selected = nil) then exit;
    e := TJabberEvent(lstEvents.Selected.Data);
    ShowEvent(e);
end;

{---------------------------------------}
procedure TfrmJabber.lstEventsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    i: integer;
begin
    // pickup hot-keys on the list view..
    case Key of
    VK_DELETE, VK_BACK, Ord('d'), Ord('D'): begin
        // delete the selected item
        if lstEvents.Selected <> nil then begin
            i := lstEvents.Selected.Index;
            lstEvents.Items.Delete(i);
            if (i < lstEvents.Items.Count) then
                lstEvents.Selected := lstEvents.Items[i]
            else if (lstEvents.Items.Count > 0) then
                lstEvents.Selected := lstEvents.Items[lstEvents.Items.Count - 1];
            end;
        Key := $0;
        end;
    end;

end;

{---------------------------------------}
procedure TfrmJabber.WMWindowPosChanging(var msg: TWMWindowPosChanging);
var
    r: TRect;
begin
    if _noMoveCheck then exit;
        
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
procedure TfrmJabber.FormShow(Sender: TObject);
begin
    _noMoveCheck := false;
end;

{---------------------------------------}
procedure TfrmJabber.btnDelPersonClick(Sender: TObject);
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
procedure TfrmJabber.ShowXML1Click(Sender: TObject);
begin
    // show the debug window if it's hidden
    if (MainSession.Prefs.getBool('expanded')) then
        // do something here
    else 
        frmDebug.Show;
end;

{---------------------------------------}
procedure TfrmJabber.Splitter1Moved(Sender: TObject);
begin
    // Save the current width
    MainSession.Prefs.setInt('event_width', lstEvents.Width);
end;

{---------------------------------------}
procedure TfrmJabber.timFaderTimer(Sender: TObject);
begin
    // fade the main window's alpha blending to 100
    Self.AlphaBlendValue := Self.AlphaBlendValue - 10;
    if (Self.AlphaBlendValue <= _fade_limit) then
        timFader.Enabled := false;
end;

{---------------------------------------}
procedure TfrmJabber.Exit2Click(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmJabber.timFlasherTimer(Sender: TObject);
begin
    _flash := not _flash;
    FlashWindow(Application.Handle, _flash);
end;

{---------------------------------------}
procedure TfrmJabber.JabberorgWebsite1Click(Sender: TObject);
begin
    // goto www.jabber.org
    ShellExecute(0, 'open', 'http://www.jabber.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmJabber.JabberCentralWebsite1Click(Sender: TObject);
begin
    // goto www.jabbecentral.org
    ShellExecute(0, 'open', 'http://www.jabbercentral.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmJabber.About1Click(Sender: TObject);
begin
    // Show some about dialog box
    frmAbout := TfrmAbout.Create(nil);
    frmAbout.ShowModal;
end;

{---------------------------------------}
procedure TfrmJabber.presOnlineClick(Sender: TObject);
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
procedure TfrmJabber.mnuMyVCardClick(Sender: TObject);
begin
    ShowMyProfile();
end;

{---------------------------------------}
procedure TfrmJabber.mnuToolbarClick(Sender: TObject);
begin
    // toggle toolbar on/off
    Toolbar.Visible := not Toolbar.Visible;
    MainSession.Prefs.setBool('toolbar', Toolbar.Visible);
end;

{---------------------------------------}
procedure TfrmJabber.NewGroup2Click(Sender: TObject);
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
        frmRosterWindow.RenderGroup(gl.Count - 1);
        end;
end;

{---------------------------------------}
procedure TfrmJabber.timAutoAwayTimer(Sender: TObject);
var
    mins, away, xa: integer;
    cur_idle: dword;
begin    // get the latest idle amount
    with MainSession.Prefs do begin
        if getBool('auto_away') then begin
            cur_idle := (GetTickCount() - IdleUIGetLastInputTime()) div 1000;
            mins := cur_idle div 60;
            // frmDebug.debugMsg('Idle time: ' + IntToStr(cur_idle) + ' secs'#13#10);
            away := getInt('away_time');
            xa := getInt('xa_time');

            if ((mins = 0) and ((_is_autoaway) or (_is_autoxa))) then begin
                if (mins = 0) then begin
                    // reset our status to available
                    MainSession.setPresence(_last_show, _last_status,
                         MainSession.Priority);
                     _is_autoaway := false;
                     _is_autoxa := false;
                     timAutoAway.Interval := 30000;
                     end;
                 end

             else if (_is_autoxa) then
                 exit

             else if ((mins >= xa) and (_is_autoaway)) then begin
                 // set us to xa
                 MainSession.setPresence('xa', getString('xa_status'),
                     MainSession.Priority);
                 _is_autoaway := false;
                 _is_autoxa := true;
                 end
             else if ((mins >= away) and (not _is_autoaway)) then begin
                 // set us to away
                 _last_show := MainSession.Show;
                 _last_status := MainSession.Status;
                 MainSession.setPresence('away', getString('away_status'),
                     MainSession.Priority);
                 _is_autoaway := true;
                 _is_autoxa := false;
                 timAutoAway.Interval := 1000;
                 end;
             end;
         end;
end;
{---------------------------------------}
procedure TfrmJabber.MessageHistory2Click(Sender: TObject);begin
    frmRosterWindow.popHistoryClick(Sender);
end;

{---------------------------------------}
procedure TfrmJabber.Properties2Click(Sender: TObject);
begin
    frmRosterWindow.popPropertiesClick(Sender);
end;

{---------------------------------------}
procedure TfrmJabber.mnuVCardClick(Sender: TObject);
var
    jid: string;
begin
    // lookup some arbitrary vcard..
    if InputQuery('Lookup Profile', 'Enter Jabber ID:', jid) then
        ShowProfile(jid);
end;

{---------------------------------------}
procedure TfrmJabber.SearchforPerson1Click(Sender: TObject);
begin
    // Start a default search
    StartSearch(MainSession.MyAgents.getFirstSearch);
end;

{---------------------------------------}
procedure TfrmJabber.TabsMouseDown(Sender: TObject; Button: TMouseButton;
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
function TfrmJabber.getTabForm(tab: TTabSheet): TForm;
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
procedure TfrmJabber.popCloseTabClick(Sender: TObject);
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

procedure TfrmJabber.popFloatTabClick(Sender: TObject);
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

end.

