unit DockContainer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dockable, ExtCtrls, ComCtrls, ToolWin, OleCtrls, SHDocVw, gnugettext;

type
  TfrmDockContainer = class(TfrmDockable)
    Panel1: TPanel;
    WebBrowser1: TWebBrowser;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDockContainer: TfrmDockContainer;

implementation

{$R *.dfm}
procedure TfrmDockContainer.FormCreate(Sender: TObject);
begin
  TP_GlobalIgnoreClassProperty(TWebBrowser,'StatusText');
  inherited;
end;

initialization
end.
