unit COMBookmarkManager;
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
  COMObj,ActiveX, Exodus_TLB, StdVcl, Bookmarks, SysUtils;

type
  TExodusBookmarkManager = class(TAutoObject, IExodusBookmarkManager)
  protected
    function FindBookmark(const JabberID: WideString): WideString; safecall;
    procedure AddBookmark(const JabberID, bmName, Nickname: WideString; AutoJoin,
      UseRegisteredNick: WordBool); safecall;
    procedure RemoveBookmark(const JabberID: WideString); safecall;
    private
      _bookmarks: TBookmarkManager;
    public
      constructor Create(bookmarks: TBookmarkManager);
  end;

implementation
uses
  ComServ, XMLTag;

{-----------------------------------------------}
constructor TExodusBookmarkManager.Create(bookmarks: TBookmarkManager);
begin
  _bookmarks := bookmarks;
end;

{----------------------------------------------}
procedure TExodusBookmarkManager.AddBookmark(const JabberID, bmName,
  Nickname: WideString; AutoJoin, UseRegisteredNick: WordBool);
var
  i: integer;
begin
  i := _bookmarks.IndexOf(JabberID);
  if ( i >= 0 ) then
    exit;
  _bookmarks.AddBookmark(JabberID, bmName, Nickname, autojoin, UseRegisteredNick);
end;

{-----------------------------------------------}
procedure TExodusBookmarkManager.RemoveBookmark(const JabberID: WideString);
begin
  _bookmarks.RemoveBookmark(JabberID);
end;

{------------------------------------------------}
function TExodusBookmarkManager.FindBookmark(const JabberID: WideString): WideString;
var
  bmTag: TXMLTag;
begin
   bmTag := _bookmarks.FindBookmark(JabberID);
   if ( bmTag <> nil ) then
      Result := bmTag.XML
   else
      Result := '';
end;

{-------------------------------------}

initialization
  TAutoObjectFactory.Create(ComServer, TExodusBookmarkManager, CLASS_ExodusBookmarkManager,
    ciMultiInstance, tmApartment);

end.
