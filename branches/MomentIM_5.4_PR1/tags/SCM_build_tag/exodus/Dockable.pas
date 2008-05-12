unit Dockable;
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
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    ComCtrls, Dialogs, ImgList, Buttons, ToolWin, Contnrs,
    ExtCtrls, TntComCtrls, StateForm, Unicode, XMLTag, buttonFrame, JabberMsg;

  function generateUID(): widestring;

type

  TDockNotify = procedure of object;

  TDockbarButton = class
  private
    _button: TToolButton;
    _callback: TDockNotify;
    _parentForm: TForm;

    function getImageIndex(): integer;
    procedure setImageIndex(ii: integer);
    function getHint(): WideString;
    procedure setHint(hint: Widestring);
    procedure OnClickEvent(Sender: TObject);
  protected
  public
    constructor create();
    destructor Destroy();override;

    property Hint: WideString read getHint write setHint;
    property ImageIndex: integer read getImageIndex write setImageIndex;
    property OnClick: TDockNotify read _callback write _callback;
    property Parent: TForm read _parentForm;
  end;


  {
    Dockable forms may be docked/undocked either through drag -n- dock operations
    or programatically through their DockForm/FloatForm methods. Because there
    are two different paths that result in this state change One set of events
    has been defined that will fire in either case.
  }
  TfrmDockable = class(TfrmState)
    pnlDockTop: TPanel;
    tbDockBar: TToolBar;
    btnDockToggle: TToolButton;
    btnCloseDock: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    {
        Drag event.

        Override default event handlers to change when this form should accept
        dragged objects. Fired by dock manager when user drags something over
        tab.
    }
    procedure OnDockedDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);virtual;
    {
        Drop event

        Override to handle objects dropped into form, specifically
        from dock manager (tabs)
    }
    procedure OnDockedDragDrop(Sender, Source: TObject; X, Y: Integer); virtual;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseDockClick(Sender: TObject);
    procedure btnDockToggleClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TntFormDestroy(Sender: TObject);
  private
    { Private declarations }
    _docked: boolean;
    _initiallyDocked: boolean;  //start docked?
    _normalImageIndex: integer;//image shown when not notifying
    _prefs_callback_id: integer; //ID for prefs events
    _session_close_all_callback: integer;
    _session_dock_all_callback: integer;
    _session_float_all_callback: integer;

    //Unread messages in the currently open window
    _unreadmsg: integer; // Unread msg count
    _unreadMessages: TWidestringList; //list of serialized <message> elements

    //Messages persisted through session, available at OnRestoreWindowState
    _persistMessages: boolean; //should messages be persisted through a session?

    _uid: widestring; // Unique ID (usually a jid) for this particular dockable window
    _priorityflag: boolean; // Is there a high priority msg unread
    _activating: boolean; // Is the window currently becoming active
    _lastActivity: TDateTime; // what was the last activity for this window

    function  getImageIndex(): Integer;
    procedure setImageIndex(idx: integer);
    procedure prefsCallback(event: string; tag: TXMLTag);
    procedure closeAllCallback(event: string; tag: TXMLTag);
    procedure dockAllCallback(event: string; tag: TXMLTag);
    procedure floatAllCallback(event: string; tag: TXMLTag);
  protected
    procedure OnRestoreWindowState(windowState : TXMLTag);override;
    procedure OnPersistWindowState(windowState : TXMLTag);override;
    procedure OnPersistedMessage(msg: TXMLTag);virtual;

    property NormalImageIndex: integer read _normalImageIndex write _normalImageIndex;

    procedure showDockbar(show: boolean);
    procedure showTopbar(show: boolean);
    procedure showCloseButton(show: boolean);
    procedure showDockToggleButton(show: boolean);
    procedure updateMsgCount(msg: TJabberMessage); overload;virtual;
    procedure updateMsgCount(msgTag: TXMLTag); overload;virtual;
    procedure updateLastActivity(lasttime: TDateTime); virtual;
    procedure _doActivate();

    //getters/setters for activity window properties. Allows subclasses to set their
    //state as the state of these properties change
    procedure SetUnreadMsgCount(value : integer);virtual;
    function GetUnreadMsgCount(): Integer;virtual;
  public
    _windowType: widestring; // what kind of dockable window is this

    Constructor Create(AOwner: TComponent); override;

    procedure DockForm; virtual;
    procedure FloatForm; virtual;

    procedure ShowDefault(bringtofront:boolean=true; dockOverride: string = 'n');override;

    {
        Event fired when docking is complete.

        Docked property will be true, tabsheet will be assigned. This event
        is fired after all other docking events are complete.
    }
    procedure OnDocked();virtual;

    {
        Event fired when a float (undock) is complete.

        Docked property will be false, tabsheet will be nil. This event
        is fired after all other floating events are complete.
    }
    procedure OnFloat();virtual;

    {
        A notification event has occurred.

        notifyEvents is a bitmap flag of what events should fire.
    }
    procedure OnNotify(notifyEvents: integer);override;

    procedure gotActivate();override;
    procedure addDockbarButton(button: TDockbarButton);
    procedure removeDockbarButton(button: TDockbarButton);

    {
        Get the UID for the window.
    }
    function getUID(): Widestring; virtual;

    {
        Set the UID for the window.
    }
    procedure setUID(id:widestring); virtual;

    {
        Clear out the UnreadMsgCount
    }
    procedure ClearUnreadMsgCount(); virtual;

    { Public Properties }
    property Docked: boolean read _docked write _docked;
    property FloatPos: TRect read getPosition;

    property ImageIndex: Integer read getImageIndex write setImageIndex;

    {
        A UID (usually a JID) that identifies this window for tracking
        by the activity window.
    }
    property UID: WideString read _uid write _uid;
    property UnreadMsgCount: integer read GetUnreadMsgCount write SetUnreadMsgCount;
    property PriorityFlag: boolean read _priorityflag write _priorityflag;
    property Activating: boolean read _activating write _activating;
    property LastActivity: TDateTime read _lastActivity write _lastActivity;
    property WindowType: widestring read _windowType write _windowType;
    property PersistUnreadMessages: boolean read _persistMessages write _persistMEssages;
  end;

