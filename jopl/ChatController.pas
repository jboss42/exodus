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
    SysUtils, Classes, JabberMsg;

type

    TChatMessageEvent = procedure(tag: TXMLTag) of object;

    TChatController = class
    private
        _jid: Widestring; //The jid of the other party involved in this chat
        _resource: Widestring; //The resource of the other party involved in this chat
        
        _msg_cb: integer;
        _eventCB: integer; //event listener for this chat session
        _OnMessageEvent: TChatMessageEvent;
        _OnSendMessageEvent: TChatMessageEvent;
        _history: Widestring;
        _memory: TTimer;
        _window: TObject; //The ChatWin associated with this chat
        _refs: integer;
//        _queued: boolean;
        _threadid: Widestring; //The thread for this chat
        _SessionCB: integer;    // Session callback
        _send_msg_cb: integer;  // Outgoing message callback
        _sent_auto_response: boolean; //Have we sent the participant an auto response since last non-available status?
        _last_msg_id: Widestring; //ID of the last message sent
        _anonymous_chat: boolean; // Is chat from annonymous room
        procedure SetWindow(new_window: TObject);
    protected
        procedure timMemoryTimer(Sender: TObject);
        procedure SessionCallback(event: string; tag: TXMLTag);
    public
        msg_queue: TQueue;
//        last_session_msg_queue: TQueue; //Number of newly received offline messages
 
        constructor Create(sjid, sresource: Widestring; anonymousChat: boolean);
        destructor Destroy; override;

        procedure SetJID(sjid: Widestring);
        procedure MsgCallback(event: string; tag: TXMLTag);
        procedure EventCallback(event: string; tag: TXMLTag);
        procedure SendMsg(tag: TXMLTag); overload;
        procedure SendMsg(body: Widestring; subject: Widestring; xml: Widestring; composing: boolean = false; priority: PriorityType = None); overload;
        procedure SendMsgCallback(event: string; tag: TXMLTag);
        procedure SetHistory(s: Widestring);
        procedure setThreadID(id: Widestring);
        procedure startTimer();
        procedure stopTimer();
        procedure unassignEvent1();
        procedure unassignSendMsgEvent1();

        procedure PushMessage(tag: TXMLTag; last_session_queue: boolean = false);

        function CreateMessage(): TJabberMessage; overload;
        function CreateMessage(tag: TXMLTag): TJabberMessage; overload;
        function CreateMessage(body: Widestring; subject: Widestring; xml: Widestring; priority: PriorityType = None): TJabberMessage; overload;

        function getHistory: Widestring;
        function getThreadID: Widestring;
        function GenerateThreadID: Widestring;
        function getTags: TXMLTagList;

        procedure addRef();
        procedure Release();
        procedure TimedRelease();
        procedure DisableChat();
        procedure RegisterSessionCB(event: widestring);
        procedure RegisterMsgCB();
        procedure RegisterSendMsgCB();
        procedure UnregisterSessionCB();
        procedure UnregisterMsgCB();
        procedure UnregisterSendMsgCB();

        property JID: WideString read _jid;
        property Resource2: Widestring read _resource;
        property Window: TObject read _window write SetWindow;
        property OnMessage: TChatMessageEvent read _OnMessageEvent write _OnMessageEvent;
        property OnSendMessage: TChatMessageEvent read _OnSendMessageEvent write _OnSendMessageEvent;
        property RefCount: integer read _refs;
        property LastMsgId: Widestring read _last_msg_id;
        property AnonymousChat: boolean read _anonymous_chat write _anonymous_chat;
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
    DisplayName,
    JabberConst, XMLUtils, Session, Chat,
    Forms, IdGlobal, ChatWin, Debug, Presence;

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
constructor TChatController.Create(sjid, sresource: Widestring; anonymousChat: boolean);
begin
    // Create a new chat controller..
    // Setup msg callbacks, and either queue them,
    // or send them to the event handler
    inherited Create();

    _msg_cb := -1;
    _eventCB := -1;
    _send_msg_cb := -1;
    _SessionCB := -1;
    _jid := sjid;
    _resource := sresource;
    msg_queue := TQueue.Create();
