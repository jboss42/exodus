unit ExUtils;
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
    JabberMsg, Graphics, Forms, Classes, SysUtils, Windows;

const
    cWIN_95 = 1;             { Windows version constants}
    cWIN_98 = 2;
    cWIN_NT = 3;
    cWIN_2000 = 4;
    cWIN_ME = 5;
    cWIN_XP = 6;

const
    node_none = 0;
    node_ritem = 1;
    node_bm = 2;
    node_grp = 3;

type
    PLASTINPUTINFO = ^LASTINPUTINFO;
    tagLASTINPUTINFO = record
        cbSize: UINT;
        dwTime: DWORD;
        end;
    {$EXTERNALSYM tagLASTINPUTINFO}
    LASTINPUTINFO = tagLASTINPUTINFO;
    {$EXTERNALSYM LASTINPUTINFO}
    TLastInputInfo = LASTINPUTINFO;

function GetLastInputInfo(var plii: LASTINPUTINFO): BOOL; stdcall;
{$EXTERNALSYM GetLastInputInfo}

function GetAppVersion: string;
function WindowsVersion(var verinfo: string): integer;

function JabberToDateTime(datestr: string): TDateTime;
function DateTimeToJabber(dt: TDateTime): string;

function URLToFilename(url: string): string;

procedure LogMessage(Msg: TJabberMessage);
procedure ShowLog(jid: string);

function getDisplayField(fld: string): string;
procedure DebugMsg(Message : string);
procedure AssignDefaultFont(font: TFont);
function secsToDuration(seconds: string): string;
function GetPresenceAtom(status: string): ATOM;
function GetPresenceString(a: ATOM): string;
function ColorToHTML( Color: TColor): string;

var
    _GetLastInputInfo: Pointer;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    StrUtils, IdGlobal,
    ShellAPI,
    MsgDisplay,
    Session,
    XMLUtils,
    JabberID,
    IniFiles,
    Debug;

type
    TAtom = class
    public
        a : ATOM;
        constructor Create(at: ATOM);
    end;

var
    presenceToAtom: TStringList;

constructor TAtom.Create(at: ATOM);
begin
    a := at;
end;

{---------------------------------------}
function GetLastInputInfo;
begin
    Result := false;
    asm
        mov esp, ebp
        pop ebp
        jmp [_GetLastInputInfo]
    end;
end;

{---------------------------------------}

{---------------------------------------}
function GetAppVersion: string;
const
    InfoNum = 10;
    InfoStr : array [1..InfoNum] of String =
        ('CompanyName', 'FileDescription', 'FileVersion', 'InternalName',
        'LegalCopyright', 'LegalTradeMarks', 'OriginalFilename',
        'ProductName', 'ProductVersion', 'Comments');
var
    S: String;
    n: DWORD;
    Len: UINT;
    i: Integer;
    Buf: PChar;
    Value: PChar;
    keyList: TStringList;
    valList: TStringList;
