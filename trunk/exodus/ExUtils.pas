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
    Unicode, ExRichEdit, RichEdit2, Signals, XMLTag, IQ,
    TntStdCtrls, TntClasses, TntMenus, Menus, Dialogs, NodeItem,  
    JabberMsg, Graphics, Controls, StdCtrls, Forms, Classes, SysUtils, Windows,
    TntSysUtils;

const
    cWIN_95 = 1;             { Windows version constants}
    cWIN_98 = 2;
    cWIN_NT = 3;    // NT 4.0
    cWIN_2000 = 4;
    cWIN_ME = 5;
    cWIN_XP = 6;

const
    node_none = 0;
    node_ritem = 1;
    node_bm = 2;
    node_grp = 3;
    node_transport = 4;
    node_myres = 5;

function WindowsVersion(var verinfo: string): integer;
function URLToFilename(url: string): string;

procedure LogMessage(Msg: TJabberMessage);
procedure ShowLog(jid: Widestring);
procedure ClearAllLogs();
procedure ClearLog(jid: Widestring);
procedure ShowRoomLog(jid: Widestring);
procedure ClearRoomLog(jid: Widestring);
procedure ClearAllRoomLogs();

Procedure DebugMsgBox(msg : string);
procedure DebugMsg(Message : string);
procedure AssignDefaultFont(font: TFont);
procedure AssignUnicodeFont(f: TFont; font_size: short = 0); overload;
procedure AssignUnicodeFont(Form: TForm; font_size: short = 0); overload;
procedure AssignUnicodeHighlight(f: TFont; font_size: short);
procedure AssignUnicodeURL(f: TFont; font_size: short);
procedure URLLabel(lbl: TLabel); overload;
procedure URLLabel(lbl: TTntLabel); overload;

procedure jabberSendRosterItems(to_jid: WideString; items: TList);

function jabberSendCTCP(jid, xmlns: Widestring; callback: TPacketEvent = nil): TJabberIQ;
function getDisplayField(fld: string): string;
function secsToDuration(seconds: string): Widestring;
function GetPresenceAtom(status: string): ATOM;
function GetPresenceString(a: ATOM): string;
function getMemoText(memo: TMemo): WideString;
function getInputText(Input: TExRichEdit): Widestring;
function ForceForegroundWindow(hwnd: THandle): boolean;

function trimNewLines(value: WideString): WideString;

procedure CanvasTextOutW(Canvas: TCanvas; X, Y: Integer;
    const Text: WideString; max_right: integer = -1);
function CanvasTextWidthW(Canvas: TCanvas; const Text: WideString): integer;

procedure removeSpecialGroups(grps: TStrings); overload;
procedure removeSpecialGroups(grps: TWidestrings); overload;
procedure removeSpecialGroups(grps: TTntStrings); overload;

procedure AssignTntStrings(sl: TWidestringlist; tnt: TTntStrings);

procedure jabberSendMsg(to_jid: Widestring; mtag, xtags: TXMLTag;
    body, subject: Widestring); overload;
procedure jabberSendMsg(to_jid: Widestring; mtag: TXMLTag;
    xtags, body, subject: Widestring); overload;

procedure centerMainForm(f: TForm);
procedure CenterChildForm(f: TForm; anchor: TForm);
procedure checkAndCenterForm(f: TForm);
procedure BuildPresMenus(parent: TObject; clickev: TNotifyEvent);
function promptNewGroup: TJabberGroup;

function IsUnicodeEnabled(): boolean;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Exodus_TLB, COMLogMsg, ExSession, GnuGetText, Presence, InputPassword,
    IniFiles, StrUtils, IdGlobal, ShellAPI, Types, 
    XMLUtils, Session, JabberUtils, JabberID, Jabber1, Roster,
    JabberConst, MsgDisplay, Debug;

type
    TAtom = class
    public
        a : ATOM;
        constructor Create(at: ATOM);
    end;

