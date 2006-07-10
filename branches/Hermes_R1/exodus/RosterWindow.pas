unit RosterWindow;
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
    JabberID, GraphUtil,
    DropTarget, Unicode, XMLTag, Presence, Roster, NodeItem, Avatar,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ComCtrls, ExtCtrls, Buttons, ImgList, Menus, StdCtrls, TntStdCtrls,
    CommCtrl, TntExtCtrls, TntMenus, Grids, TntGrids, TntComCtrls;

const
    WM_SHOWLOGIN = WM_USER + 5273;

    // ToggleGUI states
    gui_disconnected = 0;
    gui_connecting = 1;
    gui_connected = 2;

type

  TfrmRosterWindow = class(TForm)
    treeRoster: TTreeView;
    popRoster: TTntPopupMenu;
    StatBar: TStatusBar;
    popStatus: TTntPopupMenu;
    pnlShow: TPanel;
    ImageList2: TImageList;
    popActions: TTntPopupMenu;
    imgStatus: TPaintBox;
    popGroup: TTntPopupMenu;
    pnlConnect: TPanel;
    pnlAnimation: TPanel;
    aniWait: TAnimate;
    popBookmark: TTntPopupMenu;
    popTransport: TTntPopupMenu;
    imgAd: TImage;
    lblStatus: TTntLabel;
    lblCreate: TTntLabel;
    pnlStatus: TTntPanel;
    lblStatusLink: TTntLabel;
    imgSSL: TImage;
    pnlFind: TPanel;
    txtFind: TTntEdit;
    lblFind: TTntLabel;
    radJID: TTntRadioButton;
    radNick: TTntRadioButton;
    btnFindClose: TSpeedButton;
    N7: TTntMenuItem;
    popProperties: TTntMenuItem;
    popRemove: TTntMenuItem;
    popBlock: TTntMenuItem;
    N1: TTntMenuItem;
    popHistory: TTntMenuItem;
    popRename: TTntMenuItem;
    popPresence: TTntMenuItem;
    popClientInfo: TTntMenuItem;
    popSendContacts: TTntMenuItem;
    popInvite: TTntMenuItem;
    popSendFile: TTntMenuItem;
    popMsg: TTntMenuItem;
    popChat: TTntMenuItem;
    popAddGroup: TTntMenuItem;
    popAddContact: TTntMenuItem;
    Custom1: TTntMenuItem;
    N8: TTntMenuItem;
    presDND: TTntMenuItem;
    presXA: TTntMenuItem;
    presAway: TTntMenuItem;
    presChat: TTntMenuItem;
    presOnline: TTntMenuItem;
    popGrpInvisible: TTntMenuItem;
    popGrpAvailable: TTntMenuItem;
    NewGroup1: TTntMenuItem;
    N4: TTntMenuItem;
    popGrpRemove: TTntMenuItem;
    popGrpRename: TTntMenuItem;
    popGroupBlock: TTntMenuItem;
    N3: TTntMenuItem;
    MoveorCopyContacts1: TTntMenuItem;
    SendContactsTo1: TTntMenuItem;
    BroadcastMessage1: TTntMenuItem;
    popGrpInvite: TTntMenuItem;
    popGrpPresence: TTntMenuItem;
    Properties1: TTntMenuItem;
    Delete1: TTntMenuItem;
    N5: TTntMenuItem;
    Join1: TTntMenuItem;
    popTransUnRegister: TTntMenuItem;
    popTransProperties: TTntMenuItem;
    N6: TTntMenuItem;
    popTransLogon: TTntMenuItem;
    popTransLogoff: TTntMenuItem;
    popSendSubscribe: TTntMenuItem;
    N2: TTntMenuItem;
    popSendInvisible: TTntMenuItem;
    popSendPres: TTntMenuItem;
    popTransEdit: TTntMenuItem;
    popLast: TTntMenuItem;
    popTime: TTntMenuItem;
    popVersion: TTntMenuItem;
    autoScroll: TTimer;
    lblConnect: TTntLabel;
    lblNewUser: TTntLabel;
    popProfiles: TTntPopupMenu;
    ModifyProfile1: TTntMenuItem;
    RenameProfile1: TTntMenuItem;
    DeleteProfile1: TTntMenuItem;
    lstProfiles: TTntListView;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure treeRosterDblClick(Sender: TObject);
    procedure treeRosterMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlStatusClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure presAvailableClick(Sender: TObject);
    procedure Panel2DblClick(Sender: TObject);
    procedure treeRosterCollapsed(Sender: TObject; Node: TTreeNode);
    procedure treeRosterExpanded(Sender: TObject; Node: TTreeNode);
    procedure treeRosterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure popVersionClick(Sender: TObject);
    procedure popRosterPopup(Sender: TObject);
    procedure popPropertiesClick(Sender: TObject);
    procedure popRemoveClick(Sender: TObject);
    procedure treeRosterDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure treeRosterDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure treeRosterContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure popHistoryClick(Sender: TObject);
    procedure popChatClick(Sender: TObject);
    procedure popMsgClick(Sender: TObject);
    procedure popSendFileClick(Sender: TObject);
    procedure popAddContactClick(Sender: TObject);
    procedure popAddGroupClick(Sender: TObject);
    procedure popSendPresClick(Sender: TObject);
    procedure popSendSubscribeClick(Sender: TObject);
    procedure treeRosterCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure imgStatusPaint(Sender: TObject);
    procedure popGrpRenameClick(Sender: TObject);
    procedure popGrpRemoveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure popInviteClick(Sender: TObject);
    procedure popGrpInviteClick(Sender: TObject);
    procedure popSendContactsClick(Sender: TObject);
    procedure popBlockClick(Sender: TObject);
    procedure BroadcastMessage1Click(Sender: TObject);
    procedure lblCreateClick(Sender: TObject);
    procedure treeRosterEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure treeRosterEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure treeRosterChange(Sender: TObject; Node: TTreeNode);
    procedure treeRosterExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure popTransLogoffClick(Sender: TObject);
    procedure popTransUnRegisterClick(Sender: TObject);
    procedure imgAdClick(Sender: TObject);
    procedure treeRosterKeyPress(Sender: TObject; var Key: Char);
    procedure popRenameClick(Sender: TObject);
    procedure treeRosterCompare(Sender: TObject; Node1, Node2: TTreeNode;
      Data: Integer; var Compare: Integer);
    procedure pluginClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure treeRosterMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MoveorCopyContacts1Click(Sender: TObject);
    procedure presCustomClick(Sender: TObject);
    procedure txtFindKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtFindChange(Sender: TObject);
    procedure btnFindCloseClick(Sender: TObject);
    procedure presDNDClick(Sender: TObject);
    procedure popTransEditClick(Sender: TObject);
    procedure autoScrollTimer(Sender: TObject);
    procedure lblConnectClick(Sender: TObject);
    procedure lblDeleteClick(Sender: TObject);
    procedure lblModifyClick(Sender: TObject);
    procedure lblNewUserClick(Sender: TObject);
    procedure treeRosterEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure treeRosterStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure treeRosterKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstProfilesKeyPress(Sender: TObject; var Key: Char);
    procedure lstProfilesInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
  private
    { Private declarations }
    _rostercb: integer;             // roster callback id
    _sessionCB: integer;            // session callback id
    _FullRoster: boolean;           // is this a full roster paint?
    _task_collapsed: boolean;
    _show_status: boolean;          // show inline status foo (bar) ?
    _status_color: TColor;          // inline status font color
    _change_node: TTreeNode;        // the current node being changed

    _online: TTreeNode;             // Special group nodes
    _chat: TTreeNode;
    _away: TTreeNode;
    _xa: TTreeNode;
    _dnd: TTreeNode;

    _online_go: TJabberGroup;
    _chat_go: TJabberGroup;
    _away_go: TJabberGroup;
    _xa_go: TJabberGroup;
    _dnd_go: TJabberGroup;

    _hint_text : WideString;        // the hint text for the current node
    _cur_ritem: TJabberRosterItem;  // current roster item selected
    _cur_grp: Widestring;           // current group selected
    _cur_go: TJabberGroup;          // current group object
    _cur_status: integer;           // current status for the current item
    _last_search: integer;          // last item found by search

    _brand_muc: boolean;
    _brand_ft: boolean;

    _collapsed_grps: TWideStringList;
    _blockers: TWideStringlist;     // current list of jids being blocked
    _adURL : string;                // the URL for the ad graphic
    _transports: Widestring;        // current group name for special transports grp
    _roster_unicode: boolean;       // Use unicode chars in the roster?
    _collapse_all: boolean;         // Collapse all groups by default?
    _group_counts: boolean;

    _show_pending: boolean;
    _show_online: boolean;          // Show only "online" contacts
    _show_filter: integer;          // A filter for the <show> types to display
    _sort_roster: boolean;          // Sort roster by <show> types
    _offline_grp: boolean;          // Use the offline grp
    _show_unsub: boolean;           // Show unsubscribed contacts
    _drop_copy: boolean;            // is the drag operation trying to copy?
    _drag_op: boolean;              // Are we doing a drag-n-drop?
    _avatars: boolean;
    _item_height: integer;

    _caps_xp: TXPLite;
    _client_bmp: TBitmap;

    _drop: TExDropTarget;
    _auto_dir: integer;

    g_offline: Widestring;
    g_online: Widestring;
    g_chat: Widestring;
    g_away: Widestring;
    g_xa: Widestring;
    g_dnd: Widestring;
    g_unfiled: Widestring;
    g_bookmarks: Widestring;
    g_myres: Widestring;

    procedure popUnBlockClick(Sender: TObject);
    procedure ExpandNodes();
    procedure RenderNode(ritem: TJabberRosterItem; p: TJabberPres);
    procedure RemoveItemNodes(ritem: TJabberRosterItem);
    procedure RemoveGroupNode(node: TTreeNode);
    procedure ResetPanels;
    procedure ChangeStatusImage(idx: integer);
    procedure showAniStatus();
    procedure DrawNodeText(Node: TTreeNode; State: TCustomDrawState; c1, c2: Widestring);
    procedure InvalidateGrps(node: TTreeNode);
    procedure ExpandGrpNode(n: TTreeNode);
    procedure DrawAvatar(Node: TTreeNode; a: TAvatar);
    procedure DoLogin(idx: integer);
    
    function GetSpecialGroup(var node: TTreeNode; var grp: TJabberGroup; caption: Widestring): TTreeNode;

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMShowLogin(var msg: TMessage); message WM_SHOWLOGIN;

  published
    procedure RosterCallback(event: string; tag: TXMLTag; ritem: TJabberRosterItem);
    procedure SessionCallback(event: string; tag: TXMLTag);

    procedure onURLDrop(p: TPoint; url: Widestring);
  public
    { Public declarations }
    DockOffset: longint;
    Docked: boolean;
    inMessenger: boolean;

    function getNodeType(node: TTreeNode = nil): integer;

    procedure StartFind;
    procedure FindAgain;
    procedure ClearNodes;
    procedure Redraw;
    procedure DockRoster;
    procedure ShowPresence(show: Widestring);

    procedure updateReconnect(secs: integer);
    procedure ShowProfiles();
    procedure ToggleGUI(state: integer);

    function RenderGroup(grp: TJabberGroup): TTreeNode;
    function getSelectedContacts(online: boolean = true): TList;

    property CurRosterItem: TJabberRosterItem read _cur_ritem;
    property CurGroup: Widestring read _cur_grp;
  end;

var
  frmRosterWindow: TfrmRosterWindow;

// Some util functions
procedure setRosterMenuCaptions(online, chat, away, xa, dnd: TTntMenuItem);

implementation
uses
    fProfile, ConnDetails, NewUser, RosterImages,  
    ExSession, XferManager, CustomPres, RegForm, Math,
    JabberConst, Chat, ChatController, GrpManagement, GnuGetText, InputPassword,
    SelContact, Invite, Bookmark, S10n, MsgRecv, PrefController,
    ExEvents, JabberUtils, ExUtils,  Room, Profile, RiserWindow, ShellAPI,
    IQ, RosterAdd, GrpRemove, RemoveContact, ChatWin, Jabber1, 
    Transports, Session, StrUtils;

