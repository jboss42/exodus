unit XMLStream;
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
    XMLTag,
    XMLUtils,
    XMLParser, 
    LibXMLParser,
    {$ifdef linux}
    QForms, QExtCtrls,
    {$else}
    Forms, Messages, Windows, StdVcl, ExtCtrls,
    {$endif}
    SysUtils, IdThread, IdException,
    IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
    SyncObjs, Classes;

const
    {$ifdef linux}
    WM_USER = 0;
    {$endif}

    WM_JABBER = WM_USER + 5222;

    WM_XML = WM_USER + 7001;
    WM_HTTPPROXY = WM_USER + 7002;
    WM_COMMERROR = WM_USER + 7003;
    WM_DROPPED = WM_USER + 7004;
    WM_CONNECTED = WM_USER + 7006;
    WM_DISCONNECTED = WM_USER + 7007;
    WM_SEND = WM_USER + 7008;
    WM_SOCKET = WM_USER + 7010;

type
    TDataThread = class;

    EXMLStream = class(Exception)
    public
    end;

    TJabberMsg = record
        msg: Cardinal;
        lparam: integer;
    end;

    TSocketCallback = procedure (send: boolean; data: string) of object;
    TXMLStreamCallback = procedure (msg: string; tag: TXMLTag) of object;

    TXMLStream = class
    private
        _root_tag: string;
        _socket: TidTCPClient;
        _thread: TDataThread;
        _timer: TTimer;
        _callbacks: TList;
        _sock_callbacks: TList;
        _Server: string;
        _port: integer;
        _active: boolean;
        _LocalIP: string;

        procedure DoCallbacks(msg: string; tag: TXMLTag);
        procedure DoSocketCallbacks(send: boolean; data: string);
        procedure Keepalive(Sender: TObject);
    protected
        // procedure WndProc(var msg: TMessage);
        procedure MsgHandler(var msg: TJabberMsg); message WM_JABBER;
    public
        constructor Create(root: String);
        destructor Destroy; override;

        procedure Connect(server: string; port: integer); virtual;
        procedure Send(xml: string);
        procedure SendTag(tag: TXMLTag);
        procedure Disconnect;

        procedure RegisterStreamCallback(p: TXMLStreamCallback);
        procedure RegisterSocketCallback(p: TSocketCallback);

        property Active: boolean read _active;
        property LocalIP: string read _LocalIP;
    end;

    TDataThread = class(TIdThread)
    private
        _lock: TCriticalSection;
        _socket: TidTCPClient;
        _stage: integer;
        _data: String;
        _root_tag: string;
        _root_len: integer;
        _indata: TStringlist;
        _stream: TXMLStream;
        _tag_parser: TXMLTagParser;
        _counter: integer;
        _rbuff: string;
        _root: string;
        _domstack: TList;

        _cur_msg: TJabberMsg;

        procedure ParseTags(buff: string);
        procedure handleBuffer(buff: string);
        procedure DispatchMsg;

        function getFullTag(buff: string): string;
        function GetData: string;

    protected
        procedure Run; override;
        procedure doMessage(msg: integer);
        procedure Sock_Connect(Sender: TObject);
        procedure Sock_Disconnect(Sender: TObject);
    public
        // constructor Create(wnd: HWND; Socket: TidTCPClient; root: string); reintroduce;
        constructor Create(strm: TXMLStream; Socket: TidTCPClient; root: string); reintroduce;

        procedure DataTerminate (Sender: TObject);
        procedure GotException (Sender: TObject; E: Exception);

        function GetTag: TXMLTag;

        property Data: string read GetData;
    end;

implementation
uses
    Signals, 
    Math;

{---------------------------------------}
{      TDataThread Class                }
{---------------------------------------}
constructor TDataThread.Create(strm: TXMLStream; Socket: TidTCPClient; root: string);
begin
    // Create a new thread and setup the socket events
    inherited  Create(True);

    _Stream := strm;
    _Socket := Socket;
    _root_tag := root;
    _root_len := Length(_root_tag);

    _Socket.OnConnected := Sock_Connect;
    _Socket.OnDisconnected := Sock_Disconnect;

    FreeOnTerminate := true;
    StopMode := smSuspend;

    OnException := GotException;
    OnTerminate := DataTerminate;

    _Stage := 0;
    _Data := '';
    _rbuff := '';
    _root := '';
    _counter := 0;
    _indata := TStringList.Create;
    _tag_parser := TXMLTagParser.Create;
    _domstack := TList.Create;
    _lock := TCriticalSection.Create;
