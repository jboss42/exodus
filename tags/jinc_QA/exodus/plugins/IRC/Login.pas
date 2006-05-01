unit Login;

interface

uses
    Exodus_TLB,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, buttonFrame;

type
  TfrmStartSession = class(TForm)
    Label1: TLabel;
    txtServer: TEdit;
    Label2: TLabel;
    txtPort: TEdit;
    Label3: TLabel;
    txtNickname: TEdit;
    Label4: TLabel;
    txtAlt: TEdit;
    frameButtons1: TframeButtons;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStartSession: TfrmStartSession;

implementation

{$R *.dfm}

end.
