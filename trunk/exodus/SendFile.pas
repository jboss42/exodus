unit SendFile;
{
    Copyright 2003, Peter Millard

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
  Unicode, SyncObjs, 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dockable, StdCtrls, ComCtrls, RichEdit2, ExRichEdit,
  TntStdCtrls, ExtCtrls, buttonFrame, IdCustomHTTPServer, IdHTTPServer,
  IdSocks, IdBaseComponent, IdComponent, IdTCPServer, IdTCPConnection,
  IdTCPClient, IdHTTP;

const
    WM_SEND_DONE = WM_USER + 6002;

type
    TExSendFileMode = (send_oob, send_dav, send_si);

    TFileSendThread = class;

    TfrmSendFile = class(TfrmDockable)
        frameButtons1: TframeButtons;
        pnlFrom: TPanel;
        lblFrom: TTntLabel;
        lblTo: TTntLabel;
        lblFile: TTntLabel;
        Label5: TTntLabel;
        lblDesc: TTntLabel;
        txtMsg: TExRichEdit;
        OpenDialog1: TOpenDialog;
        TCPServer: TIdTCPServer;
        SocksInfo: TIdSocksInfo;
        httpServer: TIdHTTPServer;
        httpClient: TIdHTTP;
        procedure frameButtons1btnOKClick(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure FormDestroy(Sender: TObject);
        procedure httpServerCommandGet(AThread: TIdPeerThread;
         ARequestInfo: TIdHTTPRequestInfo;
         AResponseInfo: TIdHTTPResponseInfo);
    procedure httpServerDisconnect(AThread: TIdPeerThread);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure httpServerConnect(AThread: TIdPeerThread);
    protected
        procedure WMThreadDone(var msg: TMessage); message WM_SEND_DONE;
    private
        { Private declarations }
        mode: TExSendFileMode;
        _thread: TFileSendThread;
        _cur_file: String;
        _cur_path: String;

        procedure _sendIQ();
    public
        { Public declarations }
        url: string;
        filename: string;
        jid: string;
    end;

    TFileSendThread = class(TThread)
    private
        _http: TIdHTTP;
        _stream: TFileStream;
        _form: TfrmSendFile;
        _pos_max: longint;
        _pos: longint;
        _new_txt: TWidestringlist;
        _lock: TCriticalSection;
        _url: string;
        _method: string;

        procedure Update();
        procedure setHttp(value: TIdHttp);

        procedure httpClientStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: String);
        procedure httpClientConnected(Sender: TObject);
        procedure httpClientDisconnected(Sender: TObject);
        procedure httpClientWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
        procedure httpClientWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
        procedure httpClientWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
    protected
        procedure Execute; override;
    public
        constructor Create(); reintroduce;

        property http: TIdHttp read _http write setHttp;
        property stream: TFileStream read _stream write _stream;
        property form: TfrmSendFile read _form write _form;
        property url: String read _url write _url;
        property method: String read _method write _method;
    end;


var
  frmSendFile: TfrmSendFile;

procedure FileSend(tojid: string; fn: string = '');

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    FileServer, ExSession,
    XMLTag, JabberConst,  
    Transfer, Session, Presence, Roster, JabberID;

{---------------------------------------}
procedure FileSend(tojid: string; fn: string = '');
var
    xfer: TfrmSendFile;
    tmp_id: TJabberID;
    ip, tmps: string;
    pri: TJabberPres;
    ritem: TJabberRosterItem;
    p: integer;
    dav_path: Widestring;
begin
    xfer := TfrmSendFile.Create(Application);

    with xfer do begin
        // Make sure the contact is online
        tmp_id := TJabberID.Create(tojid);
        if (tmp_id.resource = '') then begin
            pri := MainSession.ppdb.FindPres(tmp_id.jid, '');
            if (pri = nil) then begin
                MessageDlg(sXferOnline, mtError, [mbOK], 0);
                xfer.Close;
                exit;
            end;
            tmps := pri.fromJID.full;
        end
        else
            tmps := tojid;

        jid := tmps;
        tmp_id.Free();

        tmp_id := TJabberID.Create(tmps);
        ritem := MainSession.Roster.Find(tmp_id.jid);
        if (ritem = nil) then
            ritem := MainSession.Roster.Find(tmp_id.full);

        if (ritem <> nil) then begin
            tmps := ritem.Nickname;
            lblTo.Hint := tmps;
        end
        else
            tmps := tmp_id.full;
        tmp_id.Free();

        // Setup the GUI
        lblTo.Caption := tmps;
        lblTo.Hint := jid;
        lblTo.Caption := sTo;

        //pnlProgress.Visible := false;
        frameButtons1.btnOK.Caption := sSend;
        if (fn <> '') then
            filename := fn
        else begin
            if not OpenDialog1.Execute then exit;
            filename := OpenDialog1.Filename;
        end;

        // get xfer prefs, and spin up URL
        with MainSession.Prefs do begin
            if (getBool('xfer_webdav')) then begin
                Mode := send_dav;
                ip := getString('xfer_davhost');
                dav_path := getString('xfer_davpath');
                url := ip + dav_path + '/' + ExtractFilename(filename);
            end
            else begin
                Mode := send_oob;
                ip := getString('xfer_ip');
                p := getInt('xfer_port');

                if (ip = '') then ip := MainSession.Stream.LocalIP;
                url := 'http://' + ip + ':' + IntToStr(p) + '/' + ExtractFileName(filename);
            end;
        end;

        txtMsg.Lines.Clear();
        txtMsg.Lines.Add(sXferDefaultDesc);
        lblFile.Hint := filename;
        lblFile.Caption := ExtractFileName(filename);
    end;
    xfer.ShowDefault();
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TFileSendThread.Create();
begin
    //
    inherited Create(true);

    _pos := 0;
    _form := nil;
    _new_txt := TWidestringlist.Create();
    _lock := TCriticalSection.Create();

end;

{---------------------------------------}
procedure TFileSendThread.setHttp(value: TIdHttp);
begin
    _http := Value;
    with _http do begin
        OnConnected := Self.httpClientConnected;
        OnDisconnected := Self.httpClientDisconnected;
        OnWork := Self.httpClientWork;
        OnWorkBegin := Self.httpClientWorkBegin;
        OnWorkEnd := Self.httpClientWorkEnd;
        OnStatus := httpClientStatus;
    end;
end;


{---------------------------------------}
procedure TFileSendThread.Execute();
begin
    try
        try
            if (_method = 'get') then
                _http.Get(_url, _stream)
            else
                _http.Put(Self.url, _stream);
        finally
            FreeAndNil(_stream);
        end;
    except
    end;

    SendMessage(_form.Handle, WM_THREAD_DONE, 0, _http.ResponseCode);
end;

{---------------------------------------}
procedure TFileSendThread.Update();
var
    i: integer;
begin
    _lock.Acquire();

    if ((Self.Suspended) or (Self.Terminated)) then begin
        _lock.Release();
        _http.DisconnectSocket();
        FreeAndNil(_stream);
        Self.Terminate();
    end;

    with _form do begin
        //bar1.Max := _pos_max;
        //bar1.Position := _pos;
        for i := 0 to _new_txt.Count - 1 do
            txtMsg.Lines.Add(_new_txt[i]);
        _new_txt.Clear();
    end;
    _lock.Release();
end;

{---------------------------------------}
procedure TFileSendThread.httpClientStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
    _lock.Acquire();
    _new_txt.Add(AStatusText);
    _lock.Release();
    Synchronize(Update);
end;

{---------------------------------------}
procedure TFileSendThread.httpClientConnected(Sender: TObject);
begin
    _lock.Acquire();
    _new_txt.Add(sXferConn);
    _lock.Release();
    Synchronize(Update);
end;

{---------------------------------------}
procedure TFileSendThread.httpClientDisconnected(Sender: TObject);
begin
    // NB: For Indy9, it fires disconnected before it actually
    // connects. So if we drop the stream here, our GETs
    // never work since the response stream gets freed.
    {$ifndef INDY9}
    if (_stream <> nil) then
        FreeAndNil(_stream);
    {$endif}
end;


{---------------------------------------}
procedure TFileSendThread.httpClientWorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
    _lock.Acquire();
    _new_txt.Add(sXferDone);
    _lock.Release();
    Synchronize(Update);
end;

{---------------------------------------}
procedure TFileSendThread.httpClientWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
    // Update the progress meter
    _pos := AWorkCount;
    Synchronize(Update);
end;

{---------------------------------------}
procedure TFileSendThread.httpClientWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
    _pos_max := AWorkCountMax;
    _pos := 0;
    Synchronize(Update);
end;

{---------------------------------------}
procedure TfrmSendFile.frameButtons1btnOKClick(Sender: TObject);
var
    u, p: string;
    dp: integer;
    fStream: TFileStream;
begin
    if (Mode = send_dav) then begin
        // check to see if we need to auth
        u := MainSession.Prefs.getString('xfer_davusername');
        p := MainSession.Prefs.getString('xfer_davpassword');
        if (u <> '') then with httpClient.Request do begin
            BasicAuthentication := true;
            Username := u;
            Password := p;
        end;

        dp := MainSession.Prefs.getInt('xfer_davport');
        if (dp > 0) then
            httpClient.Port := dp;

        // get a handle to the stream
        try
            fStream := TFileStream.Create(filename, fmOpenRead);
        except
            on EStreamError do begin
                MessageDlg(sXferStreamError, mtError, [mbOK], 0);
                exit;
            end;
        end;

        _thread := TFileSendThread.Create();
        _thread.url := Url;
        _thread.form := Self;
        _thread.http := httpClient;
        _thread.stream := fstream;
        _thread.method := 'put';
        _thread.Resume();

    end
    else begin
        Self.Mode := send_oob;
        _cur_file := ExtractFilename(filename);
        _cur_path := filename;
        with httpServer do begin
            AutoStartSession := true;
            Active := true;
        end;
        _sendIQ();
        //Self.Close();
    end;
end;

{---------------------------------------}
procedure TfrmSendFile.WMThreadDone(var msg: TMessage);
begin
    // our thread completed.
    if (Self.Mode = send_dav) then begin
        if ((msg.LParam >= 200) and
            (msg.LParam < 300)) then
            _sendIQ()
        else
            MessageDlg(sXferDavError, mtError, [mbOK], 0);
        Self.Close();
    end;
end;

{---------------------------------------}
procedure TfrmSendFile._sendIQ();
var
    iq: TXMLTag;
begin
    // normal p2p... just add it to our server,
    // and close the form.
    iq := TXMLTag.Create('iq');
    with iq do begin
        setAttribute('to', jid);
        setAttribute('id', MainSession.generateID());
        setAttribute('type', 'set');
        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_IQOOB);
            AddBasicTag('url', url);
            AddBasicTag('desc', txtMsg.WideText);
        end;
    end;
    MainSession.SendTag(iq);
