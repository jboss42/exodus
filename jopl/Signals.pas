unit Signals;
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
    Unicode, XMLTag,
    Contnrs, Classes, SysUtils;

type

    // turn on M+ so we can do RTTI stuff on the signals + dispatcher at runtime
    {M+}

    // A function definition for a global signal handler
    TSignalExceptionHandler = procedure(e_data: TWidestringlist);

    {---------------------------------------}
    // Base callback method for TSignal listeners
    TSignalEvent = procedure (event: string; tag: TXMLTag) of object;
    TSignal = class;
    TSignalListener = class;

    {---------------------------------------}
    // This is a class to store info in the x-ref table
    // inside the dispatcher. This allows us to lookup a LID,
    // and get the associated signal and a pointer to the TSignalListener
    TListenerInfo = class
    public
        lid: longint;
        sig: TSignal;
        l: TSignalListener;
    end;

    {---------------------------------------}
    // This is the main signal dispatcher...
    TSignalDispatcher = class(TStringList)
    private
        _lid_info: TStringList;
        _handler: TSignalExceptionHandler;

        procedure _setHandler(proc: TSignalExceptionHandler);
    public
        constructor Create();
        destructor Destroy(); override;

        procedure AddSignal(sig: TSignal);
        procedure DispatchSignal(event: string; tag: TXMLTag);
        procedure DeleteListener(lid: longint);
        procedure AddListenerInfo(lid: integer; sig: TSignal; l: TSignalListener);
        procedure handleException(sig: TSignal; e: Exception;
            sl: TSignalListener; event: string; tag: TXMLTag);

        function TotalCount: longint;

        property ExceptionHandler: TSignalExceptionHandler read _handler write _setHandler;
    end;

    {---------------------------------------}
    // Normal signal event listener
    TSignalListener = class
    public
        cb_id: longint;
        callback: TMethod;
        classname: string;
        methodname: string;

        constructor Create;
    end;

    {---------------------------------------}
    // A class for storing queued events.
    // Important for allowing us to "pause" the client
    TQueuedEvent = class
    public
        callback: TMethod;
        event: string;
        tag: TXMLTag;
        constructor Create;
        destructor Destroy; override;
    end;

    {---------------------------------------}
    // classes for change list stuff.
    {
    The deal is that callbacks that get fired by
    a signal have the potential to change the listener
    list for that signal. To hanle these cases, we
    store these adds/deletes to the signal listener list
    in a pending list while we are invoking.
    After all _current_ listeners have been invoked, we process
    the change list to the listener list.
    }
    TChangeListOps = (cl_add, cl_delete);
    TChangeListEvent = class
    public
        l: TSignalListener;
        event: string;
        op: TChangeListOps;
    end;


    {---------------------------------------}
    // Base class for all signals..
    TSignal = class(TStringList)
    private
        _my_event: String;
        _change_list: TObjectQueue;
    protected
        // invoking: boolean;
        _invoking: integer;
        
        // pointer to the disp that owns us
        Dispatcher: TSignalDispatcher;
        function addListener(event: string;
            l: TSignalListener): boolean; overload; virtual;
        function delListener(l: TSignalListener): boolean;
        procedure Invoke(event: string; tag: TXMLTag); overload; virtual;
        procedure processChangeList();
    public
        constructor Create(my_event: String);
        destructor Destroy; override;

        property change_list: TObjectQueue read _change_list;
        property Event: String read _my_event;
    end;

    {---------------------------------------}
    // Just a simple implementation of TSignal
    TBasicSignal = class(TSignal)
    public
        function addListener(event: string;
            callback: TSignalEvent): TSignalListener; overload;
    end;


    {---------------------------------------}
    // Signal that understands XPLite statements and invokes based on them
    TPacketEvent = procedure(event: string; tag: TXMLTag) of object;
    TPacketListener = class(TSignalListener)
    protected
        xp: TXPLite;
    public
        constructor Create;
        destructor Destroy; override;
        procedure ParseXPLite(xplite: string);
        property XPLite: TXPLite read xp;
    end;

    TPacketSignal = class(TSignal)
    protected
        _next: string;
        _len_event: integer;
    public
        constructor Create(my_event: string; next_sig: string = '');
        function addListener(xplite: string; callback: TPacketEvent): TPacketListener; overload;
        procedure Invoke(event: string; tag: TXMLTag); override;
    end;

    {---------------------------------------}
    // Signal that handles an additional string at the end
    TDataStringEvent = procedure(event: string; tag: TXMLTag; data: Widestring) of object;
    TStringListener = class(TSignalListener);

    TStringSignal = class(TSignal)
    public
        function addListener(callback: TDataStringEvent): TStringListener; overload;
        procedure Invoke(event: string; tag: TXMLTag; data: Widestring); overload;
    end;

    {M-}

