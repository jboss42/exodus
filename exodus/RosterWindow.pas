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
    Unicode, XMLTag,
    Presence, Roster,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ComCtrls, ExtCtrls, Buttons, ImgList, Menus, StdCtrls;

type
  TfrmRosterWindow = class(TForm)
    treeRoster: TTreeView;
    ImageList1: TImageList;
    popRoster: TPopupMenu;
    popProperties: TMenuItem;
    popRemove: TMenuItem;
    popChat: TMenuItem;
    popMsg: TMenuItem;
    N1: TMenuItem;
    StatBar: TStatusBar;
    popStatus: TPopupMenu;
    pnlShow: TPanel;
    pnlStatus: TPanel;
    presChat: TMenuItem;
    presAvailable: TMenuItem;
    presAway: TMenuItem;
    presXA: TMenuItem;
    presDND: TMenuItem;
    popClientInfo: TMenuItem;
    popVersion: TMenuItem;
    popTime: TMenuItem;
    popLast: TMenuItem;
    popHistory: TMenuItem;
    popPresence: TMenuItem;
    popSendPres: TMenuItem;
    popSendSubscribe: TMenuItem;
    ImageList2: TImageList;
    popSendFile: TMenuItem;
    popActions: TPopupMenu;
    popAddContact: TMenuItem;
    popAddGroup: TMenuItem;
    imgStatus: TPaintBox;
    N2: TMenuItem;
    popSendInvisible: TMenuItem;
    popGroup: TPopupMenu;
    popGrpPresence: TMenuItem;
    popGrpAvailable: TMenuItem;
    popGrpInvisible: TMenuItem;
    popGrpInvite: TMenuItem;
    N3: TMenuItem;
    popGrpRename: TMenuItem;
    popGrpRemove: TMenuItem;
    popSendContacts: TMenuItem;
    N4: TMenuItem;
    NewGroup1: TMenuItem;
    InvitetoConference1: TMenuItem;
    SendContactsTo1: TMenuItem;
    popBlock: TMenuItem;
    popGroupBlock: TMenuItem;
    BroadcastMessage1: TMenuItem;
    pnlConnect: TPanel;
    lblStatus: TLabel;
    lblLogin: TLabel;
    pnlAnimation: TPanel;
    aniWait: TAnimate;
    popBookmark: TPopupMenu;
    Join1: TMenuItem;
    Properties1: TMenuItem;
    Delete1: TMenuItem;
    N5: TMenuItem;
    popTransport: TPopupMenu;
    popTransLogoff: TMenuItem;
    popTransLogon: TMenuItem;
    N6: TMenuItem;
    popTransUnRegister: TMenuItem;
    popTransProperties: TMenuItem;
    popTransRemove: TMenuItem;
    lblStatusLink: TLabel;
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
    procedure InvitetoConference1Click(Sender: TObject);
    procedure popGrpInviteClick(Sender: TObject);
    procedure popSendContactsClick(Sender: TObject);
    procedure popBlockClick(Sender: TObject);
    procedure BroadcastMessage1Click(Sender: TObject);
    procedure lblLoginClick(Sender: TObject);
    procedure treeRosterEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure treeRosterEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure treeRosterChange(Sender: TObject; Node: TTreeNode);
    procedure treeRosterExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure popTransLogoffClick(Sender: TObject);
    procedure popTransUnRegisterClick(Sender: TObject);
    procedure popTransRemoveClick(Sender: TObject);
  private
    { Private declarations }
    _rostercb: integer;
    _prescb: integer;
    _sessionCB: integer;
    _FullRoster: boolean;
    _pos: TRect;
    _task_collapsed: boolean;
    _show_status: boolean;
    _status_color: TColor;

    _change_node: TTreeNode;
    _bookmark: TTreeNode;
    _offline: TTreeNode;
    _hint_text : WideString;

    _cur_ritem: TJabberRosterItem;
    _cur_grp: Widestring;
    _cur_bm: TJabberBookmark;
    _cur_status: integer;

    _collapsed_grps: TWideStringList;
    _blockers: TWideStringlist;

    function getNodeType(node: TTreeNode = nil): integer;
    function getSelectedContacts(online: boolean = true): TList;
    procedure popUnBlockClick(Sender: TObject);
    procedure ExpandNodes;
    procedure RenderNode(ritem: TJabberRosterItem; p: TJabberPres);
    procedure RenderBookmark(bm: TJabberBookmark);
    procedure RemoveItemNodes(ritem: TJabberRosterItem);
    procedure RemoveGroupNode(node: TTreeNode);
    procedure RemoveEmptyGroups();
    procedure ResetPanels;
    procedure DoShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure ChangeStatusImage(idx: integer);
    procedure showAniStatus();

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  published
    procedure RosterCallback(event: string; tag: TXMLTag; ritem: TJabberRosterItem);
    procedure PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
    procedure SessionCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
    DockOffset: longint;
    Docked: boolean;

    procedure ClearNodes;
    procedure Redraw;
    procedure DockRoster;
    procedure FloatRoster;
    procedure ShowPresence(show: string);
    function  RenderGroup(grp_idx: integer): TTreeNode;
  end;

var
  frmRosterWindow: TfrmRosterWindow;

resourcestring
    sRemoveBookmark = 'Remove this bookmark?';
    sRenameGrp = 'Rename group';
    sRenameGrpPrompt = 'New group name:';
    sNoContactsSel = 'You must select one or more contacts.';
    sUnblockContacts = 'Unblock %d contacts?';
    sBlockContacts = 'Block %d contacts?';
    sNoBroadcast = 'You must select more than one online contact to broadcast.';
    sSignOn = 'Click to Sign On';
    sCancelLogin = 'Click to Cancel...';
    sDisconnected = 'Disconnected.';
    sConnecting = 'Trying to connect...';
    sAuthenticating = 'Connected. '#13#10 + 'Authenticating...';
    sAuthenticated = 'Authenticated.'#13#10 + 'Getting Settings...';

