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
    XMLTag,
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
    Panel2: TPanel;
    imgStatus: TImage;
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
    pnlTasks: TPanel;
    lstTasks: TListView;
    splitTask: TSplitter;
    popPresence: TMenuItem;
    popSendPres: TMenuItem;
    popSendSubscribe: TMenuItem;
    pnlTaskHeader: TPanel;
    txtFrom: TStaticText;
    ImageList2: TImageList;
    Panel4: TPanel;
    btnTasks: TSpeedButton;
    popSendFile: TMenuItem;
    popActions: TPopupMenu;
    popAddContact: TMenuItem;
    popAddGroup: TMenuItem;
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
    procedure btnTasksClick(Sender: TObject);
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
  private
    { Private declarations }
    _rostercb: integer;
    _prescb: integer;
    _sessionCB: integer;
    _FullRoster: boolean;
    _pos: TRect;
    _task_height: longint;
    _task_collapsed: boolean;

    _bookmark: TTreeNode;
    _hint_text : String;


    procedure RosterCallback(event: string; tag: TXMLTag; ritem: TJabberRosterItem);
    procedure PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure ClearNodes;
    procedure RenderNode(ritem: TJabberRosterItem; p: TJabberPres);
    procedure RenderBookmark(bm: TJabberBookmark);
    procedure RemoveItemNodes(ritem: TJabberRosterItem);
    procedure RemoveGroupNode(node: TTreeNode);
    procedure ResetPanels;
    procedure DoShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    DockOffset: longint;
    Docked: boolean;

    procedure Redraw;
    procedure DockRoster;
    procedure FloatRoster;
    procedure ShowPresence(show: string);
    function  RenderGroup(grp_idx: integer): TTreeNode;
  end;

var
  frmRosterWindow: TfrmRosterWindow;

const
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


implementation
uses
    S10n,
    Transfer, 
    MsgRecv,
    PrefController,
    ExUtils, 
    Room, 
    Profile, 
    JabberID, 
    RiserWindow, 
    IQ,
    RosterAdd,
    RemoveContact,
    ChatWin,
    Jabber1,
    Session;

{$R *.DFM}

{---------------------------------------}
procedure TfrmRosterWindow.FormCreate(Sender: TObject);
begin
    // register the callback
    _FullRoster := false;
    _rostercb := MainSession.RegisterCallback(RosterCallback);
    _prescb := MainSession.RegisterCallback(PresCallback);
    _sessionCB := MainSession.RegisterCallback(SessionCallback, '/session');
    ImageList1.GetBitmap(0, imgStatus.Picture.Bitmap);
    _pos.Left := (Screen.Width div 2) - 150;
    _pos.Right := _pos.Left + 200;
    _pos.Top := (Screen.Height div 3);
    _pos.Bottom := _pos.Top + 280;

    SessionCallback('prefs', nil);
    _task_collapsed := false;
    _bookmark := nil;

    Application.ShowHint := true;
    Application.OnShowHint := DoShowHint;

end;

{---------------------------------------}
procedure TfrmRosterWindow.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    if MainSession <> nil then with MainSession do begin
        UnRegisterCallback(_rostercb);
        UnRegisterCallback(_prescb);
        // UnRegisterCallback(_sessionCB);
        end;
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
procedure TfrmRosterWindow.DoShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
    // show a hint..
    if HintInfo.HintControl = treeRoster then begin
        // Tweak the hint properties for the roster,
        // this allows us to display custom hint text
        // which is set in the MouseMove event.
        HintInfo.ReshowTimeout := 500;
        HintStr := _hint_text;
        end;
end;


