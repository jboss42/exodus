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
    Signals, XMLStream, XMLTag, Unicode, 
    Contnrs, Classes, SysUtils, JabberID;

type
    TJabberAuthType = (jatZeroK, jatDigest, jatPlainText, jatNoAuth);

    TJabberSession = class
    private
        _stream: TXMLStream;
        _register: boolean;
        _stream_id: WideString;
        _show: WideString;
        _status: WideString;
        _priority: integer;
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

        procedure SetUsername(username: WideString);
        procedure SetPassword(password: WideString);
        procedure SetServer(server: WideString);
        procedure SetResource(resource: WideString);
        procedure SetPort(port: integer);

        procedure handleDisconnect();

        function GetUsername(): WideString;
        function GetPassword(): WideString;
        function GetServer(): WideString;
        function GetResource(): WideString;
        function GetPort(): integer;

        function GetActive(): boolean;
    published
        procedure AuthGetCallback(event: string; xml: TXMLTag);
        procedure AuthCallback(event: string; tag: TXMLTag);
        procedure RegistrationCallback(event: string; xml: TXMLTag);


        procedure DataEvent(send: boolean; data: Widestring);
    public
        ppdb: TJabberPPDB;
        roster: TJabberRoster;
        ChatList: TJabberChatList;
        Prefs: TPrefController;
        Agents: TStringList;
        dock_windows: boolean;
        Presence_XML: TWideStringlist;

        Constructor Create(ConfigFile: widestring);
        Destructor Destroy; override;

        procedure CreateAccount;
        procedure Connect;
        procedure Disconnect;

        procedure setPresence(show, status: WideString; priority: integer);

        function RegisterCallback(callback: TPacketEvent; xplite: string; pausable: boolean = false): integer; overload;
        function RegisterCallback(callback: TRosterEvent): integer; overload;
        function RegisterCallback(callback: TPresenceEvent): integer; overload;
        function RegisterCallback(callback: TDataStringEvent): integer; overload;
        procedure UnRegisterCallback(index: integer);

        procedure FireEvent(event: string; tag: TXMLTag); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const p: TJabberPres); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const ritem: TJabberRosterItem); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const data: WideString); overload;

        procedure SendTag(tag: TXMLTag);
        procedure ActivateProfile(i: integer);

        procedure Pause;
        procedure Play;
        procedure QueueEvent(event: string; tag: TXMLTag; Callback: TPacketEvent);

        function NewAgentsList(srv: WideString): TAgents;
        function GetAgentsList(srv: WideString): TAgents;
        function generateID: WideString;
        function IsBlocked(jid : WideString): boolean;  overload;
        function IsBlocked(jid : TJabberID): boolean; overload;

        procedure Block(jid : TJabberID);
        procedure UnBlock(jid : TJabberID);


        property Username: WideString read GetUsername write SetUsername;
        property Password: WideString read GetPassword write SetPassword;
        property Server: WideString read GetServer write SetServer;
        property Resource: WideString read GetResource write SetResource;
        property Port: integer read GetPort write SetPort;
        property Priority: integer read _priority write _priority;
        property Show: WideString read _show;
        property Status: WideString read _status;
        property Stream: TXMLStream read _stream;
        property Dispatcher: TSignalDispatcher read _dispatcher;
        property MyAgents: TAgents read getMyAgents;
        property IsPaused: boolean read _paused;
        property Invisible: boolean read _invisible write _invisible;
        property Active: boolean read GetActive;
        property Profile: TJabberProfile read _profile;
    end;

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
    JabberConst, iq;

var
    _auth_iq: TJabberIQ;


{---------------------------------------}
Constructor TJabberSession.Create(ConfigFile: widestring);
begin
    //
    inherited Create();

    _register := false;
    _id := 1;
    _cb_id := 1;
    _profile := nil;
    _auth_iq := nil;

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

    Presence_XML := TWideStringlist.Create();

end;

{---------------------------------------}
Destructor TJabberSession.Destroy;
begin
    // Clean up everything

    ClearStringListObjects(ppdb);
    ClearStringListObjects(Agents);

    ppdb.Clear();
    Agents.Clear();

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
procedure TJabberSession.SetUsername(username: WideString);
begin
    _profile.Username := username;
end;

{---------------------------------------}
function TJabberSession.GetUsername(): WideString;
begin
    if (_profile = nil) then
        result := ''
    else
        result := _profile.Username;
end;

{---------------------------------------}
procedure TJabberSession.SetPassword(password: WideString);
begin
    _profile.Password := Trim(password);
end;

{---------------------------------------}
function TJabberSession.GetPassword(): WideString;
begin
    if (_profile = nil) then
        result := ''
    else
        result := _profile.Password;
end;