const
    sMsgRosterItems = 'This message contains %d roster items.';

    sDownloading      = 'Downloading...';
    sDownloadComplete = 'Download Complete';
    sInitializing     = 'Initializing...';
    sInstalling       = 'Installing...';
    sError            = 'Error: %s';

    sDefaultGroup = 'Untitled Group';
    sGrpBookmarks = 'Bookmarks';
    sGrpOffline = 'Offline';
    sGrpUnfiled = 'Unfiled';

    sTurnOnBlocking = 'You currently have logging turned off. Turn Logging On? (Warning: Logs are not encrypted)';

    sNewGroup = 'New Roster Group';
    sNewGroupPrompt = 'Enter new group name below. ';
    sNewGroupNested = 'To create a nested group, use a name like foo%sbar.';
    sNewGroupExists = 'This group already exists!';

var
    presenceToAtom: TStringList;
    unicode_font: TFont;
    unicode_enabled: integer;

{---------------------------------------}
constructor TAtom.Create(at: ATOM);
begin
    a := at;
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
    VER_PLATFORM_WIN32_NT: begin
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
{---------------------------------------}
{---------------------------------------}
procedure ShowLog(jid: Widestring);
var
    logger: IExodusLogger;
begin
    logger := ExCOMController.ContactLogger;
    if (logger <> nil) then
        logger.Show(jid);
end;

{---------------------------------------}
procedure ClearLog(jid: Widestring);
var
    logger: IExodusLogger;
begin
    logger := ExCOMController.ContactLogger;
    if (logger <> nil) then
        logger.Clear(jid);
end;

{---------------------------------------}
procedure ClearAllLogs();
var
    logger: IExodusLogger;
begin
    logger := ExCOMController.ContactLogger;
    if (logger <> nil) then
        logger.Purge();
end;

{---------------------------------------}
procedure ShowRoomLog(jid: Widestring);
var
    logger: IExodusLogger;
begin
    logger := ExCOMController.RoomLogger;
    if (logger <> nil) then
        logger.Show(jid);
end;

{---------------------------------------}
procedure ClearRoomLog(jid: Widestring);
var
    logger: IExodusLogger;
begin
    logger := ExCOMController.RoomLogger;
    if (logger <> nil) then
        logger.Clear(jid);
end;

{---------------------------------------}
procedure ClearAllRoomLogs();
var
    logger: IExodusLogger;
begin
    logger := ExCOMController.RoomLogger;
    if (logger <> nil) then
        logger.Purge();
end;

{---------------------------------------}
procedure LogMessage(msg: TJabberMessage);
var
    logger: IExodusLogger;
    m: TExodusLogMsg;
begin
    if (msg.MsgType = 'groupchat') then
        logger := ExCOMController.RoomLogger
    else
        logger := ExCOMController.ContactLogger;

    if (logger = nil) then exit;

    m := TExodusLogMsg.Create(msg);
    logger.LogMessage(m);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function getDisplayField(fld: string): string;
begin
    // send back "well formatted" field names

    if (fld = 'nick') then result := _('Nickname:')
    else if (fld = 'first') then result := _('First Name:')
    else if (fld = 'last') then result := _('Last Name:')
    else if (fld = 'email') then result := _('EMail Address:')
    else if (fld = 'password') then result := _('Password')
    else if (fld = 'username') then result := _('UserName:')
    else
        result := fld;
end;

Procedure DebugMsgBox(msg : string);
begin
//    Application.MessageBox(PChar(msg), 'Debug');
end;

{---------------------------------------}
procedure DebugMsg(Message : string);
begin
//    DebugMessage(Message);
    MainSession.FireEvent('/data/debug', nil, Message);
end;

{---------------------------------------}
procedure URLLabel(lbl: TLabel);
begin
    AssignUnicodeURL(lbl.Font, 8);
end;

{---------------------------------------}
procedure URLLabel(lbl: TTntLabel);
begin
    AssignUnicodeURL(lbl.Font, 8);
end;

