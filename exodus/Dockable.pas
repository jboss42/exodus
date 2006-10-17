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
    ComCtrls, Dialogs, ExtCtrls, TntComCtrls, StateForm,
    XMLTag, ToolWin, ImgList, buttonFrame, Buttons;


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
  published
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
  private
    { Private declarations }
    _docked: boolean;
    _initiallyDocked: boolean;  //start docked?

    _normalImageIndex: integer;//image shown when not notifying
    _notifyImageIndex: integer;//image shown when notifying

    function  getImageIndex(): Integer;
    procedure setImageIndex(idx: integer);
  protected
    procedure OnRestoreWindowState(windowState : TXMLTag);override;
    procedure OnPersistWindowState(windowState : TXMLTag);override;

    procedure OnFlash();override;

    property NormalImageIndex: integer read _normalImageIndex write _normalImageIndex;
    property NotifyImageIndex: integer read _notifyImageIndex write _notifyImageIndex;

    procedure showDockbar(show: boolean);
    procedure showTopbar(show: boolean);
    procedure showCloseButton(show: boolean);
    procedure showDockToggleButton(show: boolean);
  public
    { Public declarations }
    procedure DockForm; virtual;
    procedure FloatForm; virtual;

    procedure ShowDefault(bringtofront:boolean=true);override;

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

    procedure  addDockbarButton(button: TDockbarButton);
    procedure removeDockbarButton(button: TDockbarButton);


    property Docked: boolean read _docked write _docked;

    property FloatPos: TRect read getPosition;

    {
        Index into the TRosterImages list for image mapping

        ImageIndex controls what image appears on a tab for a docked
        form. @see jopl/RosterImages for complete image map

        Base class will use either normalImageIndex (not notifying) or
        notifyImageIndex when this property is read. When this property
        is set, normalImageIndex is set and dock manager refreshTab is
        called.
    }
    property ImageIndex: Integer read getImageIndex write setImageIndex;

  end;

var
  frmDockable: TfrmDockable;

implementation

{$R *.dfm}

uses
    PrefController,
    RosterImages,
    XMLUtils, ChatWin, Debug, JabberUtils, ExUtils,  GnuGetText, Session, Jabber1;

constructor TDockbarButton.create();
begin
    inherited create();
    _button := TToolButton.create(nil);
    _button.OnClick := OnClickEvent;
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

{---------------------------------------}
procedure TfrmDockable.FormCreate(Sender: TObject);
begin
    _normalImageIndex := RosterImages.RI_APPIMAGE_INDEX;
    _notifyImageIndex := RosterImages.RI_ATTN_INDEX;
    btnCloseDock.ImageIndex := RosterImages.RosterTreeImages.Find(RI_CLOSETAB_KEY);
    btnDockToggle.ImageIndex := RosterImages.RosterTreeImages.Find(RI_UNDOCK_KEY);
    _docked := false;
    _initiallyDocked := true;

    SnapBuffer := MainSession.Prefs.getInt('edge_snap');
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
    if (isNotifying and (GetDockmanager().getTopDocked() <> Self)) then
        Result := _notifyImageIndex
    else
        Result := _normalImageIndex;
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

{---------------------------------------}
procedure TfrmDockable.btnCloseDockClick(Sender: TObject);
begin
    inherited;
    Self.Close();
end;

procedure TfrmDockable.btnDockToggleClick(Sender: TObject);
begin
    inherited;
    if (Docked) then
        FloatForm()
    else
        DockForm();

end;

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

    if (Docked) then begin
        OutputDebugMsg('TfrmDockable.gotActivate calling UpdateDocked: ImageIndex: ' + IntToStr(ImageIndex));
        GetDockManager().UpdateDocked(Self);
    end;
end;

{---------------------------------------}
procedure TfrmDockable.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    if (_docked) then
        GetDockManager().CloseDocked(Self);
    inherited;
end;

{---------------------------------------}
procedure TfrmDockable.ShowDefault(bringtofront:boolean);
begin
    if (self.Visible and Docked) then begin
        if (bringtofront) then
            GetDockManager().BringDockedToTop(Self);
    end
    else if (Self.Visible) then
        inherited
    else begin
        RestoreWindowState();
        // show this form using the default behavior
        if (not self.Visible and _initiallyDocked) then begin
            Self.DockForm();
            if (bringtofront) then
               GetDockManager().BringDockedToTop(Self);
        end
        else begin
            inherited; //let base class show window
            Self.OnFloat(); //fire float event so windows can fix up
        end;
    end;
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
end;

procedure TfrmDockable.OnDocked();
begin
    Self.Align := alClient;
    btnCloseDock.Visible := true;
    btnDockToggle.ImageIndex := RosterImages.RosterTreeImages.Find(RI_UNDOCK_KEY);
end;

procedure TfrmDockable.OnFloat();
begin
    btnCloseDock.Visible := false;
    btnDockToggle.ImageIndex := RosterImages.RosterTreeImages.Find(RI_DOCK_KEY);
    btnDockToggle.Visible := (Jabber1.getAllowedDockState() <> adsForbidden);
end;

procedure TfrmDockable.OnRestoreWindowState(windowState : TXMLTag);
var
    ads: TAllowedDockStates;
    tstr: widestring;
begin
    inherited;
    ads := Jabber1.getAllowedDockState();
    tstr := windowState.GetAttribute('dock');
    if (tstr = '') and (MainSession.Prefs.getBool('start_docked')) then
        tstr := 't';
    _initiallyDocked :=  (ads = adsRequired) or ((ads <> adsForbidden) and (tstr = 't'));
end;

procedure TfrmDockable.OnPersistWindowState(windowState : TXMLTag);
begin
    if (not Floating) then
        windowState.setAttribute('dock', 't')
    else
        windowState.setAttribute('dock', 'f');
    inherited;
end;

procedure TfrmDockable.OnNotify(notifyEvents: integer);
begin
    if (Docked) then begin
        if ((notifyEvents and PrefController.notify_front) > 0) then
            GetDockManager().BringDockedToTop(Self)
        //if form is docked, all we need to do is update our presentation
        else if ((notifyEvents and PrefController.notify_flash) > 0) then begin
            isNotifying := true;
            GetDockManager().UpdateDocked(Self);
        end;
    end;
    inherited; //inherited will handle floating window notifications
end;

procedure TfrmDockable.OnFlash();
begin
    //could implement flashing tabs here
    if (not Docked) then
        inherited;
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

procedure TfrmDockable.showCloseButton(show: boolean);
begin
    btnCloseDock.Visible := show;
end;

procedure TfrmDockable.showDockToggleButton(show: boolean);
begin
    btnDockToggle.Visible := show;
end;

end.
