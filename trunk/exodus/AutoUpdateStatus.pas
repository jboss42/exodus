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
    _tag: TXMLTag;
    procedure getFile();
  public
    { Public declarations }
    procedure setTag(tag: TXMLTag);
    property URL : string read _url write _url;
  end;

procedure ShowAutoUpdateStatus(URL : string); overload;
procedure ShowAutoUpdateStatus(tag : TXMLTag); overload;

const
    EXODUS_REG = '\Software\Jabber\Exodus';
    JID_AUTOUPDATE  = '1016321811@update.jabber.org';
    XMLNS_AUTOUPDATE = 'jabber:iq:autoupdate';

resourcestring
    sDownloading      = 'Downloading...';
    sDownloadComplete = 'Download Complete';
    sInitializing     = 'Initializing...';
    sInstalling       = 'Installing...';
    sError            = 'Error: %s';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    ExUtils,
    IdException,
    IQ,
    Registry,
    Session,
    ShellAPI;

var
  frmAutoUpdateStatus: TfrmAutoUpdateStatus;

{---------------------------------------}
procedure ShowAutoUpdateStatus(tag : TXMLTag);
begin
     if (frmAutoUpdateStatus = nil) then
        frmAutoUpdateStatus := TfrmAutoUpdateStatus.Create(Application);
    frmAutoUpdateStatus.setTag(tag);
    frmAutoUpdateStatus.Show();
end;

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
    Image1.Picture.Icon.Handle := LoadIcon(0, IDI_QUESTION);
    _downloading := false;
    _tag := nil;
    _url := '';
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
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.HttpClientWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
    ProgressBar1.Max := AWorkCountMax;
    label1.Caption := sDownloading;
    label1.Refresh();
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
    reg : TRegistry;
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

                reg := TRegistry.Create();
                reg.RootKey := HKEY_LOCAL_MACHINE;
                reg.OpenKey(EXODUS_REG, true);
                reg.WriteDateTime('Last_Update', httpClient.Response.LastModified);
                reg.CloseKey();

                label1.Caption := sInstalling;
                label1.Refresh();

                ShellExecute(0, 'open', PChar(tmp), '/S', nil, SW_SHOWNORMAL);
                end
            else begin
                label1.Caption := Format(sError, [httpClient.ResponseText]);
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

{---------------------------------------}
procedure TfrmAutoUpdateStatus.setTag(tag: TXMLTag);
var
    c: TXMLTagList;
begin
    // deal with the iq-result tag.
    _tag := TXMLTag.Create(tag);

    c := tag.GetFirstTag('query').ChildTags;
    _url := c[0].GetFirstTag('url').Data;
end;



end.
