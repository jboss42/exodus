{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W+,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
unit XMLHttpStream;

interface

uses
    XMLTag,
    XMLStream,
    PrefController,
    {$ifdef linux}
    QExtCtrls,
    {$else}
    ExtCtrls,
    {$endif}
    Classes, SysUtils, IdException,
    IdHTTP, SyncObjs;

type
    THttpThread = class;

    TXMLHttpStream = class(TXMLStream)
    private
        _thread:    THttpThread;
    protected
        procedure MsgHandler(var msg: TJabberMsg); message WM_JABBER;
    public
        constructor Create(root: string); override;
        destructor Destroy; override;

        procedure Connect(profile: TJabberProfile); override;
        procedure Send(xml: string); override;
        procedure Disconnect; override;
    end;

    THttpThread = class(TParseThread)
    private
        _profile : TJabberProfile;
        _poll_id: string;
        _poll_time: integer;
        _http: TIdHttp;
        _request: TStringlist;
        _response: TStringStream;
        _cookie_list : TStringList;
        _lock: TCriticalSection;
        _event: TEvent;

        procedure DoPost();
    protected
        procedure Run; override;
    public
        constructor Create(strm: TXMLHttpStream; profile: TJabberProfile; root: string);
        destructor Destroy(); override;

        procedure Send(xml: String);
        procedure Disconnect(end_tag: string);
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef Windows}
    Registry, StrUtils, ExUtils, 
    {$endif}
    IdGlobal;

const
    MIN_TIME : integer = 250;
    INCREASE_FACTOR : single = 1.5;

{---------------------------------------}
constructor TXMLHttpStream.Create(root: string);
begin
    //
    inherited;
    _thread := nil;
end;

{---------------------------------------}
destructor TXMLHttpStream.Destroy;
begin
    //
    inherited;
end;

{---------------------------------------}
procedure TXMLHttpStream.Connect(profile: TJabberProfile);
begin
    // kick off the thread.

    // TODO: check to see if the thread will get freed when it stops
    _thread := THttpThread.Create(Self, profile, _root_tag);
    _thread.doMessageSync(WM_CONNECTED);
    _thread.Start();
end;

{---------------------------------------}
procedure TXMLHttpStream.Send(xml: string);
begin
    if (_thread <> nil) then begin
        DoDataCallbacks(true, xml);
        _thread.Send(xml);
        end;
end;

{---------------------------------------}
procedure TXMLHttpStream.Disconnect;
var
    end_tag: string;
begin
    end_tag := '</' + Self._root_tag + '>';
    DoDataCallbacks(true, end_tag);
    _thread.Disconnect(end_tag);
    _thread.doMessageSync(WM_DISCONNECTED);

    // Note that the free will free itself.
end;

{---------------------------------------}
procedure TXMLHttpStream.MsgHandler(var msg: TJabberMsg);
var
    tmps: string;
    tag: TXMLTag;
begin
    //
    case msg.lparam of

        WM_XML: begin
            // We are getting XML data from the thread
            if _thread = nil then exit;

            tag := _thread.GetTag;
            if tag <> nil then begin
                DoCallbacks('xml', tag);
                end;
            end;

        WM_SOCKET: begin
            // We are getting something on the socket
            tmps := _thread.Data;
            if tmps <> '' then
                DoDataCallbacks(false, tmps);
            end;
        WM_CONNECTED: begin
            // Socket is connected
            DoCallbacks('connected', nil);
            end;

        WM_DISCONNECTED: begin
            // Socket is disconnected
            DoCallbacks('disconnected', nil);
            end;
        WM_COMMERROR: begin
            // There was a COMM ERROR
            DoCallbacks('disconnected', nil);
            DoCallbacks('commerror', nil);
            end;
        end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor THttpThread.Create(strm: TXMLHttpStream; profile: TJabberProfile; root: string);
var
    {$ifdef Windows}
    reg: TRegistry;
    {$endif}
    srv: string;
    colon: integer;