{---------------------------------------}
procedure TJabberSession.SetServer(server: WideString);
begin
    _profile.Server := server;
end;

{---------------------------------------}
function TJabberSession.GetServer(): WideString;
begin
    if (_profile = nil) then
        result := ''
    else
        result := _profile.Server;
end;

{---------------------------------------}
procedure TJabberSession.SetResource(resource: WideString);
begin
    _profile.Resource := resource;
end;

{---------------------------------------}
function TJabberSession.GetResource(): WideString;
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

    if (Self.Stream.Active) then begin
        Prefs.SaveServerPrefs();
        _stream.Send('<presence type="unavailable"/>');
        _stream.Disconnect;
    end
    else
        Self.handleDisconnect();

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
procedure TJabberSession.DataEvent(send: boolean; data: Widestring);
begin
    // we are getting data from the socket
    if (send) then
        _dataSignal.Invoke('/data/send', nil, data)
    else
        _dataSignal.Invoke('/data/recv', nil, data);
end;

{---------------------------------------}
procedure TJabberSession.handleDisconnect();
begin
    // Clear the roster, ppdb and fire the callbacks
    _dispatcher.DispatchSignal('/session/disconnected', nil);
    ClearStringListObjects(Agents);
    ppdb.Clear;
    Roster.Clear;
    Agents.Clear;
    ppdb.Clear;

    _stream.Free();
    _stream := nil;
end;

{---------------------------------------}
procedure TJabberSession.StreamCallback(msg: string; tag: TXMLTag);
var
    tmps: WideString;
begin
    // Process callback info..
    if msg = 'connected' then begin
        // we are connected... send auth stuff.
        tmps := '<stream:stream to="' + Trim(Server) + '" xmlns="jabber:client" xmlns:stream="http://etherx.jabber.org/streams">';
        _stream.Send(tmps);
    end

    else if msg = 'disconnected' then
        Self.handleDisconnect()

    else if msg = 'commtimeout' then
        _dispatcher.DispatchSignal('/session/commtimeout', nil)
        
    else if msg = 'commerror' then
        _dispatcher.DispatchSignal('/session/commerror', nil)

    else if msg = 'xml' then begin
        // process XML
        // always fire debug
        if (tag.Name = 'stream:stream') then begin
            // we got dropped
            _stream_id := tag.getAttribute('id');
            _dispatcher.DispatchSignal('/session/connected', nil);

            if _register then
                SendRegistration()
            else
                AuthGet();

        end
        else if (tag.Name = 'stream:error') then begin
            // we got a stream error
            FireEvent('/session/stream:error', tag);
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

    // XXX: WOAH! Make sure things are played back or cleared when we get disconnected.
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
procedure TJabberSession.FireEvent(event: string; tag: TXMLTag; const data: WideString);
begin
    // dispatch a data event directly
    _dataSignal.Invoke(event, tag, data);
end;

{---------------------------------------}
procedure TJabberSession.UnRegisterCallback(index: integer);
begin
    // Unregister a callback
    if (index >= 0) then
        _dispatcher.DeleteListener(index);
end;

{---------------------------------------}
function TJabberSession.generateID: WideString;
begin
    Result := 'jcl_' + IntToStr(_id);
    _id := _id + 1;
end;

{---------------------------------------}
procedure TJabberSession.AuthGet;
begin
    // find out the potential auth kinds for this user
    if (_auth_iq <> nil) then _auth_iq.Free();

    _auth_iq := TJabberIQ.Create(Self, generateID, AuthGetCallback, 180);
    with _auth_iq do begin
        Namespace := XMLNS_AUTH;
        iqType := 'get';
        with qTag do
            AddBasicTag('username', Username);
    end;
    _auth_iq.Send;
end;

{---------------------------------------}
procedure TJabberSession.SendRegistration;
begin
    // send an iq register
    if (_auth_iq <> nil) then _auth_iq.Free();

    _auth_iq := TJabberIQ.Create(Self, generateID, RegistrationCallback, 180);
    with _auth_iq do begin
        Namespace := XMLNS_REGISTER;
        iqType := 'set';
        with qTag do begin
            AddBasicTag('username', Username);
            AddBasicTag('password', Password);
        end;
    end;
    _auth_iq.Send;
end;

{---------------------------------------}
procedure TJabberSession.RegistrationCallback(event: string; xml: TXMLTag);
begin
    // callback from our registration request
    _auth_iq := nil;
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
    etag, tok, seq, dig, qtag: TXMLTag;
    authDigest, authHash, authToken, hashA, key: WideString;
    i, authSeq: integer;