implementation
uses
    SelContact,
    Invite,
    Bookmark,
    S10n,
    Transfer,
    MsgRecv,
    PrefController,
    ExEvents,
    ExUtils,
    Room,
    Profile,
    JabberID,
    RiserWindow,
    IQ,
    RosterAdd,
    GrpRemove, RemoveContact,
    ChatWin,
    Jabber1,
    Transports, 
    Session;

{$R *.DFM}

{---------------------------------------}
procedure TfrmRosterWindow.FormCreate(Sender: TObject);
begin
    // register the callback
    _FullRoster := false;
    _collapsed_grps := TWideStringList.Create();
    _blockers := TWideStringlist.Create();
    _rostercb := MainSession.RegisterCallback(RosterCallback);
    _prescb := MainSession.RegisterCallback(PresCallback);
    _sessionCB := MainSession.RegisterCallback(SessionCallback, '/session');
    ChangeStatusImage(0);
    _pos.Left := (Screen.Width div 2) - 150;
    _pos.Right := _pos.Left + 200;
    _pos.Top := (Screen.Height div 3);
    _pos.Bottom := _pos.Top + 280;

    SessionCallback('/session/prefs', nil);
    _task_collapsed := false;
    _bookmark := nil;
    _offline := nil;
    _change_node := nil;
    _show_status := MainSession.Prefs.getBool('inline_status');
    _status_color := TColor(MainSession.Prefs.getInt('inline_color'));

    frmExodus.pnlRoster.ShowHint := not _show_status;

    aniWait.Filename := '';
    aniWait.ResName := 'Status';
    pnlConnect.Visible := true;
    pnlConnect.Align := alClient;

    treeRoster.Visible := false;
    pnlStatus.Visible := true;

    treeRoster.Canvas.Pen.Width := 1;

    Application.ShowHint := true;
    Application.OnShowHint := DoShowHint;
end;

{---------------------------------------}
procedure TfrmRosterWindow.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
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
procedure TfrmRosterWindow.ChangeStatusImage(idx: integer);
begin
    _cur_status := idx;
    imgStatus.Repaint();
end;

{---------------------------------------}
procedure TfrmRosterWindow.DoShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
var
    c: TControl;
    f: TForm;
begin
    // show a hint..
    c := HintInfo.HintControl;
    if (c.Owner is TForm) then
        f := TForm(c.Owner)
    else
        exit;

    {
    This is kind of hackish because the application can only
    have a single OnShowHint handler at once.. *SIGH*
    We have this functionality so that TC rooms can also
    display status just like the roster window does.
    }

    if ((f = Self) and (c = treeRoster)) then begin
        // Tweak the hint properties for the roster,
        // this allows us to display custom hint text
        // which is set in the MouseMove event.
        HintInfo.ReshowTimeout := 500;
        HintInfo.
        HintStr := _hint_text;
        end
    else if ((f is TfrmRoom) and (c is TTreeView)) then begin
        // this is a TC room
        HintInfo.ReshowTimeout := 500;
        HintStr := TfrmRoom(f).HintText;
        end;
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
procedure TfrmRosterWindow.SessionCallback(event: string; tag: TXMLTag);
var
    i: integer;
    grp_node: TTreeNode;
begin
    // catch session events
    if event = '/session/disconnected' then begin
        ClearNodes();
        ShowPresence('offline');
        MainSession.Roster.GrpList.Clear();
        treeRoster.Visible := false;
        aniWait.Active := false;
        aniWait.Visible := false;
        pnlConnect.Visible := true;
        pnlConnect.Align := alClient;
        lblStatus.Caption := sDisconnected;
        lblLogin.Caption := sSignOn;
        end

    // We are in the process of connecting
    else if event = '/session/connecting' then begin
        pnlConnect.Visible := true;
        pnlConnect.Align := alClient;
        lblStatus.Visible := true;
        lblStatus.Caption := sConnecting;
        lblLogin.Caption := sCancelLogin;
        Self.showAniStatus();
        end

    // we've got a socket connection
    else if event = '/session/connected' then begin
        lblLogin.Caption := sCancelLogin;
        lblStatus.Caption := sAuthenticating;
        Self.showAniStatus();
        ShowPresence('online');
        ResetPanels;
        end

    // we've been authenticated
    else if event = '/session/authenticated' then begin
        lblLogin.Caption := sCancelLogin;
        lblStatus.Caption := sAuthenticated;
        Self.showAniStatus();
        end

    // it's the end of the roster, update the GUI
    else if event = '/roster/end' then begin
        if (not treeRoster.Visible) then begin
            aniWait.Active := false;
            aniWait.Visible := false;
            pnlConnect.Visible := false;
            treeRoster.Visible := true;
            end;
        end

    // our own presence has changed
    else if event = '/session/presence' then begin
        ShowPresence(MainSession.show);
        end

    // preferences have been changed, refresh the roster
    else if event = '/session/prefs' then begin
        MainSession.Prefs.fillStringlist('blockers', _blockers);
        _show_status := MainSession.Prefs.getBool('inline_status');
        _status_color := TColor(MainSession.Prefs.getInt('inline_color'));
        treeRoster.Font.Name := MainSession.Prefs.getString('roster_font_name');
        treeRoster.Font.Size := MainSession.Prefs.getInt('roster_font_size');
        treeRoster.Font.Color := TColor(MainSession.Prefs.getInt('roster_font_color'));

        pnlConnect.Color := TColor(MainSession.prefs.getInt('roster_bg'));
        pnlAnimation.Color := pnlConnect.Color;
        aniWait.Color := pnlConnect.Color;

        frmExodus.pnlRoster.ShowHint := not _show_status;
        Redraw();
        end

    // someone has been blocked
    else if ((event = '/session/block') or (event = '/session/unblock')) then begin
        MainSession.Prefs.fillStringlist('col_groups', _collapsed_grps, true);
        end

    // we are getting server side prefs
    else if event = '/session/server_prefs' then begin
        MainSession.Prefs.fillStringlist('col_groups', _collapsed_grps, true);

        // Iterate over all grp nodes
        for i := 0 to MainSession.Roster.GrpList.Count - 1 do begin
            grp_node := TTreeNode(MainSession.Roster.GrpList.Objects[i]);
            if (grp_node <> nil) then begin
                if (_collapsed_grps.IndexOf(grp_node.Text) >= 0) then
                    grp_node.Collapse(true)
                else
                    grp_node.Expand(true);
                end;
            end;
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.RosterCallback(event: string; tag: TXMLTag; ritem: TJabberRosterItem);
var
    p: TJabberPres;
    bi: integer;
    bm: TJabberBookmark;
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
        treeRoster.AlphaSort;
        Self.ExpandNodes();
        if treeRoster.items.Count > 0 then
            treeRoster.TopItem := treeRoster.Items[0];
        end
    else if event = '/roster/bookmark' then begin
        bi := MainSession.Roster.Bookmarks.indexOf(tag.getAttribute('jid'));
        if bi >= 0 then begin
            bm := TJabberBookmark(MainSession.roster.Bookmarks.Objects[bi]);
            RenderBookmark(bm);
            end;
        end
    else if event = '/roster/item' then begin
        if ritem <> nil then with treeRoster do begin
            p := MainSession.ppdb.FindPres(ritem.JID.jid, '');
            RenderNode(ritem, p);
            end;
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.RenderBookmark(bm: TJabberBookmark);
var
    bi: integer;
    bm_node: TTreeNode;