implementation
uses
    XMLUtils;

var
    _lid: longint = 0;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
constructor TQueuedEvent.Create;
begin
    inherited Create;

    event := '';
    tag := nil;
end;

{---------------------------------------}
destructor TQueuedEvent.Destroy;
begin
    if (tag <> nil) then tag.Free();

    inherited Destroy;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
constructor TSignalDispatcher.Create();
begin
    inherited;

    _lid_info := TStringList.Create();
    _handler := nil;
end;

{---------------------------------------}
destructor TSignalDispatcher.Destroy();
begin
    ClearStringListObjects(_lid_info);
    ClearStringListObjects(Self);

    _lid_info.Free();

    inherited Destroy;
end;

{---------------------------------------}
procedure TSignalDispatcher.AddSignal(sig: TSignal);
begin
    // add a signal to the list
    Self.AddObject(sig.event, sig);
    sig.Dispatcher := Self;
end;

{---------------------------------------}
procedure TSignalDispatcher._setHandler(proc: TSignalExceptionHandler);
begin
    _handler := proc;
end;

{---------------------------------------}
procedure TSignalDispatcher.handleException(sig: TSignal; e: Exception;
    sl: TSignalListener; event: string; tag: TXMLTag);
var
    data: TWideStringlist;
begin
    // call the exception handler
    if (not Assigned(_handler)) then exit;

    data := TWidestringList.Create();
    data.Add('Exception: ' + e.Message);
    data.Add('Signal Class: ' + sig.ClassName);
    data.Add('Event: ' + event);
    data.Add('Listener Classname: ' + sl.classname);
    data.Add('Listener Methodname: ' + sl.methodname);
    if (tag <> nil) then
        data.Add('XML Packet: ' + tag.xml());
    _handler(data);
    data.Free();
end;

{---------------------------------------}
procedure TSignalDispatcher.DispatchSignal(event: string; tag: TXMLTag);
var
    levt: string;
    i: integer;
    sig: TSignal;
begin
    // find the correct signal to dispatch this event on
    levt := WideLowerCase(Trim(event));
    for i := Self.Count - 1 downto 0 do begin
        if (Pos(LowerCase(Strings[i]), levt) = 1) then begin
            sig := TSignal(Objects[i]);
            if (sig <> nil) then
                sig.Invoke(event, tag);
        end;
    end;
end;

{---------------------------------------}
procedure TSignalDispatcher.AddListenerInfo(lid: integer; sig: TSignal; l: TSignalListener);
var
    i: integer;
    ls: string;
    li: TListenerInfo;
begin
    // add an entry into the stringlist
    // first check to see if this lid is already in the list
    ls := IntToStr(lid);
    i := _lid_info.IndexOf(ls);
    if (i < 0) then begin
        i := _lid_info.Add(ls);
        li := TListenerInfo.Create();
    end
    else
        li := TListenerInfo(_lid_info.Objects[i]);

    li.lid := lid;
    li.sig := sig;
    li.l := l;

    _lid_info.Objects[i] := li;