begin
    // auth get result or error
    _auth_iq := nil;
    if ((xml = nil) or (xml.getAttribute('type') = 'error')) then begin
        if (xml <> nil) then begin
            // check for non-existant account
            etag := xml.GetFirstTag('error');
            if ((etag <> nil) and
                (etag.getAttribute('code') = '401'))then begin
                _dispatcher.DispatchSignal('/session/noaccount', xml);
                exit;
            end;
        end;

        // otherwise, auth-error
        _dispatcher.DispatchSignal('/session/autherror', xml);
    end;

    qtag := xml.GetFirstTag('query');
    if qtag = nil then exit;

    seq := qtag.GetFirstTag('sequence');
    tok := qtag.GetFirstTag('token');
    dig := qtag.GetFirstTag('digest');

    // setup the iq-set
    _auth_iq := TJabberIQ.Create(Self, generateID, AuthCallback, 180);
    with _auth_iq do begin
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
        _auth_iq.qTag.AddBasicTag('hash', authHash);
    end

    else if dig <> nil then begin
        // Digest (basic Sha1)
        _AuthType := jatDigest;
        authDigest := Sha1Hash(Trim(_stream_id + Password));
        _auth_iq.qTag.AddBasicTag('digest', authDigest);
    end

    else begin
        // Plaintext
        _AuthType := jatPlainText;
        _auth_iq.qTag.AddBasicTag('password', Password);
    end;
    _auth_iq.Send;
end;

{---------------------------------------}
procedure TJabberSession.AuthCallback(event: string; tag: TXMLTag);
var
    cur_agents: TAgents;
begin
    // check the result of the authentication
    _auth_iq := nil;
    if ((tag = nil) or (tag.getAttribute('type') = 'error')) then begin
        // timeout
        _dispatcher.DispatchSignal('/session/autherror', tag);
        Disconnect();
    end
    else begin
        _dispatcher.DispatchSignal('/session/authenticated', tag);
        // Self.RegisterCallback(ChatList.MsgCallback, '/packet/message[@type="chat"]');
        Self.RegisterCallback(ChatList.MsgCallback, '/packet/message');
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
    _priority := _profile.Priority;
end;

{---------------------------------------}
procedure TJabberSession.setPresence(show, status: WideString; priority: integer);
var
    p: TJabberPres;
    i: integer;
begin
    _show := show;
    _status := status;
    _priority := priority;

    if (Self.Active) then begin
        p := TJabberPres.Create();
        p.Show := show;
        p.Status := status;
        if (priority = -1) then priority := 0;
        p.Priority := priority;
        if (_invisible) then
            p.PresType := 'invisible';

        for i := 0 to Presence_XML.Count - 1 do
            p.addInsertedXML(Presence_XML[i]);

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
function TJabberSession.NewAgentsList(srv: WideString): TAgents;
begin
    // create some new agents list object and return it
    Result := TAgents.Create();
    Self.Agents.AddObject(srv, Result);
end;

{---------------------------------------}
function TJabberSession.GetAgentsList(srv: WideString): TAgents;
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
function TJabberSession.IsBlocked(jid : WideString): boolean;
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
    blockers: TWideStringList;
begin
    blockers := TWideStringList.Create();
    Prefs.fillStringlist('blockers', blockers);
    if (blockers.IndexOf(jid.jid) < 0) then
        result := false
    else
        result := true;
    blockers.Free();

    if (Prefs.getBool('block_nonroster')) then begin
        // block this jid if they are not in my roster
        Result := (Roster.Find(jid.jid) = nil); 
    end;
end;

{---------------------------------------}
procedure TJabberSession.UnBlock(jid : TJabberID);
var
    i: integer;
    blockers: TWideStringList;
    block : TXMLTag;
begin
    blockers := TWideStringList.Create();
    Prefs.fillStringlist('blockers', blockers);
    i := blockers.IndexOf(jid.jid);
    if (i >= 0) then begin
        blockers.Delete(i);
        Prefs.setStringlist('blockers', blockers);
    end;
    blockers.Free();
    block := TXMLTag.Create('unblock');
    block.setAttribute('jid', jid.jid);
    MainSession.FireEvent('/session/unblock', block);
    block.Free();
end;

{---------------------------------------}
procedure TJabberSession.Block(jid : TJabberID);
var
    blockers: TWideStringList;
    block: TXMLTag;
begin
    blockers := TWideStringList.Create();
    Prefs.fillStringlist('blockers', blockers);
    if (blockers.IndexOf(jid.jid) < 0) then begin
        blockers.Add(jid.jid);
        Prefs.setStringlist('blockers', blockers);
    end;
    blockers.Free();
    block := TXMLTag.Create('block');
    block.setAttribute('jid', jid.jid);
    MainSession.FireEvent('/session/block', block);
    block.Free();
end;

function TJabberSession.GetActive(): boolean;
begin
    Result := (_stream <> nil);
end;


end.

