unit Session;
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
    Signals,
    XMLStream, XMLTag,
    Agents, Chat, Presence, Roster,
    PrefController, Notify,
    Windows, Forms, Classes, SysUtils, StdVcl;

type
    TJabberAuthType = (jatZeroK, jatDigest, jatPlainText, jatNoAuth);

    TJabberSession = class
    private
        _stream: TXMLStream;
        _register: boolean;
        _username: string;
        _password: string;
        _resource: string;
        _server: string;
        _stream_id: string;
        _show: string;
        _status: string;
        _port: integer;
        _priority: integer;
        _AuthType: TJabberAuthType;

        _dispatcher: TSignalDispatcher;
        _packetSignal: TPacketSignal;
        _sessionSignal: TSignal;
        _chatSignal: TSignal;
        _rosterSignal: TRosterSignal;
        _presSignal: TPresenceSignal;

        _id: longint;
        _cb_id: longint;

        procedure StreamCallback(msg: string; tag: TXMLTag);

        // auth stuff
        procedure AuthGet;
        procedure AuthGetCallback(event: string; xml: TXMLTag);
        procedure AuthCallback(event: string; tag: TXMLTag);
        procedure SendRegistration;
        procedure RegistrationCallback(event: string; xml: TXMLTag);

    public
        ppdb: TJabberPPDB;
        roster: TJabberRoster;
        ChatList: TJabberChatList;
        Prefs: TPrefController;
        Notify: TNotifyController;
        Agents: TAgents;

        dock_windows: boolean;

        Constructor Create;
        Destructor Destroy; override;

        procedure CreateAccount;
        procedure Connect;
        procedure Disconnect;

        procedure setPresence(show, status: string; priority: integer);

        function RegisterCallback(callback: TPacketEvent; xplite: string): integer; overload;
        function RegisterCallback(callback: TRosterEvent): integer; overload;
        function RegisterCallback(callback: TPresenceEvent): integer; overload;
        procedure UnRegisterCallback(index: integer);

        procedure FireEvent(event: string; tag: TXMLTag); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const p: TJabberPres); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const ritem: TJabberRosterItem); overload;

        procedure SendTag(tag: TXMLTag);
        procedure AssignProfile(profile: TJabberProfile);
        procedure ActivateProfile(i: integer);

        function generateID: string;

        property Username: string read _username write _username;
        property Password: string read _password write _password;
        property Server: string read _server write _server;
        property Resource: string read _resource write _resource;
        property Port: integer read _port write _port;
        property Priority: integer read _priority write _priority;
        property Show: string read _show;
        property Status: string read _status;
        property Stream: TXMLStream read _stream;
        property Dispatcher: TSignalDispatcher read _dispatcher;
    end;

const
    XMLNS_AUTH      = 'jabber:iq:auth';
    XMLNS_ROSTER    = 'jabber:iq:roster';
    XMLNS_REGISTER  = 'jabber:iq:register';
    XMLNS_LAST      = 'jabber:iq:last';
    XMLNS_TIME      = 'jabber:iq:time';
    XMLNS_VERSION   = 'jabber:iq:version';
    XMLNS_IQOOB     = 'jabber:iq:oob';
    XMLNS_BROWSE    = 'jabber:iq:browse';
    XMLNS_AGENTS    = 'jabber:iq:agents';
    XMLNS_SEARCH    = 'jabber:iq:search';
    XMLNS_PRIVATE   = 'jabber:iq:private';
    XMLNS_BM        = 'storage:bookmarks';
    

var
    MainSession: TJabberSession;


implementation
uses
    XMLUtils,
    Dialogs,
    iq;

{---------------------------------------}
Constructor TJabberSession.Create;
begin
    //
    inherited Create;

    _stream := TXMLStream.Create('stream:stream');
    _username := '';
    _password := '';
    _resource := '';
    _server := '';
    _register := false;
    _port := 5222;
    _id := 1;
    _cb_id := 1;

    // Create the event dispatcher mechanism
    _dispatcher := TSignalDispatcher.Create;
    _packetSignal := TPacketSignal.Create('/packet');
    _sessionSignal := TSignal.Create('/session');
    _rosterSignal := TRosterSignal.Create('/roster');
    _presSignal := TPresenceSignal.Create('/presence');
    _chatSignal := TSignal.Create('/chat');

    _dispatcher.AddObject('/packet', _packetSignal);
    _dispatcher.AddObject('/session', _sessionSignal);
    _dispatcher.AddObject('/roster', _rosterSignal);
    _dispatcher.AddObject('/presence', _presSignal);
    _dispatcher.AddObject('/chat', _chatSignal);

    // Register our session to get XML Tags
    _stream.RegisterStreamCallback(Self.StreamCallback);

    // Create all the things which might register w/ the session
    ppdb := TJabberPPDB.Create;
    ppdb.SetSession(Self);

    roster := TJabberRoster.Create;
    roster.SetSession(Self);

    ChatList := TJabberChatList.Create;

    Prefs := TPrefController.Create('\Software\Jabber\Exodus');
    Prefs.LoadProfiles;

    Notify := TNotifyController.Create;
    Notify.SetSession(Self);

    Agents := TAgents.Create();