const
    sRemoveBookmark = 'Remove this bookmark?';
    sRenameGrp = 'Rename group';
    sRenameGrpPrompt = 'New group name:';
    sNoContactsSel = 'You must select one or more contacts.';
    sUnblockContacts = 'Unblock %d contacts?';
    sBlockContacts = 'Block %d contacts?';
    sNoBroadcast = 'You must select more than one online contact to broadcast.';
    sSignOn = 'Click a profile to connect';
    sNewProfile = 'Create a New Profile';
    sCancelLogin = 'Click to Cancel...';
    sDisconnected = 'You are currently disconnected.';
    sConnecting = 'Trying to connect...';
    sAuthenticating = 'Connected. '#13#10'Authenticating...';
    sAuthenticated = 'Authenticated.'#13#10'Getting Contacts...';
    sCancelReconnect = 'Click to Cancel Reconnect';
    sReconnectIn = 'Reconnect in %d seconds.';

    sBtnBlock = 'Block';
    sBtnUnBlock = 'UnBlock';
    sMyResources = 'My Resources';

    sNetMeetingConnError = 'Your connection type does not support direct connections.';

    sRosterAvail = 'Available';
    sRosterChat = 'Free to Chat';
    sRosterAway = 'Away';
    sRosterXA = 'Xtended Away';
    sRosterDND = 'Do Not Disturb';
    sRosterOffline = 'Offline';
    sRosterPending = ' (Pending)';

    sGrpBookmarks = 'Bookmarks';
    sGrpOffline = 'Offline';

    // Profile strings
    sProfileRemove = 'Remove this profile?';
    sProfileDefault = 'Default Profile';
    sProfileNew = 'Untitled Profile';
    sProfileCreate = 'New Profile';
    sProfileNamePrompt = 'Enter Profile Name';


    MIN_WIDTH = 150;

{$R *.DFM}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure setRosterMenuCaptions(online, chat, away, xa, dnd: TTntMenuItem);
begin
    online.Caption := _(sRosterAvail);
    chat.Caption := _(sRosterChat);
    away.Caption := _(sRosterAway);
    xa.Caption := _(sRosterXA);
    dnd.Caption := _(sRosterDND);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmRosterWindow.FormCreate(Sender: TObject);
var
    s : widestring;
begin
    // Deal with fonts & stuff
    inherited;

    AssignUnicodeFont(Self, 9);
    AssignUnicodeFont(lblConnect.Font, 8);
    AssignUnicodeURL(lblCreate.Font, 8);
    AssignUnicodeURL(lblNewUser.Font, 8);
    AssignUnicodeFont(pnlFind.Font, 8);
    StatBar.Font.Size := 8;
    TranslateComponent(Self);

    g_offline := _('Offline');
    g_online := _('Available');
    g_chat := _('Free to Chat');
    g_away := _('Away');
    g_xa := _('Ext. Away');
    g_dnd := _('Do Not Disturb');
    g_unfiled := _('Unfiled');
    g_bookmarks := _('Bookmarks');
    g_myres := _('My Resources');

    lblStatus.Caption := _(sDisconnected);
    lblConnect.Caption := _(sSignOn);
    lblCreate.Caption := _(sNewProfile);

    // Make sure presence menus have unified captions
    setRosterMenuCaptions(presOnline, presChat, presAway, presXA, presDND);

    // register the callback
    _FullRoster := false;
    _collapsed_grps := TWideStringList.Create();
    _blockers := TWideStringlist.Create();
    _rostercb := MainSession.RegisterCallback(RosterCallback, '/roster');
    _sessionCB := MainSession.RegisterCallback(SessionCallback, '/session');
    ChangeStatusImage(0);

    SessionCallback('/session/prefs', nil);
    _task_collapsed := false;
    _online := nil;
    _away := nil;
    _xa := nil;
    _dnd := nil;
    _change_node := nil;
    _show_status := MainSession.Prefs.getBool('inline_status');
    _status_color := TColor(MainSession.Prefs.getInt('inline_color'));
    _transports := MainSession.Prefs.getString('roster_transport_grp');
    _roster_unicode := MainSession.Prefs.getBool('roster_unicode');
    _collapse_all := MainSession.Prefs.getBool('roster_collapsed');
    _group_counts := MainSession.Prefs.getBool('roster_groupcounts');
    _drop := TExDropTarget.Create();
    _drag_op := false;
    _drop_copy := false;

    frmExodus.getCurrentRosterPanel().ShowHint := not _show_status;
    aniWait.Filename := '';
    aniWait.ResName := 'Status';
    pnlConnect.Visible := true;
    pnlConnect.Align := alClient;

    // branding stuff
    with (MainSession.Prefs) do begin
        _brand_muc := getBool('brand_muc');
        _brand_ft := getBool('brand_ft');

        popInvite.Visible := _brand_muc;
        popGrpInvite.Visible := _brand_muc;
        popSendFile.Visible := _brand_ft;
    end;

    ShowProfiles();
    treeRoster.Visible := false;
    pnlStatus.Visible := true;

    ToggleGUI(gui_disconnected);

    treeRoster.Canvas.Pen.Width := 1;

    s := MainSession.Prefs.getString('brand_ad');
    if (s <> '') then begin
        imgAd.Picture.LoadFromFile(ExtractFilePath(Application.EXEName) + s);
        imgAd.Visible := true;
    end;
    _adURL := MainSession.Prefs.getString('brand_ad_url');
    if (_adURL <> '') then
        imgAd.Cursor := crHandPoint;

    _caps_xp := TXPLite.Create('/presence/c[xmlns="http://jabber.org/protocol/caps"]');
    _client_bmp := TBitmap.Create();
end;

{---------------------------------------}
procedure TfrmRosterWindow.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
    frmRosterWindow := nil;
end;

{---------------------------------------}
procedure TfrmRosterWindow.CreateParams(var Params: TCreateParams);
begin
    // Make each window appear on the task bar.
    inherited CreateParams(Params);
    with Params do begin
        ExStyle := ExStyle or WS_EX_APPWINDOW;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.WMShowLogin(var msg: TMessage);
begin
    ShowProfiles();
end;

{---------------------------------------}
procedure TfrmRosterWindow.ShowProfiles();
var
    c, i: integer;
    li: TTntListItem;
begin
    c := MainSession.Prefs.Profiles.Count;

    lstProfiles.Items.Clear();

    for i := 0 to c - 1 do begin
        li := lstProfiles.Items.Add();
        li.ImageIndex := 1;
        li.Caption := MainSession.Prefs.Profiles[i];
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.DoLogin(idx: integer);
var
    p: TJabberProfile;
begin
    p := TJabberProfile(MainSession.Prefs.Profiles.Objects[idx]);

    if ((not p.SavePasswd) and (p.password <> '')) then begin
        p.password := '';
    end;

    if (Trim(p.Resource) = '') then
        p.Resource := getAppInfo().ID;

    // do this for immediate feedback
    ToggleGUI(gui_connecting);
    AssignUnicodeURL(lblConnect.Font, 8);
    lblConnect.Color := pnlConnect.Color;

    if (p.NewAccount) then
      MainSession.NoAuth := false;

    MainSession.Prefs.setInt('profile_active', idx);
    MainSession.Prefs.SaveProfiles();

    // Activate this profile, and fire it UP!
    MainSession.ActivateProfile(idx);

    // XXX: MainSession.Invisible := l.chkInvisible.Checked;
    frmExodus.DoConnect();

end;

{---------------------------------------}
procedure TfrmRosterWindow.ChangeStatusImage(idx: integer);
begin
    _cur_status := idx;
    imgStatus.Repaint();
end;

{---------------------------------------}
procedure TfrmRosterWindow.showAniStatus();
begin
    // show the status animation
    aniWait.Left := (pnlConnect.Width - aniWait.Width) div 2;
    aniWait.Visible := true;
    aniWait.Active := true;
end;

{---------------------------------------}
procedure TfrmRosterWindow.ToggleGUI(state: integer);
begin
    if (state = gui_disconnected) then begin
        ClearNodes();
        ShowPresence('offline');
        MainSession.Roster.Clear();
        pnlAnimation.Visible := false;
        treeRoster.Visible := false;
        aniWait.Active := false;
        aniWait.Visible := false;
        lblCreate.Visible := true;
        lblNewUser.Visible := true;
        lblConnect.Caption := _(sSignOn);
        lblConnect.Color := clWindow;
        lblCreate.Caption := _(sNewProfile);
        lblConnect.Font.Color := clWindowText;
        lblConnect.Font.Style := [];
        lstProfiles.Visible := true;
        pnlConnect.Visible := true;
        pnlConnect.Align := alClient;
        lblStatus.Caption := _(sDisconnected);
        imgSSL.Visible := false;
        AssignUnicodeFont(lblConnect.Font, 8);
    end
    else if (state = gui_connecting) then begin
        pnlAnimation.Visible := true;
        pnlConnect.Visible := true;
        pnlConnect.Align := alClient;
        lblStatus.Visible := true;
        lblStatus.Caption := _(sConnecting);
        lblConnect.Caption := _(sCancelLogin);
        lstProfiles.Visible := false;
        lblCreate.Visible := false;
        lblNewUser.Visible := false;
        AssignUnicodeURL(lblConnect.Font, 8);
        Self.showAniStatus();
    end;
end;


{---------------------------------------}
procedure TfrmRosterWindow.SessionCallback(event: string; tag: TXMLTag);
var
    ritem: TJabberRosterItem;
    b_jid: Widestring;
    imgsrc, restype, resname : Widestring;
    ins: cardinal;
    
begin
    // catch session events
    if event = '/session/disconnected' then begin
        ToggleGUI(gui_disconnected);
    end

    // We are in the process of connecting
    else if event = '/session/connecting' then begin
        ToggleGUI(gui_connecting);
    end

    // we've got a socket connection
    else if event = '/session/connected' then begin
        lblConnect.Caption := _(sCancelLogin);
        lblStatus.Caption := _(sAuthenticating);
        Self.showAniStatus();
        lstProfiles.Visible := false;
        lblCreate.Visible := false;
        lblNewUser.Visible := false;
        ShowPresence('online');
        ResetPanels();
    end

    // we've been authenticated
    else if event = '/session/authenticated' then begin
        lblConnect.Caption := _(sCancelLogin);
        lblStatus.Caption := _(sAuthenticated);
        Self.showAniStatus();
        lstProfiles.Visible := false;
        lblCreate.Visible := false;
        lblNewUser.Visible := false;
    end

    // it's the end of the roster, update the GUI
    else if event = '/roster/end' then begin
        if (not treeRoster.Visible) then begin
            aniWait.Active := false;
            aniWait.Visible := false;
            pnlConnect.Visible := false;
            treeRoster.Visible := true;
            if (_avatars) then begin
                _show_status := true;
                treeRoster.Perform(TVM_SETITEMHEIGHT, _item_height, 0);
            end
            else
                treeRoster.Perform(TVM_SETITEMHEIGHT, -1, 0);
        end;
    end

    // our own presence has changed
    else if event = '/session/presence' then begin
        ShowPresence(MainSession.show);
        imgStatus.Hint := MainSession.Status;
    end

    // preferences have been changed, refresh the roster
    else if event = '/session/prefs' then begin
        MainSession.Prefs.fillStringlist('blockers', _blockers);

        _show_status := MainSession.Prefs.getBool('inline_status');
        _status_color := TColor(MainSession.Prefs.getInt('inline_color'));
        _transports := MainSession.Prefs.getString('roster_transport_grp');
        _roster_unicode := MainSession.Prefs.getBool('roster_unicode');
        _collapse_all := MainSession.Prefs.getBool('roster_collapsed');
        _group_counts := MainSession.Prefs.getBool('roster_groupcounts');

        treeRoster.Font.Name := MainSession.Prefs.getString('roster_font_name');
        treeRoster.Font.Size := MainSession.Prefs.getInt('roster_font_size');
        treeRoster.Font.Color := TColor(MainSession.Prefs.getInt('roster_font_color'));
        treeRoster.Font.Charset := MainSession.Prefs.getInt('roster_font_charset');

        pnlFind.Font.Name := treeRoster.Font.Name;
        pnlFind.Font.Size := treeRoster.Font.Size;

        if (treeRoster.Font.Charset = 0) then
            treeRoster.Font.Charset := 1;

        pnlConnect.Color := TColor(MainSession.prefs.getInt('roster_bg'));
        pnlAnimation.Color := pnlConnect.Color;
        lblStatus.Color := pnlConnect.Color;
        aniWait.Color := pnlConnect.Color;

        MainSession.Prefs.fillStringlist('col_groups', _collapsed_grps);

        _show_online := MainSession.Prefs.getBool('roster_only_online');
        _show_filter := MainSession.Prefs.getInt('roster_filter');
        if (_show_filter = show_offline) then begin
            _show_filter := show_dnd;
            MainSession.Prefs.setInt('roster_filter', _show_filter);
        end;

        _sort_roster := MainSession.Prefs.getBool('roster_sort');
        _show_pending := MainSession.Prefs.getBool('roster_show_pending');
        _offline_grp := MainSession.Prefs.getBool('roster_offline_group');
        _show_unsub := MainSession.Prefs.getBool('roster_show_unsub');
        _avatars := MainSession.Prefs.getBool('roster_avatars');

        frmExodus.pnlRoster.ShowHint := not _show_status;

        BuildPresMenus(TTntMenuItem(popStatus), presAvailableClick);

        Redraw();
    end

    // someone has been blocked
    else if ((event = '/session/block') or (event = '/session/unblock')) then begin
        // re-render this jid if it's in our roster
        b_jid := tag.GetAttribute('jid');
        ritem := MainSession.Roster.Find(b_jid);
        if (ritem <> nil) then begin
            RenderNode(ritem, MainSession.ppdb.FindPres(b_jid, ''));
        end;
        MainSession.Prefs.fillStringlist('col_groups', _collapsed_grps);
    end

    // we are getting server side prefs
    else if event = '/session/server_prefs' then begin
    end

    // we got a new avatar in the cache
    else if (event = '/session/avatars') then begin
        treeRoster.Refresh();
    end

    // image on/off
    else if (event = '/session/adimage/on') then begin
        if (tag <> nil) then begin
            restype := tag.GetAttribute('type');
            resname := tag.GetAttribute('resname');
            imgsrc  := tag.GetAttribute('source');

            if (restype = 'dll') then begin
                ins := LoadLibraryW(PWChar(imgsrc));
                if (ins = 0) then
                    ins := LoadLibrary(PChar(String(imgsrc)));
                if (ins > 0) then begin
                    imgAd.Picture.Bitmap.LoadFromResourceName(ins, resname);
                    FreeLibrary(ins);
                end;
            end;
            {Todo:
            else if (restype = 'file') then begin

            end
            else if (restype = 'resource') then begin


            end;
            }
        end
        else begin
            resname := MainSession.Prefs.getString('brand_ad');
            if (resname <> '') then begin
                imgAd.Picture.LoadFromFile(ExtractFilePath(Application.EXEName) + resname);
            end;
            _adURL := MainSession.Prefs.getString('brand_ad_url');
            if (_adURL <> '') then
                imgAd.Cursor := crHandPoint;
        end;

        imgAd.Visible := true;


    end
    else if (event = '/session/adimage/off') then begin
        imgAd.Visible := false;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.RosterCallback(event: string; tag: TXMLTag; ritem: TJabberRosterItem);
