unit ConnDetails;
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
    PrefController,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, buttonFrame, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmConnDetails = class(TForm)
    Panel1: TPanel;
    Label8: TLabel;
    cboConnection: TComboBox;
    Label6: TLabel;
    txtPriority: TEdit;
    spnPriority: TUpDown;
    frameButtons1: TframeButtons;
    PageControl1: TPageControl;
    tbsSocket: TTabSheet;
    tbsHttp: TTabSheet;
    Label1: TLabel;
    txtURL: TEdit;
    txtTime: TEdit;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    lblProxyHost: TLabel;
    lblProxyPort: TLabel;
    lblProxyUsername: TLabel;
    lblProxyPassword: TLabel;
    Label3: TLabel;
    txtProxyHost: TEdit;
    txtProxyPort: TEdit;
    chkProxyAuth: TCheckBox;
    txtProxyUsername: TEdit;
    txtProxyPassword: TEdit;
    cboProxyApproach: TComboBox;
    txtHost: TEdit;
    Label4: TLabel;
    Label7: TLabel;
    txtPort: TEdit;
    chkSSL: TCheckBox;
    GroupBox2: TGroupBox;
    lblSocksHost: TLabel;
    lblSocksPort: TLabel;
    lblSocksType: TLabel;
    lblSocksUsername: TLabel;
    lblSocksPassword: TLabel;
    chkSocksAuth: TCheckBox;
    txtSocksHost: TEdit;
    txtSocksPort: TEdit;
    cboSocksType: TComboBox;
    txtSocksUsername: TEdit;
    txtSocksPassword: TEdit;
    Bevel1: TBevel;
    Label5: TLabel;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure chkSocksAuthClick(Sender: TObject);
    procedure cboSocksTypeChange(Sender: TObject);
    procedure cboProxyApproachChange(Sender: TObject);
    procedure chkProxyAuthClick(Sender: TObject);
    procedure chkSSLClick(Sender: TObject);
    procedure cboConnectionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    _profile: TJabberProfile;

    procedure SetSocket(profile: TJabberProfile);
    procedure GetSocket(var profile: TJabberProfile);

    procedure SetHttp(profile: TJabberProfile);
    procedure GetHttp(var profile: TJabberProfile);

  public
    { Public declarations }
  end;

var
  frmConnDetails: TfrmConnDetails;

function ShowConnDetails(p: TJabberProfile): integer;

implementation

{$R *.dfm}

uses
    Session;

function ShowConnDetails(p: TJabberProfile): integer;
var
    f: TfrmConnDetails;
begin
    //
    f := TfrmConnDetails.Create(Application);

    with f do begin
        _profile := p;
        tbsSocket.TabVisible := false;
        tbsHttp.TabVisible := false;

        SetHttp(p);
        SetSocket(p);

        cboConnection.ItemIndex := p.ConnectionType;
        if (p.ConnectionType = conn_normal) then 
            PageControl1.ActivePage := tbsSocket
        else if (p.ConnectionType = conn_http) then
            PageControl1.ActivePage := tbsHttp;
        end;

    result := f.ShowModal();
end;

procedure TfrmConnDetails.frameButtons1btnOKClick(Sender: TObject);
begin
    // save the info...
    _profile.ConnectionType := cboConnection.ItemIndex;
    _profile.Priority := spnPriority.Position;

    if _profile.ConnectionType = conn_normal then
        GetSocket(_profile)
    else
        GetHttp(_profile);

    ModalResult := mrOK;
end;

procedure TfrmConnDetails.chkSocksAuthClick(Sender: TObject);
begin
    if (chkSocksAuth.Checked) then begin
        lblSocksUsername.Enabled := true;
        lblSocksPassword.Enabled := true;
        txtSocksUsername.Enabled := true;
        txtSocksPassword.Enabled := true;
        end
    else begin
        lblSocksUsername.Enabled := false;
        lblSocksPassword.Enabled := false;
        txtSocksUsername.Enabled := false;
        txtSocksPassword.Enabled := false;
        end;
end;

