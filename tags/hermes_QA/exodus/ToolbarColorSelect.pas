unit ToolbarColorSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  BaseChat,
  Dialogs, StdCtrls, ExtCtrls, TntStdCtrls, Buttons, TntExtCtrls;

type
  TfrmToolbarColorSelect = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    pnlDefault: TTntPanel;

    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure pnlDefaultClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    _toolbar: TfrmBaseChat;
  public
    SelColor: TColor;
  end;

function getToolbarColorSelect(toolbar: TfrmBaseChat; dColor: TColor): TForm;

implementation
uses
    gnugettext;
var
  frmToolbarColorSelect: TfrmToolbarColorSelect;

function getToolbarColorSelect(toolbar: TfrmBaseChat; dColor: TColor): TForm;
begin
    if (frmToolbarColorSelect = nil) then begin
        frmToolbarColorSelect := TfrmToolbarColorSelect.Create(Application);
    end;
    frmToolbarColorSelect._toolbar := toolbar;
    frmToolbarColorSelect.pnlDefault.Font.Color := dColor;
    Result := frmToolbarColorSelect;
end;


{$R *.dfm}

procedure TfrmToolbarColorSelect.FormCreate(Sender: TObject);
begin
    //layout color pallet
    SelColor := panel1.Color;
    TranslateComponent(Self);
end;

procedure TfrmToolbarColorSelect.FormDeactivate(Sender: TObject);
begin
    if Self.Visible then
        Self.Hide();
end;

procedure TfrmToolbarColorSelect.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE: Self.Hide
  end;
end;

procedure TfrmToolbarColorSelect.Panel1Click(Sender: TObject);
begin
    SelColor := TPanel(Sender).Color;
    Self.Hide();
    _toolbar.OnColorSelect(SelColor);
end;

procedure TfrmToolbarColorSelect.pnlDefaultClick(Sender: TObject);
begin
    SelColor := TPanel(Sender).Font.Color;
    Self.Hide();
    _toolbar.OnColorSelect(SelColor);
end;

end.