{---------------------------------------}
procedure AssignUnicodeFont(f: TFont; font_size: short);
begin
    // Assign either Arial or Arial Unicode MS to this form.
    if (unicode_font = nil) then begin
        unicode_font := TFont.Create();
        if (Screen.Fonts.IndexOf('Arial Unicode MS') < 0) then begin
            unicode_font.name := 'Arial';
            unicode_font.size := 8;
        end
        else begin
            unicode_font.Name := 'Arial Unicode MS';
            unicode_font.Size := 8;
        end;
    end;

    f.Name := unicode_font.name;

    if ((font_size = 0) or (font_size < 5)) then
        f.size := unicode_font.size
    else
        f.size := font_size;
end;

{---------------------------------------}
procedure AssignUnicodeHighlight(f: TFont; font_size: short);
begin
    AssignUnicodeFont(f, font_size);
    f.Color := clHighlightText;
    f.Style := [fsBold];
end;

{---------------------------------------}
procedure AssignUnicodeURL(f: TFont; font_size: short);
begin
    AssignUnicodeFont(f, font_size);
    f.Color := clBlue;
    f.Style := [fsUnderline];
end;

{---------------------------------------}
procedure AssignUnicodeFont(form: TForm; font_size: short);
begin
    AssignUnicodeFont(form.font, font_size);
end;

{---------------------------------------}
procedure AssignDefaultFont(font: TFont);
var
    cs: integer;
begin
    with MainSession.Prefs do begin
        Font.Name := getString('font_name');
        Font.Size := getInt('font_size');
        cs := getInt('font_charset');
        if cs <> 0 then
            Font.Charset := cs;

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
function secsToDuration(seconds: string): Widestring;
var
    d : integer;
    h : integer;
    m : integer;
    s : integer;
    day_str: Widestring;
    hrs_str: Widestring;
    min_str: Widestring;
    sec_str: Widestring;
begin
    s := StrToIntDef(seconds, -1);

    day_str := _('days');
    hrs_str := _('hours');
    min_str := _('minutes');
    sec_str := _('seconds');

    if (s < 0) then begin
        result := _(' unknown last result: ') + seconds
    end
    else if (s = 0) then begin
        result := ' 0 ' + sec_str;
    end
    else begin
        d := s div 86400;
        h := (s mod 86400) div 3600;
        m := ((s mod 86400) mod 3600) div 60;
        s := s mod 60;
        Result :=
            WideFormat(ngettext('%d day, ', '%d %s, ', d), [d, day_str]) +
            WideFormat(ngettext('%d hour, ', '%d %s, ', h), [h, hrs_str]) +
            WideFormat(ngettext('%d minute, ', '%d %s, ', m), [m, min_str]) +
            WideFormat(ngettext('%d second.', '%d %s.', s), [s, sec_str]);
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
    if (GlobalGetAtomName(a, buf, sizeof(buf)) = 0) then begin
        //raise Exception.Create('Global atom not found for: ' + IntToStr(a));
        result := MainSession.Status;
        exit;
    end;
    
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

{---------------------------------------}
function jabberSendCTCP(jid, xmlns: Widestring; callback: TPacketEvent): TJabberIQ;
var
    iq: TJabberIQ;
begin
    // Send an iq-get to some jid, with this namespace
    if (@callback = nil) then
        callback := frmExodus.CTCPCallback;
    iq := TJabberIQ.Create(MainSession, MainSession.generateID, callback);
    iq.iqType := 'get';
    iq.toJID := jid;
    iq.Namespace := xmlns;
    Result := iq;
    iq.Send();
end;

{---------------------------------------}
function getMemoText(memo: TMemo): WideString;
var
    len: integer;
    txt: PWideChar;
begin
    // Result := memo.Text;
    len := Length(memo.Text) + 1;
    txt := StrAllocW(len);
    GetWindowTextW(memo.Handle, txt, len);
    Result := WideString(txt);
end;

