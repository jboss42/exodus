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
        _stream_id: string;
        _show: string;
        _status: string;
        _AuthType: TJabberAuthType;
        _invisible: boolean;
        _profile: TJabberProfile;

        // Dispatcher
        _dispatcher: TSignalDispatcher;
        _packetSignal: TPacketSignal;
        _sessionSignal: TBasicSignal;
        _rosterSignal: TRosterSignal;
        _presSignal: TPresenceSignal;
        _dataSignal: TStringSignal;

        _paused: boolean;
        _pauseQueue: TQueue;

        _id: longint;
        _cb_id: longint;

        procedure StreamCallback(msg: string; tag: TXMLTag);

        // auth stuff
        procedure AuthGet;
        procedure SendRegistration;

        function getMyAgents(): TAgents;

        procedure SetUsername(username: string);
        procedure SetPassword(password: string);
        procedure SetServer(server: string);
        procedure SetResource(resource: string);
        procedure SetPort(port: integer);
        procedure SetPriority(priority: integer);

        function GetUsername(): string;
        function GetPassword(): string;
        function GetServer(): string;
        function GetResource(): string;
        function GetPort(): integer;
        function GetPriority(): integer;

        function GetActive(): boolean;
    published
        procedure AuthGetCallback(event: string; xml: TXMLTag);
        procedure AuthCallback(event: string; tag: TXMLTag);
        procedure RegistrationCallback(event: string; xml: TXMLTag);

        procedure DataEvent(send: boolean; data: string);
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
        function RegisterCallback(callback: TDataStringEvent): integer; overload;
        procedure UnRegisterCallback(index: integer);

        procedure FireEvent(event: string; tag: TXMLTag); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const p: TJabberPres); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const ritem: TJabberRosterItem); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const data: string); overload;

        procedure SendTag(tag: TXMLTag);
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

        property Username: string read GetUsername write SetUsername;
        property Password: string read GetPassword write SetPassword;
        property Server: string read GetServer write SetServer;
        property Resource: string read GetResource write SetResource;
        property Port: integer read GetPort write SetPort;
        property Priority: integer read GetPriority write SetPriority;
        property Show: string read _show;
        property Status: string read _status;
        property Stream: TXMLStream read _stream;
        property Dispatcher: TSignalDispatcher read _dispatcher;
        property MyAgents: TAgents read getMyAgents;
        property IsPaused: boolean read _paused;
        property Invisible: boolean read _invisible write _invisible;
        property Active: boolean read GetActive;
        property Profile: TJabberProfile read _profile;
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
    XMLNS_CONFERENCE= 'jabber:iq:conference';

var
    MainSession: TJabberSession;


implementation
uses
    {$ifdef Win32}
    Forms, Dialogs,
    {$else}
    QForms, QDialogs,
    {$endif}
    XMLUtils, XMLSocketStream, XMLHttpStream, IdGlobal,
    iq;

{---------------------------------------}
Constructor TJabberSession.Create(ConfigFile: string);
begin
    //
    inherited Create();

    _register := false;
    _id := 1;
    _cb_id := 1;
    _profile := nil;

    // Create the event dispatcher mechanism
    _dispatcher := TSignalDispatcher.Create;
    _packetSignal := TPacketSignal.Create();
    _sessionSignal := TBasicSignal.Create();
    _rosterSignal := TRosterSignal.Create();
    _presSignal := TPresenceSignal.Create();
    _dataSignal := TStringSignal.Create();

    _dispatcher.AddSignal('/packet', _packetSignal);
    _dispatcher.AddSignal('/session', _sessionSignal);
    _dispatcher.AddSignal('/roster', _rosterSignal);
    _dispatcher.AddSignal('/presence', _presSignal);
    _dispatcher.AddSignal('/data', _dataSignal);

    _pauseQueue := TQueue.Create();

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

    if (_stream <> nil) then
        _stream.Free;
    _pauseQueue.Free;

    // Free the dispatcher... this should free the signals
    _dispatcher.Free;

    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberSession.SetUsername(username: string);
begin
    _profile.Username := username;
end;

{---------------------------------------}
function TJabberSession.GetUsername(): string;
begin
    if (_profile = nil) then
        result := ''
    else
        result := _profile.Username;
end;

{---------------------------------------}
procedure TJabberSession.SetPassword(password: string);
begin
    _profile.Password := password;
end;

{---------------------------------------}
function TJabberSession.GetPassword(): string;
begin
    if (_profile = nil) then
        result := ''
    else
        result := _profile.Password;
end;

{---------------------------------------}
procedure TJabberSession.SetServer(server: string);
begin
    _profile.Password := server;
end;

{---------------------------------------}
function TJabberSession.GetServer(): string;
begin
    if (_profile = nil) then
        result := '';
    result := _profile.Server;
end;

{---------------------------------------}
procedure TJabberSession.SetResource(resource: string);
begin
    _profile.Resource := resource;
end;

{---------------------------------------}
function TJabberSession.GetResource(): string;
begin
    if (_profile = nil) then
        result := ''
    else
        result := _profile.Resource;
end;