var
    go: TJabberGroup;
    grp_node: TTreeNode;
    grp_rect: TRect;
    p: TJabberPres;
begin
    // callback from the session
    if event = '/roster/start' then begin
        frmExodus.tabs.ActivePage := frmExodus.tbsRoster;
        _FullRoster := true;
        treeRoster.Items.BeginUpdate;
        // Don't clear the nodes here so mod_groups works ok..
        // maybe a better way to handle this??
        // ClearNodes();
    end
    else if event = '/roster/end' then begin
        _FullRoster := false;
        Self.SessionCallback('/roster/end', nil);
        treeRoster.Items.EndUpdate;

        if (not MainSession.Prefs.getBool('roster_collapsed')) then
            Self.ExpandNodes();

        if (treeRoster.items.Count > 0) then
            treeRoster.TopItem := treeRoster.Items[0];

        treeRoster.AlphaSort();
    end
    else if event = '/roster/item' then begin
        if ritem <> nil then begin
            p := MainSession.ppdb.FindPres(ritem.JID.jid, '');
            RenderNode(ritem, p);
        end;
    end
    else if (event = '/roster/group') then begin
        if (tag = nil) then exit;
        
        if (tag.Name = 'group') then begin
            go := MainSession.roster.getGroup(tag.GetAttribute('name'));
            if (go <> nil) then begin
                grp_node := TTreeNode(go.Data);
                if (grp_node = nil) then begin
                    grp_node := RenderGroup(go);
                    go.Data := grp_node;
                end;

                // force a redraw
                grp_rect := grp_node.DisplayRect(false);
                InvalidateRect(treeRoster.Handle, @grp_rect, true);
            end;
        end;
    end
    else if (event = '/roster/remove') then begin
        // only care if this is a bookmark
        if (ritem <> nil) then begin
            if (ritem.Group[0] = g_bookmarks) then
                RemoveItemNodes(ritem);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.ExpandGrpNode(n: TTreeNode);
var
    p: TTreeNode;
    pi: TJabberNodeItem;
    p_grp: Widestring;
begin
    // This sucks, but we have to check for OUR grp, and all possible
    // parents above us are in the collapsed list
    p := n.Parent;
    while (p <> nil) do begin
        if (not p.Expanded) then begin
            pi := TJabberNodeItem(p.Data);
            if (pi is TJabberGroup) then begin
                p_grp := TJabberGroup(pi).Fullname;
                if (_collapsed_grps.indexOf(p_grp) >= 0) then
                    exit;
            end;
            p.Expand(false);
        end;
        p := p.parent;
    end;
    n.Expand(false);
end;

{---------------------------------------}
procedure TfrmRosterWindow.ExpandNodes;
var
    i: integer;
    n: TTreeNode;
    ni: TJabberNodeItem;
    cur_grp: Widestring;
begin
    // expand all nodes except special nodes
    for i := 0 to treeRoster.Items.Count - 1 do begin
        n := treeRoster.Items[i];
        ni := TJabberNodeItem(n.Data);
        assert(ni <> nil);
        if ((ni is TJabberGroup) and (TJabberGroup(ni).AutoExpand)) then begin
            cur_grp := TJabberGroup(ni).Fullname;
            if ((_collapsed_grps.indexOf(cur_grp) = -1)) then
                ExpandGrpNode(n);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.StartFind;
begin
    txtFind.Color := clWindow;
    _last_search := 0;
    pnlFind.Visible := true;
    FormResize(Self);
    txtFind.SetFocus();
end;

{---------------------------------------}
procedure TfrmRosterWindow.FindAgain;
begin
    if (_last_search <> 0) then
        _last_search := _last_search + 1;
    pnlFind.Visible := true;
    FormResize(Self);
    txtFind.SetFocus();
    txtFindChange(self);
end;

{---------------------------------------}
procedure TfrmRosterWindow.ClearNodes;
var
    i:          integer;
    ri:         TJabberRosterItem;
    node_list:  TWideStringlist;
    go:         TJabberGroup;
begin
    treeRoster.Items.BeginUpdate;
    treeRoster.Items.Clear;

    with MainSession.Roster do begin
        // remove the grp list node pointers
        for i := 0 to GroupsCount - 1 do begin
            go := Groups[i];
            go.Data := nil;
        end;

        // remove all item pointers to tree nodes
        for i := 0 to Count - 1 do begin
            ri := TJabberRosterItem(Objects[i]);
            node_list := TWidestringlist(ri.Data);
            if (node_list <> nil) then node_list.Clear;
        end;
    end;

    treeRoster.Items.EndUpdate;
end;

{---------------------------------------}
function TfrmRosterWindow.getNodeType(Node: TTreeNode): integer;
var
    o: TObject;
    n: TTreeNode;
    go: TJabberGroup;
begin
    // return the type of node this is..
    if (Node = nil) then
        n := treeRoster.Selected
    else
        n := Node;

    Result := node_none;
    _cur_ritem := nil;
    _cur_grp := '';

    if (n = nil) then exit;

    o := TObject(n.Data);
    if (o = nil) then exit;

    if ((o is TJabberGroup) or
        ((treeRoster.SelectionCount > 1) and (node = nil))) then begin
        Result := node_grp;

        if (o is TJabberGroup) then begin
            go := TJabberGroup(n.Data);
            _cur_grp := go.FullName;
            _cur_go := go;
        end;

    end
    else if (TObject(n.Data) is TJabberRosterItem) then begin
        Result := node_ritem;
        _cur_ritem := TJabberRosterItem(n.Data);

        // check to see if it's a transport
        if (n.Level > 0) then begin
            go := TJabberGroup(n.Parent.Data);
            if (go.FullName = _transports) then
                Result := node_transport;
        end;
    end;
end;

{---------------------------------------}
function TfrmRosterWindow.getSelectedContacts(online: boolean = true): TList;
var
    c, i: integer;
    ri: TJabberRosterItem;
    node: TTreeNode;
    ntype: integer;
begin
    // return a list of the selected roster items
    Result := TList.Create();

    case getNodeType() of
    node_ritem: begin
        if (((online) and (_cur_ritem.IsOnline)) or (not online)) then
            Result.Add(_cur_ritem);
    end;
    node_grp: begin
        // add all online contacts in this grp to the Result list
        c := treeRoster.SelectionCount;
        if (c = 0) then exit;
        for i := 0 to c - 1 do begin
            node := treeRoster.Selections[i];
            ntype := getNodeType(node);
            if (ntype = node_ritem) then begin
                // add this roster item to the selection
                ri := TJabberRosterItem(node.Data);
                if (((online) and (ri.IsOnline)) or (not online)) then
                    Result.Add(TJabberRosterItem(node.Data));
            end
            else if ((ntype = node_grp) and (_cur_go <> nil)) then begin
                // add this grp to the selection
                _cur_go.getRosterItems(Result, online);
            end;
        end;
    end;
end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.Redraw;
var
    i: integer;
    ri: TJabberRosterItem;
    p: TJabberPres;
    go: TJabberGroup;
begin
    // Make sure we have current settings
    // SessionCallback('/session/prefs', nil);

    // loop through all roster items and draw them
    _FullRoster := true;
    treeRoster.Color := TColor(MainSession.prefs.getInt('roster_bg'));

    if (not _sort_roster) then begin
        // remove availability grps
        if (_online <> nil) then begin
            assert(_online_go <> nil);
            MainSession.roster.removeGroup(_online_go);
            _online.Free();
            _online := nil;
        end;
        if (_chat <> nil) then begin
            assert(_chat_go <> nil);
            Mainsession.roster.removeGroup(_chat_go);
            _chat.Free();
            _chat := nil;
        end;
        if (_xa <> nil) then begin
            assert(_xa_go <> nil);
            Mainsession.roster.removeGroup(_xa_go);
            _xa.Free();
            _xa := nil;
        end;
        if (_dnd <> nil) then begin
            assert(_dnd_go <> nil);
            Mainsession.roster.removeGroup(_dnd_go);
            _dnd.Free();
            _dnd := nil;
        end;
    end;

    // Clear out associated nodes
    ClearNodes;

    // make sure our item heights are setup correctly.
    if (_avatars) then begin
        _item_height := Round(1.7 * (treeRoster.Canvas.TextHeight('Ag'))) + 2;
        treeRoster.Perform(TVM_SETITEMHEIGHT, _item_height, 0);
    end
    else begin
        _item_height := treeRoster.Canvas.TextHeight('Ag') + 2;
        treeRoster.Perform(TVM_SETITEMHEIGHT, -1, 0);
    end;

    // Render everything
    treeRoster.Items.BeginUpdate;

    with MainSession.Roster do begin
        // iterate across all items and render them
        for i := 0 to Count - 1 do begin
            ri := TJabberRosterItem(Objects[i]);
            p := MainSession.ppdb.FindPres(ri.JID.jid, '');
            RenderNode(ri, p);
        end;

        // iterate across the grps, render any empty ones
        for i := 0 to GroupsCount - 1 do begin
            go := Groups[i];
            if ((go.Parent = nil) and (go.isEmpty())) then begin
                if ((go.KeepEmpty) and (go.Data = nil)) then
                    RenderGroup(go)
            end;
        end;
    end;

    _FullRoster := false;
    treeRoster.AlphaSort;
    ExpandNodes();
    if (treeRoster.Items.Count > 0) then
        treeRoster.TopItem := treeRoster.Items[0];
    treeRoster.Items.EndUpdate;
end;

{---------------------------------------}
procedure TfrmRosterWindow.RemoveItemNodes(ritem: TJabberRosterItem);
var
    n, p: TTreeNode;
    node_list: TWidestringlist;
    i: integer;
