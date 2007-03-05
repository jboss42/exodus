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

{$ifdef VER150}
    {$define INDY9}
{$endif}

interface

uses
    PrefController,
    JabberAuth, Chat, ChatController, MsgList, Presence, Roster, Bookmarks, NodeItem,
    Signals, XMLStream, XMLTag, Unicode,
    Contnrs, Classes, SysUtils, JabberID, GnuGetText;

const
    sErrorRevoke = 'Error on attempt to revoke voice from owner or user with a higher affiliation';
type
    TJabberAuthType = (jatZeroK, jatDigest, jatPlainText, jatNoAuth);

    TJabberSession = class
    private
        _stream: TXMLStream;
        _register: boolean;
        _stream_id: WideString;
        _show: WideString;
        _status: WideString;
        _extensions: TWideStringList;
        _priority: integer;
        _invisible: boolean;
        _profile: TJabberProfile;
        _features: TXMLTag;
        _xmpp: boolean;
        _cur_server: Widestring;
        _tls_cb: integer;
        _ssl_on: boolean;
        _compression_cb: integer;
        _compression_err_cb: integer;
        _compression_on: boolean;
        _lang: WideString;
        _sent_stream: boolean;

        // Dispatcher
        _dispatcher: TSignalDispatcher;

        // main packet handling signals
        _filterSignal: TPacketSignal;
        _preSignal: TPacketSignal;
        _packetSignal: TPacketSignal;
        _postSignal: TPacketSignal;
        _sessionSignal: TBasicSignal;
        _unhandledSignal: TBasicSignal;

        // other signals
        _rosterSignal: TRosterSignal;
        _presSignal: TPresenceSignal;
        _dataSignal: TStringSignal;
        _winSignal: TPacketSignal;
        _chatSignal: TChatSignal;

        // other misc. flags
        _paused: boolean;
        _resuming: boolean;
        _pauseQueue: TQueue;
        _id: longint;
        _cb_id: longint;
        _authd: boolean;
        _first_pres: boolean;
        _avails: TWidestringlist;
        _auth_agent: TJabberAuth;
        _no_auth: boolean;

        procedure StreamCallback(msg: string; tag: TXMLTag);

        procedure SetUsername(username: WideString);
        procedure SetPassword(password: WideString);
        procedure SetServer(server: WideString);
        procedure SetResource(resource: WideString);
        procedure SetPort(port: integer);

        procedure handleDisconnect();
        procedure manualBlastPresence(p: TXMLTag);
        procedure StartSession(tag: TXMLTag);
        procedure ResetStream();
        procedure StartTLS();
        procedure StartCompression(method: Widestring);

        function GetUsername(): WideString;
        function GetPassword(): WideString;
        function GetServer(): WideString;
        function GetResource(): WideString;
        function GetPort(): integer;
        function GetFullJid(): Widestring;
        function GetBareJid(): Widestring;
        function GetActive(): boolean;

        procedure doConnect();

    published
        procedure DataEvent(send: boolean; data: Widestring);
        procedure SessionCallback(event: string; tag: TXMLTag);
        procedure BindCallback(event: string; tag: TXMLTag);
        procedure TLSCallback(event: string; tag: TXMLTag);
        procedure CompressionCallback(event: string; tag: TXMLTag);
        procedure CompressionErrorCallback(event: string; tag: TXMLTag);

    public
        ppdb: TJabberPPDB;
        roster: TJabberRoster;
        bookmarks: TBookmarkManager;
        MsgList: TJabberMsgList;
        ChatList: TJabberChatList;
        Prefs: TPrefController;
        dock_windows: boolean;
        Presence_XML: TWideStringlist;

        Constructor Create(ConfigFile: widestring);
        Destructor Destroy; override;

        procedure CreateAccount;
        procedure Connect;
        procedure Disconnect;

        // AuthAgent stuff
        procedure setAuthAgent(new_auth: TJabberAuth);
        {*
            Create an auth agaent from current profile information UNLESS
            already assigned. nop if already assigned.
        *}
        procedure checkAuthAgent();
        procedure setAuthdJID(user, host, res: Widestring);
        procedure setAuthenticated(ok: boolean; tag: TXMLTag; reset_stream: boolean);
        function  getAuthAgent: TJabberAuth;

        procedure setPresence(show, status: WideString; priority: integer);
        function  GetExtList(): TWideStringList;
        function  GetExtStr(): WideString;
        procedure AddExtension(ext: WideString; feature: WideString);
        procedure RemoveExtension(ext: WideString);

        function RegisterCallback(callback: TPacketEvent; xplite: Widestring; pausable: boolean = false): integer; overload;
        function RegisterCallback(callback: TRosterEvent; xplite: Widestring): integer; overload;
        function RegisterCallback(callback: TPresenceEvent): integer; overload;
        function RegisterCallback(callback: TDataStringEvent): integer; overload;
        function RegisterCallback(callback: TChatEvent): integer; overload;
        procedure UnRegisterCallback(index: integer);

        procedure FireEvent(event: string; tag: TXMLTag); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const p: TJabberPres); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const ritem: TJabberRosterItem); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const data: WideString); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const controller: TChatController); overload;

        procedure SendTag(tag: TXMLTag);
        procedure ActivateProfile(i: integer);

        procedure Pause;
        procedure Play;
        procedure QueueEvent(event: string; tag: TXMLTag; Callback: TPacketEvent);

        function generateID: WideString;
        function IsBlocked(jid : WideString): boolean;  overload;
        function IsBlocked(jid : TJabberID): boolean; overload;
        function getDisplayUsername(): widestring;

        procedure Block(jid : TJabberID);
        procedure UnBlock(jid : TJabberID);     

        procedure addAvailJid(jid: Widestring);
        procedure removeAvailJid(jid: Widestring);

        // Added by SIG for setting default nickname.
