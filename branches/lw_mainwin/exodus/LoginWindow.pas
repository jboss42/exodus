unit LoginWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, StdCtrls, TntStdCtrls, ComCtrls, TntComCtrls, ExtCtrls;

type
  TfrmLoginWindow = class(TExForm)
    lblStatus: TTntLabel;
    lblConnect: TTntLabel;
    lstProfiles: TTntListView;
    pnlMetadata: TPanel;
    imgLogo: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ShowProfiles();
    
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
procedure TfrmLoginWindow.ShowProfiles;
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

procedure TfrmLoginWindow.FormCreate(Sender: TObject);
begin
  inherited;

  ShowProfiles();
end;

end.