begin
    // Remove the nodes for this item..
    node_list := TWideStringlist(ritem.Data);
    treeRoster.Items.BeginUpdate();
    if node_list <> nil then begin
        for i := node_list.count - 1 downto 0 do begin
            n := TTreeNode(node_list.Objects[i]);
            p := n.Parent;
            node_list.Delete(i);
            n.Free;
            if ((p <> nil) and (p.Count <= 0)) then
                Self.RemoveGroupNode(p);
        end;
    end;
    treeRoster.Items.EndUpdate();
end;

{---------------------------------------}
procedure TfrmRosterWindow.RemoveGroupNode(node: TTreeNode);
var
    go: TJabberGroup;
begin
    go := TJabberGroup(node.Data);
    if (go = nil) then exit;
    go.Data := nil;
    node.Free();
end;

{---------------------------------------}
procedure TfrmRosterWindow.RenderNode(ritem: TJabberRosterItem; p: TJabberPres);
var
    i, g: integer;
    cur_grp, tmps: Widestring;
    top_item, cur_node, grp_node, n: TTreeNode;
    node_list, tmp_grps: TWideStringlist;
    is_blocked: boolean;
    is_transport: boolean;
    exp_grpnode: boolean;
    resort: boolean;
    node_rect: TRect;
    plevel: integer;
    go: TJabberGroup;
begin
    // Render a specific roster item, with the given presence info.
    is_blocked := MainSession.isBlocked(ritem.jid);
    if (is_blocked) then begin
        if MainSession.Prefs.getBool('roster_hide_block') then exit;
    end;

    // some flags
    is_transport := false;
    resort := false;

    // cache the current top item
    top_item := treeRoster.TopItem;

    {
    --------------- Stage #1 ----------------------
    Here we want to bail on some circumstances
    if the roster item is NOT supposed to be shown
    based on preferences, and the state of the roster
    item, and the current presence info, etc..
    }
    if (not ritem.IsContact) then begin
        // always let non-contact items thru
    end

    else if (ritem.subscription = 'remove') or (ritem.Removed) then begin
        // something is getting removed.. ALWAYS remove it
        RemoveItemNodes(ritem);
        exit;
    end

    else if (ritem.ask = 'subscribe') and (_show_pending) then begin
        // allow these items to pass thru
    end

    else if ((ritem.IsInGroup(_transports)) and
        (ritem.GroupCount = 1)) then begin
        // we have a transport... always let them pass
        is_transport := true;
    end

    else if (ritem.jid.user = '') then begin
        // maybe a transport? let them pass
    end

    else if ((_show_online) and (_show_filter > show_offline)) then begin
        // we are filtering visible contacts

        if (p = nil) then plevel := show_offline
        else if (p.show = 'dnd') then plevel := show_dnd
        else if (p.show = 'xa') then plevel := show_xa
        else if (p.show = 'away') then plevel := show_away
        else plevel := show_available;

        if (plevel < _show_filter) then begin
            // we shouldn't show this ritem
            RemoveItemNodes(ritem);
            exit;
        end;
    end

    else if (_show_unsub) then begin
        // Show all nodes no matter the s10n state
    end

    else if ((ritem.subscription = 'none') or
        (ritem.subscription = '') or
        (ritem.subscription = 'from')) then begin
        // We aren't subscribed to these people,
        // or we are removing them from the roster
        RemoveItemNodes(ritem);
        exit;
    end;

    {
    ------------------- Stage #2 -----------------------
    OK, now deal with groups and existing roster nodes.
    Create a list to contain all nodes for this
    roster item, and assign it to the .Data property
    of the roster item object
    }
    node_list := TWideStringlist(ritem.Data);
    if node_list = nil then begin
        node_list := TWideStringlist.Create;
        ritem.Data := node_list;
    end;

    // Create a temporary list of grps that this
    // contact should be in.
    tmp_grps := TWideStringlist.Create;
    tmp_grps.CaseSensitive := true;

    if (((p = nil) or (p.PresType = 'unavailble')) and (_offline_grp)
        and (ritem.isContact) and (is_transport = false)) then
        // they are offline, and we want an offline grp
        tmp_grps.Add(g_offline)

    else if ((_sort_roster) and (not is_transport) and (ritem.isContact)) then begin
        // We are sorting the roster by <show>
        if (p = nil) then begin
            tmp_grps.Add(g_offline)
        end
        else if (p.Show = 'away') then begin
            tmp_grps.Add(g_away)
        end
        else if (p.Show = 'xa') then begin
            tmp_grps.Add(g_xa)
        end
        else if (p.Show = 'dnd') then begin
            tmp_grps.Add(g_dnd)
        end
        else begin
            tmp_grps.Add(g_online);
        end;
    end

    else
        // otherwise, assign the grps from the roster item
        ritem.AssignGroups(tmp_grps);

    // If they aren't in any grps, put them into the Unfiled grp
    if (tmp_grps.Count <= 0) then begin
        go := MainSession.Roster.AddGroup(g_unfiled);
        go.DragTarget := false;
        if (not go.inGroup(ritem.jid)) then
            go.AddJid(ritem.jid);
        go.setPresence(ritem.jid, p);
        tmp_grps.Add(g_unfiled);
    end;

    // Remove nodes that are in node_list but aren't in the grp list
    // This takes care of changing grps, or going to the offline grp
    for i := node_list.Count - 1 downto 0 do begin
        cur_grp  := node_list[i];
        cur_node := TTreeNode(node_list.Objects[i]);
        if (tmp_grps.IndexOf(cur_grp) < 0) then begin
            grp_node := cur_node.Parent;
            node_list.Delete(i);
            cur_node.Free();
            if (grp_node.Count = 0) then
                RemoveGroupNode(grp_node);
        end;
    end;

    // determine the caption for the node
    if (ritem.Text <> '') then
        tmps := ritem.Text
    else
        tmps := ritem.jid.Full;

    // ---------------------- Stage #3 -------------------------
    // For each grp in the temp. grp list,
    // make sure a node already exists, or create one.
    // For my resources, we need to add each PPDB entry
    for g := 0 to tmp_grps.Count - 1 do begin
        cur_grp := tmp_grps[g];

        // The offline grp is special, we keep a pointer to
        // it at all times (if it exists).
        if (cur_grp = g_online) then begin
            _online := GetSpecialGroup(_online, _online_go, g_online);
            resort := true;
            grp_node := _online;
        end
        else if (cur_grp = g_chat) then begin
            _chat := GetSpecialGroup(_chat, _chat_go, g_chat);
            resort := true;
            grp_node := _chat;
        end
        else if (cur_grp = g_away) then begin
            _away := GetSpecialGroup(_away, _away_go, g_away);
            resort := true;
            grp_node := _away;
        end
        else if (cur_grp = g_xa) then begin
            _xa := GetSpecialGroup(_xa, _xa_go, g_xa);
            resort := true;
            grp_node := _xa;
        end
        else if (cur_grp = g_dnd) then begin
            _dnd := GetSpecialGroup(_dnd, _dnd_go, g_dnd);
            resort := true;
            grp_node := _dnd;
        end

        else begin
            // Make sure the grp exists
            go := MainSession.Roster.addGroup(cur_grp);

            // Make sure we have a node for this grp and keep
            // a pointer to the node in the Roster's grp list
            grp_node := TTreeNode(go.Data);
            if (grp_node = nil) then begin
                grp_node := RenderGroup(go);
            end;
        end;

        // Expand any grps that are not supposed to be collapsed
        if ((not _FullRoster) and
            (_collapsed_grps.IndexOf(cur_grp) < 0) and
            (not _collapse_all)) then
            exp_grpnode := true
        else
            exp_grpnode := false;

        // Now that we are sure we have a grp_node,
        // check to see if this jid node exists under it
        cur_node := nil;

        // find the node for this grp
        i := node_list.indexOf(cur_grp);
        if (i >= 0) then begin
            n := TTreeNode(node_list.Objects[i]);
            cur_node := n;
        end;

        if (cur_node = nil) then begin
            // add a node for this person under this group
            cur_node := treeRoster.Items.AddChild(grp_node, tmps);
            node_list.AddObject(cur_grp, cur_node);
        end;

        cur_node.Text := String(tmps);
        cur_node.Data := ritem;
        cur_node.ImageIndex := ritem.ImageIndex;
        cur_node.SelectedIndex := ritem.ImageIndex;

        // only invalid if we're not doing a full roster draw.
        if ((not _FullRoster) and (grp_node <> nil)) then begin
            if (exp_grpnode) then ExpandGrpNode(grp_node);
            node_rect := cur_node.DisplayRect(false);

            // invalidate just the rect which contains our node
            if (cur_node.IsVisible) then
                InvalidateRect(treeRoster.Handle, @node_rect, false);

            // if we showing grp counts, then invalidate the grp rect as well.
            if ((_group_counts) and (grp_node.isVisible)) then
                InvalidateGrps(cur_node);
        end;
    end;

    tmp_grps.Free();

    {
    Finally, If this isn't a full roster push,
    Make sure the roster is alpha sorted, and
    check for any empty groups
    }
    if not _FullRoster then begin
        if (resort) then
            treeRoster.AlphaSort;
        if ((treeRoster.Items.Count > 0) and (top_item <> nil)) then
            treeRoster.TopItem := top_item;
    end;
end;

{---------------------------------------}
function TfrmRosterWindow.GetSpecialGroup(var node: TTreeNode; var grp: TJabberGroup; caption: Widestring): TTreeNode;
begin
    if (node = nil) then begin
        node := treeRoster.Items.AddChild(nil, caption);
        node.ImageIndex := RosterTreeImages.Find('closed_group');
        node.SelectedIndex := node.ImageIndex;
        grp := MainSession.Roster.addGroup(caption);
        node.Data := grp;
    end;

    Result := node;
end;

{---------------------------------------}
procedure TfrmRosterWindow.InvalidateGrps(node: TTreeNode);
var
    n: TTreeNode;
    grp_rect: TRect;
begin
    // invalidate all grp nodes above this roster item
    n := node.Parent;
    while (n <> nil) do begin
        grp_rect := n.DisplayRect(false);
        InvalidateRect(treeRoster.Handle, @grp_rect, false);
        n := n.Parent;
    end;
end;

{---------------------------------------}
function TfrmRosterWindow.RenderGroup(grp: TJabberGroup): TTreeNode;
var
    n: integer;
    p, grp_node: TTreeNode;
    sep, path, part, cur_grp: Widestring;
    sub: TJabberGroup;
begin
    // Show this group node
    cur_grp := grp.getText();

    treeRoster.Items.BeginUpdate();

    n := 0;
    p := nil;
    path := '';
    repeat
        part := grp.Parts[n];
        sep := MainSession.prefs.getString('group_seperator');
        if (path <> '') then path := path + sep;
        path := path + part;
        if (n = (grp.NestLevel - 1)) then begin
            // create the final grp
            grp_node := treeRoster.Items.AddChild(p, part);
            grp_node.Data := grp;
        end
        else begin
            sub := MainSession.Roster.addGroup(path);
            grp_node := TTreeNode(sub.Data);
            if (grp_node = nil) then begin
                grp_node := treeRoster.Items.AddChild(p, part);
                grp_node.Data := sub;
                sub.Data := grp_node;
            end;
        end;

        p := grp_node;
        grp_node.ImageIndex := RosterTreeImages.Find('closed_group');
        grp_node.SelectedIndex := grp_node.ImageIndex;
        inc(n);
    until (n = grp.NestLevel);

    grp.Data := grp_node;
    treeRoster.AlphaSort(true);
    treeRoster.Items.EndUpdate();

    result := grp_node;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterDblClick(Sender: TObject);
begin
    // Chat with this person
    _change_node := nil;
    if (getNodeType() = node_ritem) then
        // Fire the associated event with this item
        MainSession.FireEvent(_cur_ritem.Action, _cur_ritem.Tag);
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
    Node : TTreeNode;
    ri  : TJabberRosterItem;
begin
    // Handle the changing of the treeview Hints
    // Based on the current node we are hovering over.
    _hint_text := '';
    Node := treeRoster.GetNodeAt(x,y);
    if (Node = nil) then exit;

    // For groups just display the group name:
    if (TObject(Node.Data) is TJabberGroup) then begin
        _hint_text := TJabberGroup(Node.Data).getText();
    end
    else if (TObject(Node.Data) is TJabberRosterItem) then begin
        ri := TJabberRosterItem(Node.Data);
        if ri = nil then exit;
        _hint_text := ri.Tooltip;
    end
    else
        _hint_text := '';

    if _hint_text = treeRoster.Hint then exit;
    treeRoster.Hint := _hint_text;
    Application.CancelHint;
end;

