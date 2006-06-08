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
    lblXferPath: TTntLabel;
    txtXFerPath: TTntEdit;
    btnTransferBrowse: TTntButton;
    lblXferDefault: TTntLabel;
    grpPeer: TGroupBox;
    lblXferPort: TTntLabel;
    txtXferPort: TTntEdit;
    chkXferIP: TTntCheckBox;
    txtXferIP: TTntEdit;
    grpWebDav: TGroupBox;
    lblDavHost: TTntLabel;
    txtDavHost: TTntEdit;
    txtDavPort: TTntEdit;
    lblDavPort: TTntLabel;
    txtDavPath: TTntEdit;
    lblDavPath: TTntLabel;
    lblDavPath2: TTntLabel;
    lblDavUsername: TTntLabel;
    txtDavUsername: TTntEdit;
    txtDavPassword: TTntEdit;
    lblDavPassword: TTntLabel;
    lblDavHost2: TTntLabel;
    cboXferMode: TTntComboBox;
    grpProxy: TGroupBox;
    lbl65Proxy: TTntLabel;
    txt65Proxy: TTntEdit;
    lblXferMethod: TTntLabel;
    procedure btnTransferBrowseClick(Sender: TObject);
    procedure chkXferIPClick(Sender: TObject);
    procedure lblXferDefaultClick(Sender: TObject);
    procedure cboXferModeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
    frmPrefTransfer: TfrmPrefTransfer;

const
    sPrefsXFerDir = 'Select download directory';


implementation
{$WARN UNIT_PLATFORM OFF}
{$R *.dfm}
uses
    JabberUtils, ExUtils,  Session, FileCtrl;

procedure TfrmPrefTransfer.LoadPrefs();
var
    m: integer;
begin
    inherited;
    with MainSession.Prefs do begin
        m := xfer_socks;
        if (getBool('xfer_webdav')) then m := xfer_dav;
        if (getBool('xfer_proxy')) then m := xfer_proxy;
        if (getBool('xfer_oob')) then m := xfer_oob;
        cboXferMode.ItemIndex := m;
        cboXferModeChange(Self);
    end;
end;

procedure TfrmPrefTransfer.SavePrefs();
var
    m: integer;
begin
    inherited;
    with MainSession.Prefs do begin
        m := cboXferMode.ItemIndex;
        setBool('xfer_webdav', (m = xfer_dav));
        setBool('xfer_proxy', (m = xfer_proxy));
        setBool('xfer_oob', (m = xfer_oob));

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

procedure TfrmPrefTransfer.chkXferIPClick(Sender: TObject);
begin
  inherited;
    txtXferIP.Enabled := chkXferIP.Checked;
    if (not txtXferIP.Enabled) then txtXferIP.Text := '';
end;

procedure TfrmPrefTransfer.lblXferDefaultClick(Sender: TObject);
begin
  inherited;
    // reset everything to defaults..
    txtXFerPath.Text := ExtractFilePath(Application.EXEName);
    cboXferMode.ItemIndex := 0;
    cboXferModeChange(Self);
    txtXferPort.Text := '5280';
    chkXferIP.Checked := false;
    txtXferIP.Text := '';
    chkXferIPClick(Self);
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

procedure TfrmPrefTransfer.FormCreate(Sender: TObject);
begin
  inherited;
    AssignUnicodeURL(lblXferDefault.Font, 8);
end;

end.
