unit XMLUtils;
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
    XMLTag, Classes, SysUtils;

function XML_EscapeChars(txt: string): string;
function XML_UnEscapeChars(txt: string): string;

function HTML_EscapeChars(txt: string; DoAPOS: boolean): string;
function TrimQuotes(instring: string): string;
function RightChar(instring: string; nchar: word): string;
function LeftChar(instring: string; nchar: word): string;
function SToInt(inp: string): integer;
function NameMatch(s1, s2: string): boolean;
function Sha1Hash(fkey: string): string;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    sechash;


{---------------------------------------}
function HTML_EscapeChars(txt: string; DoAPOS: boolean): string;
var
    tok, tmps: string;
    j, i: integer;
begin
    // escape special chars .. not &apos; --> only XML
    tok := '';
    tmps := '';
    i := 1;
    while i <= length(txt) do begin
        if txt[i] = '&' then begin
            j := i + 1;
            tok := '';
            repeat
                if (j >= length(txt)) then
                    tok := Copy(txt, i, j - i + 1)
                else if (txt[j] = ' ') or (txt[j] = ';') then
                    tok := Copy(txt, i, j - i + 1)
                else
                    inc(j);
            until (tok <> '') or (j > length(txt));

            if (tok = '&amp;') or (tok = '&quot;') or
            (tok = '&apos;') or (tok = '&lt;') or (tok = '&gt;') then
                tmps := tmps + '&'
            else
                tmps := tmps + '&amp;'
            end
        else if (txt[i] = Chr(39)) and (DoAPOS) then tmps := tmps + '&apos;'
        else if txt[i] = '"' then tmps := tmps + '&quot;'
        else if txt[i] = '<' then tmps := tmps + '&lt;'
        else if txt[i] = '>' then tmps := tmps + '&gt;'
        else tmps := tmps + txt[i];
        inc(i);
    end;
    Result := tmps;
end;

{---------------------------------------}
function XML_EscapeChars(txt: string): string;
begin
    // escape the special chars.
    Result := HTML_EscapeChars(txt, true);
end;

{---------------------------------------}
function XML_UnescapeChars(txt: string): string;
var
    tok, tmps: string;
    a, i: integer;
begin
    // un-escape the special chars.
    tmps := '';
    i := 1;
    while i <= length(txt) do begin
        // amp
        if txt[i] = '&' then begin
            a := i;
            repeat
                inc(i);
            until (txt[i] = ';') or (i >= length(txt));
            tok := Copy(txt, a+1, i-a-1);
            if tok = 'amp' then tmps := tmps + '&';
            if tok = 'quot' then tmps := tmps + '"';
            if tok = 'apos' then tmps := tmps + Chr(39);
            if tok = 'lt' then tmps := tmps + '<';
            if tok = 'gt' then tmps := tmps + '>';
            inc(i);
            end
        else begin
            // normal char
            tmps := tmps + txt[i];
            inc(i);
            end;
        end;
    Result := tmps;
end;

{---------------------------------------}
function TrimQuotes(instring: string): string;
var
	tmps: string;
begin
	{strip off first and last " or ' characters}
    tmps := Trim(instring);
    if Leftchar(tmps, 1) = '"' then
    	tmps := RightChar(tmps, length(tmps) - 1);
    if RightChar(tmps, 1) = '"' then
    	tmps := LeftChar(tmps, Length(tmps) - 1);
    if Leftchar(tmps, 1) = Chr(39) then
    	tmps := RightChar(tmps, length(tmps) - 1);
    if RightChar(tmps, 1) = Chr(39) then
    	tmps := LeftChar(tmps, Length(tmps) - 1);

    Result := tmps;
end;

{---------------------------------------}
function RightChar(instring: string; nchar: word): string;
var
	tmps: string;
begin
	{returns the rightmost n characters of a string}
    tmps := Copy(instring, length(instring) - nchar + 1, nchar);
    Result := tmps;
end;

{---------------------------------------}
function LeftChar(instring: string; nchar: word): string;
var
	tmps: string;
begin
	{returns the leftmost n characters of a string}
    tmps := Copy(instring, 1, nchar);
    Result := tmps;
end;

{---------------------------------------}
function SToInt(inp: string): integer;
var
	tmpi: integer;
begin
    // exception safe version of StrToInt
	try
    	tmpi := StrToInt(Trim(inp));
    except on EConvertError do
    	tmpi := 0;
    end;
    Result := tmpi;
end;

{---------------------------------------}
function NameMatch(s1, s2: string): boolean;
begin
    Result := (StrComp(PChar(s1), PChar(s2)) = 0);
end;

{---------------------------------------}
function Sha1Hash(fkey: string): string;
var
    hasher: TSecHash;
    h: TIntDigest;
    i: integer;
    s: string;
begin
    hasher := TSecHash.Create(nil);
    h := hasher.ComputeString(fkey);
    s := '';
    for i := 0 to 4 do
        s := s + IntToHex(h[i], 8);
    s := Lowercase(s);
    hasher.Free;
    Result := s;
end;


end.
