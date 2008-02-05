unit LoginWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, StdCtrls, TntStdCtrls, ComCtrls, TntComCtrls, ExtCtrls,
  pngextra, XMLTag, pngimage, Menus, TntMenus, RichEdit2, ExRichEdit, Buttons,
  TntButtons, TntForms, ExGraphicButton;

const
    WM_SHOWLOGIN = WM_USER + 5273;

type
  TLoginGuiState = (lgsDisconnected, lgsConnecting, lgsConnected, lgsAuthenticated);
  TfrmLoginWindow = class(TTntForm)
    lblStatus: TTntLabel;
    lblConnect: TTntLabel;
    lstProfiles: TTntListView;
    popProfiles: TTntPopupMenu;
    mnuModifyProfile: TTntMenuItem;
    mnuDeleteProfile: TTntMenuItem;
    mnuRenameProfile: TTntMenuItem;
    pnlAnimate: TGridPanel;
    aniWait: TAnimate;
    pnlBottomInfo: TPanel;
    pnlInfomercial: TPanel;
    imgLogo: TImage;
    txtDisclaimer: TExRichEdit;
    pnlProfileActions: TPanel;
    btnNewUser: TExGraphicButton;
    btnCreateProfile: TExGraphicButton;

    procedure lstProfilesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure clickCreateProfile(Sender: TObject);
    procedure clickNewUser(Sender: TObject);
    procedure mnuModifyProfileClick(Sender: TObject);
    procedure mnuDeleteProfileClick(Sender: TObject);
    procedure mnuRenameProfileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblConnectClick(Sender: TObject);

  private
    { Private declarations }
    _sessionCB: Integer;

    procedure LoadProfiles();
    function LoadLogo(): Integer;
    function LoadDisclaimer(): Integer;

  protected
    { Protected declarations }

  public
    { Public declarations }
    procedure DockWindow(docksite : TWinControl);
    procedure DoLogin(idx: Integer);

    procedure ToggleGUI(state: TLoginGuiState);

  published
    { Published declarations }
    procedure SessionCallback(event: string; tag: TXMLTag);

  end;

function GetLoginWindow() : TfrmLoginWindow;

implementation

uses Jabber1, JabberUtils, ConnDetails, GnuGetText, InputPassword,
    PrefController, Profile, Session, NewUser;

const
    sRenameProfile = 'Rename profile';
    sRenameProfilePrompt = 'New profile name:';
    sProfileAlreadyExists = 'Profile %s already exists.';

    sGrpOffline = 'Offline';

    // Profile strings
    sProfileRemove = 'Remove this profile?';
    sProfileDefault = 'Default Profile';
    sProfileNew = 'Untitled Profile';
    sProfileCreate = 'New Profile';
    sProfileNamePrompt = 'Enter Profile Name';

    //Connection status strings
    sSignOn = 'Click a profile to connect';
    sCancelLogin = 'Click to Cancel...';
    sCancelReconnect = 'Click to Cancel Reconnect';

    sDisconnected = 'You are currently disconnected.';
    sConnecting = 'Trying to connect...';
    sAuthenticating = 'Connected. '#13#10'Authenticating...';
    sAuthenticated = 'Authenticated.'#13#10'Getting Contacts...';
    sReconnectIn = 'Reconnect in %d seconds.';

var
  frmLoginWindow: TfrmLoginWindow;

{$R *.dfm}

function GetLoginWindow() : TfrmLoginWindow;
begin
    if (frmLoginWindow = nil) then begin
        frmLoginWindow := TfrmLoginWindow.Create(Application);
    end;

    Result := frmLoginWindow;
end;


procedure TfrmLoginWindow.DockWindow(docksite: TWinControl);
begin
    if (docksite <> Self.Parent) then begin
        Self.ManualDock(docksite, nil, alClient);
        Application.ProcessMessages();
        Self.Align := alClient;
    end;
end;

procedure TfrmLoginWindow.LoadProfiles;
var
    c, i: integer;
    li: TTntListItem;
begin
    c := MainSession.Prefs.Profiles.Count;

    lstProfiles.Items.Clear();

    for i := 0 to c - 1 do begin
        li := lstProfiles.Items.Add();
        li.ImageIndex := 1;
        li.Caption := MainSession.Prefs.Profiles[i];
    end;

    lstProfiles.Visible := true;
end;
procedure TfrmLoginWindow.lstProfilesClick(Sender: TObject);
begin
    if (lstProfiles.ItemIndex >= 0) then
        // Item is actively selected OR we have a "last logged in"
        DoLogin(lstProfiles.ItemIndex)
    else if ((lstProfiles.Items.Count > 0) and
             (Sender <> lstProfiles)) then
        // Do NOT have an actively selected item OR a "last logged in"
        // Do NOT have a click on the "whitespace" of profile list
        // BUT we do have an item (at least default). So, try item 0
        DoLogin(0);  