var
  dockable_uid: integer;
  frmDockable: TfrmDockable;

implementation

{$R *.dfm}

uses
    PrefController,
    RosterImages,
    JabberConst,
    IDGlobal,
    XMLUtils, XMLParser, ChatWin, Debug, JabberUtils, ExUtils,  GnuGetText, Session, Jabber1;

function generateUID(): widestring;
begin
    Inc(dockable_uid);
    Result := 'dockableUID_' + inttostr(dockable_uid);
end;

constructor TDockbarButton.create();
begin
    inherited create();
    _button := TToolButton.create(nil);
    _button.OnClick := OnClickEvent;
    _button.ShowHint := true;
    _callback := nil;
    _parentForm := nil;
end;

function TDockbarButton.getImageIndex(): integer;
begin
    Result := _button.ImageIndex;
end;

procedure TDockbarButton.setImageIndex(ii: integer);
begin
    _button.ImageIndex := ii;
end;

function TDockbarButton.getHint(): WideString;
begin
    Result := _button.Hint;
end;

procedure TDockbarButton.setHint(hint: Widestring);
begin
    _button.Hint := hint;
end;

procedure TDockbarButton.OnClickEvent(Sender: TObject);
begin
    if (Assigned(_callback)) then
        _callback();
end;

destructor TDockbarButton.Destroy();
begin
    _parentForm := nil;
    _button.Parent := nil;
    _button.free();
    inherited;
end;

Constructor TfrmDockable.Create(AOwner: TComponent);
begin
    inherited;
    _normalImageIndex := RosterImages.RI_AVAILABLE_INDEX;
    _docked := false;
    _initiallyDocked := true;
    SnapBuffer := MainSession.Prefs.getInt('edge_snap');

    _prefs_callback_id := MainSession.RegisterCallback(prefsCallback, '/session/prefs');
    _session_close_all_callback := MainSession.RegisterCallback(closeAllCallback, '/session/close-all-windows');
    _session_dock_all_callback := MainSession.RegisterCallback(dockAllCallback, '/session/dock-all-windows');
    _session_float_all_callback := MainSession.RegisterCallback(floatAllCallback, '/session/float-all-windows');

    _unreadmsg := -1;
    _unreadMessages := TWidestringList.create();
    _persistMessages := false;

    _priorityflag := false;
    activating := false;

    _uid := generateUID();