begin
    // render this bookmark
    if _bookmark = nil then begin
        // create some container for bookmarks
        bi := MainSession.Roster.GrpList.indexOf(sGrpBookmarks);
        if bi >= 0 then
            _bookmark := TTreeNode(MainSession.Roster.GrpList.Objects[bi])
        else
            bi := MainSession.roster.GrpList.Add(sGrpBookmarks);

        if (_bookmark = nil) then begin
            _bookmark := treeRoster.Items.AddChild(nil, sGrpBookmarks);
            _bookmark.ImageIndex := ico_down;
            _bookmark.SelectedIndex := ico_down;
            MainSession.roster.GrpList.Objects[bi] :=  _bookmark;
            end;
        end;

    if (bm.Data <> nil) then begin
        bm_node := TTreeNode(bm.Data);
        assert(bm_node <> nil);
        bm_node.Text := bm.bmName;
        end
    else begin
        // add this conference to the bookmark nodes
        bm_node := treeRoster.Items.AddChild(_bookmark, bm.bmName);
        bm.Data := bm_node;
        bm_node.ImageIndex := 21;
        bm_node.SelectedIndex := bm_node.ImageIndex;
        bm_node.Data := bm;
        end;


    _bookmark.Expand(true);
end;

{---------------------------------------}
procedure TfrmRosterWindow.ExpandNodes;
var
    i: integer;
    n: TTreeNode;
begin
    // expand all nodes except special nodes
    for i := 0 to treeRoster.Items.Count - 1 do begin
        n := treeRoster.Items[i];
        if ((n.Level = 0) and (n <> _offline)) then begin
            if (_collapsed_grps.IndexOf(n.Text) < 0) then
                n.Expand(true);
            end;
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.ClearNodes;
var
    i:          integer;
    ri:         TJabberRosterItem;
    node_list:  TList;
begin
    treeRoster.Items.BeginUpdate;
    treeRoster.Items.Clear;

    with MainSession.Roster do begin
        // remove the grp list node pointers
        for i := 0 to GrpList.Count - 1 do
            GrpList.Objects[i] := nil;

        // remove all item pointers to tree nodes
        for i := 0 to Count - 1 do begin
            ri := TJabberRosterItem(Objects[i]);
            node_list := TList(ri.Data);
            if (node_list <> nil) then node_list.Clear;
            end;
        for i := 0 to Bookmarks.Count - 1 do
            TJabberBookmark(Bookmarks.Objects[i]).Data := nil;
        end;

    _bookmark := nil;
    _offline := nil;

    treeRoster.Items.EndUpdate;
end;

{---------------------------------------}
function TfrmRosterWindow.getNodeType(Node: TTreeNode): integer;
var
    grp_node, n: TTreeNode;
begin
    // return the type of node this is..
    if (Node = nil) then
        n := treeRoster.Selected
    else
        n := Node;

    Result := node_none;
    _cur_ritem := nil;
    _cur_bm := nil;
    _cur_grp := '';

    if (n = nil) then exit;

    if ((n.Level = 0) or
    ((treeRoster.SelectionCount > 1) and (node = nil))) then begin
        Result := node_grp;
        _cur_grp := n.Text;
        end

    else if (TObject(n.Data) is TJabberBookmark) then begin
        Result := node_bm;
        _cur_bm := TJabberBookmark(n.Data);
        end

    else if (TObject(n.Data) is TJabberRosterItem) then begin
        Result := node_ritem;
        _cur_ritem := TJabberRosterItem(n.Data);

        // check to see if it's a transport
        if (n.Level > 0) then begin
            grp_node := n.Parent;
            if (grp_node.Text = 'Transports') then
                Result := node_transport;
            end;
        end;
end;

{---------------------------------------}
function TfrmRosterWindow.getSelectedContacts(online: boolean = true): TList;
var
    i: integer;
    ri: TJabberRosterItem;
    node: TTreeNode;
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
        if (treeRoster.SelectionCount > 1) then begin
            // we have a collection of contacts selected
            for i := 0 to treeRoster.SelectionCount - 1 do begin
                node := treeRoster.Selections[i];
                if getNodeType(node) = node_ritem then begin
                    ri := TJabberRosterItem(node.Data);
                    if (((online) and (ri.IsOnline)) or (not online)) then
                        Result.Add(TJabberRosterItem(node.Data));
                    end;
                end;
            end
        else
            // we have a single grp selected
            Result := MainSession.Roster.GetGroupItems(_cur_grp, online);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.Redraw;
var
    i: integer;
    ri: TJabberRosterItem;
    bm: TJabberBookmark;
    p: TJabberPres;
