unit ActivityWindow;

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

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, Dockable, TntComCtrls, ComCtrls, ExtCtrls,
  TntExtCtrls, ExodusDockManager, StdCtrls, ExGradientPanel,
  AWItem, Unicode, DockWindow, Menus, TntMenus, TntStdCtrls;

type

  TScrollState = (ssDisabled, ssEnabled, ssPriority, ssNewWindow);

  TAWTrackerItem = class
  private
    { Private declarations }
    _dockable_frm: TfrmDockable;
    _awItem: TfAWItem;

  protected
    { Protected declarations }

  public
    { Public declarations }
    property frm: TfrmDockable read _dockable_frm write _dockable_frm;
    property awItem: TfAWItem read _awItem write _awItem;
  end;

  TfrmActivityWindow = class(TExForm)
    pnlListBase: TExGradientPanel;
    pnlListScrollUp: TExGradientPanel;
    pnlListScrollDown: TExGradientPanel;
    pnlList: TExGradientPanel;
    pnlListSort: TExGradientPanel;
    imgScrollUp: TImage;
    imgScrollDown: TImage;
    ScrollUpBevel: TBevel;
    ScrollDownBevel: TBevel;
    SortBevel: TBevel;
    lblSort: TTntLabel;
    popAWSort: TTntPopupMenu;
    mnuAlphaSort: TTntMenuItem;
    mnuRecentSort: TTntMenuItem;
    mnuTypeSort: TTntMenuItem;
    mnuUnreadSort: TTntMenuItem;
    SortTopSpacer: TBevel;
    ListLeftSpacer: TBevel;
    ListRightSpacer: TBevel;
    imgSortArrow: TImage;
    pnlBorderTop: TExGradientPanel;
    pnlBorderBottom: TExGradientPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pnlListScrollUpClick(Sender: TObject);
    procedure pnlListScrollDownClick(Sender: TObject);
    procedure mnuAlphaSortClick(Sender: TObject);
    procedure mnuRecentSortClick(Sender: TObject);
    procedure mnuTypeSortClick(Sender: TObject);
    procedure mnuUnreadSortClick(Sender: TObject);
    procedure pnlListSortClick(Sender: TObject);
  private
    { Private declarations }
    _trackingList: TWidestringList;
    _docked: boolean;
    _activeitem: TfAWItem;
    _dockwindow: TfrmDockWindow;
    _showingTopItem: integer;
    _newActivateSheet: TTntTabSheet;
    _oldActivateSheet: TTntTabSheet;
    _curListSort: TSortState;
    _canScrollUp: boolean;
    _canScrollDown: boolean;
    _scrollPriorityStartColor: TColor;
    _scrollPriorityEndColor: TColor;
    _scrollNewWindowStartColor: TColor;
    _scrollNewWindowEndColor: TColor;
    _scrollDefaultStartColor: TColor;
    _scrollDefaultEndColor: TColor;
    _scrollEnabledStartColor: TColor;
    _scrollEnabledEndColor: TColor;
    _scrollUpState: TScrollState;
    _scrollDownState: TScrollState;
    _currentActivePage: TTntTabSheet;

    procedure _clearTrackingList();
    function _findItem(awitem: TfAWItem): TAWTrackerItem;
    procedure _sortTrackingList(sortType: TSortState = ssUnsorted);
    procedure _updateDisplay(allowPartialVisible: boolean = true);
    procedure _activateNextDockedItem(curitemindx: integer);
    procedure _enableScrollUp(doenable: boolean = true);
    procedure _enableScrollDown(doenable: boolean = true);
    procedure _setScrollUpColor();
    procedure _setScrollDownColor();
    function _getItemCount(): integer;
  protected
    { Protected declarations }
    procedure CreateParams(Var params: TCreateParams); override;
    procedure onItemClick(Sender: TObject);

  public
    { Public declarations }
    procedure activateItem(awitem: TfAWItem); overload;
    procedure DockActivityWindow(dockSite : TWinControl);
    procedure removeItem(item:TAWTrackerItem); overload;
    procedure removeItem(id:widestring); overload;
    function addItem(id:widestring; frm:TfrmDockable): TAWTrackerItem;
    function findItem(id:widestring): TAWTrackerItem; overload;
    function findItem(frm:TfrmDockable): TAWTrackerItem; overload;
    function findItem(awitem: TfAWItem): TAWTrackerItem; overload;
    procedure activateItem(id:widestring); overload;
    procedure scrollToActive();
    procedure setDockingSpacers(dockstate: TDockStates);
    procedure itemChangeUpdate();
    procedure selectNextItem();
    procedure selectPrevItem();

    property docked: boolean read _docked write _docked;
    property dockwindow: TfrmDockWindow read _dockwindow write _dockwindow;
    property currentActivePage: TTntTabSheet read _currentActivePage;
    property itemCount: integer read _getItemCount;
  end;

  // Global Functions
  procedure DockActivityWindow(docksite : TWinControl);
  function GetActivityWindow() : TfrmActivityWindow;
  procedure CloseActivityWindow();

