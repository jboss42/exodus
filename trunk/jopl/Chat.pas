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
    Session;

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
        if (Self.indexOf(tmp_jid.jid) >= 0) then begin
            tmp_jid.Free();
            exit;
            end;

        // in the blocker list?
        if (MainSession.IsBlocked(tmp_jid)) then  begin
            tmp_jid.Free();
            exit;
            end;

        // Create a new chat controller
        c := Self.AddChat(tmp_jid.jid, tmp_jid.resource);
        c.MsgCallback(event, tag);

        tmp_jid.Free();
        end;
end;

{---------------------------------------}
function TJabberChatList.FindChat(sjid, sresource, sthread: string): TChatController;
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

