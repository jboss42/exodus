unit Transfer;
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
    // Exodus things
    XMLTag, Dockable, ExRichEdit, RichEdit2, buttonFrame,
    Unicode, 

    // Indy Things
    IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent,
    IdComponent, IdThreadMgr, IdThread, IdAntiFreezeBase, IdAntiFreeze,

    // Normal Delphi things
    SyncObjs, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, StdCtrls, ExtCtrls, TntExtCtrls, TntStdCtrls;

const
    WM_THREAD_DONE = WM_USER + 6001;

type
    TTransferThread = class;

    TfrmTransfer = class(TfrmDockable)
        pnlFrom: TPanel;
        txtMsg: TExRichEdit;
        frameButtons1: TframeButtons;
        pnlProgress: TTntPanel;
        Label1: TTntLabel;
        bar1: TProgressBar;
        httpClient: TIdHTTP;
        OpenDialog1: TOpenDialog;
        SaveDialog1: TSaveDialog;
        lblFrom: TTntLabel;
        txtFrom: TTntLabel;
        lblFile: TTntLabel;
        Label5: TTntLabel;
        lblDesc: TTntLabel;
        procedure frameButtons1btnOKClick(Sender: TObject);
        procedure frameButtons1btnCancelClick(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure lblFileClick(Sender: TObject);
        procedure txtMsgKeyDown(Sender: TObject; var Key: Word;
          Shift: TShiftState);
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        protected
        procedure WMThreadDone(var msg: TMessage); message WM_THREAD_DONE;
    private
        { Private declarations }
        _thread: TTransferThread;

        procedure doSendIQ();
    public
        { Public declarations }
        Mode: integer;
        url: string;
        filename: string;
        jid: string;
        send_dav: boolean;
    end;

    TTransferThread = class(TIdThread)
    private
        _http: TIdHTTP;
        _stream: TFileStream;
        _form: TfrmTransfer;
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
        procedure Run; override;
    public
        constructor Create(); reintroduce;

        property http: TIdHttp read _http write setHttp;
        property stream: TFileStream read _stream write _stream;
        property form: TfrmTransfer read _form write _form;
        property url: String read _url write _url;
        property method: String read _method write _method;
    end;


var
  frmTransfer: TfrmTransfer;

const
    xfer_invalid = -1;
    xfer_recv = 0;
    xfer_send = 1;
    xfer_recvd = 2;
    xfer_sending = 3;
    xfer_davputting = 4;

resourcestring
    sXferRecv = '%s is sending you a file.';
    sXferURL = 'File transfer URL: ';
    sXferDesc = 'File Description: ';
    sXferOnline = 'The Contact must be online before you can send a file.';
    sSend = 'Send';
    sOpen = 'Open';
    sClose = 'Close';
    sTo = 'To:     ';
    sXferOverwrite = 'This file already exists. Overwrite?';
    sXferWaiting = 'Waiting for connection...';
    sXferSending = 'Sending file...';
    sXferRecvDisconnected = 'Receiver disconnected.';
    sXferTryingClose = 'Trying to close.';
    sXferDone = 'File transfer is done.';
    sXferConn = 'Got connection.';
    sXferDefaultDesc = 'Sending you a file.';
    sXferCreateDir = 'This directory does not exist. Create it?';
    sXferStreamError = 'There was an error trying to create the file.';
    sXferDavError = 'There was an error trying to upload the file to your web host.';
    sXferRecvError = 'There was an error receiving the file.';

procedure FileReceive(tag: TXMLTag); overload;
procedure FileReceive(from, url, desc: string); overload;

procedure FileSend(tojid: string; fn: string = '');

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    ExSession,
    JabberConst, Notify, JabberID, Roster, Session, Presence,
    ShellAPI, Jabber1, ExUtils;

{---------------------------------------}
procedure FileReceive(tag: TXMLTag); overload;
var
    qTag, tmp_tag: TXMLTag;
    from, url, desc: string;
begin
    // Callback for receiving file transfers
    from := tag.GetAttribute('from');
    qTag := tag.getFirstTag('query');
    tmp_tag := qtag.GetFirstTag('url');
    url := tmp_tag.Data;

    // if this isn't an http:// url, then ignore.
    if (Pos('http:', url) <> 1) then exit;

    tmp_tag := qTag.GetFirstTag('desc');
    if (tmp_tag <> nil) then
        desc := tmp_tag.Data
    else
        desc := '';
    FileReceive(from, url, desc);
end;

{---------------------------------------}
procedure FileReceive(from, url, desc: string); overload;
var
    tmps: string;
    tmp_jid: TJabberID;
    xfer: TfrmTransfer;
    ritem: TJabberRosterItem;
begin
    xfer := TfrmTransfer.Create(Application);
    xfer.url := url;
    with xfer do begin
        jid := from;
        Mode := xfer_recv;

        tmp_jid := TJabberID.Create(jid);
        ritem := MainSession.Roster.Find(tmp_jid.jid);
        if (ritem = nil) then
            ritem := MainSession.Roster.Find(tmp_jid.full);

        if (ritem <> nil) then begin
            tmps := ritem.Nickname;
            txtFrom.Hint := from;
        end
        else
            tmps := tmp_jid.full;
        txtFrom.Caption := tmps;

        lblFile.Caption := ExtractFilename(URLToFileName(url));
        lblFile.Hint := url;

        txtMsg.Lines.Clear();
        txtMsg.Lines.Add(Format(sXferRecv, [from]));

        if (desc <> '') then
            txtMsg.Lines.Add(sXferDesc + desc);

        txtMsg.ReadOnly := true;
        lblDesc.Visible := false;
        tmp_jid.Free();

    end;
    xfer.ShowDefault();
    DoNotify(xfer, 'notify_oob', 'File from ' + tmps, ico_service);
end;

{---------------------------------------}
procedure FileSend(tojid: string; fn: string = '');
var
    xfer: TFrmTransfer;
    tmp_id: TJabberID;
    ip, tmps: string;
    pri: TJabberPres;
    ritem: TJabberRosterItem;
    p: integer;
    dav_path: Widestring;
begin
    xfer := TfrmTransfer.Create(Application);

    with xfer do begin
        Mode := xfer_send;

        // Make sure the contact is online
        tmp_id := TJabberID.Create(tojid);
        if (tmp_id.resource = '') then begin
            pri := MainSession.ppdb.FindPres(tmp_id.jid, '');
            if (pri = nil) then begin
                MessageDlg(sXferOnline, mtError, [mbOK], 0);
                Mode := xfer_invalid;
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
            txtFrom.Hint := tmps;
        end
        else
            tmps := tmp_id.full;
        tmp_id.Free();

        // Setup the GUI
        txtFrom.Caption := tmps;
        txtFrom.Hint := jid;
        lblFrom.Caption := sTo;

        pnlProgress.Visible := false;
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
                send_dav := true;
                ip := getString('xfer_davhost');
                dav_path := getString('xfer_davpath');
                url := ip + dav_path + '/' + ExtractFilename(filename);
            end
            else begin
                send_dav := false;
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
constructor TTransferThread.Create();
begin
    //
    inherited Create;
    
    _pos := 0;
    _form := nil;
    _new_txt := TWidestringlist.Create();
    _lock := TCriticalSection.Create();

end;

{---------------------------------------}
procedure TTransferThread.setHttp(value: TIdHttp);
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
procedure TTransferThread.Run();
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
    Self.Terminate();
end;

{---------------------------------------}
procedure TTransferThread.Update();
var
    i: integer;
begin
    _lock.Acquire();

    if ((Self.Stopped) or (Self.Terminated)) then begin
        _lock.Release();
        _http.DisconnectSocket();
        FreeAndNil(_stream);
        Self.Terminate();
    end;

    with _form do begin
        bar1.Max := _pos_max;
        bar1.Position := _pos;
        for i := 0 to _new_txt.Count - 1 do
            txtMsg.Lines.Add(_new_txt[i]);
        _new_txt.Clear();
    end;
    _lock.Release();
end;

{---------------------------------------}
procedure TTransferThread.httpClientStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
    _lock.Acquire();
    _new_txt.Add(AStatusText);
    _lock.Release();
    Synchronize(Update);
end;

{---------------------------------------}
procedure TTransferThread.httpClientConnected(Sender: TObject);
begin
    _lock.Acquire();
    _new_txt.Add(sXferConn);
    _lock.Release();
    Synchronize(Update);
end;

{---------------------------------------}
procedure TTransferThread.httpClientDisconnected(Sender: TObject);
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
procedure TTransferThread.httpClientWorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
    _lock.Acquire();
    _new_txt.Add(sXferDone);
    _lock.Release();
    Synchronize(Update);
end;

{---------------------------------------}
procedure TTransferThread.httpClientWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
    // Update the progress meter
    _pos := AWorkCount;
    Synchronize(Update);
end;

{---------------------------------------}
procedure TTransferThread.httpClientWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
    _pos_max := AWorkCountMax;
    _pos := 0;
    Synchronize(Update);
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmTransfer.frameButtons1btnCancelClick(Sender: TObject);
begin
    if ((Self.Mode = xfer_davputting) or
        (Self.Mode = xfer_recv)) then
        httpClient.DisconnectSocket();
    Self.Close;
end;


{---------------------------------------}
procedure TfrmTransfer.frameButtons1btnOKClick(Sender: TObject);
var
    u, p: string;
    file_path: String;
    dp: integer;
    fStream: TFileStream;
begin
    if Self.Mode = xfer_recv then begin
        // receive mode
        filename := URLToFilename(Self.url);

        // use the save as dialog
        SaveDialog1.Filename := filename;
        if (not SaveDialog1.Execute) then exit;
        filename := SaveDialog1.filename;

        if FileExists(filename) then begin
            if MessageDlg(sXferOverwrite,
                mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
            DeleteFile(filename);
        end;

        file_path := ExtractFilePath(filename);
        if (not DirectoryExists(file_path)) then begin
            if MessageDlg(sXferCreateDir, mtConfirmation,
                [mbYes, mbNo], 0) = mrNo then exit;
            CreateDir(file_path);
        end;

        // Create a stream, and get the file into it.
        try
            fstream := TFileStream.Create(filename, fmCreate);
        except
            on EStreamError do begin
                MessageDlg(sXferStreamError, mtError, [mbOK], 0);
                exit;
            end;
        end;

        _thread := TTransferThread.Create();
        _thread.url := Url;
        _thread.form := Self;
        _thread.http := httpClient;
        _thread.stream := fstream;
        _thread.method := 'get';
        _thread.Start();
    end
    else if Self.Mode = xfer_send then begin
        // send mode
        if (send_dav) then begin
            // first do the HTTP PUT
            Self.Mode := xfer_davputting;

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

            _thread := TTransferThread.Create();
            _thread.url := Url;
            _thread.form := Self;
            _thread.http := httpClient;
            _thread.stream := fstream;
            _thread.method := 'put';

            _thread.Start();
        end
        else begin
            Self.Mode := xfer_sending;
            doSendIQ();
            ExFileServer.AddFile(filename);
            Self.Close();
        end;
    end
    else if Self.Mode = xfer_recvd then begin
        // Open the file.
        ShellExecute(0, 'open', PChar(filename), '', '', SW_NORMAL);
        Self.Close;
    end;
end;

{---------------------------------------}
procedure TfrmTransfer.WMThreadDone(var msg: TMessage);
begin
    // our thread completed.
    if (Self.Mode = xfer_davputting) then begin
        Self.Mode := xfer_sending;
        if ((msg.LParam >= 200) and
            (msg.LParam < 300)) then
            doSendIQ()
        else
            MessageDlg(sXferDavError, mtError, [mbOK], 0);

        Self.Close();
    end
    else if (Self.Mode = xfer_recv) then begin
        if ((msg.LParam >= 200) and
            (msg.LParam < 300)) then begin
            frameButtons1.btnOK.Caption := sOpen;
            frameButtons1.btnCancel.Caption := sClose;
            mode := xfer_recvd;
        end
        else begin
            MessageDlg(sXferRecvError, mtError, [mbOK], 0);
            DeleteFile(filename);
            Self.Close();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmTransfer.doSendIQ();
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
procedure TfrmTransfer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmTransfer.lblFileClick(Sender: TObject);
begin
    // Browse for a new file..
    if Mode = xfer_recv then begin
        frameButtons1btnOKClick(Sender);
    end
    else if Mode = xfer_send then begin
        if OpenDialog1.Execute then begin
            // reset the text in the txtMsg richedit..
            filename := OpenDialog1.FileName;
            url := 'http://' + MainSession.Stream.LocalIP + ':5280/' +
                   ExtractFileName(filename);
            txtMsg.Lines.Clear();
            txtMsg.Lines.Add(sXferURL + url);
        end;
    end
    else if Mode = xfer_send then
        ShellExecute(0, 'open', PChar(filename), '', '', SW_NORMAL);
end;

{---------------------------------------}
procedure TfrmTransfer.txtMsgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if ((Key = 13) and (ssCtrl in Shift)) then
        frameButtons1btnOKClick(Self);
end;

{---------------------------------------}
procedure TfrmTransfer.FormCreate(Sender: TObject);
begin
    //
    AssignUnicodeFont(Self);
    URLLabel(lblFile);
end;

{---------------------------------------}
procedure TfrmTransfer.FormDestroy(Sender: TObject);
begin
    if (_thread <> nil) then begin
        _thread.Terminate();
        _thread := nil;
    end;
end;

end.
