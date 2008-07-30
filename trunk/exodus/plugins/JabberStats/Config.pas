unit Config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, buttonFrame;

type
  TfrmConfig = class(TForm)
    Label1: TLabel;
    txtFilename: TEdit;
    frameButtons1: TframeButtons;
    btnBrowse: TButton;
    OpenDialog1: TOpenDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.dfm}

end.
