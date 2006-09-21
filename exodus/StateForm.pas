unit StateForm;
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  XMLTag,  //JOPL XML
  TntForms; //Unicode form

const
    WS_NORMAL = 0;
    WS_MINIMIZED = 1;
    WS_MAXIMIZED = 2;
    WS_TRAY = 3;

    DEFAULT_MIN_WIDTH = 640;
    DEFAULT_MIN_HEIGHT = 480;

type
  TPos = record
      Height: integer;
      Width: integer;
      Left: integer;
      Top: Integer;
  end;

  {
    A state form is one that will save state information on close and restore
    that state at creation.

    The default implementation saves/restores position and window "state"
    (min/max/tray or restored).
  }
  TfrmState = class(TTntForm)
    procedure WMWindowPosChange(var msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure sfWMSysCommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;

    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
     _pos: TPos;          //our position
     _persistPos: boolean; //should we persist our current position?
     _origPos: TPos;      //position we last loaded/saved to prefs
     _programaticChange: boolean;
     _windowState: TWindowState; //min max or normal
     _stateRestored: boolean;

    procedure NormalizePos(); //
    function isGoodPos(pos: TPos): Boolean;
    procedure CenterOnMonitor(var pos: TPos);
  protected
    {
        Show the window in its default configuration.

        The default implementation is to show the window in its last floating
        position. Override this method to change (ie dock instead of float)
    }
    procedure ShowDefault;virtual;


    {
        Get the minimum width (x) and height(y) this form should display as.
    }
    function getDefaultSize(): TPoint;

    {
        Get the window state associated with this window.

        Default implementation is to return a munged classname (all XML illgal
        characters escaped). Classes should override to change pref (for instance
        chat windows might save based on munged profile&jid).
    }
    function GetWindowStateKey() : WideString;virtual;

    {
        Event fired when form should restore its persisted state.

        Default uses GetPreferenceKey to get pref containing this
        window's state information.

        prefTag is an xml tag
            <windowstatekey>
                <position h="" w="" l="" t=""/>
                <docked>true|false</docked>
            </windowstatekey>

        This event is fired when the form is created.
    }
    procedure OnRestoreWindowState(windowState : TXMLTag);virtual;

    {
        Event fired when form should persist its position and other state
        information.

        Default uses GetWindowStateKey to determine actual key persisted

        OnPersistState is passed an xml tag (<windowstatekey/>) that should be used to
        store state. For instance after the default OnPersistState handler is called
        prefTag will be
            <windowstatekey>
                <position h="" w="" t="" l="" />
                <docked/>
            </windowstatekey>

        This event is fired during the OnCloseQuery event.
    }
    procedure OnPersistWindowState(windowState : TXMLTag);virtual;

    {
    }
    function getPosition(): TRect;

  public
    {
        Restore window state.
    }
    procedure RestoreWindowState();

    {
        Perists window state
    }
    procedure PersistWindowState();
  end;

var
  frmState: TfrmState;

implementation

{$R *.dfm}

uses
    jabber1,
    types,
    Session,
    GnuGetText,
    ExUtils,
    XMLUtils;

procedure TfrmState.CenterOnMonitor(var pos: TPos);
var
    dtop: TRect;
    mon: TMonitor;
    cp: TPoint;

begin
    // center it on the default monitor
    mon := Screen.MonitorFromWindow(Self.Handle, mdNearest);
    dtop := mon.WorkAreaRect;
    cp := CenterPoint(dtop);

    pos.Left := cp.x - (pos.width div 2);
    pos.Top := cp.y - (pos.height div 2);
end;

{ TfrmState }
procedure TfrmState.FormCreate(Sender: TObject);
begin
    _stateRestored := false;
    //get state info from prefs
    // do translation magic
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
    _programaticChange := false;
end;

function sToWindowState(s : string): TWindowState;
begin
    if (s = 'min') then
        Result := wsMinimized
    else if (s = 'max') then
        Result := wsMaximized
    else Result := wsNormal;
end;

function wsToString(ws : TWindowState): string;
begin
    if (ws = wsMinimized) then
        Result := 'min'
    else if (ws = wsMaximized) then
        Result := 'max'
    else Result := 'normal'
end;

function b2s(b:boolean): String;
begin
    if (b) then
        Result := 'true'
    else
        Result := 'false';
end;
procedure TfrmState.sfWMSysCommand(var msg: TWmSysCommand);
begin
    case (msg.CmdType and $FFF0) of
        SC_MINIMIZE: begin
            _windowState := wsMinimized;
        end;
        SC_RESTORE: begin
            _windowState := wsNormal;
        end;
        SC_MAXIMIZE: begin
            _windowState := wsMaximized;
        end;
    end;
OutputDebugMsg('wmssyscommande: new state: ' + wsToString(_windowState));

    inherited;
end;
{---------------------------------------}
procedure TfrmState.WMWindowPosChange(var msg: TWMWindowPosChanging);
var
    inCreate: boolean;
begin
    inherited;
    inCreate := (fsCreating in Self.FormState);
// OutputDebugMsg('TfrmState.WMWindowPosChanged. _programaticChange: ' + b2s(_programaticChange) + ', Floating: ' + b2s(Floating) +', inCreate: ' + b2s(inCreate));
    if (not _programaticChange and Self.Floating and not inCreate and (_windowState = wsNormal)) then begin
        _pos.Left := Self.Left;
        _pos.width := Self.Width;
        _pos.Top := Self.Top;
        _pos.height := Self.Height;
        _persistPos := true;
OutputDebugMsg('WMWindowPosChange: updated position to: l:' + IntToStr(_pos.left) + ', t:' + IntToStr(_pos.Top) + ', h:' + IntToStr(_pos.Height) + ', w:' + IntToStr(_pos.Width));
    end;
end;

{
    Restore position and window state.

    For backwards compatablility need to check to see if
    position information is stored as attributes, if not look
    for nodes...
}
procedure TfrmState.RestoreWindowState();
var
    stateTag: TXMLTag;
begin
    if (not _stateRestored) then begin
        if (MainSession.Prefs.getBool('restore_window_state')) then
            MainSession.Prefs.getWindowState(GetWindowStateKey(), stateTag)
        else //if not persisting, use defaults
            stateTag := TXMLTag.create(GetWindowStateKey());
        Self.OnRestoreWindowState(stateTag);
OutputDebugMsg('Restored window state. key: ' + GetWindowStateKey() + ', state: ' + stateTag.XML);
        stateTag.Free();
        _stateRestored := true;
    end;
end;

procedure TfrmState.PersistWindowState();
var
    stateTag: TXMLTag;
begin
    stateTag := TXMLTag.Create(getWindowStateKey());
    Self.OnPersistWindowState(stateTag);
    MainSession.Prefs.setWindowState(getWindowStateKey(), stateTag);
OutputDebugMsg('Persisting window state. key: ' + GetWindowStateKey() + ', state: ' + stateTag.XML);
    stateTag.Free();
end;

{
    Show the window in its default configuration.

    The default implementation is to show the window in its last floating
    position. Override this method to change (ie dock instead of float)
}
procedure TfrmState.ShowDefault;
begin
    if (not Self.Visible) then begin
        RestoreWindowState();
        if (_windowState = wsMinimized) then begin
            //sc command message handler moves current _windowState to _lastState
            ShowWindow(Handle, SW_SHOWMINNOACTIVE);
        end
        else if (_windowState = wsMaximized) then begin
            ShowWindow(Handle, SW_MAXIMIZE);
        end
        else begin
            ShowWindow(Handle, SW_SHOWNOACTIVATE);
        end;
    end
    else if (frmExodus.isMinimized()) then
        ShowWindow(Handle, SW_SHOWMINNOACTIVE)
    else
        ShowWindow(Handle, SW_SHOWNOACTIVATE);
end;

{
    Get the window state associated with this window.

    Default implementation is to return a munged classname (all XML illgal
    characters escaped). Classes should override to change pref (for instance
    chat windows might save based on munged profile&jid).
}
function TfrmState.GetWindowStateKey() : WideString;
begin
    Result := XMLUtils.MungeName(Self.ClassName);
end;

{
    Event fired when form should restore its persisted state.

    Default uses GetPreferenceKey to get pref containing this
    window's state information.

    prefTag is an xml tag
        <windowstatekey>
            <position h="" w="" l="" t=""/>
            <docked>true|false</docked>
        </windowstatekey>

    This event is fired when the form is created.
}
procedure TfrmState.OnRestoreWindowState(windowState : TXMLTag);
var
    pt: TXMLTag;
begin
    _persistPos := true;
    //center on parent
    pt := windowState.GetFirstTag('pos');
    if (pt <> nil) then begin
        _pos.Left := SafeInt(pt.getAttribute('l'));
        _pos.Top := SafeInt(pt.getAttribute('t'));
        _pos.height := SafeInt(pt.getAttribute('h'));
        _pos.width := SafeInt(pt.getAttribute('w'));
    end
    else begin
        _pos.Left := 0;
        _pos.Top := 0;
        _pos.Width := Self.getDefaultSize.X;
        _pos.Height := Self.getDefaultSize.Y;
        CenterOnMonitor(_pos);
    end;
    _origPos.Left := _pos.Left;
    _origPos.width := _pos.width;
    _origPos.Top := _pos.Top;
    _origPos.height := _pos.height;
    normalizePos();
    //setwiondowpos sets the undocked dimensions of window.
    SetWindowPos(Self.Handle, 0, _pos.Left, _pos.Top, _pos.Width, _pos.Height, SWP_NOOWNERZORDER);
    //add minimized, maximized or restored
    _windowState := sToWindowState(windowState.GetBasicText('ws'));
end;

{
    Event fired when form should persist its position and other state
    information.

    Default uses GetWindowStateKey to determine actual key persisted

    OnPersistState is passed an xml tag (<windowstatekey/>) that should be used to
    store state. For instance after the default OnPersistState handler is called
    prefTag will be
        <windowstatekey>
            <position h="" w="" t="" l="" />
            <docked>true|false</docked>
        </windowstatekey>

    This event is fired during the OnCloseQuery event.
}
procedure TfrmState.OnPersistWindowState(windowState : TXMLTag);
var
    tp : TPos;
    ptag: TXMLTag;
    tstr: string;
begin
    if (_persistPos) then
        tp := _pos
    else
        tp := _origPos;
    ptag := windowState.GetFirstTag('pos');
    if (ptag = nil) then
        ptag := windowState.AddTag('pos');
    ptag.setAttribute('h', IntToStr(tp.height));
    ptag.setAttribute('w', IntToStr(tp.width));
    ptag.setAttribute('t', IntToStr(tp.Top));
    ptag.setAttribute('l', IntToStr(tp.Left));
    //add min/max/restored (see Self.WindowState)
    tstr := '0';
    if (Self.WindowState = wsMinimized) then
        tstr := '1'
    else if (Self.WindowState = wsMaximized) then
        tstr := '2';
    windowState.AddBasicTag('ws', wsToString(_windowState));
end;

{---------------------------------------}
function TfrmState.isGoodPos(pos: TPos) : boolean;
begin
    Result := (pos.Width >= Self.Constraints.MinWidth) and (pos.Height >= Self.Constraints.MinHeight);
end;

procedure TfrmState.NormalizePos();
var
    ok: boolean;
    dtop: TRect;
    mon: TMonitor;
    cp: TPoint;
    vwidth, vht, i: integer;
begin

    // Netmeeting hack
    if (Assigned(Application.MainForm)) then
        Application.MainForm.Monitor;

    // Make it slightly bigger to acccomodate PtInRect
    dtop := Screen.DesktopRect;
    dtop.Bottom := dtop.Bottom + 1;
    dtop.Right := dtop.Right + 1;

    cp.X := _pos.left;
    cp.Y := _pos.Top;
    ok := PtInRect(dtop, cp);

    cp.X := _pos.left + _pos.width;
    cp.Y := _pos.Top + _pos.Height;
    ok := ok and PtInRect(dtop, cp);

    if (ok = false) then begin
        //we had to move this window as it won't fit in our desktop.
        //don't save new coords.
        _persistPos := false;
        CenterOnMonitor(_pos);
    end;
end;

procedure TfrmState.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    PersistWindowState();
end;

function TfrmState.getPosition(): TRect;
begin
    Result := Bounds(_pos.Left, _pos.Top, _pos.Width, _pos.Height);
end;

{
    Get the minimum width (x) and height(y) this form should display as.
}
function TfrmState.getDefaultSize(): TPoint;
begin
    Result.X := DEFAULT_MIN_WIDTH;
    Result.Y := DEFAULT_MIN_HEIGHT;
end;

end.
