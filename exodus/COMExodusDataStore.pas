unit COMExodusDataStore;

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
  TExodusDataStore = class(TAutoObject, IExodusDataStore)
  protected
    // IExodusDataStore Interface
    function ExecSQL(const SQLStatement: WideString): WordBool; safecall;
    function GetTable(const SQLStatement: WideString): IExodusDataTable; safecall;

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
function TExodusDataStore.ExecSQL(const SQLStatement: WideString): WordBool;
begin
    Result := false; //???dda
end;

{---------------------------------------}
function TExodusDataStore.GetTable(const SQLStatement: WideString): IExodusDataTable;
begin
    Result := nil; //???dda
end;



initialization
  TAutoObjectFactory.Create(ComServer, TExodusDataStore, Class_ExodusDataStore,
    ciMultiInstance, tmApartment);

end.