{---------------------------------------}
function trimNewLines(value: WideString): WideString;
var
    ins_list: TWideStringList;
    tmps: WideString;
    i: integer;
begin
    // Remove bogus whitespace, and use word-wrapping built
    // into the label control
    if (value = '') then
        Result := ''
    else begin
        tmps := Tnt_WideStringReplace(value, ''#13, '',[rfReplaceAll, rfIgnoreCase]);
        ins_list := TWideStringList.Create();
        split(tmps, ins_list, #10);
        tmps := '';
        for i := 0 to ins_list.Count - 1 do
            tmps := tmps + Trim(ins_list[i]) + ' ';
        Result := tmps;
        ins_list.Free();
    end;
end;

{---------------------------------------}
procedure jabberSendRosterItems(to_jid: WideString; items: TList);
var
    i: integer;
    b: WideString;
    msg, x, item: TXMLTag;
    ri: TJabberRosterItem;
begin
    msg := TXMLTag.Create('message');
    msg.setAttribute('id', MainSession.generateID());
    msg.setAttribute('to', to_jid);

    b := WideFormat(_(sMsgRosterItems), [items.Count]);
    x := msg.AddTag('x');
    x.setAttribute('xmlns', XMLNS_XROSTER);
    for i := 0 to items.Count - 1 do begin
        ri := TJabberRosterItem(items[i]);
        item := x.AddTag('item');
        item.setAttribute('jid', ri.jid.full);
        item.setAttribute('name', ri.Text);
        b := b + Chr(13) + Chr(10) + ri.Text + ': ' + ri.jid.getDisplayFull();
    end;

    jabberSendMsg(to_jid, msg, x, b, '');
end;

{---------------------------------------}
function getInputText(Input: TExRichEdit): Widestring;
var
    i: integer;
begin
    // get a single properly formatted widestring from an input
    // RichEdit control
    Result := '';
    if (Input.WideLines.Count = 0) then exit;

    Result := Input.WideText;
    for i := Length(Result) downto 1 do begin
        if (Result[i] = Chr(10)) then
            Delete(Result, i, 1)
        else if (Result[i] = Chr(11)) then
            Result[i] := Chr(13);
    end;
end;

{---------------------------------------}
procedure CanvasTextOutW(Canvas: TCanvas; X, Y: Integer; const Text: WideString;
    max_right: integer);
var
    tw, opts: integer;
    r: TRect;
begin
    // Use ExtTextOutW:
    // function ExtTextOutW(DC: HDC; X, Y: Integer; Options: Longint;
    //   Rect: PRect; Str: PWideChar; Count: Longint; Dx: PInteger): BOOL; stdcall;
    tw := CanvasTextWidthW(Canvas, Text) + 1;
    if (Canvas.CanvasOrientation = coRightToLeft) then
        Inc(X, tw);
    if ((max_right > 0) and (tw > max_right)) then begin
        r.Top := Y;
        r.Left := X;
        r.Right := max_right;
        r.Bottom := Y + 100;
        opts := Canvas.TextFlags + ETO_CLIPPED;
        Windows.ExtTextOutW(Canvas.Handle, X, Y, opts, @r,
            PWideChar(Text), Length(Text), nil);
        Canvas.MoveTo(r.right, Y);
    end
    else begin
        Windows.ExtTextOutW(Canvas.Handle, X, Y, Canvas.TextFlags, nil,
            PWideChar(Text), Length(Text), nil);
        Canvas.MoveTo(X + CanvasTextWidthW(Canvas, Text), Y);
    end;
end;

{---------------------------------------}
function CanvasTextWidthW(Canvas: TCanvas; const Text: WideString): integer;
var
    s: TSize;
begin
  s.cX := 0;
  s.cY := 0;
  Windows.GetTextExtentPoint32W(Canvas.Handle, PWideChar(Text), Length(Text), s);
  Result := s.cx;
end;

{---------------------------------------}
procedure removeSpecialGroups(grps: TStrings);
var
    i: integer;
begin
    i := grps.IndexOf(_(sGrpBookmarks));
    if (i >= 0) then grps.Delete(i);

    i := grps.IndexOf(_(sGrpUnfiled));
    if (i >= 0) then grps.Delete(i);

    i := grps.IndexOf(_(sGrpOffline));
    if (i >= 0) then grps.Delete(i);

    i := grps.IndexOf(MainSession.Prefs.getString('roster_transport_grp'));
    if (i >= 0) then grps.Delete(i);
end;

{---------------------------------------}
procedure removeSpecialGroups(grps: TWidestrings);
var
    i: integer;
begin
    i := grps.IndexOf(_(sGrpBookmarks));
    if (i >= 0) then grps.Delete(i);

    i := grps.IndexOf(_(sGrpUnfiled));
    if (i >= 0) then grps.Delete(i);

    i := grps.IndexOf(_(sGrpOffline));
    if (i >= 0) then grps.Delete(i);

    i := grps.IndexOf(MainSession.Prefs.getString('roster_transport_grp'));
    if (i >= 0) then grps.Delete(i);
end;

{---------------------------------------}
procedure removeSpecialGroups(grps: TTntStrings);
var
    i: integer;
begin
    i := grps.IndexOf(_(sGrpBookmarks));
    if (i >= 0) then grps.Delete(i);

    i := grps.IndexOf(_(sGrpUnfiled));
    if (i >= 0) then grps.Delete(i);

    i := grps.IndexOf(_(sGrpOffline));
    if (i >= 0) then grps.Delete(i);

    i := grps.IndexOf(MainSession.Prefs.getString('roster_transport_grp'));
    if (i >= 0) then grps.Delete(i);
end;


{---------------------------------------}
procedure jabberSendMsg(to_jid: Widestring; mtag: TXMLTag;
    xtags, body, subject: Widestring);
var
    stag, btag: TXMLTag;
    xml, s, b: Widestring;
begin
    // handle allowing the plugins to get a pass at all
    // outgoing messages
    b := body;
    s := subject;
    xml := ExCOMController.fireIM(to_jid, b, s, xtags);

    // don't put in two body elements.
    if (b <> '') then begin
        btag := (mtag.GetFirstTag('body'));
        if (btag = nil) then
            mtag.AddBasicTag('body', b)
        else begin
            btag.ClearCData();
            btag.AddCData(b);
        end;
    end;

    if (s <> '') then begin
        stag := (mtag.GetFirstTag('subject'));
        if (stag = nil) then
            mtag.AddBasicTag('subject', s)
        else begin
            stag.ClearCData();
            stag.AddCData(subject);
        end;
    end;

    if (xml <> '') then
        mtag.addInsertedXML(xml);

    MainSession.SendTag(mtag);
end;

{---------------------------------------}
procedure jabberSendMsg(to_jid: Widestring; mtag, xtags: TXMLTag;
    body, subject: Widestring);
begin
    jabberSendMsg(to_jid, mtag, xtags.xml, body, subject);
end;

{---------------------------------------}
function ForceForegroundWindow(hwnd: THandle): boolean;
const
    SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
    SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
    ForegroundThreadID: DWORD;
    ThisThreadID      : DWORD;
    timeout           : DWORD;
begin
    if IsIconic(hwnd) then ShowWindow(hwnd, SW_RESTORE);
    if GetForegroundWindow = hwnd then
        Result := true
    else begin
        // Windows 98/2000 doesn't want to foreground a window when some other
        // window has keyboard focus

        if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4))
            or
            ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
            ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
             (Win32MinorVersion > 0)))) then begin
            // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
            // Converted to Delphi by Ray Lischner
            // Published in The Delphi Magazine 55, page 16

            Result := false;
            ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow,nil);
            ThisThreadID := GetWindowThreadPRocessId(hwnd,nil);
            if AttachThreadInput(ThisThreadID, ForegroundThreadID, true) then begin
                BringWindowToTop(hwnd); // IE 5.5 related hack
                SetForegroundWindow(hwnd);
                AttachThreadInput(ThisThreadID, ForegroundThreadID, false);
                Result := (GetForegroundWindow = hwnd);
            end;

            if not Result then begin
                // Code by Daniel P. Stasinski
                SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
                SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0), SPIF_SENDCHANGE);
                BringWindowToTop(hwnd); // IE 5.5 related hack
                SetForegroundWindow(hWnd);
                SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
            end;
        end
        else begin
            BringWindowToTop(hwnd); // IE 5.5 related hack
            SetForegroundWindow(hwnd);
        end;

    Result := (GetForegroundWindow = hwnd);
    end;
