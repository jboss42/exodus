unit jud;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dockable, StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmJUD = class(TfrmDockable)
    pnlLeft: TPanel;
    Button1: TButton;
    Button2: TButton;
    lstContacts: TListView;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmJUD: TfrmJUD;

implementation

{$R *.dfm}

end.
