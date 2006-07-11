unit DockContainer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dockable, ExtCtrls;

type
  TfrmDockContainer = class(TfrmDockable)
    Panel1: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDockContainer: TfrmDockContainer;

implementation

{$R *.dfm}

end.