end;

{---------------------------------------}
procedure TfrmDockable.FormCreate(Sender: TObject);
begin
    btnCloseDock.ImageIndex := RosterImages.RosterTreeImages.Find(RI_CLOSETAB_KEY);
    btnDockToggle.ImageIndex := RosterImages.RosterTreeImages.Find(RI_UNDOCK_KEY);

    inherited;
end;

procedure TfrmDockable.setImageIndex(idx: integer);
begin
    _normalImageIndex := idx;
    RosterTreeImages.GetIcon(idx, Self.Icon);
    GetDockManager().UpdateDocked(self);
end;

function TfrmDockable.getImageIndex(): Integer;
begin
        Result := _normalImageIndex;
end;

procedure TfrmDockable.SetUnreadMsgCount(value : integer);
begin
    _unreadmsg := value;
    GetDockManager().UpdateDocked(self);
end;

function TfrmDockable.GetUnreadMsgCount(): integer;
begin
    Result := _unreadmsg;
end;

procedure TfrmDockable.OnDockedDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    inherited;
    Accept := false;
    //implement in subclass
end;

procedure TfrmDockable.OnDockedDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
    inherited;
    //implement in subclass
end;

procedure TfrmDockable.OnPersistedMessage(msg: TXMLTag);
begin
    //nop in base class
end;

{---------------------------------------}
procedure TfrmDockable.btnCloseDockClick(Sender: TObject);
begin
    inherited;
    Self.Close();
end;

{---------------------------------------}
procedure TfrmDockable.btnDockToggleClick(Sender: TObject);
begin
    inherited;
    if (Docked) then
        FloatForm()
    else
        DockForm();

    _doActivate();
end;

{---------------------------------------}
procedure TfrmDockable._doActivate();
begin
    _activating := true;
    ClearUnreadMsgCount();

    try
        GetDockManager().UpdateDocked(Self);
    except

    end;
    _activating := false;
end;

{---------------------------------------}
procedure TfrmDockable.DockForm;
begin
    GetDockManager().OpenDocked(self);
end;

{---------------------------------------}
procedure TfrmDockable.FloatForm;
begin
    GetDockManager().FloatDocked(Self);
end;

{---------------------------------------}
procedure TfrmDockable.gotActivate();
begin
    inherited;

    _doActivate();
end;

{---------------------------------------}
procedure TfrmDockable.ClearUnreadMsgCount();
begin
    if (_unreadmsg > 0) then
        _unreadmsg := 0;

    _unreadMessages.clear();
    _priorityflag := false;
end;

{---------------------------------------}
procedure TfrmDockable.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    inherited;
    MainSession.UnRegisterCallback(_prefs_callback_id);
    MainSession.UnRegisterCallback(_session_close_all_callback);
    MainSession.UnRegisterCallback(_session_dock_all_callback);
    MainSession.UnRegisterCallback(_session_float_all_callback);
end;

procedure TfrmDockable.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    GetDockManager().CloseDocked(Self);
    inherited;
end;

{---------------------------------------}
procedure TfrmDockable.ShowDefault(bringtofront:boolean; dockOverride: string);
begin
    if (self.Visible and Docked) then begin
        if (bringtofront) then begin
            GetDockManager().BringDockedToTop(Self);
            GetDockManager().BringToFront();
        end;
    end
    else if (Self.Visible) then
        inherited
    else begin
        RestoreWindowState();
        // show this form using the default behavior
        if (not self.Visible and _initiallyDocked and (dockOverride <> 'f')) then begin
            Self.DockForm();
            if (bringtofront) then begin
               GetDockManager().BringDockedToTop(Self);
               GetDockManager().ShowDockManagerWindow(); //Make sure window is showing here.
            end;
        end
        else begin
            inherited; //let base class show window
            Self.OnFloat(); //fire float event so windows can fix up
        end;
    end;
    GetDockManager().UpdateDocked(Self); // Make sure activity list is updated.
end;