end;

procedure TfrmLoginWindow.mnuDeleteProfileClick(Sender: TObject);
var
    i: integer;
    p: TJabberProfile;
begin
    // Delete this profile
    i := lstProfiles.ItemIndex;
    if (i < 0) then exit;

    if (MessageDlgW(_(sProfileRemove), mtConfirmation, [mbYes, mbNo], 0) = mrNo) then exit;

    p := TJabberProfile(MainSession.Prefs.Profiles.Objects[i]);
    MainSession.Prefs.RemoveProfile(p);
    MainSession.Prefs.setInt('profile_active', 0);

    // make sure we have at least a default profile
    if (MainSession.Prefs.Profiles.Count) <= 0 then begin
        MainSession.Prefs.CreateProfile(_(sProfileDefault))
    end;

    // save
    MainSession.Prefs.SaveProfiles();

    ToggleGUI(lgsDisconnected);
end;

procedure TfrmLoginWindow.mnuModifyProfileClick(Sender: TObject);
var
    res: integer;
    idx: integer;
    p: TJabberProfile;
    li: TTntListItem;
begin
    idx := lstProfiles.ItemIndex;
    if (idx < 0) then exit;

    p := TJabberProfile(MainSession.Prefs.Profiles.Objects[idx]);
    res := ShowConnDetails(p);
    if ((res = mrOK) or (res = mrYES)) then begin
        li := lstProfiles.Items[idx];
        li.Caption := p.Name;
        if (res = mrYES) then
            DoLogin(idx);
    end;
end;

procedure TfrmLoginWindow.mnuRenameProfileClick(Sender: TObject);
var
    go: TTntListItem;
    profile_exists: boolean;
    old_profile, new_profile, profile_exists_msg: WideString;
    i: integer;
    profile: TJabberProfile;
begin
    // Rename some profile.
    go := lstProfiles.Selected;
    if (go = nil) then exit;

    new_profile := go.Caption;
    if (InputQueryW(_(sRenameProfile), _(sRenameProfilePrompt), new_profile)) then begin
        old_profile := go.Caption;
        new_profile := Trim(new_profile);
        if (new_profile <> old_profile) then begin
            profile_exists := false;
            for i := 0 to lstProfiles.Items.Count - 1 do begin
                if (lstProfiles.Items[i].Caption = new_profile) then begin
                    profile_exists := true;
                end;
            end;

            if (profile_exists) then begin
                profile_exists_msg := _(sProfileAlreadyExists);
                profile_exists_msg := WideFormat(profile_exists_msg, [new_profile]);
                MessageDlgW(profile_exists_msg, mtConfirmation, [mbOK], 0);
                exit;
            end;

            profile := TJabberProfile(MainSession.Prefs.Profiles.Objects[lstProfiles.ItemIndex]);
            profile.Name := new_profile;
            MainSession.Prefs.SaveProfiles();
            MainSession.Prefs.LoadProfiles();
            ToggleGUI(lgsDisconnected);
        end;
    end;
end;

function TfrmLoginWindow.LoadDisclaimer(): Integer;
var
    tag: TXMLTag;
    restype : Widestring;
    resname : Widestring;
    ressrc  : Widestring;
    restxt  : Widestring;
    inst    : cardinal;
    Buffer  : array [0..16384] of char;
    valid   : Boolean;
begin
    Result := 0;
    valid := false;

    //Load tag info
    txtDisclaimer.WideText := '';
    tag := MainSession.Prefs.getXMLPref('brand_disclaimer_text');
    if (tag <> nil) then with tag do begin
        restype := GetAttribute('type');
        resname := GetAttribute('resname');
        ressrc  := GetAttribute('source');
        restxt  := tag.Data;

        try
            Result := StrToInt(GetAttribute('height'));
        except
            Result := 0;
        end;

        FreeAndNil(tag);
    end;

    with txtDisclaimer do begin
        try
            if (restype = 'dll') and (ressrc <> '') and (resname <> '') then begin
                inst := LoadLibraryW(PWChar(ressrc));
                if (inst = 0) then
                    inst := LoadLibraryA(PChar(String(ressrc)));
                if (inst > 0) then begin
                    LoadString(inst, StrToInt(resname), Buffer, sizeof(Buffer));
                    restxt := Buffer;
                    WideText := restxt;
                    valid := true;
                    FreeLibrary(inst);
                end;
            end
            else if (restype = 'file') and (ressrc <> '') then begin
                if FileExists(ressrc) then
                    ressrc := ressrc
                else if FileExists(ExtractFilePath(Application.ExeName) + ressrc) then
                    ressrc := ExtractFilePath(Application.ExeName) + ressrc;
                InsertFromFile(ressrc);
                valid := true;
            end
            else if (restype = 'text') and (restxt <> '') then begin
                InsertRTF(restxt);
                valid := true;
            end;
        except
            //Could not load text
            valid := false;
        end;

        if (valid) and (Result <> 0) then begin
            Visible := true;
            Height := Result;
        end
        else begin
            Visible := false;
            Height := 0;
            Result := 0;
        end;
    end;
