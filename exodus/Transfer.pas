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
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent,
    IdComponent, IdTCPServer, IdHTTPServer, ComCtrls, StdCtrls, buttonFrame,
    ExRichEdit, ExtCtrls, IdThreadMgr, IdThreadMgrPool, IdAntiFreezeBase,
  IdAntiFreeze, IdThreadMgrDefault;

const
    WM_XFER = WM_USER + 5000;

type
  TfrmTransfer = class(TForm)
    pnlFrom: TPanel;
    lblFrom: TStaticText;
    txtFrom: TStaticText;
    txtMsg: TExRichEdit;
    frameButtons1: TframeButtons;
    pnlProgress: TPanel;
    Label1: TLabel;
    bar1: TProgressBar;
    httpServer: TIdHTTPServer;
    httpClient: TIdHTTP;
    OpenDialog1: TOpenDialog;
    procedure txtMsgURLClick(Sender: TObject; url: String);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure httpClientWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure httpClientWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure httpClientWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure httpServerCommandGet(AThread: TIdPeerThread;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    procedure httpServerDisconnect(AThread: TIdPeerThread);
    procedure httpServerConnect(AThread: TIdPeerThread);
  private
    { Private declarations }
    totBytes: longint;
    fstream: TFileStream;
  protected
    procedure WMXFer(var msg: TMessage); message WM_XFER;
  public
    { Public declarations }
    Mode: integer;
    url: string;
    filename: string;
  end;

var
  frmTransfer: TfrmTransfer;

procedure FileReceive(from, url, desc: string);
procedure FileSend(tojid: string);

implementation

{$R *.dfm}

uses
    JabberID,
    Session,
    Presence, 
    XMLTag, 
    ShellAPI,
    ExUtils;

procedure FileReceive(from, url, desc: string);
var
    xfer: TfrmTransfer;
begin
    xfer := TfrmTransfer.Create(nil);
    xfer.url := url;
    with xfer do begin
        Mode := 0;

        txtFrom.Caption := from;
        txtMsg.Lines.Add(from + ' is sending you a file');
        txtMsg.Lines.Add('File Transfer URL: ' + url);

        if (desc <> '') then
            txtMsg.Lines.Add('File Description: ' + desc);
        end;
    xfer.Show;
end;

procedure FileSend(tojid: string);
var
    xfer: TFrmTransfer;
    tmp_id: TJabberID;
    s_jid: string;
    pri: TJabberPres;
begin
    xfer := TfrmTransfer.Create(nil);

    with xfer do begin
        Mode := 1;
        tmp_id := TJabberID.Create(tojid);
        if (tmp_id.resource = '') then begin
            pri := MainSession.ppdb.FindPres(tmp_id.jid, '');
            if (pri = nil) then begin
                MessageDlg('The Contact must be online before you can send a file.',
                    mtError, [mbOK], 0);
                Mode := -1;
                xfer.Close;
                exit;
                end;
            s_jid := pri.fromJID.full;
            end
        else
            s_jid := tojid;

        lblFrom.Caption := 'To:    ';
        txtFrom.Caption := s_jid;
        pnlProgress.Visible := false;
        frameButtons1.btnOK.Caption := 'Send';
        if not OpenDialog1.Execute then exit;
        filename := OpenDialog1.Filename;
        url := 'http://' + MainSession.Stream.LocalIP + ':5280/' +
            ExtractFileName(filename);
        txtMsg.Lines.Add('File Transfer URL: ' + url);
        end;
    xfer.Show;
end;

procedure TfrmTransfer.txtMsgURLClick(Sender: TObject; url: String);
begin
    // Browse for a new file..
    if Mode = 0 then begin
        frameButtons1btnOKClick(Sender);
        end
    else if Mode = 1 then begin
        if OpenDialog1.Execute then begin
            // reset the text in the txtMsg richedit..
            end;
        end
    else if Mode = 2 then
        ShellExecute(0, 'open', PChar(filename), '', '', SW_NORMAL);
end;

procedure TfrmTransfer.frameButtons1btnOKClick(Sender: TObject);
var
    iq: TXMLTag;
begin
    if Self.Mode = 0 then begin
        // receive mode
        totBytes := 0;
        filename := URLToFilename(Self.url);
        if FileExists(filename) then begin
            if MessageDlg('This file already exists. Overwrite?',
                mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
            DeleteFile(filename);
            end;
        fstream := TFileStream.Create(filename, fmCreate);
        httpClient.Get(Self.url, fstream);
        end
    else if Self.Mode = 1 then begin
        // send mode
        Self.Mode := 3;
        iq := TXMLTag.Create('iq');
        with iq do begin
            PutAttribute('to', txtFrom.Caption);
            PutAttribute('id', MainSession.generateID());
            PutAttribute('type', 'set');
            with AddTag('query') do begin
                putAttribute('xmlns', 'jabber:iq:oob');
                AddBasicTag('url', url);
                end;
            end;
        MainSession.SendTag(iq);
        txtMsg.Lines.Add('Waiting for connection...');
        httpServer.Active := true;
        end
    else if Self.Mode = 2 then begin
        // Open the file.
        ShellExecute(0, 'open', PChar(filename), '', '', SW_NORMAL);
        end;
end;

procedure TfrmTransfer.httpClientWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
    // Update the progress meter
    totBytes := totBytes + AWorkCount;
    bar1.Position := totBytes;
end;

procedure TfrmTransfer.httpClientWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
    bar1.Max := AWorkCountMax;
end;

procedure TfrmTransfer.httpClientWorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
    frameButtons1.btnOK.Caption := 'Open';
    frameButtons1.btnCancel.Caption := 'Close';
    Self.mode := 2;
end;

procedure TfrmTransfer.frameButtons1btnCancelClick(Sender: TObject);
begin
    case Self.Mode of
    0: httpClient.DisconnectSocket();
    end;
    Self.Close;
end;

procedure TfrmTransfer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmTransfer.httpServerCommandGet(AThread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
begin
    // send the file
    txtMsg.Lines.Add('Sending File...');
    httpServer.ServeFile(AThread, ResponseInfo, filename);
end;

procedure TfrmTransfer.httpServerDisconnect(AThread: TIdPeerThread);
begin
    txtMsg.Lines.Add('Receiver Disconnected.');
    SendMessage(Self.Handle, WM_XFER, 0, 0);
end;

procedure TfrmTransfer.WMXFER(var msg: TMessage);
begin
    // we are getting told to shutdown..
    txtMsg.Lines.Add('Trying to close');
    Self.Close();
end;


procedure TfrmTransfer.httpServerConnect(AThread: TIdPeerThread);
begin
    txtMsg.Lines.Add('Got Connection.');
end;

end.
