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
    SysUtils, Classes, Unicode;

type
    TJabberChatList = class(TWideStringList)
    private
        _s: TObject;
        _callback: integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetSession(s: TObject);

        function FindChat(sjid, sresource, sthread: Widestring): TChatController;
        function AddChat(sjid, sresource: Widestring): TChatController; overload;

        procedure MsgCallback(event: string; tag: TXMLTag);
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Presence,
    JabberConst, PrefController, Session;

{---------------------------------------}
constructor TJabberChatList.Create;
begin
    inherited;
    _s := nil;
    _callback := -1;
end;

{---------------------------------------}
destructor TJabberChatList.Destroy;
begin
    if (_callback <> -1) then
        MainSession.UnRegisterCallback(_callback);
    inherited;
end;

{---------------------------------------}
procedure TJabberChatList.SetSession(s: TObject);
begin
    _s := s;
    _callback := TJabberSession(s).RegisterCallback(MsgCallback,'/post/message[@type!="error"]');
end;

{---------------------------------------}
procedure TJabberChatList.MsgCallback(event: string; tag: TXMLTag);
var
    fjid: Widestring;
    tmp_jid: TJabberID;
    c: TChatController;
    idx1, idx2, mt: integer;
    mtype: string;
begin
    // check to see if we have a session already open for
    // this jid, if not, create one.
    fjid := tag.getAttribute('from');
    mtype := tag.getAttribute('type');

    mt := MainSession.Prefs.getInt('msg_treatment');

    // pgm 2/29/04 - we should never get these packets anymore...
    // throw out any x-data msgs we get.. the xdata handler will pick them up.
    //if (tag.QueryXPTag(XP_MSGXDATA) <> nil) then exit;

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

        if ((idx1 = -1) and (idx2 = -1)) then begin
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
function TJabberChatList.FindChat(sjid, sresource, sthread: widestring): TChatController;
var
    full: string;
    i,j: integer;
    p: TJabberPres;
    jid: TJabberID;
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

    if (i < 0) then begin
        p := nil;
        i := indexOf(sjid);
        while (i < 0) do begin
            // See if they are online to find their Full JID
            if (p = nil) then
                p := MainSession.ppdb.FindPres(sjid, '')
            else
                p := MainSession.ppdb.NextPres(p);
            if (p <> nil) then
                // We have presence so try to find any conversation thread
                i := indexOf(p.fromJid.full)
            else begin
                // Offline (no presence) so see if we can find ANY conversation
                // to attach to for sending offline message.
                i := -1;
                for j := 0 to Self.Count - 1 do begin
                    jid := TJabberID.Create(Self.Get(j));
                    if (jid.jid = sjid) then begin
                        //Found a conversation with base JID
                        i := j;
                        jid.Free;
                        break;
                    end;
                    jid.Free;
                end;
                break;
            end;
        end;
    end;

    if (i < 0) then
        Result := nil
    else begin
        Result := TChatController(Objects[i]);

        // if we have a resource specified...
        // and the chat controller has a different one,
        // then don't return it.
        if ((sresource <> '') and
            (Result.resource <> '') and
            (sresource <> Result.Resource)) then
            Result := nil;
    end;
end;

{---------------------------------------}
function TJabberChatList.AddChat(sjid, sresource: Widestring): TChatController;
begin
    //
    Result := TChatController.Create(sjid, sresource);
    if (sresource = '') then
        Self.AddObject(sjid, Result)
    else
        Self.AddObject(sjid + '/' + sresource, Result);
end;

end.

