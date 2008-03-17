unit SQLSearchHandler;
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
    Unicode,
    JabberMsg;

type
    TSQLSearchHandler = class(TAutoObject, IExodusHistorySearchHandler)
        private
            // Variables
            _SearchTypes: TWidestringList;
            _CurrentSearches: TWidestringList;
            _handlerID: integer;

            // Methods
            function GenerateSQLSearchString(SearchParameters: IExodusHistorySearch): Widestring;

        protected
            // Variables

            // Methods

        public
            // Variables

            // Methods
            constructor Create();
            destructor Destroy();

            procedure OnResult(SearchID: widestring; msg: TJabberMessage);

            // IExodusHistorySearchHandler inteface
            function NewSearch(const SearchParameters: IExodusHistorySearch): WordBool; safecall;
            procedure CancelSearch(const SearchID: WideString); safecall;
            function Get_SearchTypeCount: Integer; safecall;
            function GetSearchType(index: Integer): WideString; safecall;

            // Properties
    end;

const
    SQLSEARCH_CHAT = 'chat history';
    SQLSEARCH_ROOM = 'groupchat history';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ExSession,
    ComServ,
    sysUtils,
    SQLLogger,
    COMLogMsg,
    SQLSearchThread,
    SQLUtils;

{---------------------------------------}
constructor TSQLSearchHandler.Create();
begin
    _SearchTypes := TWidestringList.Create();
    _SearchTypes.Add(SQLSEARCH_CHAT);
    _SearchTypes.Add(SQLSEARCH_ROOM);

    _CurrentSearches := TWidestringList.Create();

    _handlerID := HistorySearchManager.RegisterSearchHandler(Self);
end;
{---------------------------------------}
destructor TSQLSearchHandler.Destroy();
var
    i: integer;
    thread: TSQLSearchThread;
begin
    HistorySearchManager.UnRegisterSearchHandler(_handlerID);

    _SearchTypes.Clear();
    for i := _CurrentSearches.Count - 1 downto 0 do begin
        thread := TSQLSearchThread(_CurrentSearches.Objects[i]);
        try
            thread.Terminate();
        except
        end;

        _CurrentSearches.Delete(i);
    end;

    _SearchTypes.Free();
    _CurrentSearches.Free();
end;

{---------------------------------------}
function TSQLSearchHandler.NewSearch(const SearchParameters: IExodusHistorySearch): WordBool;
var
    searchThread: TSQLSearchThread;
begin
    searchThread := TSQLSearchThread.Create();
    searchThread.SearchID := SearchParameters.SearchID;
    searchThread.DataStore := DataStore;
    searchThread.SQLStatement := GenerateSQLSearchString(SearchParameters);
    searchThread.SetCallback(Self.OnResult);
    searchThread.SetTable(CreateCOMObject(CLASS_ExodusDataTable) as IExodusDataTable);

    _CurrentSearches.AddObject(searchThread.SearchID, SearchThread);

    searchThread.Resume();

    Result := true; // Always want to participate in search
end;

{---------------------------------------}
procedure TSQLSearchHandler.CancelSearch(const SearchID: WideString);
var
    i: integer;
    thread: TSQLSearchThread;
begin
    if (_CurrentSearches.Find(SearchID, i)) then begin
        try
            thread := TSQLSearchThread(_CurrentSearches.Objects[i]);
            thread.Terminate();
        except
        end;
    end;
end;

{---------------------------------------}
function TSQLSearchHandler.Get_SearchTypeCount: Integer;
begin
    Result := _SearchTypes.Count;
end;

{---------------------------------------}
function TSQLSearchHandler.GetSearchType(index: Integer): WideString;
begin
    Result := '';
    if (index < 0) then exit;
    if (index >= _SearchTypes.Count) then exit;

    Result := _SearchTypes[index];
end;

{---------------------------------------}
function TSQLSearchHandler.GenerateSQLSearchString(SearchParameters: IExodusHistorySearch): Widestring;
var
    i: integer;
    mindate: integer;
    maxdate: integer;
    exactMatch: boolean;
begin
    // SELECT part
    Result := 'SELECT * ';

    // FROM part
    Result := Result +
              'FROM ' +
              MESSAGES_TABLE;

    // WHERE part
    mindate := Trunc(SearchParameters.minDate);
    maxdate := Trunc(SearchParameters.maxDate);
    Result := Result +
              ' WHERE date > ' +
              IntToStr(mindate) +
              ' AND date < ' +
              IntToStr(maxdate);

    if (SearchParameters.JIDCount > 0) then begin
        Result := Result +
                  ' AND (';
        for i := 0 to SearchParameters.JIDCount - 1 do begin
            Result := Result +
                      'jid="' +
                      str2sql(UTF8Encode(SearchParameters.GetJID(i))) +
                      '"';
            if (i < (SearchParameters.JIDCount - 1)) then begin
                Result := Result +
                          ' OR ';
            end;
        end;
        Result := Result +
                  ')';
    end;

    if (SearchParameters.KeywordCount > 0) then begin
        exactMatch := SearchParameters.ExactKeywordMatch;

        Result := Result +
                  ' AND (';
        for i := 0 to SearchParameters.KeywordCount - 1 do begin
            Result := Result +
                      'body LIKE "';

            if (not exactMatch) then
                Result := Result + '%';

            Result := Result +
                      str2sql(UTF8Encode(SearchParameters.GetKeyword(i)));

            if (not exactMatch) then
                Result := Result + '%';

            Result := Result +
                      '"';

            if (i < (SearchParameters.KeywordCount -1)) then begin
                Result := Result +
                          ' OR ';
            end;
        end;
        Result := Result +
                  ')';
    end;

    // GROUP BY part

    // ORDER BY part
    Result := Result +
              ' ORDER BY ' +
              'date, time';

    // End of SQL Statement
    Result := Result +
             ';';
end;

{---------------------------------------}
procedure TSQLSearchHandler.OnResult(SearchID: widestring; msg: TJabberMessage);
var
    i: integer;
    m: TExodusLogMsg;
begin
    if (SearchID = '') then exit;

    if (msg = nil) then begin
        // End of result set
        HistorySearchManager.HandlerResult(_handlerID, SearchID, nil);
        if (_currentSearches.Find(SearchID, i)) then begin
            // Remove search from search queue.
            // Do NOT free the thread object here.  It will self
            // delete.  If we try to clean it up, we deadlock.
            // Deleteing the search from the list will remove any reference
            // to it, so we will not try to access a deleted object.
            _CurrentSearches.Delete(i);
        end;
    end
    else begin
        // Send the result set on to the Search Manager
        m := TExodusLogMsg.Create(msg);
        HistorySearchManager.HandlerResult(_handlerID, SearchID, m);
        m.Free();
    end;
end;



initialization
  TAutoObjectFactory.Create(ComServer, TSQLSearchHandler, Class_ExodusHistorySQLSearchHandler,
    ciMultiInstance, tmApartment);


end.
