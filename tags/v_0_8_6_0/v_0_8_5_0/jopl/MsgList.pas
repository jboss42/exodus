unit MsgList;
{
    Copyright 2003, Peter Millard

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
    MsgController, 
    JabberID, Unicode, Signals, XMLTag,
    Classes;

type
    TJabberMsgList = class(TWidestringList)
    private
        _s: TObject;
        _cb: integer;

        function getController(jid: Widestring): TMsgController;

    published
        procedure MsgCallback(event: String; tag: TXMLTag);

    public
        constructor Create();
        destructor Destroy(); Override;

        procedure SetSession(s: TObject);

        function AddController(jid: Widestring; c: TMsgController): integer;

        function FindJid(jid: Widestring): TMsgController; overload;
        function FindJid(jid: TJabberID): TMsgController; overload;
    end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    // JOPL stuff
    ChatController, JabberConst, PrefController, Session,
    XMLUtils,

    // Delphi stuff
    IdGlobal, SysUtils;

{---------------------------------------}
constructor TJabberMsgList.Create();
begin
    //
    _cb := -1;
    _s := nil;
end;

{---------------------------------------}
destructor TJabberMsgList.Destroy();
var
    s: TJabberSession;
begin
    //
    if ((_s <> nil) and (_cb <> -1)) then begin
        s := TJabberSession(_s);
        s.UnRegisterCallback(_cb);
    end;
end;

{---------------------------------------}
procedure TJabberMsgList.SetSession(s: TObject);
var
    ss: TJabberSession;
begin
    _s := s;
    ss := TJabberSession(s);
    _cb := ss.RegisterCallback(MsgCallback, '/packet/message');
end;

{---------------------------------------}
function TJabberMsgList.getController(jid: Widestring): TMsgController;
var
    idx: integer;
begin
    idx := Self.indexOf(jid);
    if (idx = -1) then
        Result := nil
    else
        Result := TMsgController(Self.Objects[idx]);
end;

{---------------------------------------}
function TJabberMsgList.FindJid(jid: Widestring): TMsgController;
var
    cp: TMsgController;
begin
    cp := getController(jid);
    if (cp <> nil) then
        Result := cp
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberMsgList.FindJid(jid: TJabberID): TMsgController;
var
    cp: TMsgController;
begin
    cp := getController(jid.full);
    if (cp = nil) then
        cp := getController(jid.jid);

    if (cp = nil) then
        Result := nil
    else
        Result := cp;
end;

{---------------------------------------}
procedure TJabberMsgList.MsgCallback(event: String; tag: TXMLTag);
var
    b, mtype: Widestring;
    from_jid: TJabberID;
    msgt: integer;
    mc: TMsgController;
    cc: TChatController;
    js: TJabberSession;
    m, etag: TXMLTag;
begin
    js := TJabberSession(_s);
    mtype := tag.getAttribute('type');
    b := Trim(tag.GetBasicText('body'));
    from_jid := TJabberID.Create(tag.getAttribute('from'));

    // check for a handler for this JID already
    try
        // check for messages we don't care about
        if ((mtype = 'groupchat') or (mtype = 'chat')) then exit;
        if (mtype = 'normal') then mtype := '';

        // if (mtype = 'headline') then exit;
        if (tag.QueryXPTag(XP_MSGXDATA) <> nil) then exit;
        if (tag.QueryXPTag(XP_MUCINVITE) <> nil) then exit;
        if (tag.QueryXPTag(XP_CONFINVITE) <> nil) then exit;

        // check for headlines w/ JUST a x-oob.
        // otherwise, throw out cases where body is empty
        if ((tag.QueryXPTag(XP_XOOB) = nil) and (b = '')) then exit;

        // check current msg treatment prefs
        msgt := MainSession.Prefs.getInt('msg_treatment');
        if (msgt = msg_existing_chat) then begin
            // check for an existing chat window..
            // if we have one, then bail.
            cc := js.ChatList.FindChat(from_jid.jid, '', '');
            if (cc = nil) then
                cc := js.ChatList.FindChat(from_jid.jid,
                    from_jid.resource, '');
            if (cc <> nil) then exit;
        end
        else if ((msgt = msg_all_chat) and (mtype = '') and
                 (tag.QueryXPTag(XP_XROSTER) = nil)) then begin
            // do we need to do more here??
            exit;
        end;

        // if we're paused, queue the event
        if (js.isPaused) then begin
            with tag.AddTag('x') do begin
                setAttribute('xmlns', XMLNS_DELAY);
                setAttribute('stamp', DateTimeToJabber(Now + TimeZoneBias()));
            end;
            js.QueueEvent(event, tag, Self.MsgCallback);
            exit;
        end;

        // check for delivered event requests
        etag := tag.QueryXPTag(XP_MSGXEVENT);
        if ((etag <> nil) and
            (etag.GetFirstTag('id') = nil) and
            (etag.GetFirstTag('delivered') <> nil)) then begin
            // send back a delivered event
            m := generateEventMsg(tag, 'delivered');
            js.SendTag(m);
        end;

        if (mtype = 'headline') then
            js.FireEvent('/session/gui/headline', tag)
        else begin
            mc := FindJid(from_jid);
            if (mc <> nil) then
                // send the msg to the existing window
                mc.HandleMessage(tag)
            else
                // spin up a new window
                js.FireEvent('/session/gui/msgevent', tag);
        end;

    finally
        from_jid.Free();
    end;
end;

{---------------------------------------}
function TJabberMsgList.AddController(jid: Widestring; c: TMsgController): integer;
begin
    Result := Self.AddObject(jid, c);
end;

end.
