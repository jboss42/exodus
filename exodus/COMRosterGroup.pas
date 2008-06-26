unit COMRosterGroup;
{
    Copyright 2006, Peter Millard

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
    NodeItem, Roster, ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusRosterGroup = class(TAutoObject, IExodusRosterGroup)
  protected
    function Get_Action: WideString; safecall;
    function Get_AutoExpand: WordBool; safecall;
    function Get_DragSource: WordBool; safecall;
    function Get_DragTarget: WordBool; safecall;
    function Get_KeepEmpty: WordBool; safecall;
    function Get_ShowPresence: WordBool; safecall;
    function Get_SortPriority: Integer; safecall;
    function getText: WideString; safecall;
    procedure Set_Action(const Value: WideString); safecall;
    procedure Set_AutoExpand(Value: WordBool); safecall;
    procedure Set_DragSource(Value: WordBool); safecall;
    procedure Set_DragTarget(Value: WordBool); safecall;
    procedure Set_KeepEmpty(Value: WordBool); safecall;
    procedure Set_ShowPresence(Value: WordBool); safecall;
    procedure Set_SortPriority(Value: Integer); safecall;
    function inGroup(const jid: WideString): WordBool; safecall;
    function isEmpty: WordBool; safecall;
    procedure addJid(const jid: WideString); safecall;
    function getGroup(const group_name: WideString): IExodusRosterGroup;
      safecall;
    procedure removeJid(const jid: WideString); safecall;
    procedure addGroup(const child: IExodusRosterGroup); safecall;
    procedure removeGroup(const child: IExodusRosterGroup); safecall;
    function getRosterItems(Online: WordBool): OleVariant; safecall;
    function Get_FullName: WideString; safecall;
    function Get_NestLevel: Integer; safecall;
    function Get_Online: Integer; safecall;
    function Get_Parent: IExodusRosterGroup; safecall;
    function Get_Total: Integer; safecall;
    function Parts(Index: Integer): WideString; safecall;
    procedure fireChange; safecall;

  private
    _grp: TJabberGroup;

  public
    constructor Create(grp: TJabberGroup);

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    XMLTag, Variants, Classes, Session, JabberID, ComServ;

{---------------------------------------}
constructor TExodusRosterGroup.Create(grp: TJabberGroup);
begin
    // this is just a wrapper for the roster item
    _grp := grp;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_Action: WideString;
begin
    Result := _grp.Action;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_AutoExpand: WordBool;
begin
    Result := _grp.AutoExpand;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_DragSource: WordBool;
begin
    Result := _grp.DragSource;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_DragTarget: WordBool;
begin
    Result := _grp.DragTarget;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_KeepEmpty: WordBool;
begin
    Result := _grp.KeepEmpty;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_ShowPresence: WordBool;
begin
    Result := _grp.ShowPresence;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_SortPriority: Integer;
begin
    Result := _grp.SortPriority;
end;

{---------------------------------------}
function TExodusRosterGroup.getText: WideString;
begin
    Result := _grp.getText();
end;

{---------------------------------------}
procedure TExodusRosterGroup.Set_Action(const Value: WideString);
begin
    _grp.Action := Value;
end;

{---------------------------------------}
procedure TExodusRosterGroup.Set_AutoExpand(Value: WordBool);
begin
    _grp.AutoExpand := Value;
end;

{---------------------------------------}
procedure TExodusRosterGroup.Set_DragSource(Value: WordBool);
begin
    _grp.DragSource := Value;
end;

{---------------------------------------}
procedure TExodusRosterGroup.Set_DragTarget(Value: WordBool);
begin
    _grp.DragTarget := Value;
end;

{---------------------------------------}
procedure TExodusRosterGroup.Set_KeepEmpty(Value: WordBool);
begin
    _grp.KeepEmpty := Value;
end;

{---------------------------------------}
procedure TExodusRosterGroup.Set_ShowPresence(Value: WordBool);
begin
    _grp.ShowPresence := Value;
end;

{---------------------------------------}
procedure TExodusRosterGroup.Set_SortPriority(Value: Integer);
begin
    _grp.SortPriority := Value;
end;

{---------------------------------------}
function TExodusRosterGroup.inGroup(const jid: WideString): WordBool;
begin
    Result := _grp.inGroup(jid);
end;

{---------------------------------------}
function TExodusRosterGroup.isEmpty: WordBool;
begin
    Result := _grp.isEmpty();
end;

{---------------------------------------}
procedure TExodusRosterGroup.addJid(const jid: WideString);
begin
    _grp.AddJid(jid);
end;

{---------------------------------------}
function TExodusRosterGroup.getGroup(
  const group_name: WideString): IExodusRosterGroup;
var
    go: TJabberGroup;
begin
    go := MainSession.Roster.getGroup(group_name);
    if (go <> nil) then
        Result := TExodusRosterGroup.Create(go)
    else
        Result := nil;
end;

{---------------------------------------}
procedure TExodusRosterGroup.removeJid(const jid: WideString);
begin
    _grp.removeJid(jid);
end;

{---------------------------------------}
procedure TExodusRosterGroup.addGroup(const child: IExodusRosterGroup);
var
    go: TJabberGroup;
begin
    go := MainSession.Roster.getGroup(child.FullName);
    if (go <> nil) then
        _grp.addGroup(go);
end;

{---------------------------------------}
procedure TExodusRosterGroup.removeGroup(const child: IExodusRosterGroup);
var
    go: TJabberGroup;
begin
    go := _grp.getGroup(child.FullName);
    if (go <> nil) then
        _grp.removeGroup(go);
end;

{---------------------------------------}
function TExodusRosterGroup.getRosterItems(Online: WordBool): OleVariant;
var
    i: integer;
    list: TList;
    va: Variant;
    ritem: TJabberRosterItem;
begin
    list := TList.Create();
    _grp.getRosterItems(list, online);

    va := VarArrayCreate([0, list.count], varOleStr);
    for i := 0 to list.count - 1 do begin
        ritem := TJabberRosteritem(list[i]);
        VarArrayPut(va, ritem.jid.full, i);
    end;
    list.Free();

    Result := va;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_FullName: WideString;
begin
    Result := _grp.FullName;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_NestLevel: Integer;
begin
    Result := _grp.NestLevel;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_Online: Integer;
begin
    Result := _grp.Online;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_Parent: IExodusRosterGroup;
begin
    if (_grp.Parent <> nil) then
        Result := TExodusRosterGroup.Create(_grp.Parent)
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_Total: Integer;
begin
    Result := _grp.Total;
end;

{---------------------------------------}
function TExodusRosterGroup.Parts(Index: Integer): WideString;
begin
    Result := _grp.Parts[Index];
end;

{---------------------------------------}
procedure TExodusRosterGroup.fireChange;
var
    x: TXMLTag;
begin
    x := TXMLTag.Create('group');
    x.setAttribute('name', _grp.FullName);
    MainSession.FireEvent('/roster/group', x, TJabberRosterItem(nil));
    x.Free();
end;

end.