var
  frmActivityWindow: TfrmActivityWindow;

implementation

uses
    Room, ChatWin, Session,
    Jabber1, RosterImages, gnugettext,
    XMLTag, ExUtils;

{$R *.dfm}

const
    sSortBy         = 'Sort By:  ';
    sSortUnsorted   = 'Unsorted';  // Not currently supported
    sSortAlpha      = 'Alphabetical';
    sSortRecent     = 'Recent Activity';
    sSortType       = 'Type';
    sSortUnread     = 'Unread Messages';


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure DockActivityWindow(docksite : TWinControl);
begin
    if (frmActivityWindow <> nil) then
        frmActivityWindow.DockActivityWindow(docksite);
end;

{
    Get the singleton instance of the activity window
}
function GetActivityWindow() : TfrmActivityWindow;
begin
    if (frmActivityWindow = nil) then
        frmActivityWindow := TfrmActivityWindow.Create(Application);
    Result := frmActivityWindow;
end;

{
    Free the singleton activity window
}
procedure CloseActivityWindow();
begin
    if (frmActivityWindow <> nil) then begin
        frmActivityWindow.Close();
        frmActivityWindow := nil;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmActivityWindow.CreateParams(Var params: TCreateParams);
begin
    // Make this window show up on the taskbar
    inherited CreateParams( params );
    params.ExStyle := params.ExStyle or WS_EX_APPWINDOW;
end;

{---------------------------------------}
procedure TfrmActivityWindow.FormCreate(Sender: TObject);
var
    tag: TXMLTag;
begin
    inherited;
    _trackingList := TWidestringList.Create;
    _showingTopItem := -1;
    _canScrollUp := false;
    _canScrollDown := false;
    _oldActivateSheet := nil;

    case MainSession.Prefs.getInt('activity_window_sort') of
        0: begin
            _curListSort := ssUnsorted;
            lblSort.Caption := _(sSortBy) + _(sSortUnsorted);
        end;
        1: begin
            _curListSort := ssAlpha;
            lblSort.Caption := _(sSortBy) + _(sSortAlpha);
        end;
        2: begin
            _curListSort := ssRecent;
            lblSort.Caption := _(sSortBy) + _(sSortRecent);
        end;
        3: begin
            _curListSort := ssType;
            lblSort.Caption := _(sSortBy) + _(sSortType);
        end;
        4: begin
            _curListSort := ssUnread;
            lblSort.Caption := _(sSortBy) + _(sSortUnread);
        end;
    end;

    frmExodus.ImageList2.GetIcon(RosterTreeImages.Find('arrow_up'), imgScrollUp.Picture.Icon);
    frmExodus.ImageList2.GetIcon(RosterTreeImages.Find('arrow_down'), imgScrollDown.Picture.Icon);
    frmExodus.ImageList2.GetIcon(RosterTreeImages.Find('arrow_down'), imgSortArrow.Picture.Icon);

    _scrollUpState := ssDisabled;
    _scrollDownState := ssEnabled;
    _scrollDefaultStartColor := pnlListScrollUp.GradientProperites.startColor;
    _scrollDefaultEndColor := pnlListScrollUp.GradientProperites.endColor;
    _scrollEnabledStartColor := $00C4B399;
    _scrollEnabledEndColor := $00A58A69;
    _scrollPriorityStartColor := $000000ff;
    _scrollPriorityEndColor := $000000ff;
    _scrollNewWindowStartColor := $0000ffff;
    _scrollNewWindowEndColor := $0000aaaa;
    tag := MainSession.Prefs.getXMLPref('activity_window_high_priority_color');
    if (tag <> nil) then begin
        _scrollPriorityStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
        _scrollPriorityEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
    end;
    tag.Free();
    tag := MainSession.Prefs.getXMLPref('activity_window_new_window_color');
    if (tag <> nil) then begin
        _scrollNewWindowStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
        _scrollNewWindowEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
    end;
    tag.Free();
