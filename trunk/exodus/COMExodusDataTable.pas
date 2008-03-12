unit COMExodusDataTable;

{$WARN SYMBOL_PLATFORM OFF}
{
    Copyright 2006, Peter Millard

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
    StdVcl, SQLiteTable3, sysUtils,
    Unicode;

type
  TExodusDataTableMap = class
  private
    // Variables
    _tablemap: TWidestringList;

    // Methods
    function _FindTable(tableID: widestring): integer;
  protected
    // Variables

    // Methods
  public
    // Variables

    // Methods
    constructor Create();
    destructor Destroy();

    procedure AddTable(tableID: widestring; table: TSQLiteTable);
    function FindTable(tableID: widestring): TSQLiteTable;
    procedure RemoveTable(tableID: widestring);

    // Properties
  end;

  TExodusDataTable = class(TAutoObject, IExodusDataTable)
  private
    // Variables
    _tableID: widestring;

    // Methdods
    function _GetTable(): TSQLiteTable;

    // Properties
    property _table: TSQLiteTable read _GetTable;

  protected
    // Variables

    // Methdods

  public
    // Variables

    // Methdods
    procedure Initialize(); override;
    destructor Destroy(); override;

    // IExodusDataTable Interface
    function Get_CurrentRow: Integer; safecall;
    function Get_ColCount: Integer; safecall;
    function Get_RowCount: Integer; safecall;
    function Get_IsEndOfTable: WordBool; safecall;
    function Get_IsBeginOfTable: WordBool; safecall;
    function IsFieldNULL(Field: Integer): WordBool; safecall;
    function GetFieldByName(const Name: WideString): WideString; safecall;
    function GetCol(Column: Integer): WideString; safecall;
    function GetField(Field: Integer): WideString; safecall;
    function NextRow: WordBool; safecall;
    function PrevRow: WordBool; safecall;
    function FirstRow: WordBool; safecall;
    function LastRow: WordBool; safecall;
    function GetFieldAsInt(Field: Integer): Integer; safecall;
    function GetFieldAsString(Field: Integer): WideString; safecall;
    function GetFieldAsDouble(Field: Integer): Double; safecall;
    function GetFieldIndex(const Field: WideString): Integer; safecall;
    function Get_SQLTableID: WideString; safecall;
    property CurrentRow: Integer read Get_CurrentRow;
    property ColCount: Integer read Get_ColCount;
    property RowCount: Integer read Get_RowCount;
    property IsEndOfTable: WordBool read Get_IsEndOfTable;
    property IsBeginOfTable: WordBool read Get_IsBeginOfTable;
    property SQLTableID: WideString read Get_SQLTableID;

    // Properties

  end;

var
    ExodusDataTableMap: TExodusDataTableMap;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ComServ;


{---------------------------------------}
constructor TExodusDataTableMap.Create();
begin
    _tablemap := TWidestringList.Create();
end;

{---------------------------------------}
destructor TExodusDataTableMap.Destroy();
var
    i: integer;
    table: TSQLiteTable;
begin
    for i := _tablemap.Count - 1 downto 0 do begin
        table := TSQLiteTable(_tablemap.Objects[i]);
        if (table <> nil) then begin
            table.Free();
        end;
        _tablemap.Delete(i);
    end;
end;

{---------------------------------------}
procedure TExodusDataTableMap.AddTable(tableID: WideString; table: TSQLiteTable);
begin
    if (tableID = '') then exit;
    if (table = nil) then exit;

    RemoveTable(tableID);

    _tablemap.AddObject(tableID, table);
end;

{---------------------------------------}
function TExodusDataTableMap._FindTable(tableID: widestring): integer;
var
    i: integer;
begin
    Result := -1;
    if (tableID = '') then exit;

    if (_tablemap.Find(tableID, i)) then begin
        Result := i;
    end;
end;

{---------------------------------------}
function TExodusDataTableMap.FindTable(tableID: widestring): TSQLiteTable;
var
    i: integer;
begin
    Result := nil;
    if (tableID = '') then exit;

    i := _FindTable(tableID);

    if (i >= 0) then begin
        Result := TSQLiteTable(_tablemap.Objects[i]);
    end;
end;

{---------------------------------------}
procedure TExodusDataTableMap.RemoveTable(tableID: widestring);
var
    i: integer;
begin
    if (tableID = '') then exit;

    i := _FindTable(tableID);
    if (i >= 0) then begin
        try
            TSQLiteTable(_tablemap.Objects[i]).Free();
            _tablemap.Delete(i);
        except
        end;
    end;
end;

{---------------------------------------}
procedure TExodusDataTable.Initialize();
begin
    inherited;
    _tableID := DateTimeToStr(Now());
end;

{---------------------------------------}
destructor TExodusDataTable.Destroy;
begin
    ExodusDataTableMap.RemoveTable(_tableID);

    inherited;
end;

{---------------------------------------}
function TExodusDataTable._GetTable(): TSQLiteTable;
begin
    Result := ExodusDataTableMap.FindTable(_tableID);
end;

{---------------------------------------}
function TExodusDataTable.Get_ColCount: Integer;
begin
    Result := -1;
    if (_table = nil) then exit;

    try
        Result := _table.ColCount;
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.Get_CurrentRow: Integer;
begin
    Result := -1;
    if (_table = nil) then exit;

    try
        Result := _table.Row;
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.Get_IsBeginOfTable: WordBool;
begin
    Result := false;
    if (_table = nil) then exit;

    try
        Result := _table.BOF;
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.Get_IsEndOfTable: WordBool;
begin
    Result := false;
    if (_table = nil) then exit;

    try
        Result := _table.EOF;
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.Get_RowCount: Integer;
begin
    Result := -1;
    if (_table = nil) then exit;

    try
        Result := _table.RowCount;
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.GetCol(Column: Integer): WideString;
begin
    Result := '';
    if (_table = nil) then exit;

    try
        Result := _table.Columns[Column];
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.GetField(Field: Integer): WideString;
begin
    Result := '';
    if (_table = nil) then exit;

    try
        Result := _table.Fields[Field];
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.GetFieldAsDouble(Field: Integer): Double;
begin
    Result := -1;
    if (_table = nil) then exit;

    try
        Result := _table.FieldAsDouble(Field);
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.GetFieldAsInt(Field: Integer): Integer;
begin
    Result := -1;
    if (_table = nil) then exit;

    try
        Result := _table.FieldAsInteger(Field);
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.GetFieldAsString(Field: Integer): WideString;
begin
    Result := '';
    if (_table = nil) then exit;

    try
        Result := _table.FieldAsString(Field);
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.GetFieldByName(const Name: WideString): WideString;
begin
    Result := '';
    if (_table = nil) then exit;

    try
        Result := _table.FieldByName[Name];
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.IsFieldNULL(Field: Integer): WordBool;
begin
    Result := false;
    if (_table = nil) then exit;

    try
        Result := _table.FieldIsNull(Field);
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.FirstRow: WordBool;
begin
    Result := false;
    if (_table = nil) then exit;

    try
        Result := _table.MoveFirst;
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.LastRow: WordBool;
begin
    Result := false;
    if (_table = nil) then exit;

    try
        Result := _table.MoveLast;
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.NextRow: WordBool;
begin
    Result := false;
    if (_table = nil) then exit;

    try
        Result := _table.Next;
    except
         on e: ESqliteException do begin
            // Eat error
        end;
   end;
end;

{---------------------------------------}
function TExodusDataTable.PrevRow: WordBool;
begin
    Result := false;
    if (_table = nil) then exit;

    try
        Result := _table.Previous;
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.GetFieldIndex(const Field: WideString): Integer;
begin
    Result := -1;
    if (_table = nil) then exit;

    try
        Result := _table.FieldIndex[Field];
    except
        on e: ESqliteException do begin
            // Eat error
        end;
    end;
end;

{---------------------------------------}
function TExodusDataTable.Get_SQLTableID: WideString;
begin
    Result := _tableID;
end;




initialization
    TAutoObjectFactory.Create(ComServer, TExodusDataTable, Class_ExodusDataTable,
                              ciMultiInstance, tmApartment);

    ExodusDataTableMap := TExodusDataTableMap.Create();

finalization
    ExodusDataTableMap.Free();

end.
