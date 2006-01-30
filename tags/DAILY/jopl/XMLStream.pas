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
    Unicode,
    {$ifdef Win32}
    Messages,
    {$endif}
    PrefController,
    SysUtils, IdThread, IdException,
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
    WM_DEBUG = WM_USER + 7008;
    WM_SOCKET = WM_USER + 7010;
    WM_TIMEOUT = WM_USER + 7011;

type
    EXMLStream = class(Exception)
    public
end;

    TJabberMsg = record
        msg: Cardinal;
        lparam: integer;
end;

    TDataEvent = procedure (send: boolean; data: Widestring) of object;
    TXMLStreamCallback = procedure (msg: string; tag: TXMLTag) of object;

    TParseThread = class;

    TXMLStream = class
    private
        _callbacks: TObjectList;
        _data_event: TDataEvent;

    protected
        _Server:    string;
        _port:      integer;
        _local_ip:  string;
        _active:    boolean;
        _root_tag:  string;
        _thread:    TParseThread;

        procedure DoCallbacks(msg: string; tag: TXMLTag);
        procedure DoDataCallbacks(send: boolean; data: Widestring);

    public
        constructor Create(root: String); virtual;
        destructor Destroy(); override;

        procedure Connect(profile : TJabberProfile); virtual; abstract;
        procedure Send(xml: Widestring); virtual; abstract; // Make sure the imp. does ANSI -> UTF8
        procedure SendTag(tag: TXMLTag);
        procedure Disconnect; virtual; abstract;
        procedure ResetParser();
        function  isSSLCapable(): boolean; virtual; abstract;
        procedure EnableSSL(); virtual; abstract;
        procedure EnableCompression; virtual; abstract;

        procedure RegisterStreamCallback(p: TXMLStreamCallback);
        procedure UnregisterStreamCallback(p: TXMLStreamCallback);

        property Active: boolean read _active;
        property LocalIP: string read _local_ip;

        property OnData: TDataEvent read _data_event write _data_event;
    end;

    TParseThread = class(TIdThread)
    private
        _lock:       TCriticalSection;
        _indata:     TWideStringlist;
        _tag_parser: TXMLTagParser;
        _domstack:   TList;
        _root:       Widestring;
        _root_tag:   Widestring;
        _root_len:   integer;
        _cur_msg:    TJabberMsg;
        _rbuff:      Widestring;
        _counter:    integer;

        procedure DispatchMsg();
        procedure ParseTags(buff: Widestring);
        procedure handleBuffer(buff: Widestring);
        function getFullTag(buff: Widestring): Widestring;

    protected
        _stream:     TXMLStream;
        function GetData(): Widestring;
        procedure Debug(buff: Widestring);
        procedure Push(buff: Widestring);
        procedure ThreadCleanUp();
        procedure doMessage(msg: integer);
        procedure doMessageSync(msg: integer);

    public
        constructor Create(strm: TXMLStream; root: Widestring); reintroduce;
        property Data: Widestring read GetData;
        function GetTag: TXMLTag;
end;


implementation
uses
    Signals,
    Math;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TParseThread.Create(strm: TXMLStream; root: Widestring);
begin
    // Create a new thread and setup the events
    inherited  Create(True);

    _rbuff := '';
    _root := '';
    _counter := 0;
    _stream := strm;
    _root_tag := root;
    _root_len := Length(_root_tag);
    _indata := TWideStringList.Create;
    _tag_parser := TXMLTagParser.Create;
    _domstack := TList.Create;
    _lock := TCriticalSection.Create;

    FreeOnTerminate := true;
    StopMode := smSuspend;

end;

{---------------------------------------}
procedure TParseThread.Debug(buff: Widestring);
begin
    _lock.Acquire;
    _indata.Add(buff);
    _lock.Release;

    doMessage(WM_SOCKET);
end;

{---------------------------------------}
procedure TParseThread.Push(buff: Widestring);
begin
    Debug(buff);
    
    if (Copy(buff, 1, _root_len + 2) = '</' + _root_tag) then
        doMessage(WM_COMMERROR)
    else begin
        handleBuffer(buff);
    end;
end;

{---------------------------------------}
procedure TParseThread.handleBuffer(buff: Widestring);
var
    cp_buff: Widestring;
    fc, frag: Widestring;
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
function TParseThread.GetData: Widestring;
begin
    {
    Suck some data off of the _indata stack and return it.
    Make sure we lock around this since the stringlist is not
    thread safe.
    }
    _lock.Acquire;
    if _indata.Count > 0 then begin
        Result := _indata.Strings[0];
        _indata.Delete(0);
    end
    else
        Result := '';
    _lock.Release;
end;

{---------------------------------------}
procedure TParseThread.ThreadCleanUp();
begin
    {
    NOTE: This method is called from descendant classes..
    so it can't be removed despite that it's never
    called in the parent class
    }
    _indata.Free();
    _tag_parser.Free();
    _lock.Free();
    _domStack.Free();
end;

{---------------------------------------}
procedure TParseThread.doMessage(msg: integer);
begin
    {
    Send a message out to the main thread.
    Calls DispatchMsg synchronized, so it'll
    execute in the main VCL thread
    }
    if (_stream = nil) then exit;
    if (not _stream._active) then exit;

    _cur_msg.msg := WM_JABBER;
    _cur_msg.lparam := msg;

    Synchronize(Self.DispatchMsg);
end;

