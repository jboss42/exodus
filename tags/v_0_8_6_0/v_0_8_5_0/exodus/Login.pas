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
    StdCtrls, buttonFrame, ComCtrls, Menus, TntStdCtrls, ExtCtrls;

type
  TfrmLogin = class(TForm)
    Label5: TLabel;
    cboProfiles: TTntComboBox;
    chkInvisible: TCheckBox;
    btnDetails: TButton;
    popProfiles: TPopupMenu;
    CreateNew1: TMenuItem;
    Delete1: TMenuItem;
    lblJID: TTntLabel;
    frameButtons1: TframeButtons;

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

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.DFM}

uses
    ExUtils, GnuGetText, Jabber1,  JabberID, Unicode, InputPassword, 
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
    if (i >= l.cboProfiles.Items.Count) then i := l.cboProfiles.Items.Count - 1;
    l.cboProfiles.ItemIndex := i;
    l.cboProfilesChange(nil);

    frmExodus.PreModal(l);

    if l.ShowModal = mrOK then begin
        // Save the info on the profile and login
        i := l.cboProfiles.ItemIndex;
        p := TJabberProfile(MainSession.Prefs.Profiles.Objects[i]);

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
    p: TJabberProfile;
begin
    chkInvisible.Checked := false;
    p := TJabberProfile(MainSession.Prefs.Profiles.Objects[cboProfiles.ItemIndex]);
    lblJID.Caption := p.Username + '@' + p.Server + '/' + p.Resource;
end;

{---------------------------------------}
procedure TfrmLogin.FormCreate(Sender: TObject);
begin
    TranslateProperties(Self);
    MainSession.Prefs.RestorePosition(Self);
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
    lblJID.Caption := p.Username + '@' + p.Server + '/' + p.Resource;
end;

{---------------------------------------}
procedure TfrmLogin.CreateNew1Click(Sender: TObject);
var
    pname: WideString;
    i: integer;
    p : TJabberProfile;
begin
    // Create a new profile
    pname := sProfileNew;
    if InputQueryW(sProfileCreate, sProfileNamePrompt, pname) then begin
        p := MainSession.Prefs.CreateProfile(pname);
        cboProfiles.Items.Assign(MainSession.Prefs.Profiles);
        i := cboProfiles.Items.Indexof(pname);
        cboProfiles.ItemIndex := i;
        cboProfilesChange(Self);
        p.Resource := sProfileDefaultResource;
        ShowConnDetails(p);
        lblJID.Caption := p.Username + '@' + p.Server + '/' + p.Resource;
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

