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
  StateForm, XMLTag,
  FrmUtils;

type

  TSortState = (ssUnsorted, ssAlpha, ssRecent, ssType, ssUnread);

  TfrmDockWindow = class(TfrmState, IExodusDockManager)
    splAW: TTntSplitter;
    AWTabControl: TTntPageControl;
    pnlActivityList: TPanel;
    timFlasher: TTimer;
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
    procedure timFlasherTimer(Sender: TObject);
    Procedure WMSyscommand(Var msg: TWmSysCommand); message WM_SYSCOMMAND;
    procedure FormResize(Sender: TObject);
    procedure OnMove(var Msg: TWMMove); message WM_MOVE;
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
    _docked_forms: TList;
    _dockState: TDockStates;
    _sortState: TSortState;
    _glueEdge: TGlueEdge;
    _glueRange: integer;
    _undocking: boolean;
    _sessionCB: integer;
    _suppressShow: boolean;

    procedure _removeTabs(idx:integer = -1; oldtsheet: TTntTabSheet = nil);
    procedure _layoutDock();
    procedure _layoutAWOnly();
    procedure _saveDockWidths();
    procedure _needToBeShowingCheck();
    procedure _glueCheck();
    function _canShowWindow(): boolean;

  protected
    { Protected declarations }
    procedure CreateParams(Var params: TCreateParams); override;

  public
    { Public declarations }

    // IExodusDockManager interface
    procedure CloseDocked(frm: TfrmDockable);
    function OpenDocked(frm : TfrmDockable) : TTntTabSheet;
    procedure FloatDocked(frm : TfrmDockable);
    function GetDockSite() : TWinControl;
    procedure BringDockedToTop(form: TfrmDockable);
    function getTopDocked(): TfrmDockable;
    procedure SelectNext(goforward: boolean; visibleOnly:boolean=false);
    procedure OnNotify(frm: TForm; notifyEvents: integer);reintroduce; overload;
    procedure UpdateDocked(frm: TfrmDockable);
    procedure BringToFront();
    function isActive(): boolean;
    function getHWND(): THandle;
    function ShowDockManagerWindow(Show: boolean = true; BringWindowToFront: boolean = true): boolean;

    function getTabSheet(frm : TfrmDockable) : TTntTabSheet;
    function getTabForm(tab: TTabSheet): TForm;
    procedure updateLayoutDockChange(frm: TfrmDockable; docking: boolean; FirstOrLastDock: boolean);
    procedure setWindowCaption(txt: widestring);
    procedure Flash();
    procedure checkFlash();
    procedure moveGlued();
    procedure SessionCallback(event: string; tag: TXMLTag);
    function GetActiveTabSheet(): TTntTabSheet;
    procedure changeGotoAcitivityWindowButton();

    property glueEdge: TGlueEdge read _glueEdge write _glueEdge;
  end;

var
  frmDockWindow: TfrmDockWindow;
  dockWindowKBHook: HHook; {this intercepts keyboard input}

  function dockWindowKeyboardHookProc(code: Integer; wParam: Word; lParam: LongInt): LongInt; stdcall;

implementation

uses
    RosterForm, Session, PrefController,
    ActivityWindow, Jabber1, ExUtils,
    ExSession, Notify;

{$R *.dfm}

{---------------------------------------}
function dockWindowKeyboardHookProc(code: Integer; wParam: Word; lParam: LongInt) : LongInt;
var
    keyUp: boolean;
    ctrl_down: boolean;
    shift_down: boolean;
    aw: TfrmActivityWindow;
