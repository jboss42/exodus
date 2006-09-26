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
    XMLTag;

type
  TDockNotify = procedure of object;
  {
    Dockable forms may be docked/undocked either through drag -n- dock operations
    or programatically through their DockForm/FloatForm methods. Because there
    are two different paths that result in this state change One set of events
    has been defined that will fire in either case.
  }
  TfrmDockable = class(TfrmState)
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
  private
    { Private declarations }
    _docked: boolean;
    _top: boolean;
    _dockChanging: boolean;
    _initiallyDocked: boolean;
    _bringToFront: boolean;

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMActivate(var msg: TMessage); message WM_ACTIVATE;
    procedure WMDisplayChange(var msg: TMessage); message WM_DISPLAYCHANGE;
    procedure WMWindowPosChanging(var msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;

    procedure OnRestoreWindowState(windowState : TXMLTag);override;
    procedure OnPersistWindowState(windowState : TXMLTag);override;

  public
    { Public declarations }
    TabSheet: TTntTabSheet;
    ImageIndex: integer;
    procedure DockForm; virtual;
    procedure FloatForm; virtual;
    procedure ShowDefault;override;
    procedure gotActivate; virtual;
    {
        Event fired when Form receives activation while in docked state.

        Fired by DockManager when tab is activated (brought to front)
    }
    procedure OnDockedActivate(Sender : TObject);virtual;

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

    property Docked: boolean read _docked write _docked;

    property FloatPos: TRect read getPosition;
  end;

var
  frmDockable: TfrmDockable;

implementation

{$R *.dfm}

uses
    XMLUtils, ChatWin, Debug, JabberUtils, ExUtils,  GnuGetText, Session, Jabber1;

{---------------------------------------}
procedure TfrmDockable.FormCreate(Sender: TObject);
begin
    ImageIndex := 43;
    _docked := false;
    _dockChanging := false;
    _initiallyDocked := false;
    _bringToFront := false;
    SnapBuffer := MainSession.Prefs.getInt('edge_snap');
    inherited;
end;

{
    Drag event.

    Override default event handlers to change when this form should accept
    dragged objects. This is called from dock manager (tabs)
}
procedure TfrmDockable.OnDockedDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    inherited;
    Accept := false;
    //implement in subclass
end;

{
    Drop event

    Override to handle objects dropped into form, specifically
    from dock manager (tabs)
}
procedure TfrmDockable.OnDockedDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
    inherited;
    //implement in subclass
end;

{---------------------------------------}
procedure TfrmDockable.DockForm;
begin
    _dockChanging := true;
    Self.TabSheet := frmExodus.OpenDocked(self);
    _dockChanging := false;
end;

{---------------------------------------}
procedure TfrmDockable.FloatForm;
begin
    _dockChanging := true;
    frmExodus.FloatDocked(Self);
    _dockChanging := false;
end;

{---------------------------------------}
procedure TfrmDockable.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    if (_docked) then 
        frmExodus.CloseDocked(Self);
    inherited;
end;

{---------------------------------------}
procedure TfrmDockable.CreateParams(var Params: TCreateParams);
begin
    // Make each window appear on the task bar.
    inherited CreateParams(Params);
    with Params do begin
        ExStyle := ExStyle or WS_EX_APPWINDOW;
    end;
end;

{---------------------------------------}
procedure TfrmDockable.ShowDefault;
var
    ads: TAllowedDockStates;
begin
    if (self.Visible) then begin
        if (Self.TabSheet <> nil) then
            frmExodus.BringDockedToTop(Self)
        else
            inherited;
    end
    else begin
        RestoreWindowState();
        ads := Jabber1.getAllowedDockState();
        // show this form using the default behavior
        if ((ads = adsRequired) or ((ads <> adsForbidden) and _initiallyDocked)) then begin
            Self.DockForm();
            frmExodus.BringDockedToTop(Self);
        end
        else begin
            inherited; //let base class show window
            Self.OnFloat(); //fire float event so windows can fix up
        end;
    end;
    Self.Show();
end;

{---------------------------------------}
procedure TfrmDockable.WMDisplayChange(var msg: TMessage);
begin
    checkAndCenterForm(Self);
end;

{---------------------------------------}
procedure TfrmDockable.WMActivate(var msg: TMessage);
var
    m: string;
begin
    if ((not _top) and
        ((Application.Active) or (Msg.WParamLo = WA_CLICKACTIVE))) then begin
        // we are getting clicked..
        m := Self.className + '.WMActivate ' + Self.Caption;
        OutputDebugString(PChar(m));

        _top := true;
        _bringToFront := true;
        SetWindowPos(Self.Handle, 0,0,0,0,0, HWND_TOP or SWP_NOSIZE or SWP_NOMOVE);
        _top := false;
        _bringToFront := false;

        StopTrayAlert();
        gotActivate();
    end;

    inherited;
end;

{---------------------------------------}
procedure TfrmDockable.WMWindowPosChanging(var msg: TWMWindowPosChanging);
begin

    if (not _top) then
        msg.WindowPos^.flags := msg.WindowPos^.flags or SWP_NOZORDER;

    inherited;
end;

{---------------------------------------}
procedure TfrmDockable.gotActivate();
begin
    // implement this in sub-classes.
end;

{---------------------------------------}
{

    Event fired when Form receives activation while in docked state.

    Fired by DockManager when tab is activated (brought to front)
}
procedure TfrmDockable.OnDockedActivate(Sender : TObject);
begin
    inherited;
    //subclasses override to change activation behavior
     if (Self.TabSheet <> nil) then
        Self.TabSheet.ImageIndex := ImageIndex;
end;

{
    Event fired when docking is complete.

    Docked property will be true, tabsheet will be assigned. This event
    is fired after all other docking events are complete.
}
procedure TfrmDockable.OnDocked();
begin
    Self.Align := alClient;
    Self.TabSheet.ImageIndex := Self.ImageIndex;
end;

procedure TfrmDockable.OnFloat();
begin

end;

procedure TfrmDockable.OnRestoreWindowState(windowState : TXMLTag);
begin
    inherited;
    _initiallyDocked := (windowState.GetAttribute('dock') = 't');
end;

procedure TfrmDockable.OnPersistWindowState(windowState : TXMLTag);
begin
    if (not Floating) then
        windowState.setAttribute('dock', 't')
    else 
        windowState.removeAttribute('dock');
    inherited;
end;

end.