procedure TfrmConnDetails.cboSocksTypeChange(Sender: TObject);
begin
    if (cboSocksType.ItemIndex = 0) then begin
        txtSocksHost.Enabled := false;
        txtSocksPort.Enabled := false;
        txtSocksUsername.Enabled := false;
        txtSocksPassword.Enabled := false;
        chkSocksAuth.Enabled := false;
        chkSocksAuth.Checked := false;
        lblSocksHost.Enabled := false;
        lblSocksPort.Enabled := false;
        lblSocksUsername.Enabled := false;
        lblSocksPassword.Enabled := false;
        end
    else begin
        if (not txtSocksHost.Enabled) then begin
            txtSocksHost.Enabled := true;
            txtSocksPort.Enabled := true;
            chkSocksAuth.Enabled := true;
            lblSocksHost.Enabled := true;
            lblSocksPort.Enabled := true;
            end;
        end;
end;

procedure TfrmConnDetails.SetSocket(profile: TJabberProfile);
begin
    with profile do begin
        txtHost.Text := Host;
        txtPort.Text := IntToStr(Port);
        chkSSL.Checked := ssl;
        cboSocksType.ItemIndex := SocksType;
        cboSocksTypeChange(cboSocksType);
        txtSocksHost.Text := SocksHost;
        txtSocksPort.Text := IntToStr(SocksPort);
        chkSocksAuth.Checked := SocksAuth;
        chkSocksAuthClick(chkSocksAuth);
        txtSocksUsername.Text := SocksUsername;
        txtSocksPassword.Text := SocksPassword;
        end;
end;

procedure TfrmConnDetails.GetSocket(var profile: TJabberProfile);
begin
    with profile do begin
        Host := txtHost.Text;
        Port := StrToIntDef(txtPort.Text, 5222);
        ssl := chkSSL.Checked;

        SocksType := cboSocksType.ItemIndex;
        SocksHost := txtSocksHost.Text;
        SocksPort := StrToIntDef(txtSocksPort.Text, 0);
        SocksAuth := chkSocksAuth.Checked;
        SocksUsername := txtSocksUsername.Text;
        SocksPassword := txtSocksPassword.Text;
        end;
end;


procedure TfrmConnDetails.cboProxyApproachChange(Sender: TObject);
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

procedure TfrmConnDetails.chkProxyAuthClick(Sender: TObject);
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

procedure TfrmConnDetails.SetHttp(profile: TJabberProfile);
begin
    with profile do begin
        txtURL.Text := URL;
        txtTime.Text := FloatToStr(Poll / 1000.0);
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

procedure TfrmConnDetails.GetHttp(var profile: TJabberProfile);
begin
    with profile do begin
        URL := txtURL.Text;
        Poll := Trunc(strToFloatDef(txtTime.Text, 30) * 1000);
        ProxyApproach := cboProxyApproach.ItemIndex ;
        ProxyHost := txtProxyHost.Text;
        ProxyPort := StrToIntDef(txtProxyPort.Text, 0);
        ProxyAuth := chkProxyAuth.Checked;
        ProxyUsername := txtProxyUsername.Text;
        ProxyPassword := txtProxyPassword.Text;
        end;
end;


procedure TfrmConnDetails.chkSSLClick(Sender: TObject);
begin
    if (chkSSL.Checked) then begin
        if (txtPort.Text = '5222') then
            txtPort.Text := '5223';
        end
    else begin
        if (txtPort.Text = '5223') then
            txtPort.Text := '5222';
        end;
end;

procedure TfrmConnDetails.cboConnectionChange(Sender: TObject);
begin
    // Change the current tab and the profile info.
    if cboConnection.ItemIndex = 0 then
        PageControl1.ActivePage := tbsSocket
    else
        PageControl1.ActivePage := tbsHttp;

    _profile.ConnectionType := cboConnection.ItemIndex;
end;

procedure TfrmConnDetails.FormCreate(Sender: TObject);
begin
    MainSession.Prefs.RestorePosition(Self);
end;

procedure TfrmConnDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

end.
