unit JabberUtils;
{
    Copyright 2004, Peter Millard

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
    Unicode, XMLTag, Dialogs, Graphics, Classes, SysUtils;

function jabberIQResult(orig: TXMLTag): TXMLTag;
function jabberIQError(orig: TXMLTag): TXMLTag;
function JabberToDateTime(datestr: string): TDateTime;
function DateTimeToJabber(dt: TDateTime): string;
function UTCNow(): TDateTime;
function ColorToHTML(Color: TColor): string;
function MessageDlgW(const Msg: Widestring; DlgType: TMsgDlgType;
    Buttons: TMsgDlgButtons; HelpCtx: Longint; Caption: Widestring = ''): Word;


procedure split(value: WideString; list: TWideStringList; seps : WideString = ' '#9#10#13);

implementation
uses
    {$ifdef EXODUS}
    GnuGetText,
    {$endif}

    Controls, Types, Forms, Windows,
    // IdGlobal provides TimeZoneBias() for us
    IdGlobal;

{---------------------------------------}
function jabberIQResult(orig: TXMLTag): TXMLTag;
begin
    //
    Result := TXMLTag.Create('iq');
    Result.setAttribute('to', orig.getAttribute('from'));
    Result.setAttribute('id', orig.getAttribute('id'));
    Result.setAttribute('type', 'result');
end;

{---------------------------------------}
function jabberIQError(orig: TXMLTag): TXMLTag;
begin
    //
    Result := jabberIQResult(orig);
    Result.setAttribute('type', 'error');
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

    yw := StrToInt(ys);
    mw := StrToInt(ms);
    dw := StrToInt(ds);

    if (TryEncodeDate(yw, mw, dw, rdate)) then begin
        rdate := rdate + StrToTime(ts);
        Result := rdate - TimeZoneBias();
    end
    else
        Result := Now;
end;

{---------------------------------------}
function DateTimeToJabber(dt: TDateTime): string;
begin
    // Format the current date/time into "Jabber" format
    Result := FormatDateTime('yyyymmdd', dt);
    Result := Result + 'T';
    Result := Result + FormatDateTime('hh:nn:ss', dt);
end;

{---------------------------------------}
function ColorToHTML( Color: TColor): string;
var
    rgb: longint;
begin
    rgb := ColorToRGB(Color);
    result := Format( '#%.2x%.2x%.2x', [ GetRValue(rgb),
                GetGValue(rgb), GetBValue(rgb)]);
end;

{---------------------------------------}
procedure split(value: WideString; list: TWideStringList; seps : WideString = ' '#9#10#13);
var
    i, l : integer;
    tmps : WideString;
begin
    tmps := Trim(value);
    l := 1;
    while l <= length(tmps) do begin
        // search for the first non-space
        while ((l <= length(tmps)) and (pos(tmps[l], seps) > 0)) do
            inc(l);

        if l > length(tmps) then exit;
        i := l;

        // search for the first space
        while (i <= length(tmps)) and (pos(tmps[i], seps) <=0) do
            inc(i);

        list.Add(Copy(tmps, l, i - l));
        l := i + 1;

    end;
end;

{---------------------------------------}
function UTCNow(): TDateTime;
var
    tzi: TTimeZoneInformation;
    res: integer;
begin
    res := GetTimeZoneInformation(tzi);
    if res = TIME_ZONE_ID_DAYLIGHT then
        result := Now + ((tzi.Bias - 60) / 1440.0)
    else
        result := Now + (tzi.Bias / 1440.0);;
end;

{---------------------------------------}
function MessageDlgW(const Msg: Widestring; DlgType: TMsgDlgType;
    Buttons: TMsgDlgButtons; HelpCtx: Longint; Caption: Widestring): Word;
var
    flags: Word;
    res: integer;
begin
    flags := 0;
    case DlgType of
    mtWarning:          flags := flags + MB_ICONWARNING;
    mtError:            flags := flags + MB_ICONERROR;
    mtInformation:      flags := flags + MB_ICONINFORMATION;
    mtConfirmation:     flags := flags + MB_ICONQUESTION;
    end;

    {
    TMsgDlgBtn = (mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore,
        mbAll, mbNoToAll, mbYesToAll, mbHelp);
    }
    if (Buttons = [mbYes, mbNo, mbCancel]) then
        flags := flags or MB_YESNOCANCEL
    else if (Buttons = [mbYes, mbNo]) then
        flags := flags or MB_YESNO
    else if (Buttons = [mbOK]) then
        flags := flags or MB_OK
    else if (Buttons = [mbOK, mbCancel]) then
        flags := flags or MB_OKCANCEL
    else
        flags := flags or MB_OK;

    {$ifdef EXODUS}
    res := MessageBoxW(Application.Handle, PWideChar(Msg), PWideChar(_('Exodus')),
        flags);
    {$else}
    res := MessageBoxW(Application.Handle, PWideChar(Msg), PWideChar(Caption),
        flags);
    {$endif}

    case res of
    IDCANCEL: Result := mrCancel;
    IDNO: Result := mrNo;
    IDYES: Result := mrYes;
    else
        Result := mrOK;
    end;

end;


end.
