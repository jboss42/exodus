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
        _http: TIdHttp;
        _request: TStringlist;
        _response: TStringStream;
    protected
        procedure Run; override;
    public
        constructor Create(strm: TXMLHttpStream; profile: TJabberProfile; root: string);
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    IdGlobal;

{---------------------------------------}
constructor TXMLHttpStream.Create(root: string);
begin
    //
    inherited;

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
    _thread := THttpThread.Create(Self, profile, _root_tag);
    _thread.Start();
end;

{---------------------------------------}
procedure TXMLHttpStream.Send(xml: string);
begin
    //
end;

{---------------------------------------}
procedure TXMLHttpStream.Disconnect;
begin
    //
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor THttpThread.Create(strm: TXMLHttpStream; profile: TJabberProfile; root: string);
begin
    inherited Create(strm, root);

    _profile := profile;
    _poll_id := '0';
    _http := TIdHTTP.Create(nil);

    _request := TStringlist.Create();
    _response := TStringstream.Create('');

    if (_profile.ProxyApproach = http_proxy_ie) then begin
        //TODO: get IE settings from registry
        end;
    if (_profile.ProxyApproach = http_proxy_custom) then begin
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
procedure THttpThread.Run();
var
    new_cookie, r: string;
begin
    if ((Self.Stopped) or (Self.Suspended) or (Self.Terminated)) then
        exit;

    // nuke whatever is currently in the stream
    _response.Size := 0;

    _request.Insert(0, _poll_id + ',');

    _http.Post(_profile.URL, _request, _response);

    // parse the response stream
    new_cookie := _http.Response.ExtraHeaders.Values['Set-Cookie'];

    Sleep(_profile.Poll * 1000);
end;

end.