begin
    // loop through all roster items and draw them
    _FullRoster := true;
    ClearNodes;
    treeRoster.Color := TColor(MainSession.prefs.getInt('roster_bg'));
    treeRoster.Items.BeginUpdate;

    // re-render each item
    with MainSession.Roster do begin
        for i := 0 to Count - 1 do begin
            ri := TJabberRosterItem(Objects[i]);
            p := MainSession.ppdb.FindPres(ri.JID.jid, '');
            RenderNode(ri, p);
            end;

        for i := 0 to Bookmarks.Count - 1 do begin
            bm := TJabberBookmark(Bookmarks.Objects[i]);
            RenderBookmark(bm);
            end;
        end;

    _FullRoster := false;
    treeRoster.AlphaSort;
    ExpandNodes();
    treeRoster.Items.EndUpdate;
end;

{---------------------------------------}
procedure TfrmRosterWindow.PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
var
    ritem: TJabberRosterItem;
    jid, ptype: string;
    tmp_jid: TJabberID;
begin
    // callback for the ppdb
    ptype := tag.getAttribute('type');
    jid := tag.getAttribute('from');
    tmp_jid := TJabberID.Create(jid);
    jid := tmp_jid.jid;
    ritem := MainSession.Roster.Find(jid);

    if (event = '/presence/error') then
        // ignore
    else if (event = '/presence/unavailable') then begin
        // remove the node
        p := MainSession.PPDB.FindPres(jid, '');
        if ritem <> nil then
            RenderNode(ritem, p);
        end
    else begin
        // possibly re-render the node based on this pres packet
        ritem := MainSession.Roster.Find(jid);

        // if we can't find the item based on bare jid, check the full jid.
        // NB: this should catch most of the transport madness.
        if ritem = nil then
            ritem := MainSession.Roster.Find(tmp_jid.full);
        if ritem <> nil then
            RenderNode(ritem, p);
        end;

    tmp_jid.Free();
end;

{---------------------------------------}
procedure TfrmRosterWindow.RemoveItemNodes(ritem: TJabberRosterItem);
var
    n, p: TTreeNode;
    node_list: TList;
    i: integer;
begin
    // Remove the nodes for this item..
    node_list := TList(ritem.Data);
    if node_list <> nil then begin
        for i := node_list.count - 1 downto 0 do begin
            n := TTreeNode(node_list[i]);
            p := n.Parent;
            n.Free;
            if (p.Count <= 0) then
                Self.RemoveGroupNode(p);
            node_list.Delete(i);
            end;
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.RemoveEmptyGroups();
var
    i: integer;
    node: TTreeNode;
begin
    // scan for any empty grps
    for i := MainSession.Roster.GrpList.Count - 1 downto 0 do begin
        node := TTreeNode(MainSession.Roster.GrpList.Objects[i]);
        if ((node <> nil) and (node.Count = 0)) then
            RemoveGroupNode(node);
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.RemoveGroupNode(node: TTreeNode);
var
    grp_idx: integer;
    grp: string;
begin
    grp := node.Text;
    grp_idx := MainSession.roster.GrpList.indexOf(grp);
    if (grp_idx >= 0) then
        MainSession.roster.GrpList.Objects[grp_idx] := nil;
    node.Free();
end;

{---------------------------------------}
procedure TfrmRosterWindow.RenderNode(ritem: TJabberRosterItem; p: TJabberPres);
var
    i, g, grp_idx: integer;
    cur_grp, tmps: string;
    cur_node, grp_node, n: TTreeNode;
    node_list: TList;
    tmp_grps: TWideStringlist;
    is_blocked: boolean;
    show_online: boolean;
    show_offgrp: boolean;
    exp_grpnode: boolean;