begin
    // To prevent Windows from passing the keystrokes
    // to the target window, the Result value must
    // be a nonzero value.
    Result:=0;

    if (code < 0) then begin
        // MUST call CallNextHookEx according to MSDN
        Result := CallNextHookEx(dockWindowKBHook, code, wParam, lParam);
    end
    else begin
        case Code of
            HC_ACTION: begin
                keyUp := ((lParam and (1 shl 31)) <> 0);

                // Is the Control key pressed
                if ((GetKeyState(VK_CONTROL) and (1 shl 15)) <> 0) then begin
                    ctrl_down := true;
                end
                else begin
                    ctrl_down := false;
                end;
                // Is the Shift key pressed
                if ((GetKeyState(VK_SHIFT) and (1 shl 15)) <> 0) then begin
                    shift_down := true;
                end
                else begin
                    shift_down := false;
                end;

                if (keyUP) then begin
                    // Only process KeyUp as we can get many
                    // KeyDowns, but only one KeyUp per press.
                    case wParam of
                        VK_TAB: begin
                            if ((ctrl_down) and (not shift_down)) then begin
                                // Doing a Ctrl-Tab, so go to next item
                                aw := GetActivityWindow();
                                if (aw <> nil) then begin
                                    aw.selectNextItem();
                                end;
                                Result := 1;
                            end
                            else if ((ctrl_down) and (shift_down)) then begin
                                // Doing a Ctrl-Shift-Tab, so go to prev item
                                aw := GetActivityWindow();
                                if (aw <> nil) then begin
                                    aw.selectPrevItem();
                                end;
                                Result := 1;
                            end;
                        end;
                    end;
                end;
            end;
            HC_NOREMOVE: begin
              {This is a keystroke message, but the keystroke message}
              {has not been removed from the message queue, since an}
              {application has called PeekMessage() specifying PM_NOREMOVE}
              Result := 0;
              exit;
            end;
        end;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmDockWindow.FormCreate(Sender: TObject);
begin
    inherited;
    setWindowCaption('');
    _docked_forms := TList.Create;
    _dockState := dsUninitialized;
    _sortState := ssUnsorted;
    _glueEdge := geNone;
    _undocking := false;
    dockWindowKBHook := SetWindowsHookEx(WH_KEYBOARD, @dockWindowKeyboardHookProc, HInstance, GetCurrentThreadId()) ;

    _sessionCB := MainSession.RegisterCallback(SessionCallback, '/session');

    Self.RestoreWindowState();

    if ((MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH) = 0) and
        (MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH) = 0)) then begin
        // If both settings are 0, then this must be the first time ever
        // activity window has been ever created and thus we need to preset
        // these items.
        Self.Height := 557; // Match Jabber1 height with first time startup.
        Self.Width  := 185;
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_WIDTH, 185);
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH, 450);
    end;

    _layoutAWOnly();

    // Determine glue range
    if (MainSession.Prefs.getBool('brand_glue_activity_window')) then begin
        _glueRange := MainSession.Prefs.getInt('brand_glue_activity_window_range');
    end
    else begin
        _glueRange := -1;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.FormDestroy(Sender: TObject);
begin
    try
        inherited;
        _docked_forms.Free;
        MainSession.UnRegisterCallback(_sessionCB);
        UnHookWindowsHookEx(dockWindowKBHook) ;
    except
    end;
end;

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
    item: TAWTrackerItem;
begin
    if (frm = nil) then exit;

    try
        aw := GetActivityWindow();
        if (aw <> nil) then begin
            item := aw.findItem(frm);
            aw.removeItem(item);
        end;

        if (frm.Docked) then begin
            updateLayoutDockChange(frm, true, _docked_forms.Count = 1);
            frm.Docked := false;
            idx := _docked_forms.IndexOf(frm);
            if (idx >= 0) then
                _docked_forms.Delete(idx);
        end;

        _needToBeShowingCheck();
    except
    end;
end;

{---------------------------------------}
function TfrmDockWindow.OpenDocked(frm : TfrmDockable) : TTntTabSheet;
var
    oldsheet: TTntTabSheet;
begin
    oldsheet := GetActiveTabSheet();
    if (not Self.Showing) then begin
        ShowDockManagerWindow(true, false);
    end;
    frm.ManualDock(AWTabControl); //fires TabsDockDrop event
    setWindowCaption(frm.Caption);
    Result := GetTabSheet(frm);
    frm.Visible := true;
    _removeTabs(-1, oldsheet);
end;

{---------------------------------------}
procedure TfrmDockWindow.FloatDocked(frm : TfrmDockable);
begin
    frm.ManualFloat(frm.FloatPos);
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
procedure TfrmDockWindow.FormHide(Sender: TObject);
begin
    inherited;
    frmExodus.mnuWindows_View_ShowActivityWindow.Checked := false;
end;