end;

{---------------------------------------}
procedure CenterChildForm(f: TForm; anchor: TForm);
var
    x,y,l,t,h,w: integer;
begin
    // center the form over frmExodus..
    // but don't overlay edges.

    with anchor do begin
        x := Left + (Width div 2);
        y := Top + (Height div 2);
    end;

    h := f.Height;
    w := f.Width;

    if (h > Screen.Height) then
        h := Trunc(Screen.Height * 0.667);
    if (w > Screen.Width) then
        w := Trunc(Screen.Width * 0.667);

    l := x - (h div 2);
    t := y - (w div 2);

    if (t < 10) then
        t := anchor.Top + 10
    else if ((t + h) > Screen.Height) then
        t := Screen.Height - h - 10;

    if (l < 10) then
        l := anchor.Left + 10
    else if ((l + w) > Screen.Width) then
        l := Screen.Width - w - 10;

    f.SetBounds(l,t,w,h);
end;

{---------------------------------------}
procedure CenterMainForm(f: TForm);
begin
    CenterChildForm(f, frmExodus);
end;

{---------------------------------------}
procedure AssignTntStrings(sl: TWidestringlist; tnt: TTntStrings);
var
    i: integer;
begin
    tnt.Clear();
    for i := 0 to sl.Count - 1 do
        tnt.Add(sl[i])