begin
    // Render a specific roster item, with the given presence info.
    is_blocked := MainSession.isBlocked(ritem.jid);
    if (is_blocked) then begin
        if MainSession.Prefs.getBool('roster_hide_block') then exit;
        end;

    // First Cache some prefs
    show_online := MainSession.Prefs.getBool('roster_only_online');
    show_offgrp := MainSession.Prefs.getBool('roster_offline_group');

    exp_grpnode := false;

    {
    OK, here we want to bail on some circumstances
    if the roster item is NOT supposed to be shown
    based on preferences, and the state of the roster
    item, and the current presence info.
    }

    if (ritem.ask = 'subscribe') then begin
        // allow these items to pass thru
        end

    else if (((show_online) and (not show_offgrp)) and
        ((p = nil) or (p.PresType = 'unavailable'))) then begin
        // Only show online, and don't use the offline grp
        // This person is not online, remove all nodes and bail
        RemoveItemNodes(ritem);
        exit;
        end

    else if ((ritem.Groups.IndexOf('Transports') <> -1) and
        (ritem.Groups.Count = 1) and (p <> nil)) then begin
        // we have a transport... let them pass
        end

    else if ((ritem.subscription = 'none') or
        (ritem.subscription = '') or
        (ritem.subscription = 'from') or
        (ritem.subscription = 'remove')) then begin
        // We aren't subscribed to these people,
        // or we are removing them from the roster
        RemoveItemNodes(ritem);
        exit;
        end;

    // Create a list to contain all nodes for this
    // roster item, and assign it to the .Data property
    // of the roster item object
    node_list := TList(ritem.Data);
    if node_list = nil then begin
        node_list := TList.Create;
        ritem.Data := node_list;
        end;

    // Create a temporary list of grps that this
    // contact should be in.
    tmp_grps := TWideStringlist.Create;
    if (((p = nil) or (p.PresType = 'unavailble')) and (show_offgrp)) then
        // they are offline, and we want an offline grp
        tmp_grps.Add(sGrpOffline)
    else
        // otherwise, assign the grps from the roster item
        tmp_grps.Assign(ritem.Groups);

    // If they aren't in any grps, put them into the Unfiled grp
    if tmp_grps.Count <= 0 then
        tmp_grps.Add(sGrpUnfiled);

    // Remove nodes that are in node_list but aren't in the grp list
    // This takes care of changing grps, or going to the offline grp
    for i := node_list.Count - 1 downto 0 do begin
        cur_node := TTreeNode(node_list[i]);
        grp_node := cur_node.Parent;
        cur_grp := grp_node.Text;
        if (tmp_grps.IndexOf(cur_grp) < 0) then begin
            // nuke this old node
            cur_node.Free;
            node_list.Delete(i);
            end;
        end;

    // determine the caption for the node
    if (ritem.RawNickname <> '') then
        tmps := ritem.Nickname
    else
        tmps := ritem.jid.Full;


    //if (ritem.ask = 'subscribe') then
    //    tmps := tmps + sRosterPending;

    if (_show_status) then begin
        if (p <> nil) then begin
            if (p.Status <> '') then
                tmps := tmps + ' (' + p.Status + ')';
            end;
        end;


    // For each grp in the temp. grp list,
    // Make sure a node already exists, or create one.
    for g := 0 to tmp_grps.Count - 1 do begin
        cur_grp := tmp_grps[g];

        // The offline grp is special, we keep a pointer to
        // it at all times (if it exists).
        if (cur_grp = sGrpOffline) then begin
            if (_offline = nil) then begin
                _offline := treeRoster.Items.AddChild(nil, sGrpOffline);
                _offline.ImageIndex := ico_right;
                _offline.SelectedIndex := ico_right;
                end;
            grp_node := _offline;
            end
        else begin
            // Make sure the grp exists in the GrpList
            grp_idx := MainSession.Roster.GrpList.indexOf(cur_grp);
            if (grp_idx < 0) then
                grp_idx := MainSession.Roster.GrpList.Add(cur_grp);

            // Make sure we have a node for this grp and keep
            // a pointer to the node in the Roster's grp list
            grp_node := TTreeNode(MainSession.Roster.GrpList.Objects[grp_idx]);
            if (grp_node = nil) then begin
                grp_node := RenderGroup(grp_idx);
                end;
            end;

        // Expand any grps that are not supposed to be collapsed
        if ((not _FullRoster) and
            (grp_node <> _offline) and
            (_collapsed_grps.IndexOf(grp_node.Text) < 0)) then
            exp_grpnode := true;


        // Now that we are sure we have a grp_node,
        // check to see if this node exists under it
        cur_node := nil;
        for i := 0 to node_list.count - 1 do begin
            n := TTreeNode(node_list[i]);
            if n.HasAsParent(grp_node) then begin
                cur_node := n;
                break;
                end;
            end;

        if cur_node = nil then begin
            // add a node for this person under this group
            cur_node := treeRoster.Items.AddChild(grp_node, tmps);
            node_list.Add(cur_node);
            end;

        cur_node.Text := tmps;
        cur_node.Data := ritem;

        // setup the image
        if (is_blocked) then
            cur_node.ImageIndex := ico_blocked
        else if (ritem.ask = 'subscribe') then
            cur_node.ImageIndex := ico_Unknown
        else if p = nil then
            cur_node.ImageIndex := ico_Offline
        else begin
            if p.Show = 'away' then
                cur_node.ImageIndex := ico_Away
            else if p.Show = 'xa' then
                cur_node.ImageIndex := ico_XA
            else if p.Show = 'dnd' then
                cur_node.ImageIndex := ico_DND
            else
                cur_node.ImageIndex := ico_Online
            end;

        cur_node.SelectedIndex := cur_node.ImageIndex;
        if (exp_grpnode) then grp_node.Expand(true);
        end;

    tmp_grps.Free();

    {
    If this isn't a full roster push,
    Make sure the roster is alpha sorted, and
    check for any empty groups
    }
    if not _FullRoster then begin
        treeRoster.AlphaSort;
        treeRoster.Refresh;
        RemoveEmptyGroups();
        end;

end;

{---------------------------------------}
function TfrmRosterWindow.RenderGroup(grp_idx: integer): TTreeNode;
var
    grp_node: TTreeNode;
    cur_grp: string;
begin
    // Show this group node
    cur_grp := MainSession.Roster.GrpList[grp_idx];
    grp_node := treeRoster.Items.AddChild(nil, cur_grp);
    MainSession.Roster.GrpList.Objects[grp_idx] := grp_node;
    grp_node.ImageIndex := ico_Right;
    grp_node.SelectedIndex := ico_Right;
    grp_node.Data := nil;
    result := grp_node;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterDblClick(Sender: TObject);
begin
    // Chat with this person
    _change_node := nil;
    case getNodeType() of
    node_ritem: begin
        // chat w/ this person
        if (MainSession.Prefs.getBool(P_CHAT)) then
            StartChat(_cur_ritem.jid.jid, '', true)
        else
            StartMsg(_cur_ritem.jid.jid);
        end;
    node_bm: begin
        // enter this conference
        if _cur_bm.bmType = 'conference' then
            StartRoom(_cur_bm.jid.jid, _cur_bm.nick);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
    Node : TTreeNode;
    ri  : TJabberRosterItem;
    p: TJabberPres;
begin
    // Handle the changing of the treeview Hints
    // Based on the current node we are hovering over.
    _hint_text := '';
    Node := treeRoster.GetNodeAt(x,y);
    if ((Node = nil) or (Node.HasChildren)) then exit;

    // get the roster item attached to this node.
    if (Node.Data = nil) then exit;
    if (TObject(Node.Data) is TJabberBookmark) then exit;

    ri := TJabberRosterItem(Node.Data);
    if ri = nil then exit;

    p := MainSession.ppdb.FindPres(ri.JID.jid, '');
    if MainSession.Prefs.getBool('inline_status') then
        _hint_text := ri.jid.full
    else if P = nil then
        _hint_text := ri.jid.full + ': ' + sGrpOffline
    else
        _hint_text := ri.jid.full + ': ' + p.Status;
    if _hint_text = TreeRoster.Hint then exit;
    TreeRoster.Hint := _hint_text;
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
    Self.ManualDock(frmExodus.pnlRoster, nil, alClient);
    Self.Align := alClient;
    Docked := true;
    MainSession.dock_windows := Docked;
end;

{---------------------------------------}
procedure TfrmRosterWindow.FloatRoster;
begin
    // float the window
    Self.Align := alNone;
    Self.ManualFloat(_pos);
    StatBar.Visible := true;
    Docked := false;
    MainSession.dock_windows := Docked;
end;

{---------------------------------------}
procedure TfrmRosterWindow.FormResize(Sender: TObject);
begin
    // save the pos info in _pos
    _pos.left := Self.Left;
    _pos.Right := Self.Left + Self.Width;
    _pos.Top := Self.Top;
    _pos.Bottom := Self.Top + Self.Height;
