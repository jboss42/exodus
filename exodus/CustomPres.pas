unit CustomPres;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, buttonFrame, StdCtrls, ComCtrls;

type
  TfrmCustomPres = class(TForm)
    frameButtons1: TframeButtons;
    Label1: TLabel;
    cboType: TComboBox;
    Label2: TLabel;
    txtStatus: TEdit;
    Label3: TLabel;
    txtPriority: TEdit;
    chkSave: TCheckBox;
    boxSave: TGroupBox;
    lblTitle: TLabel;
    txtTitle: TEdit;
    lblHotkey: TLabel;
    txtHotkey: THotKey;
    procedure FormCreate(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure chkSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCustomPres: TfrmCustomPres;

procedure ShowCustomPresence();

implementation

{$R *.dfm}

uses
    Session, Presence;

procedure ShowCustomPresence();
var
    f: TfrmCustomPres;
begin
    // show a new custom presence dialog box
    f := TfrmCustomPres.Create(nil);
    f.ShowModal;
end;

procedure TfrmCustomPres.FormCreate(Sender: TObject);
var
    i: integer;
begin
    // Default to the current settings
    if (MainSession.Show = 'chat') then i := 0
    else if (MainSession.Show = 'away') then i := 2
    else if (MainSession.show = 'xa') then i := 3
    else if (MainSession.Show = 'dnd') then i := 4
    else i := 1;

    cboType.ItemIndex := i;
    txtStatus.Text := MainSession.Status;
    txtPriority.Text := IntToStr(MainSession.Priority);
    chkSave.Checked := false;
end;

procedure TfrmCustomPres.frameButtons1btnOKClick(Sender: TObject);
var
    plist: TStringlist;
    show, status: string;
    i, pri: integer;
begin
    // todo: save custom presence
    if (chkSave.Checked) then begin
        plist := MainSession.Prefs.getStringlist('custom_pres');
        i := plist.indexOf(txtTitle.Text);

        if (i >= 0) then begin
            // it already exists
            end;


        end;

    // apply the new presence to the session
    case cboType.ItemIndex of
    0: show := 'chat';
    1: show := '';
    2: show := 'away';
    3: show := 'xa';
    4: show := 'dnd';
    end;

    status := txtStatus.Text;
    pri := StrToInt(txtPriority.Text);

    MainSession.setPresence(show, status, pri);

    Self.Close;
end;

procedure TfrmCustomPres.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmCustomPres.chkSaveClick(Sender: TObject);
var
    e: boolean;
begin
    e := chkSave.Checked;
    lblTitle.Enabled := e;
    txtTitle.Enabled := e;
    lblHotkey.Enabled := e;
    txtHotkey.Enabled := e;
end;

end.
