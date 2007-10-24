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

type
  TfrmPrefTransfer = class(TfrmPrefPanel)
    Label15: TTntLabel;
    txtXFerPath: TTntEdit;
    btnTransferBrowse: TTntButton;
    Label2: TTntLabel;
    optPeer: TTntRadioButton;
    grpPeer: TGroupBox;
    Label1: TTntLabel;
    txtPort: TTntEdit;
    chkIP: TTntCheckBox;
    txtIP: TTntEdit;
    optWebDav: TTntRadioButton;
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
    procedure btnTransferBrowseClick(Sender: TObject);
    procedure chkIPClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure optWebDavClick(Sender: TObject);
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
    p: integer;
begin
    with MainSession.Prefs do begin
        txtXFerPath.Text := getString('xfer_path');
        p := getInt('xfer_port');
        if (p <= 0) then p := 5280;
        txtPort.Text := IntToStr(p);
        txtIP.Text := getString('xfer_ip');

        optWebDav.Checked := getBool('xfer_webdav');
        optPeer.Checked := not optWebDav.Checked;

        txtDavHost.Text := getString('xfer_davhost');
        txtDavPort.Text := getString('xfer_davport');
        txtDavPath.Text := getString('xfer_davpath');
        txtDavUsername.Text := getString('xfer_davusername');
        txtDavPassword.Text := getString('xfer_davpassword');
    end;
end;

procedure TfrmPrefTransfer.SavePrefs();
var
    p: integer;
begin
    with MainSession.Prefs do begin
        setString('xfer_path', txtXFerPath.Text);
        p := StrToIntDef(txtPort.Text, 5280);
        if (p < 0) then p := 5280;
        if (p > 65535) then p := 5280;
        setInt('xfer_port', p);
        setString('xfer_ip', txtIP.Text);

        setBool('xfer_webdav', optWebDav.Checked);
        setString('xfer_davhost', txtDavHost.Text);
        setString('xfer_davport', txtDavPort.Text);
        setString('xfer_davpath', txtDavPath.Text);
        setString('xfer_davusername', txtDavUsername.Text);
        setString('xfer_davpassword', txtDavPassword.Text);
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
    optPeer.Checked := true;
    optWebDavClick(Self);
    txtPort.Text := '5280';
    chkIP.Checked := false;
    txtIP.Text := '';
    chkIPClick(Self);
end;

procedure TfrmPrefTransfer.optWebDavClick(Sender: TObject);
begin
  inherited;
    grpPeer.Enabled := optPeer.Checked;
    grpPeer.Visible := optPeer.Checked;

    grpWebDav.Enabled := optWebDav.Checked;
    grpWebDav.Visible := optWebDav.Checked;
end;

end.