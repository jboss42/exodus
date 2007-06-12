unit ExceptTracer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, buttonFrame;

type
  TfrmTracer = class(TForm)
    frameButtons1: TframeButtons;
    Panel1: TPanel;
    Memo1: TMemo;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTracer: TfrmTracer;

implementation

{$R *.dfm}

procedure TfrmTracer.frameButtons1btnOKClick(Sender: TObject);
begin
    Self.Close();
end;

procedure TfrmTracer.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

procedure TfrmTracer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

end.
