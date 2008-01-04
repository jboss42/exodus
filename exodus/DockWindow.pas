unit DockWindow;

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
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  ExForm, Dockable, TntComCtrls,
  ComCtrls, ExtCtrls, TntExtCtrls,
  ExodusDockManager, StdCtrls,
  ExGradientPanel, AWItem, Unicode,
  StateForm;

type

  TSortStates = (ssUnsorted, ssAlpha, ssActive, ssRecent, ssUnread);

  TfrmDockWindow = class(TfrmState, IExodusDockManager)
    splAW: TTntSplitter;
    AWTabControl: TTntPageControl;
    pnlActivityList: TExGradientPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AWTabControlDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure AWTabControlUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure FormShow(Sender: TObject);
    procedure WMActivate(var msg: TMessage); message WM_ACTIVATE;
    procedure FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
  private
    { Private declarations }

  protected
    { Protected declarations }
    _docked_forms: TList;
    _dockState: TDockStates;
    _sortState: TSortStates;

    procedure CreateParams(Var params: TCreateParams); override;
    procedure _removeTabs(idx:integer = -1);
    procedure _layoutDock();
    procedure _layoutAWOnly();
    procedure _saveDockWidths();

  public
    { Public declarations }

    // IExodusDockManager interface
    procedure CloseDocked(frm: TfrmDockable);
    function OpenDocked(frm : TfrmDockable) : TTntTabSheet;
    procedure FloatDocked(frm : TfrmDockable);
    function GetDockSite() : TWinControl;
    procedure BringDockedToTop(form: TfrmDockable);
    function getTopDocked() : TfrmDockable;
    procedure SelectNext(goforward: boolean; visibleOnly:boolean=false);
    procedure OnNotify(frm: TForm; notifyEvents: integer);
    procedure UpdateDocked(frm: TfrmDockable);
    procedure BringToFront();
    function isActive(): boolean;

    function getTabSheet(frm : TfrmDockable) : TTntTabSheet;
    function getTabForm(tab: TTabSheet): TForm;
    procedure updateLayoutDockChange(frm: TfrmDockable; docking: boolean; FirstOrLastDock: boolean);
  end;

var
  frmDockWindow: TfrmDockWindow;

implementation

uses
    RosterWindow, Session, PrefController,
    ActivityWindow;

{$R *.dfm}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmDockWindow.CreateParams(Var params: TCreateParams);
begin
    // Make this window show up on the taskbar
    inherited CreateParams( params );
    params.ExStyle := params.ExStyle or WS_EX_APPWINDOW;
    params.WndParent := GetDesktopwindow;
end;

{---------------------------------------}
procedure TfrmDockWindow.CloseDocked(frm: TfrmDockable);
var
    idx: integer;
    aw: TfrmActivityWindow;
begin
    if (frm = nil) then exit;

    try
        aw := GetActivityWindow();
        if (aw <> nil) then begin
            aw.removeItem(frm.UID);
        end;

        if (frm.Docked) then begin
            updateLayoutDockChange(frm, true, _docked_forms.Count = 1);
            frm.Docked := false;
            idx := _docked_forms.IndexOf(frm);
            if (idx >= 0) then
                _docked_forms.Delete(idx);
        end;
    except
    end;
end;

{---------------------------------------}
function TfrmDockWindow.OpenDocked(frm : TfrmDockable) : TTntTabSheet;
begin
    frm.ManualDock(AWTabControl); //fires TabsDockDrop event
    Result := GetTabSheet(frm);
    frm.Visible := true;
    _removeTabs();
end;

{---------------------------------------}
procedure TfrmDockWindow.FloatDocked(frm : TfrmDockable);
begin
    frm.ManualFloat(frm.FloatPos);
end;

{---------------------------------------}
procedure TfrmDockWindow.FormCreate(Sender: TObject);
begin
    inherited;
    _docked_forms := TList.Create;
    _dockState := dsUninitialized;
    _sortState := ssUnsorted;
    _layoutAWOnly();
end;

{---------------------------------------}
procedure TfrmDockWindow.FormDestroy(Sender: TObject);
begin
    try
        inherited;
        _docked_forms.Free;
    except
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.FormDockDrop(Sender: TObject; Source: TDragDockObject;
  X, Y: Integer);