//JJF now handled by DisplayName        
//        procedure SetDefaultNickname();
//        procedure vcardCallback(event: string; tag: TXMLTag);

        // Account information
        property Username: WideString read GetUsername write SetUsername;
        property Password: WideString read GetPassword write SetPassword;
        property Server: WideString read GetServer write SetServer;
        property Resource: WideString read GetResource write SetResource;
        property Jid: Widestring read GetFullJid;
        property BareJid: Widestring read GetBareJid;
        property Port: integer read GetPort write SetPort;
        property Profile: TJabberProfile read _profile;

        // Presence Info
        property Priority: integer read _priority write _priority;
        property Show: WideString read _show;
        property Status: WideString read _status;

        // Stream stuff
        property Stream: TXMLStream read _stream;
        property StreamID: Widestring read _stream_id;
        property Dispatcher: TSignalDispatcher read _dispatcher;
        property IsPaused: boolean read _paused;
        property IsResuming: boolean read _resuming;
        property Invisible: boolean read _invisible write _invisible;
        property Active: boolean read GetActive;
        property isXMPP: boolean read _xmpp;
        property xmppFeatures: TXMLTag read _features;
        property SSLEnabled: boolean read _ssl_on;
        property xmlLang: WideString read _lang;
        property CompressionEnabled: boolean read _compression_on;

        // Auth info
        property NoAuth: boolean read _no_auth write _no_auth;
        property AuthAgent: TJabberAuth read _auth_agent;
        property Authenticated: boolean read _authd;
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
    EntityCache, CapsCache,
    DisplayName, //display name cache
    PluginAuth,
    XMLUtils, XMLSocketStream, XMLHttpStream, IdGlobal, IQ,
    JabberConst, CapPresence, XMLVCard, Windows, strutils, JabberUtils;

{---------------------------------------}
Constructor TJabberSession.Create(ConfigFile: widestring);
var
    exe_FullPath: string;
    exe_FullPath_len: cardinal;
