unit PrefNetwork;
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
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, ComCtrls, TntStdCtrls, ExtCtrls,
  TntExtCtrls;

type
  TfrmPrefNetwork = class(TfrmPrefPanel)
    GroupBox1: TGroupBox;
    Label2: TTntLabel;
    Label3: TTntLabel;
    Label4: TTntLabel;
    txtReconnectTries: TTntEdit;
    spnAttempts: TUpDown;
    txtReconnectTime: TTntEdit;
    spnTime: TUpDown;
    GroupBox2: TGroupBox;
    lblProxyHost: TTntLabel;
    lblProxyPort: TTntLabel;
    lblProxyUsername: TTntLabel;
    lblProxyPassword: TTntLabel;
    Label28: TLabel;
    txtProxyHost: TTntEdit;
    txtProxyPort: TTntEdit;
    chkProxyAuth: TTntCheckBox;
    txtProxyUsername: TTntEdit;
    txtProxyPassword: TTntEdit;
    cboProxyApproach: TTntComboBox;
    procedure cboProxyApproachChange(Sender: TObject);
    procedure chkProxyAuthClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefNetwork: TfrmPrefNetwork;

const
    sBadProxy = 'Your IE proxy settings won''t help, since you use an autoconfiguration script.  Please configure your proxy manually.';

implementation

{$R *.dfm}
uses
    GnuGetText, ExUtils, PrefController, Session, Registry;

procedure TfrmPrefNetwork.LoadPrefs();
var
    i: integer;
begin
    with MainSession.Prefs do begin
        // reconnect config
        i := getInt('recon_tries');
        if (i <= 0) then i := 3;
        spnAttempts.Position := i;
        spnTime.Position := getInt('recon_time');

        // proxy config
        cboProxyApproach.ItemIndex := getInt('http_proxy_approach');
        cboProxyApproachChange(cboProxyApproach);
        txtProxyHost.Text := getString('http_proxy_host');
        txtProxyPort.Text := getString('http_proxy_port');
        chkProxyAuth.Checked := getBool('http_proxy_auth');
        chkProxyAuthClick(chkProxyAuth);
        txtProxyUsername.Text := getString('http_proxy_user');
        txtProxyPassword.Text := getString('http_proxy_password');
    end;
end;

procedure TfrmPrefNetwork.SavePrefs();
var
    reg: TRegistry;
begin
    with MainSession.Prefs do begin
        // reconnect config
        setInt('recon_tries', spnAttempts.Position);
        setInt('recon_time', spnTime.Position);

        // Network
        setInt('http_proxy_approach', cboProxyApproach.ItemIndex);
        if (cboProxyApproach.ItemIndex = http_proxy_ie) then begin
            reg := TRegistry.Create();
            try
                reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings', false);
                if (reg.ValueExists('AutoConfigURL')) then begin
                    setInt('http_proxy_approach', http_proxy_custom);
                    cboProxyApproach.ItemIndex := http_proxy_custom;
                    cboProxyApproachChange(Self);
                    txtProxyHost.SetFocus();
                    MessageDlgW(_(sBadProxy), mtWarning, [mbOK], 0);
                end;
            finally
                reg.Free();
            end;
        end;

        setString('http_proxy_host', txtProxyHost.Text);
        setInt('http_proxy_port', StrToIntDef(txtProxyPort.Text, 0));
        setBool('http_proxy_auth', chkProxyAuth.Checked);
        setString('http_proxy_user', txtProxyUsername.Text);
        setString('http_proxy_password', txtProxyPassword.Text);
    end;
end;


{---------------------------------------}
procedure TfrmPrefNetwork.cboProxyApproachChange(Sender: TObject);
begin
    if (cboProxyApproach.ItemIndex = http_proxy_custom) then begin
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

{---------------------------------------}
procedure TfrmPrefNetwork.chkProxyAuthClick(Sender: TObject);
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


end.
