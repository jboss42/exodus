unit SocketDetails;
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
  TfrmSocketDetails = class(TForm)
    frameButtons1: TframeButtons;
    Label7: TLabel;
    txtPort: TEdit;
    chkSSL: TCheckBox;
    Label1: TLabel;
    txtHost: TEdit;
    GroupBox1: TGroupBox;
    chkSocksAuth: TCheckBox;
    lblSocksHost: TLabel;
    lblSocksPort: TLabel;
    txtSocksHost: TEdit;
    txtSocksPort: TEdit;
    lblSocksType: TLabel;
    cboSocksType: TComboBox;
    lblSocksUsername: TLabel;
    txtSocksUsername: TEdit;
    lblSocksPassword: TLabel;
    txtSocksPassword: TEdit;
    procedure chkSSLClick(Sender: TObject);
    procedure cboSocksTypeChange(Sender: TObject);
    procedure chkSocksAuthClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetDefaults(profile : TJabberProfile);
    procedure GetValues(var profile : TJabberProfile);
  end;

var
  frmSocketDetails: TfrmSocketDetails;

implementation

{$R *.dfm}

uses
    Session;
    
procedure TfrmSocketDetails.chkSSLClick(Sender: TObject);
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


procedure TfrmSocketDetails.cboSocksTypeChange(Sender: TObject);
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

procedure TfrmSocketDetails.chkSocksAuthClick(Sender: TObject);
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

procedure TfrmSocketDetails.FormCreate(Sender: TObject);
begin
    MainSession.Prefs.RestorePosition(Self);
end;

procedure TfrmSocketDetails.SetDefaults(profile: TJabberProfile);
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

procedure TfrmSocketDetails.GetValues(var profile : TJabberProfile);
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

end.
