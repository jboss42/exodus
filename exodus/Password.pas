unit Password;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, buttonFrame;

type
  TfrmPassword = class(TForm)
    Label1: TLabel;
    txtOldPassword: TEdit;
    frameButtons1: TframeButtons;
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
 