end;

{---------------------------------------}
procedure TfrmActivityWindow.FormDestroy(Sender: TObject);
var
    listsort: integer;
begin
    inherited;
    _clearTrackingList();
    _trackingList.Free;
    case _curListSort of
        ssUnsorted: listSort := 0;
        ssAlpha: listSort := 1;
        ssRecent: listSort := 2;
        ssType: listSort := 3;
        ssUnread: listSort := 4;
        else
            listSort := 0;
    end;
    MainSession.Prefs.setInt('activity_window_sort', listSort);
end;

{---------------------------------------}
procedure TfrmActivityWindow.FormResize(Sender: TObject);
begin
    imgScrollUp.Left := (pnlListScrollUp.Width div 2) - (imgScrollUp.Width div 2);
    imgScrollDown.Left := (pnlListScrollDown.Width div 2) - (imgScrollDown.Width div 2);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.mnuAlphaSortClick(Sender: TObject);
begin
    _sortTrackingList(ssAlpha);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.mnuRecentSortClick(Sender: TObject);
begin
    _sortTrackingList(ssRecent);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.mnuTypeSortClick(Sender: TObject);
begin
    _sortTrackingList(ssType);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.mnuUnreadSortClick(Sender: TObject);
begin
    _sortTrackingList(ssUnread);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow._clearTrackingList();
var
    i: integer;
    item: TAWTrackerItem;
begin
    try
        for i := _trackingList.Count - 1 downto 0 do begin
            item := TAWTrackerItem(_trackingList.Objects[i]);
            if (item <> nil) then begin
                removeItem(item);
            end;
            _trackingList.Delete(i);
        end;
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.removeItem(item:TAWTrackerItem);
var
    i: integer;
begin
    if (item = nil) then exit;

    for i := 0 to _trackingList.Count - 1 do begin
        if (item = TAWTrackerItem(_trackingList.Objects[i])) then begin
            // Change active item
            if (_activeitem = item.awItem) then begin
                _activeitem := nil;
            end;
            if (_trackingList.Count > 1) then begin
                _activateNextDockedItem(i);
            end;

            // Remove from list
            _trackingList.Delete(i);

            // Delete item
            item.frm := nil;
            item.awItem.Free();
            item.awItem := nil;
            item.Free();

            // Update list view
            _updateDisplay();

            if (_trackingList.Count <= 0) then begin
                _showingTopItem := -1;
            end;

            break;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.removeItem(id:widestring);
var
    item: TAWTrackerItem;
begin
    item := findItem(id);
    if (item <> nil) then begin
        removeItem(item);
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.addItem(id:widestring; frm:TfrmDockable): TAWTrackerItem;
begin
    Result := findItem(id);

    if ((Result = nil) and
        (frm <> nil)) then begin
        Result := TAWTrackerItem.Create();
        Result.awItem := TfAWItem.Create(nil);
        Result.frm := frm;
        _trackingList.AddObject(id, Result);
        Result.awItem.OnClick := Self.onItemClick;

        // Setup item props
        Result.awItem.Parent := pnlList;
        Result.awItem.Align := alNone;
        Result.awItem.Left := ListLeftSpacer.Width;
        Result.awItem.Width := pnlList.Width - ListLeftSpacer.Width - ListRightSpacer.Width;
        Result.awItem.name := frm.Caption;
        Result.awItem.defaultStartColor := pnlList.GradientProperites.startColor;
        Result.awItem.defaultEndColor := pnlList.GradientProperites.endColor;

        if (_showingTopItem < 0) then begin
            _showingTopItem := 0;
        end;

        // Keep sort
        _sortTrackingList(_curListSort);

        _updateDisplay();
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.findItem(id:widestring): TAWTrackerItem;
var
    idx: integer;
