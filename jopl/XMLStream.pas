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
    Messages, PrefController,
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
    WM_SEND = WM_USER + 7008;
    WM_SOCKET = WM_USER + 7010;

type
    EXMLStream = class(Exception)
    public
    end;

    TJabberMsg = record
        msg: Cardinal;
        lparam: integer;
    end;

    TDataCallback = procedure (send: boolean; data: string) of object;
    TXMLStreamCallback = procedure (msg: string; tag: TXMLTag) of object;

    TParseThread = class;
    
    TXMLStream = class
    private
        _callbacks: TObjectList;
        _data_callbacks: TObjectList;

    protected
        _Server:    string;
        _port:      integer;
        _local_ip:  string;
        _active:    boolean;
        _root_tag:  string;
        _thread:    TParseThread;

        procedure DoCallbacks(msg: string; tag: TXMLTag);
        procedure DoDataCallbacks(send: boolean; data: string);

    public
        constructor Create(root: String); virtual;
        destructor Destroy(); override;

        procedure Connect(profile : TJabberProfile); virtual; abstract;
        procedure Send(xml: string); virtual; abstract; // Make sure the imp. does ANSI -> UTF8
        procedure SendTag(tag: TXMLTag);
        procedure Disconnect; virtual; abstract;

        procedure RegisterStreamCallback(p: TXMLStreamCallback);
        procedure RegisterDataCallback(p: TDataCallback);
        procedure UnregisterStreamCallback(p: TXMLStreamCallback);
        procedure UnregisterDataCallback(p: TDataCallback);

        property Active: boolean read _active;
        property LocalIP: string read _local_ip;
    end;

    TParseThread = class(TIdThread)
    private
        _lock:       TCriticalSection;
        _indata:     TStringlist;
        _tag_parser: TXMLTagParser;
        _stream:     TXMLStream;
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
        function GetData(): Widestring;
        procedure Push(buff: Widestring);
        procedure CleanUp(); virtual;
        procedure doMessage(msg: integer);

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
    _indata := TStringList.Create;
    _tag_parser := TXMLTagParser.Create;
    _domstack := TList.Create;
    _lock := TCriticalSection.Create;

    FreeOnTerminate := true;
    StopMode := smSuspend;

end;

{---------------------------------------}
procedure TParseThread.Push(buff: Widestring);
begin
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
        Result := _indata[0];
        _indata.Delete(0);
        end
    else
        Result := '';
    _lock.Release;
end;

{---------------------------------------}
procedure TParseThread.CleanUp();
begin
    _indata.Free();
    _tag_parser.Free();
    _lock.Free();
    _domStack.Free();
end;

{---------------------------------------}
procedure TParseThread.doMessage(msg: integer);
begin
    if (_stream = nil) then exit;

    _cur_msg.msg := WM_JABBER;
    _cur_msg.lparam := msg;

    Synchronize(Self.DispatchMsg);
end;

{---------------------------------------}
procedure TParseThread.DispatchMsg;
begin
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
    if _domstack.count <= 0 then exit;

    Result := TXMLTag(_domstack[0]);
    _domstack.Delete(0);
end;

{---------------------------------------}
procedure TParseThread.ParseTags(buff: Widestring);
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
function TParseThread.getFullTag(buff: Widestring): Widestring;
var
    // pbuff: array of char;
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

    // find the first tag
    p := Pos('<', sbuff);
    if p <= 0 then raise EXMLStream.Create('');

    // trim off the first < char.
    tmps := Copy(sbuff, p, l - p + 1);
    e := Pos('>', tmps);
    i := Pos('/>', tmps);

    if _root = '' then begin
        // snag the first tag off the front
        {
        p := Pos('<', sbuff);
        if p <= 0 then raise EXMLStream.Create('');
        tmps := Copy(sbuff, p, l - p + 1);
        e := Pos('>', tmps);
        i := Pos('/>', tmps);
        }

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
{---------------------------------------}
{---------------------------------------}
constructor TXMLStream.Create(root: string);
begin
    inherited Create();
    _root_tag := root;
    _callbacks := TObjectList.Create;
    _data_callbacks := TObjectList.Create;
    _active := false;
end;

{---------------------------------------}
destructor TXMLStream.Destroy();
begin
    // free all our objects and free the window handle
    _callbacks.Clear();
    _data_callbacks.Clear();

    if _thread <> nil then begin
        _thread._stream := nil;
        _thread.Terminate;
        end;

    _callbacks.Free;
    _data_callbacks.Free;

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
procedure TXMLStream.RegisterDataCallback(p: TDataCallback);
var
    l: TSignalListener;
begin
    // Register a socket callback.
    // Socket callbacks get raw data read in our sent thru the socket
    l := TSignalListener.Create;
    l.callback := TMethod(p);
    _data_callbacks.add(l);
end;

{---------------------------------------}
procedure TXMLStream.UnregisterStreamCallback(p: TXMLStreamCallback);
var
    i : integer;
    cb: TXMLStreamCallback;
    l:  TSignalListener;
begin
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
procedure TXMLStream.UnregisterDataCallback(p: TDataCallback);
var
    i : integer;
    cb: TDataCallback;
    l:  TSignalListener;
begin
    for i := 0 to _data_callbacks.Count -1 do begin
        l := TSignalListener(_data_callbacks[i]);
        cb := TDataCallback(l.callback);
        if (@cb = @p) then begin
            _data_callbacks.Delete(i);
            exit;
            end;
        end;
end;

{---------------------------------------}
procedure TXMLStream.DoDataCallbacks(send: boolean; data: string);
var
    i: integer;
    cb: TDataCallback;
    l: TSignalListener;
begin
    // Dispatch socket data to all of our register'd callbacks
    cb := nil;

    for i := 0 to _data_callbacks.Count - 1 do begin
        l := TSignalListener(_data_callbacks[i]);
        cb := TDataCallback(l.callback);
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

{---------------------------------------}
procedure TXMLStream.SendTag(tag: TXMLTag);
begin
    // Send this xml tag out the socket
    Send(tag.xml);
end;



end.