begin
    //
    inherited Create();

    _register := false;
    _id := 1;
    _cb_id := 1;
    _profile := nil;

    // Create the event dispatcher mechanism
    _dispatcher := TSignalDispatcher.Create;

    // Core packet signals
    _filterSignal := TPacketSignal.Create('/filter', '/pre');
    _preSignal := TPacketSignal.Create('/pre', '/packet');
    _packetSignal := TPacketSignal.Create('/packet', '/post');
    _postSignal := TPacketSignal.Create('/post', '/unhandled');
    _unhandledSignal := TBasicSignal.Create('/unhandled');
    _dispatcher.AddSignal(_filterSignal);
    _dispatcher.AddSignal(_preSignal);
    _dispatcher.AddSignal(_packetSignal);
    _dispatcher.AddSignal(_postSignal);
    _dispatcher.AddSignal(_unhandledSignal);

    // other signals
    _sessionSignal := TBasicSignal.Create('/session');
    _rosterSignal := TRosterSignal.Create('/roster');
    _presSignal := TPresenceSignal.Create('/presence');
    _dataSignal := TStringSignal.Create('/data');
    _winSignal := TPacketSignal.Create('/windows');
    _chatSignal := TChatSignal.Create('/chat');
    _dispatcher.AddSignal(_sessionSignal);
    _dispatcher.AddSignal(_rosterSignal);
    _dispatcher.AddSignal(_presSignal);
    _dispatcher.AddSignal(_dataSignal);
    _dispatcher.AddSignal(_winSignal);
    _dispatcher.AddSignal(_chatSignal);

    _pauseQueue := TQueue.Create();
    _avails := TWidestringlist.Create();
    _features := nil;
    _xmpp := false;
    _ssl_on := false;
    _compression_on := false;
    _tls_cb := -1;
    _compression_cb := -1;
    _compression_err_cb := -1;

    // Create all the things which might register w/ the session
    jCapsCache.SetSession(Self);

    //display name cache
    DisplayName.getDisplayNameCache().setSession(Self);
    
    // Create the Presence Proxy Database (PPDB)
    ppdb := TJabberPPDB.Create;
    ppdb.SetSession(Self);

    // Create the Roster
    roster := TJabberRoster.Create;
    roster.SetSession(Self);

    // Create the bookmark manager
    bookmarks := TBookmarkManager.Create();
    bookmarks.SetSession(Self);

    // Create the msg & chat controllers
    MsgList := TJabberMsgList.Create();
    ChatList := TJabberChatList.Create();
    MsgList.SetSession(Self);
    ChatList.SetSession(Self);

    // Create the preferences controller
    Prefs := TPrefController.Create(ConfigFile);
    Prefs.LoadProfiles;
    Prefs.SetSession(Self);
    SetLength(exe_FullPath, MAX_PATH+1);
    exe_FullPath_len := GetModuleFileName(0, PChar(exe_FullPath), MAX_PATH);
    exe_FullPath := LeftStr(exe_FullPath, exe_FullPath_len);
    Prefs.setString('exe_FullPath', exe_FullPath);

    if (Prefs.getBool('always_lang')) then
        _lang := Prefs.getString('locale')
    else
        _lang := '';
    if (Prefs.getBool('branding_priority_notifications') = false) then
      Prefs.setBool('show_priority', false);

    // Create the Presence_XML list for stashing stuff in every pres packet
    Presence_XML := TWideStringlist.Create();

    _extensions := TWideStringList.Create();
end;

{---------------------------------------}
Destructor TJabberSession.Destroy;
begin
    // Clean up everything

    ClearStringListObjects(ppdb);
    ppdb.Clear();
    Prefs.Free();
    ppdb.Free();
    roster.Free();
    bookmarks.Free();
    MsgList.Free();
    ChatList.Free();
    ClearStringListObjects(_extensions);
    _extensions.Free();

    _avails.Free();

    if (_stream <> nil) then
        _stream.Free();

    _pauseQueue.Free();
    Presence_XML.Free();

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
function TJabberSession.GetFullJid(): WideString;
begin
    if (_profile = nil) then
        result := ''
    else
        result := _profile.Username + '@' + _profile.Server + '/' +
            _profile.Resource;
end;

{---------------------------------------}
function TJabberSession.GetBareJid(): Widestring;
begin
    if (_profile = nil) then
        Result := ''
    else
        Result := _profile.username + '@' + _profile.server;
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
    else if (_cur_server <> '') then
        result := _cur_server
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
    if (not _auth_agent.StartRegistration()) then begin
        // this auth mechanism doesn't support registration
        _register := false;
        Self.FireEvent('/session/gui/reg-not-supported', nil);
    end;
end;

{---------------------------------------}
procedure TJabberSession.Connect;
begin
    DoConnect();
end;

{---------------------------------------}
procedure TJabberSession.DoConnect;
begin
    assert(_stream = nil);
    _sent_stream := false;
    if (_profile = nil) then
        raise Exception.Create('Invalid profile')
    else if (_stream <> nil) then
        raise Exception.Create('Session is already connected');

    checkAuthAgent(); //see if we have an auth agent already, or create one from profile info
            
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

    _ssl_on := (_profile.ssl = ssl_port);
end;

