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
    PrefController,
    Agents, Chat, Presence, Roster,
    Signals, XMLStream, XMLTag,
    Contnrs, Classes, SysUtils, JabberID;

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
        _use_ssl: boolean;
        _port: integer;
        _priority: integer;
        _AuthType: TJabberAuthType;
        _invisible: boolean;

        // Dispatcher
        _dispatcher: TSignalDispatcher;
        _packetSignal: TPacketSignal;
        _sessionSignal: TBasicSignal;
        _rosterSignal: TRosterSignal;
        _presSignal: TPresenceSignal;

        _paused: boolean;
        _pauseQueue: TQueue;
        
        _id: longint;
        _cb_id: longint;

        procedure StreamCallback(msg: string; tag: TXMLTag);

        // auth stuff
        procedure AuthGet;
        procedure SendRegistration;

        function getMyAgents(): TAgents;
    published
        procedure AuthGetCallback(event: string; xml: TXMLTag);
        procedure AuthCallback(event: string; tag: TXMLTag);
        procedure RegistrationCallback(event: string; xml: TXMLTag);
    public
        ppdb: TJabberPPDB;
        roster: TJabberRoster;
        ChatList: TJabberChatList;
        Prefs: TPrefController;
        Agents: TStringList;
        dock_windows: boolean;

        Constructor Create(ConfigFile: string);
        Destructor Destroy; override;

        procedure CreateAccount;
        procedure Connect;
        procedure Disconnect;

        procedure setPresence(show, status: string; priority: integer);

        function RegisterCallback(callback: TPacketEvent; xplite: string; pausable: boolean = false): integer; overload;
        function RegisterCallback(callback: TRosterEvent): integer; overload;
        function RegisterCallback(callback: TPresenceEvent): integer; overload;
        procedure UnRegisterCallback(index: integer);

        procedure FireEvent(event: string; tag: TXMLTag); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const p: TJabberPres); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const ritem: TJabberRosterItem); overload;

        procedure SendTag(tag: TXMLTag);
        procedure AssignProfile(profile: TJabberProfile);
        procedure ActivateProfile(i: integer);

        procedure Pause;
        procedure Play;
        procedure QueueEvent(event: string; tag: TXMLTag; Callback: TPacketEvent);

        function NewAgentsList(srv: string): TAgents;
        function GetAgentsList(srv: string): TAgents;
        function generateID: string;
        function IsBlocked(jid : string): boolean;  overload;
        function IsBlocked(jid : TJabberID): boolean; overload;
        procedure Block(jid : TJabberID);

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
        property MyAgents: TAgents read getMyAgents;
        property IsPaused: boolean read _paused;
        property Invisible: boolean read _invisible write _invisible;
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
    XMLNS_PREFS     = 'storage:imprefs';
    XMLNS_MSGEVENTS = 'jabber:x:event';
    XMLNS_DELAY     = 'jabber:x:delay';
    XMLNS_XROSTER   = 'jabber:x:roster';

var
    MainSession: TJabberSession;


implementation
uses
    {$ifdef Win32}
    Forms, Dialogs,
    {$else}
    QForms, QDialogs,
    {$endif}
    XMLUtils, XMLSocketStream, IdGlobal,
//    XMLHttpStream, 
    iq;

{---------------------------------------}
Constructor TJabberSession.Create(ConfigFile: string);
begin
    //
    inherited Create();
    
    _stream := TXMLSocketStream.Create('stream:stream');
