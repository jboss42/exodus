unit DebugLogger;

interface
uses
    XMLTag;
type

    TDebugLogFile = class
    private
        _filename : Widestring;
        _logfile  : TextFile;
        _cb: integer;
        procedure Init();
        procedure RotateLog();
        procedure DataCallback(event: string; tag: TXMLTag; data: Widestring);

    public
        constructor Create(filename: Widestring);
        destructor  Destroy(); override;
    end;

var
    debugLogFile : TDebugLogFile;

procedure StartDebugLogger(filename: Widestring);
procedure StopDebugLogger();

implementation
uses
    WideStrUtils,
    XMLParser,
    SysUtils, Session;
const
    MAX_BACKUPS = 5;
{---------------------------------------}
constructor TDebugLogFile.Create(filename: Widestring);
begin
    _filename := filename;
    Init();
end;

{---------------------------------------}
procedure TDebugLogFile.Init();
begin
    if (FileExists(_filename)) then begin
        // Rotate the log backups
        RotateLog();
    end;

    AssignFile(_logfile, _filename);
    Rewrite(_logfile);

    // Attach callbacks
    _cb := MainSession.RegisterCallback(DataCallback);
    
end;
{---------------------------------------}
destructor TDebugLogFile.Destroy();
begin
    MainSession.UnRegisterCallback(_cb);
    CloseFile(_logfile);
end;
{---------------------------------------}
procedure TDebugLogFile.RotateLog();
var
    i        : Integer;
    backfile : Widestring;
begin
    //Loop through log files and rotate backups
    for i := MAX_BACKUPS - 1 downto 0 do begin
        backfile := _filename;
        if (i > 0) then begin
            backfile := backfile + '.' + IntToStr(i);
            if (FileExists(backfile)) then begin
                DeleteFile(ChangeFileExt(backfile, '.' + IntToStr(i + 1)));
                RenameFile(backfile, ChangeFileExt(backfile, '.' + IntToStr(i + 1)));
            end;
        end
        else begin
            DeleteFile(backfile + '.1');
            RenameFile(backfile, backfile + '.1');
        end;
    end;
end;

function getObfuscatedData(event : String; tag : TXMLTag; data : WideString) : WideString;
const
    PASSWORD_NAME : WideString = 'password'; //don't localize
    XML_TAG       : WideString = '<';
var
    ptag        : TXMLTag;
    ctags       : TXMLTagList;
    xmlParser   : TXMLTagParser;
begin
    Result := data;
    if ((event = '/data/send') or (event = '/data/recv')) then begin
        //see if password is in string
        //conatins some refernce to password and starts with <, making it liekely this is xml
        if ((WStrPos(PWideChar(data), PWideChar(PASSWORD_NAME)) <> nil)  and (WStrPos(PWideChar(data), PWideChar(XML_TAG)) <> nil)) then begin
            //attempt ot build xml tag from data, so we can manipluate it...
            xmlParser := TXMLTagParser.Create();
            try
                xmlParser.ParseString(data, '');
                ptag := xmlParser.popTag;
                //get pass element
                ctags := ptag.QueryRecursiveTags(PASSWORD_NAME, true);
                if ((ctags.Count > 0) and (ctags[0].Data <> ''))then begin
                    ctags[0].ClearCData();
                    ctags[0].AddCData('*******');
                end;
                Result := ptag.XML;
                ptag.Free();
            finally
                xmlParser.Free();
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TDebugLogFile.DataCallback(event: string; tag: TXMLTag; data: Widestring);
var
    line : Widestring;
    time: string;
    tstr : WideString;
begin
    tstr := getObfuscatedData(event, tag, data);
    if (event = '/data/send') then begin
        if (Trim(tstr) <> '') then
            line := 'SENT: ' + tstr;
    end
    else if (event = '/data/debug') then begin
        line := tstr;
    end
    else
        line := 'RECV: ' + tstr;

    DateTimeToString(time, 'yyyy-mm-dd hh:mm:ss.zzz', Now());
    line := '[' + time + ']  ' + line + ''#13#10;
    WRITE(_logfile, line);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure StartDebugLogger(filename: Widestring);
begin
    if (debugLogFile = nil) then
        debugLogFile := TDebugLogFile.Create(filename);
end;

{---------------------------------------}
procedure StopDebugLogger();
begin
    if (debugLogFile <> nil) then
        FreeAndNil(debugLogFile);

end;

end.