{---------------------------------------}
procedure TfrmDockWindow.FormResize(Sender: TObject);
begin
    inherited;
    Self.Constraints.MaxWidth := 0;
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
    frmExodus.mnuWindows_View_ShowActivityWindow.Checked := true;
    frmExodus.mnuWindows_View_ShowActivityWindow.Enabled := true;
    frmExodus.trayShowActivityWindow.Enabled := true;
    frmExodus.btnActivityWindow.Enabled := true;
    frmExodus.trayShowActivityWindow.Enabled := true;

    _glueCheck();
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
    oldsheet: TTntTabSheet;
begin
    // We got a new form dropped on us.
    if (Source.Control is TfrmDockable) then begin
        _undocking := false;
        oldsheet := GetActiveTabSheet();
        updateLayoutDockChange(TfrmDockable(Source.Control), true, false);
        TfrmDockable(Source.Control).Docked := true;
        TTntTabSheet(AWTabControl.Pages[AWTabControl.PageCount - 1]).ImageIndex := TfrmDockable(Source.Control).ImageIndex;
        TfrmDockable(Source.Control).OnDocked();
        _docked_forms.Add(TfrmDockable(Source.Control));
        _removeTabs(-1, oldsheet);

        if (Self.WindowState = wsMaximized) then begin
            Self.Top := Self.Monitor.WorkareaRect.Top;
            Self.Left := Self.Monitor.WorkareaRect.Top;
            Self.Height := Self.Monitor.WorkareaRect.Bottom - Self.Monitor.WorkareaRect.Top;
            Self.Width := Self.Monitor.WorkareaRect.Right - Self.Monitor.WorkareaRect.Left;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.AWTabControlUnDock(Sender: TObject;
  Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
begin
    // check to see if the tab is a frmDockable
    Allow := true;
    if ((Client is TfrmDockable) and TfrmDockable(Client).Docked)then begin
        setWindowCaption('');
        _undocking := true;
        CloseDocked(TfrmDockable(Client));
        TfrmDockable(Client).Docked := false;
        TfrmDockable(Client).OnFloat();
        _undocking := false;
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
            if (Self.Active)  then            
                form.gotActivate();
        end;
    end;
end;

{---------------------------------------}
function TfrmDockWindow.getTopDocked() : TfrmDockable;
var
    top : TForm;
    i: integer;
begin
    Result := nil;
    try
        // Find the visible tab as we cannot use ActivePage reliably with hidden tabs

        for i := 0 to AWTabControl.PageCount - 1 do begin
            if (AWTabControl.Pages[i].Visible) then begin
                top := getTabForm(AWTabControl.Pages[i]);
                if ((top is TfrmDockable) and (TfrmDockable(top).Docked)) then begin
                    Result := TfrmDockable(top);
                    exit;
                end;
            end;
        end;
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
    //if dockmanager is being notified directly or the given form is docked
    //handle bring to front and flash
    if ((frm = nil) or (frm = Self) or
        ((frm is TfrmDockable) and (TfrmDockable(frm).Docked))) then begin
        if ((notifyEvents and notify_front) > 0) then
             bringToFront()
        else if ((notifyEvents and notify_flash) > 0) then
            Self.Flash();
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.UpdateDocked(frm: TfrmDockable);
var
    item: TAWTrackerItem;
    aw: TfrmActivityWindow;
begin
    if (frm = nil) then exit;
    
    aw := ActivityWindow.GetActivityWindow();

    if (aw <> nil) then begin
        // See if item is in list
        item := aw.findItem(frm);
        if ((item = nil) and
            (frm.UID <> ''))then begin
            // Item NOT being tracked so let's add it
            item := aw.addItem(frm);
        end;

        if (item <> nil) then begin
            // Deal with priority
            item.awItem.priorityFlag(frm.PriorityFlag);

            // Successful lookup or add
            item.awItem.imgIndex := frm.ImageIndex;

            // Deal with new msg highlight
            if (frm.UnreadMsgCount > item.awItem.count) then begin
                item.awItem.newMessage(true);
            end;

            // Deal with msg count
            item.awItem.count := frm.UnreadMsgCount;

            // Deal with change of nickname
            aw.SetItemName(item.awItem, frm.Caption, frm.Hint);

            // Deal with undocked window focus
            if (frm.Activating) then begin
                if ((not Self.Showing) and
                    (frm.Docked)) then begin
                    ShowDockManagerWindow(true, true);
                end;
                aw.activateItem(item.awItem);
            end;

            aw.itemChangeUpdate();
            checkFlash();
            _needToBeShowingCheck();
        end;

        // Make sure right color button is showing on contact list toolbar
        changeGotoAcitivityWindowButton();
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.BringToFront();
begin
    ForceForegroundWindow(Self.Handle);//Self.ShowDockManagerWindow(true, true);
end;

{---------------------------------------}
function TfrmDockWindow.isActive(): boolean;
begin
    Result := Self.Active;
end;

{---------------------------------------}
function TfrmDockWindow.getHWND(): THandle;
begin
    Result := Self.Handle;
end;

{---------------------------------------}
function TfrmDockWindow.ShowDockManagerWindow(Show: boolean = true; BringWindowToFront: boolean = true): boolean;
begin
    Result := false;

    if ((Show) and
        (_canShowWindow())) then begin

        Self.ShowDefault(BringWindowToFront);

        // Make sure that if we are starting up and we are supposed to
        // start minimized to systray, then be sure to be minimized to systray
        if ((StateForm.restoringDesktopFlag) and
            (not frmExodus.Showing)) then begin
            Self.close();
        end;
        Result := true;
    end
    else if (not Show) then begin
        close(); //hide, sets Showing property to false
        Result := true;
    end;
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
procedure TfrmDockWindow._removeTabs(idx: integer; oldtsheet: TTntTabSheet);
var
    i: integer;
    aw: TfrmActivityWindow;
    frm: TfrmDockable;
    item: TAWTrackerItem;
    holdSheet: TTntTabSheet;
begin
    holdSheet:=  TTntTabSheet(AWTabControl.ActivePage);

    if ((idx >= 0) and
        (idx < AWTabControl.PageCount)) then begin
        AWTabControl.Pages[idx].TabVisible := false;
    end
    else begin
        for i := 0 to AWTabControl.PageCount - 1 do begin
            AWTabControl.Pages[i].TabVisible := false
        end;
    end;

    if (holdSheet <> nil) then begin
        AWTabControl.ActivePage := holdSheet;
    end;

    if (oldtsheet <> nil) then begin
        // Workaround for problem with hidden tabs on TPageControl
        // Restore the sheet that was showing
        //AWTabControl.ActivePage := oldtsheet;
        try
            aw := GetActivityWindow();
            if (aw <> nil) then begin
                frm := TfrmDockable(getTabForm(oldtsheet));
                if (frm <> nil) then begin
                    item := aw.findItem(frm);
                    if (item <> nil) then begin
                        aw.activateItem(item.awItem);
                    end;
                end;
            end;
            AWTabControl.ActivePage := oldtsheet;
        except
        end;
    end
    else if (AWTabControl.PageCount > 0) then begin
        try
            // No old sheet was showing but one should be now
            // as the PageCount is positive, so force the page
            // at index 0 to show.
            aw := GetActivityWindow();
            if (aw <> nil) then begin
                frm := TfrmDockable(getTabForm(AWTabControl.Pages[0]));
                if (frm <> nil) then begin
                    item := aw.findItem(frm);
                    if (item <> nil) then begin
                        aw.activateItem(item.awItem);
                    end;
                end;
            end;
        except
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.WMActivate(var msg: TMessage);
var
    frm: TfrmDockable;
begin
    if (Msg.WParamLo <> WA_INACTIVE) then begin
        checkFlash();
        if (_dockState = dsDocked) then begin
            frm := getTopDocked();
            if (frm <> nil) and (frm.visible) then begin
                frm.gotActivate();
            end;
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
         newState := dsUnDocked;
       end
       else begin
         newState := dsDocked;
       end
    end
    else
      newState := dsUnDocked;

    if (newState <> oldState) then begin
          if (newState = dsDocked) then
            _layoutDock()
          else
            _layoutAWOnly();
    end;

    _glueCheck();
end;

{
    Adjust layout so roster panel and dock panel are shown
}
{---------------------------------------}
procedure TfrmDockWindow._layoutDock();
var
  mon: TMonitor;
  ratioRoster: real;
  aw: TfrmActivityWindow;
begin
    if (_dockState <> dsDocked) then begin
        _saveDockWidths();
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

        Self.DockSite := false;
        pnlActivityList.DockSite := false;
        AWTabControl.DockSite := true;

        _dockState := dsDocked;

        aw := GetActivityWindow();
        if (aw <> nil) then begin
            aw.setDockingSpacers(_dockState);
        end;
    end;
end;

{
    Adjust layout so only roster panel is shown
}
{---------------------------------------}
procedure TfrmDockWindow._layoutAWOnly();
var
  aw: TfrmActivityWindow;
begin
    //if tabs were being shown, save tab size
    _saveDockWidths();
    if (_dockState <> dsUnDocked) then begin
        AWTabControl.Visible := false;
        pnlActivityList.Align := alClient;
        splAW.Visible := false;
        Self.ClientWidth := MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH);
        Self.DockSite := true;
        pnlActivityList.DockSite := true;
        AWTabControl.DockSite := false;

        _dockState := dsUnDocked;

        aw := GetActivityWindow();
        if (aw <> nil) then begin
            aw.setDockingSpacers(_dockState);
        end;
    end;
