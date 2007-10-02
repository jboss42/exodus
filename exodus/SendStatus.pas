unit SendStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TfSendStatus = class(TFrame)
    Panel1: TPanel;
    btnCancel: TButton;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    Panel3: TPanel;
    lblFile: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