{---------------------------------------}
procedure TJabberSession.Disconnect;
begin
    // Save the server side prefs and kill our connection.
    if (_stream = nil) then exit;


    if (Self.Stream.Active) then begin
        if (_authd) then begin
            Prefs.SaveServerPrefs();
            _stream.Send('<presence type="unavailable"/>');
        end;

        // disconnect the stream
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
        if (_lang <> '') then
            tag.setAttribute('xml:lang', _lang);

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
    if (send) then
        // we are sending data
        _dataSignal.Invoke('/data/send', nil, data)
    else begin
        // getting data from the socket
        if (Pos('<stream:error>', data) > 0) then
            _dispatcher.DispatchSignal('/session/error/stream', nil);
        _dataSignal.Invoke('/data/recv', nil, data);
    end;
end;

{---------------------------------------}
procedure TJabberSession.handleDisconnect();
begin
    if ((not _authd) and (_register)) then
        _auth_agent.CancelRegistration()
    else if (not _authd) then 
        _auth_agent.CancelAuthentication();

    // Do this before we invalidate our state
    _dispatcher.DispatchSignal('/session/disconnected', nil);

    // Clear the roster, ppdb and fire the callbacks
    _first_pres := false;
    _authd := false;
    _cur_server := '';
    _ssl_on := false;
    _compression_on := false;

    if (_paused) then
        Self.Play();

    FreeAndNil(_features);

    ppdb.Clear;
    Roster.Clear;
    ppdb.Clear;

    _stream.Free();
    _stream := nil;

    // clear the entity cache
    jEntityCache.Clear();
    jCapsCache.Clear();

end;

{---------------------------------------}
procedure TJabberSession.StreamCallback(msg: string; tag: TXMLTag);
var
    biq: TJabberIQ;
    l, lang, tmps: WideString;
    methods: TXMLTagList;
    i: integer;
begin
    // Something is happening... our stream says so.
    if ((msg = 'connected') and (_sent_stream = false)) then begin
        // we are connected... send auth stuff.
        lang := Prefs.getString('locale');
        if (lang <> '') then l := ' xml:lang="' + lang + '" ' else l := '';
        tmps := '<stream:stream to="' + Trim(Server) +
            '" xmlns="jabber:client" ' +
            'xmlns:stream="http://etherx.jabber.org/streams" ' + l +
            'version="1.0" ' +
            '>';
        _stream.Send(tmps);
        _sent_stream := true;
    end

    else if msg = 'ssl-error' then
        // Throw a dialog box up..
        _dispatcher.DispatchSignal('/session/error/ssl', tag)

    else if msg = 'disconnected' then
        // We're not connected anymore
        Self.handleDisconnect()

    else if msg = 'commtimeout' then
        // Communications timed out (woops).
        _dispatcher.DispatchSignal('/session/commtimeout', nil)

    else if msg = 'commerror' then
        // Some kind of socket error
        _dispatcher.DispatchSignal('/session/commerror', nil)

    else if msg = 'xml' then begin
        // We got a stanza. Whoop.
        // Let's always fire debug events
        if (tag.GetAttribute('type') = 'error') then begin
           tag := tag.GetFirstTag('error');
           if (tag <> nil) then
             if (tag.GetAttribute('code') = '405') then
               MessageDlgW(_(sErrorRevoke), mtError, [mbOK], 0);
        end
        else if (tag.Name = 'stream:stream') then begin

            // we got connected
            _stream_id := tag.getAttribute('id');
            _xmpp := (tag.GetAttribute('version') = '1.0');

            // Stash away our current server.
            _cur_server := tag.getAttribute('from');
            _dispatcher.DispatchSignal('/session/connected', nil);

            if (_no_auth) then
                // do nothing
            else if (((_register) or (_profile.NewAccount)) and (_xmpp = false)) then begin
                _xmpp := false;
                CreateAccount()
            end
            else if (not _xmpp) then
                _auth_agent.StartAuthentication();
        end
        else if (tag.Name = 'stream:error') then begin
            // we got a stream error
            FireEvent('/session/error/stream', tag);
        end

        else if ((_xmpp) and (tag.Name = 'stream:features')) then begin
            // cache stream features..
            FreeAndNil(_features);
            _features := TXMLTag.Create(tag);

            if (_authd) and (not _no_auth) then begin
                // We are already auth'd, lets bind to our resource
                biq := TJabberIQ.Create(Self, generateID(), BindCallback, AUTH_TIMEOUT);
                biq.Namespace := 'urn:ietf:params:xml:ns:xmpp-bind';
                biq.qTag.Name := 'bind';
                biq.qTag.AddBasicTag('resource', Self.Resource);
                biq.iqType := 'set';
                biq.Send();
            end
            else begin
                // We aren't authd yet, check for StartTLS
                if (not _ssl_on) then begin
                    if (_features.GetFirstTag('starttls') <> nil) then begin
                        if (_stream.isSSLCapable()) then begin
                            StartTLS();
                            exit;
                        end;
                    end;
                    if (_profile.ssl = ssl_only_tls) then begin
                        Self.FireEvent('/session/error/tls', nil);
                        exit;
                    end;
                end;
                
                // now see if we can do compression
                {$ifdef INDY9}
                if (not _compression_on)  then begin
                    methods := _features.QueryXPTags('/stream:features/compression[@xmlns="http://jabber.org/features/compress"]/method');
                    for i := 0 to methods.Count - 1 do begin
                        if methods.Tags[i].Data = 'zlib' then begin
                            StartCompression('zlib');
                            exit;
                        end
                    end;
                    // doesn't support zlib
                    Self.FireEvent('/session/error/compression', nil);
                end;
                {$endif}

                // Otherwise, either try to register, or auth
                if (_no_auth) then
                    // do nothing
                else if ((_register) or (_profile.NewAccount)) then begin

                    if (_features.QueryXPTag('/stream:features/register[@xmlns="http://jabber.org/features/iq-register"]') = nil) then begin
                        // this server doesn't support inband reg.
                        FireEvent('/session/gui/no-inband-reg', nil);
                        exit;
                    end;

                    CreateAccount();
                end
                else if (not _no_auth) then
                    _auth_agent.StartAuthentication();
            end;
        end

        else begin
            _dispatcher.DispatchSignal('/filter', tag);
        end;
    end;