end;

{
    Save the current roster and dock panel widths.

    Depending on current state...
}
{---------------------------------------}
procedure TfrmDockWindow._saveDockWidths();
begin
    if (_dockState = dsUnDocked) then
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_WIDTH, pnlActivityList.Width)
    else if (_dockState = dsDocked) then begin
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_WIDTH, pnlActivityList.Width);
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH, AWTabControl.Width);
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.setWindowCaption(txt: widestring);
begin
    if (txt = '') then begin
        Caption := MainSession.Prefs.getString('brand_caption');
    end
    else begin
        Caption := txt +
                   ' - ' +
                   MainSession.Prefs.getString('brand_caption');
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.timFlasherTimer(Sender: TObject);
begin
    inherited;
    // Flash the window
    FlashWindow(Self.Handle, true);
end;

{---------------------------------------}
procedure TfrmDockWindow.Flash();
begin
    If (Self.Active and not MainSession.Prefs.getBool('notify_docked_flasher')) then begin
        timFlasher.Enabled := false;
        exit; //0.9.1.0 behavior
    end;
    // flash window
    if (not Self.Showing) then begin
        Self.WindowState := wsMinimized;
        Self.Visible := true;
        if (_canShowWindow()) then begin
            ShowWindow(Handle, SW_SHOWMINNOACTIVE);
        end;
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
procedure TfrmDockWindow.checkFlash();
begin
    //notify_docked_flasher is a badly named pref that controls
    //whether or not the docking window should continue to flash until
    //every "notified" docked window has been brought to the front.
    //This means walking the list and checking the IsNotifying flag
    //however... this functionality will drive you crazy. It is
    //turned off and invisible in Exodus' defaults.xml