begin

    Result := '';

    KeyList := TStringlist.create;
    ValList := TStringlist.create;

    S := Application.ExeName;
    n := GetFileVersionInfoSize(PChar(S),n);
    if n > 0 then begin
        Buf := AllocMem(n);
        GetFileVersionInfo(PChar(S),0,n,Buf);
        if VerQueryValue(Buf,PChar('StringFileInfo\040904E4\'+ InfoStr[3]),Pointer(Value),Len) then
            Result := Value;
        for i:=1 to InfoNum do begin
            if VerQueryValue(Buf,PChar('StringFileInfo\040904E4\'+ InfoStr[i]),Pointer(Value),Len) then begin
                KeyList.Add(InfoStr[i]);
                ValList.Add(Value);
                end;
            end;
        FreeMem(Buf,n);
        end
    else
        Result := '';

    keylist.Free;
    vallist.Free;
end;

{---------------------------------------}
function WindowsVersion(var verinfo: string): integer;
var
    OSVersionInfo32: OSVERSIONINFO;
begin
    {
    Function returns:
    1 = Win95
    2 = Win98
    3 = WinNT
    4 = W2k
    5 = Win ME
    6 = Win XP
    }
    Result := -1;

    OSVersionInfo32.dwOSVersionInfoSize := SizeOf(OSVersionInfo32);
    GetVersionEx(OSVersionInfo32);

    case OSVersionInfo32.dwPlatformId of
    VER_PLATFORM_WIN32_WINDOWS:     { Windows 95/98 }
    begin
        with OSVersionInfo32 do
        begin
            { If minor version is zero, we are running on Win 95.
              Otherwise we are running on Win 98 }
            if (dwMinorVersion = 0) then begin
                { Windows 95 }
                Result := cWIN_95;
                verinfo := Format('Windows-95 %d.%.2d.%d%s',
                    [dwMajorVersion, dwMinorVersion,
                    Lo(dwBuildNumber),
                    szCSDVersion]);
            end
            else if (dwMinorVersion < 90) then begin
                { Windows 98 }
                Result := cWIN_98;
                verinfo := Format('Windows-98 %d.%.2d.%d%s',
                    [dwMajorVersion, dwMinorVersion,
                    Lo(dwBuildNumber),
                    szCSDVersion]);
            end
            else if (dwMinorVersion >= 90) then begin
                { Windows ME }
                Result := cWIN_ME;
                verinfo := Format('Windows-ME %d.%.2d.%d%s',
                    [dwMajorVersion, dwMinorVersion,
                    Lo(dwBuildNumber),
                    szCSDVersion]);
            end;
        end; { end with }
    end;
    VER_PLATFORM_WIN32_NT:
    begin
        with OSVersionInfo32 do begin
            if (dwMajorVersion <= 4) then begin
                { Windows NT 3.5/4.0 }
                Result := cWIN_NT;
                verinfo := Format('Windows-NT %d.%.2d.%d%s', [dwMajorVersion,
                    dwMinorVersion, dwBuildNumber, szCSDVersion]);
            end
            else begin
                if (dwMinorVersion > 0) then begin
                    { Windows XP }
                    Result := cWIN_XP;
                    verinfo := Format('Windows-XP %d.%.2d.%d%s', [dwMajorVersion,
                        dwMinorVersion, dwBuildNumber, szCSDVersion]);
                end
                else begin
                    { Windows 2000 }
                    Result := cWIN_2000;
                    verinfo := Format('Windows-2000 %d.%.2d.%d%s', [dwMajorVersion,
                        dwMinorVersion, dwBuildNumber, szCSDVersion]);
                end;
            end;
        end;
    end;
    end; { end case }

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

{---------------------------------------}
function URLToFilename(url: string): string;
var
    i: integer;
    fp, c, fn: string;
begin
    fn := '';
    i := length(url);
    repeat
        c := url[i];
        dec(i);
    until (c = '/') or (c = '\') or (c = ':') or (i <= 0);

    if (i > 0) then begin
        // we got a seperator
        fn := Copy(url, i + 2, length(url) - i);
        fp := MainSession.Prefs.getString('xfer_path');
        if (AnsiEndsText('\', fp)) then
            fn := fp + fn
        else
            fn := fp + '\' + fn;
        end
    else
        fn := url;
    Result := fn;
end;

{---------------------------------------}
procedure ShowLog(jid: string);
var
    fn: string;
begin
    fn := 'iexplore.exe ';
    fn := MainSession.Prefs.getString('log_path');
    fn := fn + '\' + MungeName(jid) + '.html';

    ShellExecute(0, 'open', PChar(fn), '', '', SW_NORMAL);
end;

{---------------------------------------}
procedure LogMessage(Msg: TJabberMessage);
var
    h, fn: string;
    f: TextFile;
    fh: integer;
    header: boolean;
    _jid: TJabberID;
    ndate: TDateTime;
begin
    // log this msg..
    fn := MainSession.Prefs.getString('log_path');

    if (Copy(fn, length(fn), 1) <> '\') then
        fn := fn + '\';

    if (not DirectoryExists(fn)) then begin
        // mkdir
        CreateDir(fn);
        end;

    if (Msg.isMe) then
        _jid := TJabberID.Create(Msg.ToJID)
    else
        _jid := TJabberID.Create(Msg.FromJID);

    fn := fn + MungeName(_jid.jid) + '.html';
    AssignFile(f, fn);
    if FileExists(fn) then begin
        fh := FileOpen(fn, fmOpenRead);
        ndate := FileDateToDateTime(FileGetDate(fh));
        FileClose(fh);
        header := (abs(Now - nDate) > 0.04);
        Append(f);
        end
    else begin
        header := true;
        ReWrite(f);
        end;

    // if the file is over an hour old..put a new header on it.
    if (header) then
        Writeln(f, '<p><font size=+1><b>New Conversation at: ' +
            DateTimeToStr(Now) + '</b></font><br />');

    h := GetMsgHTML(Msg);
    Writeln(f, h);
    CloseFile(f);
end;

{---------------------------------------}
function getDisplayField(fld: string): string;
begin
    // send back "well formatted" field names

    if (fld = 'nick') then result := 'Nickname:'
    else if (fld = 'first') then result := 'First Name:'
    else if (fld = 'last') then result := 'Last Name:'
    else if (fld = 'email') then result := 'EMail Address:'
    else if (fld = 'password') then result := 'Password'
    else if (fld = 'username') then result := 'UserName:'
    else
        result := fld;
end;

{---------------------------------------}
procedure DebugMsg(Message : string);
begin
    DebugMessage(Message);
end;

{---------------------------------------}
procedure AssignDefaultFont(font: TFont);
begin
    with MainSession.Prefs do begin
        Font.Name := getString('font_name');
        Font.Size := getInt('font_size');
        Font.Style := [];
        // Color := TColor(getInt('color_bg'));
        Font.Color := TColor(getInt('font_color'));
        if getBool('font_bold') then
            Font.Style := Font.Style + [fsBold];
        if getBool('font_italic') then
            Font.Style := Font.Style + [fsItalic];
        if getBool('font_underline') then
            Font.Style := Font.Style + [fsUnderline];
        end;
end;

{---------------------------------------}
function secsToDuration(seconds: string): string;
var
    d : integer;
    h : integer;
    m : integer;
    s : integer;

    function toText(i: integer; modifier: string) : string;
    begin
        if (i = 0) then
            result := ''
        else if (i = 1) then
            result := ' ' + IntToStr(i) + ' ' + modifier
        else
            result := ' ' + IntToStr(i) + ' ' + modifier + 's';
    end;

begin
    s := StrToIntDef(seconds, -1);

    if (s < 0) then begin
        result := ' unknown last result: ' + seconds
        end
    else if (s = 0) then begin
        result := ' 0 seconds';
        end
    else begin
        d := s div 86400;
        h := (s mod 86400) div 3600;
        m := ((s mod 86400) mod 3600) div 60;
        s := s mod 60;
        result := toText(d, 'day') + toText(h, 'hour') +
                  toText(m, 'minute') + toText(s, 'second');
    end;
end;

{---------------------------------------}
function GetPresenceAtom(status: string): ATOM;
var
    ind : integer;
    a: ATOM;
begin
    // atom functions don't like ''.
    if (status = '') then begin
        result := 0;
        exit;
        end;

    ind := presenceToAtom.IndexOf(status);
    if (ind = -1) then begin
        a := GlobalAddAtom(pchar(status));
        if (a = 0) then
            raise Exception.Create('Bad string to atom: ' + status);
        presenceToAtom.AddObject(status, TAtom.Create(a));
        result := a;
        end
    else
        result := TAtom(presenceToAtom.Objects[ind]).a;
end;

{---------------------------------------}
function GetPresenceString(a: ATOM): string;
var
    i : integer;
    buf: array[0..255] of char;
    status : string;
begin
    if (a = 0) then begin
        result := '';
        exit;
        end;
        
    // hm.  better data structure needed...
    // Luckily, there shouldn't be more than ~10 of these,
    // so it doesn't matter that much.
    for i:=0 to presenceToAtom.Count-1 do begin
        if (TAtom(presenceToAtom.Objects[i]).a = a) then begin
            result := presenceToAtom[i];
            exit;
            end;
        end;
    // not found
    if (GlobalGetAtomName(a, buf, sizeof(buf)) = 0) then
        raise Exception.Create('Global atom not found for: ' + IntToStr(a));
    status := StrPas(buf);
    presenceToAtom.AddObject(status, TAtom.Create(a));
    result := status;
end;

{---------------------------------------}
procedure FreeAtoms(pta: TStringList);
var
    i : integer;
    a : TAtom;
begin
    for i:=0 to pta.Count-1 do begin
        a := TAtom(pta.Objects[i]);
        GlobalDeleteAtom(a.a);
        a.Free();
        end;
end;

function ColorToHTML( Color: TColor): string;
begin
  result := Format( '#%.2x%.2x%.2x', [ GetRValue( Color), GetGValue( Color), GetBValue( Color)]);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
initialization
    _GetLastInputInfo := GetProcAddress(GetModuleHandle('user32.dll'), 'GetLastInputInfo');
    presenceToAtom := TStringList.Create();

finalization
    if (presenceToAtom <> nil) then begin
        FreeAtoms(presenceToAtom);
        presenceToAtom.Free();
        end;
end.

