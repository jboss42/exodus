unit Login;
{
    Copyright 2001, Peter Millard

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
    Session,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, buttonFrame, ComCtrls, Menus, TntStdCtrls;

type
  TfrmLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cboServer: TTntComboBox;
    frameButtons1: TframeButtons;
    Label5: TLabel;
    cboProfiles: TTntComboBox;
    chkInvisible: TCheckBox;
    btnDetails: TButton;
    popProfiles: TPopupMenu;
    CreateNew1: TMenuItem;
    Delete1: TMenuItem;
    chkSavePasswd: TCheckBox;
    txtUsername: TTntEdit;
    txtPassword: TTntEdit;
    cboResource: TTntComboBox;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cboProfilesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
    procedure CreateNew1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

procedure ShowLogin;

resourcestring
    sProfileDefaultResource = 'Exodus';
    sProfileRemove = 'Remove this profile?';
    sProfileDefault = 'Default Profile';
    sProfileNew = 'Untitled Profile';
    sProfileCreate = 'New Profile';
    sProfileNamePrompt = 'Enter Profile Name';

    sResourceWork = 'Work';
    sResourceHome = 'Home';


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.DFM}

uses
    Jabber1,  Unicode, InputPassword, 
    ConnDetails, PrefController;

{---------------------------------------}
procedure ShowLogin;
var
    l: TfrmLogin;
    i: integer;
    p: TJabberProfile;
begin
    l := TfrmLogin.Create(Application);
    l.cboProfiles.Items.Assign(MainSession.Prefs.Profiles);
    i := MainSession.Prefs.getInt('profile_active');
    if (i < 0) then i := 0;
    l.cboProfiles.ItemIndex := i;
    l.cboProfilesChange(nil);

    frmExodus.PreModal(l);
    
    if l.ShowModal = mrOK then begin
        // Save the info on the profile and login
        i := l.cboProfiles.ItemIndex;
        p := TJabberProfile(MainSession.Prefs.Profiles.Objects[i]);

        // Update the profile
        p.Server := l.cboServer.Text;
        p.Username := l.txtUsername.Text;
        p.SavePasswd := l.chkSavePasswd.Checked;
        p.password := l.txtPassword.Text;
        p.resource := l.cboResource.Text;

        if (Trim(p.Resource) = '') then
            p.Resource := sProfileDefaultResource;

        MainSession.Prefs.setInt('profile_active', i);
        MainSession.Prefs.SaveProfiles();

        // Active this profile, and fire it UP!
        MainSession.ActivateProfile(i);
        MainSession.Invisible := l.chkInvisible.Checked;
        l.Close();
        frmExodus.DoConnect();
    end
    else
        l.Close();

    frmExodus.PostModal();
end;

{---------------------------------------}
procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmLogin.cboProfilesChange(Sender: TObject);
var
    i: integer;
    p: TJabberProfile;
begin
    // Display this profile..
    i := cboProfiles.ItemIndex;
    p := TJabberProfile(MainSession.Prefs.Profiles.Objects[i]);

    // populate the fields
    txtUsername.Text := p.Username;
    txtPassword.Text := p.Password;
    cboServer.Text := p.Server;
    cboResource.Text := p.Resource;
    chkSavePasswd.Checked := p.SavePasswd;
    chkInvisible.Checked := false;
end;

{---------------------------------------}
procedure TfrmLogin.FormCreate(Sender: TObject);
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
end;

{---------------------------------------}
procedure TfrmLogin.btnDetailsClick(Sender: TObject);
var
    i : integer;
    p : TJabberProfile;
begin
    i := cboProfiles.ItemIndex;
    p := TJabberProfile(MainSession.Prefs.Profiles.Objects[i]);
    ShowConnDetails(p);
end;

{---------------------------------------}
procedure TfrmLogin.CreateNew1Click(Sender: TObject);
var
    pname: WideString;
    i: integer;
begin
    // Create a new profile
    pname := sProfileNew;
    if InputQueryW(sProfileCreate, sProfileNamePrompt, pname) then begin
        MainSession.Prefs.CreateProfile(pname);
        cboProfiles.Items.Assign(MainSession.Prefs.Profiles);
        i := cboProfiles.Items.Indexof(pname);
        cboProfiles.ItemIndex := i;
        cboProfilesChange(Self);
        cboResource.Text := sProfileDefaultResource;
        txtUsername.SetFocus();
    end;
end;

{---------------------------------------}
procedure TfrmLogin.Delete1Click(Sender: TObject);
var
    i: integer;
    p: TJabberProfile;
begin
    // Delete this profile
    if (MessageDlg(sProfileRemove, mtConfirmation, [mbYes, mbNo], 0) = mrNo) then exit;

    i := cboProfiles.ItemIndex;
    p := TJabberProfile(MainSession.Prefs.Profiles.Objects[i]);
    MainSession.Prefs.RemoveProfile(p);
    MainSession.Prefs.setInt('profile_active', 0);

    // make sure we have at least a default profile
    if (MainSession.Prefs.Profiles.Count) <= 0 then begin
        MainSession.Prefs.CreateProfile(sProfileDefault)
    end;

    cboProfiles.Items.Assign(MainSession.Prefs.Profiles);
    cboProfiles.ItemIndex := MainSession.Prefs.getInt('profile_active');
    cboProfilesChange(nil);

end;

{---------------------------------------}
procedure TfrmLogin.Label5Click(Sender: TObject);
var
    cp: TPoint;
begin
    // show the popup
    GetCursorPos(cp);
    popProfiles.Popup(cp.x, cp.y);
end;

end.

