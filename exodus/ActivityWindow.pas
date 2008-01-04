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
  AWItem, Unicode, DockWindow;

type

  TAWTrackerItem = class
  private
    { Private declarations }

  protected
    { Protected declarations }
    _dockable_frm: TfrmDockable;
    _awItem: TfAWItem;

  public
    { Public declarations }
    property frm: TfrmDockable read _dockable_frm write _dockable_frm;
    property awItem: TfAWItem read _awItem write _awItem;
  end;

  TfrmActivityWindow = class(TExForm)
    pnlListBase: TExGradientPanel;
    pnlListTop: TExGradientPanel;
    pnlListBottom: TExGradientPanel;
    Button1: TButton;
    Button2: TButton;
    pnlList: TExGradientPanel;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }

  protected
    { Protected declarations }
    _trackingList: TWidestringList;
    _docked: boolean;
    _activeitem: TfAWItem;
    _dockwindow: TfrmDockWindow;
    _showingTopItem: integer;
    _showingItemCnt: integer;

    procedure _clearTrackingList();
    procedure CreateParams(Var params: TCreateParams); override;
    procedure onItemClick(Sender: TObject);
    function _findItem(awitem: TfAWItem): TAWTrackerItem;
    procedure _sortTrackingList(sortType: TSortStates = ssUnsorted);
    procedure _sortList(var list: TWidestringList; sortType: TSortStates);
    procedure _updateDisplay();

  public
    { Public declarations }
    procedure activateItem(awitem: TfAWItem); overload;
    procedure DockActivityWindow(dockSite : TWinControl);
    procedure removeItem(item:TAWTrackerItem); overload;
    procedure removeItem(id:widestring); overload;
    function addItem(id:widestring; frm:TfrmDockable): TAWTrackerItem;
    function findItem(id:widestring): TAWTrackerItem; overload;
    function findItem(frm:TfrmDockable): TAWTrackerItem; overload;
    procedure activateItem(id:widestring); overload;

    property docked: boolean read _docked write _docked;
    property dockwindow: TfrmDockWindow read _dockwindow write _dockwindow;
  end;

  // Global Functions
  procedure DockActivityWindow(docksite : TWinControl);
  function GetActivityWindow() : TfrmActivityWindow;
  procedure CloseActivityWindow();

var
  frmActivityWindow: TfrmActivityWindow;

implementation


{$R *.dfm}

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
//    params.WndParent := GetDesktopwindow;
end;

{---------------------------------------}
procedure TfrmActivityWindow.FormCreate(Sender: TObject);
begin
    inherited;
    _trackingList := TWidestringList.Create;
    _showingTopItem := -1;
    _showingItemCnt := 0;
end;

{---------------------------------------}
procedure TfrmActivityWindow.FormDestroy(Sender: TObject);
begin
    inherited;
    _clearTrackingList();
    _trackingList.Free;
end;

procedure TfrmActivityWindow.FormResize(Sender: TObject);
begin
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.Button1Click(Sender: TObject);
begin
    _sortTrackingList(ssAlpha);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.Button2Click(Sender: TObject);
begin
    _sortTrackingList(ssUnread);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.Button3Click(Sender: TObject);
begin
    if (_showingTopItem > 0) then begin
        Dec(_showingTopItem);
    end;
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.Button4Click(Sender: TObject);
begin
    Inc(_showingTopItem);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow._clearTrackingList();
var
    i: integer;
    item: TAWTrackerItem;
begin
    for i := _trackingList.Count - 1 downto 0 do begin
        item := TAWTrackerItem(_trackingList.Objects[i]);
        removeItem(item);
        _trackingList.Delete(i);
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
            // Found Item - remove from list
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
        Result.awItem.name := id;
        Result.awItem.Left := 0;

        if (_showingTopItem < 0) then begin
            _showingTopItem := 0;
        end;

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
procedure TfrmActivityWindow.DockActivityWindow(dockSite : TWinControl);
begin
    if (dockSite <> Self.Parent) then begin
        Self.ManualDock(dockSite, nil, alClient);
        Application.processMessages();
        Self.Align := alClient;
        _docked := true;
