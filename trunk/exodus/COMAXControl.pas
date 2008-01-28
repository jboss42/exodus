unit COMAXControl;
{
    Copyright 2001, Peter Millard

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

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, Variants, ComCtrls, ComObj, ActiveX, Exodus_TLB, StdVcl, PLUGINCONTROLLib_TLB ;

type
  TExodusAXControl = class(TAutoObject, IExodusAXControl)
  private
    AXControl: TAXControl;
    prop1: integer;

  public
    constructor Create(AXControl: TAXControl);

  protected
    function Get_Property1: Integer; safecall;
    procedure Set_Property1(value: Integer); safecall;

  end;

implementation

uses
    RosterImages, ComServ;

constructor TExodusAXControl.Create(AXControl: TAXControl);
begin
      Self.AXControl := AXControl;
end;


function TExodusAXControl.Get_Property1: Integer;
begin
    Result := prop1;
end;

procedure TExodusAXControl.Set_Property1(value: Integer);
begin
    prop1 := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusAXControl, Class_ExodusAXControl,
    ciMultiInstance, tmApartment);
end.
