unit Selector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmGateways = class(TForm)
    btnAdd: TButton;
    btnCancel: TButton;
    ListBox1: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGateways: TfrmGateways;

implementation

{$R *.dfm}

end.