//        MainSession.dock_windows := Docked;
//        _drop.DropEvent := onURLDrop;
//        _drop.start(treeRoster);
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
begin
    if (Sender = nil) then exit;

    try
        awitem := TfAWItem(Sender);
        activateItem(awitem);
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.activateItem(awitem: TfAWItem);
var
    trackitem: TAWTrackerItem;
    tsheet: TTntTabSheet;
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
                    _dockwindow.AWTabControl.ActivePage := tsheet;
                end;
            end
            else begin
                trackitem.frm.BringToFront;
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
procedure TfrmActivityWindow._sortTrackingList(sortType: TSortStates);
begin
    _sortList(_trackingList, sortType);
end;

{---------------------------------------}
procedure TfrmActivityWindow._sortList(var list: TWidestringList; sortType: TSortStates);
var
    i,j: integer;
    insertPoint: integer;
    tempitem1, tempitem2: TAWTrackerItem;
    tempList: TWidestringList;
    itemadded: boolean;
begin
    if (sortType = ssUnsorted) then exit;
    if (list = nil) then exit;
    if (list.Count = 0) then exit;

    tempList := TWidestringList.Create();
    insertPoint := 0;

    // Always do an Alpha sort first
    if (sortType <> ssUnsorted) then begin
        // Sort by Alpha so use TWidestringList default sort
        list.Sort;
    end;

    // Refine sort if something other then Alpha
    if (sortType = ssActive) then begin
        // Sort by most active items, then by alpha for tied items
    end
    else if (sortType = ssRecent) then begin
        // Sort by most Recent Activity, then by alpha for tied items
    end
    else if (sortType = ssUnread) then begin
        // Sort by Highest Unread msgs
        for i := 0 to list.Count - 1 do begin
            // iterate over list to reorder
            itemadded := false;
            tempitem1 := TAWTrackerItem(_trackingList.Objects[i]);
            for j := 0 to tempList.Count - 1 do begin
                tempitem2 := TAWTrackerItem(tempList.Objects[j]);
                insertPoint := j;
                if (tempitem2.awItem.count < tempitem1.awItem.count) then begin
                    // We have an new item to add to the temp list that should be higher
                    // then the current item in the templist
                    tempList.InsertObject(insertPoint, list.Strings[i], list.Objects[i]);
                    itemadded := true;
                    break;
                end;
            end;
            if (not itemadded) then begin
                // We didn't insert the item into the temp list so add to end
                tempList.AddObject(list.Strings[i], list.Objects[i]);
            end;
        end;
        list.Clear;
        for i := 0 to tempList.Count - 1 do begin
            list.AddObject(tempList.Strings[i], tempList.Objects[i]);
        end;
    end
    else begin
        // Sort was Alpha which we did above
    end;

    tempList.Clear;
    tempList.Free;
end;

{---------------------------------------}
procedure TfrmActivityWindow._updateDisplay();
var
    numSlots: integer;
    i: integer;
    item: TAWTrackerItem;
    slotsFilled: integer;
begin
    try
        if (_trackingList.Count > 0) then begin
            numSlots := pnlList.Height div TAWTrackerItem(_trackingList.Objects[0]).awItem.Height;
            slotsFilled := 0;
            for i := 0 to _trackingList.Count - 1 do begin
                item := TAWTrackerItem(_trackingList.Objects[i]);
                if (i < _showingTopItem) then begin
                    // Off the top of the viewable list
                    item.awItem.Visible := false;
                    Button3.Enabled := true;
                end
                else if (slotsFilled >= numSlots) then begin
                    // Off the bottom of the viewable list
                    item.awItem.Visible := false;
                    Button4.Enabled := true;
                end
                else begin
                    item.awItem.Width := pnlList.Width;
                    item.awItem.Top := item.awItem.Height * slotsFilled;
                    item.awItem.Visible := true;
                    Inc(slotsFilled);
                end;
            end;

            // Disable scroll buttons if not needed
            if (_showingTopItem <= 0) then begin
                Button3.Enabled := false;
            end;
            if (TAWTrackerItem(_trackingList.Objects[_trackingList.Count - 1]).awItem.Visible) then begin
                Button4.Enabled := false;
            end;



        end
        else begin
            Button3.Enabled := false;
            Button4.Enabled := false;
        end;
    except
    end;
end;






initialization
    frmActivityWindow := nil;

end.

