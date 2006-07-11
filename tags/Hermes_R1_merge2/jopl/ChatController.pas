unit ChatController;
{
    Copyright 2002, Peter Millard

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
    {$ifdef Linux}
    QExtCtrls,
    {$else}
    ExtCtrls,
    {$endif}

    Unicode, XMLTag, JabberID, Contnrs, Signals,
    SysUtils, Classes;

type

    TChatMessageEvent = procedure(tag: TXMLTag) of object;

    TChatController = class
    private
        _jid: Widestring;
        _resource: Widestring;
        _cb: integer;
        _event: TChatMessageEvent;
        _history: Widestring;
        _memory: TTimer;
        _window: TObject;
        _refs: integer;
        _queued: boolean;
        _threadid: Widestring;
        _scallback: integer;    // Session callback

        procedure SetWindow(new_window: TObject);
    protected
        procedure timMemoryTimer(Sender: TObject);
        procedure SessionCallback(event: string; tag: TXMLTag);
    public
        msg_queue: TQueue;

        constructor Create(sjid, sresource: Widestring);
        destructor Destroy; override;

        procedure SetJID(sjid: Widestring);
        procedure MsgCallback(event: string; tag: TXMLTag);
        procedure SetHistory(s: Widestring);
        procedure setThreadID(id: Widestring);
        procedure startTimer();
        procedure stopTimer();
        procedure unassignEvent();

        procedure PushMessage(tag: TXMLTag);

        function getHistory: Widestring;
        function getThreadID: Widestring;
        function getTags: TXMLTagList;

        procedure addRef();
        procedure Release();
        procedure TimedRelease();
        procedure DisableChat();
        procedure UnregisterSessionCB();

        property JID: WideString read _jid;
        property Resource: Widestring read _resource;
        property Window: TObject read _window write SetWindow;
        property OnMessage: TChatMessageEvent read _event write _event;
        property RefCount: integer read _refs;
    end;

    TChatEvent = procedure(event: string; tag: TXMLTag; controller: TChatController) of object;
    TChatListener = class(TPacketListener)
    public
    end;

    TChatSignal = class(TPacketSignal)
    public
        procedure Invoke(event: string; tag: TXMLTag; controller: TChatController = nil); overload;
        function addListener(callback: TChatEvent): TChatListener; overload;
    end;

{---------------------------------------}
implementation
uses
    PrefController,
    JabberConst, XMLUtils, Session, Chat,
    Forms, IdGlobal;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TChatSignal.Invoke(event: string; tag: TXMLTag; controller: TChatController = nil);
var
    cl: TChatListener;
    ce: TChatEvent;
    i: integer;
begin
    //
    inc(_invoking);
    for i := 0 to Self.Count - 1 do begin
        cl := TChatListener(Self.Objects[i]);
        ce := TChatEvent(cl.Callback);
        try
            ce(event, tag, controller);
        except
            on e: Exception do
                Dispatcher.handleException(Self, e, cl, event, tag);
        end;
    end;
    dec(_invoking);

    if (change_list.Count > 0) and (_invoking = 0) then
        Self.processChangeList();
end;

function TChatSignal.addListener(callback: TChatEvent): TChatListener;
var
    l: TChatListener;
begin
    l := TChatListener.Create();
    l.callback := TMethod(callback);
    inherited addListener('', l);
    Result := l;
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TChatController.Create(sjid, sresource: Widestring);
begin
    // Create a new chat controller..
    // Setup msg callbacks, and either queue them,
    // or send them to the event handler
    inherited Create();

    _cb := -1;
    _scallback := -1;
    _jid := sjid;
    _resource := sresource;
    msg_queue := TQueue.Create();
    _history := '';
    _memory := TTimer.Create(nil);
    _memory.OnTimer := timMemoryTimer;
    _memory.Enabled := false;
    _queued := false;
    _threadid := '';

    if (_resource <> '') then
        self.SetJID(_jid + '/' + _resource)
    else
        self.SetJID(_jid);
end;

{---------------------------------------}
procedure TChatController.addRef();
begin
    inc(_refs);
end;

{---------------------------------------}
procedure TChatController.Release();
begin
    dec(_refs);
    assert(_refs >= 0);
    if (_refs = 0) then
        Self.Free();
end;

{---------------------------------------}
procedure TChatController.TimedRelease();
begin
    dec(_refs);
    if (_refs = 0) then
        StartTimer();
end;

{---------------------------------------}
procedure TChatController.SetJID(sjid: Widestring);
begin
    // If we already have a callback, then unregister
    // Then re-register for messages for the new jid
    if (_cb >= 0) then
        MainSession.UnRegisterCallback(_cb);

    _cb := MainSession.RegisterCallback(MsgCallback,
            '/packet/message[@type="chat"][@from="' + XPLiteEscape(Lowercase(sjid)) + '*"]');
end;

procedure TChatController.DisableChat();
begin
    if (_cb >= 0) then
        MainSession.UnRegisterCallback(_cb);
    Self.unassignEvent();
    StopTimer();
end;

{---------------------------------------}
procedure TChatController.SetWindow(new_window: TObject);
var
    tag : TXMLTag;
begin
    // this controller has a new window.
    // make sure to let the plugins know about it
    _window := new_window;

    if (new_window <> nil) then begin
        tag := TXMLTag.Create('chat');
        tag.setAttribute('handle', IntToStr(TForm(new_window).Handle));
        tag.setAttribute('jid', self._jid);
        MainSession.FireEvent('/chat/window', tag, self);
    end;
end;

{---------------------------------------}
destructor TChatController.Destroy;
var
    idx: integer;
begin
    // Unregister the callback and remove us from the chat list.
    if (MainSession <> nil) then begin
        if (_cb >= 0) then
            MainSession.UnRegisterCallback(_cb);
        idx := MainSession.ChatList.IndexOfObject(Self);
        if (idx >= 0) then
            MainSession.ChatList.Delete(idx);

        Self.UnregisterSessionCB();
    end;

    // Free stuff
    _memory.Free();
    msg_queue.Free();
    inherited;
end;        

{---------------------------------------}
procedure TChatController.MsgCallback(event: string; tag: TXMLTag);
var
    mtype: Widestring;
    m, etag: TXMLTag;
    is_composing: boolean;
begin
    // do stuff
    // if we don't have a window, then ignore composing events
    etag := tag.QueryXPTag(XP_MSGXEVENT);
    is_composing := ((etag <> nil) and
        (etag.GetFirstTag('composing') <> nil) and
        (etag.GetFirstTag('id') <> nil));

    // if our event isn't hooked up, and this is a composing event,
    // just bail
    if ((is_composing) and (not Assigned(_event))) then exit;

    // if we have no body, then bail
    if ((not is_composing) and (tag.GetFirstTag('body') = nil)) then exit;

    // check for delivered requests
    if (mtype <> 'error') and (etag <> nil) then begin
        if ((etag.GetFirstTag('delivered') <> nil) and
            (etag.GetFirstTag('id') = nil)) then begin
            m := generateEventMsg(tag, 'delivered');
            MainSession.SendTag(m);
        end;
    end;

    // if we are paused, put on a delay tag.
    if (MainSession.IsPaused) then begin
        with tag.AddTag('x') do begin
            setAttribute('xmlns', 'jabber:x:delay');
            setAttribute('stamp', DateTimeToJabber(Now + TimeZoneBias()));
        end;
    end;

    if ((_queued) and (MainSession.IsResuming)) then
        _queued := false;

    if Assigned(_event) then begin
        if MainSession.IsPaused then begin
            MainSession.QueueEvent(event, tag, Self.MsgCallback);
            _queued := true;
        end
        else
            _event(tag);
    end
    else begin
        if MainSession.IsPaused then begin
            MainSession.QueueEvent(event, tag, Self.MsgCallback);
            _queued := true;
        end
        else begin
            msg_queue.Push(TXMLTag.Create(tag));

            // if this is the first msg into the queue, fire gui event
            if (msg_queue.Count = 1) then
                MainSession.FireEvent('/session/gui/chat', tag)
            else
                MainSession.FireEvent('/session/gui/update-chat', tag);
        end;
    end;
end;

{---------------------------------------}
procedure TChatController.PushMessage(tag: TXMLTag);
begin
    msg_queue.Push(TXMLTag.Create(tag));
end;

{---------------------------------------}
procedure TChatController.SetHistory(s: Widestring);
begin
    _history := s;
end;

{---------------------------------------}
procedure TChatController.setThreadID(id: Widestring);
begin
    _threadid := id;
end;

{---------------------------------------}
function TChatController.getThreadID: Widestring;
begin
    Result := _threadid;
end;

{---------------------------------------}
function TChatController.getHistory: Widestring;
begin
    Result := _history;
    _history := '';
end;

{---------------------------------------}
function TChatController.getTags: TXMLTagList;
var
    tmp_queue: TQueue;
    c, m: TXMLTag;
begin
    // return a copy of all of the tags in the queue
    tmp_queue := TQueue.Create();
    Result := TXMLTagList.Create();

    while (msg_queue.AtLeast(1)) do begin
        m := TXMLTag(msg_queue.Pop());
        c := TXMLTag.Create(m);
        Result.Add(c);
        tmp_queue.Push(m);
    end;

    while (tmp_queue.AtLeast(1)) do
        msg_queue.Push(tmp_queue.Pop());

    tmp_queue.Free();
end;

{---------------------------------------}
procedure TChatController.timMemoryTimer(Sender: TObject);
begin
    // time to free the window if we still have no refs.
    if ((msg_queue.AtLeast(1)) or (_queued)) then begin
        stopTimer();
        exit;
    end;
    
    if (_refs = 0) then Self.Free();
end;

{---------------------------------------}
//  This method should start a countdown to destroy the chat controller object.
//  If there is no associated window, then it will register itself as a session
//  listener and destroy itself when session disconnects.
procedure TChatController.startTimer();
begin
    _memory.Interval := MainSession.Prefs.getInt('chat_memory') * 60 * 1000;
    _memory.Enabled := true;
    if (_scallback = -1)  and (Self.Window = nil) then
        _scallback := MainSession.RegisterCallback(SessionCallback, '/session');
end;

{---------------------------------------}
procedure TChatController.stopTimer();
begin
    _memory.Enabled := false;
    // Only unregister session callback if control has been handed to a window
    if (Self.Window <> nil) then
        Self.UnregisterSessionCB();
end;

{---------------------------------------}
procedure TChatController.unassignEvent();
begin
    _event := nil;
end;

{---------------------------------------}
procedure TChatController.SessionCallback(event: string; tag: TXMLTag);
begin
    // remove the ChatController if the user disconnects
    if (event = '/session/disconnected') then
        Self.Free();
end;

procedure TChatController.UnregisterSessionCB();
begin
    if (_scallback >= 0) then begin
        MainSession.UnRegisterCallback(_scallback);
        _scallback := -1;
    end;
end;

end.
