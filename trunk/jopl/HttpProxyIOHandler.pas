unit HttpProxyIOHandler;
{$ifdef VER150}
    {$define INDY9}
{$endif}

{$ifdef INDY9}

interface

uses
  Classes, IdIOHandlerSocket, IdComponent, IdGlobal, IdSocks, IdIOHandler;

type

  THttpProxyIOHandler = class(TIdIOHandlerSocket)
  public
    procedure ConnectClient(const AHost: string; const APort: Integer; const ABoundIP: string;
     const ABoundPort: Integer; const ABoundPortMin: Integer; const ABoundPortMax: Integer;
     const ATimeout: Integer = IdTimeoutDefault); override;
    procedure HttpProxyConnect(const AHost: string; const APort: Integer);
  end;


implementation

uses
  IdException, IdResourceStrings, SysUtils, IdCoderMime;

procedure THttpProxyIOHandler.HttpProxyConnect(const AHost: string; const APort: Integer);
var
    hostport: string;
    connect: string;
    state: integer;
    c: char;
    len: integer;
    encoder: TIdEncoderMIME;
begin

    hostport := AHost + ':' + IntToStr(APort);
    connect := 'CONNECT ' + hostport + ' HTTP/1.1'#13#10'Host: ' + hostport + ''#13#10;

    if (FSocksInfo.Authentication = saUsernamePassword) then begin
        encoder := TIdEncoderMIME.Create(nil);
        connect := connect + 'Proxy-Authorization: Basic ' + encoder.Encode(FSocksInfo.Username + ':' + FSocksInfo.Password);
        encoder.Free();
    end;
    connect := connect + #13#10;

    len := length(connect);

    if (Send(Pointer(connect)^, len) <> len) then
        raise Exception.Create('HTTP proxy send error');

    state := 0;

    // search forward for eand of response header
    while (state < 4) do begin
        len := Recv(c, 1);
        if (len <> 1) then
            raise Exception.Create('HTTP proxy recv error');

        // these should all work:
        // \r\n\r\n
        // \n\n
        // \r\n\n
        // \n\r\n
        case state of
        0:
            if (c = #13) then
                state := 1
            else if (c = #10) then
                state := 2;
        1:
            if (c = #10) then
                state := 2
            else
                state := 0;
        2:
            if (c = #13) then
                state := 3
            else if (c = #10) then
                state := 4
            else
                state := 0;
        3:
            if (c = #10) then
                state := 4
            else
                state := 0;
        end;
    end;
end;

procedure THttpProxyIOHandler.ConnectClient(const AHost: string; const APort: Integer; const ABoundIP: string;
     const ABoundPort: Integer; const ABoundPortMin: Integer; const ABoundPortMax: Integer;
     const ATimeout: Integer = IdTimeoutDefault);
begin

    inherited ConnectClient(FSocksInfo.Host, FSocksInfo.Port,
                            ABoundIP, ABoundPort, ABoundPortMin,
                            ABoundPortMax, ATimeout);
    HttpProxyConnect(AHost, APort);
end;
{$endif}

end.

