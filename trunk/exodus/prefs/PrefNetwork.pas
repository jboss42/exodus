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
  TntExtCtrls, ExNumericEdit, ExGroupBox, TntForms, ExFrame, ExBrandPanel;

type
  TfrmPrefNetwork = class(TfrmPrefPanel)
    pnlContainer: TExBrandPanel;
    gbReconnect: TExGroupBox;
    pnlAttempts: TExBrandPanel;
    lblAttempts: TTntLabel;
    txtAttempts: TExNumericEdit;
    pnlTime: TExBrandPanel;
    lblTime: TTntLabel;
    txtTime: TExNumericEdit;
    lblTime2: TTntLabel;
    lblSeconds: TTntLabel;
    gbProxy: TExGroupBox;
    rbIE: TTntRadioButton;
    rbNone: TTntRadioButton;
    rbCustom: TTntRadioButton;
    pnlProxyInfo: TExBrandPanel;
    lblProxyHost: TTntLabel;
    txtProxyHost: TTntEdit;
    lblProxyPort: TTntLabel;
    txtProxyPort: TTntEdit;
    pnlAuthInfo: TExBrandPanel;
    chkProxyAuth: TTntCheckBox;
    lblProxyUsername: TTntLabel;
    txtProxyUsername: TTntEdit;
    lblProxyPassword: TTntLabel;
    txtProxyPassword: TTntEdit;
    procedure rbIEClick(Sender: TObject);
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
    GnuGetText, JabberUtils, ExUtils,  PrefFile, PrefController, Session, Registry;

{---------------------------------------}
procedure TfrmPrefNetwork.LoadPrefs();
var
    pType: integer;
    s: TPrefState;
begin
    inherited;
    ptype := MainSession.Prefs.getInt('http_proxy_approach');
    case (ptype) of
        http_proxy_ie: rbIE.Checked := true;
        http_proxy_none: rbNone.Checked := true;
        else rbCustom.Checked := true;
    end;

    s := getPrefState('http_proxy_approach');
    rbIe.Visible := (s <> psInvisible);
    rbIE.Enabled := (s <> psReadOnly);
    rbNone.Visible := (s <> psInvisible);
    rbNone.enabled := (s <> psReadOnly);
    rbCustom.Visible := (s <> psInvisible);
    rbCustom.Enabled := (s <> psReadOnly);
    pnlProxyInfo.Visible := (s <> psInvisible);
    pnlProxyInfo.Enabled := (s <> psReadOnly);
    pnlAuthInfo.Visible := (s <> psInvisible);
    pnlAuthInfo.Enabled := (s <> psReadOnly);

    if (StrToInt(txtAttempts.Text) < 0) then txtAttempts.Text := '3';

    pnlContainer.captureChildStates();

    rbIEClick(Self);

    pnlContainer.checkAutoHide();
end;

procedure TfrmPrefNetwork.rbIEClick(Sender: TObject);
begin
    inherited;
    pnlProxyInfo.Enabled := rbCustom.Checked;
    pnlAuthInfo.Enabled := rbCustom.Checked;
    if (not rbCustom.Checked) then
        chkProxyAuth.Checked := false;
    chkProxyAuthClick(Self);
end;

{---------------------------------------}
procedure TfrmPrefNetwork.SavePrefs();
var
    reg: TRegistry;
    ptype: integer;
begin
    inherited;
    if (rbIE.Checked) then
        ptype := http_proxy_ie
    else if (rbNone.Checked) then
        ptype := http_proxy_none
    else
        ptype := http_proxy_custom;

    if (ptype = http_proxy_ie) then begin
        reg := TRegistry.Create();
        try
            reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings', false);
            if (reg.ValueExists('AutoConfigURL')) then begin
                ptype := http_proxy_custom;
                rbCustom.Checked := true;
                rbIEClick(Self);
                txtProxyHost.SetFocus();
                MessageDlgW(_(sBadProxy), mtWarning, [mbOK], 0);
            end;
        finally
            reg.Free();
        end;
    end;
    MainSession.prefs.setInt('http_proxy_approach', ptype);
end;


{---------------------------------------}
procedure TfrmPrefNetwork.chkProxyAuthClick(Sender: TObject);
begin
    lblProxyUsername.Enabled := chkProxyAuth.Checked;
    lblProxyPassword.Enabled := chkProxyAuth.Checked;
    txtProxyUsername.Enabled := chkProxyAuth.Checked;
    txtProxyPassword.Enabled := chkProxyAuth.Checked;
end;


end.