{---------------------------------------}
procedure TParseThread.doMessageSync(msg: integer);
begin
    // Directly calls the DispatchMsg method w/out
    // Synchronized, so it's executed in this thread.
    if (_stream = nil) then exit;

    _cur_msg.msg := WM_JABBER;
    _cur_msg.lparam := msg;

    Self.DispatchMsg;
end;

{---------------------------------------}
procedure TParseThread.DispatchMsg;
begin
    // Send this message to the stream object
    assert(_stream <> nil, 'Trying to dispatch to a nil stream');
    _stream.Dispatch(_cur_msg);
end;

{---------------------------------------}
function TParseThread.GetTag: TXMLTag;
begin
    {
    Suck an entire TXMLTag object off of the _domstack list
    and return it. This method is called by the stream object
    via the synchronized Dispatch method.
    }
    Result := nil;
    _lock.Acquire();
    if _domstack.count <= 0 then begin
        _lock.Release();
        exit;
    end;

    Result := TXMLTag(_domstack[0]);
    _domstack.Delete(0);
    _lock.Release();
end;

{---------------------------------------}
procedure TParseThread.ParseTags(buff: Widestring);
var
    c_tag: TXMLTag;
begin
    {
    Called by handleBuffer. This sends the buffer, which
    should contain a single XML fragement, into the parser
    object and stores the XMLTag objects in the _domStack.
    Tags are popped off this stack by the GetTag method
    when the stream object asks for them.
    }
    _tag_parser.ParseString(buff, _root_tag);
    repeat
        c_tag := _tag_parser.popTag();
        if (c_tag <> nil) then begin
            _lock.Acquire;
            _domStack.Add(c_tag);
            _lock.Release;
            doMessage(WM_XML);
        end;
    until (c_tag = nil);

end;

{---------------------------------------}
function TParseThread.getFullTag(buff: Widestring): Widestring;
var
    sbuff, r, stag, etag, tmps: Widestring;
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

    _counter := 0;
    Result := '';
    sbuff := buff;
    l := Length(sbuff);

    // Check for empty buffers
    if (Trim(sbuff)) = '' then exit;

    // find the first tag
    p := Pos('<', sbuff);
    if p <= 0 then raise EXMLStream.Create('');

    // trim off the first < char.
    tmps := Copy(sbuff, p, l - p + 1);
    e := Pos('>', tmps);
    i := Pos('/>', tmps);

    // If we have no end tags at all, then bail
    if ((e = 0) and (i = 0)) then exit;

    if _root = '' then begin
        // snag the first tag off the front and cache it as the "root" of our fragment
        // check various kinds of whitespace
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
            // we have an end marker /> before whitespace
            // this is something like <foo/>
            _root := Trim(Copy(sbuff, p + 1, i - 2))
        else if (e < ws) then
            // we have an end begin tag > before whitespace
            // this is something like <foo>cdata goes here</foo>
            _root := Trim(Copy(sbuff, p + 1, e - 2))
        else
            // Normal <foo bar="baz">...</foo> or
            // <foo bar="baz"/>
            _root := Trim(Copy(sbuff, p + 1, ws - 2));

        // return special entity tags and bail
        if  (_root = '?xml') or
            (_root = '!ENTITY') or
            (_root = '!--') or
            (_root = '!ATTLIST') or
            (_root = _root_tag) then begin
            r := Copy(sbuff, p, e);
            _root := '';
            _rbuff := Copy(sbuff, p + e , l - e - p + 1);
            Result := r;
            exit;
        end;
    end;

    if (e = (i + 1)) then begin
        // basic tag.. <foo/>
        // position the stream at the next char and pull off the tag
        r := Copy(sbuff, p, e);
        _root := '';
        _rbuff := Copy(sbuff, p + e, l - e - p + 1);
    end
    else begin
        // some other "normal" xml'ish thing..
        // count start/end tags of _root
        i := p;
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
                    r := Copy(sbuff, p, i - p);
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
{---------------------------------------}
{---------------------------------------}
constructor TXMLStream.Create(root: string);
begin
    inherited Create();
    _root_tag := root;
    _callbacks := TObjectList.Create;
    _active := false;
    _local_ip := '';
end;

{---------------------------------------}
destructor TXMLStream.Destroy();
begin
    // free all our objects and free the window handle
    _callbacks.Clear();

    if _thread <> nil then begin
        _thread.Terminate;
        _thread._stream := nil;
    end;

    _callbacks.Free;
    inherited;
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
procedure TXMLStream.UnregisterStreamCallback(p: TXMLStreamCallback);
var
    i : integer;
    cb: TXMLStreamCallback;
    l:  TSignalListener;
begin
    // Unregister a normal stream callback.
    for i := 0 to _callbacks.Count -1 do begin
        l := TSignalListener(_callbacks[i]);
        cb := TXMLStreamCallback(l.callback);
        if (@cb = @p) then begin
            _callbacks.Delete(i);
            exit;
        end;
    end;
end;

{---------------------------------------}
procedure TXMLStream.DoDataCallbacks(send: boolean; data: Widestring);
begin
    // Call the "debug" event handler if it's been assigned
    if (Assigned(_data_event)) then
        _data_event(send, data);
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

    // free the tag here after it's been dispatched thru the system
    if (tag <> nil) then
        tag.Release();
end;

{---------------------------------------}
procedure TXMLStream.SendTag(tag: TXMLTag);
begin
    // Send this xml tag out the socket
    Send(tag.xml);
end;

{---------------------------------------}
procedure TXMLStream.ResetParser();
begin
    //
    _thread._tag_parser.Free();
    _thread._tag_parser := TXMLTagParser.Create();
end;


end.