begin
    Result := nil;

    idx := _trackingList.IndexOf(id);

    if (idx >= 0) then begin
        Result := TAWTrackerItem(_trackingList.Objects[idx]);
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.findItem(frm:TfrmDockable): TAWTrackerItem;
var
    i:integer;
    item: TAWTrackerItem;
begin
    Result := nil;

    for i := 0 to _trackingList.Count - 1 do begin
        item := TAWTrackerItem(_trackingList.Objects[i]);
        if (item.frm = frm) then begin
            Result := item;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.findItem(awitem: TfAWItem): TAWTrackerItem;
var
    i: integer;
    item: TAWTrackerItem;
begin
    Result := nil;

    for i := 0 to _trackingList.Count - 1 do begin
        item := TAWTrackerItem(_trackingList.Objects[i]);
        if (item.awitem = awitem) then begin
            Result := item;
            exit;
        end;
    end;
end;


{---------------------------------------}
procedure TfrmActivityWindow.DockActivityWindow(dockSite : TWinControl);
begin
    if (dockSite <> Self.Parent) then begin
        Self.ManualDock(dockSite, nil, alClient);
        Application.processMessages();
        Self.Align := alClient;
        _docked := true;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.activateItem(id:widestring);
var
    awitem: TfAWItem;
    trackeritem: TAWTrackerItem;
begin
    if (id = '') then exit;

    trackeritem := findItem(id);
    if (trackeritem <> nil) then begin
        awitem := trackeritem.awItem;
        if (awitem <> nil) then begin
            activateItem(awitem);
        end;
    end;
end;


{---------------------------------------}
procedure TfrmActivityWindow.onItemClick(Sender: TObject);
var
    awitem: TfAWItem;
    trackitem: TAWTrackerItem;
begin
    if (Sender = nil) then exit;

    try
        awitem := TfAWItem(Sender);
        activateItem(awitem);
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.pnlListScrollDownClick(Sender: TObject);
begin
    if (_canScrollDown) then begin
        Inc(_showingTopItem);
        _updateDisplay(); 
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.pnlListScrollUpClick(Sender: TObject);
begin
    if (_canScrollUp) then begin
        if (_showingTopItem > 0) then begin
            Dec(_showingTopItem);
        end;
        _updateDisplay();
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.pnlListSortClick(Sender: TObject);
var
    p: TPoint;
begin
    GetCursorPos(p);
    popAWSort.Popup(p.X, p.Y);
end;

{---------------------------------------}
procedure TfrmActivityWindow.activateItem(awitem: TfAWItem);
var
    trackitem: TAWTrackerItem;
    tsheet: TTntTabSheet;
    i: integer;
begin
    if (awitem = nil) then exit;

    try
        // Set the active state of the List Item
        try
            if (_activeitem <> nil) then begin
                _activeitem.activate(false);
            end;
        except
            _activeitem := nil;
        end;
        awitem.activate(true);
        _activeitem := awitem;

        trackitem := _findItem(awitem);

        if (trackitem <> nil) then begin
            trackitem.frm.ClearUnreadMsgCount();
            trackitem.awItem.count := trackitem.frm.UnreadMsgCount;
            if (trackitem.frm.Docked) then begin
                tsheet := _dockwindow.getTabSheet(trackitem.frm);
                if (tsheet <> nil) then begin
                    try
                        for I := 0 to _dockWindow.AWTabControl.PageCount - 1 do begin
                            _dockWindow.AWTabControl.Pages[i].Visible := false;
                        end;
                        tsheet.Visible := true;
                        _oldActivateSheet := tsheet;
                    except
                    end;
                end;
            end
            else begin
                trackitem.frm.BringToFront;
                scrollToActive();
            end;
        end;

    except
    end;
end;

{---------------------------------------}
function TfrmActivityWindow._findItem(awitem: TfAWItem): TAWTrackerItem;
var
    item: TAWTrackerItem;
    i: integer;
