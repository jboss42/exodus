unit COMBookmarkManager;

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
