unit Register;
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

interface
uses
    XMLTag,
    IQ,
    Presence, 
    Signals,
    SysUtils, Classes;

type
    TRegister = class
    private
        cur_iq: TJabberIQ;
        procedure PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
    public
        rjid: string;
        constructor Create(remote_system: string);
        destructor Destroy; override;
    end;

var
    _cb: integer;

function RegistrationFactory(rjid: string): TRegister;
procedure RegistrationCallback(event: string; tag: TXMLTag);

implementation
uses
    Session;

function RegistrationFactory(rjid: string): TRegister;
begin
    // Create a new registration object
    Result := TRegister.Create(rjid);
    //_cb := MainSession.RegisterCallback('/session/register', RegistrationCallback)
end;

procedure RegistrationCallback(event: string; tag: TXMLTag);
begin
    //
end;

constructor TRegister.Create(remote_system: string);
begin
    //
end;

destructor TRegister.Destroy;
begin
    //
end;

procedure TRegister.PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
begin
    //
end;



end.