{---------------------------------------}
procedure TfrmRosterWindow.pnlStatusClick(Sender: TObject);
var
    cp : TPoint;
begin
    // popup the menu and to change our status
    if MainSession.Active then begin
        GetCursorPos(cp);
        popStatus.Popup(cp.x, cp.y);
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.DockRoster;
begin
    // dock the window to the main form
    StatBar.Visible := false;
    if (MainSession.Prefs.GetBool('roster_messenger')) then begin
        Self.ManualDock(frmExodus.pnlRoster, nil, alClient);
        inMessenger := true;
    end
    else begin
        Self.ManualDock(frmExodus.pnlLeft, nil, alClient);
        inMessenger := false;
    end;
    Self.Align := alClient;
    lstProfiles.Clear();
    ShowProfiles();
    Docked := true;
    MainSession.dock_windows := Docked;

    _drop.DropEvent := onURLDrop;
    _drop.start(treeRoster);
end;

{---------------------------------------}
procedure TfrmRosterWindow.FormResize(Sender: TObject);
begin
    if (treeRoster.Visible) then begin
        btnFindClose.Left := pnlFind.Width - btnFindClose.Width - 2;
        txtFind.Width := btnFindClose.Left - 5 - txtFind.Left;
        treeRoster.Invalidate();
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.ShowPresence(show: Widestring);
var
    s: Widestring;
