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
    SysUtils, IdException,
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

    protected
        procedure Run; override;

    public
        constructor Create(strm: TXMLHttpStream; profile: TJabberProfile; root: string);
    end;
implementation

uses
    Classes;
    
constructor TXMLHttpStream.Create(root: string);
begin
    //
end;

destructor TXMLHttpStream.Destroy;
begin
    //
end;

procedure TXMLHttpStream.Connect(profile: TJabberProfile);
begin
    _thread := THttpThread.Create(Self, profile, _root_tag);
end;

procedure TXMLHttpStream.Send(xml: string);
begin
//
end;

procedure TXMLHttpStream.Disconnect;
begin
    //
end;

constructor THttpThread.Create(strm: TXMLHttpStream; profile: TJabberProfile; root: string);
begin
    _profile := profile;
    inherited Create(strm, root);
end;

procedure THttpThread.Run();
var
    request : TStringStream;
    response : TStringStream;
    http: TIdHTTP;
begin
    http := TIdHTTP.Create(nil);
    if (_profile.ProxyApproach = 0) then begin
        //TODO: get IE settings from registry
        end;
    if (_profile.ProxyApproach = 2) then begin
        with http.Request do begin
            ProxyServer := _profile.ProxyHost;
            ProxyPort := _profile.ProxyPort;
            if (_profile.ProxyAuth) then begin
                ProxyUsername := _profile.ProxyUsername;
                ProxyPassword := _profile.ProxyPassword;
                end;
            end;
        end;

    request := TStringStream.Create('');
    response := TStringStream.Create('');
    repeat
        http.Post(_profile.URL, request, response);
        Sleep(_profile.Poll * 1000);
    until true;
end;

end.