end;
function TfrmLoginWindow.LoadLogo() : Integer;
var
    tag: TXMLTag;
    restype : Widestring;
    resname : Widestring;
    ressrc  : Widestring;
    inst    : cardinal;
begin
    Result := 0;
    restype := '';
    resname := '';
    ressrc  := '';

    //Load tag info
    tag := MainSession.Prefs.getXMLPref('brand_logo');
    if (tag <> nil) then with tag do begin
        restype := GetAttribute('type');
        resname := GetAttribute('resname');
        ressrc  := GetAttribute('source');

        try
            Result := StrToInt(GetAttribute('height'));
        except
            Result := 0;
        end;

        FreeAndNil(tag);
    end;

    with imgLogo do begin
        try
            if (restype = 'dll') and (ressrc <> '') and (resname <> '') then begin
                inst := LoadLibraryW(PWChar(ressrc));
                if (inst = 0) then
                    inst := LoadLibraryA(PChar(String(ressrc)));
                if (inst > 0) then begin
                    Picture.Bitmap.LoadFromResourceName(inst, resname);
                    FreeLibrary(inst);
                end;
            end
            else if (restype = 'file') and (ressrc <> '') then begin
                if FileExists(ressrc) then
                    Picture.LoadFromFile(ressrc)
                else
                    Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + ressrc);
            end;
        except
            //Could not load logo
        end;

        if Picture.Bitmap.HandleAllocated() then begin
            if (Result = 0) then
                Result := Picture.Bitmap.Height;
            imgLogo.Visible := true;
        end
        else begin
            imgLogo.Visible := false;
            Result := 0;
        end;
    end;
end;

procedure TfrmLoginWindow.FormCreate(Sender: TObject);
begin
    inherited;

    _sessionCB := MainSession.RegisterCallback(SessionCallback, '/session');

    aniWait.FileName := '';
    aniWait.ResName := 'Status';

    LoadProfiles();

    //Brand disclaimer and logo
    if LoadDisclaimer() <= 0 then LoadLogo();

    //Brand "new user wizard" button
    if not MainSession.Prefs.getBool('branding_roster_hide_new_wizard') then begin
        btnNewUser.Visible := true;
    end else begin
        btnNewUser.Visible := false;
    end;

    //Brand "create profile" button
    if not MainSession.Prefs.getBool('branding_roster_hide_create') then begin
        btnCreateProfile.Visible := true;
    end else begin
        btnCreateProfile.Visible := false;
    end;

    ToggleGUI(lgsDisconnected);
end;

procedure TfrmLoginWindow.clickCreateProfile(Sender: TObject);
var
    pname: Widestring;
    p: TJabberProfile;
    i: Integer;
begin
    // Create a new profile
    pname := _(sProfileNew);
    if InputQueryW(_(sProfileCreate), _(sProfileNamePrompt), pname) then begin
        p := MainSession.Prefs.CreateProfile(pname);
        p.Resource := resourceName;
        p.NewAccount := MainSession.Prefs.getBool('brand_profile_new_account_default');
        case (ShowConnDetails(p)) of
            mrCancel: Begin
                MainSession.Prefs.RemoveProfile(p);
                MainSession.Prefs.SaveProfiles();
                LoadProfiles();
            End;
            mrYes: Begin
                MainSession.Prefs.SaveProfiles();
                i := MainSession.Prefs.Profiles.IndexOfObject(p);
                assert(i >= 0);
                MainSession.ActivateProfile(i);
                LoadProfiles();
                //DoLogin(i);
            End;
            mrOK: Begin
                MainSession.Prefs.SaveProfiles();
                LoadProfiles();
            End;
        end;
    end;
end;
procedure TfrmLoginWindow.clickNewUser(Sender: TObject);
var
    pname: Widestring;
    p: TJabberProfile;
    i: integer;