end;


{---------------------------------------}
procedure BuildPresMenus(parent: TObject; clickev: TNotifyEvent);

    procedure ClearCustoms(mi: TMenuItem);
    var
        j: integer;
        s: TMenuItem;
    begin
        // This removes all old custom menu items
        for j := mi.Count - 1 downto 0 do begin
            s := mi.Items[j];
            if (s.Tag <> -1) then
                s.Free();
        end;
    end;

var
    plist: TWidestringList;
    grp, i: integer;
    mnu: TTntMenuItem;
    cp: TJabberCustompres;
    c, avail, chat, away, xa, dnd: TMenuItem;
    pm: TTntMenuItem;
    pp: TTntPopupMenu;
begin
    // Build the custom presence menus.
    // make sure to leave the main "Custom" entry and the divider

    // Parent is a has children, which have children..
    avail := nil;
    away := nil;
    xa := nil;
    dnd := nil;
    chat := nil;

    if (parent is TTntMenuItem) then begin
        pm := TTntMenuItem(Parent);
        for i := 0 to pm.Count - 1 do begin
            c := pm.Items[i];
            case c.tag of
            0: avail := c;
            1: chat := c;
            2: away := c;
            3: xa := c;
            4: dnd := c;
            else
                continue;
            end;
            ClearCustoms(c);
        end;
    end
    else if (parent is TTntPopupMenu) then begin
        pp := TTntPopupMenu(parent);
        for i := 0 to pp.Items.Count - 1 do begin
            c := pp.Items[i];
            case c.tag of
            0: avail := c;
            1: chat := c;
            2: away := c;
            3: xa := c;
            4: dnd := c;
            else
                continue;
            end;
            ClearCustoms(c);
        end;
    end;

    // Make sure we got them all.
    if ((avail = nil) or (chat = nil) or (away = nil) or (xa = nil) or (dnd = nil)) then exit;

    plist := MainSession.prefs.getAllPresence();
    for i := 0 to plist.count - 1 do begin
        cp := TJabberCustomPres(plist.Objects[i]);

        if (cp.show = 'chat') then begin
            grp := 4;
            c := chat;
        end
        else if (cp.show = 'away') then begin
            grp := 1;
            c := away;
        end
        else if (cp.Show = 'xa') then begin
            grp := 2;
            c := xa;
        end
        else if (cp.show = 'dnd') then begin
            grp := 3;
            c := dnd;
        end
        else begin
            grp := 0;
            c := avail;
        end;

        mnu := TTntMenuItem.Create(c);
        mnu.Caption := cp.title;
        mnu.tag := i;
        mnu.OnClick := clickev;
        mnu.ShortCut := TextToShortcut(cp.hotkey);
        mnu.GroupIndex := grp;
        c.Add(mnu);
        cp.Free();
    end;

    plist.Clear();
    plist.Free();

