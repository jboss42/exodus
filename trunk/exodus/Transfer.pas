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

interface

uses
    {$ifdef INDY9}
    IdCustomHTTPServer,
    {$endif}

    XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent,
    IdComponent, IdTCPServer, IdHTTPServer, ComCtrls, StdCtrls, buttonFrame,
    ExRichEdit, ExtCtrls, IdThreadMgr, IdThreadMgrPool, IdAntiFreezeBase,
    IdAntiFreeze, IdThreadMgrDefault, RichEdit2, Grids;

const
    WM_XFER = WM_USER + 5000;

type
  TfrmTransfer = class(TForm)
    pnlFrom: TPanel;
    txtMsg: TExRichEdit;
    frameButtons1: TframeButtons;
    pnlProgress: TPanel;
    Label1: TLabel;
    bar1: TProgressBar;
    httpServer: TIdHTTPServer;
    httpClient: TIdHTTP;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    lblFrom: TLabel;
    txtFrom: TLabel;
    lblFile: TLabel;
    Label5: TLabel;
    lblDesc: TLabel;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure httpClientWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure httpClientWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure httpClientWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    {$ifdef INDY9}
    procedure httpServerCommandGet9(AThread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    {$else}
    procedure httpServerCommandGet8(AThread: TIdPeerThread;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    {$endif}
    procedure httpServerDisconnect(AThread: TIdPeerThread);
    procedure httpServerConnect(AThread: TIdPeerThread);
    procedure lblFileClick(Sender: TObject);
    procedure txtMsgKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fstream: TFileStream;
  protected
    procedure WMXFer(var msg: TMessage); message WM_XFER;
  public
    { Public declarations }
    Mode: integer;
    url: string;
    filename: string;
    jid: string;
  end;

var
  frmTransfer: TfrmTransfer;

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
    sXferConn = 'Got connection.';
    sXferDefaultDesc = 'Sending you a file.';

procedure FileReceive(tag: TXMLTag); overload;
procedure FileReceive(from, url, desc: string); overload;

procedure FileSend(tojid: string; fn: string = '');

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
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
    tmp_tag := qTag.GetFirstTag('desc');
    if (tmp_tag <> nil) then
        desc := tmp_tag.Data
    else
        desc := '';
    FileReceive(from, url, desc);
end;

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
        Mode := 0;

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
    xfer.Show;
    DoNotify(xfer, 'notify_oob', 'File from ' + tmps, ico_service);
    BringWindowToTop(xfer.Handle);
end;

{---------------------------------------}
procedure FileSend(tojid: string; fn: string = '');
var
    xfer: TFrmTransfer;
    tmp_id: TJabberID;
    tmps: string;
    pri: TJabberPres;
    ritem: TJabberRosterItem;
begin
    xfer := TfrmTransfer.Create(Application);

    with xfer do begin
        Mode := 1;
        tmp_id := TJabberID.Create(tojid);
        if (tmp_id.resource = '') then begin
            pri := MainSession.ppdb.FindPres(tmp_id.jid, '');
            if (pri = nil) then begin
                MessageDlg(sXferOnline, mtError, [mbOK], 0);
                Mode := -1;
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
        url := 'http://' + MainSession.Stream.LocalIP + ':5280/' +
               ExtractFileName(filename);
        txtMsg.Lines.Clear();
        txtMsg.Lines.Add(sXferDefaultDesc);
        lblFile.Hint := filename;
        lblFile.Caption := ExtractFileName(filename);
        end;
    xfer.Show;
    BringWindowToTop(xfer.Handle);
end;

{---------------------------------------}
procedure TfrmTransfer.frameButtons1btnOKClick(Sender: TObject);
var
    iq: TXMLTag;
begin
    if Self.Mode = 0 then begin
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
        fstream := TFileStream.Create(filename, fmCreate);
        httpClient.Get(Self.url, fstream);
        fstream.Free;
        end
    else if Self.Mode = 1 then begin
        // send mode
        Self.Mode := 3;
        iq := TXMLTag.Create('iq');
        with iq do begin
            PutAttribute('to', jid);
            PutAttribute('id', MainSession.generateID());
            PutAttribute('type', 'set');
            with AddTag('query') do begin
                putAttribute('xmlns', XMLNS_IQOOB);
                AddBasicTag('url', url);
                AddBasicTag('desc', txtMsg.WideText);
                end;
            end;
        MainSession.SendTag(iq);
        txtMsg.Lines.Add(sXferWaiting);
        httpServer.Active := true;
        end
    else if Self.Mode = 2 then begin
        // Open the file.
        ShellExecute(0, 'open', PChar(filename), '', '', SW_NORMAL);
        Self.Close;
        end;
end;

{---------------------------------------}
procedure TfrmTransfer.httpClientWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
    // Update the progress meter
    bar1.Position := AWorkCount;
end;

{---------------------------------------}
procedure TfrmTransfer.httpClientWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
    bar1.Max := AWorkCountMax;
end;

{---------------------------------------}
procedure TfrmTransfer.httpClientWorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
    frameButtons1.btnOK.Caption := sOpen;
    frameButtons1.btnCancel.Caption := sClose;
    Self.mode := 2;
end;

{---------------------------------------}
procedure TfrmTransfer.frameButtons1btnCancelClick(Sender: TObject);
begin
    case Self.Mode of
    0: httpClient.DisconnectSocket();
    end;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmTransfer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
{$ifdef INDY9}
procedure TfrmTransfer.httpServerCommandGet9(AThread: TIdPeerThread;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
    // send the file.
    txtMsg.Lines.Add(sXferSending);
    httpServer.ServeFile(AThread, AResponseInfo, filename);
end;

{$else}
procedure TfrmTransfer.httpServerCommandGet8(AThread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
begin
    // send the file
    txtMsg.Lines.Add(sXferSending);
    httpServer.ServeFile(AThread, ResponseInfo, filename);
end;
{$endif}

{---------------------------------------}
procedure TfrmTransfer.httpServerDisconnect(AThread: TIdPeerThread);
begin
    txtMsg.Lines.Add(sXferRecvDisconnected);
    SendMessage(Self.Handle, WM_XFER, 0, 0);
end;

{---------------------------------------}
procedure TfrmTransfer.WMXFER(var msg: TMessage);
begin
    // we are getting told to shutdown..
    txtMsg.Lines.Add(sXferTryingClose);
    Self.Close();
end;

{---------------------------------------}
procedure TfrmTransfer.httpServerConnect(AThread: TIdPeerThread);
begin
    txtMsg.Lines.Add(sXferConn);
end;

procedure TfrmTransfer.lblFileClick(Sender: TObject);
begin
    // Browse for a new file..
    if Mode = 0 then begin
        frameButtons1btnOKClick(Sender);
        end
    else if Mode = 1 then begin
        if OpenDialog1.Execute then begin
            // reset the text in the txtMsg richedit..
            filename := OpenDialog1.FileName;
            url := 'http://' + MainSession.Stream.LocalIP + ':5280/' +
                   ExtractFileName(filename);
            txtMsg.Lines.Clear();
            txtMsg.Lines.Add(sXferURL + url);
            end;
        end
    else if Mode = 2 then
        ShellExecute(0, 'open', PChar(filename), '', '', SW_NORMAL);
end;

procedure TfrmTransfer.txtMsgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if ((Key = 13) and (ssCtrl in Shift)) then
        frameButtons1btnOKClick(Self);
end;

procedure TfrmTransfer.FormCreate(Sender: TObject);
begin
    {$ifdef INDY9}
    httpServer.onCommandGet := httpServerCommandGet9;
    {$else}
    httpServer.onCommandGet := httpServerCommandGet8;
    {$endif}
end;

end.