end;

{---------------------------------------}
procedure TSignalDispatcher.DeleteListener(lid: longint);
var
    ls: string;
    li: TListenerInfo;
    i: integer;
begin
    // lookup the lid in the stringlist,
    // and then call the corresponding signal's delListener method
    ls := IntToStr(lid);
    i := _lid_info.indexOf(ls);
    if (i >= 0) then begin
        // the lid is in our list
        li := TListenerInfo(_lid_info.Objects[i]);
        if (li <> nil) then begin
            // we have a good entry..
            li.sig.delListener(li.l);
            li.Free();
        end;
        _lid_info.Delete(i);
    end;
end;

{---------------------------------------}
function TSignalDispatcher.TotalCount: longint;
var
    i: integer;
    sig: TSignal;
begin
    Result := 0;
    for i := 0 to Self.Count - 1 do begin
        sig := TSignal(Objects[i]);
        Result := Result + sig.Count;
    end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
constructor TSignalListener.Create;
begin
    inherited;

    cb_id := _lid;
    inc(_lid);
end;

constructor TSignal.Create(my_event: String);
begin
    inherited Create(); 
    _my_event := my_event;
    _change_list := TObjectQueue.Create();
    Dispatcher := nil;
end;

{---------------------------------------}
destructor TSignal.Destroy;
begin
    ClearStringListObjects(Self);
    Dispatcher := nil;
    _change_list.Free();

    inherited Destroy;
end;

{---------------------------------------}
function TSignal.addListener(event: string; l: TSignalListener): boolean;
var
    co: TChangeListEvent;
begin
    // handle adding this listener to the list,
    // or stick it  into the change list

    // return true if added now,
    // return false if added to the change list
    if (_invoking > 0) then begin
        // add to change list
        co := TChangeListEvent.Create();
        co.l := l;
        co.event := event;
        co.op := cl_add;
        _change_list.Push(co);

        Result := false;
    end
    else begin
        l.classname := TObject(l.callback.Data).ClassName;
        l.methodname := TObject(l.callback.Data).MethodName(l.callback.code);

        Self.AddObject(event, l);
        if (Dispatcher <> nil) then
            Dispatcher.AddListenerInfo(l.cb_id, Self, l);
        Result := true;
    end;
end;

{---------------------------------------}
function TSignal.delListener(l: TSignalListener): boolean;
var
    idx: integer;
    co: TChangeListEvent;
begin
    // remove the listener from the list
    Result := false;
    idx := Self.IndexOfObject(l);
    if (idx < 0) then exit;

    if (_invoking = 0) then begin
        l.Free();
        Self.Delete(idx);
        Result := true;
    end
    else if (_invoking > 0) then begin
        co := TChangeListEvent.Create();
        co.l := l;
        co.op := cl_delete;
        _change_list.Push(co);
    end;
end;

{---------------------------------------}
procedure TSignal.Invoke(event: string; tag: TXMLTag);
var
    i: integer;
    l: TSignalListener;
    cmp, e: string;
    sig: TSignalEvent;
begin
    // dispatch this to all interested listeners
    cmp := Lowercase(Trim(event));

    inc(_invoking);
    for i := 0 to Self.Count - 1 do begin
        e := Strings[i];
        l := TSignalListener(Objects[i]);
        if (l <> nil) then begin
            sig := TSignalEvent(l.callback);
            if (e <> '') then begin
                // check to see if the listener's string is a substring of the event
                if (Pos(e, cmp) >= 1) then begin
                    try
                        sig(event, tag);
                    except
                        on e: Exception do
                            Dispatcher.handleException(Self, e, l, event, tag);
                    end;
                end;
            end
            else begin
                // otherwise, signal
                try
                    sig(event, tag);
                except
                    on e: Exception do
                        Dispatcher.handleException(Self, e, l, event, tag);
                end;
            end;
        end;
    end;

    dec(_invoking);

    if (change_list.Count > 0) and (_invoking = 0) then
        Self.processChangeList();
