unit XMLHttpStream;

interface

uses
    XMLTag,
    XMLStream,
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

        procedure Connect(server: string; port: integer; use_ssl: boolean = false); override;
        procedure Send(xml: string); override;
        procedure Disconnect; override;
    end;

    THttpThread = class(TParseThread)
    private
        _Http:      TidHTTP;
        _url:       string;
        _interval:  cardinal;
        
    protected
        procedure Run; override;

    public
        constructor Create(strm: TXMLHttpStream; url: string; root: string);
        property Interval : cardinal read _interval write _interval;
        property URL : string read _url;
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

procedure TXMLHttpStream.Connect(server: string; port: integer; use_ssl: boolean = false);
var
    url : string;
begin
    if (use_ssl) then
        url := 'https://www.' + server + '/wc12/webclient'
    else
        url := 'http://www.' + server + '/wc12/webclient';
    _thread := THttpThread.Create(Self, url, _root_tag);
end;

procedure TXMLHttpStream.Send(xml: string);
begin
//
end;

procedure TXMLHttpStream.Disconnect;
begin
    //
end;

constructor THttpThread.Create(strm: TXMLHttpStream; url: string; root: string);
begin
    _url := url;
    _http := TIdHTTP.Create(nil);
    inherited Create(strm, root);
end;

procedure THttpThread.Run();
var
    response : TStringStream;
begin
    response := TStringStream.Create('');
    repeat
//        _http.Post();
    until true;
end;

end.
