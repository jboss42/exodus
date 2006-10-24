unit HtmlUtils;
{
    Functions moved from Exodus util libraries. Eliminates a number of Exodus
    depandancies within the plugin, helping to avoid compile time issues
}
interface
uses
    Dialogs, Graphics;

    function MessageDlgW(const Msg: Widestring; DlgType: TMsgDlgType;Buttons: TMsgDlgButtons): Word;
    function ColorToHTML( Color: TColor): string;
    function JabberToDateTime(datestr: Widestring): TDateTime;
    function MungeName(str: Widestring): Widestring;
    function HTML_EscapeChars(txt: Widestring; DoAPOS: boolean; DoQUOT: boolean): Widestring;
    
implementation
uses
    Windows, Forms, Controls, ShellAPI, SysUtils, Classes, 
    IdGlobal;

{
    Copied from JabberUtils to remove the dependancy
}
{---------------------------------------}
function MessageDlgW(const Msg: Widestring; DlgType: TMsgDlgType;Buttons: TMsgDlgButtons): Word;
var
    flags: Word;
    res: integer;
    tstr : WideString;
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

//commneted out to remove dependancy on prefcontroller
//    {$ifdef EXODUS}
//    res := MessageBoxW(Application.Handle, PWideChar(Msg), PWideChar(PrefController.getAppInfo.Caption),
//        flags);
//    {$else}
    tstr := Application.Title;
    res := MessageBoxW(Application.Handle, PWideChar(Msg), PWideChar(tstr), flags);
//    {$endif}

    case res of
    IDCANCEL: Result := mrCancel;
    IDNO: Result := mrNo;
    IDYES: Result := mrYes;
    else
        Result := mrOK;
    end;

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

{
    Copied from XMLUtils to eliminate that dependancy
}
{---------------------------------------}
function JabberToDateTime(datestr: Widestring): TDateTime;
var
    rdate: TDateTime;
    ys, ms, ds, ts: Widestring;
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

        if (TryEncodeDate(yw, mw, dw, rdate)) then begin
            rdate := rdate + StrToTime(ts);
            Result := rdate - TimeZoneBias();
        end
        else
            Result := Now();
    except
        Result := Now;
    end;
end;

{---------------------------------------}
function MungeName(str: Widestring): Widestring;
var
    i: integer;
    c, fn: Widestring;
begin
    // Munge some string into a filename
    // Removes all chars which aren't allowed
    fn := '';
    for i := 0 to Length(str) - 1 do begin
        c := str[i + 1];
        if ( (c='@') or (c=':') or (c='|') or (c='<') or
        (c='>') or (c='\') or (c='/') or (c='*') or (c=' ') ) then
            fn := fn + '_'
        else if (c > Chr(122)) then
            fn := fn + '_'
        else
            fn := fn + c;
    end;
    Result := fn;
end;

{---------------------------------------}
function HTML_EscapeChars(txt: Widestring; DoAPOS: boolean; DoQUOT: boolean): Widestring;
var
    tmps: Widestring;
    i: integer;
begin
    // escape special chars .. not &apos; --> only XML

    // Joe, Can we optimize this w/ regex please??
    // No.  Regexes don't do well where the replacement has to be different
    // based on the input.  Any regex would be N times slower than this.
    tmps := '';
    for i := 1 to length(txt) do begin
        if txt[i] = '&' then tmps := tmps + '&amp;'
        else if (txt[i] = Chr(39)) and (DoAPOS) then tmps := tmps + '&apos;'
        else if (txt[i] = '"') and (doQUOT) then tmps := tmps + '&quot;'
        else if txt[i] = '<' then tmps := tmps + '&lt;'
        else if txt[i] = '>' then tmps := tmps + '&gt;'
        else tmps := tmps + txt[i];
    end;
    Result := tmps;
end;


end.