begin
    Result := nil;
    if (awitem = nil) then exit;

    for i := 0 to _trackingList.Count -1 do begin
        item := TAWTrackerItem(_trackingList.Objects[i]);
        if (item.awItem = awitem) then begin
            Result := item;
            break;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow._sortTrackingList(sortType: TSortState);
var
    i,j: integer;
    insertPoint: integer;
    tempitem1, tempitem2: TAWTrackerItem;
    tempList: TWidestringList;
    itemadded: boolean;
    roomList, chatList, otherList: TWidestringList;
    sortstring: widestring;
begin
    if (sortType = ssUnsorted) then exit;

    _curListSort := sortType;
    tempList := TWidestringList.Create();

    sortstring := _(sSortBy);

    // Always do an Alpha sort first
    _trackingList.Sort;

    if (sortType = ssAlpha) then begin
        sortstring := sortstring + _(sSortAlpha);
    end
    // Refine sort if something other then Alpha
    else if (sortType = ssRecent) then begin
        // Sort by most Recent Activity, then by alpha for tied items
        sortstring := sortstring + _(sSortRecent);
        for i := 0 to _trackingList.Count - 1 do begin
            // iterate over list to reorder
            itemadded := false;
            tempitem1 := TAWTrackerItem(_trackingList.Objects[i]);
            for j := 0 to tempList.Count - 1 do begin
                tempitem2 := TAWTrackerItem(tempList.Objects[j]);
                insertPoint := j;
                if (tempitem1.frm.LastActivity > tempitem2.frm.LastActivity) then begin
                    // We have an new item to add to the temp list that should be higher
                    // then the current item in the templist
                    tempList.InsertObject(insertPoint, _trackingList.Strings[i], _trackingList.Objects[i]);
                    itemadded := true;
                    break;
                end;
            end;
            if (not itemadded) then begin
                // We didn't insert the item into the temp list so add to end
                tempList.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
            end;
        end;
        _trackingList.Clear;
        for i := 0 to tempList.Count - 1 do begin
            _trackingList.AddObject(tempList.Strings[i], tempList.Objects[i]);
        end;
    end
    else if (sortType = ssType) then begin
        // Sort by the type of window (room, chat, etc.), then by alpha for tied items
        sortstring := sortstring + _(sSortType);
        roomList := TWidestringList.Create();
        chatList := TWidestringList.Create();
        otherList := TWidestringList.Create();

        // Split them up by group
        for i := 0 to _trackingList.Count - 1 do begin
            tempitem1 := TAWTrackerItem(_trackingList.Objects[i]);
            if (tempitem1.frm is TfrmRoom) then begin
                roomList.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
            end
            else if (tempitem1.frm is TfrmChat) then begin
                chatList.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
            end
            else begin
                otherList.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
            end;
        end;

        // Reassemble list
        _trackingList.Clear();

        for i := 0 to roomList.Count - 1 do begin
            _trackingList.AddObject(roomList.Strings[i], roomList.Objects[i]);
        end;
        for i := 0 to chatList.Count - 1 do begin
            _trackingList.AddObject(chatList.Strings[i], chatList.Objects[i]);
        end;
        for i := 0 to otherList.Count - 1 do begin
            _trackingList.AddObject(otherList.Strings[i], otherList.Objects[i]);
        end;

        // Cleanup
        roomList.Clear();
        chatList.Clear();
        otherList.Clear();

        roomList.Free();
        chatList.Free();
        otherList.Free();
    end
    else if (sortType = ssUnread) then begin
        // Sort by Highest Unread msgs
        sortstring := sortstring + _(sSortUnread);
        for i := 0 to _trackingList.Count - 1 do begin
            // iterate over list to reorder
            itemadded := false;
            tempitem1 := TAWTrackerItem(_trackingList.Objects[i]);
            for j := 0 to tempList.Count - 1 do begin
                tempitem2 := TAWTrackerItem(tempList.Objects[j]);
                insertPoint := j;
                if (tempitem2.awItem.count < tempitem1.awItem.count) then begin
                    // We have an new item to add to the temp list that should be higher
                    // then the current item in the templist
                    tempList.InsertObject(insertPoint, _trackingList.Strings[i], _trackingList.Objects[i]);
                    itemadded := true;
                    break;
                end;
            end;
            if (not itemadded) then begin
                // We didn't insert the item into the temp list so add to end
                tempList.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
            end;
        end;
        _trackingList.Clear;
        for i := 0 to tempList.Count - 1 do begin
            _trackingList.AddObject(tempList.Strings[i], tempList.Objects[i]);
        end;
    end
    else begin
        // Sort was Alpha which we did above
    end;

    lblSort.Caption := sortstring;

    tempList.Clear;
    tempList.Free;