{---------------------------------------}
procedure TfrmDockable.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
    // handle Ctrl-Tab to switch tabs
    if ((Key = VK_TAB) and (ssCtrl in Shift) and (self.Docked))then begin
        GetDockManager().SelectNext(not (ssShift in Shift));
        Key := 0;
    end
    //if ctrl d try to toggle dock state
    else if ((Jabber1.getAllowedDockState() <> adsForbidden) and ([ssCtrl] = Shift)) and (Key=68) then begin
      btnDockToggleClick(Self);
      Key := 0;
    end;
end;

function visibleButtonCount(bar: TToolBar): integer;
var
    i : integer;
begin
    Result := 0;
    for i := 0 to bar.ButtonCount - 1 do begin
        if (bar.Buttons[i].Visible) then
            inc(Result);
    end;
end;

procedure TfrmDockable.OnDocked();
begin
    Self.Align := alClient;
    tbDockBar.Visible := true;
    btnCloseDock.Visible := true;
    btnDockToggle.ImageIndex := RosterImages.RosterTreeImages.Find(RI_UNDOCK_KEY);
    btnDockToggle.Hint := _('Undock this tab (ctrl-d)');
    btnDockToggle.Visible := (Jabber1.getAllowedDockState() <> adsForbidden);
    pnlDockTop.Visible := true;
end;

procedure TfrmDockable.OnFloat();
begin
    btnCloseDock.Visible := false;
    btnDockToggle.ImageIndex := RosterImages.RosterTreeImages.Find(RI_DOCK_KEY);
    btnDockToggle.Visible := (Jabber1.getAllowedDockState() <> adsForbidden);
    btnDockToggle.Hint := _('Dock this window (ctrl-d)');
    //hide top panel if no toolbar buttons are showing and no subclass has
    //added a child component (pnlDockTop.ControlCount = 1 -> only toolbar)
    tbDockBar.Visible := (visibleButtonCount(tbDockbar) > 0);
    pnlDockTop.Visible := (pnlDockTop.ControlCount <> 1) or tbDockBar.Visible;
end;

procedure TfrmDockable.OnRestoreWindowState(windowState : TXMLTag);
var
    i: integer;
    ttag: TXMLTag;
    txlist: TXMLTagList;
    ads: TAllowedDockStates;
    tstr: widestring;
begin
    inherited;

    if (MainSession.Prefs.getBool('restore_window_state')) then
    begin
        ads := Jabber1.getAllowedDockState();
        tstr := windowState.GetAttribute('dock');
        if (tstr = '') and (MainSession.Prefs.getBool('start_docked')) then
            tstr := 't';
        _initiallyDocked :=  ((ads <> adsForbidden) and (tstr = 't'));
    end;

    if (PersistUnreadMessages) then
    begin
        ttag := windowState.GetFirstTag('unread');
        if (ttag <> nil) then
        begin
            txList := ttag.ChildTags;
            for i := 0 to txList.Count - 1 do
                OnPersistedMessage(txList[i]);
        end;
    end;
end;

procedure TfrmDockable.OnPersistWindowState(windowState : TXMLTag);
var
    i: integer;
    ttag: TXMLTag;
    _parser: TXMLTagParser;
begin
    ttag := windowState.AddTag('unread');
    if (PersistUnreadMessages and (_unreadMessages.Count > 0)) then
    begin
        _parser := TXMLTagParser.Create();
        for i := 0 to _unreadMessages.Count - 1 do
        begin
            _parser.Clear();
            _parser.ParseString(_unreadMessages[i], '');
            if (_parser.Count > 0) then
                ttag.AddTag(_parser.popTag());
        end;
        _parser.Free();
    end;

    if (not Floating) then
        windowState.setAttribute('dock', 't')
    else
        windowState.setAttribute('dock', 'f');
    inherited;
end;

procedure TfrmDockable.OnNotify(notifyEvents: integer);
begin
    if (Docked) then begin
        if ((notifyEvents and PrefController.notify_front) <> 0) then
            GetDockManager().BringDockedToTop(Self)
        //if form is docked, fire notify back to dock manager to handle flash
        else if ((notifyEvents and PrefController.notify_flash) <> 0) then begin
            GetDockManager().OnNotify(nil, notify_flash);
            isNotifying := true;
        end;
    end;
    inherited; //inherited will handle floating window notifications
end;

