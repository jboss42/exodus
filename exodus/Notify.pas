unit Notify;
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
    XMLTag,
    JabberID,
    Presence,
    Windows, Forms, Contnrs, SysUtils, classes;

type
    TNotifyController = class
    private
        _session: TObject;
        _presCallback: longint;
        _chatCallback: longint;
    published
        procedure Callback (event: string; tag: TXMLTag);
        procedure PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
    public
        constructor Create;
        destructor Destroy; override;
        procedure SetSession(js: TObject);
    end;


implementation
uses
    ExUtils,  
    PrefController,
    Jabber1,
    ExEvents,
    RiserWindow,
    Roster,
    Session;

{---------------------------------------}
constructor TNotifyController.Create;
begin
    //
    inherited;
end;

{---------------------------------------}
destructor TNotifyController.Destroy;
begin
    inherited Destroy;
end;

{---------------------------------------}
procedure TNotifyController.SetSession(js: TObject);
begin
    // Store a reference to the session object
    _session := js;
    with TJabberSession(_session) do begin
        _presCallback := RegisterCallback(PresCallback);
        _chatCallback := RegisterCallback(Callback, '/session/gui/chat');
        end;
end;

{---------------------------------------}
procedure TNotifyController.PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
begin
    // getting a pres event
    Callback(event, tag);
end;

{---------------------------------------}
procedure TNotifyController.Callback(event: string; tag: TXMLTag);
var
    sess: TJabberSession;
    nick, j, from, msg: string;
    ritem: TJabberRosterItem;
    tmp_jid: TJabberID;
    n: integer;
begin
    // we are getting some event to do notification on

    // DebugMsg('Notify Callback: ' + BoolToStr(MainSession.IsPaused, true) + ''#13#10);
    if MainSession.IsPaused then begin
        MainSession.QueueEvent(event, tag, Self.Callback);
        exit;
        end;

    sess := TJabberSession(_session);
    from := tag.GetAttribute('from');
    tmp_jid := TJabberID.Create(from);
    j := tmp_jid.jid;
    n := 0;
    ritem := sess.roster.Find(j);
    if ritem <> nil then nick := ritem.nickname else nick := tmp_jid.user;

    tmp_jid.Free();

    // someone is coming online for the first time..
    if (event = '/presence/online') then begin
        msg := nick + #10#13' is now online.';
        n := sess.Prefs.getInt('notify_online');
        end;

    // Someone started a chat session w/ us
    if (event = '/session/gui/chat') then begin
        msg := 'Chat with '#10#13 + nick;
        ShowRiserWindow(msg, 20);
        n := sess.Prefs.getInt('notify_newchat')
        end;

    if ((n and notify_toast) > 0) then
        // Show toast
        ShowRiserWindow(msg, 1);

    if ((n and notify_flash) > 0) then
        // flash the main window
        FlashWindow(frmJabber.Handle, true);
end;

end.
