unit COMExodusDataStore;

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
    StdVcl, SQLiteTable3;

type
  TExodusDataStore = class(TAutoObject, IExodusDataStore)
  protected

  private
    // Variables
    _DBHandle: TSQLiteDatabase;
    _DBFileName: Widestring;

    // Methods
    function _OpenDBFile(filename: widestring): boolean;
    procedure _CloseDBFile();

  public
    // IExodusDataStore Interface
    function ExecSQL(const SQLStatement: WideString): WordBool; safecall;
    procedure GetTable(const SQLStatement: WideString; var ResultTable: IExodusDataTable); safecall;

    constructor Create(filename: widestring);
    destructor Destroy();

    function CheckForTableExistence(tablename: widestring): boolean;

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ComServ, sysUtils, COMExodusDataTable;

{---------------------------------------}
constructor TExodusDataStore.Create(filename: widestring);
begin
    inherited Create;

    _OpenDBFile(filename);
end;

{---------------------------------------}
destructor TExodusDataStore.Destroy;
begin
    _CloseDBFile();

    inherited;
end;

{---------------------------------------}
function TExodusDataStore.ExecSQL(const SQLStatement: WideString): WordBool;
begin
    Result := false;
    if (_DBHandle = nil) then exit;
    if (SQLStatement = '') then exit;

    Result := true;
    try
        _DBHandle.ExecSQL(SQLStatement);
    except
        on e: ESqliteException do begin
            Result := false;
        end;
    end;
end;

{---------------------------------------}
procedure TExodusDataStore.GetTable(const SQLStatement: WideString; var ResultTable: IExodusDataTable);
var
    sqlTable: TSQLiteTable;
begin
    if (_DBHandle = nil) then exit;
    if (SQLStatement = '') then exit;
    if (ResultTable = nil) then exit;

    try
        sqlTable := _DBHandle.GetTable(SQLStatement);

        if (sqlTable <> nil) then begin
            ExodusDataTableMap.AddTable(ResultTable.SQLTableID, sqlTable);
        end;
    except
    end;
end;

{---------------------------------------}
function TExodusDataStore._OpenDBFile(filename: widestring): boolean;
begin
    Result := false;
    if (filename = '') then exit;

    if (_DBHandle <> nil) then begin
        _CloseDBFile();
    end;

    // Try to open/create the file as SQLite DB
    _DBHandle := TSQLiteDatabase.Create(filename); // Raises Exception on I/O error

    Result := true;
end;

{---------------------------------------}
function TExodusDataStore.CheckForTableExistence(tablename: widestring): boolean;
begin
    Result := false;
    if (_DBHandle = nil) then exit;

    Result := _DBHandle.TableExists(tablename);
end;

{---------------------------------------}
procedure TExodusDataStore._CloseDBFile();
begin
    if (_DBHandle = nil) then exit;

    _DBHandle.Free();
    _DBHandle := nil;
end;






initialization
  TAutoObjectFactory.Create(ComServer, TExodusDataStore, Class_ExodusDataStore,
    ciMultiInstance, tmApartment);

end.
