unit fTopLabel;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TframeTopLabel = class(TFrame)
    Panel1: TPanel;
    lbl: TLabel;
    txtData: TEdit;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    field_name: string;
  end;

implementation

{$R *.dfm}

procedure TframeTopLabel.FrameResize(Sender: TObject);
begin
    // resize the text box..
    txtData.Width := Self.ClientWidth - 7;
end;

end.