//    if (timFlasher.Enabled and
//       (not MainSession.Prefs.getBool('notify_docked_flasher'))) then
        timFlasher.Enabled := false;
end;

{---------------------------------------}
procedure TfrmDockWindow.WMSyscommand(var msg: TWmSysCommand);
begin
    case (msg.cmdtype and $FFF0) of
        SC_MAXIMIZE: begin
            if (_dockState = dsUnDocked) then begin
                Self.Constraints.MaxWidth := Self.Width;
            end;
            inherited;
        end;
        SC_RESTORE: begin
            if (_dockState = dsUnDocked) then begin
                Self.Constraints.MaxWidth := Self.Width;
            end;
            inherited;
        end;
        else begin
            inherited;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.OnMove(var Msg: TWMMove);
begin
    _glueCheck();
    moveGlued();
    inherited;
end;

{---------------------------------------}
procedure TfrmDockWindow._needToBeShowingCheck();
var
    aw: TfrmActivityWindow;
begin
    // This check is here to hide the activity
    // window if nothing is docked or undocked
    // (nothing in list).  There is no reason to
    // show the activity list if there are no
    // windows to track.  Note, check for undocking
    // exists to prevent flashing when an undock
    // closes the docked item and readds the undocked
    // item.
    aw := GetActivityWindow();
    if (aw <> nil) then begin
        if ((aw.itemCount <= 0) and
            (not _undocking)) then begin
            // We shouldn't be showing
            frmExodus.mnuWindows_View_ShowActivityWindow.Checked := false;
            frmExodus.mnuWindows_View_ShowActivityWindow.Enabled := false;
            frmExodus.trayShowActivityWindow.Enabled := false;
            frmExodus.btnActivityWindow.Enabled := false;
            frmExodus.trayShowActivityWindow.Enabled := false;
            Self.Close(); //hide
        end
        else begin
            // We CAN be shown, but don't HAVE to be shown so
            // enable window access
            frmExodus.mnuWindows_View_ShowActivityWindow.Checked := true;
            frmExodus.mnuWindows_View_ShowActivityWindow.Enabled := true;
            frmExodus.trayShowActivityWindow.Enabled := true;
            frmExodus.btnActivityWindow.Enabled := true;
            frmExodus.trayShowActivityWindow.Enabled := true;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow._glueCheck();
