unit COMExodusHistorySearchManager;

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
    ComObj, ActiveX, Exodus_TLB,
    StdVcl, Unicode;

type
  TSearchHandlerWrapper = class(TObject)
      private
        // Variables
        _Handler: IExodusHistorySearchHandler;
        _cb_id: integer;

        // Methods

      protected
        // Variables

        // Methods

      public
        // Variables

        // Methods

        // Properties
        property Handler: IExodusHistorySearchHandler read _Handler write _Handler;
        property cb_id: integer read _cb_id write _cb_id;
  end;

  TSearchType = class(TObject)
      private
        // Variables
        _Handlers: TWidestringList

        // Methods

      protected
        // Variables

        // Methods

      public
        // Variables

        // Methods
        constructor Create();
        destructor Destroy();

        // Properties
        property Handlers: TWidestringList read _Handlers write _Handlers;
  end;

  TExodusHistorySearchManager = class(TAutoObject, IExodusHistorySearchManager)
      private
        // Variables
        _HandlerList: TWidestringList;
        _SearchTypes: TWidestringList;
        _CurrentSearches: TWidestringList;

        // Methods

      protected
        // Variables

        // Methods

      public
        // Variables

        // Methods
        constructor Create();
        destructor Destroy();

        // IExodusHistorySearchManager Interface
        function Get_SearchTypeCount: Integer; safecall;
        function GetSearchType(index: Integer): WideString; safecall;
        function NewSearch(const SearchParams: IExodusHistorySearch; const SearchResult: IExodusHistoryResult): WordBool; safecall;
        function RegisterSearchHandler(const Handler: IExodusHistorySearchHandler): Integer; safecall;
        procedure CancelSearch(const SearchID: WideString); safecall;
        procedure UnRegisterSearchHandler(HandlerID: Integer); safecall;

        // Properties
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ComServ, sysUtils;

var
    _hid: longint = 0;

{---------------------------------------}
constructor TSearchType.Create();
begin
    inherited;

    _Handlers := TWidestringList.Create();
end;

{---------------------------------------}
destructor TSearchType.Destroy();
var
    i: integer;
begin
    _Handlers.Clear();

    _Handlers.Free();

    inherited;
end;
{---------------------------------------}
constructor TExodusHistorySearchManager.Create();
begin
    inherited;

    _HandlerList := TWidestringList.Create();
    _SearchTypes := TWidestringList.Create();
    _CurrentSearches := TWidestringList.Create();
end;

{---------------------------------------}
destructor TExodusHistorySearchManager.Destroy();
begin
    _HandlerList.Clear();
    _SearchTypes.Clear();
    _CurrentSearches.Clear();

    _HandlerList.Free();
    _SearchTypes.Free();
    _CurrentSearches.Free();

    inherited;
end;

{---------------------------------------}
function TExodusHistorySearchManager.Get_SearchTypeCount: Integer;
begin
    Result := _SearchTypes.Count;
end;

{---------------------------------------}
function TExodusHistorySearchManager.GetSearchType(index: Integer): WideString;
begin
    Result := '';
    if (index < 0) then exit;
    if (index >= _SearchTypes.Count) then exit;

    Result := _SearchTypes[index];
end;

{---------------------------------------}
function TExodusHistorySearchManager.NewSearch(const SearchParams: IExodusHistorySearch; const SearchResult: IExodusHistoryResult): WordBool;
begin

end;

{---------------------------------------}
function TExodusHistorySearchManager.RegisterSearchHandler(const Handler: IExodusHistorySearchHandler): Integer;
var
    handlerwrapper: TSearchHandlerWrapper;
    i: Integer;
    j: integer;
    tmp: Widestring;
    searchtype: TSearchType;
    searchtypeexists: boolean;
begin
    Result := _hid;

    handlerwrapper := TSearchHandlerWrapper.Create();
    handlerwrapper.Handler := Handler;
    handlerwrapper.cb_id := _hid;

    for i := 0 to Handler.SearchTypeCount - 1 do begin
        tmp := LowerCase(Handler.GetSearchType(i));
        searchtypeexists := false;
        for j := 0 to _SearchTypes.Count - 1 do begin
            if (_SearchTypes[i] = tmp) then begin
                searchtype := TSearchType(_SearchTypes.Objects[i]);
                searchtype.Handlers.Add(IntToStr(handlerwrapper.cb_id));
                searchtypeexists := true;
                break;
            end;
        end;
        if (not searchtypeexists) then begin
            searchtype := TSearchType.Create();
            searchtype.Handlers.Add(IntToStr(handlerwrapper.cb_id));
            _SearchTypes.AddObject(tmp, searchtype);
        end;
    end;

    _HandlerList.AddObject(IntToStr(_hid), handlerwrapper);
    Inc(_hid);
end;

{---------------------------------------}
procedure TExodusHistorySearchManager.CancelSearch(const SearchID: WideString);
begin

end;

{---------------------------------------}
procedure TExodusHistorySearchManager.UnRegisterSearchHandler(HandlerID: Integer);
var
    i: integer;
    j: integer;
    handlerwrapper: TSearchHandlerWrapper;
    searchtype: TSearchType;
begin
//???dda    for i := 0 to _HandlerList.Count - 1 do begin
    if (_HandlerList.Find(IntToStr(HandlerID), i)) then begin
        handlerwrapper := TSearchHandlerWrapper(_HandlerList.Objects[i]);
        if (handlerwrapper.cb_id = HandlerID) then begin
            _HandlerList.Delete(i);
        end;
    end;

    for i := 0 to _SearchTypes.Count - 1 do begin
        searchtype := TSearchType(_SearchTypes.Objects[i]);
        for j := 0 to searchtype.Handlers.Count - 1 do begin
            if (searchtype.Handlers[j] = IntToStr(HandlerID)) then begin
                searchtype.Handlers.Delete(j);
                break;
            end;
        end;
        if (searchtype.Handlers.Count <= 0) then begin
            searchtype.Free();
            _SearchTypes.Delete(i);
        end;
    end;

end;






initialization
  TAutoObjectFactory.Create(ComServer, TExodusHistorySearchManager, Class_ExodusHistorySearchManager,
    ciMultiInstance, tmApartment);

end.