end;

{---------------------------------------}
procedure TJabberSession.BindCallback(event: string; tag: TXMLTag);
var
    iq: TJabberIQ;
    j: WideString;
    jid: TJabberID;
begin
    // Callback for our xmpp-bind request
    if ((event <> 'xml') or (tag.getAttribute('type') <> 'result')) then begin
        _dispatcher.DispatchSignal('/session/error/auth', tag);
        exit;
    end
    else begin
        j := tag.QueryXPData('/iq/bind[@xmlns="urn:ietf:params:xml:ns:xmpp-bind"]/jid');
        if (j <> '') then begin
            jid := TJabberID.Create(j);
            Profile.Username := jid.user;
            Profile.Host := jid.domain;
            Profile.Resource := jid.resource;
            jid.Free();
        end;

        iq := TJabberIQ.Create(Self, generateID(), SessionCallback, AUTH_TIMEOUT);
        iq.Namespace := 'urn:ietf:params:xml:ns:xmpp-session';
        iq.qTag.Name := 'session';
        iq.iqType := 'set';
        iq.Send();
    end;
end;

{---------------------------------------}
procedure TJabberSession.SessionCallback(event: string; tag: TXMLTag);
begin
    Prefs.setString('temp-pw', ''); //clear temp password
    // callback for our xmpp-session-start
    if ((event <> 'xml') or (tag.getAttribute('type') <> 'result')) then begin
        _dispatcher.DispatchSignal('/session/error/auth', tag);
        exit;
    end
    else
        StartSession(tag);
end;

{---------------------------------------}
procedure TJabberSession.StartSession(tag: TXMLTag);
begin
    // We have an active session
    _first_pres := true;
    _dispatcher.DispatchSignal('/session/authenticated', tag);
    Prefs.FetchServerPrefs();
    // Added by SIG - set Default Nickname
//    SetDefaultNickname();
end;

{---------------------------------------}
procedure TJabberSession.Pause();
begin
    // pause the session
    _paused := true;
end;

{---------------------------------------}
procedure TJabberSession.Play();
var
    q: TQueuedEvent;
    sig: TSignalEvent;
begin
    // playback the stuff in the queue
    _resuming := true;
    _paused := false;

    // WOAH! Make sure things are played back or cleared when we get disconnected.
    while (_pauseQueue.Count > 0) do begin
        q := TQueuedEvent(_pauseQueue.pop);
        sig := TSignalEvent(q.callback);
        sig(q.event, q.tag);
        q.Free;
    end;
    _resuming := false;
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
function TJabberSession.RegisterCallback(callback: TPacketEvent; xplite: Widestring; pausable: boolean = false): integer;
var
    p, i: integer;
    l: TSignalListener;
    pk: TPacketListener;
    sig: TBasicSignal;
    tok1: Widestring;
