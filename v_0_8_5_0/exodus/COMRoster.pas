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
    procedure AddItem(const JabberID, nickname, Group: WideString;
      Subscribe: WordBool); safecall;
    function Find(const JabberID: WideString): IExodusRosterItem; safecall;
    procedure AddBookmark(const JabberID, bmType, bmName, Nickname: WideString;
      AutoJoin: WordBool); safecall;
    procedure Fetch; safecall;
    procedure RemoveBookmark(const JabberID: WideString); safecall;
    procedure SaveBookmarks; safecall;
    function Item(Index: Integer): IExodusRosterItem; safecall;
    function Count: Integer; safecall;
    { Protected declarations }
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    COMRosterItem, Roster, JabberID, Session, Jabber1, ComServ;

{---------------------------------------}
procedure TExodusRoster.AddItem(const JabberID, nickname,
  Group: WideString; Subscribe: WordBool);
begin
    MainSession.roster.AddItem(JabberID, Nickname, Group, Subscribe);
end;

{---------------------------------------}
function TExodusRoster.Find(const JabberID: WideString): IExodusRosterItem;
var
    ri: TJabberRosterItem;
begin
    // xxx: Should we be spinning up new COM objects for every item??
    // they should go away via RefCounting.
    ri := MainSession.roster.Find(JabberID);
    if (ri <> nil) then
        Result := TExodusRosterItem.Create(ri)
    else
        Result := nil;
end;

{---------------------------------------}
procedure TExodusRoster.AddBookmark(const JabberID, bmType, bmName,
  Nickname: WideString; AutoJoin: WordBool);
var
    tmpjid: TJabberID;
    bm: TJabberBookmark;
begin
    bm := TJabberBookmark.Create(nil);
    tmpjid := TJabberID.Create(JabberID);
    bm.jid := tmpjid;
    bm.bmType := bmType;
    bm.bmName := bmName;
    bm.nick := Nickname;
    bm.autoJoin := AutoJoin;
    MainSession.roster.AddBookmark(JabberID, bm);
end;

{---------------------------------------}
procedure TExodusRoster.Fetch;
begin
    MainSession.roster.Fetch();
end;

{---------------------------------------}
procedure TExodusRoster.RemoveBookmark(const JabberID: WideString);
begin
    MainSession.roster.RemoveBookmark(JabberID);
end;

{---------------------------------------}
procedure TExodusRoster.SaveBookmarks;
begin
    MainSession.roster.SaveBookmarks();
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

function TExodusRoster.Count: Integer;
begin
    Result := MainSession.roster.Count;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusRoster, Class_ExodusRoster,
    ciMultiInstance, tmApartment);
end.
