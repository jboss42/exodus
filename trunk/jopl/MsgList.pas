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
        _cb1: integer;
        _cb2: integer;
        _cb3: integer;

        function getController(jid: Widestring): TMsgController;

    public
        constructor Create();
        destructor Destroy(); Override;

        procedure SetSession(s: TObject);
        procedure MsgCallback(event: String; tag: TXMLTag);

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
    _cb1 := -1;
    _cb2 := -1;
    _cb3 := -1;
    _s := nil;
end;

{---------------------------------------}
destructor TJabberMsgList.Destroy();
var
    s: TJabberSession;
begin
    //
    if ((_s <> nil) and (_cb1 <> -1)) then begin
        s := TJabberSession(_s);
        s.UnRegisterCallback(_cb1);
        s.UnRegisterCallback(_cb2);
        s.UnRegisterCallback(_cb3);
    end;
end;

{---------------------------------------}
procedure TJabberMsgList.SetSession(s: TObject);
var
    ss: TJabberSession;
begin
    _s := s;
    ss := TJabberSession(s);
    _cb1 := ss.RegisterCallback(MsgCallback, '/post/message[@type="headline"]');
    _cb2 := ss.RegisterCallback(MsgCallback, '/post/message[@type="normal"]');
    _cb3 := ss.RegisterCallback(MsgCallback, '/post/message[!type]');
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
    cc: TChatController;
    js: TJabberSession;
    mc: TMsgController;
    m, etag: TXMLTag;
begin
    js := TJabberSession(_s);
    mtype := tag.getAttribute('type');
    b := Trim(tag.GetBasicText('body'));
    from_jid := TJabberID.Create(tag.getAttribute('from'));

    // check for a handler for this JID already
    try
        // check for messages we don't care about
        if (event <> '/unhandled') then begin

            if (mtype = 'normal') then mtype := '';

            // check for is-composing tags
            etag := tag.QueryXPTag(XP_MSGXEVENT);
            if ((etag <> nil) and (b = '') and
                (etag.GetFirstTag('composing') <> nil) and
                (etag.GetFirstTag('id') <> nil)) then begin
                cc := js.ChatList.FindChat(from_jid.jid, '', '');
                if (cc = nil) then
                    cc := js.ChatList.FindChat(from_jid.jid,
                        from_jid.resource, '');
                if (cc <> nil) then
                    cc.MsgCallback('xml', tag);
            end;


            // check for headlines w/ JUST a x-oob.
            // otherwise, throw out cases where body is empty
            if ((tag.QueryXPTag(XP_XOOB) = nil) and (b = '')) then exit;

            // check to see if we've blocked them.
            if (js.IsBlocked(from_jid)) then exit;

            // check current msg treatment prefs
            msgt := MainSession.Prefs.getInt('msg_treatment');
            if (tag.QueryXPTag(XP_XROSTER) <> nil) then begin
                // fallthru
                mtype := XMLNS_XROSTER;
            end
            else if (msgt = msg_normal) then
                // normal msg processing should FALLTHROUGH
            else begin
                // check for an existing chat window..
                // if we have one, then bail.
                cc := js.ChatList.FindChat(from_jid.jid, '', '');
                if (cc = nil) then
                    cc := js.ChatList.FindChat(from_jid.jid,
                        from_jid.resource, '');
                if (cc <> nil) then begin
                    cc.MsgCallback('xml', tag);
                    exit;
                end
                else if (msgt = msg_all_chat) then begin
                    js.ChatList.MsgCallback('xml', tag);
                    exit;
                end;
            end;
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
        else if (mtype = XMLNS_XROSTER) then
            js.FireEvent('/session/gui/msgevent', tag)
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