begin
    // add this callback to the packet signal
    Result := -1;
    p := Pos('/', Copy(xplite, 2, length(xplite) - 1));
    if p > 0 then
        tok1 := Copy(xplite, 1, p)
    else
        tok1 := xplite;

    // Find the correct signal to register with
    i := _dispatcher.IndexOf(tok1);
    if (tok1 = '/filter') then begin
        pk := _filterSignal.addListener(xplite, callback);
        result := pk.cb_id;
    end
    else if (tok1 = '/pre') then begin
        pk := _preSignal.addListener(xplite, callback);
        result := pk.cb_id;
    end
    else if tok1 = '/packet' then begin
        pk := _packetSignal.addListener(xplite, callback);
        result := pk.cb_id;
    end
    else if (tok1 = '/post') then begin
        pk := _postSignal.addListener(xplite, callback);
        result := pk.cb_id;
    end
    else if i >= 0 then begin
        sig := TBasicSignal(_dispatcher.Objects[i]);
        l := sig.addListener(xplite, callback);
        result := l.cb_id;
    end;
end;

{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TRosterEvent; xplite: Widestring): integer;
var
    l: TRosterListener;
begin
    // add a callback to the roster signal
    l := _rosterSignal.addListener(callback, xplite);
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
function TJabberSession.RegisterCallback(callback: TChatEvent): integer;
var
    sl: TChatListener;
begin
    // add a callback to the data signal
    sl := _chatSignal.addListener(callback);
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
procedure TJabberSession.FireEvent(event: string; tag: TXMLTag; const controller: TChatController);
begin
    // dispatch a data event directly
    _chatSignal.Invoke(event, tag, controller);
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
    x: TXMLTag;
begin
    _show := show;
    _status := status;
    _priority := priority;

    if (Self.Active) then begin
        p := TCapPresence.Create();
        p.Show := show;
        p.Status := status;
        if (priority = -1) then priority := 0;
        p.Priority := priority;

        if (Self.Profile.AvatarHash <> '') then begin
            x := p.AddTag('x');
            x.setAttribute('xmlns', 'vcard-temp:x:update');
            x.AddBasicTag('photo', Self.Profile.AvatarHash);
            x := p.AddTag('x');
            x.setAttribute('xmlns', 'jabber:x:avatar');
            x.AddBasicTag('hash', Self.Profile.AvatarHash);
        end;


        // allow plugins to add stuff, by trapping this event
        MainSession.FireEvent('/session/before_presence', p);

        for i := 0 to Presence_XML.Count - 1 do
            p.addInsertedXML(Presence_XML[i]);

        // for invisible, only send to those people we've
        // directed presence to.
        if ((self.Invisible) and (Self.Active) and (not _first_pres)) then begin
            manualBlastPresence(p);
        end
        else begin
            if (_invisible) then
                p.setAttribute('type', 'invisible');
            SendTag(p);
            if (_first_pres) then _first_pres := false;
        end;

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
function TJabberSession.GetExtList(): TWideStringList;
begin
    Result := _extensions;
end;

{---------------------------------------}
function TJabberSession.GetExtStr(): WideString;
var
    i : integer;
begin
    Result := '';
    for i := 0 to _extensions.Count - 1 do begin
        if (i <> 0) then
            Result := Result + ' ';
        Result := Result + _extensions[i];
    end;
end;
{---------------------------------------}

procedure TJabberSession.AddExtension(ext: WideString; feature: WideString);
var
    i : integer;
    features : TWideStringList;
begin
    i := _extensions.IndexOf(ext);
    if (i < 0) then begin
        features := TWideStringList.Create();
        _extensions.AddObject(ext, features);
    end
    else begin
        features := TWideStringList(_extensions.Objects[i]);
    end;

    features.Add(feature);
end;

{---------------------------------------}
procedure TJabberSession.RemoveExtension(ext: WideString);
var
    i : integer;
    features : TWideStringList;
begin
    i := _extensions.IndexOf(ext);
    if (i < 0) then exit;

    features := TWideStringList(_extensions.Objects[i]);

    _extensions.Delete(i);
    features.Free();
end;

