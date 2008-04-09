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
      function Get_Handle: Integer; safecall;
      function Get_UID: WideString; safecall;
      function Get_Height: Integer; safecall;
      function Get_Width: Integer; safecall;
      function Get_Description: WideString; safecall;
      function Get_AXControl: OleVariant; safecall;
      procedure Set_Description(const value: WideString); safecall;
      function Get_PageIndex: Integer; safecall;
      function Get_TabIndex: Integer; safecall;
      function GetSelectedItems: IExodusItemList; safecall;
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

uses ComServ, RosterForm, SysUtils, Session, Variants, Controls, COMExodusItemList;

{---------------------------------------}
constructor TExodusTab.Create(ActiveX_GUID: WideString);
var
    g: TGUID;
begin
    _AxControl := nil;
    _Page := TTntTabSheet.Create(GetRosterWindow()._PageControl);
    _Page.PageControl :=  GetRosterWindow()._PageControl;
    _Page.TabVisible := true;
    _UID := ActiveX_GUID;
    if (_UID <> '') then
    begin
        _AxControl := TAXControl.Create(_Page, StringToGuid(_UID));
        _AxControl.Parent := _Page;
        _AxControl.Align := alClient;
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


function TExodusTab.Get_Description: WideString;
begin
    Result := _Desc;
end;


function TExodusTab.Get_AXControl: OleVariant;
begin
   Result := unassigned;;
   if (_AXControl <> nil) then
       Result := _AXControl.OleObject;
   
end;

procedure TExodusTab.Set_Description(const value: WideString);
begin
   _Desc := Value;
end;

function TExodusTab.Get_PageIndex: Integer;
begin
    Result := _Page.PageIndex;
end;

function TExodusTab.Get_TabIndex: Integer;
begin
   Result := _Page.TabIndex;
end;

function TExodusTab.GetSelectedItems: IExodusItemList;
var
   Selection: IExodusItemSelection;
begin
   if (VarIsEmpty(Get_AXControl())) then
   begin
     Result := TExodusItemList.Create();
     //GetRosterWindow().GetTreeByTabIndex(Get_PageIndex())
   end
   else
   begin
     try
        Selection := IUnknown(Get_AXControl()) as  IExodusItemSelection;
     except
         on EIntfCastError do begin
             Selection := nil
         end;
     end;
     if (Selection <> nil) then
         Result := Selection.GetSelectedItems();
   end;


end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusTab, Class_ExodusTab,
    ciMultiInstance, tmApartment);
end.