end;

{---------------------------------------}
procedure TDataThread.DataTerminate(Sender: TObject);
begin
    // We have an exception, kill the thread and the socket
    if (_Socket = nil) or (not _Socket.Connected) then begin
        Self.Terminate;
        end
    else if (_Socket <> nil) and (_Socket.Connected) then begin
        _Data := 'Reader socket terminated.';
        doMessage(WM_DROPPED);
        end;
end;

{---------------------------------------}
procedure TDataThread.doMessage(msg: integer);
begin
    _cur_msg.msg := WM_JABBER;
    _cur_msg.lparam := msg;

    Synchronize(Self.DispatchMsg);
end;

{---------------------------------------}
procedure TDataThread.DispatchMsg;
begin
    _stream.Dispatch(_cur_msg);
end;

{---------------------------------------}
procedure TDataThread.Run;
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
        if not _Socket.Connected then begin
            doMessage(WM_COMMERROR);
            Self.Terminate;
            end
        else begin
            // Get any pending incoming data
            utf := _Socket.CurrentReadBuffer;
            buff := Utf8ToAnsi(utf);

            if ((Self.Stopped) or (Self.Suspended) or (Self.Terminated)) then
                exit;

            bytes := length(buff);
            if bytes > 0 then begin
                // stuff the socket data into the stream
                // add the raw txt to the indata list
                _lock.Acquire;
                _indata.Add(buff);
                _lock.Release;

                doMessage(WM_SOCKET);

                if (Copy(buff, 1, _root_len + 2) = '</' + _root_tag) then
                    doMessage(WM_DROPPED)
                else begin
                    handleBuffer(buff);
                    end;
                end;
            end;
        end;
end;

{---------------------------------------}
function TDataThread.GetData: string;
begin
    {
    Suck some data off of the _indata stack and return it.
    Make sure we lock around this since the stringlist is not
    thread safe.
    }
    _lock.Acquire;
    if _indata.Count > 0 then begin
        Result := _indata[0];
        _indata.Delete(0);
        end
    else
        Result := '';
    _lock.Release;
end;

{---------------------------------------}
function TDataThread.GetTag: TXMLTag;
begin
    {
    Suck an entire TXMLTag object off of the _domstack list
    and return it. Make sure we lock around this since TList's
    are not thread safe.
    }
    Result := nil;
    if _domstack.count <= 0 then exit;

    // _lock.Acquire;
    Result := TXMLTag(_domstack[0]);
    _domstack.Delete(0);
    // _lock.Release;
end;

{---------------------------------------}
procedure TDataThread.Sock_Connect(Sender: TObject);
begin
    // Socket is connected, signal the main thread
    doMessage(WM_CONNECTED);
end;

{---------------------------------------}
procedure TDataThread.Sock_Disconnect(Sender: TObject);
begin
    // Socket is disconnected
end;

{---------------------------------------}
procedure TDataThread.GotException(Sender: TObject; E: Exception);
var
    se: EIdSocketError;
begin
    // Handle gracefull connection closures
    if _Stage = 0 then begin
        // We can't connect
        if E is EIdSocketError then
            _Data := 'Could not connect to the server.'
        else
            _Data := 'Exception: ' + E.Message;
        doMessage(WM_COMMERROR);
    end
    else begin
        // Some exception occured during Read ops
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
function TDataThread.getFullTag(buff: string): string;
var
    // pbuff: array of char;
    sbuff, r, stag, etag, tmps: String;
    p, ls, le, e, l, ps, pe, ws, sp, tb, cr, nl, i: longint;