begin
    // display this show type
    if show = 'chat' then begin
        lblStatusLink.Caption := _(sRosterChat);
        ChangeStatusImage(RosterTreeImages.Find('chat'));
    end
    else if show = 'away' then begin
        lblStatusLink.Caption := _(sRosterAway);
        ChangeStatusImage(RosterTreeImages.Find('away'));
    end
    else if show = 'xa' then begin
        lblStatusLink.Caption := _(sRosterXA);
        ChangeStatusImage(RosterTreeImages.Find('xa'));
    end
    else if show = 'dnd' then begin
        lblStatusLink.Caption := _(sRosterDND);
        ChangeStatusImage(RosterTreeImages.Find('dnd'));
    end
    else if show = 'offline' then begin
        lblStatusLink.Caption := _(sRosterOffline);
        ChangeStatusImage(RosterTreeImages.Find('offline'));
    end
    else begin
        lblStatusLink.Caption := _(sRosterAvail);
        ChangeStatusImage(RosterTreeImages.Find('available'));
    end;

    s := Lowercase(MainSession.Status);
    {SLK:  MainSession presence is not updated on disconnect,
           so MainSession.Status will have last status value and
           we don't want to display it for Offline show }
    if ((s <> '') and (show <> 'offline')) then begin
        lblStatusLink.Caption := lblStatusLink.Caption + ' (' + MainSession.Status + ')';
    end;

end;

{---------------------------------------}
procedure TfrmRosterWindow.presAvailableClick(Sender: TObject);
var
    stat, show: Widestring;
    cp: TJabberCustomPres;
    mi: TTntMenuItem;
    pri: integer;
begin
    // change our own presence
    mi := TTntMenuItem(sender);
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
        if (cp.Priority <> -1) then pri := cp.Priority;
        stat := cp.Status;
    end;
    MainSession.setPresence(show, stat, pri);
end;

{---------------------------------------}
procedure TfrmRosterWindow.Panel2DblClick(Sender: TObject);
begin
    // reset status to online;
    ShowPresence('online');
    MainSession.setPresence('', _(sRosterAvail), MainSession.Priority);
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterCollapsed(Sender: TObject;
  Node: TTreeNode);
var
    x: TXMLTag;
    go: TJabberGroup;
begin
    if (Node.Data = nil) then exit;

    if (TObject(Node.Data) is TJabberGroup) then begin
        Node.ImageIndex := RosterTreeImages.Find('closed_group');
        Node.SelectedIndex := Node.ImageIndex;
        go := TJabberGroup(Node.Data);

        if (_collapsed_grps.indexOf(go.FullName) = -1) then begin
            _collapsed_grps.Add(go.FullName);
            MainSession.Prefs.setStringlist('col_groups', _collapsed_grps);
        end;

        x := TXMLTag.Create('collapse');
        x.setAttribute('name', go.FullName);
        MainSession.FireEvent('/roster/collapse', x, TJabberRosterItem(nil));
        x.Free();
    end;

end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterExpanded(Sender: TObject;
  Node: TTreeNode);
var
    x: TXMLTag;
    i: integer;
    dirty: boolean;
    go: TJabberGroup;
begin
    if (TObject(Node.Data) is TJabberGroup) then begin
        go := TJabberGroup(Node.Data);
        Node.ImageIndex := RosterTreeImages.Find('open_group');
        Node.SelectedIndex := Node.ImageIndex;
        dirty := false;
        repeat
            i := _collapsed_grps.IndexOf(go.Fullname);
            if (i >= 0) then begin
                dirty := true;
                _collapsed_grps.Delete(i);
            end;
        until (i < 0);

        if (dirty) then
            MainSession.Prefs.setStringlist('col_groups', _collapsed_grps);

        x := TXMLTag.Create('expand');
        x.setAttribute('name', go.FullName);
        MainSession.FireEvent('/roster/expand', x, TJabberRosterItem(nil));
        x.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    msg: string;
    al, ar: integer;
    n: TTreeNode;
begin
    // check to see if we're hitting a button
    n := treeRoster.GetNodeAt(X, Y);
    if n = nil then begin
        n := treeRoster.GetNodeAt((treeRoster.Indent * 2), Y);
        if (n = nil) then begin
            treeRoster.Selected := nil;
            exit;
        end;
    end;

    // check for clicking on grp widget
    al := (treeRoster.Indent * (n.Level));
    ar := (al + frmExodus.ImageList2.Width + 5);
    if ((TObject(n.Data) is TJabberGroup) and
        (X > al) and (X < ar)) then begin
        if n.Expanded then
            n.Collapse(false)
        else
            n.Expand(false);
    end;

    // if we have a legit node.... make sure it's selected..
    if (treeRoster.SelectionCount = 1) then begin
        if (treeRoster.Selected <> n) then
            treeRoster.Selected := n;

        if ((n = _change_node) and (Button = mbLeft)) then begin
            if ((getNodeType(n) = node_ritem) and
                MainSession.Prefs.getBool('inline_status')) then begin
                n.Text := _cur_ritem.Text;
            end;
            n.EditText();
        end
    end;

    _drop_copy :=  (ssCtrl in Shift);
    msg := 'onMouseDown: _drop_copy = ' + BoolToStr(_drop_copy);
    OutputDebugString(PChar(msg));

end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    // Ignore the bug which does not de-select nodes if you
    // don't have the Ctrl-key pressed and you click an
    // already selected node. This is so you can drag-n-drop
    // selections of > 1 node.
end;

{---------------------------------------}
procedure TfrmRosterWindow.popVersionClick(Sender: TObject);
var
    jid: Widestring;
    p: TJabberPres;
begin
    // send a client info request
    jid := '';
    if (getNodeType() = node_ritem) then begin
        if (_cur_ritem = nil) then exit;

        // if the ritem has a res, then always lookup pres for it.
        if (_cur_ritem.jid.resource <> '') then
            p := MainSession.ppdb.FindPres(_cur_ritem.jid.jid,
                _cur_ritem.Jid.resource)
        else
            p := MainSession.ppdb.FindPres(_cur_ritem.jid.jid, '');

        if p = nil then
            // this person isn't online.
            jid := _cur_ritem.jid.jid
        else
            // they are online, send directly to the resource
            jid := p.fromJID.full;
    end;

    if (jid = '') then exit;

    if Sender = popVersion then
        jabberSendCTCP(jid, XMLNS_VERSION)
    else if Sender = popTime then
        jabberSendCTCP(jid, XMLNS_TIME)
    else if Sender = popLast then
        jabberSendCTCP(jid, XMLNS_LAST);
end;

{---------------------------------------}
procedure TfrmRosterWindow.ResetPanels;
begin
    // order here is important
    pnlShow.Align := alBottom;
    if ((MainSession.SSLEnabled) and (MainSession.Active)) then begin
        imgSSL.Visible := true;
        imgSSL.Center := true;
    end
    else
        imgSSL.Visible := false;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popRosterPopup(Sender: TObject);
begin
    //
end;

{---------------------------------------}
procedure TfrmRosterWindow.popPropertiesClick(Sender: TObject);
begin
    // Show properties for this roster item
    if (getNodeType() = node_ritem) then
            ShowProfile(_cur_ritem.jid.jid);
end;

{---------------------------------------}
procedure TfrmRosterWindow.popRemoveClick(Sender: TObject);
var
    n: TTreeNode;
    g: Widestring;
    go: TJabberGroup;
begin
    // Remove this roster item.
    if (getNodeType() = node_ritem) then begin
        // remove a roster item
        if _cur_ritem <> nil then begin
            go := nil;
            n := treeRoster.Selected.Parent;
            if (n.Data <> nil) then
                go := TJabberGroup(n.Data);
            if (go <> nil) then g := go.FullName else g := '';
            RemoveRosterItem(_cur_ritem.jid.full, g);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    i,j: integer;
    ritem: TJabberRosterItem;
    sep, d_grp: Widestring;
    s_node, d_node: TTreeNode;
    go, s_grp: TJabberGroup;
    items: TList;
begin
    // Drop the roster items onto the roster
    // d_node   : the new group node
    // d_grp    : the new group name
    // s_node   : selected node we are changing (the thing that was dropped)
    d_node := treeRoster.GetNodeAt(X, Y);
    if d_node = nil then exit;

    if (TObject(d_node.Data) is TJabberGroup) then begin
        // they dropped on a grp
        // leave d_node assigned
    end
    else if (TObject(d_node.Data) is TJabberRosterItem) then begin
        // they dropped on another item
        d_node := d_node.Parent;
    end
    else
        exit;

    // see if we can drop on this group
    go := TJabberGroup(d_node.Data);
    d_grp := go.FullName;
    if (go.DragTarget = false) then exit;

    for i := 0 to treeRoster.SelectionCount - 1 do begin
        s_node := treeRoster.Selections[i];
        if (TObject(s_node.Data) is TJabberGroup) then begin
            s_grp := TJabberGroup(s_node.Data);
            // Make sure we're not dropping on ourself.
            if (d_grp = s_grp.FullName) then exit;
            if (TJabberGroup(d_node.Data) = s_grp.parent) then exit;

            // move all the items a new subgrp in this grp.
            items := TList.Create();
            TJabberGroup(s_node.Data).getRosterItems(items, false);

            sep := MainSession.prefs.getString('group_seperator');
            d_grp := d_grp + sep + TJabberGroup(s_node.Data).getText();
            for j := 0 to items.count - 1 do begin
                ritem := TJabberRosterItem(items[j]);
                if (not _drop_copy) then
                    ritem.ClearGroups;
                ritem.AddGroup(d_grp);
                ritem.Update();
            end;
        end
        else if (TObject(s_node.Data) is TJabberRosterItem) then begin
            ritem := TJabberRosterItem(s_node.Data);

            // invalidate the old parent
            if (s_node.Parent <> nil) then begin
                InvalidateGrps(s_node);
            end;

            // change the ritem object
            if ritem <> nil then begin
                if (not ritem.IsInGroup(d_grp)) then begin
                    if (not _drop_copy) then
                        ritem.ClearGroups;
                    ritem.AddGroup(d_grp);
                    ritem.update;
                end;
            end;
        end
    end;

    _drop_copy := false;

    // Make sure d_grp is expanded if it's not in _collapsed_grps
    if ((not d_node.expanded) and (_collapsed_grps.IndexOf(d_grp) < 0)) then
        ExpandGrpNode(d_node);

    // Re-Draw both group nodes
    InvalidateGrps(d_node);

    treeRoster.Repaint();

end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
    s_node, d_node: TTreeNode;
    go: TJabberGroup;
    i: integer;
begin
    // Only accept items from the roster
    if (Source = treeRoster) then begin
        Accept := true;
    end
    else
        Accept := false;

    if (Y < treeRoster.Top + 20) then begin
        _auto_dir := +1;
        autoScroll.Enabled := true;
    end
    else if (Y > (treeRoster.Top + treeRoster.Height - 20)) then begin
        _auto_dir := -1;
        autoScroll.Enabled := true;
    end
    else
        autoScroll.Enabled := false;

    // check the items being dragged
    for i := 0 to treeRoster.SelectionCount - 1 do begin
        s_node := treeRoster.Selections[i];
        if (TObject(s_node.Data) is TJabberGroup) then begin
            go := TJabberGroup(s_node.Data);
            if (go.DragSource = false) then begin
                Accept := false;
                exit;
            end;
        end
        else if (TObject(s_node.Data) is TJabberRosterItem) then begin
            go := TJabberGroup(s_node.Parent.Data);
            if (go.DragSource = false) then begin
                Accept := false;
                exit;
            end;
        end
        else begin
            Accept := false;
            exit;
        end;
    end;


    // Check to see if we are allowed to drop here
    d_node := treeRoster.GetNodeAt(X, Y);
    if d_node = nil then exit;

    if (TObject(d_node.Data) is TJabberGroup) then begin
        // they dropped on a grp
        go := TJabberGroup(d_node.Data);
    end
    else if (TObject(d_node.Data) is TJabberRosterItem) then begin
        // they dropped on another item
        go := TJabberGroup(d_node.Parent.Data);
    end
    else
        exit;


    Accept := go.DragTarget;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
    offline, native, me, o, e: boolean;
    b, u: boolean;
    i, r: integer;
    n: TTreeNode;
    ri: TJabberRosterItem;
    pri: TJabberPres;
    slist: TList;
begin
    // Figure out what popup menu to show
    // based on the selection

    ri := nil;
    n := treeRoster.GetNodeAt(MousePos.X, MousePos.Y);
    if (n <> nil) then begin
        if (treeRoster.SelectionCount > 1) then
            r := node_grp
        else
            r := getNodeType(n);
    end
    else begin
        treeRoster.Selected := nil;
        r := node_none;
    end;

    case r of
    node_none: begin
        // show the actions popup when no node is hit
        treeRoster.PopupMenu := popActions;
        popProperties.Enabled := false;
    end;
    node_transport: begin
        treeRoster.PopupMenu := popTransport;
        treeRoster.Selected := n;
    end;
    node_ritem: begin
        // show the roster menu when a node is hit
        if (_cur_ritem.CustomContext <> nil) then
            treeRoster.PopupMenu := _cur_ritem.CustomContext
        else begin
            treeRoster.PopupMenu := popRoster;
            treeRoster.Selected := n;

            o := false;         // online?
            me := false;        // is this me?
            native := true;     // are they native jabber?
            offline := true;    // can they do offline?

            e := (_cur_ritem <> nil);
            if (e) then begin
                // check to see if this person is online
                ri := TJabberRosterItem(n.Data);
                pri := MainSession.ppdb.FindPres(ri.jid.jid, '');
                o := (pri <> nil);
                native := ri.IsNative;
                offline := ri.CanOffline;
            end;

            popChat.Enabled := (e and (o or offline));
            popMsg.Enabled := (e and (o or offline));
            popProperties.Enabled := true;
            popSendFile.Enabled := (o) and (native) and
                (MainSession.Profile.ConnectionType = conn_normal);
            popInvite.Enabled := (native);
            popPresence.Enabled := (e and (not me));
//            popClientInfo.Enabled := true;
            popClientInfo.Enabled := (native);
            popVersion.Enabled := (o) and (native);
            popTime.Enabled := (o) and (native);
            popRename.Enabled := (not me);
            popHistory.Enabled := e;
            popBlock.Enabled := (not me);
            popRemove.Enabled := (not me);

            // only enable this if we have a logger.
            popHistory.Enabled := (ExCOMController.ContactLogger <> nil);

            if ((ri <> nil) and (MainSession.isBlocked(ri.jid))) then begin
                popBlock.Caption := _(sBtnUnBlock);
                popBlock.OnClick := popUnblockClick;
            end
            else begin
                popBlock.Caption := _(sBtnBlock);
                popBlock.OnClick := popBlockClick;
            end;
            popGroupBlock.OnClick := popBlock.OnClick;
        end;
    end;
    node_grp: begin
        // check to see if we have the Transports grp selected
        if ((_cur_go <> nil) and (_cur_go.FullName = _transports)) then begin
            treeRoster.PopupMenu := popActions;
            popProperties.Enabled := false;
            exit;
        end;

        // check to see if we have multiple contacts or a group selected
        treeRoster.PopupMenu := popGroup;
        if (treeRoster.SelectionCount <= 1) then begin
            treeRoster.Selected := n;
        end;
        popGrpRename.Enabled := (treeRoster.SelectionCount <= 1);

        b := true;
        u := true;

        // do blocking madness
        slist := getSelectedContacts(MainSession.Prefs.getBool('roster_only_online'));
        for i := 0 to slist.count - 1 do begin
            ri := TJabberRosterItem(slist[i]);
            if (_blockers.IndexOf(ri.jid.jid) >= 0) then begin
                b := false;
                if (not u) then break;
            end
            else begin
                u := false;
                if (not b) then break;
            end;
        end;
        if ((not b) and (not u)) then begin
            popGroupBlock.Caption := _(sBtnBlock);
            popGroupBlock.Enabled := false;
            popBlock.OnClick := popBlockClick;
        end
        else if (b) then begin
            popGroupBlock.Caption := _(sBtnBlock);
            popGroupBlock.Enabled := true;
            popBlock.OnClick := popBlockClick;
        end
        else if (u) then begin
            popGroupBlock.Caption := _(sBtnUnBlock);
            popGroupBlock.Enabled := true;
            popBlock.OnClick := popUnBlockClick;
        end;

        popGroupBlock.OnClick := popBlock.OnClick;

        slist.Clear();
        slist.Free();
    end;
end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popHistoryClick(Sender: TObject);
var
    nt: integer;
    n: TTreeNode;
    ritem: TJabberRosterItem;
begin
    // Show history for this user
    n := treeRoster.Selected;
    nt := getNodeType(n);
    if (nt = node_ritem) then begin
        ritem := TJabberRosterItem(n.Data);
        if ritem <> nil then
            ShowLog(ritem.jid.jid);
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popChatClick(Sender: TObject);
var
    nt: integer;
    win: TfrmChat;
begin
    // chat w/ contact
    nt := getNodeType();
    if (nt = node_ritem) then begin
        if (_cur_ritem.Jid.resource <> '') then
            win := StartChat(_cur_ritem.jid.jid, _cur_ritem.Jid.resource,
                true)
        else
            win := StartChat(_cur_ritem.jid.jid, '', true);

        if (win <> nil) then
            win.Show();

    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popMsgClick(Sender: TObject);
var
    nt: integer;
begin
    // send a normal msg
    nt := getNodeType();
    if (nt = node_ritem) then
        StartMsg(_cur_ritem.jid.full);
end;

{---------------------------------------}
procedure TfrmRosterWindow.popSendFileClick(Sender: TObject);
var
    node: TTreeNode;
begin
    node := treeRoster.Selected;
    if node = nil then exit;
    if node.Data = nil then exit;

    if (TObject(node.Data) is TJabberRosterItem) then
        FileSend(TJabberRosterItem(node.Data).jid.full)
end;

{---------------------------------------}
procedure TfrmRosterWindow.popAddContactClick(Sender: TObject);
begin
    frmExodus.btnAddContactClick(Self);
end;

{---------------------------------------}
procedure TfrmRosterWindow.popAddGroupClick(Sender: TObject);
begin
    frmExodus.NewGroup2Click(Self);
end;

{---------------------------------------}
procedure TfrmRosterWindow.popSendPresClick(Sender: TObject);
var
    i: integer;
    t: TXMLTag;
    recips: TList;
    invis: boolean;
    pshow, pstatus: Widestring;
    pri: integer;
    cur_jid: Widestring;
begin
    // Send whatever my presence is right now.
    recips := getSelectedContacts(true);

    if (recips.Count > 0) then begin
        invis := false;
        if ((Sender = popSendInvisible) or (Sender = popGrpInvisible)) then
            invis := true;
        pshow := MainSession.Show;
        pstatus := MainSession.Status;
        pri := MainSession.Priority;

        // Send pres to everyone in the list.
        for i := 0 to recips.Count - 1 do begin
            cur_jid := TJabberRosterItem(recips[i]).jid.full;
            t := TXMLTag.Create('presence');

            // do insane invisible hacking to keep our own
            // avails list.
            if (invis) then begin
                t.setAttribute('type', 'invisible');
                if (MainSession.Invisible) then
                    MainSession.removeAvailJid(cur_jid);
                end
            else if (MainSession.Invisible) then
                MainSession.addAvailJid(cur_jid);

            if (pshow) <> '' then t.AddBasicTag('show', pshow);
            if (pstatus) <> '' then t.AddBasicTag('status', pstatus);
            if (pri > 0) then t.AddBasicTag('priority', IntToStr(pri));

            t.setAttribute('to', cur_jid);
            MainSession.SendTag(t);
        end;
    end;

    recips.Free;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popSendSubscribeClick(Sender: TObject);
var
    node: TTreeNode;
begin
    // send subscribe to this person
    node := treeRoster.Selected;
    if node = nil then exit;
    if node.Data = nil then exit;

    if (TObject(node.Data) is TJabberRosterItem) then
        SendSubscribe(TJabberRosterItem(node.Data).jid.jid, MainSession);
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
    c1, c2: WideString;
    p: TJabberPres;
    ntype: integer;
    go: TJabberGroup;
    o: TObject;
    a: TAvatar;
begin
    // Try drawing the roster custom..
    if (not Node.isVisible) then exit;

    DefaultDraw := true;
    o := TObject(Node.Data);

    if (o is TJabberGroup) then begin
        if (not _group_counts) then exit;

        go := TJabberGroup(o);
        if (Win32Platform <> Ver_Platform_Win32_Windows) then
            treeRoster.Canvas.Font.Style := [fsBold];

        if (not go.ShowPresence) then begin
            // If we aren't showing pres, then just show the total
            c1 := go.getText();
            c2 := '(' + IntToStr(Node.Count) + ')';
            DrawNodeText(Node, State, c1, c2);
        end
        else begin
            // Otherwise, show online/total for presence enabled grps
            c1 := go.Parts[Node.Level] + ' ';
            if (Node.Level + 1 = go.NestLevel) then
                c2 := '(' + IntToStr(go.Online) + '/' + IntToStr(go.Total) + ')'
            else
                c2 := '';
            DrawNodeText(Node, State, c1, c2);
        end;
        DefaultDraw := false;
    end
    else begin
        // we are drawing some kind of node
        treeRoster.Canvas.Font.Style := [];
        if (not Node.isVisible) then exit;

        ntype := getNodeType(Node);
        if (_avatars) then
            DefaultDraw := false
        else if (ntype = node_transport) then begin
            DefaultDraw := true;
            exit;
        end
        else if ((_roster_unicode = false) and (_show_status = false)) then begin
            DefaultDraw := true;
            exit;
        end
        else
            DefaultDraw := false;

        // always custom draw roster items to get unicode goodness
        // determine the captions (c1 is nick, c2 is status)
        c2 := '';

        if (ntype = node_transport) then begin
            c1 := _cur_ritem.Text;
            DrawNodeText(Node, State, c1, c2);
        end
        else if (_cur_ritem <> nil) then begin
            c1 := _cur_ritem.Text;
            c2 := _cur_ritem.Status;

            if (_cur_ritem.Text <> '') then
                c1 := _cur_ritem.Text
            else
                c1 := _cur_ritem.jid.Full;

            if (_cur_ritem.IsContact) then begin
                if (_cur_ritem.ask = 'subscribe') then
                    c1 := c1 + _(sRosterPending);

                p := MainSession.ppdb.FindPres(_cur_ritem.jid.jid, '');
                if ((p <> nil) and (_show_status)) then begin
                    if (p.Status <> '') then
                        c2 := '(' + p.Status + ')';
                end;
            end;

            DrawNodeText(Node, State, c1, c2);
            if (_avatars) then begin
                a := Avatars.Find(_cur_ritem.jid.jid);
                if (a <> nil) then
                    // draw the avatar
                    DrawAvatar(Node, a);
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.DrawAvatar(Node: TTreeNode; a: TAvatar);
var
    r: TRect;
begin
    //
    r := Node.DisplayRect(false);
    r.Right := r.Right - 2;
    r.Left := r.Right - _item_height;
    r.Bottom := r.Top + _item_height;
    if ((a.valid) and (not a.pending)) then
        a.Draw(treeRoster.Canvas, r);
end;

{---------------------------------------}
procedure TfrmRosterWindow.DrawNodeText(Node: TTreeNode; State: TCustomDrawState;
    c1, c2: Widestring);
var
    top_margin, lines, rr, maxr, ico, tw, th: integer;
    nRect, xRect, sRect: TRect;
    main_color, stat_color: TColor;
    is_grp: boolean;
    tmps: Widestring;
begin
    with treeRoster.Canvas do begin
        tmps := c1;
        tw := CanvasTextWidthW(treeRoster.Canvas, tmps);
        th := treeRoster.Canvas.TextHeight(tmps);
        is_grp := (TObject(Node.Data) is TJabberGroup);

        // this is madness to determine the text rectangle,
        // based on our mode, text widths, etc..
        xRect := Node.DisplayRect(true);
        xRect.Left := xRect.Left - 1;
        lines := 1;
        if ((_avatars) and (not is_grp)) then begin
            // normal, c1 (c2)
            if (c2 <> '') then lines := 2;
            rr := Max(xRect.Left + tw + 3,
                xRect.Left + CanvasTextWidthW(treeRoster.Canvas, c2) + 5);
            maxr := treeRoster.ClientWidth - _item_height - 2;
        end
        else begin
            // avatar mode, c2 under c1
            rr := xRect.Left + tw + 2 +
                CanvasTextWidthW(treeRoster.Canvas, (c2 + ' '));
            maxr := treeRoster.ClientWidth - 2;
        end;

        // make sure our rect isn't bigger than the treeview
        if (rr >= maxr) then
            xRect.Right := maxr
        else
            xRect.Right := rr;
        nRect := xRect;
        nRect.Left := nRect.Left - (2 * treeRoster.Indent);

        // if selected, draw a solid rect
        if (cdsSelected in State) then begin
            Font.Color := clHighlightText;
            Brush.Color := clHighlight;
            FillRect(xRect);
        end;

        // draw the left hand image
        top_margin := (_item_height - frmExodus.ImageList2.Height) div 2;
        if (top_margin < 0) then top_margin := 0;

        if (Node.Level > 0) then begin
            // this is an item or a group
            frmExodus.ImageList2.Draw(treeRoster.Canvas,
                nRect.Left + treeRoster.Indent,
                nRect.Top + top_margin, Node.ImageIndex);
        end
        else begin
            // this is a group
            if (Node.Expanded) then
                ico := RosterTreeImages.Find('open_group')
            else
                ico := RosterTreeImages.Find('closed_group');

            frmExodus.ImageList2.Draw(treeRoster.Canvas,
                nRect.Left + treeRoster.Indent,
                nRect.Top + top_margin, ico);
        end;

        // draw the text
        if (cdsSelected in State) then begin
            main_color := clHighlightText;
            stat_color := main_color;
        end
        else begin
            main_color := treeRoster.Font.Color;
            stat_color := _status_color;
        end;
        if ((_avatars) and (lines = 1)) then begin
            top_margin := (_item_height - th) div 2;
            if (top_margin < 0) then top_margin := 0;
        end
        else
            top_margin := 1;

        SetTextColor(treeRoster.Canvas.Handle, ColorToRGB(main_color));
        CanvasTextOutW(treeRoster.Canvas, xRect.Left + 1,
            xRect.Top + top_margin, tmps, maxr);

        if (c2 <> '') then begin
            SetTextColor(treeRoster.Canvas.Handle, ColorToRGB(stat_color));
            if ((not _avatars) or (is_grp)) then begin
                Font.Style := [];
                SelectObject(treeRoster.Canvas.Handle, Font.Handle);
                CanvasTextOutW(treeRoster.Canvas, xRect.Left + tw + 4,
                    xRect.Top + top_margin, c2, maxr)
            end
            else begin
                Font.Size := Font.Size - 3;
                SelectObject(treeRoster.Canvas.Handle, Font.Handle);
                CanvasTextOutW(treeRoster.Canvas, xRect.Left + 2,
                    xRect.Top + 1 + th, c2, maxr);
                Font.Size := Font.Size + 3;
                SelectObject(treeRoster.Canvas.Handle, Font.Handle);
            end;
        end
        else if (not (cdsSelected in State)) then begin
            { Sometimes the UI doesn't remove the "status"
              Also have to check for selected to not select maxr }
            sRect        := xRect;
            sRect.Left   := xRect.Right;
            sRect.Right  := maxr;
            sRect.Top    := xRect.Top + 1;
            sRect.Bottom := xRect.Bottom - 1;
            FillRect(sRect);
        end;

        if (cdsSelected in State) then
            // Draw the focus box.
            treeRoster.Canvas.DrawFocusRect(xRect);
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.imgStatusPaint(Sender: TObject);
begin
    frmExodus.ImageList2.Draw(imgStatus.Canvas, 1, 1, _cur_status);
end;

{---------------------------------------}
procedure TfrmRosterWindow.popGrpRenameClick(Sender: TObject);
var
    go: TJabberGroup;
    old_grp, new_grp: WideString;
    i: integer;
    ri: TJabberRosterItem;
begin
    // Rename some grp.
    go := TJabberGroup(treeRoster.Selected.Data);
    if (go = nil) then exit;

    new_grp := go.FullName;
    if (InputQueryW(_(sRenameGrp), _(sRenameGrpPrompt), new_grp)) then begin
        old_grp := go.FullName;
        new_grp := Trim(new_grp);
        if (new_grp <> old_grp) then begin
            for i := 0 to MainSession.Roster.Count - 1 do begin
                ri := MainSession.Roster.Items[i];
                if (ri.IsInGroup(old_grp)) then begin
                    ri.DelGroup(old_grp);
                    ri.AddGroup(new_grp);
                    ri.update();
                end;
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popGrpRemoveClick(Sender: TObject);
var
    go: TJabberGroup;
    recips: TList;
begin
    // Remove the grp..
    if (treeRoster.SelectionCount = 1) then begin
        go := _cur_go;
        if (go.isEmpty()) then begin
            // just remove the node, and remove it from the roster
            TTreeNode(go.Data).Free();
            MainSession.roster.removeGroup(go);
        end
        else
            RemoveGroup(_cur_grp)
    end
    else begin
        recips := getSelectedContacts(false);
        RemoveGroup('', recips);
        recips.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    // Kill the blockers list and collapsed grps
    _blockers.Free();
    _collapsed_grps.Free();
    if (MainSession <> nil) then with MainSession do begin
        UnRegisterCallback(_rostercb);
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popInviteClick(Sender: TObject);
var
    jids: TWideStringList;
begin
    //Show the invite window w/ this JID
    if (_cur_ritem = nil) then exit;

    jids := TWideStringlist.Create();
    jids.Add(_cur_ritem.jid.jid);

    ShowInvite('', jids);
    jids.Free();
end;

{---------------------------------------}
procedure TfrmRosterWindow.popGrpInviteClick(Sender: TObject);
var
    i: integer;
    sel: TList;
    jids: TWideStringlist;
begin
    // Invite the whole group to the conference.
    sel := Self.getSelectedContacts(true);
    jids := TWideStringlist.Create();
    for i := 0 to sel.Count - 1 do
        jids.Add(TJabberRosterItem(sel[i]).jid.full);

    ShowInvite('', jids);
    sel.Free();
    jids.Free();
end;

{---------------------------------------}
procedure TfrmRosterWindow.popSendContactsClick(Sender: TObject);
var
    fsel: TfrmSelContact;
    sel: TList;
begin
    // Send contacts to this JID..
    sel := getSelectedContacts(false);
    if (sel.Count = 0) then begin
        MessageDlgW(_(sNoContactsSel), mtError, [mbOK], 0);
        sel.Free();
        exit;
    end;

    fsel := TfrmSelContact.Create(Application);
    fsel.frameTreeRoster1.treeRoster.MultiSelect := false;

    frmExodus.PreModal(fsel);
    if (fsel.ShowModal = mrOK) then
        jabberSendRosterItems(fsel.GetSelectedJID(), sel);
    frmExodus.PostModal();

    sel.Free();
    fSel.Free();
end;

{---------------------------------------}
procedure TfrmRosterWindow.popBlockClick(Sender: TObject);
var
    recips: TList;
    i: integer;
    ri: TJabberRosterItem;
    p: TJabberPres;
begin
    // Block or Unblock this user
    recips := getSelectedContacts(false);
    if (recips.Count > 1) then begin
        if (MessageDlgW(WideFormat(_(sBlockContacts), [recips.Count]), mtConfirmation,
            [mbYes, mbNo], 0) = mrNo) then exit;
    end;
    for i := 0 to recips.Count - 1 do begin
        ri := TJabberRosterItem(recips[i]);
        MainSession.Block(ri.jid);
        if MainSession.Prefs.getBool('roster_hide_block') then
            RemoveItemNodes(ri)
        else begin
            p := MainSession.ppdb.FindPres(ri.jid.jid, '');
            RenderNode(ri, p);
        end;
    end;

    recips.Clear();
    recips.Free();
end;

{---------------------------------------}
procedure TfrmRosterWindow.popUnBlockClick(Sender: TObject);
var
    recips: TList;
    i: integer;
    ri: TJabberRosterItem;
    p: TJabberPres;
begin
    // Block or Unblock this user
    recips := getSelectedContacts(false);
    if (recips.Count > 1) then begin
        if (MessageDlgW(WideFormat(_(sUnblockContacts), [recips.Count]), mtConfirmation,
            [mbYes, mbNo], 0) = mrNo) then exit;
    end;
    for i := 0 to recips.Count - 1 do begin
        ri := TJabberRosterItem(recips[i]);
        MainSession.UnBlock(ri.jid);
        p := MainSession.ppdb.FindPres(ri.jid.jid, '');
        RenderNode(ri, p);
    end;

    recips.Clear();
    recips.Free();
end;

{---------------------------------------}
procedure TfrmRosterWindow.BroadcastMessage1Click(Sender: TObject);
var
    r: TList;
    jl: TWideStringList;
    i: integer;
begin
    // Broadcast a message to the grp
    if ((_show_online) and (_show_filter > show_offline)) then
        r := getSelectedContacts(true)
    else
        r := getSelectedContacts(false);

    if (r.Count <= 1) then
        MessageDlgW(_(sNoBroadcast), mtError, [mbOK], 0)
    else begin
        jl := TWideStringlist.Create();
        for i := 0 to r.Count - 1 do
            jl.Add(TJabberRosterItem(r[i]).jid.full);
        BroadcastMsg(jl);
        jl.Free();
    end;

    r.Clear();
    r.Free();
end;

{---------------------------------------}
procedure TfrmRosterWindow.lblModifyClick(Sender: TObject);
var
    res: integer;
    idx: integer;
    p: TJabberProfile;
    li: TTntListItem;
begin
    idx := lstProfiles.ItemIndex;
    if (idx < 0) then exit;

    p := TJabberProfile(MainSession.Prefs.Profiles.Objects[idx]);
    res := ShowConnDetails(p);
    if ((res = mrOK) or (res = mrYES)) then begin
        li := lstProfiles.Items[idx];
        li.Caption := p.Name;
        if (res = mrYES) then
            lblConnectClick(Self);
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.lblConnectClick(Sender: TObject);
begin
    if (Sender = lblConnect) then begin
        if (lblConnect.Caption = _(sCancelLogin)) then begin
            // Cancel the connection
            frmExodus.CancelConnect();
        end
        else if (lblConnect.Caption = _(sCancelReconnect)) then begin
            // cancel reconnect
            frmExodus.timReconnect.Enabled := false;
            ToggleGUI(gui_disconnected);
        end;
    end
    else if (lstProfiles.ItemIndex >= 0) then
        DoLogin(lstProfiles.ItemIndex);
end;

{---------------------------------------}
procedure TfrmRosterWindow.lblCreateClick(Sender: TObject);
var
    pname: Widestring;
    p: TJabberProfile;
    i: Integer;
begin
    // Create a new profile
    pname := _(sProfileNew);
    if InputQueryW(_(sProfileCreate), _(sProfileNamePrompt), pname) then begin
        p := MainSession.Prefs.CreateProfile(pname);
        p.Resource := GetAppInfo().ID;
        p.NewAccount := MainSession.Prefs.getBool('brand_profile_new_account_default');
        case (ShowConnDetails(p)) of
            mrCancel: Begin
                MainSession.Prefs.RemoveProfile(p);
                MainSession.Prefs.SaveProfiles();
                ShowProfiles();
            End;
            mrYes: Begin
                MainSession.Prefs.SaveProfiles();
                i := MainSession.Prefs.Profiles.IndexOfObject(p);
                assert(i >= 0);
                MainSession.ActivateProfile(i);
                ShowProfiles();
                DoLogin(i);
            End;
            mrOK: Begin
                MainSession.Prefs.SaveProfiles();
                ShowProfiles();
            End;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.lblDeleteClick(Sender: TObject);
var
    i: integer;
    p: TJabberProfile;
begin
    // Delete this profile
    i := lstProfiles.ItemIndex;
    if (i < 0) then exit;

    if (MessageDlgW(_(sProfileRemove), mtConfirmation, [mbYes, mbNo], 0) = mrNo) then exit;

    p := TJabberProfile(MainSession.Prefs.Profiles.Objects[i]);
    MainSession.Prefs.RemoveProfile(p);
    MainSession.Prefs.setInt('profile_active', 0);

    // make sure we have at least a default profile
    if (MainSession.Prefs.Profiles.Count) <= 0 then begin
        MainSession.Prefs.CreateProfile(_(sProfileDefault))
    end;

    // save
    MainSession.Prefs.SaveProfiles();

    PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
var
    ntype: integer;
begin
    // user is trying to change a node caption
    ntype := getNodeType(Node);
    if (ntype = node_ritem) then
        AllowEdit := _cur_ritem.InlineEdit
    else
        AllowEdit := false;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterEdited(Sender: TObject;
  Node: TTreeNode; var S: String);
var
    update: TXMLTag;
begin
    // user is done editing a node's text
    assert(getNodeType(Node) = node_ritem);

    _cur_ritem.Text := S;
    update := TXMLTag.Create('update');
    update.AddTag(TXMLTag.Create(_cur_ritem.tag));
    MainSession.FireEvent('/roster/update', update, _cur_ritem);
    update.Free();
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterChange(Sender: TObject;
  Node: TTreeNode);
begin
    _change_node := Node;
    if (Node <> nil) then begin
        _last_search := Node.AbsoluteIndex;
        if (getNodeType(Node) = node_ritem) then begin
            MainSession.Roster.ActiveItem := TJabberRosterItem(Node.Data);
            exit;
        end;
    end;

    MainSession.Roster.ActiveItem := nil;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterExit(Sender: TObject);
begin
    _change_node := nil;
end;

{---------------------------------------}
procedure TfrmRosterWindow.FormActivate(Sender: TObject);
begin
    _change_node := nil;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popTransLogoffClick(Sender: TObject);
var
    p: TXMLTag;
begin
    // send unavail pres to this jid..
    if (_cur_ritem <> nil) then begin
        p := TXMLTag.Create('presence');
        if (Sender = popTransLogoff) then
            p.setAttribute('type', 'unavailable');
        p.setAttribute('to', _cur_ritem.jid.full);
        MainSession.SendTag(p);
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popTransUnRegisterClick(Sender: TObject);
begin
    // unregister from the transport.
    RemoveTransport(_cur_ritem.jid.jid, true);
    QuietRemoveRosterItem(_cur_ritem.jid.full);
end;

{---------------------------------------}
procedure TfrmRosterWindow.imgAdClick(Sender: TObject);
begin
    if (_adURL <> '') then
        ShellExecute(Application.Handle, 'open', PChar(_adURL), nil, nil, SW_SHOWNORMAL);
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Key = #13 then begin
        Self.treeRosterDblClick(Self);
        Key := #0;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popRenameClick(Sender: TObject);
var
    ri: TJabberRosterItem;
    nick: Widestring;
begin
    // Do this since the treeview doesn't use WideStrings for
    // processing of Editing events
    getNodeType();
    ri := _cur_ritem;

    if (ri = nil) then begin
        MessageDlgW(_(sNoContactsSel), mtError, [mbOK], 0);
        exit;
    end;

    nick := ri.Text;
    if (InputQueryW(_('Rename Roster Item'), _('New Nickname: '), nick)) then begin
        ri.Text := nick;
        ri.update();
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterCompare(Sender: TObject; Node1,
  Node2: TTreeNode; Data: Integer; var Compare: Integer);
var
    //trans1: boolean;
    //trans2: boolean;
    t1, t2: Widestring;
    o1, o2: TObject;
    lev1, lev2: integer;
begin
    Assert(Node1 <> nil);
    Assert(Node2 <> nil);
    Assert(Node1.Data <> nil);
    Assert(Node2.Data <> nil);

    // define a custom sort routine for two roster nodes
    // handle normal cases.
    if (Node1.Level = Node2.Level) then begin
        o1 := TObject(Node1.Data);
        o2 := TObject(Node2.Data);

        if ((o1 is TJabberGroup) and
            (o2 is TJabberGroup)) then begin
            lev1 := TJabberGroup(o1).SortPriority;
            lev2 := TJabberGroup(o2).SortPriority;

            t1 := TJabberGroup(o1).getText();
            t2 := TJabberGroup(o2).getText();

            if (lev1 < lev2) then
                Compare := -1
            else if (lev1 > lev2) then
                Compare := +1
            else
                Compare := AnsiCompareText(t1, t2);
        end
        else if (o1 is TJabberGroup) then
            Compare := +1
        else if (o2 is TJabberGroup) then
            Compare := -1
        else begin
            if (o1 is TJabberNodeItem) then
                t1 := TJabberNodeItem(o1).GetText()
            else
                t1 := Node1.Text;
            if (o2 is TJabberNodeItem) then
                t2 := TJabberNodeItem(o2).GetText()
            else
                t2 := Node2.Text;
            Compare := AnsiCompareText(t1, t2);
        end;
    end
    else begin
        if (Node1.Level < Node2.Level) then
            Compare := -1
        else
            Compare := +1;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.pluginClick(Sender: TObject);
begin
    // a plugin menu got clicked
    ExCOMController.fireRosterMenuClick(Sender);
end;

{---------------------------------------}
procedure TfrmRosterWindow.onURLDrop(p: TPoint; url: Widestring);
var
    tp: TPoint;
    n: TTreeNode;
    i, nt: integer;
    r: TList;
    jl: TWidestringlist;
    f: TfrmMsgRecv;
    xtag: Widestring;
begin
    // we got a URL drop
    tp := treeRoster.ScreenToClient(p);
    n := treeRoster.GetNodeAt(tp.X, tp.Y);
    if (n = nil) then begin
        MessageDlgW(_(sNoContactsSel), mtWarning, [mbOK], 0);
        exit;
    end;

    xtag := '<x xmlns="jabber:x:oob"><url>' + url + '</url></x>';

    nt := getNodeType(n);
    case nt of
    node_ritem: begin
        // send a msg to this user, with the URL in the body.
        f := StartMsg(TJabberRosterItem(n.Data).jid.jid);
        f.AddOutgoing(url);
        f.AddXTagXML(xtag);
        f.txtSendSubject.Text := 'URL';
        end;
    node_grp: begin
        // we have to pretend to select the group..
        treeRoster.Selected := n;
        r := getSelectedContacts(true);
        jl := TWideStringlist.Create();
        for i := 0 to r.Count - 1 do
            jl.Add(TJabberRosterItem(r[i]).jid.full);

        f := BroadcastMsg(jl);
        f.AddOutgoing(url);
        f.AddXTagXML(xtag);
        f.txtSendSubject.Text := 'URL';

        jl.Free();
        r.Free();
        end
    else begin
        MessageDlgW(_(sNoContactsSel), mtWarning, [mbOK], 0);
        exit;
        end;
    end;

end;

{---------------------------------------}
procedure TfrmRosterWindow.FormDestroy(Sender: TObject);
begin
    _drop.stop();
    _drop := nil;
end;

{---------------------------------------}
procedure TfrmRosterWindow.MoveorCopyContacts1Click(Sender: TObject);
var
    sel: TList;
begin
    sel := Self.getSelectedContacts(false);
    ShowGrpManagement(sel);
end;

{---------------------------------------}
procedure TfrmRosterWindow.presCustomClick(Sender: TObject);
begin
    ShowCustomPresence();
end;

{---------------------------------------}
procedure TfrmRosterWindow.txtFindKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    case key of
        VK_ESCAPE: begin
            pnlFind.Visible := false;
            Key := 0;
        end;
        VK_RETURN: begin
            Self.treeRosterDblClick(Self);
            pnlFind.Visible := false;
            Key := 0;
        end
        else begin
            //_last_search := 0;
            txtFind.Color := clWindow;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.txtFindChange(Sender: TObject);
var
    i:         integer;
    ri:        TJabberRosterItem;
    node:      TTreeNode;
    comp:      WideString;
    search:    WideString;
begin
    search := Lowercase(txtFind.Text);
    if (search = '') then begin
        exit;
    end;

    for i := _last_search to treeRoster.Items.Count - 1 do begin
        node := treeRoster.Items[i];
        if (not (TObject(node.Data) is TJabberRosterItem)) then continue;
        ri := TJabberRosterItem(node.Data);
        if radNick.Checked then
            comp := Lowercase(ri.Text)
        else
            comp := Lowercase(ri.jid.jid);

        if Pos(search, comp) > 0 then begin
            treeRoster.Select(node, []);
            _last_search := i;
            exit;
        end;
    end;
    _last_search := 0;
    txtFind.Color := clRed;
end;

{---------------------------------------}
procedure TfrmRosterWindow.btnFindCloseClick(Sender: TObject);
begin
    pnlFind.Visible := false;
end;

{---------------------------------------}
procedure TfrmRosterWindow.presDNDClick(Sender: TObject);
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
procedure TfrmRosterWindow.updateReconnect(secs: integer);
begin
    lstProfiles.Visible := false;
    lblConnect.Caption := _(sCancelReconnect);
    lblStatus.Caption := WideFormat(_(sReconnectIn), [secs]);
    AssignUnicodeURL(lblConnect.Font, 8);
    lblConnect.Color := pnlConnect.Color;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popTransEditClick(Sender: TObject);
begin
    // Bring up a iq:register form for this transport
    if (_cur_ritem <> nil) then begin
        StartServiceReg(_cur_ritem.jid.full);
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.autoScrollTimer(Sender: TObject);
begin
    if (_auto_dir = +1) then
        treeRoster.Perform(WM_VSCROLL, SB_LINEUP, 0)
    else
        treeRoster.Perform(WM_VSCROLL, SB_LINEDOWN, 0);
    treeRoster.Invalidate();
end;

{---------------------------------------}
procedure TfrmRosterWindow.lblNewUserClick(Sender: TObject);
var
    pname: Widestring;
    p: TJabberProfile;
    i: integer;
begin
    // Run the new user wizard... first create a new profile
    pname := _(sProfileNew);
    if InputQueryW(_(sProfileCreate), _(sProfileNamePrompt), pname) then begin
        p := MainSession.Prefs.CreateProfile(pname);
        p.Resource := GetAppInfo().ID;
        p.NewAccount := MainSession.Prefs.getBool('brand_profile_new_account_default');
        MainSession.Prefs.SaveProfiles();
        ShowProfiles();
        i := MainSession.Prefs.Profiles.IndexOfObject(p);
        assert(i >= 0);
        MainSession.ActivateProfile(i);
        if (ShowNewUserWizard() = mrCancel) then begin
            // things didn't go so well.. cleanup
            frmExodus.CancelConnect();
            frmExodus.timReconnect.Enabled := false;
            ToggleGUI(gui_disconnected);
            MainSession.Prefs.RemoveProfile(p);
            MainSession.Prefs.SaveProfiles();
            ShowProfiles();
        end
        else
            // make sure we're showing the right UI
            ToggleGUI(gui_connected);
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
    // Disable the auto scroll timer , if not infinite scroll up or down can
    // happen - DC 09/20/2005
    autoScroll.Enabled := false;
    _drag_op := false;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
    _drag_op := true;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
    msg: string;
begin
    if (_drag_op) then begin
        _drop_copy := (ssCtrl in Shift);
        msg := 'onKeyDown: _drop_copy = ' + BoolToStr(_drop_copy);
        OutputDebugString(PChar(msg));
    end;
end;

procedure TfrmRosterWindow.lstProfilesKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Key = Chr(13) then lblConnectClick(Self);
end;

procedure TfrmRosterWindow.lstProfilesInfoTip(Sender: TObject;
  Item: TListItem; var InfoTip: String);
var
    idx: integer;
    p: TJabberProfile;
begin
    if (Item = nil) then begin
        InfoTip := '';
        exit;
    end
    else begin
        idx := Item.Index;
        p := TJabberProfile(MainSession.Prefs.Profiles.Objects[idx]);
        InfoTip := p.getJabberID().getDisplayJID();
    end;
end;

initialization
    frmRosterWindow := nil;

end.
