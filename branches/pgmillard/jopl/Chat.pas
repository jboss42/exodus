unit chat;
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
    XMLTag,
    JabberID,
    SysUtils, Classes;

type
    TJabberChat = class
    private
    public
        jid: TJabberID;
        useResource: boolean;
        nick: string;
        thread: string;
        buff: string;
        window: TForm;

        constructor Create;
        destructor Destroy; override;
    end;

    TJabberChatList = class(TStringList)
    private
        _callback: integer;
    public
        constructor Create;
        destructor Destroy; override;

        function FindChat(sjid, sresource, sthread: string): TJabberChat;
        function AddChat(sjid, sresource: string): TJabberChat;

        procedure MsgCallback(event: string; tag: TXMLTag);
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Session;

{---------------------------------------}
constructor TJabberChat.Create;
begin
    inherited Create;

    jid := TJabberID.Create('');
end;

{---------------------------------------}
destructor TJabberChat.Destroy;
begin
    jid.Free;

    inherited Destroy;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberChatList.Create;
begin
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
    // c: TfrmChat;
begin
    // check to see if we have a session already open for
    // this jid, if not, create one.
    fjid := tag.getAttribute('from');

    // we are only interested in packets w/ a body tag
    if (tag.QueryXPTag('/message/body') = nil) then exit;

    if (Self.indexOf(fjid) < 0) then begin
        // Create a new session
        tmp_jid := TJabberID.Create(fjid);
        if (Self.indexOf(tmp_jid.jid) >= 0) then exit;
        MainSession.FireEvent('/session/gui/chat', tag);
        MainSession.FireEvent('/chat/new', tag);
        end;
end;

{---------------------------------------}
function TJabberChatList.FindChat(sjid, sresource, sthread: string): TJabberChat;
var
    full: string;
    i: integer;
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
    if i < 0 then
        i := indexOf(sjid);

    if (i < 0) then
        Result := nil
    else
        Result := TJabberChat(Objects[i]);
end;

{---------------------------------------}
function TJabberChatList.AddChat(sjid, sresource: string): TJabberChat;
var
    tmps: string;
    tmp_jid: TJabberID;
    c: TJabberChat;
begin
    // Create a new chat session for this jid + resource
    tmp_jid := TJabberID.Create(sjid);
    tmps := tmp_jid.jid;
    if sresource <> '' then
        tmps := tmps + '/' + sresource;

    c := TJabberChat.Create;
    c.jid.ParseJID(tmps);
    c.useResource := (sresource <> '');

    Self.AddObject(tmps, c);

    Result := c;
end;


end.

