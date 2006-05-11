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

{---------------------------------------}
procedure TDebugLogFile.DataCallback(event: string; tag: TXMLTag; data: Widestring);
var
    line : Widestring;
    time: string;
begin
    if (event = '/data/send') then begin
        if (Trim(data) <> '') then
            line := 'SENT: ' + data;
    end
    else if (event = '/data/debug') then begin
        line := data;
    end
    else
        line := 'RECV: ' + data;

    DateTimeToString(time, 'yyyy-mm-dd hh:mm:ss.zzz', Now());
    line := '[' + time + ']  ' + line + ''#13#10;
    WRITELN(_logfile, line);
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