end;

{---------------------------------------}
function promptNewGroup: TJabberGroup;
var
    msg: Widestring;
    new_grp: WideString;
    go: TJabberGroup;
begin
    // Add a roster grp.
    Result := nil;

    new_grp := _(sDefaultGroup);
    msg := _(sNewGroupPrompt);

    if (MainSession.Prefs.getBool('nested_groups')) then
        msg := msg + ''#13#10 + WideFormat(_(sNewGroupNested),
            [MainSession.Prefs.getString('group_seperator')]);
    if InputQueryW(_(sNewGroup), msg, new_grp) = false then exit;

    // add the new grp.
    go := MainSession.Roster.getGroup(new_grp);
    if (go <> nil) then begin
        MessageDlgW(_(sNewGroupExists), mtError, [mbOK], 0);
        Result := nil;
    end
    else begin
        // add the new grp.
        Result := MainSession.Roster.addGroup(new_grp);
    end;
end;

{---------------------------------------}
procedure checkAndCenterForm(f: TForm);
var
    ok: boolean;
    dtop, tmp: TRect;
    cp: TPoint;
    m: TMonitor;
begin
    if (Assigned(Application.MainForm)) then
        Application.MainForm.Monitor;

    // Get the nearest monitor to the form
    tmp := f.BoundsRect;
    cp := CenterPoint(tmp);

    m := Screen.MonitorFromPoint(cp, mdNearest);
    if (m <> nil) then begin
        dtop := m.WorkareaRect;
    end
    else begin
        dtop := Screen.DesktopRect;
    end;

    ok := (tmp.Left >= dtop.Left) and
        (tmp.Right <= dtop.Right) and
        (tmp.Top >= dtop.Top) and
        (tmp.Bottom <= dtop.Bottom);

    if (ok = false) then begin
        // center it on the default monitor
        cp := CenterPoint(dtop);
        f.Left := cp.x - (f.Width div 2);
        f.Top := cp.y - (f.Height div 2);
    end;
end;

function IsUnicodeEnabled(): boolean;
var
    info: string;
    h: THandle;
    os: integer;
begin
    // check to see if we're an NT based OS, or we have
    // the unicode layer installed
    if (unicode_enabled = 0) then begin
        {
        1 = Win95
        2 = Win98
        3 = WinNT
        4 = W2k
        5 = Win ME
        6 = Win XP
        }
        os := WindowsVersion(info);
        if (os = 3) or (os = 4) or (os = 6) then
            unicode_enabled := +1
        else begin
            h := LoadLibrary('unicows.dll');
            if (h = 0) then
                unicode_enabled := -1
            else
                unicode_enabled := +1;
        end;
    end;

    if (unicode_enabled = 1) then
        Result := true
    else
        Result := false;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
initialization
    presenceToAtom := TStringList.Create();
    unicode_font := nil;
    unicode_enabled := 0;

finalization
    if (presenceToAtom <> nil) then begin
        FreeAtoms(presenceToAtom);
        presenceToAtom.Free();
    end;

    if (unicode_font <> nil) then
        unicode_font.Free();
end.

