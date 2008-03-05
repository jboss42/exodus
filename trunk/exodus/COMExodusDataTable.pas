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
    ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusDataTable = class(TAutoObject, IExodusDataTable)
  protected
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
    procedure FirstRow; safecall;
    procedure LastRow; safecall;
    procedure NextRow; safecall;
    procedure PrevRow; safecall;

  private

  public

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ComServ;


{---------------------------------------}
function TExodusDataTable.Get_ColCount: Integer;
begin
    Result := 0; //???dda
end;

{---------------------------------------}
function TExodusDataTable.Get_CurrentRow: Integer;
begin
    Result := 0; //???dda
end;

{---------------------------------------}
function TExodusDataTable.Get_IsBeginOfTable: WordBool;
begin
    Result := false; //???dda
end;

{---------------------------------------}
function TExodusDataTable.Get_IsEndOfTable: WordBool;
begin
    Result := false; //???dda
end;

{---------------------------------------}
function TExodusDataTable.Get_RowCount: Integer;
begin
    Result := 0; //???dda
end;

{---------------------------------------}
function TExodusDataTable.GetCol(Column: Integer): WideString;
begin
    Result := ''; //???dda
end;

{---------------------------------------}
function TExodusDataTable.GetField(Field: Integer): WideString;
begin
    Result := ''; //???dda
end;

{---------------------------------------}
function TExodusDataTable.GetFieldAsDouble(Field: Integer): Double;
begin
    Result := 0; //???dda
end;

{---------------------------------------}
function TExodusDataTable.GetFieldAsInt(Field: Integer): Integer;
begin
    Result := 0; //???dda
end;

{---------------------------------------}
function TExodusDataTable.GetFieldAsString(Field: Integer): WideString;
begin
    Result := ''; //???dda
end;

{---------------------------------------}
function TExodusDataTable.GetFieldByName(const Name: WideString): WideString;
begin
    Result := ''; //???dda
end;

{---------------------------------------}
function TExodusDataTable.IsFieldNULL(Field: Integer): WordBool;
begin
    Result := false; //???dda
end;

{---------------------------------------}
procedure TExodusDataTable.FirstRow;
begin

end;

{---------------------------------------}
procedure TExodusDataTable.LastRow;
begin

end;

{---------------------------------------}
procedure TExodusDataTable.NextRow;
begin

end;

{---------------------------------------}
procedure TExodusDataTable.PrevRow;
begin

end;



initialization
  TAutoObjectFactory.Create(ComServer, TExodusDataTable, Class_ExodusDataTable,
    ciMultiInstance, tmApartment);

end.
