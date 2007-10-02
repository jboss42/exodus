unit DebugManager;

interface

uses
	Classes,
    Unicode,
    XMLTag,
    SysUtils;

type
	IDebugLogger = interface (IInterface)
        procedure DebugStatement(msg: Widestring; dt: TDateTime);
        procedure DataSent(xml: TXMLTag; data: Widestring; dt: TDateTime);
        procedure DataRecv(xml: TXMLTag; data: Widestring; dt: TDateTime);
	end;
  	
  	TDebugManager = class
  	private
  		// Variables
        _dbglist: TWidestringList;
  		
  		// Methods

  	protected
  		// Variables
        _dataCB: integer;

  		// Methods
        function _getInterface(obj: TObject): IDebugLogger;

  	public
  		// Variables
  		
  		// Methods
        procedure DataCallback(event: string; tag: TXMLTag; data: Widestring);
        procedure AddDebugger(debuggerName: widestring; debugger: TObject);
        procedure RemoveDebugger(debuggerName: widestring);
        procedure DebugStatement(msg: Widestring);

  		// Constructor/Destructor
		constructor Create();
        destructor Destroy(); Override;

  	published
  		// Variables

  		// Methods

  	end;

procedure DebugMessage(txt: Widestring);
procedure StartDBGManager();
procedure StopDBGManager();

var
    dbgManager: TDebugManager;

implementation

uses
    Session,
    DebugLogger,
    Debug;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TDebugManager.Create();
begin
	inherited;

    _dbglist := TWideStringList.Create();
    _dataCB := MainSession.RegisterCallback(DataCallback);
end;

{---------------------------------------}
destructor TDebugManager.Destroy();
begin
    MainSession.UnRegisterCallback(_dataCB);
    _dbglist.Clear();
    _dbglist.Free();
end;

{---------------------------------------}
procedure TDebugManager.DataCallback(event: string; tag: TXMLTag; data: Widestring);
var
    i: integer;
    debugger: IDebugLogger;
begin
    for i := 0 to _dbglist.Count - 1 do begin
        debugger := _getInterface(_dbglist.Objects[i]);
        if (debugger <> nil) then begin
            if (event = '/data/debug') then begin
                if (Trim(data) <> '') then
                    debugger.DebugStatement(data, Now());
            end
            else if (event = '/data/send') then begin
                debugger.DataSent(tag, data, Now());
            end
            else if (event = '/data/recv') then begin
                debugger.DataRecv(tag, data, Now());
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TDebugManager.AddDebugger(debuggerName: widestring; debugger: TObject);
var
    temp: IDebugLogger;
begin
    _dbglist.AddObject(debuggerName, debugger);
    temp := _getInterface(debugger);
    temp._AddRef;
end;

{---------------------------------------}
procedure TDebugManager.RemoveDebugger(debuggerName: Widestring);
var
    index: integer;
begin
    index := _dbglist.IndexOf(debuggerName);
    if (index >= 0) then begin
        _dbglist.Delete(index);
    end;
end;

{---------------------------------------}
procedure TDebugManager.DebugStatement(msg: Widestring);
var
    i: integer;
    debugger: IDebugLogger;
begin
    if (Trim(msg) = '') then exit;
    
    for i := 0 to _dbglist.Count - 1 do begin
        debugger := _getInterface(_dbglist.Objects[i]);
        if (debugger <> nil) then begin
            debugger.DebugStatement(msg, Now());
        end;
    end;
end;

{---------------------------------------}
function TDebugManager._getInterface(obj: TObject): IDebugLogger;
begin
    Result := nil;

    if (obj is TDebugLogFile) then
        Result := TDebugLogFile(obj)
    else if (obj is TfrmDebug) then
        Result := TfrmDebug(obj);
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure DebugMessage(txt: Widestring);
begin
    dbgManager.DebugStatement(txt);
end;

{---------------------------------------}
procedure StartDBGManager();
begin
    if (dbgManager = nil) then
        dbgManager := TDebugManager.Create();
end;

{---------------------------------------}
procedure StopDBGManager();
begin
    dbgManager.Free();
    dbgManager := nil;
end;

end.