{---------------------------------------}
procedure TJabberSession.SetPort(port: integer);
begin
    _profile.Port := port;
end;

{---------------------------------------}
function TJabberSession.GetPort(): integer;
begin
    if (_profile = nil) then
        result := 0
    else
        result := _profile.Port;
end;

{---------------------------------------}
procedure TJabberSession.SetPriority(priority: integer);
begin
    _profile.Priority := priority;
end;

{---------------------------------------}
function TJabberSession.GetPriority(): integer;
begin
    if (_profile = nil) then
        result := 0
    else
        result := _profile.Priority;
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
    if (_profile = nil) then
        raise Exception.Create('Invalid profile')
    else if (_stream <> nil) then
        raise Exception.Create('Session is already connected');

    case _profile.ConnectionType of
    conn_normal:
        _stream := TXMLSocketStream.Create('stream:stream');
    conn_http:
        _stream := TXMLHttpStream.Create('stream:stream');
    else
        // don't I18N
        raise Exception.Create('Invalid connection type');
    end;

    // Register our session to get XML Tags
    _stream.RegisterStreamCallback(Self.StreamCallback);
    _stream.OnData := DataEvent;

    _stream.Connect(_profile);
end;

{---------------------------------------}
procedure TJabberSession.Disconnect;
begin
    // Save the server side prefs and kill our connection.
    if (_stream = nil) then exit;

    Prefs.SaveServerPrefs();
    _stream.Send('<presence type="unavailable"/>');
    _stream.Disconnect;

    _register := false;
end;

{---------------------------------------}
procedure TJabberSession.SendTag(tag: TXMLTag);
begin
    // Send this tag out to the socket
    if (_stream <> nil) then begin
        _stream.SendTag(tag);
        tag.Free;
        end
    else begin
        tag.Free;
        raise Exception.Create('Invalid stream');
        end;
end;

{---------------------------------------}
procedure TJabberSession.DataEvent(send: boolean; data: string);
begin
    // we are getting data from the socket
    if (send) then
        _dataSignal.Invoke('/data/send', nil, data)
    else
        _dataSignal.Invoke('/data/recv', nil, data);
end;

{---------------------------------------}
procedure TJabberSession.StreamCallback(msg: string; tag: TXMLTag);
var
    tmps: string;
begin
    // Process callback info..
    if msg = 'connected' then begin
        // we are connected... send auth stuff.
        tmps := '<stream:stream to="' + Trim(Server) + '" xmlns="jabber:client" xmlns:stream="http://etherx.jabber.org/streams">';
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

        _stream.Free();
        _stream := nil;
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
function TJabberSession.RegisterCallback(callback: TDataStringEvent): integer;
var
    sl: TStringListener;
begin
    // add a callback to the data signal
    sl := _dataSignal.addListener(callback);
    Result := sl.cb_id;
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
procedure TJabberSession.FireEvent(event: string; tag: TXMLTag; const data: string);
begin
    // dispatch a data event directly
    _dataSignal.Invoke(event, tag, data);
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
            AddBasicTag('username', Username);
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
            AddBasicTag('username', Username);
            AddBasicTag('password', Password);
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
        qTag.AddBasicTag('username', Username);
        qTag.AddBasicTag('resource', Resource);
        end;

    if seq <> nil then begin
        if tok = nil then exit;
        // Zero-k auth
        _AuthType := jatZeroK;
        authSeq := StrToInt(seq.data);
        authToken := tok.Data;
        hashA := Sha1Hash(Password);
        key := Sha1Hash(Trim(hashA) + Trim(authToken));
        for i := 1 to authSeq do
            key := Sha1Hash(key);
        authHash := key;
        Auth.qTag.AddBasicTag('hash', authHash);
        end

    else if dig <> nil then begin
        // Digest (basic Sha1)
        _AuthType := jatDigest;
        authDigest := Sha1Hash(Trim(_stream_id + Password));
        Auth.qTag.AddBasicTag('digest', authDigest);
        end

    else begin
        // Plaintext
        _AuthType := jatPlainText;
        Auth.qTag.AddBasicTag('password', Password);
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
        Agents.AddObject(Server, cur_agents);
        cur_agents.Fetch(Server);
        Prefs.FetchServerPrefs();
        end;
end;

{---------------------------------------}
procedure TJabberSession.ActivateProfile(i: integer);
begin
    Assert((i >= 0) and (i < Prefs.Profiles.Count));

    // make this profile the active one..
    _profile := TJabberProfile(Prefs.Profiles.Objects[i]);
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
    _profile.Priority := priority;
    SendTag(p);

    // if we are going away or xa, save the prefs
    if ((show = 'away') or (show = 'xa')) then
        Prefs.SaveServerPrefs();

    MainSession.FireEvent('/session/presence', nil);

    if (_paused) then begin
        // If the session is paused, and we're changing back
        // to available, or chat, then make sure we play the session
        if ((_show <> 'away') and (_show <> 'xa') and (_show <> 'dnd')) then
            Self.Play();
        end;
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

{---------------------------------------}
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

function TJabberSession.GetActive(): boolean;
begin
    Result := (_stream <> nil);
end;

end.

