unit Chat;
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
    {$ifdef linux}
    QForms,
    {$else}
    Forms,
    {$endif}
    ChatController, XMLTag,
    JabberID,
    SysUtils, Classes;

type
    TJabberChatList = class(TStringList)
    private
        _callback: integer;
    public
        constructor Create;
        destructor Destroy; override;

        function FindChat(sjid, sresource, sthread: string): TChatController;
        function AddChat(sjid, sresource: string): TChatController; overload;

        procedure MsgCallback(event: string; tag: TXMLTag);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    COMChatController, Presence, 
    JabberConst, PrefController, Session;

{---------------------------------------}
constructor TJabberChatList.Create;
begin
    inherited;
end;

{---------------------------------------}
destructor TJabberChatList.Destroy;
begin
    MainSession.UnRegisterCallback(_callback);
end;

{---------------------------------------}
procedure TJabberChatList.MsgCallback(event: string; tag: TXMLTag);
var
    fjid: string;
    tmp_jid: TJabberID;
    c: TChatController;
    idx1, idx2, mt: integer;
    mtype: string;
begin
    // check to see if we have a session already open for
    // this jid, if not, create one.
    fjid := tag.getAttribute('from');
    mtype := tag.getAttribute('type');

    if (mtype = 'groupchat') then exit;
    if (mtype = 'headline') then exit;

    mt := MainSession.Prefs.getInt('msg_treatment');

    // throw out any x-data msgs we get.. the xdata handler will pick them up.
    if (tag.QueryXPTag(XP_MSGXDATA) <> nil) then exit;

    // we are only interested in packets w/ a body tag
    if (tag.GetFirstTag('body') = nil) then exit;

    tmp_jid := TJabberID.Create(fjid);

    try
        idx1 := Self.indexOf(fjid);
        idx2 := Self.indexOf(tmp_jid.jid);

        if (mtype <> 'chat') then begin
            if ((mt = msg_existing_chat) and (idx1 = -1) and (idx2 = -1)) then
                exit
            else if (mt = msg_normal) then
                exit;
        end;

        if (Self.indexOf(fjid) < 0) then begin
            // Create a new session
            if (Self.indexOf(tmp_jid.jid) >= 0) then
                exit;

            // in the blocker list?
            if (MainSession.IsBlocked(tmp_jid)) then
                exit;

            // Create a new chat controller
            c := Self.AddChat(tmp_jid.jid, tmp_jid.resource);
            c.MsgCallback(event, tag);

        end;
    finally
        tmp_jid.Free();
    end;
end;

{---------------------------------------}
function TJabberChatList.FindChat(sjid, sresource, sthread: string): TChatController;
var
    full: string;
    i: integer;
    p: TJabberPres;
begin
    // find a chat object for this jid/resource/thread
    if sresource <> '' then
        full := sjid + '/' + sresource
    else
        full := '';

    // check for full first
    i := -1;
    if full <> '' then
        i := indexOf(full);
    if i < 0 then begin
        p := nil;
        i := indexOf(sjid);
        while (i < 0) do begin
            if (p = nil) then
                p := MainSession.ppdb.FindPres(sjid, '')
            else
                p := MainSession.ppdb.NextPres(p);
            if (p <> nil) then
                i := indexOf(p.fromJid.full)
            else begin
                i := -1;
                break;
            end;
        end;
    end;

    if (i < 0) then
        Result := nil
    else
        Result := TChatController(Objects[i]);
end;

{---------------------------------------}
function TJabberChatList.AddChat(sjid, sresource: string): TChatController;
begin
    //
    Result := TChatController.Create(sjid, sresource);
    if (sresource = '') then
        Self.AddObject(sjid, Result)
    else
        Self.AddObject(sjid + '/' + sresource, Result);
end;


end.

