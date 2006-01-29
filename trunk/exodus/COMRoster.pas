unit COMRoster;
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

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, ExodusCOM_TLB, StdVcl;

type
  TExodusRoster = class(TAutoObject, IExodusRoster)
  protected
    function AddItem(const JabberID, nickname, Group: WideString;
      Subscribe: WordBool): IExodusRosterItem; safecall;
    function Find(const JabberID: WideString): IExodusRosterItem; safecall;
    procedure Fetch; safecall;
    function Item(Index: Integer): IExodusRosterItem; safecall;
    function Count: Integer; safecall;
    function addGroup(const grp: WideString): IExodusRosterGroup; safecall;
    function Get_GroupsCount: Integer; safecall;
    function getGroup(const grp: WideString): IExodusRosterGroup; safecall;
    function Groups(Index: Integer): IExodusRosterGroup; safecall;
    function Items(Index: Integer): IExodusRosterItem; safecall;
    procedure removeGroup(const grp: IExodusRosterGroup); safecall;
    procedure removeItem(const Item: IExodusRosterItem); safecall;
    { Protected declarations }
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    COMRosterGroup, 
    COMRosterItem, NodeItem, Roster, JabberID, Session, Jabber1, ComServ;

{---------------------------------------}
function TExodusRoster.AddItem(const JabberID, nickname, Group: WideString;
  Subscribe: WordBool): IExodusRosterItem;
var
    ri: TJabberRosterItem;
begin
    MainSession.roster.AddItem(JabberID, Nickname, Group, Subscribe);
    ri := MainSession.Roster.Find(JabberID);
    if (ri <> nil) then
        Result := TExodusRosterItem.Create(ri)
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusRoster.Find(const JabberID: WideString): IExodusRosterItem;
var
    ri: TJabberRosterItem;
begin
    // Should we be spinning up new COM objects for every item??
    // they should go away via RefCounting.
    ri := MainSession.roster.Find(JabberID);
    if (ri <> nil) then
        Result := TExodusRosterItem.Create(ri)
    else
        Result := nil;
end;

{---------------------------------------}
procedure TExodusRoster.Fetch;
begin
    MainSession.roster.Fetch();
end;

{---------------------------------------}
function TExodusRoster.Item(Index: Integer): IExodusRosterItem;
var
    ri: TJabberRosterItem;
begin
    if ((Index >= 0) and (Index < MainSession.roster.Count)) then
        ri := MainSession.roster.Items[Index]
    else
        ri := nil;

    if (ri <> nil) then
        Result := TExodusRosterItem.Create(ri)
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusRoster.Count: Integer;
begin
    Result := MainSession.roster.Count;
end;

{---------------------------------------}
function TExodusRoster.addGroup(const grp: WideString): IExodusRosterGroup;
var
    go: TJabberGroup;
begin
    go := MainSession.Roster.addGroup(grp);
    Result := TExodusRosterGroup.Create(go);
end;

{---------------------------------------}
function TExodusRoster.Get_GroupsCount: Integer;
begin
    Result := MainSession.Roster.GroupsCount;
end;

{---------------------------------------}
function TExodusRoster.getGroup(const grp: WideString): IExodusRosterGroup;
var
    go: TJabberGroup;
begin
    go := MainSession.Roster.getGroup(grp);
    if (go <> nil) then
        Result := TExodusRosterGroup.Create(go)
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusRoster.Groups(Index: Integer): IExodusRosterGroup;
var
    go: TJabberGroup;
begin
    go := MainSession.Roster.Groups[Index];
    Result := TExodusRosterGroup.Create(go);
end;

{---------------------------------------}
function TExodusRoster.Items(Index: Integer): IExodusRosterItem;
var
    ri: TJabberRosterItem;
begin
    ri := MainSession.Roster.Items[index];
    Result := TExodusRosterItem.Create(ri);
end;

{---------------------------------------}
procedure TExodusRoster.removeGroup(const grp: IExodusRosterGroup);
var
    go: TJabberGroup;
begin
    go := MainSession.Roster.getGroup(grp.FullName);
    if (go <> nil) then
        MainSession.roster.removeGroup(go);
end;

{---------------------------------------}
procedure TExodusRoster.removeItem(const Item: IExodusRosterItem);
begin
    MainSession.Roster.RemoveItem(Item.JabberID);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusRoster, Class_ExodusRoster,
    ciMultiInstance, tmApartment);
end.