//    _stream := TXMLHttpStream.Create('stream:stream');
    _username := '';
    _password := '';
    _resource := '';
    _server := '';
    _register := false;
    _port := 5222;
    _id := 1;
    _cb_id := 1;
    _use_ssl := false;

    // Create the event dispatcher mechanism
    _dispatcher := TSignalDispatcher.Create;
    _packetSignal := TPacketSignal.Create();
    _sessionSignal := TBasicSignal.Create();
    _rosterSignal := TRosterSignal.Create();
    _presSignal := TPresenceSignal.Create();

    _dispatcher.AddSignal('/packet', _packetSignal);
    _dispatcher.AddSignal('/session', _sessionSignal);
    _dispatcher.AddSignal('/roster', _rosterSignal);
    _dispatcher.AddSignal('/presence', _presSignal);

    _pauseQueue := TQueue.Create();

    // Register our session to get XML Tags
    _stream.RegisterStreamCallback(Self.StreamCallback);

    // Create all the things which might register w/ the session
    ppdb := TJabberPPDB.Create;
    ppdb.SetSession(Self);

    roster := TJabberRoster.Create;
    roster.SetSession(Self);

    ChatList := TJabberChatList.Create;

    Prefs := TPrefController.Create(ConfigFile);
    Prefs.LoadProfiles;
    Prefs.SetSession(Self);

    Agents := TStringList.Create();
end;

{---------------------------------------}
Destructor TJabberSession.Destroy;
begin
    // Clean up everything

    ClearStringListObjects(ppdb);
    ClearStringListObjects(Agents);

    Prefs.Free;
    ppdb.Free;
    roster.Free;
    ChatList.Free;
    Agents.Free;

    _stream.Free;
    _pauseQueue.Free;

    // Free the dispatcher... this should free the signals
    _dispatcher.Free;

    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberSession.CreateAccount;
begin
    _register := true;
    SendRegistration();
end;

{---------------------------------------}
procedure TJabberSession.Connect;
begin
    // Switch port for SSL connections
    { Now done in dialog box
    if (_port = 5222) and (_use_ssl) then
        _port := 5223;
    }
    _stream.Connect(_server, _port, _use_ssl);
end;

{---------------------------------------}
procedure TJabberSession.Disconnect;
begin
    // Save the server side prefs and kill our connection.
    if (_stream.Active) then begin
        Prefs.SaveServerPrefs();
        _stream.Send('<presence type="unavailable"/>');
        _stream.Disconnect;
        end;
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
        _dispatcher.DispatchSignal('/session/disconnected', nil);
        ClearStringListObjects(Agents);
        ppdb.Clear;
        Roster.Clear;
        Agents.Clear;
        ppdb.Clear;
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

    if (tag <> nil) then
        tag.Free();
end;

{---------------------------------------}
procedure TJabberSession.Pause();
begin
    // pause the _pDispatcher;
    _paused := true;
end;

{---------------------------------------}
procedure TJabberSession.Play();
var
    q: TQueuedEvent;
    sig: TSignalEvent;
begin
    // playback the stuff in the queue
    _paused := false;

    while (_pauseQueue.Count > 0) do begin
        q := TQueuedEvent(_pauseQueue.pop);
        sig := TSignalEvent(q.callback);
        sig(q.event, q.tag);
        q.Free;
        end;
end;

{---------------------------------------}
procedure TJabberSession.QueueEvent(event: string; tag: TXMLTag; Callback: TPacketEvent);
var
    q: TQueuedEvent;
begin
    // Queue an event to a specific Callback
    q := TQueuedEvent.Create();
    q.callback := TMethod(Callback);
    q.event := event;

    // make sure we make a dup of tag since it's going to go away after
    // it makes the rounds thru the dispatcher.
    q.tag := TXMLTag.Create(tag);
    _pauseQueue.Push(q);
end;

{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TPacketEvent; xplite: string; pausable: boolean = false): integer;
var
    p, i: integer;
    l: TSignalListener;
    pk: TPacketListener;
    sig: TBasicSignal;
    tok1: string;
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
        pk := _packetSignal.addListener(xplite, callback);
        result := pk.cb_id;
        end
    else if i >= 0 then begin
        sig := TBasicSignal(_dispatcher.Objects[i]);
        l := sig.addListener(xplite, callback);
        result := l.cb_id;
        end;
