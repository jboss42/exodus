unit AutoUpdate;

interface

uses
  Classes,
  XMLTag;

type
  TAutoUpdateThread = class(TThread)
  private
    { Private declarations }
    _url : string;
    procedure checkDoUpdate();
  protected
    procedure Execute; override;
  public
    property URL : string read _url write _url;
  end;

  TAutoUpdate = class
  public
    procedure GetNewVersion(event: string; tag: TXMLTag);
  end;

procedure InitAutoUpdate();

resourcestring
    sUpdateConfirm = 'A new version of Exodus is available.  Would you like to install it?';

implementation

uses
    Controls,
    ExUtils,
    IdHttp,
    Dialogs,
    Forms,
    Registry,
    Session,
    ShellAPI,
    SysUtils,
    Windows;

var
    au: TAutoUpdate;

procedure InitAutoUpdate();
var
    reg : TRegistry;
    url : string;
    t : TAutoUpdateThread;
begin
    if (not MainSession.Prefs.getBool('auto_updates')) then exit;

    MainSession.RegisterCallback(au.GetNewVersion, '/session/getnewversion');
    
    reg := TRegistry.Create();
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('\Software\Jabber\Exodus', true);
    url := reg.ReadString('Update_URL');
    reg.CloseKey();
    reg.Free();

    if (url <> '') then begin
        t := TAutoUpdateThread.Create(true);
        t.URL := url;
        t.FreeOnTerminate := true;
        t.Resume();
        end;
end;

{ TAutoUpdateThread }
procedure TAutoUpdateThread.Execute;
var
    http : TIdHTTP;
    last: TDateTime;
begin
    http := nil;
    try

        http := TIdHTTP.Create(nil);
        http.Head(_url);
        if (http.ResponseCode <> 200) then begin
            //if (Sender <> nil) then ShowMessage(Format(sUpdateHTTPError, [http.ResponseText]));
            exit;
            end;

        last := FileDateToDateTime(FileAge(Application.EXEName));

        if (http.Response.LastModified <= last) then
            exit;

        synchronize(checkDoUpdate);
    finally
        if (http <> nil) then http.Free();
        end;
end;

procedure TAutoUpdateThread.checkDoUpdate();
begin
    if (MessageDlg(sUpdateConfirm,
                   mtConfirmation, [mbOK,mbCancel], 0) = mrOK) then begin
        MainSession.FireEvent('/session/getnewversion', TXMLTag.Create('url', _url));
        end;
end;

procedure TAutoUpdate.GetNewVersion(event: string; tag: TXMLTag);
var
    tmp: string;
    fstream: TFileStream;
    http: TIdHttp;
    url: string;
begin
    url := tag.Data;
    if (url = '') then exit;

    // ok, there's a new one.
    SetLength(tmp, 256);
    SetLength(tmp, GetTempPath(255, PChar(tmp)));

    tmp := tmp + ExtractFileName(URLToFilename(url));

    http := TIdHTTP.Create(nil);
    fstream := TFileStream.Create(tmp, fmCreate);
    http.Get(url, fstream);
    fstream.Free();
    http.Free();

    ShellExecute(0, 'open', PChar(tmp), '/S', nil, SW_SHOWNORMAL);
end;

initialization
    au := TAutoUpdate.Create();

finalization
    au.Free();

end.
