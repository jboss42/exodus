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
        _raw: widestring;
        _user: widestring;
        _domain: widestring;
        _resource: widestring;
    public
        constructor Create(jid: widestring);

        function jid: widestring;
        function full: widestring;
        function compare(sjid: widestring; resource: boolean): boolean;

        procedure ParseJID(jid: widestring);

        property user: widestring read _user;
        property domain: widestring read _domain;
        property resource: widestring read _resource;
end;


function isValidJID(jid: Widestring): boolean;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

function isValidJID(jid: Widestring): boolean;
var
    curlen, part, i: integer;
    c: Cardinal;
    valid_char: boolean;
begin
    Result := false;

    if (Pos('@', jid) >= 0) then part := 0 else part := 1;

    curlen := 0;
    for i := 1 to Length(jid) do begin
        c := Ord(jid[i]);
        valid_char := false;
        if ((jid[i] = '@') and (part = 0)) then begin
            part := 1;
            curlen := 0;
        end
        else if ((jid[i] = '/') and (part < 2)) then begin
            part := 2;
            curlen := 0;
        end
        else begin
            inc(curlen);
            case part of
            0: begin
                // user or domain
                case c of
                $21, $23..$25, $28..$2E,
                $30..$39, $3B, $3D, $3F,
                $41..$7E, $80..$D7FF,
                $E000..$FFFD, $10000..$10FFFF: valid_char := true;
                end;
                if (not valid_char) then exit;
                if (curlen > 256) then exit;
            end;
            1: begin
                // domain
                case c of
                $2D, $2E, $30..$39, $5F, $41..$5A, $61..$7A: valid_char := true;
                end;
                if (not valid_char) then exit;
                if (curlen > 256) then exit;
            end;
            2: begin
                // resource
                case c of
                $20..$D7FF, $E000..$FFFD,
                $10000..$10FFFF: valid_char := true;
                end;

                if (not valid_char) then exit;
                if (curlen > 256) then exit;
            end;
        end;
            
        end;
    end;
    Result := true;
end;

{---------------------------------------}
constructor TJabberID.Create(jid: widestring);
begin
    // parse the jid
    // user@domain/resource
    inherited Create();
    
    _raw := jid;
    _user := '';
    _domain := '';
    _resource := '';

    if (_raw <> '') then ParseJID(_raw);
end;

{---------------------------------------}
procedure TJabberID.ParseJID(jid: widestring);
var
    tmps: WideString;
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
function TJabberID.jid: widestring;
begin
    // return the _user@_domain
    if _user <> '' then
        Result := _user + '@' + _domain
    else
        Result := _domain;
end;

{---------------------------------------}
function TJabberID.Full: widestring;
begin
    if _resource <> '' then
        Result := jid + '/' + _resource
    else
        Result := jid;
end;

{---------------------------------------}
function TJabberID.compare(sjid: widestring; resource: boolean): boolean;
begin
    // compare the 2 jids for equality
    Result := false;
end;

end.

