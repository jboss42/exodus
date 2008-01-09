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

    Unicode, XMLTag, JabberID, Contnrs,
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

        procedure SetWindow(new_window: TObject);
    protected
        procedure timMemoryTimer(Sender: TObject);
    public
        msg_queue: TQueue;
        ComController: TObject;

        constructor Create(sjid, sresource: Widestring);
        destructor Destroy; override;

        procedure SetJID(sjid: Widestring);
        procedure MsgCallback(event: string; tag: TXMLTag);
        procedure SetHistory(s: Widestring);
        procedure startTimer();
        procedure stopTimer();
        procedure unassignEvent();

        function getHistory: Widestring;

        property JID: WideString read _jid;
        property Resource: Widestring read _resource;
        property Window: TObject read _window write SetWindow;
        property OnMessage: TChatMessageEvent read _event write _event;

end;

{---------------------------------------}
implementation
uses
    {$ifdef Exodus}
    COMChatController,
    {$endif}
    PrefController,
    JabberConst, XMLUtils, Session, Chat,
    Forms, IdGlobal;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TChatController.Create(sjid, sresource: Widestring);
{$ifdef Exodus}
var
    echat: TExodusChat;
{$endif}
begin
    // Create a new chat controller..
    // Setup msg callbacks, and either queue them,
    // or send them to the event handler
    inherited Create();

    _cb := -1;
    _jid := sjid;
    _resource := sresource;
    msg_queue := TQueue.Create();
    _history := '';
    _memory := TTimer.Create(nil);
    _memory.OnTimer := timMemoryTimer;
    _memory.Enabled := false;

    if (_resource <> '') then
        self.SetJID(_jid + '/' + _resource)
    else
        self.SetJID(_jid);

    {$ifdef Exodus}
    echat := TExodusChat.Create();
    echat.setChatSession(Self);
    echat.ObjAddRef();
    ComController := echat;
    {$endif}
end;

{---------------------------------------}
procedure TChatController.SetJID(sjid: Widestring);
begin
    // If we already have a callback, then unregister
    // Then re-register for messages for the new jid
    if (_cb >= 0) then
        MainSession.UnRegisterCallback(_cb);

    _cb := MainSession.RegisterCallback(MsgCallback,
            '/packet/message[@from="' + XPLiteEscape(Lowercase(sjid)) + '*"]');
end;

{---------------------------------------}
procedure TChatController.SetWindow(new_window: TObject);
begin
    // this controller has a new window.
    // make sure to let the plugins know about it
    _window := new_window;

    {$ifdef Exodus}
    if ((COMController <> nil) and (new_window <> nil)) then
        TExodusChat(COMController).fireNewWindow(TForm(new_window).Handle);
    {$endif}
end;

{---------------------------------------}
destructor TChatController.Destroy;
begin
    // Unregister the callback, and free the queue
    _memory.Free();
    if (_cb >= 0) then
        MainSession.UnRegisterCallback(_cb);
    msg_queue.Free();
    ComController.Free();
    inherited;
end;

{---------------------------------------}
procedure TChatController.MsgCallback(event: string; tag: TXMLTag);
var
    mt: integer;
    mtype: Widestring;
    m, etag: TXMLTag;
    is_composing: boolean;
begin
    // do stuff
    // check for exclusions.. don't show x-data or invites
    if (tag.QueryXPTag(XP_MSGXDATA) <> nil) then exit;
    if (tag.QueryXPTag(XP_MUCINVITE) <> nil) then exit;
    if (tag.QueryXPTag(XP_CONFINVITE) <> nil) then exit;

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

    // Check message types
    mt := MainSession.Prefs.getInt('msg_treatment');
    mtype := tag.getAttribute('type');
    if (mtype = 'groupchat') then exit;
    if ((mtype <> 'chat') and (mt = msg_normal) and (not is_composing)) then exit;


    // check for delivered requests
    if (etag <> nil) then begin
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

    if Assigned(_event) then begin
        if MainSession.IsPaused then
            MainSession.QueueEvent(event, tag, Self.MsgCallback)
        else
            _event(tag);
    end
    else begin
        if MainSession.IsPaused then
            MainSession.QueueEvent(event, tag, Self.MsgCallback)
        else begin
            msg_queue.Push(tag);
            MainSession.FireEvent('/session/gui/chat', tag);
        end;
    end;
end;

{---------------------------------------}
procedure TChatController.SetHistory(s: Widestring);
begin
    _history := s;
end;

{---------------------------------------}
function TChatController.getHistory: Widestring;
begin
    Result := _history;
    _history := '';
end;

{---------------------------------------}
procedure TChatController.timMemoryTimer(Sender: TObject);
var
    idx: integer;
begin
    // time to free the window..
    idx := MainSession.ChatList.IndexOfObject(Self);
    if (idx >= 0) then
        MainSession.ChatList.Delete(idx);
    Self.Free();
end;

{---------------------------------------}
procedure TChatController.startTimer();
begin
    _memory.Interval := MainSession.Prefs.getInt('chat_memory') * 60 * 1000;
    _memory.Enabled := true;
end;

{---------------------------------------}
procedure TChatController.stopTimer();
begin
    _memory.Enabled := false;
end;

procedure TChatController.unassignEvent();
begin
    _event := nil;
end;


end.