procedure TfrmDockable.addDockbarButton(button: TDockbarButton);
begin
    button._button.Parent := tbDockbar;
    button._parentForm := Self;
end;

procedure TfrmDockable.removeDockbarButton(button: TDockbarButton);
begin
    button._button.Parent := nil;
    button._parentForm := nil;
end;

procedure TfrmDockable.showDockbar(show: boolean);
begin
    tbDockBar.Visible := show;
end;

procedure TfrmDockable.showTopbar(show: boolean);
begin
    pnlDockTop.Visible := show;
end;

procedure TfrmDockable.TntFormDestroy(Sender: TObject);
begin
    inherited;
    _unreadMessages.free();
end;

procedure TfrmDockable.showCloseButton(show: boolean);
begin
    btnCloseDock.Visible := show;
end;

procedure TfrmDockable.showDockToggleButton(show: boolean);
begin
    btnDockToggle.Visible := show;
end;

procedure TfrmDockable.prefsCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/prefs') then
        SnapBuffer := MainSession.Prefs.getInt('edge_snap');
end;

function TfrmDockable.getUID(): Widestring;
begin
    Result := _uid;
end;

procedure TfrmDockable.setUID(id:widestring);
begin
    _uid := id;
end;

procedure TfrmDockable.updateMsgCount(msg: TJabberMessage);
begin
    _priorityflag := _priorityflag or (msg.Priority = High);
    UpdateMsgCount(msg.Tag);
end;

//create an appropriate delay tag from datetime, optional from, description
function CreateDelayTag(dt: TDateTime; from: widestring=''; desc: widestring=''): TXMLTag;
begin
    //for now, x tag
    Result := TXMLTag.create('x');
    Result.setAttribute('xmlns', XMLNS_DELAY);
    Result.setAttribute('stamp', DateTimeToJabber(dt));
    if (from <> '') then
        Result.setAttribute('from', from);
    if (desc <> '') then
        Result.AddCData(desc)
end;

procedure TfrmDockable.updateMsgCount(msgTag: TXMLTag);
var
    etag, dttag: TXMLTag;
    ttag: TXMLTag;
begin
    //no message or we are not tracking messages
    if (msgTag = nil) or (_unreadmsg = -1) then exit;

    if (not Active) then
    begin
        if ((not Docked) or
            (GetDockManager().getTopDocked() <> Self) or
            (not GetDockManager().isActive)) then
        begin
            Inc(Self._unreadmsg);
            if (PersistUnreadMessages) then
            begin
                ttag := nil;
                //add dtstamp if not already in packet
                dttag := GetDelayTag(msgTag);
                if (dttag = nil) then
                begin
                    ttag := TXMLTag.create(msgTag);
                    ttag.AddTag(CreateDelayTag(now()+ TimeZoneBias()));
                end;

                //filter tag, removing anything we don't want to persist (events for instance)
                etag := msgTag.QueryXPTag(XP_MSGXEVENT);
                if (etag <> nil) then
                begin
                    if (ttag = nil) then
                        ttag := TXMLTag.create(msgTag);
                    etag := ttag.QueryXPTag(XP_MSGXEVENT);
                    ttag.RemoveTag(etag);
                end;
                if (ttag <> nil) then
                begin
                    _unreadMessages.Add(ttag.XML);
                    ttag.Free();
                end
                else _unreadMessages.Add(msgTag.XML);
            end;
        end;

        GetDockManager().UpdateDocked(self);
    end;
end;

procedure TfrmDockable.updateLastActivity(lasttime: TDateTime);
begin
    if (lasttime > _lastActivity) then begin
        _lastActivity := lasttime;
    end;
end;

procedure TfrmDockable.closeAllCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/close-all-windows') then begin
        Self.Close();
        Application.ProcessMessages();
    end;
end;

procedure TfrmDockable.dockAllCallback(event: string; tag: TXMLTag);
begin
    if ((event = '/session/dock-all-windows') and
        (not _docked)) then begin
        Self.DockForm;
    end;
end;

procedure TfrmDockable.floatAllCallback(event: string; tag: TXMLTag);
begin
    if ((event = '/session/float-all-windows') and
        (_docked)) then begin
        Self.FloatForm;
    end;
end;



initialization
    dockable_uid := 0;


end.
