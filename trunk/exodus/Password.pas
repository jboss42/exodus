unit Password;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, buttonFrame;

type
  TfrmPassword = class(TForm)
    frameButtons1: TframeButtons;
    Label1: TLabel;
    txtOldPassword: TEdit;
    Label2: TLabel;
    txtNewPassword: TEdit;
    Label3: TLabel;
    txtConfirmPassword: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPassword: TfrmPassword;

implementation

{$R *.dfm}

end.
 