end;

{---------------------------------------}
procedure TfrmRosterWindow.ShowPresence(show: string);
begin
    // display this show type
    if show = 'chat' then begin
        lblStatusLink.Caption := sRosterChat;
        ChangeStatusImage(ico_Chat);
        end
    else if show = 'away' then begin
        lblStatusLink.Caption := sRosterAway;
        ChangeStatusImage(ico_Away);
        end
    else if show = 'xa' then begin
        lblStatusLink.Caption := sRosterXA;
        ChangeStatusImage(ico_XA);
        end
    else if show = 'dnd' then begin
        lblStatusLink.Caption := sRosterDND;
        ChangeStatusImage(ico_DND);
        end
    else if show = 'offline' then begin
        lblStatusLink.Caption := sRosterOffline;
        ChangeStatusImage(ico_Offline);
        end
    else begin
        lblStatusLink.Caption := sRosterAvail;
        ChangeStatusImage(ico_Online);
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.presAvailableClick(Sender: TObject);
var
    show: string;
begin
    // change our own presence
    case TMenuItem(Sender).Tag of
    0: begin
        show := 'chat';
        end;
    1: begin
        show := '';
        end;
    2: begin
        show := 'away';
        end;
    3: begin
        show := 'xa';
        end;
    4: begin
        show := 'dnd';
        end;
    end;
    MainSession.setPresence(show, '', MainSession.Priority);
end;

{---------------------------------------}
procedure TfrmRosterWindow.Panel2DblClick(Sender: TObject);
begin
    // reset status to online;
    ShowPresence('online');
    MainSession.setPresence('', sRosterAvail, MainSession.Priority);
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterCollapsed(Sender: TObject;
  Node: TTreeNode);
begin
    if Node.Data = nil then begin
        Node.ImageIndex := ico_Right;
        Node.SelectedIndex := ico_Right;

        if (_collapsed_grps.IndexOf(Node.Text) < 0) then begin
            _collapsed_grps.Add(Node.Text);
            MainSession.Prefs.setStringlist('col_groups', _collapsed_grps, true);
            end;
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterExpanded(Sender: TObject;
  Node: TTreeNode);
var
    i: integer;
    dirty: boolean;
begin
    if Node.Data = nil then begin
        Node.ImageIndex := ico_Down;
        Node.SelectedIndex := ico_Down;
        dirty := false;
        repeat
            i := _collapsed_grps.IndexOf(node.Text);
            if (i >= 0) then begin
                dirty := true;
                _collapsed_grps.Delete(i);
                end;
        until (i < 0);

        if (dirty) then
            MainSession.Prefs.setStringlist('col_groups', _collapsed_grps, true);
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
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

    if n.Data <> nil then begin
        end
    else if X < (ImageList1.Width + 5) then begin
        // clicking on a grp's widget
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
                // TODO: re-render to get rid of inline status before editing
                // Hey PGM!
                n.Text := _cur_ritem.Nickname;
                end;
            n.EditText();
            end
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popVersionClick(Sender: TObject);
var
    jid: string;
    p: TJabberPres;
begin
    // send a client info request
    if (getNodeType() <> node_ritem) then exit;
    if (_cur_ritem = nil) then exit;

    p := MainSession.ppdb.FindPres(_cur_ritem.jid.jid, '');
    if p = nil then
        // this person isn't online.
        jid := _cur_ritem.jid.jid
    else
        jid := p.fromJID.full;

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
end;

{---------------------------------------}
procedure TfrmRosterWindow.popRosterPopup(Sender: TObject);
var
    n: TTreeNode;
    p: TJabberPres;
    ritem: TJabberRosterItem;
begin
    // Check to see if this person is online or not
    p := nil;
    n := treeRoster.Selected;

    if (getNodeType(n) = node_ritem) then begin
        ritem := TJabberRosterItem(n.Data);
        if ritem <> nil then
            p := MainSession.ppdb.FindPres(ritem.jid.jid, '');

        popVersion.Enabled := (p <> nil);
        popTime.Enabled := (p <> nil);
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popPropertiesClick(Sender: TObject);
begin
    // Show properties for this roster item
    case getNodeType() of
    node_ritem: begin
        if (_cur_ritem <> nil) then
            ShowProfile(_cur_ritem.jid.jid);
        end;
    node_bm: begin
        if (_cur_bm <> nil) then
            ShowBookmark(_cur_bm.jid.full);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popRemoveClick(Sender: TObject);
begin
    // Remove this roster item.
    case getNodeType() of
    node_bm: begin
        // remove a bookmark
        if (MessageDlg(sRemoveBookmark, mtConfirmation,
            [mbYes, mbNo], 0) = mrNo) then exit;
        MainSession.roster.RemoveBookmark(_cur_bm.jid.full);
        treeRoster.Selected.Free;
        end;
    node_ritem: begin
        // remove a roster item
        if _cur_ritem <> nil then
            RemoveRosterItem(_cur_ritem.jid.jid);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    i: integer;
    ritem: TJabberRosterItem;
    d_grp: string;
    d_node: TTreeNode;
    s_node: TTreeNode;
begin
    // Drop the roster items onto the roster

    // d_node   : the new group node
    // d_grp    : the new group name
    // s_node   : selected node we are changing (the thing that was dropped)

    d_node := treeRoster.GetNodeAt(X, Y);
    if d_node = nil then exit;
    if d_node.Data <> nil then begin
        if (TObject(d_node.Data) is TJabberRosterItem) then
            d_node := d_node.Parent
        else
            exit;
        end;

    d_grp := d_node.Text;
    for i := 0 to treeRoster.SelectionCount - 1 do begin
        s_node := treeRoster.Selections[i];
        ritem := TJabberRosterItem(s_node.Data);
        if ritem <> nil then begin
            if (ritem.Groups.IndexOf(d_grp) < 0) then begin
                ritem.Groups.Clear;
                ritem.Groups.Add(d_grp);
                ritem.update;
                end;
            end;
        end;

    // Make sure d_grp is expanded if it's not in _collapsed_grps
    if ((not d_node.expanded) and (_collapsed_grps.IndexOf(d_grp) < 0)) then
        d_node.Expand(true);

