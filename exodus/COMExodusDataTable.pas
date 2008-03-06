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
    StdVcl, SQLiteTable3;

type
  TExodusDataTable = class(TAutoObject, IExodusDataTable)
  private
    // Variables
    _table: TSQLiteTable;

    // Methdods

  protected
    // Variables

    // Methdods

  public
    // Variables

    // Methdods
    constructor Create(sqltable: TSQLiteTable);
    destructor Destroy();

    // IExodusDataTable Interface
    function Get_ColCount: Integer; safecall;
    function Get_CurrentRow: Integer; safecall;
    function Get_IsBeginOfTable: WordBool; safecall;
    function Get_IsEndOfTable: WordBool; safecall;
    function Get_RowCount: Integer; safecall;
    function GetCol(Column: Integer): WideString; safecall;
    function GetField(Field: Integer): WideString; safecall;
    function GetFieldAsDouble(Field: Integer): Double; safecall;
    function GetFieldAsInt(Field: Integer): Integer; safecall;
    function GetFieldAsString(Field: Integer): WideString; safecall;
    function GetFieldByName(const Name: WideString): WideString; safecall;
    function IsFieldNULL(Field: Integer): WordBool; safecall;
    function FirstRow: WordBool; safecall;
    function LastRow: WordBool; safecall;
    function NextRow: WordBool; safecall;
    function PrevRow: WordBool; safecall;

    // Properties
    property Table: TSQLiteTable read _table write _table;

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ComServ;


{---------------------------------------}
constructor TExodusDataTable.Create(sqltable: TSQLiteTable);
begin
    inherited Create;

    _table := sqltable;
end;

{---------------------------------------}
destructor TExodusDataTable.Destroy;
begin
    _table.Free;

    inherited;
end;

{---------------------------------------}
function TExodusDataTable.Get_ColCount: Integer;
begin
    Result := -1;
    if (_table = nil) then exit;

    try
        Result := _table.ColCount;
    except
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
    end;
end;



initialization
  TAutoObjectFactory.Create(ComServer, TExodusDataTable, Class_ExodusDataTable,
    ciMultiInstance, tmApartment);

end.
