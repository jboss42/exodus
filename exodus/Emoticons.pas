unit Emoticons;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin;

type
  TfrmEmoticons = class(TForm)
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    ToolButton33: TToolButton;
    ToolButton34: TToolButton;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    ToolButton37: TToolButton;
    ToolButton38: TToolButton;
    ToolButton39: TToolButton;
    ToolButton40: TToolButton;
    ToolButton41: TToolButton;
    ToolButton42: TToolButton;
    ToolButton43: TToolButton;
    ToolButton44: TToolButton;
    ToolButton45: TToolButton;
    ToolButton46: TToolButton;
    ToolBar2: TToolBar;
    ToolButton27: TToolButton;
    ToolButton47: TToolButton;
    ToolButton48: TToolButton;
    ToolButton49: TToolButton;
    ToolButton50: TToolButton;
    ToolButton51: TToolButton;
    ToolButton52: TToolButton;
    ToolButton53: TToolButton;
    ToolButton54: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ToolBar1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    msn: boolean;
    imgIndex: integer;
  end;

var
  frmEmoticons: TfrmEmoticons;

implementation

{$R *.dfm}
uses
    Jabber1;

procedure TfrmEmoticons.ToolButton1Click(Sender: TObject);
var
    btn: TToolbutton;
begin
    // a button was clicked.
    if (Sender is TToolButton) then begin
        btn := TToolButton(Sender);
        msn := (Toolbar1.Buttons[btn.Index] = btn);
        imgIndex := btn.ImageIndex;
        ModalResult := mrOK;
        end
    else
        ModalResult := mrCancel;
end;

procedure TfrmEmoticons.FormDeactivate(Sender: TObject);
begin
    if Self.Visible then
        ModalResult := mrCancel;
end;

procedure TfrmEmoticons.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = Chr(27) then ModalResult := mrCancel;
end;

procedure TfrmEmoticons.ToolBar1Click(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

end.
