unit fService;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TframeObjectActions = class(TFrame)
    pRegister: TPanel;
    lblRegister: TLabel;
    pSearch: TPanel;
    lblSearch: TLabel;
    pConf: TPanel;
    lblConf: TLabel;
    pnlTop: TPanel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