{---------------------------------------}
procedure TJabberSession.manualBlastPresence(p: TXMLTag);
var
    i: integer;
    xml: Widestring;
begin
    for i := 0 to _avails.Count - 1 do begin
        p.setAttribute('to', _avails[i]);
        xml := p.xml();
        _stream.Send(xml);
    end;
    p.Free();
end;

{---------------------------------------}
procedure TJabberSession.addAvailJid(jid: Widestring);
begin
    if (_avails.IndexOf(jid) < 0) then
        _avails.Add(jid);
end;

{---------------------------------------}
procedure TJabberSession.removeAvailJid(jid: Widestring);
var
    idx: integer;
begin
    idx := _avails.IndexOf(jid);
    if (idx >= 0) then
        _avails.Delete(idx);
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
    r1, r2: TJabberRosterItem;
    blockers: TWideStringList;
begin
    blockers := TWideStringList.Create();
    Prefs.fillStringlist('blockers', blockers);
    if (blockers.IndexOf(jid.jid) < 0) then
        result := false
    else
        result := true;
    blockers.Free();

    if ((not result) and (Prefs.getBool('block_nonroster'))) then begin
        // block this jid if they are not in my roster
        r1 := Roster.Find(jid.jid);
        r2 := nil;
        if (r1 = nil) then
            r2 := Roster.Find(jid.full);
        Result := ((r1 = nil) and (r2 = nil));
    end;
end;

{---------------------------------------}
procedure TJabberSession.UnBlock(jid : TJabberID);
var
    i,j: integer;
    blockers: TWideStringList;
    block : TXMLTag;
    c: TChatController;
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
    //Disable all open chat windows
    with MainSession.ChatList do begin
       for j := Count - 1 downto 0 do begin
           c := TChatController(Objects[j]);
           if (c <> nil) then
             if (c.jid = jid.jid) then
                c.EnableChat();
       end;
    end;
    block.Free();
end;

{---------------------------------------}
procedure TJabberSession.Block(jid : TJabberID);
var
    blockers: TWideStringList;
    block: TXMLTag;
    j: Integer;
    c: TChatController;
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
    //Disable all open chat windows
    with MainSession.ChatList do begin
       for j := Count - 1 downto 0 do begin
           c := TChatController(Objects[j]);
           if (c <> nil) then
             if (c.jid = jid.jid) then
                c.DisableChat();
       end;
    end;
    block.Free();
end;

{---------------------------------------}
function TJabberSession.GetActive(): boolean;
begin
    Result := (_stream <> nil);
end;

{---------------------------------------}
procedure TJabberSession.setAuthAgent(new_auth: TJabberAuth);
begin
    if (assigned(_auth_agent)) then
        FreeAndNil(_auth_agent);
    _auth_agent := new_auth;
end;

{*
    Create an auth agaent from current profile information UNLESS
    already assigned. nop if already assigned.
*}
procedure TJabberSession.checkAuthAgent();
var
    auth: TJabberAuth;
begin
    assert(_profile <> nil); //should not try to set authagent until profile is set
    assert(_stream = nil); //should not try to change authagent once connected
    //if the current auth agent has a plugin associated, use it regardless of
    //what the profile specifies...
    
    if (_auth_agent = nil) or (not _auth_agent.InheritsFrom(TExPluginAuth)) then begin
        // Create the AuthAgent
        if (profile.SSL_Cert <> '')  then
            auth := CreateJabberAuth('EXTERNAL', Self)
        else if (_profile.KerbAuth) then
            auth := CreateJabberAuth('GSSAPI', Self)
        else
            auth := CreateJabberAuth('XMPP', Self);

        if (auth = nil) then
            raise Exception.Create('No appropriate Auth Agent found.');

        // set this auth agent as our current one
        setAuthAgent(auth);
    end;
end;

{---------------------------------------}
function TJabberSession.getAuthAgent: TJabberAuth;
begin
    Result := _auth_agent;
end;

{---------------------------------------}
procedure TJabberSession.setAuthdJID(user, host, res: Widestring);
begin
    _profile.Username := user;
    _profile.Server := host;
    _profile.Resource := res;
end;

{---------------------------------------}
procedure TJabberSession.setAuthenticated(ok: boolean; tag: TXMLTag; reset_stream: boolean);
begin
    // our auth-agent is all set\
    //remove temp password from prefs
    Prefs.setString('temp-pw', '');
    if (ok) then begin
        _authd := true;
        _profile.NewAccount := false;
        _register := false;

        if (reset_stream) then
            ResetStream()
        else
            StartSession(tag);
    end
    else begin
        _dispatcher.DispatchSignal('/session/error/auth', tag);
    end;
