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
    _last : TDateTime;
    procedure checkDoUpdate();
  protected
    procedure Execute; override;
  public
    property URL : string read _url write _url;
    property Last : TDateTime read _last write _last;
  end;

  TAutoUpdate = class
  private
    procedure IQCallback(event: string; tag: TXMLTag);
    procedure MsgCallback(event: string; tag: TXMLTag);
  public
    initialized: boolean;
    procedure GetNewVersion(event: string; tag: TXMLTag);
  end;

procedure InitAutoUpdate();

const
    JID_AUTOUPDATE  = '1016321811@update.jabber.org';
    XMLNS_AUTOUPDATE = 'jabber:iq:autoupdate';
    EXODUS_REG = '\Software\Jabber\Exodus';

resourcestring
    sUpdateConfirm = 'A new version of Exodus is available.  Would you like to install it?';

implementation

uses
    Controls,
    ExUtils,
    IdHttp,
    IQ,
    Dialogs,
    Forms,
    Registry,
    Session,
    ShellAPI,
    SysUtils,
    Windows,
    XMLUtils;

var
    au: TAutoUpdate;

procedure InitAutoUpdate();
var
    reg : TRegistry;
    j, url : string;
    last : TDateTime;
    t : TAutoUpdateThread;
    x : TXMLTag;
begin
    if (not MainSession.Prefs.getBool('auto_updates')) then exit;

    if (not au.initialized) then begin
        MainSession.RegisterCallback(au.GetNewVersion, '/session/getnewversion');
        MainSession.RegisterCallback(au.MsgCallback,
            '/packet/message/x[@xmlns="jabber:x:autoupdate"]');
        end;

    // If we have the magic reg key, check at a specific URL
    reg := TRegistry.Create();
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey(EXODUS_REG, true);
    url := reg.ReadString('Update_URL');

    // if this is the first time we've gotten here, then let's keep track of
    // the current time, and get all *future* updates.
    try
        last := reg.ReadDateTime('Last_Update');
    except
        on ERegistryException do begin
            last := Now();
            reg.WriteDateTime('Last_Update', last);
            end;
        end;
        
    reg.CloseKey();
    reg.Free();

    if (url <> '') then begin
        t := TAutoUpdateThread.Create(true);
        t.URL := url;
        t.Last := last;
        t.FreeOnTerminate := true;
        t.Resume();
        end
    else begin
        j := JID_AUTOUPDATE + '/' + Trim(GetAppVersion());
        x := TXMLTag.Create('presence');
        x.PutAttribute('to', j);
        MainSession.SendTag(x);
        end;

end;

{ TAutoUpdateThread }
procedure TAutoUpdateThread.Execute;
var
    http : TIdHTTP;
begin
    http := nil;
    try

        http := TIdHTTP.Create(nil);
        http.Head(_url);
        if (http.ResponseCode <> 200) then begin
            //if (Sender <> nil) then ShowMessage(Format(sUpdateHTTPError, [http.ResponseText]));
            exit;
            end;

        if (http.Response.LastModified <= _last) then
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

procedure TAutoUpdate.MsgCallback(event: string; tag: TXMLTag);
var
    iq: TJabberIQ;
begin
    // we are getting a message tag telling us we have an update available
    if (MessageDlg(sUpdateConfirm,
                   mtConfirmation, [mbOK,mbCancel], 0) = mrOK) then begin
        iq := TJabberIQ.Create(MainSession, MainSession.generateID(), Self.IQCallback);
        iq.toJid := JID_AUTOUPDATE;
        iq.iqType := 'get';
        iq.Namespace := XMLNS_AUTOUPDATE;
        iq.Send();
        end;
end;

procedure TAutoUpdate.IQCallback(event: string; tag: TXMLTag);
var
    url: string;
    c: TXMLTagList;
begin
    // parse this mess.. NB: We don't care if we have <beta> or <release>
    {
        <iq type="result" from="winjab@update.denmark" id="1001">
          <query xmlns="jabber:iq:autoupdate">
            <release priority="optional">
              <ver>0.9.1.1</ver>
              <desc/>
              <url>http://update.denmark/winjab/winjab_setup.exe</url>
            </release>
            <beta priority="optional">
              <ver>0.9.2.16</ver>
              <desc/>
              <url>http://update.denmark/winjab/winjab_beta.exe</url>
            </beta>
          </query>
        </iq>
    }
    if (event = 'xml') then begin
        c := tag.GetFirstTag('query').ChildTags;
        url := c[0].GetFirstTag('url').Data;
        MainSession.FireEvent('/session/getnewversion', TXMLTag.Create('url', url));
        end;
end;

procedure TAutoUpdate.GetNewVersion(event: string; tag: TXMLTag);
var
    tmp: string;
    fstream: TFileStream;
    http: TIdHttp;
    url: string;
    reg : TRegistry;
begin
    url := tag.Data;
    if (url = '') then exit;
    reg := nil;
    http := nil;

    try
        // ok, there's a new one.
        SetLength(tmp, 256);
        SetLength(tmp, GetTempPath(255, PChar(tmp)));

        tmp := tmp + ExtractFileName(URLToFilename(url));

        http := TIdHTTP.Create(nil);
        fstream := TFileStream.Create(tmp, fmCreate);
        http.Get(url, fstream);
        fstream.Free();

        if (http.ResponseCode <> 200) then exit;

        reg := TRegistry.Create();
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey(EXODUS_REG, true);
        reg.WriteDateTime('Last_Update', http.Response.LastModified);
        reg.CloseKey();
    finally
        if (reg <> nil) then reg.Free();
        if (http <> nil) then http.Free();
        end;

    ShellExecute(0, 'open', PChar(tmp), '/S', nil, SW_SHOWNORMAL);
end;

initialization
    au := TAutoUpdate.Create();
    au.initialized := false;

finalization
    au.Free();

end.
