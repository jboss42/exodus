unit PrefTransfer;
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
  Dialogs, PrefPanel, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls;

const
    xfer_socks = 0;
    xfer_proxy = 1;
    xfer_oob = 2;
    xfer_dav = 3;

type
  TfrmPrefTransfer = class(TfrmPrefPanel)
    Label15: TTntLabel;
    txtXFerPath: TTntEdit;
    btnTransferBrowse: TTntButton;
    Label2: TTntLabel;
    grpPeer: TGroupBox;
    Label1: TTntLabel;
    txtPort: TTntEdit;
    chkIP: TTntCheckBox;
    txtIP: TTntEdit;
    grpWebDav: TGroupBox;
    Label3: TTntLabel;
    txtDavHost: TTntEdit;
    txtDavPort: TTntEdit;
    Label4: TTntLabel;
    txtDavPath: TTntEdit;
    Label5: TTntLabel;
    Label6: TTntLabel;
    Label7: TTntLabel;
    txtDavUsername: TTntEdit;
    txtDavPassword: TTntEdit;
    Label8: TTntLabel;
    Label9: TTntLabel;
    StaticText4: TTntPanel;
    cboXferMode: TTntComboBox;
    grpProxy: TGroupBox;
    TntLabel1: TTntLabel;
    txtS5bProxy: TTntEdit;
    TntLabel2: TTntLabel;
    procedure btnTransferBrowseClick(Sender: TObject);
    procedure chkIPClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure cboXferModeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
    frmPrefTransfer: TfrmPrefTransfer;

resourcestring
    sPrefsXFerDir = 'Select download directory';


implementation
{$WARN UNIT_PLATFORM OFF}
{$R *.dfm}
uses
    Session, FileCtrl;

procedure TfrmPrefTransfer.LoadPrefs();
var
    m: integer;
    p: integer;
begin
    with MainSession.Prefs do begin
        txtXFerPath.Text := getString('xfer_path');
        p := getInt('xfer_port');
        if (p <= 0) then p := 5280;
        txtPort.Text := IntToStr(p);
        txtIP.Text := getString('xfer_ip');

        m := xfer_socks;
        if (getBool('xfer_webdav')) then m := xfer_dav;
        if (getBool('xfer_proxy')) then m := xfer_proxy;
        if (getBool('xfer_oob')) then m := xfer_oob;
        cboXferMode.ItemIndex := m;

        txtDavHost.Text := getString('xfer_davhost');
        txtDavPort.Text := getString('xfer_davport');
        txtDavPath.Text := getString('xfer_davpath');
        txtDavUsername.Text := getString('xfer_davusername');
        txtDavPassword.Text := getString('xfer_davpassword');
        txtS5bProxy.Text := getString('xfer_prefproxy');

        cboXferModeChange(Self);
    end;
end;

procedure TfrmPrefTransfer.SavePrefs();
var
    m, p: integer;
begin
    with MainSession.Prefs do begin
        setString('xfer_path', txtXFerPath.Text);
        p := StrToIntDef(txtPort.Text, 5280);
        if (p < 0) then p := 5280;
        if (p > 65535) then p := 5280;
        setInt('xfer_port', p);
        setString('xfer_ip', txtIP.Text);

        m := cboXferMode.ItemIndex;
        setBool('xfer_webdav', (m = xfer_dav));
        setBool('xfer_proxy', (m = xfer_proxy));
        setBool('xfer_oob', (m = xfer_oob));

        setString('xfer_davhost', txtDavHost.Text);
        setString('xfer_davport', txtDavPort.Text);
        setString('xfer_davpath', txtDavPath.Text);
        setString('xfer_davusername', txtDavUsername.Text);
        setString('xfer_davpassword', txtDavPassword.Text);
        setString('xfer_prefproxy', txtS5bProxy.Text);
    end;
end;

procedure TfrmPrefTransfer.btnTransferBrowseClick(Sender: TObject);
var
    tmps: string;
begin
    tmps := txtXFerPath.Text;
    if SelectDirectory(sPrefsXFerDir, '', tmps) then
        txtXFerPath.Text := tmps;
end;

procedure TfrmPrefTransfer.chkIPClick(Sender: TObject);
begin
  inherited;
    txtIP.Enabled := chkIP.Checked;
    if (not txtIP.Enabled) then txtIP.Text := '';
end;

procedure TfrmPrefTransfer.Label2Click(Sender: TObject);
begin
  inherited;
    // reset everything to defaults..
    txtXFerPath.Text := ExtractFilePath(Application.EXEName);
    cboXferMode.ItemIndex := 0;
    cboXferModeChange(Self);
    txtPort.Text := '5280';
    chkIP.Checked := false;
    txtIP.Text := '';
    chkIPClick(Self);
end;

procedure TfrmPrefTransfer.cboXferModeChange(Sender: TObject);
var
    m: integer;
begin
  inherited;
    // change the grp visible based on itemindex.
    m := cboXferMode.ItemIndex;

    grpPeer.Enabled := (m = xfer_oob);
    grpPeer.Visible := (m = xfer_oob);

    grpWebDav.Enabled := (m = xfer_dav);
    grpWebDav.Visible := (m = xfer_dav);

    grpProxy.Enabled := (m = xfer_proxy);
    grpProxy.Visible := (m = xfer_proxy);
end;

end.
