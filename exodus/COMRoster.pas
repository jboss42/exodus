unit COMRoster;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, ExodusCOM_TLB, StdVcl;

type
  TExodusRoster = class(TAutoObject, IExodusRoster)
  protected
    function AddItem(const JabberID, Nickname,
      Group: WideString): IExodusRosterItem; safecall;
    function Find(const JabberID: WideString): IExodusRosterItem; safecall;
    procedure AddBookmark(const JabberID, bmType, bmName, Nickname: WideString;
      AutoJoin: WordBool); safecall;
    procedure Fetch; safecall;
    procedure RemoveBookmark(const JabberID: WideString); safecall;
    procedure SaveBookmarks; safecall;
    function Item(Index: Integer): IExodusRosterItem; safecall;
    { Protected declarations }
  end;

implementation

uses ComServ;

function TExodusRoster.AddItem(const JabberID, Nickname,
  Group: WideString): IExodusRosterItem;
begin

end;

function TExodusRoster.Find(const JabberID: WideString): IExodusRosterItem;
begin

end;

procedure TExodusRoster.AddBookmark(const JabberID, bmType, bmName,
  Nickname: WideString; AutoJoin: WordBool);
begin

end;

procedure TExodusRoster.Fetch;
begin

end;

procedure TExodusRoster.RemoveBookmark(const JabberID: WideString);
begin

end;

procedure TExodusRoster.SaveBookmarks;
begin

end;

function TExodusRoster.Item(Index: Integer): IExodusRosterItem;
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusRoster, Class_ExodusRoster,
    ciMultiInstance, tmApartment);
end.