end;

{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TRosterEvent): integer;
var
    l: TRosterListener;
begin
    // add a callback to the roster signal
    l := _rosterSignal.addListener(callback);
    Result := l.cb_id;
end;

{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TPresenceEvent): integer;
var
    l: TPresenceListener;
begin
    // add a callback to the presence signal
    l := _presSignal.addListener(callback);
    Result := l.cb_id;
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
    // dispatch a presence signal directly
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
begin
    // Unregister a callback
    _dispatcher.DeleteListener(index);
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
    Server   := profile.Server;
    Password := profile.Password;
    Resource := profile.Resource;
    Priority := profile.Priority;
    Port     := profile.Port;
end;

{---------------------------------------}
procedure TJabberSession.AuthGet;
var
    iqAuth: TJabberIQ;
begin
    // find out the potential auth kinds for this user
    // iqAuth := TJabberIQ.Create(Self, generateID, Self.AuthGetCallback);
    iqAuth := TJabberIQ.Create(Self, generateID, AuthGetCallback, 180);
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
    iqReg := TJabberIQ.Create(Self, generateID, RegistrationCallback, 180);
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
var
    cur_agents: TAgents;
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
        cur_agents := TAgents.Create();
        Agents.AddObject(_server, cur_agents);
        cur_agents.Fetch(_server);
        Prefs.FetchServerPrefs();
        end;
end;

{---------------------------------------}
procedure TJabberSession.ActivateProfile(i: integer);
var
    p: TJabberProfile;
begin
    Assert((i >= 0) and (i < Prefs.Profiles.Count));

    // make this profile the active one..
    p := TJabberProfile(Prefs.Profiles.Objects[i]);

    // Update the session object
    Server := p.Server;
    Username := p.Username;
    password := p.password;
    resource := p.Resource;
    Priority := p.Priority;
    Port     := p.Port;
    _use_ssl := p.ssl;
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

    // if we are going away or xa, save the prefs
    if ((show = 'away') or (show = 'xa')) then
        Prefs.SaveServerPrefs();

    MainSession.FireEvent('/session/presence', nil);
end;

{---------------------------------------}
function TJabberSession.getMyAgents: TAgents;
begin
    //
    if (Agents.Count > 0) then
        Result := TAgents(Agents.Objects[0])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberSession.NewAgentsList(srv: string): TAgents;
begin
    // create some new agents list object and return it
    Result := TAgents.Create();
    Self.Agents.AddObject(srv, Result);
end;

{---------------------------------------}
function TJabberSession.GetAgentsList(srv: string): TAgents;
var
    idx: integer;
begin
    idx := Agents.indexOf(srv);
    if (idx >= 0) then
        Result := TAgents(Agents.Objects[idx])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberSession.IsBlocked(jid : string): boolean;
var
    tmp_jid:  TJabberID;
begin
    tmp_jid := TJabberID.Create(jid);
    result := IsBlocked(tmp_jid);
    tmp_jid.Free();
end;

{---------------------------------------}
function TJabberSession.IsBlocked(jid : TJabberID): boolean;
var
    blockers: TStringList;
begin
    blockers := TStringList.Create();
    Prefs.fillStringlist('blockers', blockers);
    if (blockers.IndexOf(jid.jid) < 0) then
        result := false
    else
        result := true;
    blockers.Free();
end;

procedure TJabberSession.Block(jid : TJabberID);
var
    blockers: TStringList;
    block: TXMLTag;
begin
    blockers := TStringList.Create();
    Prefs.fillStringlist('blockers', blockers);
    if (blockers.IndexOf(jid.jid) < 0) then begin
        blockers.Add(jid.jid);
        Prefs.setStringlist('blockers', blockers);
        end;
    blockers.Free();
    block := TXMLTag.Create('block');
    block.PutAttribute('jid', jid.jid);
    MainSession.FireEvent('/session/block', block);
end;

end.

