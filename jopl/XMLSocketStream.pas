unit XMLSocketStream;


interface
uses
    XMLTag,
    XMLUtils,
    XMLParser,
    XMLStream,
    LibXMLParser,
    {$ifdef linux}
    QForms, QExtCtrls,
    {$else}
    Forms, Messages, Windows, StdVcl, ExtCtrls,
    {$endif}
    SysUtils, IdThread, IdException, IdSSLOpenSSL,
    IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
    SyncObjs, Classes;

type
    TSocketThread = class;
    TXMLSocketStream = class(TXMLStream)
    private
        _socket:    TidTCPClient;
        _sock_lock: TCriticalSection;
        _ssl_int:   TIdConnectionInterceptOpenSSL;
        _timer:     TTimer;

        procedure Keepalive(Sender: TObject);
        procedure KillSocket();

    protected
        // TODO: make this a real event handler, so that other subclasses
        // know how to get these events more explicitly.
        procedure MsgHandler(var msg: TJabberMsg); message WM_JABBER;

    public
        constructor Create(root: String); override;
        destructor Destroy; override;

        procedure Connect(server: string; port: integer; use_ssl: boolean = false); override;
        procedure Send(xml: string); override;
        procedure Disconnect; override;
    end;


    TSocketThread = class(TParseThread)
    private
        _socket: TidTCPClient;
        _stage: integer;
        _data: String;

    protected
        procedure Run; override;
        procedure Sock_Connect(Sender: TObject);
        procedure Sock_Disconnect(Sender: TObject);
    public
        // I don't think this needs reintroduce.
        // constructor Create(wnd: HWND; Socket: TidTCPClient; root: string); reintroduce;
        constructor Create(strm: TXMLStream; Socket: TidTCPClient; root: string); //reintroduce;

        procedure DataTerminate (Sender: TObject);
        procedure GotException (Sender: TObject; E: Exception);

    end;
implementation

{---------------------------------------}
{      TSocketThread Class                }
{---------------------------------------}
constructor TSocketThread.Create(strm: TXMLStream; Socket: TidTCPClient; root: string);
begin
    inherited Create(strm, root);
    _Socket := Socket;
    _Socket.OnConnected := Sock_Connect;
    _Socket.OnDisconnected := Sock_Disconnect;

    OnException := GotException;
    OnTerminate := DataTerminate;

    _Stage := 0;
    _Data := '';
end;

{---------------------------------------}
procedure TSocketThread.DataTerminate(Sender: TObject);
begin
    // destructor for the thread
    CleanUp();
end;


{---------------------------------------}
procedure TSocketThread.Run;
var
    bytes: longint;
    utf, buff: string;
begin
    {
    This procedure gets run continuously, until
    the the thread is told to stop.

    Read stuff from the socket and feed it into the
    parser.
    }
    if _Stage = 0 then begin
        // try to connect
        if (_socket.Connected) then
            _Socket.Disconnect();

        _Socket.Connect;
        {
        If we successfully connect, change the stage of the
        thread so that we switch to reading the socket
        instead of trying to connect.

        If we can't connect, an exception will be thrown
        which will cause the GotException method of the
        thread to fire, since we don't have to explicitly
        catch exceptions in this thread.
        }
        _Stage := 1;
        end
    else begin
        // Read in the current buffer, yadda.
        if (_socket = nil) then
            Self.Terminate
        else if not _Socket.Connected then begin
            _socket := nil;
            doMessage(WM_DISCONNECTED);
            Self.Terminate;
            end
        else begin
            // Get any pending incoming data
            utf := _Socket.CurrentReadBuffer;
            buff := Utf8ToAnsi(utf);

            // We are shutting down, or we've got an exception, so just bail
            if ((Self.Stopped) or (Self.Suspended) or (Self.Terminated)) then
                exit;

            bytes := length(buff);
            if bytes > 0 then
                // stuff the socket data into the stream
                // add the raw txt to the indata list
                Push(buff);
            end;
        end;
end;

{---------------------------------------}
procedure TSocketThread.Sock_Connect(Sender: TObject);
begin
    // Socket is connected, signal the main thread
    doMessage(WM_CONNECTED);
end;

{---------------------------------------}
procedure TSocketThread.Sock_Disconnect(Sender: TObject);
begin
    // Socket is disconnected
end;

{---------------------------------------}
procedure TSocketThread.GotException(Sender: TObject; E: Exception);
var
    se: EIdSocketError;
begin
    // Handle gracefull connection closures
    if _Stage = 0 then begin
        // We can't connect
        _socket := nil;
        if E is EIdSocketError then
            _Data := 'Could not connect to the server.'
        else
            _Data := 'Exception: ' + E.Message;
        doMessage(WM_COMMERROR);
    end
    else begin
        // Some exception occured during Read ops
        _socket := nil;
        if E is EIdConnClosedGracefully then exit;

        if E is EIdSocketError then begin
            se := E as EIdSocketError;
            if se.LastError = 10038 then
                // normal disconnect
                doMessage(WM_DISCONNECTED)
            else begin
                // some other socket exception
                _Data := E.Message;
                doMessage(WM_COMMERROR);
                end;
            end;

        // reset the stage
        _Stage := 0;
        end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TXMLSocketStream.Create(root: string);