begin
    if (Self.WindowState = wsMaximized) then exit;

    _glueEdge := withinGlueSnapRange(frmExodus, Self, _glueRange);

    if (_glueEdge <> geNone) then begin
        frmExodus.glueWindow(true);
    end
    else begin
        frmExodus.glueWindow(false);
    end;
end;

{---------------------------------------}
function TfrmDockWindow._canShowWindow(): boolean;
var
    aw: TfrmActivityWindow;
begin
    Result := false;

    aw := GetActivityWindow();
    if (aw <> nil) then begin
        if ((aw.itemCount > 0) and
            (not _suppressShow)) then begin
            Result := true;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.moveGlued();
begin
    if (Self.WindowState = wsMaximized) then exit;
    
    if (Self.Showing) then begin
        case (_glueEdge) of
            geTop: begin
                // Glued on my Top edge
                Self.Top := frmExodus.Top + frmExodus.Height;
                Self.Left := frmExodus.Left;
            end;
            geLeft: begin
                // Glued on my Left edge
                Self.Top := frmExodus.Top;
                Self.Left := frmExodus.Left + frmExodus.Width;
            end;
            geRight: begin
                // Glued on my Right edge
                Self.Top := frmExodus.Top;
                Self.Left := frmExodus.Left - Self.Width;
            end;
            geBottom: begin
                // Glued on my Bottom edge
                Self.Top := frmExodus.Top - Self.Height;
                Self.Left := frmExodus.Left;
            end;
            else begin
                // Not glued - nothing to do
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/dockwindow/disableshow') then begin
        _suppressShow := true;
    end
    else if (event = '/session/dockwindow/enableshow') then begin
        _suppressShow := false;
    end;

end;

{---------------------------------------}
function TfrmDockWindow.GetActiveTabSheet(): TTntTabSheet;
var
    i: integer;
begin
    Result := TTntTabSheet(AWTabControl.ActivePage);

    if (Result = nil) then begin
        for i := 0 to AWTabControl.PageCount - 1 do begin
            if (AWTabControl.Pages[i].Visible) then begin
                Result := TTntTabSheet(AWTabControl.Pages[i]);
                break;
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.changeGotoAcitivityWindowButton();
const
    ALBUTTON_NORMAL = 8;
    ALBUTTON_UNREAD = 9;
    ALBUTTON_PRI = 10;
var
    i: integer;
    imgref: integer;
    frm: TfrmDockable;
    aw: TfrmActivityWindow;
begin
    imgref := ALBUTTON_NORMAL;

    aw := GetActivityWindow();

    if (aw <> nil) then
    begin
        for i := 0 to aw.itemCount - 1 do
        begin
            frm := aw.findItem(i).frm;

            if (frm.PriorityFlag) then begin
                // Priority always takes precedence, so don't need to look farther
                imgref := ALBUTTON_PRI;
                break;
            end
            else if (frm.UnreadMsgCount > 0) then begin
                // Still need to look incase there is a priority msg.
                imgref := ALBUTTON_UNREAD;
            end;
        end;
    end;

    frmExodus.btnActivityWindow.ImageIndex := imgref;
end;



end.



