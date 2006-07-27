{******************************************************************************}
{                                                                              }
{ Fixes the coexistence bug of a VCL application and NetMetting                }
{                                                                              }
{ Petr Vones (petr_v@post.cz)                                                  }
{                                                                              }
{******************************************************************************}

unit NetMeetingFix;

interface

implementation

uses
  Windows, SysUtils, Classes, Forms, AppEvnts;

type
  TAppSettingsChange = class(TApplicationEvents)
  private
    procedure ApplicationSettingChange(Sender: TObject; Flag: Integer;
      const Section: String; var Result: LongInt);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  AppSettingsChange: TAppSettingsChange;

{ TAppSettingsChange }

procedure TAppSettingsChange.ApplicationSettingChange(Sender: TObject;
  Flag: Integer; const Section: String; var Result: LongInt);
begin
  if (Flag = SPI_SETWORKAREA) and Assigned(Application.MainForm) then
    Application.MainForm.Monitor;
end;

constructor TAppSettingsChange.Create(AOwner: TComponent);
begin
  inherited;
  OnSettingChange := ApplicationSettingChange;
end;

initialization
  AppSettingsChange := TAppSettingsChange.Create(nil);

finalization
  FreeAndNil(AppSettingsChange);

end.
