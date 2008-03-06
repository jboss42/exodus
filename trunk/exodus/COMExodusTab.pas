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
unit COMExodusTab;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl, PLUGINCONTROLLib_TLB, TntComCtrls;

type
  TExodusTab = class(TAutoObject, IExodusTab)
  protected
      function Get_Caption: WideString; safecall;
      function Get_ImageIndex: Integer; safecall;
      function Get_Name: WideString; safecall;
    function Get_Visible: WordBool; safecall;
      procedure Hide; safecall;
      procedure Set_Caption(const Value: WideString); safecall;
      procedure Set_ImageIndex(Value: Integer); safecall;
      procedure Set_Name(const Value: WideString); safecall;
      procedure Show; safecall;
      procedure Activate; safecall;
      function Get_Handle: Integer; safecall;
      function Get_UID: WideString; safecall;
      function Get_Height: Integer; safecall;
      function Get_Width: Integer; safecall;
      function Get_Descrption: WideString; safecall;
      procedure Set_Descrption(const Value: WideString); safecall;
  private
      _AxControl: TAXControl;
      _Page: TTntTabSheet;
      _UID:  WideString;
      _Name: WideString;
      _Desc: WideString;
  public
      constructor Create(ActiveX_GUID: WideString);
      destructor Destroy; override;
  end;

implementation

uses ComServ, RosterForm, SysUtils, Session;

{---------------------------------------}
constructor TExodusTab.Create(ActiveX_GUID: WideString);
var
    g: TGUID;
begin
    _AxControl := nil;
    _Page := TTntTabSheet.Create(GetRosterWindow()._PageControl);
    _Page.PageControl :=  GetRosterWindow()._PageControl;
    _Page.Visible := true;
    _UID := ActiveX_GUID;
    if (_UID <> '') then
    begin
        _AxControl := TAXControl.Create(_Page, StringToGuid(_UID));
        _AxControl.Parent := _Page;
    end
    else
    begin
        CreateGUID(g);
        _UID := GUIDToString(g);
    end;
end;

{---------------------------------------}
destructor TExodusTab.Destroy();
begin
    _AxControl.Free;
    _Page.Free;
    inherited;
end;

{---------------------------------------}
function TExodusTab.Get_Caption: WideString;
begin
    Result := _Page.Caption;
end;

{---------------------------------------}
function TExodusTab.Get_ImageIndex: Integer;
begin
   Result := _Page.ImageIndex;
end;

{---------------------------------------}
function TExodusTab.Get_Name: WideString;
begin
    Result := _Name;
end;

{---------------------------------------}
function TExodusTab.Get_Visible: WordBool;
begin
    Result := _Page.TabVisible;
end;

{---------------------------------------}
procedure TExodusTab.Hide;
begin
   _Page.TabVisible := false;
   MainSession.FireEvent('/session/tab/hide', nil);
end;

{---------------------------------------}
procedure TExodusTab.Set_Caption(const Value: WideString);
begin
    _Page.Caption := Value;
end;

{---------------------------------------}
procedure TExodusTab.Set_ImageIndex(Value: Integer);
begin
    _Page.ImageIndex := Value;
end;

procedure TExodusTab.Set_Name(const Value: WideString);
begin
    _Name := Value;
end;

{---------------------------------------}
procedure TExodusTab.Show;
begin
    _Page.TabVisible := true;
    MainSession.FireEvent('/session/tab/show', nil);
end;

{---------------------------------------}
procedure TExodusTab.Activate;
begin
    _Page.SetFocus;
end;

{---------------------------------------}
function TExodusTab.Get_Handle: Integer;
begin
    Result := _Page.Handle;
end;

{---------------------------------------}
function TExodusTab.Get_UID: WideString;
begin
   Result := _UID;
end;

function TExodusTab.Get_Height: Integer;
begin
    Result := _Page.Height;
end;

function TExodusTab.Get_Width: Integer;
begin
   Result := _Page.Width;
end;


function TExodusTab.Get_Descrption: WideString;
begin
    Result := _Desc;
end;

procedure TExodusTab.Set_Descrption(const Value: WideString);
begin
   _Desc := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusTab, Class_ExodusTab,
    ciMultiInstance, tmApartment);
end.