begin
    if (Source.Control is TfrmDockable) then begin
        // We got a new form dropped on us.
        OpenDocked(TfrmDockable(Source.Control));
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.FormShow(Sender: TObject);
var
    aw: TfrmActivityWindow;
begin
    inherited;
    aw := GetActivityWindow();
    if (aw <> nil) and (not aw.docked)then begin
        aw.DockActivityWindow(pnlActivityList);
        aw.dockwindow := Self;
        aw.Show;
        aw.OnDockDrop := FormDockDrop;
    end;
end;

{---------------------------------------}
function TfrmDockWindow.GetDockSite() : TWinControl;
begin
    if (Self.DockSite) then
        Result := Self
    else
        Result := nil;
end;

{---------------------------------------}
procedure TfrmDockWindow.AWTabControlDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
var
    tabindx: integer;
begin
    // We got a new form dropped on us.
    if (Source.Control is TfrmDockable) then begin
        updateLayoutDockChange(TfrmDockable(Source.Control), true, false);
        TfrmDockable(Source.Control).Docked := true;
        TTntTabSheet(AWTabControl.Pages[AWTabControl.PageCount - 1]).ImageIndex := TfrmDockable(Source.Control).ImageIndex;
        //msg queue is always first tab
//        if (Source.Control is TfrmMsgQueue) then begin
//            TTntTabSheet(Tabs.Pages[Tabs.PageCount - 1]).PageIndex := 0;
//        end;
        TfrmDockable(Source.Control).OnDocked();
        tabindx := _docked_forms.Add(TfrmDockable(Source.Control));
        _removeTabs();
        Self.AWTabControl.ActivePageIndex := tabindx;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.AWTabControlUnDock(Sender: TObject;
  Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
begin
    // check to see if the tab is a frmDockable
    Allow := true;
    if ((Client is TfrmDockable) and TfrmDockable(Client).Docked)then begin
        CloseDocked(TfrmDockable(Client));
        TfrmDockable(Client).Docked := false;
        TfrmDockable(Client).OnFloat();
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.BringDockedToTop(form: TfrmDockable);
var
    tsheet: TTntTabSheet;
begin
    if (Self.AWTabControl.PageCount > 0) then begin
        tsheet := GetTabSheet(form);
        if (tsheet <> nil) then begin
            Self.AWTabControl.ActivePage := tsheet;
            if (Self.Visible) then //focus if we can
                form.gotActivate();
        end;
    end;
end;

{---------------------------------------}
function TfrmDockWindow.getTopDocked() : TfrmDockable;
var
    top : TForm;
begin
    Result := nil;
    try
        top := getTabForm(Self.AWTabControl.ActivePage);
        if ((top is TfrmDockable) and (TfrmDockable(top).Docked)) then
            Result := TfrmDockable(top);
    finally
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.SelectNext(goforward: boolean; visibleOnly:boolean=false);
begin
    AWTabControl.SelectNextPage(goforward, visibleonly);
end;

{---------------------------------------}
procedure TfrmDockWindow.OnNotify(frm: TForm; notifyEvents: integer);
begin
//    //if dockmanager is being notified directly or the given form is docked
//    //handle bring to front and flash
//    if ((frm = nil) or (frm = Self) or
//        ((frm is TfrmDockable) and (TfrmDockable(frm).Docked))) then begin
//        if ((notifyEvents and notify_front) > 0) then
//            bringToFront()
//        else if ((notifyEvents and notify_flash) > 0) then
//            Self.Flash();
//    end;
//    //tray notifications are always directed and dockmanager
//    if (((notifyEvents and notify_tray) > 0) and ((notifyEvents and notify_front) = 0))then
//        StartTrayAlert();
//
//    updateNextNotifyButton();
end;

{---------------------------------------}
procedure TfrmDockWindow.UpdateDocked(frm: TfrmDockable);
var
//    tsheet: TTntTabSheet;
    item: TAWTrackerItem;
    aw: TfrmActivityWindow;
begin
    if (frm = nil) then exit;
    
    aw := ActivityWindow.GetActivityWindow();

    if (aw <> nil) then begin
        // See if item is in list
        //item := aw.findItem(frm.UID);
        item := aw.findItem(frm);
        if ((item = nil) and
            (frm.UID <> ''))then begin
            // Item NOT being tracked so let's add it
            item := aw.addItem(frm.UID, frm);
            if (item <> nil) then begin
                // make sure this is the selected item.
                item.awItem.OnClick(item.awItem);
            end;
        end;

        if (item <> nil) then begin
            // Successful lookup or add
            item.awItem.imgIndex := frm.ImageIndex;
            if (frm.UID <> '') then begin
                item.awItem.name := frm.UID; //???dda
            end;

            // Deal with msg count
            item.awItem.count := frm.UnreadMsgCount;

            // Deal with priority
            item.awItem.priorityFlag(frm.PriorityFlag);

            // Deal with undocked window focus
            if (frm.Activating) then begin
                item.awItem.OnClick(item.awItem);
            end;
        end;

    //    tsheet := GetTabSheet(frm);
    //    if (tsheet <> nil) then
    //        tsheet.ImageIndex := frm.ImageIndex;
    //    checkFlash();
    //    updateNextNotifyButton();
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.BringToFront();
begin
//    Self.doRestore();
    ShowWindow(Self.Handle, SW_SHOWNORMAL);
    Self.Visible := true;
//    ForceForegroundWindow(Self.Handle);
end;

{---------------------------------------}
function TfrmDockWindow.isActive(): boolean;
begin
    Result := Self.Active;
end;

{---------------------------------------}
function TfrmDockWindow.getTabSheet(frm : TfrmDockable) : TTntTabSheet;
var
    i : integer;
    tf : TForm;
begin
    //walk currently docked sheets and try to find a match
    Result := nil;
    for i := 0 to AWTabControl.PageCount - 1 do begin
        tf := getTabForm(AWTabControl.Pages[i]);
        if (tf = frm) then begin
            Result := TTntTabSheet(AWTabControl.Pages[i]);
            exit;
        end;
    end;
end;

{---------------------------------------}
function TfrmDockWindow.getTabForm(tab: TTabSheet): TForm;
begin
    // Get an associated form for a specific tabsheet
    Result := nil;
    if ((tab <> nil) and (tab.ControlCount = 1)) then begin
        if (tab.Controls[0] is TForm) then begin
            Result := TForm(tab.Controls[0]);
            exit;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow._removeTabs(idx: integer);
var
    i: integer;
begin
    if ((idx >= 0) and
        (idx < AWTabControl.PageCount)) then begin
        AWTabControl.Pages[idx].TabVisible := false;
    end
    else begin
        for i := 0 to AWTabControl.PageCount - 1 do begin
            AWTabControl.Pages[i].TabVisible := false
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.WMActivate(var msg: TMessage);
var
    frm: TfrmDockable;
begin
    if (Self.Visible) then begin
        frm := getTopDocked();
        if (frm <> nil) then begin
            frm.Activating := true;
            UpdateDocked(frm);
            frm.Activating := false;
        end;
    end;

    inherited;
end;

{
    Update UI after some dock event has occurred.

    HideDock if last tab was undocked, ShowNormalDock if moving from
    no tabs to at least one tab, handle embedded roster state changes.

    Since it can be difficult to know exactly when to perform a
    change in the DockState (in some instances this method may be called
    before the TPageControl has had a chance to cleanup an tab), a
    flag is passed to force a state change.

    @param frm the form that was just docked/undocked
    @param docking  is the form beign docked or undocked?
    @toggleDockState moving from (dsDockOnly or dsRosterDock) to dsRosterOnly or vice versa
}
{---------------------------------------}
procedure TfrmDockWindow.updateLayoutDockChange(frm: TfrmDockable; docking: boolean; FirstOrLastDock: boolean);

var
    oldState : TDockStates;
    newState : TDockStates;
begin
    oldState := _dockState;
    //figure out what state we are moving to...
    if (docking) then begin
       if (FirstOrLastDock) then begin
         newState := dsRosterOnly;
       end
       else begin
         newState := dsDock;
       end
    end
    else
      newState := dsRosterOnly;

    if (newState <> oldState) then begin
//        _noMoveCheck := true;
          if (newState = dsDock) then
            _layoutDock()
          else
            _layoutAWOnly();
//        _noMoveCheck := false;
    end;
end;

{
    Adjust layout so roster panel and dock panel are shown
}
{---------------------------------------}
procedure TfrmDockWindow._layoutDock();
var
  mon: TMonitor;
  ratioRoster: real;
begin
    if (_dockState <> dsDock) then begin
//        _enforceConstraints := false;
        _saveDockWidths();
//        _noMoveCheck := true;
        //this is a mess. To get splitter working with the correct control
        //we need to hide/de-align/set their relative positions/size them and show them
        pnlActivityList.align := alNone;
        splAW.align := alNone;
        AWTabControl.align := alNone;

        splAW.Visible := false; //hide this first or will expand and throw widths off
        pnlActivityList.Visible := false;
        AWTabControl.Visible := false;

        //Obtain the width of the monitor
        //If we exceed the width of the monitor,
        //recalculate widths for roster based on the same ratio
        mon := Screen.MonitorFromWindow(Self.Handle, mdNearest);
        if (MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH) + 3 + MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH) >= mon.Width) then begin
          ratioRoster := (MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH) + 3)/(MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH) + 3 + MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH));
          Self.ClientWidth  := mon.Width;
          pnlActivityList.Width := Trunc(Self.ClientWidth * ratioRoster);
        end
        else begin
            Self.ClientWidth := MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH) + 3 + MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH);
            pnlActivityList.Width := MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH);
        end;

        pnlActivityList.Left := 0;
        pnlActivityList.Align := alLeft;
        pnlActivityList.Visible := true;
        splAW.Left := pnlActivityList.BoundsRect.Right + 1;
        splAW.Align := alLeft;
        splAW.Visible := true;
        AWTabControl.Left := pnlActivityList.BoundsRect.Right + 4;
        AWTabControl.Align := alClient;
        AWTabControl.Visible := true;

