{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
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
    IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, TntStdCtrls;

type
  TfrmAutoUpdateStatus = class(TForm)
    frameButtons1: TframeButtons;
    Label1: TTntLabel;
    ProgressBar1: TProgressBar;
    Image1: TImage;
    HttpClient: TIdHTTP;
    TntLabel1: TTntLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure HttpClientWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure HttpClientWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure TntLabel1Click(Sender: TObject);

  private
    { Private declarations }
    _url: string;
    _downloading : boolean;
    _fstream: TFileStream;
    _cancel: boolean;
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
    TranslateComponent(Self);
    Image1.Picture.Icon.Handle := LoadIcon(0, IDI_QUESTION);
    _downloading := false;
    _url := '';
    _cancel := false;
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
    if (_downloading) then begin
        _cancel := true;
        HttpClient.DisconnectSocket();
    end
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
    frameButtons1.btnOK.Enabled := false;
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

            if ((_cancel = false) and (httpClient.ResponseCode = 200)) then begin
                label1.Caption := sDownloadComplete;
                label1.Refresh();
                Application.ProcessMessages();

                // XXX: should this just use NOW() instead of the
                // modification date/time on the file??
                MainSession.Prefs.setDateTime('last_update',
                                              httpClient.Response.LastModified);

                label1.Caption := sInstalling;
                label1.Refresh();
                Application.ProcessMessages();

                ShellExecute(Application.Handle, 'open', PChar(tmp), '/S', nil,
                    SW_SHOWNORMAL);
            end
            else if (_cancel = false) then begin
                label1.Caption := WideFormat(sError, [httpClient.ResponseText]);
                Application.ProcessMessages();
            end;
        except
            on EIdConnClosedGracefully do
                Self.Close();
            on E: EIdProtocolReplyError do begin
                label1.Caption := WideFormat(sError, [E.Message]);
            end;
        end;
    finally
        if (_fstream <> nil) then _fstream.Free();
        _downloading := false;
    end;

    if (_cancel) then Self.Close();

end;

procedure TfrmAutoUpdateStatus.TntLabel1Click(Sender: TObject);
var
    url: String; // *not* widestring.
begin
    url := MainSession.Prefs.getString('auto_update_changelog_url');
    ShellExecute(Application.Handle, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

end.