//JJF msgqueue refactor    last_session_msg_queue := TQueue.Create();
    _history := '';
    _memory := TTimer.Create(nil);
    _memory.OnTimer := timMemoryTimer;
    _memory.Enabled := false;
    _threadid := '';
    _anonymous_chat := anonymousChat;
   
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
var
    tjid: TJabberID;
begin
    tjid := TJabberID.create(sjid);
    if (tjid.resource <> '') then
        _resource := tjid.resource;
    tjid.free();
    
    RegisterSessionCB('/session/presence');
    RegisterMsgCB();
    RegisterSendMsgCB();
end;

procedure TChatController.DisableChat();
begin
    UnRegisterMsgCB();
    UnRegisterSendMsgCB();
    Self.unassignSendMsgEvent1();
    Self.unassignEvent1();
    StopTimer();
end;


{---------------------------------------}
procedure TChatController.SetWindow(new_window: TObject);
var
    tag : TXMLTag;
begin
    // this controller has a new window.
    // make sure to let the plugins know about it
    if (_window = new_window) then exit;
    
    _window := new_window;

    if (new_window <> nil) then
    begin
        tag := TXMLTag.Create('chat');
        tag.setAttribute('handle', IntToStr(TForm(new_window).Handle));
        tag.setAttribute('jid', self._jid);
        MainSession.FireEvent('/chat/window', tag, self);
        tag.Free;
    end else
    begin
        Self.unassignSendMsgEvent1();
        Self.unassignEvent1();
        TimedRelease();
    end;
end;

{---------------------------------------}
destructor TChatController.Destroy;
var
    idx: integer;
begin
    // Unregister the callback and remove us from the chat list.
    if (MainSession <> nil) then begin
        UnRegisterMsgCB();
        UnRegisterSendMsgCB();
        idx := MainSession.ChatList.IndexOfObject(Self);
        if (idx >= 0) then
            MainSession.ChatList.Delete(idx);
        Self.UnregisterSessionCB();
    end;

    // Free stuff
    _memory.Free();
    msg_queue.Free();
//JJF msgqueue refactor     last_session_msg_queue.Free();
    inherited;
end;        

{---------------------------------------}
//Incoming message callback
procedure TChatController.MsgCallback(event: string; tag: TXMLTag);
var
    mtype: Widestring;
    m, etag: TXMLTag;
    isComposingEvent: boolean;
    auto_resp_body: WideString;
    auto_resp_msg: TJabberMessage;
begin
    // do stuff
    // if we don't have a window, then ignore composing events
    etag := tag.QueryXPTag(XP_MSGXEVENT);
    isComposingEvent := ((etag <> nil) and
        (etag.GetFirstTag('composing') <> nil) and
        (etag.GetFirstTag('id') <> nil));

    // if our event isn't hooked up, and this is a composing event,
    // just bail
    if (isComposingEvent and (not Assigned(_OnMessageEvent))) then exit;

    mtype := tag.GetAttribute('type');
    // if not an event and we have no body or type, do not handle
    if ((etag = nil) and ((tag.GetFirstTag('body') = nil) or (mtype =  '')))  then exit;
    
    // check for delivered requests
    if (mtype <> 'error') and (etag <> nil) then begin
        if ((etag.GetFirstTag('delivered') <> nil) and
            (etag.GetFirstTag('id') = nil)) then begin
            m := generateEventMsg(tag, 'delivered');
            MainSession.SendTag(m);
        end;
    end;

    // if we are paused, put on a delay tag.
{**JJF msgqueue refactor
    if (MainSession.IsPaused) then begin
        with tag.AddTag('x') do begin
            setAttribute('xmlns', 'jabber:x:delay');
            setAttribute('stamp', DateTimeToJabber(Now + TimeZoneBias()));
        end;
    end;
**}
    if Assigned(_OnMessageEvent) then begin
        _OnMessageEvent(tag);
    end
    else begin
        PushMessage(tag);

        // if this is the first msg into the queue, fire gui event
        if (msg_queue.Count = 1) then begin
            MainSession.FireEvent('/session/gui/chat', tag)
        end
        else
          MainSession.FireEvent('/session/gui/update-chat', tag)
    end;

    //Send auto response message?
    if (MainSession.Prefs.getBool('away_auto_response')
      and not _sent_auto_response
      and not isComposingEvent
      and not ((MainSession.Show = '')
          or (MainSession.Show = 'chat'))) then begin

      //Send only one auto response each time we are not available
      _sent_auto_response := true;

      auto_resp_body := 'Auto response: '
        + MainSession.getDisplayUsername
        + ' is '
        + Presence.DecodeShowDisplayValue(MainSession.Show);

      if (MainSession.Status <> '') then
        auto_resp_body := auto_resp_body + ' (' + MainSession.Status + ')';

      auto_resp_msg := CreateMessage(auto_resp_body,'','');

      SendMsg(auto_resp_msg.Tag);

      FreeAndNil(auto_resp_msg);
    end;
