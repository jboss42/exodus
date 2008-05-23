unit COMAXWindow;
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

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, Variants, ComCtrls,
  ComObj, ActiveX, Exodus_TLB,
  StdVcl, PLUGINCONTROLLib_TLB, ActiveXDockable;

type
  TExodusAXWindow = class(TAutoObject, IExodusAXWindow)
  private
    _frm: TfrmActiveXDockable;

  public
    constructor Create(form: TfrmActiveXDockable);

  protected
    function Get_OleObject: OleVariant; safecall;
    procedure Close; safecall;
    procedure BringToFront; safecall;
    function Get_UnreadMsgCount: Integer; safecall;
    procedure Dock; safecall;
    procedure Set_UnreadMsgCount(Value: Integer); safecall;
    procedure Float; safecall;
    function Get_LastActivityTime: TDateTime; safecall;
    procedure Set_LastActivityTime(Value: TDateTime); safecall;
    function Get_WindowType: WideString; safecall;
    procedure Set_WindowType(const Value: WideString); safecall;
    function Get_ImageIndex: Integer; safecall;
    procedure Set_ImageIndex(value: Integer); safecall;
    function Get_PriorityFlag: WordBool; safecall;
    procedure Set_PriorityFlag(Value: WordBool); safecall;
    procedure RegisterCallback(const callback: IExodusAXWindowCallback); safecall;
    procedure UnRegisterCallback; safecall;

  end;

implementation

uses
    RosterImages, ComServ;

constructor TExodusAXWindow.Create(form: TfrmActiveXDockable);
begin
    _frm := form;
end;

function TExodusAXWindow.Get_OleObject: OleVariant;
begin
    Result := unassigned;
    try
        if ((_frm <> nil) and
            (_frm.AXControl <> nil)) then begin
            Result := _frm.AXControl.OleObject;
        end;
    except
    end;
end;

procedure TExodusAXWindow.Close;
begin
    if (_frm <> nil) then begin
        _frm.Close;
    end;
end;

procedure TExodusAXWindow.BringToFront;
begin
    if (_frm <> nil) then begin
        _frm.ShowDefault();
    end;
end;


function TExodusAXWindow.Get_UnreadMsgCount: Integer;
begin
    Result := 0;
    if (_frm <> nil) then begin
        Result := _frm.UnreadMsgCount;
    end;
end;

procedure TExodusAXWindow.Dock;
begin
    if (_frm <> nil) then begin
        _frm.DockForm;
    end;
end;

procedure TExodusAXWindow.Set_UnreadMsgCount(Value: Integer);
begin
    if (_frm <> nil) then begin
        _frm.UnreadMsgCount := Value;
    end;
end;

procedure TExodusAXWindow.Float;
begin
    if (_frm <> nil) then begin
        _frm.FloatForm;
    end;
end;

function TExodusAXWindow.Get_LastActivityTime: TDateTime;
begin
    Result := Now;
    if (_frm <> nil) then begin
        Result := _frm.LastActivity;
    end;
end;

procedure TExodusAXWindow.Set_LastActivityTime(Value: TDateTime);
begin
    if (_frm <> nil) then begin
        _frm.LastActivity := Value;
    end;
end;

function TExodusAXWindow.Get_WindowType: WideString;
begin
    Result := '';
    if (_frm <> nil) then begin
        Result := _frm.WindowType;
    end;
end;

procedure TExodusAXWindow.Set_WindowType(const Value: WideString);
begin
    if (_frm <> nil) then begin
        _frm.WindowType := value;
    end;
end;

function TExodusAXWindow.Get_ImageIndex: Integer;
begin
    Result := 0;
    if (_frm <> nil) then begin
        Result := _frm.ImageIndex;
    end;
end;

procedure TExodusAXWindow.Set_ImageIndex(value: Integer);
begin
    if (_frm <> nil) then begin
        _frm.ImageIndex := value;
    end;
end;

function TExodusAXWindow.Get_PriorityFlag: WordBool;
begin
    Result := false;
    if (_frm <> nil) then begin
        Result := _frm.PriorityFlag;
    end;

end;

procedure TExodusAXWindow.Set_PriorityFlag(Value: WordBool);
begin
    if (_frm <> nil) then begin
        _frm.PriorityFlag := value;
    end;
end;

procedure TExodusAXWindow.RegisterCallback(
  const callback: IExodusAXWindowCallback);
begin
    if (_frm <> nil) then
    begin
        _frm.callback := callback;
    end;
end;

procedure TExodusAXWindow.UnRegisterCallback;
begin
    if (_frm <> nil) then
    begin
        _frm.callback := nil;
    end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusAXWindow, Class_ExodusAXWindow,
    ciMultiInstance, tmApartment);
end.