begin
    {
    Create a window handle for sending messages between
    the thread reader socket and the main object.

    Also create the socket here, and setup the callback lists.
    }
    inherited;

    // todo: Create the SSL int. JIT
    _ssl_int := TIdConnectionInterceptOpenSSL.Create(nil);
    with _ssl_int do begin
        SSLOptions.CertFile := '';
        SSLOptions.RootCertFile := '';
        end;

    _socket := nil;
    _sock_lock := TCriticalSection.Create();

    _timer := TTimer.Create(nil);
    _timer.Interval := 60000;
    _timer.Enabled := false;
    _timer.OnTimer := KeepAlive;
end;

{---------------------------------------}
destructor TXMLSocketStream.Destroy;
begin
    inherited;

    _ssl_int.Free();
    _timer.Free();

    KillSocket();
    _sock_lock.Free;
end;

{---------------------------------------}
procedure TXMLSocketStream.Keepalive(Sender: TObject);
var
    xml: string;
begin
    // send a keep alive
    if _socket.Connected then begin
        xml := '    ';
        DoDataCallbacks(true, xml);
        _socket.Write(xml);
        end;
end;

{---------------------------------------}
procedure TXMLSocketStream.MsgHandler(var msg: TJabberMsg);
var
    tmps: string;
    tag: TXMLTag;
begin
    {
    handle all of our funky messages..
    These are window msgs put in the stack by the thread so that
    we can get thread -> mainprocess IPC
    }
    case msg.lparam of
        WM_CONNECTED: begin
            // Socket is connected
            _local_ip := _Socket.Binding.IP;
            _active := true;
            _timer.Enabled := true;
            DoCallbacks('connected', nil);
            end;

        WM_DISCONNECTED: begin
            // Socket is disconnected
            KillSocket();
            if (_thread <> nil) then
                _thread.Terminate();
            _timer.Enabled := false;
            _active := false;
            _thread := nil;
            DoCallbacks('disconnected', nil);
            end;

        WM_SOCKET: begin
            // We are getting something on the socket
            tmps := _thread.Data;
            if tmps <> '' then
                DoDataCallbacks(false, tmps);
            end;

        WM_XML: begin
            // We are getting XML data from the thread
            if _thread = nil then exit;

            tag := _thread.GetTag;
            if tag <> nil then begin
                DoCallbacks('xml', tag);
                end;
            end;

        WM_COMMERROR: begin
            // There was a COMM ERROR
            KillSocket();
            if _thread <> nil then
                tmps := _thread.Data
            else
                tmps := '';

            _timer.Enabled := false;
            _active := false;
            _thread := nil;
            DoCallbacks('disconnected', nil);
            DoCallbacks('commerror', nil);
            end;

        WM_DROPPED: begin
            // something dropped our connection
            if (_socket.Connected) then
                _socket.Disconnect();
            _thread := nil;
            _timer.Enabled := false;
            end;

        else
            inherited;
    end;
end;

{---------------------------------------}
procedure TXMLSocketStream.Connect(server: string; port: integer; use_ssl: boolean = false);
begin
    // connect to this server
    _socket := TIdTCPClient.Create(nil);
    _socket.Intercept := _ssl_int;
    _socket.InterceptEnabled := false;
    _socket.RecvBufferSize := 4096;

    _server := Server;
    _port := port;
    _socket.Host := Server;
    _socket.Port := port;
    _Socket.InterceptEnabled := use_ssl;

    // Create the socket reader thread and start it.
    // The thread will open the socket and read all of the data.
    _thread := TSocketThread.Create(Self, _socket, _root_tag);
    _thread.Start;
end;

{---------------------------------------}
procedure TXMLSocketStream.Disconnect;
begin
    // Disconnect the stream and stop the thread
    _timer.Enabled := false;
    if ((_socket <> nil) and (_socket.Connected)) then begin
        _socket.Disconnect();
        end;
end;

{---------------------------------------}
procedure TXMLSocketStream.KillSocket();
begin
    _sock_lock.Acquire();

    if (_socket <> nil) then begin
        _socket.Free();
        _socket := nil;
        end;

    _sock_lock.Release();
end;

{---------------------------------------}
procedure TXMLSocketStream.Send(xml: string);
var
    utf: string;
begin
    // Send this text out the socket
    utf := AnsiToUTF8(xml);
    DoDataCallbacks(true, utf);
    _Socket.Write(utf);
    _timer.Enabled := false;
    _timer.Enabled := true;
end;

end.
