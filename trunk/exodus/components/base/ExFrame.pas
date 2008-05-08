unit ExFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms;

type
  TExFrame = class(TTntFrame)
  private
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
  public
  end;


implementation
{$R *.dfm}

uses
    ExForm;
procedure TExFrame.CreateWindowHandle(const Params: TCreateParams);
begin
    inherited;
    Self.Color := TExForm.GetDefaultWindowColor();
    TExForm.GetDefaultFont(Self.Font);
end;

end.
