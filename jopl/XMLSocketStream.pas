unit XMLSocketStream;
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
    XMLTag, XMLStream, PrefController,

    {$ifdef linux}
    QExtCtrls, IdSSLIntercept,
    {$else}
    ExtCtrls, IdSSLOpenSSL,
    {$endif}

    IdTCPConnection, IdTCPClient, IdException, IdThread, IdSocks,
    SysUtils, SyncObjs;

type
    TSocketThread = class;
    TXMLSocketStream = class(TXMLStream)
    private
        _socket:    TidTCPClient;
        _sock_lock: TCriticalSection;
        {$ifdef Linux}
            _ssl_int: TIdSSLConnectionIntercept;
        {$else}
            {$ifdef INDY9}
            _ssl_int: TIdSSLIOHandlerSocket;
            _socks_info: TIdSocksInfo;
            {$else}
            _ssl_int: TIdConnectionInterceptOpenSSL;
            _socks_info: TObject;
            {$endif}
        {$endif}
        _ssl_check: boolean;
        _ssl_ok:    boolean;
        _timer:     TTimer;
        _profile:   TJabberProfile;
        _cert:      TIdX509;

        {$ifdef Win32}
        procedure VerifyUI();
        function VerifyPeer(Certificate: TIdX509): Boolean;
        {$endif}
        procedure Keepalive(Sender: TObject);
        procedure KillSocket();

    protected
        // TODO: make this a real event handler, so that other subclasses
        // know how to get these events more explicitly.
        procedure MsgHandler(var msg: TJabberMsg); message WM_JABBER;

    public
        constructor Create(root: String); override;
        destructor Destroy; override;

        procedure Connect(profile: TJabberProfile); override;
        procedure Send(xml: Widestring); override;
        procedure Disconnect; override;
    end;


    TSocketThread = class(TParseThread)
    private
        _socket: TidTCPClient;
        _stage: integer;
        _data: WideString;

    protected
        procedure Run; override;
        procedure Sock_Connect(Sender: TObject);
        procedure Sock_Disconnect(Sender: TObject);
    public
        // I don't think this needs reintroduce.
        // constructor Create(wnd: HWND; Socket: TidTCPClient; root: string); reintroduce;
        constructor Create(strm: TXMLStream; Socket: TidTCPClient; root: string); //reintroduce;

        procedure DataTerminate (Sender: TObject);
        procedure GotException (Sender: TIdThread; E: Exception);

    end;
implementation

uses
    {$ifdef Win32}
    // todo: REMOVE this dependency!!
    Controls, Dialogs,
    {$endif}
    Classes;
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
    utf: string;
    buff: WideString;
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
            _socket.CheckForGracefulDisconnect(false);
            if (not _socket.ClosedGracefully) then begin
                _socket := nil;
                doMessage(WM_COMMERROR);
                end
            else begin
                _socket := nil;
                doMessage(WM_DISCONNECTED);
                end;
            Self.Terminate;
            end
        else begin
            // Get any pending incoming data
            utf := _Socket.CurrentReadBuffer;
            buff := UTF8Decode(utf);

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
procedure TSocketThread.GotException(Sender: TIdThread; E: Exception);
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
            end
        else begin
            _Data := E.Message;
            doMessage(WM_COMMERROR);
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

    _ssl_int    := nil;
    _ssl_check  := false;
    _ssl_ok     := false;
    _socket     := nil;
    _sock_lock  := TCriticalSection.Create();
    _socks_info := nil;

    _timer := TTimer.Create(nil);
    _timer.Interval := 60000;
    _timer.Enabled := false;
    _timer.OnTimer := KeepAlive;
end;

{---------------------------------------}
destructor TXMLSocketStream.Destroy;
begin
    inherited;

    _timer.Free();

    KillSocket();
    _sock_lock.Free;
end;

{$ifdef Win32}
procedure TXMLSocketStream.VerifyUI();
var
    sl : TStringList;
    i  : integer;
    n  : TDateTime;