end;

{---------------------------------------}
procedure TJabberSession.ResetStream();
var
    tmps: Widestring;
begin
    // send a new stream:stream...
    _stream.ResetParser();
    tmps := '<stream:stream to="' + Trim(Server) +
        '" xmlns="jabber:client" ' +
        'xmlns:stream="http://etherx.jabber.org/streams" ' +
        'version="1.0" ' +
        '>';
    _stream.Send(tmps);
end;

{---------------------------------------}
procedure TJabberSession.StartTLS();
var
    s: TXMLTag;
begin
    _tls_cb := Self.RegisterCallback(TLSCallback,
        '/packet/proceed[@xmlns="urn:ietf:params:xml:ns:xmpp-tls"]');

    s := TXMLTag.Create('starttls');
    s.setAttribute('xmlns', 'urn:ietf:params:xml:ns:xmpp-tls');
    Self.SendTag(s);
end;


{---------------------------------------}
procedure TJabberSession.TLSCallback(event: string; tag: TXMLTag);
begin
    Self.UnRegisterCallback(_tls_cb);
    _tls_cb := -1;

    if (event <> 'xml') then begin
        Self.FireEvent('/session/error/tls', nil);
        exit;
    end;

    try
        _stream.EnableSSL();
        ResetStream();
        _ssl_on := true;
    except
        Self.FireEvent('/session/error/tls', nil);
        _ssl_on := false;
    end;

end;

{---------------------------------------}
procedure TJabberSession.StartCompression(method: WideString);
var
    s: TXMLTag;
begin
    _compression_cb := Self.RegisterCallback(CompressionCallback,
        '/packet/compressed[@xmlns="http://jabber.org/protocol/compress"]');
    _compression_err_cb := Self.RegisterCallback(CompressionErrorCallback,
        '/packet/failure[@xmlns="http://jabber.org/protocol/compress"]');
    s := TXMLTag.Create('compress');
    s.setAttribute('xmlns', 'http://jabber.org/protocol/compress');
    s.AddBasicTag('method', method);
    Self.SendTag(s);
end;

{---------------------------------------}
procedure TJabberSession.CompressionCallback(event: string; tag: TXMLTag);
begin
    Self.UnRegisterCallback(_compression_cb);
    _compression_cb := -1;

    if (event <> 'xml') then begin
        Self.FireEvent('/session/error/compression', nil);
        exit;
    end;

    try
        _stream.EnableCompression();
        ResetStream();
        _compression_on := true;
    except
        Self.FireEvent('/session/error/compression', nil);
        _ssl_on := false;
    end;

end;

{---------------------------------------}
procedure TJabberSession.CompressionErrorCallback(event: string; tag: TXMLTag);
begin
    Self.UnRegisterCallback(_compression_err_cb);
    _compression_err_cb := -1;

    Self.FireEvent('/session/error/compression', tag);
end;

function TJabberSession.getDisplayUsername(): widestring;
begin
    Result := DisplayName.getDisplayNameCache().getDisplayName(Profile.getJabberID);
end;


{------------- Added by SIG to support setting default nick name---}
{---------- JJF now handled by DisplayName --------}
{------------------------------------
procedure TJabberSession.SetDefaultNickname();
var
  vciq: TJabberIQ;
  default_nick: WideString;
begin
   default_nick := Prefs.getString('default_nick');
    if ( default_nick = '' ) then
    begin
      vciq := TJabberIQ.Create(Self,generateID(),vcardCallback);
      vciq.qTag.Name := 'VCARD';
      vciq.Namespace := 'vcard-temp';
      vciq.iqType := 'get';
      vciq.toJid := Username + '@' + Server;
      vciq.Send();
    end;
end;
{------------------------------------
procedure TJabberSession.vcardCallback(event: string; tag: TXMLTag);
var
  vcard: TXMLVCard;
  default_nick: WideString;
begin

   if (event <> 'xml') then exit;
   vcard := TXMLVCard.Create;
   vcard.parse(tag);
   default_nick := vcard.FamilyName + ', ' + vcard.GivenName;
   Prefs.setString('default_nick',default_nick);
   vcard.Free();
end;
}
end.




