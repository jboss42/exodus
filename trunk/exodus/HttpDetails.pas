unit HttpDetails;
{
    Copyright 2002, Joe Hildebrand

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
  Dialogs, buttonFrame, StdCtrls, PrefController;

type
  TfrmHttpDetails = class(TForm)
    frameButtons1: TframeButtons;
    txtURL: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    txtTime: TEdit;
    GroupBox1: TGroupBox;
    lblProxyHost: TLabel;
    txtProxyHost: TEdit;
    lblProxyPort: TLabel;
    txtProxyPort: TEdit;
    chkProxyAuth: TCheckBox;
    lblProxyUsername: TLabel;
    txtProxyUsername: TEdit;
    lblProxyPassword: TLabel;
    txtProxyPassword: TEdit;
    cboProxyApproach: TComboBox;
    Label3: TLabel;
    procedure cboProxyApproachChange(Sender: TObject);
    procedure chkProxyAuthClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetDefaults(profile : TJabberProfile);
    procedure GetValues(var profile : TJabberProfile);
  end;

var
  frmHttpDetails: TfrmHttpDetails;

implementation

{$R *.dfm}

uses
    Session;

procedure TfrmHttpDetails.cboProxyApproachChange(Sender: TObject);
begin
    if (cboProxyApproach.ItemIndex = 2) then begin
        txtProxyHost.Enabled := true;
        txtProxyPort.Enabled := true;
        chkProxyAuth.Enabled := true;
        lblProxyHost.Enabled := true;
        lblProxyPort.Enabled := true;
        end
    else begin
        txtProxyHost.Enabled := false;
        txtProxyPort.Enabled := false;
        chkProxyAuth.Enabled := false;
        chkProxyAuth.Checked := false;
        txtProxyUsername.Enabled := false;
        txtProxyPassword.Enabled := false;
        lblProxyHost.Enabled := false;
        lblProxyPort.Enabled := false;
        lblProxyUsername.Enabled := false;
        lblProxyPassword.Enabled := false;
        end;
end;

procedure TfrmHttpDetails.chkProxyAuthClick(Sender: TObject);
begin
    if (chkProxyAuth.Checked) then begin
        lblProxyUsername.Enabled := true;
        lblProxyPassword.Enabled := true;
        txtProxyUsername.Enabled := true;
        txtProxyPassword.Enabled := true;
        end
    else begin
        lblProxyUsername.Enabled := false;
        lblProxyPassword.Enabled := false;
        txtProxyUsername.Enabled := false;
        txtProxyPassword.Enabled := false;
        end;
end;

procedure TfrmHttpDetails.FormCreate(Sender: TObject);
begin
    MainSession.Prefs.RestorePosition(Self);
end;

procedure TfrmHttpDetails.SetDefaults(profile : TJabberProfile);
begin
    with profile do begin
        txtURL.Text := URL;
        txtTime.Text := IntToStr(Poll);
        cboProxyApproach.ItemIndex := ProxyApproach;
        cboProxyApproachChange(cboProxyApproach);
        txtProxyHost.Text := ProxyHost;
        txtProxyPort.Text := IntToStr(ProxyPort);
        chkProxyAuth.Checked := ProxyAuth;
        chkProxyAuthClick(chkProxyAuth);
        txtProxyUsername.Text := ProxyUsername;
        txtProxyPassword.Text := ProxyPassword;
        end;
end;

procedure TfrmHttpDetails.GetValues(var profile : TJabberProfile);
begin
    with profile do begin
        URL := txtURL.Text;
        Poll := strToIntDef(txtTime.Text, 30);
        ProxyApproach := cboProxyApproach.ItemIndex ;
        ProxyHost := txtProxyHost.Text;
        ProxyPort := StrToIntDef(txtProxyPort.Text, 0);
        ProxyAuth := chkProxyAuth.Checked;
        ProxyUsername := txtProxyUsername.Text;
        ProxyPassword := txtProxyPassword.Text;
        end;
end;

end.