end;

{---------------------------------------}
Destructor TJabberSession.Destroy;
begin
    // Clean up everything

    ppdb.Free;
    roster.Free;
    ChatList.Free;
    Notify.Free;

    _stream.Free;

    _packetSignal.Free;
    _sessionSignal.Free;
    _dispatcher.Free;


    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberSession.CreateAccount;
begin
    _register := true;
    Connect();
end;

{---------------------------------------}
procedure TJabberSession.Connect;
begin
    _stream.Connect(_server, _port);
end;

{---------------------------------------}
procedure TJabberSession.Disconnect;
begin
    _stream.Send('<presence type="unavailable"/>');
    // ChatList.CloseAll;
    _stream.Disconnect;
    _register := false;
end;

{---------------------------------------}
procedure TJabberSession.SendTag(tag: TXMLTag);
begin
    // Send this tag out to the socket
    _stream.SendTag(tag);
    tag.Free;
end;

{---------------------------------------}
procedure TJabberSession.StreamCallback(msg: string; tag: TXMLTag);
var
    tmps: string;
begin
    // Process callback info..
    if msg = 'connected' then begin
        // we are connected... send auth stuff.
        tmps := '<stream:stream to="' + Trim(_Server) + '" xmlns="jabber:client" xmlns:stream="http://etherx.jabber.org/streams">';
        _stream.Send(tmps);
        end
    else if msg = 'disconnected' then begin
        // Clear the roster, ppdb and fire the callbacks
        Roster.Clear;
        ppdb.Clear;
        _dispatcher.DispatchSignal('/session/disconnected', nil);
        end
    else if msg = 'commerror' then
        _dispatcher.DispatchSignal('/session/commerror', nil)
    else if msg = 'xml' then begin
        // process XML
        // always fire debug
        if (tag.Name = 'stream:stream') then begin
            _stream_id := tag.getAttribute('id');
            _dispatcher.DispatchSignal('/session/connected', nil);

            if _register then
                SendRegistration()
            else
                AuthGet();
                
            end
        else
            _dispatcher.DispatchSignal('/packet', tag);
        end;
end;

{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TPacketEvent; xplite: string): integer;
var
    p, i: integer;
    l: TSignalListener;
    pk: TPacketListener;
    sig: TSignal;
    msg, tok1: string;
begin
    // add this callback to the packet signal
    Result := -1;
    p := Pos('/', Copy(xplite, 2, length(xplite) - 1));
    if p > 0 then
        tok1 := Copy(xplite, 1, p)
    else
        tok1 := xplite;

    i := _dispatcher.IndexOf(tok1);
    if tok1 = '/packet' then begin
        pk := _packetSignal.addListener(callback, xplite);
        pk.cb_id := _dispatcher.getNextID();
        result := pk.cb_id;
        end
    else if i >= 0 then begin
        sig := TSignal(_dispatcher.Objects[i]);
        l := sig.addListener(callback);
        l.cb_id := _dispatcher.getNextID();
        result := l.cb_id;
        end;

    msg := 'Registering callback for: ' + xplite + '. Total=' + IntToStr(_dispatcher.TotalCount);
    OutputDebugString(PChar(msg));
end;

{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TRosterEvent): integer;
var
    l: TRosterListener;
    msg: string;
begin
    // add a callback to the roster signal
    l := _rosterSignal.addListener(callback);
    l.cb_id := _dispatcher.getNextID();
    Result := l.cb_id;

    msg := 'Registering roster callback. Total=' + IntToStr(_dispatcher.TotalCount);
    OutputDebugString(PChar(msg));
end;

{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TPresenceEvent): integer;
var
    l: TPresenceListener;
    msg: string;
begin
    // add a callback to the presence signal
    l := _presSignal.addListener(callback);
    l.cb_id := _dispatcher.getNextID();
    Result := l.cb_id;

    msg := 'Registering presence callback. Total=' + IntToStr(_dispatcher.TotalCount);
    OutputDebugString(PChar(msg));
end;

{---------------------------------------}
procedure TJabberSession.FireEvent(event: string; tag: TXMLTag);
begin
    // dispatch some basic signal
    _dispatcher.DispatchSignal(event, tag);
end;

{---------------------------------------}
procedure TJabberSession.FireEvent(event: string; tag: TXMLTag; const p: TJabberPres);
begin
    // dispatch a presence signal
    _presSignal.Invoke(event, tag, p);
end;

{---------------------------------------}
procedure TJabberSession.FireEvent(event: string; tag: TXMLTag; const ritem: TJabberRosterItem);
begin
    // dispatch a roster event directly
    _rosterSignal.Invoke(event, tag, ritem);
end;

{---------------------------------------}
procedure TJabberSession.UnRegisterCallback(index: integer);
var
    msg: string;
begin
    // todo: do something for unregistering callbacks
    _dispatcher.DeleteListener(index);

    msg := 'UnRegistering callback. Total=' + IntToStr(_dispatcher.TotalCount);
    OutputDebugString(PChar(msg));
end;