end;

{---------------------------------------}
procedure TfrmActivityWindow._updateDisplay(allowPartialVisible: boolean);
var
    numSlots: integer;
    i: integer;
    item: TAWTrackerItem;
    slotsFilled: integer;
    remainder: integer;
    havePriUpHidden: boolean;
    havePriDownHidden: boolean;
    haveNewWindowUpHidden: boolean;
    haveNewWindowDownHidden: boolean;
begin
    try
        if (_trackingList.Count > 0) then begin
            // Compute the maximum showing items
            numSlots := pnlList.Height div TAWTrackerItem(_trackingList.Objects[0]).awItem.Height;
            remainder := pnlList.Height mod TAWTrackerItem(_trackingList.Objects[0]).awItem.Height;
            slotsFilled := 0;

            // See if current showing top item needs to be changed so maximum number
            // of items are visible
            if (_showingTopItem > 0) then begin
                if ((_trackingList.Count - _showingTopItem + 1) < numSlots) then begin
                    // We can show more so change top showing
                    _showingTopItem := _trackingList.Count - numSlots + 1;
                end;
            end;

            // see if we need to show partials
            if ((allowPartialVisible) and
                (remainder > 0)) then begin
                Inc(numSlots);
            end;
            // Crawl list to see what needs displayed
            havePriUpHidden := false;
            havePriDownHidden := false;
            haveNewWindowUpHidden := false;
            haveNewWindowDownHidden := false;
            for i := 0 to _trackingList.Count - 1 do begin
                item := TAWTrackerItem(_trackingList.Objects[i]);
                if (i < _showingTopItem) then begin
                    // Off the top of the viewable list
                    item.awItem.Visible := false;
                    _enableScrollUp(true);
                    if (item.awItem.priority) then begin
                        havePriUpHidden := true;
                    end;
                    if (item.awItem.newWindowHighlight) then begin
                        haveNewWindowUpHidden := true;
                    end;
                end
                else if (slotsFilled >= numSlots) then begin
                    // Off the bottom of the viewable list
                    item.awItem.Visible := false;
                    _enableScrollDown(true);
                    if (item.awItem.priority) then begin
                        havePriDownHidden := true
                    end;
                    if (item.awItem.newWindowHighlight) then begin
                        haveNewWindowDownHidden := true
                    end;
                end
                else begin
                    // Is in visible part of list (at least in part)
                    item.awItem.Left := ListLeftSpacer.Width;
                    item.awItem.Width := pnlList.Width - ListLeftSpacer.Width - ListRightSpacer.Width;
                    item.awItem.Top := item.awItem.Height * slotsFilled;
                    item.awItem.Visible := true;
                    Inc(slotsFilled);
                end;
            end;

            // Change scroll state
            if (_canScrollUp) then begin
                _scrollUpState := ssEnabled;
            end
            else begin
                _scrollUpState := ssDisabled;
            end;
            if (_canScrollDown) then begin
                _scrollDownState := ssEnabled;
            end
            else begin
                _scrollDownState := ssDisabled;
            end;
            if (havePriUpHidden) then begin
                _scrollUpState := ssPriority;
            end;
            if (havePriDownHidden) then begin
                _scrollDownState := ssPriority;
            end;
            if (haveNewWindowUpHidden) then begin
                _scrollUpState := ssNewWindow;
            end;
            if (haveNewWindowDownHidden) then begin
                _scrollDownState := ssNewWindow;
            end;
            _setScrollUpColor();
            _setScrollDownColor();

            // Disable scroll buttons if not needed
            if (_showingTopItem <= 0) then begin
                // At top of list
                _enableScrollUp(false);
            end;
            if ((TAWTrackerItem(_trackingList.Objects[_trackingList.Count - 1]).awItem.Visible) and
                ((TAWTrackerItem(_trackingList.Objects[_trackingList.Count - 1]).awItem.Top +
                 TAWTrackerItem(_trackingList.Objects[_trackingList.Count - 1]).awItem.Height) <= pnlList.Height)) then begin
                // At bottom of list AND bottom element is fully visible (not partial)
                _enableScrollDown(false);
            end;
        end
        else begin
            _enableScrollUp(false);
            _enableScrollDown(false);
        end;
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow._activateNextDockedItem(curitemindx: integer);
var
    newActiveItem: TAWTrackerItem;
    i: integer;