end;

{---------------------------------------}
procedure TfrmSendFile.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmSendFile.FormDestroy(Sender: TObject);
begin
  inherited;
    if (_thread <> nil) then begin
        _thread.Terminate();
        _thread := nil;
    end;
end;

{---------------------------------------}
procedure TfrmSendFile.httpServerCommandGet(AThread: TIdPeerThread;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
    f: string;
begin
    // send the file.
    f := ARequestInfo.Document;
    if (f[1] = '/') then Delete(f, 1, 1);
    if (f <> _cur_file) then with AResponseInfo do begin
        ResponseNo := 404;
        CloseConnection := true;
        txtMsg.Lines.Add('Sent a 404 error to the recipient');
    end
    else begin
        txtMsg.Lines.Add('Sending file to the recipient');
        httpServer.ServeFile(AThread, AResponseInfo, _cur_path);
    end;
end;

{---------------------------------------}
procedure TfrmSendFile.httpServerDisconnect(AThread: TIdPeerThread);
begin
  inherited;
    //
    Self.Close();
end;

procedure TfrmSendFile.frameButtons1btnCancelClick(Sender: TObject);
begin
  inherited;
    // xxx: code
end;

procedure TfrmSendFile.httpServerConnect(AThread: TIdPeerThread);
begin
  inherited;
    txtMsg.Lines.Add('Accepted receivers connection');
end;

end.
