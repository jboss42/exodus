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
    XMLTag, JabberID, Contnrs,
    SysUtils, Classes;

type

    TChatMessageEvent = procedure(tag: TXMLTag) of object;

    TChatController = class
    private
        _jid: Widestring;
        _resource: Widestring;
        _cb: integer;
        _event: TChatMessageEvent;
    public
        msg_queue: TQueue;
        window: TObject;
        ComController: TObject;

        constructor Create(sjid, sresource: Widestring);
        destructor Destroy; override;

        procedure SetJID(sjid: Widestring);
        procedure MsgCallback(event: string; tag: TXMLTag);

        property JID: WideString read _jid;
        property OnMessage: TChatMessageEvent read _event write _event;
    end;

{---------------------------------------}
implementation
uses
    COMChatController, 
    JabberConst, XMLUtils, Session, Chat, IdGlobal;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TChatController.Create(sjid, sresource: Widestring);
var
    echat: TExodusChat;
begin
    // Create a new chat controller..
    // Setup msg callbacks, and either queue them,
    // or send them to the event handler
    inherited Create();

    _cb := -1;
    _jid := sjid;
    _resource := sresource;
    msg_queue := TQueue.Create();

    if (_resource <> '') then
        self.SetJID(_jid + '/' + _resource)
    else
        self.SetJID(_jid);

    echat := TExodusChat.Create();
    echat.setChatSession(Self);
    echat.ObjAddRef();
    ComController := echat;

end;

{---------------------------------------}
procedure TChatController.SetJID(sjid: Widestring);
begin
    // If we already have a callback, then unregister
    // Then re-register for messages for the new jid
    if (_cb >= 0) then
        MainSession.UnRegisterCallback(_cb);

    _cb := MainSession.RegisterCallback(MsgCallback,
            '/packet/message[@from="' + Lowercase(sjid) + '*"]');
end;

{---------------------------------------}
destructor TChatController.Destroy;
begin
    // Unregister the callback, and free the queue
    if (_cb >= 0) then
        MainSession.UnRegisterCallback(_cb);
    msg_queue.Free();
    inherited;
end;

{---------------------------------------}
procedure TChatController.MsgCallback(event: string; tag: TXMLTag);
begin
    // do stuff
    // check for exclusions.. don't show x-data or invites
    if (tag.QueryXPTag(XP_MSGXDATA) <> nil) then exit;
    if (tag.QueryXPTag(XP_MUCINVITE) <> nil) then exit;
    if (tag.QueryXPTag(XP_CONFINVITE) <> nil) then exit;
    if (tag.GetAttribute('type') = 'groupchat') then exit;
    
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


end.