{---------------------------------------}
procedure TfrmRosterWindow.SessionCallback(event: string; tag: TXMLTag);
begin
    // catch session events
    if event = '/session/disconnected' then begin
        ClearNodes();
        ShowPresence('offline');
        //pnlTasks.Visible := false;
        end
    else if event = '/session/connected' then begin
        ShowPresence('online');
        //pnlTasks.Visible := true;
        ResetPanels;
        end
    else if event = '/session/presence' then begin
        ShowPresence(MainSession.show);
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
        frmJabber.tabs.ActivePage := frmJabber.tbsMsg;
        _FullRoster := true;
        treeRoster.Items.BeginUpdate;
        ClearNodes();
        end
    else if event = '/roster/end' then begin
        _FullRoster := false;
        treeRoster.Items.EndUpdate;
        treeRoster.AlphaSort;
        treeRoster.FullExpand;
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
        bi := MainSession.Roster.GrpList.indexOf('Bookmarks');
        if bi >= 0 then
            _bookmark := TTreeNode(MainSession.Roster.GrpList.Objects[bi])
        else
            bi := MainSession.roster.GrpList.Add('Bookmarks');

        if (_bookmark = nil) then begin
            _bookmark := treeRoster.Items.AddChild(nil, 'Bookmarks');
            _bookmark.ImageIndex := ico_down;
            _bookmark.SelectedIndex := ico_down;
            MainSession.roster.GrpList.Objects[bi] :=  _bookmark;
            end;
        end;

    // add this conference to the bookmark nodes
    bm_node := treeRoster.Items.AddChild(_bookmark, bm.Name);
    bm_node.ImageIndex := 21;
    bm_node.SelectedIndex := bm_node.ImageIndex;
    bm_node.Data := bm;

    _bookmark.Expand(true);
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
        end;

    _bookmark := nil;

    treeRoster.Items.EndUpdate;
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
    _bookmark := nil;
    ClearNodes;
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
    treeRoster.FullExpand;
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

    if event = '/presence/error' then
        // do nothing
    else if (event = '/presence/unavailable') then begin
        // remove the node
        p := MainSession.PPDB.FindPres(jid, '');
        if ritem <> nil then
            RenderNode(ritem, p);
        end
    else begin
        ritem := MainSession.Roster.Find(jid);
        if ritem <> nil then
            RenderNode(ritem, p);
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.RemoveItemNodes(ritem: TJabberRosterItem);
var
    n, p: TTreeNode;
    node_list: TList;
    i: integer;
begin
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
    tmp_grps: TStringlist;
    show_online: boolean;
begin
    // The Data parameter contains a list of nodes for this item
    show_online := MainSession.Prefs.getBool('roster_only_online');
    if ((show_online) and ((p = nil) or (p.PresType = 'unavailable'))) then begin
        RemoveItemNodes(ritem);
        exit;
        end

    else if (ritem.ask = 'subscribe') then begin
        // allow these items to pass thru
        end

    else if ((ritem.subscription = 'none') or
        (ritem.subscription = '') or
        (ritem.subscription = 'remove')) then begin
        RemoveItemNodes(ritem);
        exit;
        end;

    node_list := TList(ritem.Data);
    if node_list = nil then begin
        node_list := TList.Create;
        ritem.Data := node_list;
        end;

    // for each group, put in a node
    tmp_grps := TStringlist.Create;
    tmp_grps.Assign(ritem.Groups);

    if tmp_grps.Count <= 0 then
        tmp_grps.Add('Unfiled');

    // Remove nodes that are in node_list but aren't in the grp list
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

    for g := 0 to tmp_grps.Count - 1 do begin
        cur_grp := tmp_grps[g];
        grp_idx := MainSession.Roster.GrpList.indexOf(cur_grp);

        if (grp_idx < 0) then
            grp_idx := MainSession.Roster.GrpList.Add(cur_grp);

        grp_node := TTreeNode(MainSession.Roster.GrpList.Objects[grp_idx]);
        if (grp_node = nil) then
            grp_node := RenderGroup(grp_idx);

        // check to see if this node exists under this grp_node
        cur_node := nil;
        for i := 0 to node_list.count - 1 do begin
            n := TTreeNode(node_list[i]);
            if n.HasAsParent(grp_node) then begin
                cur_node := n;
                break;
                end;
            end;

        // determine the caption
        if (ritem.Nickname <> '') then
            tmps := ritem.Nickname
        else
            tmps := ritem.jid.Full;

        if (ritem.ask = 'subscribe') then
            tmps := tmps + ' (Pending)';

        if cur_node = nil then begin
            // add a node for this person under this group
            cur_node := treeRoster.Items.AddChild(grp_node, tmps);
            node_list.Add(cur_node);
            end;

        if cur_node <> nil then begin
            cur_node.Text := tmps;
            cur_node.Data := ritem;

            // setup the image
            if p = nil then
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

            if ((not _FullRoster) and (grp_node <> nil)) then
                grp_node.Expand(true);
            end;
        end;

    if not _FullRoster then begin
        treeRoster.AlphaSort;
        treeRoster.Refresh;
        end;

end;

{---------------------------------------}
function TfrmRosterWindow.RenderGroup(grp_idx: integer): TTreeNode;
var
    grp_node: TTreeNode;
    cur_grp: string;
begin
    cur_grp := MainSession.Roster.GrpList[grp_idx];
    grp_node := treeRoster.Items.AddChild(nil, cur_grp);
    MainSession.Roster.GrpList.Objects[grp_idx] := grp_node;
    grp_node.ImageIndex := ico_Down;
    grp_node.SelectedIndex := ico_Down;
    grp_node.Data := nil;
    result := grp_node;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterDblClick(Sender: TObject);