end;

procedure TChatController.EventCallback(event: string; tag: TXMLTag);
begin
    //ignore if this event has a body, part of a normal message that
    //MsgCallback will handle.
    if (tag.GetFirstTag('body') = nil) then
        MsgCallback(event, tag);
end;

{---------------------------------------}
//Send an outgoing message for this chat
procedure TChatController.SendMsg(body: Widestring; subject: Widestring; xml: Widestring; composing: boolean = false; priority: PriorityType = None);
var
    msg: TJabberMessage;
begin
    msg := CreateMessage(body,subject,xml, priority);
    msg.Composing := composing;
    SendMsg(msg.Tag);
    FreeAndNil(msg);
end;

{---------------------------------------}
//Initiate an outgoing message for this chat
procedure TChatController.SendMsg(tag: TXMLTag);
begin
    SendMsgCallback('/packet/message@chat=''chat''@to=''' + XPLiteEscape(WideLowercase(Self.JID)) + '''',tag);
end;

{---------------------------------------}
//Outgoing message callback
procedure TChatController.SendMsgCallback(event: string; tag: TXMLTag);
var
    jid: TJabberID;
    toJid: TJabberID;
begin
    jid := TJabberID.Create(Self.JID);
    toJid := TJabberID.Create(tag.GetAttribute('to'));
    try
        //This function executes as callback when resource2 sending message
        //to resource1 for the same jid. The callback is registered for all
        //resources for this jid.

        //Do not want to send messages to myself
        if (toJid.full = MainSession.Jid) then exit;

        if (Self.Window = nil) then
            //We need a chat window to do plugin message send logic
            //(or refactor so that ChatController can own the COMChatController)
            StartChat(Self.JID,jid.resource,false);

        if (Assigned(_OnSendMessageEvent)) then
            _OnSendMessageEvent(tag); //Directly invoke the event
    finally
        jid.Free;
        toJid.Free;
    end;
end;

{---------------------------------------}
//Create (an outbound) message for this chat
function TChatController.CreateMessage(): TJabberMessage;
begin
    result := TJabberMessage.Create();
    result.MsgType := 'chat';
    result.FromJID := MainSession.Jid;
    if ( _resource <> '' ) then
        result.ToJID := Self.JID + '/' + _resource
    else
  	    result.ToJID := Self.JID;
    result.isMe := true;
    result.Nick := MainSession.Profile.getDisplayUsername();
    result.ID := MainSession.generateID();
    result.Thread := _threadid;
    _last_msg_id := result.ID;
end;

{---------------------------------------}
//Create (an outbound) message for this chat
function TChatController.CreateMessage(body: Widestring; subject: Widestring; xml: Widestring; priority: PriorityType): TJabberMessage;
begin
    result := CreateMessage();
    result.Body := body;
    result.Subject := subject;
    result.XML := xml;
    result.Priority := priority;
end;

{---------------------------------------}
//Create a message for this chat from an XML tag
//Determine inbound/outbound from message attributes
function TChatController.CreateMessage(tag: TXMLTag): TJabberMessage;
var
  is_me: boolean;
  jid: TJabberID;
begin
  if (tag.GetAttribute('from') = MainSession.JID) then
    is_me := true
  else
    is_me := false;

  result := TJabberMessage.Create(tag);
  result.isMe := is_me;
  if (is_me) then
    jid := TJabberID.Create(MainSession.JID)
  else
    jid := TJabberID.Create(Self.JID);
    
  result.Nick := DisplayName.getDisplayNameCache().getDisplayName(jid);
  FreeAndNil(jid);
end;

{---------------------------------------}
//Push a message into the message queue for this chat
procedure TChatController.PushMessage(tag: TXMLTag; last_session_queue: boolean=false);
begin
    msg_queue.Push(TXMLTag.Create(tag));
end;

{---------------------------------------}
//Store the message history for this chat
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
//Generate a thread id for this chat
function TChatController.GenerateThreadID: Widestring;
begin
    result := FormatDateTime('MMDDYYYYHHMM',Now);
    result := result + jid + MainSession.Username + MainSession.Server;
    result := Sha1Hash(result); // hash the seed to get the thread
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
        PushMessage(tmp_queue.Pop());

    tmp_queue.Free();
end;

{---------------------------------------}
procedure TChatController.timMemoryTimer(Sender: TObject);
begin
    // time to free the window if we still have no refs.
{** JJF msgqueue rfactor... hmmm
    if ((msg_queue.AtLeast(1)) or (_queued)) then begin
        stopTimer();
        exit;
    end;
**}    
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
    if (Self.Window = nil) then
        RegisterSessionCB('/session');
end;

{---------------------------------------}
procedure TChatController.stopTimer();
begin
    _memory.Enabled := false;
    // Only unregister session callback if control has been handed to a window
    if (Self.Window <> nil) then begin
        UnregisterSessionCB();
        RegisterSessionCB('/session/presence');
    end;
end;

{---------------------------------------}
//Unassign the incoming message event for this chat
procedure TChatController.unassignEvent1();
begin
    _OnMessageEvent := nil;
end;

{---------------------------------------}
//Unassign the outgoing message event for this chat
procedure TChatController.unassignSendMsgEvent1();
begin
    _OnSendMessageEvent := nil;
end;

{---------------------------------------}
//Handle session events related to this chat
procedure TChatController.SessionCallback(event: string; tag: TXMLTag);
begin
    // remove the ChatController if the user disconnects
    if (event = '/session/disconnected') then
        Self.Free()
    else if (event = '/session/presence') then //Reset auto response flag
        _sent_auto_response := false;
end;

{---------------------------------------}
procedure TChatController.RegisterSessionCB(event: widestring);
begin
  UnRegisterSessionCB();
  _SessionCB := MainSession.RegisterCallback(SessionCallback, event);
end;

{---------------------------------------}
procedure TChatController.UnregisterSessionCB();
begin
    if (_SessionCB >= 0) then begin
        MainSession.UnRegisterCallback(_SessionCB);
        _SessionCB := -1;
    end;
end;

{---------------------------------------}
//Listen for incoming messages that belong to this chat
procedure TChatController.RegisterMsgCB();
var
    event: widestring;
    from: widestring;
begin
    UnRegisterMsgCB();
    //event := '/packet/message[@type="chat"][@from="';
    from := XPLiteEscape(Lowercase(Self.JID));
    if (_anonymous_chat) then
        from := from + XPLiteEscape(Lowercase('/' + Self.Resource2))
    else from := from + '*';

    _msg_cb := MainSession.RegisterCallback(MsgCallback,
                                            '/packet/message[@type="chat"][@from="' + from + '"]');
    _eventCB := MainSession.RegisterCallback(EventCallback,
                                            '/packet/message[@from="' + from + '"]/x[@xmlns="' + XMLNS_XEVENT + '"]/id');
end;

{---------------------------------------}
procedure TChatController.UnregisterMsgCB();
begin
    if (_msg_cb <> -1) then begin
        MainSession.UnRegisterCallback(_msg_cb);
        _msg_cb := -1;
    end;
    if (_eventCB <> -1) then begin
        MainSession.UnRegisterCallback(_eventCB);
        _eventCB := -1;
    end;
end;

{---------------------------------------}
//Listen for outgoing message that belong to this chat
procedure TChatController.RegisterSendMsgCB();
var
    event: widestring;
begin
    UnRegisterSendMsgCB();
    event := '/packet/message[@type="chat"][@to="';
    event := event + XPLiteEscape(Lowercase(Self.JID));
    if (_anonymous_chat) then
        event := event + XPLiteEscape(Lowercase('/' + Self.Resource2));
    event := event + '*"]';  
    _send_msg_cb := MainSession.RegisterCallback(SendMsgCallback, event);
end;

{---------------------------------------}
procedure TChatController.UnregisterSendMsgCB();
begin
    if (_send_msg_cb >= 0) then begin
        MainSession.UnRegisterCallback(_send_msg_cb);
        _send_msg_cb := -1;
    end;
end;

end.