end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    // Only accept items from the roster
    Accept := (Source = treeRoster);
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
    o, e: boolean;
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
    node_bm: begin
        treeRoster.PopupMenu := popBookmark;
        treeRoster.Selected := n;
        end;
    node_transport: begin
        treeRoster.PopupMenu := popTransport;
        treeRoster.Selected := n;
        end;
    node_ritem: begin
        // show the roster menu when a node is hit
        treeRoster.PopupMenu := popRoster;
        treeRoster.Selected := n;
        o := false;
        e := (TObject(n.Data) is TJabberRosterItem);
        if (e) then begin
            // check to see if this person is online
            ri := TJabberRosterItem(n.Data);
            pri := MainSession.ppdb.FindPres(ri.jid.jid, '');
            o := (pri <> nil);
            end;
        popChat.Enabled := e;
        popMsg.Enabled := e;
        popProperties.Enabled := true;
        popSendFile.Enabled := o and (MainSession.Profile.ConnectionType = conn_normal);
        popPresence.Enabled := e;
        popClientInfo.Enabled := true;
        popVersion.Enabled := o;
        popTime.Enabled := o;
        popHistory.Enabled := e;

        if ((ri <> nil) and (MainSession.isBlocked(ri.jid))) then begin
            popBlock.Caption := 'UnBlock';
            popBlock.OnClick := popUnblockClick;
            end
        else begin
            popBlock.Caption := 'Block';
            popBlock.OnClick := popBlockClick;
            end;
        popGroupBlock.OnClick := popBlock.OnClick;
        popBlock.Enabled := true;
        end;
    node_grp: begin
        // we have multiple contacts or a group selected
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
            popGroupBlock.Caption := 'Block';
            popGroupBlock.Enabled := false;
            popBlock.OnClick := popBlockClick;
            end
        else if (b) then begin
            popGroupBlock.Caption := 'Block';
            popGroupBlock.Enabled := true;
            popBlock.OnClick := popBlockClick;
            end
        else if (u) then begin
            popGroupBlock.Caption := 'UnBlock';
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
    n: TTreeNode;
    ritem: TJabberRosterItem;
begin
    // Show history for this user
    n := treeRoster.Selected;
    if (getNodeType(n) = node_ritem) then begin
        ritem := TJabberRosterItem(n.Data);
        if ritem <> nil then
            ShowLog(ritem.jid.jid);
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popChatClick(Sender: TObject);
var
    node: TTreeNode;
begin
    // chat w/ contact
    node := treeRoster.Selected;
    if node = nil then exit;
    if node.Data = nil then exit;

    if (TObject(node.Data) is TJabberRosterItem) then begin
        StartChat(TJabberRosterItem(node.Data).jid.jid, '', true);
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popMsgClick(Sender: TObject);
var
    node: TTreeNode;
begin
    // send a normal msg
    node := treeRoster.Selected;
    if node = nil then exit;
    if node.Data = nil then exit;

    if (TObject(node.Data) is TJabberRosterItem) then
        StartMsg(TJabberRosterItem(node.Data).jid.jid);
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
        FileSend(TJabberRosterItem(node.Data).jid.jid);
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
    ptype, pshow, pstatus: string;
    pri: integer;
begin
    // Send whatever my presence is right now.
    recips := getSelectedContacts(true);

    if (recips.Count > 0) then begin
        ptype := '';
        if ((Sender = popSendInvisible) or (Sender = popGrpInvisible)) then
            ptype := 'invisible';
        pshow := MainSession.Show;
        pstatus := MainSession.Status;
        pri := MainSession.Priority;

        // Send pres to everyone in the list.
        for i := 0 to recips.Count - 1 do begin
            t := TXMLTag.Create('presence');
            if (ptype) <> '' then t.PutAttribute('type', ptype);
            if (pshow) <> '' then t.AddBasicTag('show', pshow);
            if (pstatus) <> '' then t.AddBasicTag('status', pstatus);
            if (pri > 0) then t.AddBasicTag('priority', IntToStr(pri));

            t.PutAttribute('to', TJabberRosterItem(recips[i]).jid.full);
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
    tw: integer;
    c1, c2: string;
    xRect: TRect;
    nRect: TRect;
    p: TJabberPres;
    main_color, stat_color: TColor;
begin
    // Try drawing the roster custom..
    DefaultDraw := true;
    if (Node.Level = 0) then
        treeRoster.Canvas.Font.Style := [fsBold]
    else begin
        // we are drawing some kind of node
        treeRoster.Canvas.Font.Style := [];
        case getNodeType(Node) of
        node_bm: DefaultDraw := true;
        node_transport: DefaultDraw := true;
        node_ritem: begin
            // draw a roster item
            if (_show_status) then begin

                // determine the caption
                if (_cur_ritem.RawNickname <> '') then
                    c1 := _cur_ritem.Nickname
                else
                    c1 := _cur_ritem.jid.Full;

                if (_cur_ritem.ask = 'subscribe') then
                    c1 := c1 + sRosterPending;

                p := MainSession.ppdb.FindPres(_cur_ritem.jid.jid, '');
                if (p <> nil) then begin
                    if (p.Status <> '') then
                        c2 := '(' + p.Status + ')';
                    end;

                with treeRoster.Canvas do begin
                    TextFlags := ETO_OPAQUE;
                    tw := TextWidth(c1);
                    xRect := Node.DisplayRect(true);
                    xRect.Right := xRect.Left + tw + 8 + TextWidth(c2);
                    nRect := xRect;
                    nRect.Left := nRect.Left - (2*treeRoster.Indent);

                    if (cdsSelected in State) then begin
                        Font.Color := clHighlightText;
                        Brush.Color := clHighlight;
                        FillRect(xRect);
                        end
                    else begin
                        Font.Color := clWindowText;
                        Brush.Color := treeRoster.Color;
                        Brush.Style := bsSolid;
                        FillRect(xRect);
                        end;

                    // draw the image
                    ImageList1.Draw(treeRoster.Canvas, nRect.Left + treeRoster.Indent,
                        nRect.Top, Node.ImageIndex);

                    // draw the text
                    if (cdsSelected in State) then begin
                        main_color := clHighlightText;
                        stat_color := main_color;
                        end
                    else begin
                        main_color := treeRoster.Font.Color;
                        stat_color := _status_color;
                    end;

                    SetTextColor(treeRoster.Canvas.Handle, ColorToRGB(main_color));
                    TextOut(xRect.Left + 1, xRect.Top + 1, c1);
                    SetTextColor(treeRoster.Canvas.Handle, ColorToRGB(stat_color));
                    TextOut(xRect.Left + tw + 5, xRect.Top + 1, c2);

                    if (cdsSelected in State) then
                        // Draw the focus box.
                        treeRoster.Canvas.DrawFocusRect(xRect);
                    end;

                DefaultDraw := false;
                end
            else
                DefaultDraw := true;
            end;
        end;

        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.imgStatusPaint(Sender: TObject);
