unit CustomPres;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, buttonFrame, StdCtrls;

type
  TfrmCustomPres = class(TForm)
    frameButtons1: TframeButtons;
    Label1: TLabel;
    cboType: TComboBox;
    Label2: TLabel;
    txtStatus: TEdit;
    Label3: TLabel;
    txtPriority: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCustomPres: TfrmCustomPres;

implementation

{$R *.dfm}

end.
