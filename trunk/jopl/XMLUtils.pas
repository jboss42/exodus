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
function EncodeString(value: string): string;
function DecodeString(value: string): string;
function MungeName(str: string): string;
function SafeInt(str: string): integer;

function JabberToDateTime(datestr: string): TDateTime;
function DateTimeToJabber(dt: TDateTime): string;

procedure ClearStringListObjects(sl: TStringList);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    IdGlobal, IdCoder3To4, sechash;


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
    // Do a SHA1 hash using the sechash.pas unit
    hasher := TSecHash.Create(nil);
    h := hasher.ComputeString(fkey);
    s := '';
    for i := 0 to 4 do
        s := s + IntToHex(h[i], 8);
    s := Lowercase(s);
    hasher.Free;
    Result := s;
end;

{---------------------------------------}
function EncodeString(value: string): string;
var
    e: TIdBase64Encoder;
begin
    // do base64 encode
    e := TIdBase64Encoder.Create(nil);
    e.CodeString(value);
    Result := e.CompletedInput();
    Fetch(Result, ';');
    e.Free();
end;

{---------------------------------------}
function DecodeString(value: string): string;
var
    d: TIdBase64Decoder;
begin
    // do base64 decode
    d := TIdBase64Decoder.Create(nil);
    d.CodeString(value);
    Result := d.CompletedInput();
    Fetch(Result, ';');
    d.Free();
end;

{---------------------------------------}
function MungeName(str: string): string;
var
    i: integer;
    c, fn: string;
begin
    // Munge some string into a filename
    // Removes all chars which aren't allowed
    fn := '';
    for i := 0 to Length(str) - 1 do begin
        c := str[i + 1];
        if ( (c='@') or (c=':') or (c='|') or (c='<') or
        (c='>') or (c='\') or (c='/') or (c='*') or (c=' ') ) then
            fn := fn + '_'
        else
            fn := fn + c;
        end;
    Result := fn;
end;

{---------------------------------------}
function SafeInt(str: string): integer;
begin
    // Null safe string to int function
    try
        Result := StrToInt(str);
    except
        Result := 0;
    end;
end;

{---------------------------------------}
procedure ClearStringListObjects(sl: TStringList);
var
    i: integer;
    o: TObject;
begin
    //
    for i := 0 to sl.Count - 1 do begin
        o := TObject(sl.Objects[i]);
        if (o <> nil) then
            o.Free();
        end;
end;

{---------------------------------------}
function JabberToDateTime(datestr: string): TDateTime;
var
    rdate: TDateTime;
    ys, ms, ds, ts: string;
    yw, mw, dw: Word;
begin
    // translate date from 20000110T19:54:00 to proper format..
    ys := Copy(Datestr, 1, 4);
    ms := Copy(Datestr, 5, 2);
    ds := Copy(Datestr, 7, 2);
    ts := Copy(Datestr, 10, 8);

    try
        yw := StrToInt(ys);
        mw := StrToInt(ms);
        dw := StrToInt(ds);

        rdate := EncodeDate(yw, mw, dw);
        rdate := rdate + StrToTime(ts);

        Result := rdate - TimeZoneBias();
    except
        Result := Now;
    end;
end;

{---------------------------------------}
function DateTimeToJabber(dt: TDateTime): string;
begin
    // Format the current date/time into "Jabber" format
    Result := FormatDateTime('yyyymmdd', dt);
    Result := Result + 'T';
    Result := Result + FormatDateTime('hh:nn:ss', dt);
end;




end.
