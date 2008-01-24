unit LoginWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, StdCtrls, TntStdCtrls, ComCtrls, TntComCtrls, ExtCtrls,
  pngextra, XMLTag, pngimage, ExImagedButton;

type
  TfrmLoginWindow = class(TExForm)
    lblStatus: TTntLabel;
    lblConnect: TTntLabel;
    lstProfiles: TTntListView;
    pnlLogoStuff: TPanel;
    imgLogo: TImage;
    pnlNewUser: TPanel;
    Image1: TImage;
    TntLabel1: TTntLabel;
    pnlCreateProfile: TPanel;
    Image2: TImage;
    TntLabel2: TTntLabel;
    ExImagedButton1: TExImagedButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadProfiles();
    function LoadLogo(): Integer;
    function LoadDisclaimer(): Integer;
    
  public
    { Public declarations }
    procedure DockWindow(docksite : TWinControl);
  end;

function GetLoginWindow() : TfrmLoginWindow;

var
  frmLoginWindow: TfrmLoginWindow;

implementation

uses Session;

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
end;
function TfrmLoginWindow.LoadDisclaimer(): Integer;
begin
    result := 0;
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
        end;
    end;
end;

procedure TfrmLoginWindow.FormCreate(Sender: TObject);
var
    metaHeight: integer;
begin
    inherited;

    LoadProfiles();

    metaHeight := 0;

    //Brand logo
    metaHeight := metaHeight + LoadLogo();

    //Brand "new user wizard" button
    if not MainSession.Prefs.getBool('branding_roster_hide_new_wizard') then begin
        pnlNewUser.Visible := true;
    end else begin
        pnlNewUser.Visible := false;
    end;

    //Brand "create profile" button
    if True then begin
        pnlCreateProfile.Visible := true;
    end else begin
        pnlCreateProfile.Visible := false;
    end;
end;

end.