begin
    sl := TStringList.Create();
    sl.Delimiter := '/';
    sl.QuoteChar := #0;
    sl.DelimitedText := _cert.Subject.OneLine;

    _ssl_ok := false;
    for i := 0 to sl.Count - 1 do begin
        if (sl[i] = ('CN=' + _profile.Server)) then begin
            _ssl_ok := true;
            break;
            end;
        end;
    sl.Free();

    // TODO: timing.  really shouldn't have graphics here, also.
    if (not _ssl_ok) then begin
        _ssl_ok := false;
        MessageDlg('Certificate does not match host: ' +
                   _cert.Subject.OneLine,
                   mtWarning, [mbOK], 0);
        end;

    // TODO: check issuer.
    n := Now();
    if (n < _cert.NotBefore) then begin
        _ssl_ok := false;
        MessageDlg('Certificate not valid until ' + DateTimeToStr(_cert.NotBefore),
                               mtWarning, [mbOK], 0);
        end;

    if (n > _cert.NotAfter) then begin
        _ssl_ok := false;
        MessageDlg('Certificate expired on ' + DateTimeToStr(_cert.NotAfter),
                               mtWarning, [mbOK], 0);
        end;
end;

function TXMLSocketStream.VerifyPeer(Certificate: TIdX509): Boolean;
begin
    if (not _ssl_check) then begin
        _cert := Certificate;
        _thread.synchronize(VerifyUI);
        _ssl_check := true;
        end;

    result := _ssl_ok;
end;
{$endif}

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
    tmps: WideString;
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
            {$ifdef INDY9}
            _local_ip := _socket.BoundIP;
            {$else}
            _local_ip := _Socket.Binding.IP;
            {$endif}
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

            // show the exception
            DoDataCallbacks(false, tmps);

            _timer.Enabled := false;
            _active := false;
            _thread := nil;
            DoCallbacks('commerror', nil);
            DoCallbacks('disconnected', nil);
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
procedure TXMLSocketStream.Connect(profile: TJabberProfile);
begin
    _profile := profile;

    {$ifdef Linux}
    _ssl_int := TIdSSLConnectionIntercept.Create(nil);
    {$else}
    {$ifdef INDY9}
    _ssl_int := TIdSSLIOHandlerSocket.Create(nil);
    _socks_info := TIdSocksInfo.Create(nil);
    {$else}
    _ssl_int := TIdConnectionInterceptOpenSSL.Create(nil);
    {$endif}
    with _ssl_int do begin
        // TODO: get certs from profile
        // that would be *cool*.
        SSLOptions.CertFile := '';
        SSLOptions.RootCertFile := '';
        SSLOptions.VerifyMode := [sslvrfPeer, sslvrfFailIfNoPeerCert];
        SSLOptions.VerifyDepth := 2;
        SSLOptions.Method :=  sslvSSLv23;
        OnVerifyPeer := VerifyPeer;
        end;
    {$endif}

    // connect to this server
    _socket := TIdTCPClient.Create(nil);
    _socket.RecvBufferSize := 4096;
    _socket.Port := _profile.port;
    {$ifdef INDY9}
    if (_profile.ssl) then
        _socket.IOHandler := _ssl_int;
    {$else}
    _socket.Intercept := _ssl_int;
    _socket.InterceptEnabled := _profile.ssl;
    {$endif}

    _server := _profile.Server;
    if (_profile.Host = '') then
        _socket.Host := _profile.Server
    else
        _socket.Host := _profile.Host;

    if (_profile.SocksType = 0) then begin
        // don't do anything here??
        // _socket.Intercept := _ssl_int;
        end
    else begin
        {$ifdef INDY9}
        with _socks_info do begin
        {$else}
        with _socket.SocksInfo do begin
        {$endif}
            case _profile.SocksType of
            1: Version := svSocks4;
            2: Version := svSocks4a;
            3: Version := svSocks5;
            end;
            Host := _profile.SocksHost;
            Port := _profile.SocksPort;
            if (_profile.SocksAuth) then begin
                {$ifdef INDY9}
                _socks_info.Username := _profile.SocksUsername;
                _socks_info.Password := _profile.SocksPassword;
                {$else}
                UserID := _profile.SocksUsername;
                Password := _profile.SocksPassword;
                {$endif}
                Authentication := saUsernamePassword;
                end;
            end;
        end;

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
        {$ifndef INDY9}
        _socket.InterceptEnabled := false;
        _socket.Intercept := nil;
        {$endif}

        if (_ssl_int <> nil) then begin
            _ssl_int.Free();
            _ssl_int := nil;
            end;

        _socket.Free();
        _socket := nil;
        end;

    _sock_lock.Release();
end;

{---------------------------------------}
procedure TXMLSocketStream.Send(xml: Widestring);
var
    buff: UTF8String;
begin
    // Send this text out the socket
    DoDataCallbacks(true, xml);
    buff := UTF8Encode(xml);
    _Socket.Write(buff);
    _timer.Enabled := false;
    _timer.Enabled := true;
end;

end.