var
    node: TTreeNode;
    ri: TJabberRosterItem;
    bm: TJabberBookmark;
begin
    // Chat with this person
    node := treeRoster.Selected;
    if node = nil then exit;
    if node.Data = nil then exit;

    if (TObject(node.Data) is TJabberRosterItem) then begin
        // chat w/ this person
        ri := TJabberRosterItem(node.Data);
        if (MainSession.Prefs.getBool(P_CHAT)) then
            StartChat(ri.jid.jid, '', true)
        else
            StartMsg(ri.jid.jid);
        end
    else if (TObject(node.Data) is TJabberBookmark) then begin
        // enter this conference
        bm := TJabberBookmark(node.Data);
        if bm.bmType = 'conference' then
            StartRoom(bm.jid.jid, MainSession.Username);
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
    if P = nil then
        _hint_text := Node.Text + ': Offline'
    else
        _hint_text := Node.Text + ': ' + p.Status;
    if _hint_text = TreeRoster.Hint then exit;
    TreeRoster.Hint := _hint_text;
end;

{---------------------------------------}
procedure TfrmRosterWindow.pnlStatusClick(Sender: TObject);
var
    cp : TPoint;
begin
    // popup the menu and to change our status
    GetCursorPos(cp);
    popStatus.Popup(cp.x, cp.y);
end;

{---------------------------------------}
procedure TfrmRosterWindow.DockRoster;
begin
    // dock the window to the main form
    StatBar.Visible := false;
    Self.ManualDock(frmJabber.pnlRoster, nil, alClient);
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
        pnlStatus.Caption := 'Want to Chat';
        ImageList1.GetBitmap(ico_Chat, imgStatus.Picture.Bitmap);
        end
    else if show = 'away' then begin
        pnlStatus.Caption := 'Away';
        ImageList1.GetBitmap(ico_Away, imgStatus.Picture.Bitmap);
        end
    else if show = 'xa' then begin
        pnlStatus.Caption := 'Ext. Away';
        ImageList1.GetBitmap(ico_XA, imgStatus.Picture.Bitmap);
        end
    else if show = 'dnd' then begin
        pnlStatus.Caption := 'Do Not Disturb';
        ImageList1.GetBitmap(ico_DND, imgStatus.Picture.Bitmap);
        end
    else if show = 'offline' then begin
        pnlStatus.Caption := 'Offline';
        ImageList1.GetBitmap(ico_Offline, imgStatus.Picture.Bitmap);
        end
    else begin
        pnlStatus.Caption := 'Available';
        ImageList1.GetBitmap(ico_Online, imgStatus.Picture.Bitmap);
        end;
    imgStatus.Refresh;
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
    MainSession.setPresence(show, MainSession.Status, MainSession.Priority);
end;

{---------------------------------------}
procedure TfrmRosterWindow.Panel2DblClick(Sender: TObject);
begin
    // reset status to online;
    ShowPresence('online');
    MainSession.setPresence('', 'Available', MainSession.Priority);
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterCollapsed(Sender: TObject;
  Node: TTreeNode);
begin
    if Node.Data = nil then begin
        Node.ImageIndex := ico_Right;
        Node.SelectedIndex := ico_Right;
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.treeRosterExpanded(Sender: TObject;
  Node: TTreeNode);
begin
    if Node.Data = nil then begin
        Node.ImageIndex := ico_Down;
        Node.SelectedIndex := ico_Down;
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
    if n = nil then exit;
    if n.Data <> nil then begin
        end
    else if X < (ImageList1.Width + 5) then begin
        // clicking on a grp's widget
        if n.Expanded then
            n.Collapse(false)
        else
            n.Expand(false);
        end;

end;

{---------------------------------------}
procedure TfrmRosterWindow.popVersionClick(Sender: TObject);
var
    iq: TJabberIQ;
    n: TTreeNode;
    ritem: TJabberRosterItem;
    p: TJabberPres;
begin
    // send a client info request
    n := treeRoster.Selected;
    ritem := TJabberRosterItem(n.Data);
    if ritem <> nil then begin
        iq := TJabberIQ.Create(MainSession, MainSession.generateID, frmJabber.CTCPCallback);
        iq.iqType := 'get';
        p := MainSession.ppdb.FindPres(ritem.jid.jid, '');
        if p = nil then begin
            // this person isn't online.
            end
        else begin
            iq.toJID := p.fromJID.full;
            if Sender = popVersion then
                iq.Namespace := XMLNS_VERSION
            else if Sender = popTime then
                iq.Namespace := XMLNS_TIME
            else if Sender = popLast then
                iq.Namespace := XMLNS_LAST;
            iq.Send;
            end;
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.btnTasksClick(Sender: TObject);
var
    bmp: TBitmap;