begin
    inherited Create(strm, root);

    _profile := profile;
    _poll_id := '0';
    _poll_time := MIN_TIME;
    _http := TIdHTTP.Create(nil);
    _cookie_list := TStringList.Create();
    _cookie_list.Delimiter := ';';
    _cookie_list.QuoteChar := #0;
    _lock := TCriticalSection.Create();
    _event := TEvent.Create(nil, false, false, 'exodus_http_poll');

    _request := TStringlist.Create();
    _response := TStringstream.Create('');

    if (_profile.ProxyApproach = http_proxy_ie) then begin
        // get IE settings from registry

        // todo: figure out some way of doing this XP??
        {$ifdef Windows}
        reg := TRegistry.Create();
        try
            reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings', false);
            if (reg.ValueExists('ProxyEnable') and
                (reg.ReadInteger('ProxyEnable') <> 0)) then with _http.Request do begin
                srv := reg.ReadString('ProxyServer');
                colon := pos(':', srv);
                ProxyServer := Copy(srv, 1, colon-1);
                ProxyPort := StrToInt(Copy(srv, colon+1, length(srv)));
                end;
        finally
            reg.Free();
            end;
        {$endif}
        
        end
    else if (_profile.ProxyApproach = http_proxy_custom) then begin
        with _http.Request do begin
            ProxyServer := _profile.ProxyHost;
            ProxyPort := _profile.ProxyPort;
            if (_profile.ProxyAuth) then begin
                ProxyUsername := _profile.ProxyUsername;
                ProxyPassword := _profile.ProxyPassword;
                end;
            end;
        end;
end;

{---------------------------------------}
destructor THttpThread.Destroy();
begin
   _lock.Free();
   _event.Free();
   _cookie_list.Free();
   _http.Free();
   _request.Free();
   _response.Free();
end;

{---------------------------------------}
procedure THttpThread.Send(xml: string);
begin
    _lock.Acquire();
    _request.Add(AnsiToUTF8(xml));
    _lock.Release();
    _event.SetEvent();
end;

{---------------------------------------}
procedure THttpThread.DoPost();
begin
    // nuke whatever is currently in the stream
    _response.Size := 0;
    _request.Insert(0, _poll_id + ',');
    try
        _lock.Acquire();
        _http.Post(_profile.URL, _request, _response);
        _request.Clear();
        _lock.Release();
    except
        on E: Exception do begin
            if (not Self.Stopped) then begin
                doMessage(WM_COMMERROR);
                Self.Terminate();
                end;
            exit;
        end;
    end;
end;

{---------------------------------------}
procedure THttpThread.Run();
var
    r, pid, new_cookie: string;
    i: integer;
begin
    // Bail if we're stopped.
    if ((Self.Stopped) or (Self.Suspended) or (Self.Terminated)) then
        exit;

    Self.DoPost();

    // parse the response stream
    if (_http.ResponseCode <> 200) then begin
        // HTTP error!
        doMessage(WM_COMMERROR);
        Self.Terminate();
        exit;
        end;

    pid := '';

    // Get the cookie values + parse them, looking for the ID
    new_cookie := _http.Response.ExtraHeaders.Values['Set-Cookie'];
    _cookie_list.DelimitedText := new_cookie;
    for i := 0 to _cookie_list.Count - 1 do begin
        if (Pos('ID=', _cookie_list[i]) = 1) then begin
            pid := Copy(_cookie_list[i], 4, length(_cookie_list[i]));
            break;
            end;
        end;

    if (_poll_id = '0') then begin
        _poll_id := pid;
        end;

    // compare the most recent pid with our stored poll_id
    // if ((pid = '') or AnsiEndsStr(':0', pid) or (pid <> _poll_id)) then begin
    if ((pid = '') or (Pos(':0', pid) = length(pid) - 1) or (pid <> _poll_id)) then begin
        // something really bad has happened!
        doMessage(WM_COMMERROR);
        Self.Terminate();
        exit;
        end;

    r := _response.DataString;
    if (r <> '') then begin
        Push(r);
        _poll_time := MIN_TIME;
        end
    else if (_poll_time <> _profile.Poll) then begin
        _poll_time := Trunc(_poll_time * INCREASE_FACTOR);
        if (_poll_time >= _profile.Poll) then
            _poll_time := _profile.Poll;
        end;

    _event.WaitFor(_poll_time);
end;

{---------------------------------------}
procedure THttpThread.Disconnect(end_tag: string);
begin
    // Yes, we analyzed to see if there is a race condition.
    // There's not.
    Stop();
    _event.SetEvent();
    if (end_tag <> '') then begin
        Send(end_tag);
        DoPost();
        end;

    // Free me.  Touch me.  Feel me.
    Terminate();
end;

end.