begin
    if (curitemindx < 0) then exit;
    if (curitemindx > (_trackingList.Count - 1)) then exit;
    if (_trackingList.Count = 0) then exit;

    try
        newActiveItem := nil;

        // Seach "down" in list for next docked item.
        i := curitemindx + 1;
        while (i < _trackingList.Count) do begin
            newActiveItem := TAWTrackerItem(_trackingList.Objects[i]);
            if (newActiveItem.frm.Docked) then begin
                break;
            end
            else begin
                newActiveItem := nil;
            end;
            Inc(i);
        end;

        // If nothing docked found, then search "up" list
        if (newActiveItem = nil) then begin
            i := curitemindx - 1;
            while (i >= 0) do begin
                newActiveItem := TAWTrackerItem(_trackingList.Objects[i]);
                if (newActiveItem.frm.Docked) then begin
                    break;
                end
                else begin
                    newActiveItem := nil;
                end;
                Dec(i);
            end;
        end;

        if (newActiveItem <> nil) then begin
            // Got an item, so activate it
            //OnItemClick(newactiveitem.awItem);
            activateItem(newactiveitem.awItem);
        end
        else begin
            // Deactivate all items
            TAWTrackerItem(_trackingList.Objects[curitemindx]).awItem.activate(false);
        end;
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.scrollToActive();
var
    i: integer;
    idx: integer;
    numslots: integer;
    tempitem: TAWTrackerItem;
begin
    if (_activeitem = nil) then exit; // No active item

    _updateDisplay(false); // don't want a partial at this instant

    if (_activeitem.Visible) then exit; // Active item is visible

    // Find where the item is in the tracking list
    idx := -1;
    tempitem := nil;
    for i := 0 to _trackingList.Count - 1 do begin
        tempitem := TAWTrackerItem(_trackingList.Objects[i]);
        if (tempitem.awItem = _activeitem) then begin
            idx := i;
            break;
        end;
    end;

    if ((idx >= 0) and
        (tempitem <> nil)) then begin
        if (idx < _showingTopItem) then begin
            // Item is above current visible
            _showingTopItem := idx;
        end
        else begin
            // Item is below current visible
            numSlots := pnlList.Height div tempitem.awItem.Height;
            if (numSlots > 0) then begin
                _showingTopItem := idx - numSlots + 1;
            end;
        end;
    end;

    _updateDisplay(); // partials are fine now.
end;

{---------------------------------------}
procedure TfrmActivityWindow._enableScrollUp(doenable: boolean);
begin
    _canScrollUp := doenable;
    pnlListScrollUp.Visible := doenable;

    if (doenable) then begin
        if (_scrollUpState = ssDisabled) then begin
            _scrollUpState := ssEnabled;
        end;
    end
    else begin
        _scrollUpState := ssDisabled;
    end;

    _setScrollUpColor();
end;

{---------------------------------------}
procedure TfrmActivityWindow._enableScrollDown(doenable: boolean);
begin
    _canScrollDown := doenable;
    pnlListScrollDown.Visible := doenable;

    if (doenable) then begin
        if (_scrollDownState = ssDisabled) then begin
            _scrollDownState := ssEnabled;
        end;
    end
    else begin
        _scrollDownState := ssDisabled;
    end;
    _setScrollDownColor();
end;

