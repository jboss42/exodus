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
    Dialogs, buttonFrame, ComCtrls, StdCtrls, ExtCtrls, TntStdCtrls;

type
  TfrmConnDetails = class(TForm)
    frameButtons1: TframeButtons;
    PageControl1: TPageControl;
    tbsSocket: TTabSheet;
    tbsHttp: TTabSheet;
    Label1: TLabel;
    txtURL: TEdit;
    txtTime: TEdit;
    Label2: TLabel;
    Label5: TLabel;
    txtKeys: TEdit;
    Label9: TLabel;
    tbsProfile: TTabSheet;
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
    Label3: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    cboServer: TTntComboBox;
    chkSavePasswd: TCheckBox;
    txtUsername: TTntEdit;
    txtPassword: TTntEdit;
    cboResource: TTntComboBox;
    tbsConn: TTabSheet;
    Label4: TLabel;
    Label7: TLabel;
    txtHost: TEdit;
    txtPort: TEdit;
    chkSSL: TCheckBox;
    Label8: TLabel;
    cboConnection: TComboBox;
    Label6: TLabel;
    txtPriority: TEdit;
    spnPriority: TUpDown;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure chkSocksAuthClick(Sender: TObject);
    procedure cboSocksTypeChange(Sender: TObject);
    procedure chkSSLClick(Sender: TObject);
    procedure cboConnectionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure txtUsernameKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    _profile: TJabberProfile;

    procedure SetSocket(profile: TJabberProfile);
    procedure GetSocket(profile: TJabberProfile);
    procedure SetHttp(profile: TJabberProfile);
    procedure GetHttp(profile: TJabberProfile);
    procedure SetProfile(profile: TJabberProfile);
    procedure GetProfile(profile: TJabberProfile);
    procedure SetConn(profile: TJabberProfile);
    procedure GetConn(profile: TJabberProfile);


  public
    { Public declarations }
  end;

var
  frmConnDetails: TfrmConnDetails;

function ShowConnDetails(p: TJabberProfile): integer;

resourcestring
    sSmallKeys = 'Must have a larger number of poll keys.';
    sConnDetails = '%s Details';
    sProfileInvalidJid = 'The Jabber ID you entered (username@server/resource) is invalid. Please enter a valid username, server, and resource.';
    sResourceWork = 'Work';
    sResourceHome = 'Home';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    ExUtils, JabberID, Unicode, Session;

{---------------------------------------}
function ShowConnDetails(p: TJabberProfile): integer;
var
    f: TfrmConnDetails;
begin
    //
    f := TfrmConnDetails.Create(Application);

    with f do begin
        _profile := p;
        f.Caption := Format(sConnDetails, [p.Name]);
        SetProfile(p);
        SetConn(p);
        SetHttp(p);
        SetSocket(p);
        PageControl1.ActivePage := tbsProfile;
    end;

    result := f.ShowModal();
end;

{---------------------------------------}
procedure TfrmConnDetails.frameButtons1btnOKClick(Sender: TObject);
begin
    // save the info...
    GetProfile(_profile);
    GetConn(_profile);

    if _profile.ConnectionType = conn_normal then
        GetSocket(_profile)
    else
        GetHttp(_profile);

    ModalResult := mrOK;
end;

{---------------------------------------}
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

{---------------------------------------}
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

{---------------------------------------}
procedure TfrmConnDetails.SetSocket(profile: TJabberProfile);
begin
    with profile do begin
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

{---------------------------------------}
procedure TfrmConnDetails.GetSocket(profile: TJabberProfile);
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

{---------------------------------------}
procedure TfrmConnDetails.SetProfile(profile: TJabberProfile);
begin
    with profile do begin
        // populate the fields
        txtUsername.Text := Username;
        txtPassword.Text := Password;
        cboServer.Text := Server;
        cboResource.Text := Resource;
        chkSavePasswd.Checked := SavePasswd;
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.GetProfile(profile: TJabberProfile);
begin
    with Profile do begin
        // Update the profile
        Server := cboServer.Text;
        Username := txtUsername.Text;
        SavePasswd := chkSavePasswd.Checked;
        password := txtPassword.Text;
        resource := cboResource.Text;
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.SetConn(profile: TJabberProfile);
begin
    with profile do begin
        txtHost.Text := Host;
        txtPort.Text := IntToStr(Port);
        chkSSL.Checked := ssl;
        cboConnection.ItemIndex := ConnectionType;
        spnPriority.Position := Priority;
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.GetConn(profile: TJabberProfile);
begin
    with profile do begin
        Host := txtHost.Text;
        Port := StrToIntDef(txtPort.Text, 5222);
        ssl := chkSSL.Checked;
        ConnectionType := cboConnection.ItemIndex;
        Priority := spnPriority.Position;
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.SetHttp(profile: TJabberProfile);
begin
    with profile do begin
        txtURL.Text := URL;
        txtTime.Text := FloatToStr(Poll / 1000.0);
        txtKeys.Text := IntToStr(NumPollKeys);
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.GetHttp(profile: TJabberProfile);
begin
    with profile do begin
        URL := txtURL.Text;
        Poll := Trunc(strToFloatDef(txtTime.Text, 30) * 1000);
        NumPollKeys := StrToInt(txtKeys.Text);
        if (NumPollKeys < 2) then begin
            NumPollKeys := 256;
            txtKeys.Text := '256';
            MessageDlg(sSmallKeys, mtWarning, [mbOK], 0);
        end;
        
    end;
end;

{---------------------------------------}
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

{---------------------------------------}
procedure TfrmConnDetails.cboConnectionChange(Sender: TObject);
begin
    // Change the current tab and the profile info.
    if cboConnection.ItemIndex = 0 then
        PageControl1.ActivePage := tbsSocket
    else
        PageControl1.ActivePage := tbsHttp;

    _profile.ConnectionType := cboConnection.ItemIndex;
end;

{---------------------------------------}
procedure TfrmConnDetails.FormCreate(Sender: TObject);
var
    list : TWideStrings;
    i : integer;
begin
    MainSession.Prefs.RestorePosition(Self);

    list := TWideStringList.Create();
    fillDefaultStringList('brand_profile_server_list', list);
    if (list.Count > 0) then begin
        cboServer.Clear();
        for i := 0 to list.Count - 1 do
            cboServer.Items.Add(list[i]);
    end;
    fillDefaultStringList('brand_profile_resource_list', list);
    if (list.Count > 0) then begin
        cboResource.Clear();
        for i := 0 to list.Count - 1 do
            cboResource.Items.Add(list[i]);
    end
    else begin
        cboResource.Items.Add(sResourceHome);
        cboResource.Items.Add(sResourceWork);
        cboResource.Items.Add('Exodus');
    end;
    list.Free();
end;

{---------------------------------------}
procedure TfrmConnDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmConnDetails.txtUsernameKeyPress(Sender: TObject;
  var Key: Char);
var
    u, h, r, jid: Widestring;
begin
    // alway allow people to fix mistakes :)
    if (Key = #8) then exit;

    // check to make sure JID is valid
    u := txtUsername.Text;
    h := cboServer.Text;
    r := cboResource.Text;

    if (Sender = txtUsername) then u := u + Key
    else if (Sender = cboServer) then h := h + Key
    else if (Sender = cboResource) then r := r + Key;

    jid := u + '@' + h + '/' + r;
    if (not isValidJid(jid)) then
        Key := #0;
end;

end.