begin
    // Run the new user wizard... first create a new profile
    pname := _(sProfileNew);
    if InputQueryW(_(sProfileCreate), _(sProfileNamePrompt), pname) then begin
        p := MainSession.Prefs.CreateProfile(pname);
        p.Resource := resourceName;
        p.NewAccount := MainSession.Prefs.getBool('brand_profile_new_account_default');
        MainSession.Prefs.SaveProfiles();
        LoadProfiles();
        i := MainSession.Prefs.Profiles.IndexOfObject(p);
        assert(i >= 0);
        MainSession.ActivateProfile(i);
        if (ShowNewUserWizard() = mrCancel) then begin
            // things didn't go so well.. cleanup
            frmExodus.CancelConnect();
            frmExodus.timReconnect.Enabled := false;
            ToggleGUI(lgsDisconnected);
            MainSession.Prefs.RemoveProfile(p);
            MainSession.Prefs.SaveProfiles();
            MainSession.ActivateDefaultProfile();
            LoadProfiles();
        end
        else
            // make sure we're showing the right UI
            ToggleGUI(lgsConnected);
    end;
end;

procedure TfrmLoginWindow.DoLogin(idx: Integer);
var
    p: TJabberProfile;
begin
    p := TJabberProfile(MainSession.Prefs.Profiles.Objects[idx]);

    if ((not p.SavePasswd) and (p.password <> '')) then begin
        p.password := '';
    end;

    if (Trim(p.Resource) = '') then
       p.Resource := resourceName;

    // do this for immediate feedback

    if (p.NewAccount) then
        MainSession.NoAuth := false;

    MainSession.Prefs.setInt('profile_active', idx);
    MainSession.Prefs.SaveProfiles();

    // Activate this profile, and fire it UP!
    MainSession.ActivateProfile(idx);

    // XXX: MainSession.Invisible := l.chkInvisible.Checked;
    frmExodus.DoConnect();
end;

procedure TfrmLoginWindow.FormShow(Sender: TObject);
var
    val: Integer;
begin
    //resize bottom panel now
    val := 0;

    with pnlInfomercial do begin
        val := val + Height + Margins.Bottom + Margins.Top + Padding.Bottom + Padding.Top;
    end;
    with pnlProfileActions do begin
        val := val + Height + Margins.Bottom + Margins.Top + Padding.Bottom + Padding.Top;
    end;

    pnlBottomInfo.Align := alNone;
    pnlBottomInfo.Height := val;
    pnlBottomInfo.Align := alBottom;
end;

procedure TfrmLoginWindow.lblConnectClick(Sender: TObject);
begin
    if (Sender = lblConnect) then begin
        if (lblConnect.Caption = _(sCancelLogin)) then begin
            // Cancel the connection
            frmExodus.CancelConnect();
        end
        else if (lblConnect.Caption = _(sCancelReconnect)) then begin
            // cancel reconnect
            frmExodus.timReconnect.Enabled := false;
            ToggleGUI(lgsDisconnected);
        end;
    end
    else if (lstProfiles.ItemIndex >= 0) then
        // Item is actively selected OR we have a "last logged in"
        DoLogin(lstProfiles.ItemIndex)
    else if ((lstProfiles.Items.Count > 0) and
             (Sender <> lstProfiles)) then
        // Do NOT have an actively selected item OR a "last logged in"
        // Do NOT have a click on the "whitespace" of profile list
        // BUT we do have an item (at least default). So, try item 0
        DoLogin(0);
end;

procedure TfrmLoginWindow.ToggleGUI(state: TLoginGuiState);
begin
    case state of
        lgsDisconnected: begin
            aniWait.Active := false;
            pnlAnimate.Visible := false;
            lblConnect.Caption := _(sSignOn);
            lblConnect.Cursor := crDefault;
            lblStatus.Caption := _(sDisconnected);
            pnlProfileActions.Visible := true;
            lstProfiles.Visible := true;
            LoadProfiles();
        end;
        lgsConnecting: begin
            aniWait.Active := true;
            pnlAnimate.Visible := true;
            lblConnect.Caption := _(sCancelLogin);
            lblConnect.Cursor := crHandPoint;
            lblStatus.Caption := _(sConnecting);
            lstProfiles.Visible := false;
            pnlProfileActions.Visible := false;
        end;
        lgsConnected: begin
            aniWait.Active := true;
            lblConnect.Caption := _(sCancelLogin);
            lblConnect.Cursor := crHandPoint;
            lblStatus.Caption := _(sAuthenticating);
            lstProfiles.Visible := false;
        end;
        lgsAuthenticated: begin
            //Let's not waste animation cycles on hidden things...
            aniWait.Active := false;
            lblConnect.Cursor := crDefault;
        end
        else begin

        end;
    end;

    Self.Invalidate();
end;
procedure TfrmLoginWindow.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/disconnected') then begin
        ToggleGUI(lgsDisconnected);
    end
    else if (event = '/session/connecting') then begin
        ToggleGUI(lgsConnecting);
    end
    else if (event = '/session/connected') then begin
        ToggleGUI(lgsConnected);
    end
    else if (event = '/session/authenticated') then begin
        ToggleGUI(lgsAuthenticated);
    end;
end;

end.