begin
    // init some counters, flags
    {
    List of wierd XML issues:

    <?xml version="1.0" standalone='yes'?>
    <!ELEMENT foo >
    <!ATTLIST bar >
    <!--  foo bar -->

    }
    e := 0;
    i := 0;
    _counter := 0;
    Result := '';
    sbuff := buff;
    l := Length(sbuff);

    if _root = '' then begin
        // snag the first tag off the front
        p := Pos('<', sbuff);

        if p <= 0 then raise EXMLStream.Create('');

        tmps := Copy(sbuff, p, l - p + 1);
        e := Pos('>', tmps);
        i := Pos('/>', tmps);

        // various kinds of whitespace
        sp := Pos(' ', tmps);
        tb := Pos(#09, tmps);
        cr := Pos(#10, tmps);
        nl := Pos(#13, tmps);

        // find the first piece of whitespace
        ws := sp;
        if (tb > 0) then ws := Min(ws,tb);
        if (cr > 0) then ws := Min(ws,cr);
        if (nl > 0) then ws := Min(ws,nl);

        // find the _root tag
        if ((i > 0) and (i < ws)) then
            _root := Trim(Copy(sbuff, p + 1, i - p))
        else
            _root := Trim(Copy(sbuff, p + 1, ws - p));

        // return special entity tags and bail
        if  (_root = '?xml') or
            (_root = '!ENTITY') or
            (_root = '!--') or
            (_root = '!ATTLIST') or
            (_root = _root_tag) then begin
            r := Copy(sbuff, 1, e);
            _root := '';
            _rbuff := Copy(sbuff, e + 1, l - e + 1);
            Result := r;
            exit;
            end;
        end;

    if (e = (i + 1)) then begin
        // basic tag.. <foo/>
        // position the stream at the next char and pull off the tag
        r := Copy(sbuff, 1, e);
        _root := '';
        _rbuff := Copy(sbuff, e + 1, l - e + 1);
        end
    else begin
        // some other "normal" xml'ish thing..
        // count start/end tags of _root
        i := 1;
        stag := '<' + _root;
        etag := '</' + _root + '>';
        ls := length(stag);
        le := length(etag);
        r := '';
        repeat
            // trim off any cruft before our tag
            tmps := Copy(sbuff, i, l - i + 1);
            ps := Pos(stag, tmps);

            // we have a start tag, inc the counter
            if (ps > 0) then begin
                _counter := _counter + 1;
                i := i + ps + ls - 1;
                end;

            // find the end tag, and dec the counter
            tmps := Copy(sbuff, i, l - i + 1);
            pe := Pos(etag, tmps);
            if ((pe > 0) and ((ps > 0) and (pe > ps)) ) then begin
                _counter := _counter - 1;
                i := i + pe + le - 1;
                if (_counter <= 0) then begin
                    // we have a full tag..
                    r := Copy(sbuff, 1, i - 1);
                    _root := '';
                    _rbuff := Copy(sbuff, i, l - i + 1);
                    break;
                    end;
                end;
        until ((pe <= 0) or (ps <= 0) or (tmps = ''));
        end;
    result := r;
end;

{---------------------------------------}
procedure TDataThread.handleBuffer(buff: string);
var
    cp_buff: string;
    fc, frag: string;
begin
    // scan the buffer to see if it's complete
    cp_buff := buff;
    cp_buff := _rbuff + buff;
    _rbuff := cp_buff;

    // get all of the complete xml fragments until
    // we don't have any left in this buffer
    repeat
        frag := getFullTag(_rbuff);
        if (frag <> '') then begin
            fc := frag[2];
            if (fc <> '?') and (fc <> '!') then
                ParseTags(frag);
            _root := '';
            end;
    until ((frag = '') or (_rbuff = ''));
end;

{---------------------------------------}
procedure TDataThread.ParseTags(buff: string);
var
    c_tag: TXMLTag;
begin
    _tag_parser.ParseString(buff, _root_tag);

    repeat
        c_tag := _tag_parser.popTag();
        if (c_tag <> nil) then begin
            _lock.Acquire;
            _domStack.Add(c_tag);
            doMessage(WM_XML);
            _lock.Release;
            end;
    until (c_tag = nil);
    
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TXMLStream.Create(root: string);
begin
    {
    Create a window handle for sending messages between
    the thread reader socket and the main object.

    Also create the socket here, and setup the callback lists.
    }
    _Socket := TIdTCPClient.Create(nil);
    _root_tag := root;
    _callbacks := TList.Create;
    _sock_callbacks := TList.Create;
    _active := false;
    _timer := TTimer.Create(nil);
    _timer.Interval := 60000;
    _timer.Enabled := false;
    _timer.OnTimer := KeepAlive;


    _socket.RecvBufferSize := 4096;
end;

{---------------------------------------}
destructor TXMLStream.Destroy;
begin
    // free all our objects and free the window handle
    if _thread <> nil then
        _thread.Terminate;

    // _socket.Free;
    _callbacks.Free;
    _sock_callbacks.Free;
end;

{---------------------------------------}
procedure TXMLStream.Keepalive(Sender: TObject);
var
    xml: string;
begin
    // send a keep alive
    if _socket.Connected then begin
        xml := '    ';
        DoSocketCallbacks(true, xml);
        _socket.Write(xml);
        end;
end;

{---------------------------------------}
// procedure TXMLStream.WndProc(var msg: TMessage);
procedure TXMLStream.MsgHandler(var msg: TJabberMsg);
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
            _LocalIP := _Socket.Binding.IP;
            _active := true;
            _timer.Enabled := true;
            DoCallbacks('connected', nil);
            end;

        WM_DISCONNECTED: begin
            // Socket is disconnected
            {
            if ((_thread <> nil) and (not _thread.Stopped)) then
                _thread.TerminateAndWaitFor
            else if (_thread.Stopped) then
                _thread.Terminate();
            }
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
                DoSocketCallbacks(false, tmps);
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
procedure TXMLStream.Connect(server: string; port: integer);
begin
    // connect to this server
    _server := Server;
    _port := port;
    _socket.Host := Server;
    _socket.Port := port;

    // Create the socket reader thread and start it.
    // The thread will open the socket and read all of the data.
    _thread := TDataThread.Create(Self, _socket, _root_tag);
    _thread.Start;
end;

{---------------------------------------}
procedure TXMLStream.Disconnect;
begin
    // Disconnect the stream and stop the thread
    if ((_socket <> nil) and (_socket.Connected)) then
        _socket.Disconnect;
    _timer.Enabled := false;
end;

{---------------------------------------}
procedure TXMLStream.Send(xml: string);
var
    utf: string;
begin
    // Send this text out the socket
    utf := AnsiToUTF8(xml);
    DoSocketCallbacks(true, utf);
    _Socket.Write(utf);
    _timer.Enabled := false;
    _timer.Enabled := true;
end;

{---------------------------------------}
procedure TXMLStream.SendTag(tag: TXMLTag);
begin
    // Send this xml tag out the socket
    Send(tag.xml);
end;

{---------------------------------------}
procedure TXMLStream.RegisterStreamCallback(p: TXMLStreamCallback);
var
    l: TSignalListener;
begin
    // Register a callback with this stream..
    // Stream Callbacks will get TXMLTag objects dispatched
    l := TSignalListener.Create;
    l.callback := TMethod(p);
    _callbacks.add(l);
end;

{---------------------------------------}
procedure TXMLStream.RegisterSocketCallback(p: TSocketCallback);
var
    l: TSignalListener;
begin
    // Register a socket callback.
    // Socket callbacks get raw data read in our sent thru the socket
    l := TSignalListener.Create;
    l.callback := TMethod(p);
    _sock_callbacks.add(l);
end;

{---------------------------------------}
procedure TXMLStream.DoSocketCallbacks(send: boolean; data: string);
var
    i: integer;
    cb: TSocketCallback;
    l: TSignalListener;
begin
    // Dispatch socket data to all of our register'd callbacks
    cb := nil;

    for i := 0 to _sock_callbacks.Count - 1 do begin
        l := TSignalListener(_sock_callbacks[i]);
        cb := TSocketCallback(l.callback);
        cb(send, data);
        end;
end;

{---------------------------------------}
procedure TXMLStream.DoCallbacks(msg: string; tag: TXMLTag);
var
    i: integer;
    l: TSignalListener;
    cb: TXMLStreamCallback;
begin
    // dispatch a TXMLTag object to all of the callbacks
    cb := nil;

    for i := 0 to _callbacks.Count - 1 do begin
        l := TSignalListener(_callbacks[i]);
        cb := TXMLStreamCallback(l.callback);
        cb(msg, tag);
        end;
end;

end.