begin
    ImageList1.Draw(imgStatus.Canvas, 1, 1, _cur_status);
end;

{---------------------------------------}
procedure TfrmRosterWindow.popGrpRenameClick(Sender: TObject);
var
    old_grp, new_grp: string;
    gi, i: integer;
    ri: TJabberRosterItem;
begin
    // Rename some grp.
    new_grp := treeRoster.Selected.Text;
    if (InputQuery(sRenameGrp, sRenameGrpPrompt, new_grp)) then begin
        old_grp := treeRoster.Selected.Text;
        new_grp := Trim(new_grp);
        if (new_grp <> old_grp) then begin
            for i := 0 to MainSession.Roster.Count - 1 do begin
                ri := MainSession.Roster.Items[i];
                gi := ri.Groups.IndexOf(old_grp);
                if (gi >= 0) then begin
                    ri.Groups.Delete(gi);
                    ri.Groups.Add(new_grp);
                    ri.update();
                    end;
                end;
            end;
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popGrpRemoveClick(Sender: TObject);
var
    recips: TList;
begin
    // Remove the grp..
    if (treeRoster.SelectionCount = 1) then
        RemoveGroup(_cur_grp)
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
    if MainSession <> nil then with MainSession do begin
        UnRegisterCallback(_rostercb);
        UnRegisterCallback(_prescb);
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.InvitetoConference1Click(Sender: TObject);
var
    jids: TWideStringList;
begin
    //Show the invite window w/ this JID
    if (_cur_ritem = nil) then exit;

    jids := TWideStringlist.Create();
    jids.Add(_cur_ritem.jid.jid);

    ShowInvite('', jids);
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
    x, item, msg: TXMLTag;
    s, i: integer;
    ri: TJabberRosterItem;
    sel: TList;
begin
    // Send contacts to this JID..
    sel := getSelectedContacts(false);
    if (sel.Count = 0) then begin
        MessageDlg(sNoContactsSel, mtError, [mbOK], 0);
        sel.Free();
        exit;
        end;

    fsel := TfrmSelContact.Create(Application);
    // fsel.frameTreeRoster1.DrawRoster(false);
    fsel.frameTreeRoster1.treeRoster.MultiSelect := false;

    frmExodus.PreModal(fsel);

    if (fsel.ShowModal = mrOK) then begin
        // do the send
        msg := TXMLTag.Create('message');
        msg.PutAttribute('id', MainSession.generateID());
        msg.PutAttribute('to', fsel.GetSelectedJID());

        s := treeRoster.SelectionCount;

        msg.AddBasicTag('body', Format(sMsgRosterItems, [s]));
        x := msg.AddTag('x');
        x.PutAttribute('xmlns', XMLNS_XROSTER);
        for i := 0 to sel.Count - 1 do begin
            ri := TJabberRosterItem(sel[i]);
            item := x.AddTag('item');
            item.PutAttribute('jid', ri.jid.full);
            item.PutAttribute('name', ri.RawNickname);
            end;

        MainSession.SendTag(msg);
        end;

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
        if (MessageDlg(Format(sBlockContacts, [recips.Count]), mtConfirmation,
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
        if (MessageDlg(Format(sUnblockContacts, [recips.Count]), mtConfirmation,
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
    r := getSelectedContacts(true);
    if (r.Count <= 1) then
        MessageDlg(sNoBroadcast, mtError, [mbOK], 0)
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
procedure TfrmRosterWindow.lblLoginClick(Sender: TObject);
begin
    // Login to the client..
    if (lblLogin.Caption = sCancelLogin) then begin
        // Cancel the connection
        MainSession.Disconnect();
        end
    else if (lblLogin.Caption = sCancelReconnect) then begin
        // cancel reconnect
        frmExodus.timReconnect.Enabled := false;
        Self.SessionCallback('/session/disconnected', nil);
        end
    else
        // Normal, show the login window
        PostMessage(frmExodus.Handle, WM_SHOWLOGIN, 0, 0);
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
var
    ntype: integer;
begin
    // user is trying to change a node caption
    ntype := getNodeType(Node);
    AllowEdit := not (ntype = node_grp);
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterEdited(Sender: TObject;
  Node: TTreeNode; var S: String);
begin
    // user is done editing a node
    getNodeType(Node);
    if (_cur_ritem <> nil) then begin
        _cur_ritem.Nickname := s;
        _cur_ritem.update();
        end
    else if (_cur_bm <> nil) then begin
        _cur_bm.bmName := S;
        MainSession.Roster.UpdateBookmark(_cur_bm);
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterChange(Sender: TObject;
  Node: TTreeNode);
begin
    _change_node := Node;
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
            p.PutAttribute('type', 'unavailable');
        p.PutAttribute('to', _cur_ritem.jid.full);
        MainSession.SendTag(p);
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popTransUnRegisterClick(Sender: TObject);
begin
    // unregister from the transport.
    RemoveTransport(_cur_ritem.jid.jid);
end;

{---------------------------------------}
procedure TfrmRosterWindow.popTransRemoveClick(Sender: TObject);
begin
    RemoveRosterItem(_cur_ritem.jid.full);
end;

end.