begin
    if (not _task_collapsed) then
        _task_height := pnlTasks.Height;

    // lstTasks.Visible := not lstTasks.Visible;
    bmp := TBitmap.Create;
    _task_collapsed := not _task_collapsed;
    if (_task_collapsed) then begin
        // shrink the task list
        pnlTasks.Height := pnlTaskHeader.Height + splitTask.Height - 1;
        ImageList2.GetBitmap(1, bmp);
        btnTasks.Glyph.Assign(bmp);
        end
    else begin
        pnlTasks.Height := _task_height;
        ImageList2.GetBitmap(0, bmp);
        btnTasks.Glyph.Assign(bmp);
        ResetPanels;
        end;
end;

{---------------------------------------}
procedure TfrmRosterWindow.ResetPanels;
begin
    pnlTasks.Align := alNone;
    splitTask.Align := alNone;

    // order here is important
    pnlShow.Align := alBottom;
    pnlTasks.Align := alBottom;
    splitTask.Align := alBottom;
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
    ritem := TJabberRosterItem(n.Data);
    if ritem <> nil then
        p := MainSession.ppdb.FindPres(ritem.jid.jid, '');

    popClientInfo.Enabled := (p <> nil);
end;

{---------------------------------------}
procedure TfrmRosterWindow.popPropertiesClick(Sender: TObject);
var
    n: TTreeNode;
    ritem: TJabberRosterItem;
begin
    // Show properties for this roster item
    n := treeRoster.Selected;
    ritem := TJabberRosterItem(n.Data);
    if ritem <> nil then
        ShowProfile(ritem.jid.jid);
end;

{---------------------------------------}
procedure TfrmRosterWindow.popRemoveClick(Sender: TObject);
var
    n: TTreeNode;
    ritem: TJabberRosterItem;
begin
    // Remove this roster item.
    n := treeRoster.Selected;
    ritem := TJabberRosterItem(n.Data);
    if ritem <> nil then
        RemoveRosterItem(ritem.jid.jid);
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
    n: TTreeNode;
    ri: TJabberRosterItem;
    pri: TJabberPres;
begin
    n := treeRoster.GetNodeAt(MousePos.X, MousePos.Y);
    o := false;
    if (n = nil) then begin
        // show the actions popup when no node is hit
        e := false;
        treeRoster.PopupMenu := popActions;
        end
    else begin
        // show the roster menu when a node is hit
        treeRoster.PopupMenu := popRoster;
        treeRoster.Selected := n;
        e := (TObject(n.Data) is TJabberRosterItem);
        if (e) then begin
            // check to see if this person is online
            ri := TJabberRosterItem(n.Data);
            pri := MainSession.ppdb.FindPres(ri.jid.jid, '');
            o := (pri <> nil);
            end;
        popChat.Enabled := e;
        popMsg.Enabled := e;
        end;

    popSendFile.Enabled := o;
    popClientInfo.Enabled := e;
    popHistory.Enabled := e;
    popProperties.Enabled := e;
end;

{---------------------------------------}
procedure TfrmRosterWindow.popHistoryClick(Sender: TObject);
var
    n: TTreeNode;
    ritem: TJabberRosterItem;
begin
    n := treeRoster.Selected;
    ritem := TJabberRosterItem(n.Data);
    if ritem <> nil then
        ShowLog(ritem.jid.jid);
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
    frmJabber.btnAddContactClick(Self);
end;

{---------------------------------------}
procedure TfrmRosterWindow.popAddGroupClick(Sender: TObject);
begin
    frmJabber.NewGroup2Click(Self);
end;

{---------------------------------------}
procedure TfrmRosterWindow.popSendPresClick(Sender: TObject);
var
    node: TTreeNode;
    ri: TJabberRosterItem;
    p: TJabberPres;
begin
    // Send whatever my presence is right now.
    node := treeRoster.Selected;
    if node = nil then exit;
    if node.Data = nil then exit;

    if (TObject(node.Data) is TJabberRosterItem) then begin
        ri := TJabberRosterItem(node.Data);
        p := TJabberPres.Create();
        p.toJID := ri.jid;
        p.Show := MainSession.Show;
        p.Status := MainSession.Status;
        p.Priority := MainSession.Priority;
        MainSession.SendTag(p);
        end;
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

end.
