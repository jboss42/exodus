unit PrefNetwork;

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
    StaticText4: TTntPanel;
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

implementation

{$R *.dfm}
uses
    PrefController, Session;

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
begin
    with MainSession.Prefs do begin
        // reconnect config
        setInt('recon_tries', spnAttempts.Position);
        setInt('recon_time', spnTime.Position);

        // Network
        setInt('http_proxy_approach', cboProxyApproach.ItemIndex);
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
