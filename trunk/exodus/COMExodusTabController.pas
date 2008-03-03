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
unit COMExodusTabController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl, TntComCtrls, Unicode, Contnrs;

type
  TExodusTabController = class(TAutoObject, IExodusTabController)
  protected
      function AddTab(const activeX_guid: WideString): IExodusTab; safecall;
      function Get_Tab(Index: Integer): IExodusTab; safecall;
      function Get_TabCount: Integer; safecall;
      procedure ActivateTab(Index: Integer); safecall;
      procedure RemoveTab(Index: Integer); safecall;
      procedure Clear; safecall;
      function GetTabByUID(const uid: WideString): IExodusTab; safecall;
      function GetTabIndexByUID(const uid: WideString): Integer; safecall;
  private
      _Tabs: TObjectList;
  public
      constructor Create();
      destructor Destroy; override;
  end;

implementation

uses ComServ, COMExodusTab, COMExodusTabWrapper;

{---------------------------------------}
constructor TExodusTabController.Create();
begin
    _Tabs := TObjectList.Create();
    _Tabs.OwnsObjects := true;
end;

{---------------------------------------}
destructor TExodusTabController.Destroy();
begin
    _Tabs.Free;
end;

{---------------------------------------}
function TExodusTabController.AddTab(
  const activeX_guid: WideString): IExodusTab;
var
    Tab: TExodusTabWrapper;
begin
   Tab := TExodusTabWrapper.Create(activeX_guid);
   _Tabs.Add(tab);
   Result := Tab.ExodusTab;
end;

{---------------------------------------}
function TExodusTabController.Get_Tab(Index: Integer): IExodusTab;
begin
   Result := TExodusTabWrapper(_Tabs[Index]).ExodusTab;
end;

{---------------------------------------}
function TExodusTabController.Get_TabCount: Integer;
begin
    Result := _Tabs.Count;
end;

{---------------------------------------}
procedure TExodusTabController.ActivateTab(Index: Integer);
begin
   Get_Tab(Index).Activate;
end;

{---------------------------------------}
procedure TExodusTabController.RemoveTab(Index: Integer);
var
   Tab: TExodusTabWrapper;
begin
   _Tabs.Delete(Index);
end;

{---------------------------------------}
procedure TExodusTabController.Clear;
begin
  _Tabs.Clear();
end;

//function TExodusTabController.Get_TabByUid(const uid: WideString): IExodusTab;
//var
//    i: Integer;
//begin
//    Result := nil;
//    for i := 0 to _Tabs.Count - 1 do
//    begin
//       if (Get_Tab(i).UID = uid) then
//       begin
//          Result := Get_Tab(i);
//          break;
//       end;
//    end;
//end;

function TExodusTabController.GetTabByUID(const uid: WideString): IExodusTab;
var
    i: Integer;
begin
    Result := nil;
    for i := 0 to _Tabs.Count - 1 do
    begin
       if (Get_Tab(i).UID = uid) then
       begin
          Result := Get_Tab(i);
          break;
       end;
    end;
end;

{---------------------------------------}
function TExodusTabController.GetTabIndexByUID(const uid: WideString): Integer;
var
    i: Integer;
begin
    Result := -1;
    for i := 0 to _Tabs.Count - 1 do
    begin
       if (Get_Tab(i).UID = uid) then
       begin
          Result := i;
          break;
       end;
    end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusTabController, Class_ExodusTabController,
    ciMultiInstance, tmApartment);
end.
