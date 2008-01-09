unit AutoUpdateStatus;
{
    Copyright 2002, Peter Millard

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
    XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, StdCtrls, buttonFrame, ExtCtrls, IdBaseComponent,
    IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TfrmAutoUpdateStatus = class(TForm)
    frameButtons1: TframeButtons;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Image1: TImage;
    HttpClient: TIdHTTP;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure HttpClientWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure HttpClientWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure frameButtons1btnOKClick(Sender: TObject);

  private
    { Private declarations }
    _url: string;
    _downloading : boolean;
    _fstream: TFileStream;
    procedure getFile();
  public
    { Public declarations }
    property URL : string read _url write _url;
  end;

procedure ShowAutoUpdateStatus(URL : string); overload;

var
  frmAutoUpdateStatus: TfrmAutoUpdateStatus;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    ExUtils, GnuGetText, IdException, IQ, Registry, Session, ShellAPI;

{---------------------------------------}
procedure ShowAutoUpdateStatus(URL : string);
begin
     if (frmAutoUpdateStatus = nil) then
        frmAutoUpdateStatus := TfrmAutoUpdateStatus.Create(Application);
    frmAutoUpdateStatus.URL := URL;
    frmAutoUpdateStatus.Show();
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.FormCreate(Sender: TObject);
begin
    TranslateProperties(Self);
    Image1.Picture.Icon.Handle := LoadIcon(0, IDI_QUESTION);
    _downloading := false;
    _url := '';
    MainSession.Prefs.setProxy(HttpClient);
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
    frmAutoUpdateStatus := nil;
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.frameButtons1btnCancelClick(
  Sender: TObject);
begin
    if (_downloading) then
        HttpClient.DisconnectSocket()
    else
        Self.Close();
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.HttpClientWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
    ProgressBar1.Position := AWorkCount;
    Application.ProcessMessages();
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.HttpClientWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
    ProgressBar1.Max := AWorkCountMax;
    label1.Caption := sDownloading;
    label1.Refresh();
    Application.ProcessMessages();
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.frameButtons1btnOKClick(Sender: TObject);
begin
    Self.getFile();
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.getFile();
var
    tmp : string;
begin
    SetLength(tmp, 256);
    SetLength(tmp, GetTempPath(255, PChar(tmp)));

    tmp := tmp + ExtractFileName(URLToFilename(_url));

    ProgressBar1.Visible := true;
    label1.Caption := sInitializing;
    label1.Refresh();
    Image1.Picture.Icon.Handle := LoadIcon(0, IDI_INFORMATION);
    Image1.Refresh();
    _downloading := true;
    Application.ProcessMessages();

    _fstream := nil;
    try
        try
            _fstream := TFileStream.Create(tmp, fmCreate);
            httpClient.Get(_url, _fstream);
            _fstream.Free();
            _fstream := nil;

            if (httpClient.ResponseCode = 200) then begin
                label1.Caption := sDownloadComplete;
                label1.Refresh();
                Application.ProcessMessages();

                MainSession.Prefs.setString('last_update',
                    DateTimeToStr(httpClient.Response.LastModified));

                label1.Caption := sInstalling;
                label1.Refresh();
                Application.ProcessMessages();

                ShellExecute(0, 'open', PChar(tmp), '/S', nil, SW_SHOWNORMAL);
            end
            else begin
                label1.Caption := Format(sError, [httpClient.ResponseText]);
                Application.ProcessMessages();
            end;
        except
            on EIdConnClosedGracefully do
                Self.Close();
            on E: EIdProtocolReplyError do begin
                label1.Caption := Format(sError, [E.Message]);
            end;
        end;
    finally
        if (_fstream <> nil) then _fstream.Free();
        _downloading := false;
    end;
end;

end.