{---------------------------------------}
function TJabberSession.generateID: string;
begin
    Result := 'jcl_' + IntToStr(_id);
    _id := _id + 1;
end;

{---------------------------------------}
procedure TJabberSession.AssignProfile(profile: TJabberProfile);
begin
    Username := profile.Username;
    Server := profile.Server;
    Password := profile.Password;
    Resource := profile.Resource;
    Priority := profile.Priority;
end;

{---------------------------------------}
procedure TJabberSession.AuthGet;
var
    iqAuth: TJabberIQ;
begin
    // find out the potential auth kinds for this user
    // iqAuth := TJabberIQ.Create(Self, generateID, Self.AuthGetCallback);
    iqAuth := TJabberIQ.Create(Self, generateID, AuthGetCallback, 180000);
    with iqAuth do begin
        Namespace := XMLNS_AUTH;
        iqType := 'get';
        with qTag do
            AddBasicTag('username', _username);
        end;
    iqAuth.Send;
end;

{---------------------------------------}
procedure TJabberSession.SendRegistration;
var
    iqReg: TJabberIQ;
begin
    // send an iq register
    iqReg := TJabberIQ.Create(Self, generateID, RegistrationCallback, 180000);
    with iqReg do begin
        Namespace := XMLNS_REGISTER;
        iqType := 'set';
        with qTag do begin
            AddBasicTag('username', _username);
            AddBasicTag('password', _password);
            end;
        end;
    iqReg.Send;
end;

{---------------------------------------}
procedure TJabberSession.RegistrationCallback(event: string; xml: TXMLTag);
begin
    // callback from our registration request
    if ((xml = nil) or (xml.getAttribute('type') = 'error')) then begin
        Disconnect();
        _dispatcher.DispatchSignal('/session/regerror', xml);
        end
    else begin
        // We got a good registration...
        // Go do the entire Auth sequence now.
        AuthGet();
        end;
end;

{---------------------------------------}
procedure TJabberSession.AuthGetCallback(event: string; xml: TXMLTag);
var
    tok, seq, dig, qtag: TXMLTag;
    authDigest, authHash, authToken, hashA, key: string;
    i, authSeq: integer;
    auth: TJabberIQ;
begin
    // auth get result or error
    if ((xml = nil) or (xml.getAttribute('type') = 'error')) then begin
        Disconnect();
        _dispatcher.DispatchSignal('/session/noaccount', xml);
        exit;
        end;

    qtag := xml.GetFirstTag('query');
    if qtag = nil then exit;

    seq := qtag.GetFirstTag('sequence');
    tok := qtag.GetFirstTag('token');
    dig := qtag.GetFirstTag('digest');

    // setup the iq-set
    Auth := TJabberIQ.Create(Self, generateID, AuthCallback);
    with Auth do begin
        Namespace := XMLNS_AUTH;
        iqType := 'set';
        qTag.AddBasicTag('username', _username);
        qTag.AddBasicTag('resource', _resource);
        end;

    if seq <> nil then begin
        if tok = nil then exit;
        // Zero-k auth
        _AuthType := jatZeroK;
        authSeq := StrToInt(seq.data);
        authToken := tok.Data;
        hashA := Sha1Hash(_password);
        key := Sha1Hash(Trim(hashA) + Trim(authToken));
        for i := 1 to authSeq do
            key := Sha1Hash(key);
        authHash := key;
        Auth.qTag.AddBasicTag('hash', authHash);
        end

    else if dig <> nil then begin
        // Digest (basic Sha1)
        _AuthType := jatDigest;
        authDigest := Sha1Hash(Trim(_stream_id + _password));
        Auth.qTag.AddBasicTag('digest', authDigest);
        end

    else begin
        // Plaintext
        _AuthType := jatPlainText;
        Auth.qTag.AddBasicTag('password', _password);
        end;
    Auth.Send;
end;

{---------------------------------------}
procedure TJabberSession.AuthCallback(event: string; tag: TXMLTag);
begin
    // check the result of the authentication
    if ((tag = nil) or (tag.getAttribute('type') = 'error')) then begin
        // timeout
        Disconnect();
        _dispatcher.DispatchSignal('/session/autherror', tag);
        end
    else begin
        _dispatcher.DispatchSignal('/session/authenticated', tag);
        Self.RegisterCallback(ChatList.MsgCallback, '/packet/message[@type="chat"]');
        Agents.Fetch(_server);
        end;
end;

{---------------------------------------}
procedure TJabberSession.ActivateProfile(i: integer);
var
    p: TJabberProfile;
begin
    // make this profile the active one..
    p := TJabberProfile(Prefs.Profiles.Objects[i]);

    // Update the session object
    Server := p.Server;
    Username := p.Username;
    password := p.password;
    resource := p.Resource;
    Priority := p.Priority;
end;

{---------------------------------------}
procedure TJabberSession.setPresence(show, status: string; priority: integer);
var
    p: TJabberPres;
begin
    p := TJabberPres.Create();
    p.Show := show;
    p.Status := status;
    p.Priority := priority;

    _show := show;
    _status := status;
    _priority := priority;
    SendTag(p);
    MainSession.FireEvent('/session/presence', nil);
end;

end.

