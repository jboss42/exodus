unit JabberID;
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
    SysUtils, Classes;

type
    TJabberID = class
    private
        _raw: string;
        _user: string;
        _domain: string;
        _resource: string;
    public
        constructor Create(jid: string);

        function jid: string;
        function full: string;
        function compare(sjid: string; resource: boolean): boolean;

        procedure ParseJID(jid: string);

        property user: string read _user;
        property domain: string read _domain;
        property resource: string read _resource;
    end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{---------------------------------------}
constructor TJabberID.Create(jid: string);
begin
    // parse the jid
    // user@domain/resource
    _raw := jid;
    _user := '';
    _domain := '';
    _resource := '';

    if (_raw <> '') then ParseJID(_raw);

end;

{---------------------------------------}
procedure TJabberID.ParseJID(jid: string);
var
    tmps: string;
    p1, p2: integer;
begin
    _raw := jid;

    p1 := Pos('@', _raw);
    p2 := Pos('/', _raw);

    tmps := _raw;
    if p2 > 0 then begin
        // pull off the resource..
        _resource := Copy(tmps, p2 + 1, length(tmps) - p2 + 1);
        tmps := Copy(tmps, 1, p2 - 1);
        end;

    if p1 > 0 then begin
        _domain := Copy(tmps, p1 + 1, length(tmps) - p1 + 1);
        _user := Copy(tmps, 1, p1 - 1);
        end
    else
        _domain := tmps;
end;

{---------------------------------------}
function TJabberID.jid: string;
begin
    // return the _user@_domain
    if _user <> '' then
        Result := _user + '@' + _domain
    else
        Result := _domain;
end;

{---------------------------------------}
function TJabberID.Full: string;
begin
    if _resource <> '' then
        Result := jid + '/' + _resource
    else
        Result := jid;
end;

{---------------------------------------}
function TJabberID.compare(sjid: string; resource: boolean): boolean;
begin
    // compare the 2 jids for equality
    Result := false;
end;

end.

