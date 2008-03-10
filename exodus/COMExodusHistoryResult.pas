unit COMExodusHistoryResult;

{$WARN SYMBOL_PLATFORM OFF}
{
    Copyright 2008, Estate of Peter Millard

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
    ComObj,
    ActiveX,
    Exodus_TLB,
    StdVcl,
    Unicode;

type
  TExodusHistoryResult = class(TAutoObject, IExodusHistoryResult)
  private
    // Variables
    _processing: boolean;
    _ResultList: TWidestringList;

    // Methods

  protected
    // Variables

    // Methods

  public
    // Variables

    // Methods
    constructor Create();
    destructor Destroy();

    // IExodusHistoryResult Interface
    function Get_ResultCount: Integer; safecall;
    function Get_Processing: WordBool; safecall;
    procedure OnResultItem(const SearchID: WideString; const Item: IExodusLogMsg); safecall;
    function GetResult(index: Integer): IExodusLogMsg; safecall;
    procedure Set_Processing(Value: WordBool); safecall;
    property ResultCount: Integer read Get_ResultCount;
    property Processing: WordBool read Get_Processing write Set_Processing;

	// Properties
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ComServ,
    sysUtils,
    JabberMsg,
    ComLogMsg,
    JabberUtils;

{---------------------------------------}
constructor TExodusHistoryResult.Create();
begin
    inherited;

    _ResultList := TWidestringList.Create();
    _processing := false;
end;

{---------------------------------------}
destructor TExodusHistoryResult.Destroy();
var
    i: integer;
    msg: TJabberMessage;
begin
    for i := 0 to _ResultList.Count - 1 do begin
        msg := TJabberMessage(_ResultList.Objects[i]);
        msg.Free();
        _ResultList.Delete(i);
    end;

    _ResultList.Free();

    inherited;
end;

{---------------------------------------}
function TExodusHistoryResult.Get_Processing: WordBool;
begin
    Result := _processing;
end;

{---------------------------------------}
function TExodusHistoryResult.Get_ResultCount: Integer;
begin
    Result := _ResultList.Count;
end;

{---------------------------------------}
function TExodusHistoryResult.GetResult(index: Integer): IExodusLogMsg;
begin
    Result := nil;
    if (index < 0) then exit;
    if (index >= _ResultList.Count) then exit;

    Result := TExodusLogMsg.Create(TJabberMessage(_ResultList.Objects[index]));
end;

{---------------------------------------}
procedure TExodusHistoryResult.OnResultItem(const SearchID: WideString; const Item: IExodusLogMsg);
var
    msg: TJabberMessage;
begin
    if (Item = nil) then begin
        // Got a nil so that is the signal to end processing.
        _processing := false;
    end
    else begin
        msg := TJabberMessage.Create();

        msg.ToJID := Item.ToJid;
        msg.FromJID := Item.FromJid;
        msg.MsgType := Item.MsgType;
        msg.ID := Item.ID;
        msg.Nick := Item.Nick;
        msg.Body := Item.Body;
        msg.Thread := Item.Thread;
        msg.Subject := Item.Subject;
        msg.Time := JabberToDateTime(Item.Timestamp);
        if (Item.Direction = LOG_MESSAGE_DIRECTION_OUT) then begin
            msg.isMe := true;
        end
        else begin
            msg.isMe := false;
        end;
        msg.XML := Item.XML;

        _ResultList.AddObject('', msg);
    end;
end;

{---------------------------------------}
procedure TExodusHistoryResult.Set_Processing(Value: WordBool);
begin
    _processing := value;
end;




initialization
  TAutoObjectFactory.Create(ComServer, TExodusHistoryResult, Class_ExodusHistoryResult,
    ciMultiInstance, tmApartment);

end.