{---------------------------------------}
procedure TfrmActivityWindow.setDockingSpacers(dockstate: TDockStates);
begin
    case dockstate of
        dsUnDocked: begin
            ListRightSpacer.Width := 10;
            pnlBorderTop.Height := 0;
            pnlBorderBottom.Height := 0;
        end;
        dsDocked: begin
            ListRightSpacer.Width := 0;
            pnlBorderTop.Height := 10;
            pnlBorderBottom.Height := 10;
        end;
        dsUninitialized: begin
            ListRightSpacer.Width := 10;
            pnlBorderTop.Height := 0;
            pnlBorderBottom.Height := 0;
        end;
    end;

    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.itemChangeUpdate();
begin
    _sortTrackingList(_curListSort);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow._setScrollUpColor();
begin
    case _scrollUpState of
        ssDisabled: begin
            pnlListScrollUp.GradientProperites.startColor := _scrollDefaultStartColor;
            pnlListScrollUp.GradientProperites.endColor := _scrollDefaultEndColor;
        end;
        ssEnabled: begin
            pnlListScrollUp.GradientProperites.startColor := _scrollEnabledStartColor;
            pnlListScrollUp.GradientProperites.endColor := _scrollEnabledEndColor;
        end;
        ssPriority: begin
            pnlListScrollUp.GradientProperites.startColor := _scrollPriorityStartColor;
            pnlListScrollUp.GradientProperites.endColor := _scrollPriorityEndColor;
        end;
        ssNewWindow: begin
            pnlListScrollUp.GradientProperites.startColor := _scrollNewWindowStartColor;
            pnlListScrollUp.GradientProperites.endColor := _scrollNewWindowEndColor;
        end;
    end;
    pnlListScrollUp.Invalidate();
end;

{---------------------------------------}
procedure TfrmActivityWindow._setScrollDownColor();
begin
    case _scrollDownState of
        ssDisabled: begin
            pnlListScrollDown.GradientProperites.startColor := _scrollDefaultStartColor;
            pnlListScrollDown.GradientProperites.endColor := _scrollDefaultEndColor;
        end;
        ssEnabled: begin
            pnlListScrollDown.GradientProperites.startColor := _scrollEnabledStartColor;
            pnlListScrollDown.GradientProperites.endColor := _scrollEnabledEndColor;
        end;
        ssPriority: begin
            pnlListScrollDown.GradientProperites.startColor := _scrollPriorityStartColor;
            pnlListScrollDown.GradientProperites.endColor := _scrollPriorityEndColor;
        end;
        ssNewWindow: begin
            pnlListScrollDown.GradientProperites.startColor := _scrollNewWindowStartColor;
            pnlListScrollDown.GradientProperites.endColor := _scrollNewWindowEndColor;
        end;
    end;
    pnlListScrollDown.Invalidate();
end;

{---------------------------------------}
procedure TfrmActivityWindow.selectNextItem();
var
    i:integer;
    item: TAWTrackerItem;
begin
    try
        // Scan through list to find active item.
        // No need to check last item (count - 1) as
        // we cannot go to the next item when it is
        // the last item.
        for i := 0 to _trackingList.Count - 2 do begin
            item := TAWTrackerItem(_trackingList.Objects[i]);
            if (item <> nil) then begin
                if (item.awItem.active) then begin
                    item := TAWTrackerItem(_trackingList.Objects[i + 1]);
                    if (item <> nil) then begin
                        activateItem(item.awItem);
                    end;
                    break;
                end;
            end;
        end;
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.selectPrevItem();
var
    i:integer;
    item: TAWTrackerItem;
begin
    try
        // Scan through list to find active item.
        // No need to check first item (item 0) as
        // we cannot go to the next item when it is
        // the last item.
        if (_trackingList.Count > 1) then begin
            for i := 1 to _trackingList.Count - 1 do begin
                item := TAWTrackerItem(_trackingList.Objects[i]);
                if (item <> nil) then begin
                    if (item.awItem.active) then begin
                        item := TAWTrackerItem(_trackingList.Objects[i - 1]);
                        if (item <> nil) then begin
                            activateItem(item.awItem);
                        end;
                        break;
                    end;
                end;
            end;
        end;
    except
    end;
end;

{---------------------------------------}
function TfrmActivityWindow._getItemCount(): integer;
begin
    Result := _trackingList.Count;
end;




initialization
    frmActivityWindow := nil;

end.

