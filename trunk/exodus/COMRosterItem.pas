unit COMRosterItem;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, ExodusCOM_TLB, StdVcl;

type
  TExodusRosterItem = class(TAutoObject, IExodusRosterItem)
  protected
    function Get_JabberID: WideString; safecall;
    procedure Set_JabberID(const Value: WideString); safecall;
    function Get_Subscription: WideString; safecall;
    procedure Set_Subscription(const Value: WideString); safecall;
    function Get_Ask: WideString; safecall;
    function Get_GroupCount: Integer; safecall;
    procedure Group(Index: Integer; const Value: WideString); safecall;
    function Get_Nickname: WideString; safecall;
    function Get_RawNickname: WideString; safecall;
    function XML: WideString; safecall;
    procedure Remove; safecall;
    procedure Set_Nickname(const Value: WideString); safecall;
    procedure Update; safecall;
    { Protected declarations }
  end;

implementation

uses ComServ;

function TExodusRosterItem.Get_JabberID: WideString;
begin

end;

procedure TExodusRosterItem.Set_JabberID(const Value: WideString);
begin

end;

function TExodusRosterItem.Get_Subscription: WideString;
begin

end;

procedure TExodusRosterItem.Set_Subscription(const Value: WideString);
begin

end;

function TExodusRosterItem.Get_Ask: WideString;
begin

end;

function TExodusRosterItem.Get_GroupCount: Integer;
begin

end;

procedure TExodusRosterItem.Group(Index: Integer; const Value: WideString);
begin

end;

function TExodusRosterItem.Get_Nickname: WideString;
begin

end;

function TExodusRosterItem.Get_RawNickname: WideString;
begin

end;

function TExodusRosterItem.XML: WideString;
begin

end;

procedure TExodusRosterItem.Remove;
begin

end;

procedure TExodusRosterItem.Set_Nickname(const Value: WideString);
begin

end;

procedure TExodusRosterItem.Update;
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusRosterItem, Class_ExodusRosterItem,
    ciMultiInstance, tmApartment);
end.
