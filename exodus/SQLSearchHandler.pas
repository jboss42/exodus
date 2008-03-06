unit SQLSearchHandler;

interface

uses
    ComObj, ActiveX, Exodus_TLB,
    StdVcl, Unicode;

type
    TSQLSearchHandler = class(TAutoObject, IExodusHistorySearchHandler)
        private
            // Variables
            _SearchTypes: TWidestringList;
            handlerID: integer;

            // Methods

        protected
            // Variables

            // Methods

        public
            // Variables

            // Methods
            constructor Create();
            destructor Destroy();

            // IExodusHistorySearchHandler inteface
            function NewSearch(const SearchParameters: IExodusHistorySearch): WordBool; safecall;
            procedure CancelSearch(const SearchID: WideString); safecall;
            function Get_SearchTypeCount: Integer; safecall;
            function GetSearchType(index: Integer): WideString; safecall;

            // Properties
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ExSession, ComServ, sysUtils;

{---------------------------------------}
constructor TSQLSearchHandler.Create();
begin
    _SearchTypes := TWidestringList.Create();
    _SearchTypes.Add('chat history');
    _SearchTypes.Add('groupchat history');

    handlerID := HistorySearchManager.RegisterSearchHandler(Self);
end;
{---------------------------------------}
destructor TSQLSearchHandler.Destroy();
begin
    HistorySearchManager.UnRegisterSearchHandler(handlerID);

    _SearchTypes.Clear();
    _SearchTypes.Free();
end;

{---------------------------------------}
function TSQLSearchHandler.NewSearch(const SearchParameters: IExodusHistorySearch): WordBool;
begin

end;

{---------------------------------------}
procedure TSQLSearchHandler.CancelSearch(const SearchID: WideString);
begin

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

initialization
  TAutoObjectFactory.Create(ComServer, TSQLSearchHandler, Class_ExodusHistorySQLSearchHandler,
    ciMultiInstance, tmApartment);


end.
