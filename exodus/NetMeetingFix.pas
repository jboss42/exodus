{
    Copyright 2001-2008, Estate of Peter Millard
	
	This file is part of Exodus.
	
	Exodus is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.
	
	Exodus is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with Exodus; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
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
