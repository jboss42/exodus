unit About;
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
  Dialogs, jpeg, ExtCtrls, StdCtrls, buttonFrame, ComCtrls, ExRichEdit,
  RichEdit2;

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    frameButtons1: TframeButtons;
    pnlVersion: TPanel;
    InfoBox: TExRichEdit;
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure InfoBoxURLClick(Sender: TObject; url: String);
    procedure pnlVersionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

uses
    GnuGetText, ShellAPI, XMLUtils, Session;

procedure TfrmAbout.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
    TranslateProperties(Self);
    pnlVersion.Caption := 'Version: ' + GetAppVersion();
    MainSession.Prefs.RestorePosition(Self);
end;

procedure TfrmAbout.InfoBoxURLClick(Sender: TObject; url: String);
begin
    ShellExecute(0, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmAbout.pnlVersionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    i: integer;
    str: string;
begin
    if (not (ssCtrl in Shift)) then exit;

    str := Application.ExeName;
    for i := 1 to ParamCount do
        str := str + ' ' + ParamStr(i);
    MessageDlg(str, mtInformation, [mbOK], 0);
end;

end.