//        _noMoveCheck := false;
//        _currDockState := dsDock;
        Self.DockSite := false;
        pnlActivityList.DockSite := false;        
        AWTabControl.DockSite := true;

//         if (MainSession.Active) then
//            frmExodus.Constraints.MinWidth := MainSession.Prefs.getInt('brand_min_roster_window_width_docked')
//         else
//            frmExodus.Constraints.MinWidth := MainSession.Prefs.getInt('brand_min_profiles_window_width_docked');

//         _enforceConstraints := true;

        _dockState := dsDock;
    end;
end;

{
    Adjust layout so only roster panel is shown
}
{---------------------------------------}
procedure TfrmDockWindow._layoutAWOnly();
begin
    //if tabs were being shown, save tab size
    _saveDockWidths();
    if (_dockState <> dsRosterOnly) then begin
//        _enforceConstraints := false;
        AWTabControl.Visible := false;
        pnlActivityList.Align := alClient;
        splAW.Visible := false;
//        _noMoveCheck := true;
        Self.ClientWidth := MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH);
//        _noMoveCheck := false;
//        _currDockState := dsRosterOnly;
        Self.DockSite := true;
        pnlActivityList.DockSite := true;
        AWTabControl.DockSite := false;
//         if (MainSession.Active) then
//            frmExodus.Constraints.MinWidth := MainSession.Prefs.getInt('brand_min_roster_window_width_undocked')
//         else
//            frmExodus.Constraints.MinWidth := MainSession.Prefs.getInt('brand_min_profiles_window_width_undocked');

//         _enforceConstraints := true;

        _dockState := dsRosterOnly;
    end;
end;

{
    Save the current roster and dock panel widths.

    Depending on current state...
}
{---------------------------------------}
procedure TfrmDockWindow._saveDockWidths();
begin
    if (_dockState = dsRosterOnly) then
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_WIDTH, pnlActivityList.Width)
    else if (_dockState = dsDock) then begin
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_WIDTH, pnlActivityList.Width);
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH, AWTabControl.Width);
    end;
end;

end.