end;

{---------------------------------------}
procedure TSignal.processChangeList();
var
    co: TChangeListEvent;
begin
    // process the change list
    while (_change_list.Count > 0) do begin
        co := TChangeListEvent(_change_list.Pop());
        if (co.op = cl_add) then
            Self.addListener(co.event, co.l)
        else
            Self.delListener(co.l);
        co.Free;
    end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
function TBasicSignal.addListener(event: string; callback: TSignalEvent): TSignalListener;
var
    l: TSignalListener;
begin
    l := TSignalListener.Create;
    l.callback := TMethod(callback);

    inherited addListener(event, l);

    Result := l;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
constructor TPacketListener.Create;
begin
    inherited;

    xp := TXPLite.Create;
end;

{---------------------------------------}
destructor TPacketListener.Destroy;
begin
    xp.free;
    inherited Destroy;
end;

{---------------------------------------}
procedure TPacketListener.ParseXPLite(xplite: string);
begin
    xp.Parse(xplite);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
constructor TPacketSignal.Create(my_event: string; next_sig: string);
begin
    inherited Create(my_event);
    _next := next_sig;
    _len_event := length(my_event);
end;

{---------------------------------------}
function TPacketSignal.addListener(xplite: string; callback: TPacketEvent): TPacketListener;
var
    l: TPacketListener;
    xps: string;
begin
    // create a new PacketListener for this signal
    l := TPacketListener.Create;
    l.callback := TMethod(callback);

    // /packet
    xps := Copy(xplite, _len_event + 1, length(xplite) - _len_event);
    l.xp.Parse(xps);

    inherited addListener(xplite, l);
    Result := l;
end;

{---------------------------------------}
procedure TPacketSignal.Invoke(event: string; tag: TXMLTag);
var
    i: integer;
    pe: TPacketEvent;
    pl: TPacketListener;
    xp: TXPLite;
    fired: boolean;
begin
    {
    check this packet against this xplite
    use basic syntax like:
    /iq/query@xmlns='jabber:iq:roster'
    }
    fired := false;

    inc(_invoking);
    for i := 0 to Self.Count - 1 do begin
        pl := TPacketListener(Self.Objects[i]);
        xp := pl.XPLite;
        if xp.Compare(tag) then begin
            pe := TPacketEvent(pl.Callback);
            try
                pe('xml', tag);
                fired := true;
            except
                on e: Exception do
                    Dispatcher.handleException(Self, e, pl, event, tag);
            end;
        end;
    end;
    dec(_invoking);

    // if we didn't fire, and we have a signal to call next, do so.
    if ((fired = false) and (_next <> '')) then begin
        Dispatcher.DispatchSignal(_next, tag);
    end;

    if (change_list.Count > 0) and (_invoking = 0) then
        Self.processChangeList();

end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
function TStringSignal.addListener(callback: TDataStringEvent): TStringListener;
var
    sl: TStringListener;
begin
    // create a new StringListener for this signal
    sl := TStringListener.Create;
    sl.callback := TMethod(callback);
    inherited addListener('', sl);
    Result := sl;
end;

{---------------------------------------}
procedure TStringSignal.Invoke(event: string; tag: TXMLTag; data: Widestring);
var
    sl: TStringListener;
    se: TDataStringEvent;
    i: integer;
begin
    //
    inc(_invoking);
    for i := 0 to Self.Count - 1 do begin
        sl := TStringListener(Self.Objects[i]);
        se := TDataStringEvent(sl.Callback);
        try
            se(event, tag, data);
        except
            on e: Exception do
                Dispatcher.handleException(Self, e, sl, event, tag);
        end;
    end;
    dec(_invoking);

    if (change_list.Count > 0) and (_invoking = 0) then
        Self.processChangeList();
end;


end.
