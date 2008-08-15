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


unit VistaAltFixUnit;

interface
uses
  ExtCtrls, Classes, Contnrs, AppEvnts;

type
  TVistaAltFix = class(TComponent)
  private
    FList: TObjectList;
    FApplicationEvents: TApplicationEvents;
    FRepaintAll: Boolean;
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    function VistaWithTheme: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property RepaintAll: Boolean read FRepaintAll write FRepaintAll default True;
  end;

procedure Register;

implementation
uses
  Forms, Windows, Messages, Buttons, ComCtrls, Controls, StdCtrls, Themes;

type
  TFormObj = class(TObject)
  private
    procedure WndProc(var Message: TMessage);
  public
    Form: TForm;
    OrgProc: TWndMethod;
    Used: Boolean;
    NeedRepaint: Boolean;
    RepaintAll: Boolean;
    constructor Create(aForm: TForm; aRepaintAll: Boolean);
    procedure DoRepaint;
  end;

procedure Register;
begin
  RegisterComponents('MEP', [TVistaAltFix]);
end;

{ TVistaAltFix }

procedure TVistaAltFix.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
var
  I: Integer;
  J: Integer;
  TestForm: TForm;
begin
  // Initialize
  for I := 0 to FList.Count - 1 do
    TFormObj(FList[i]).Used := False;

  // Check for new forms
  for I := 0 to Screen.FormCount - 1 do
  begin
    TestForm := Screen.Forms[i];
    for J := 0 to FList.Count - 1 do
    begin
      if TFormObj(FList[J]).Form = TestForm then
      begin
        TFormObj(FList[J]).Used := True;
        TestForm := nil;
        Break;
      end;
    end;
    if Assigned(TestForm) then
      FList.Add(TFormObj.Create(TestForm, RepaintAll));
  end;

  // Remove destroyed forms, repaint others if needed.
  for I := FList.Count - 1 downto 0 do
  begin
    if not TFormObj(FList[i]).Used then
      FList.Delete(i)
    else
      TFormObj(FList[i]).DoRepaint;
  end;
end;

constructor TVistaAltFix.Create(AOwner: TComponent);
begin
  inherited;
  FRepaintAll := True;
  if VistaWithTheme and not (csDesigning in ComponentState) then
  begin
    FList := TObjectList.Create;
    FApplicationEvents := TApplicationEvents.Create(nil);
    FApplicationEvents.OnIdle := ApplicationEventsIdle;
  end;
end;

destructor TVistaAltFix.Destroy;
begin
  FApplicationEvents.Free;
  FList.Free;
  inherited;
end;

function TVistaAltFix.VistaWithTheme: Boolean;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) and
     (OSVersionInfo.dwMajorVersion >= 6) and
     ThemeServices.ThemesEnabled then
    Result := True
  else
    Result := False;
end;

{ TFormObj }

constructor TFormObj.Create(aForm: TForm; aRepaintAll: Boolean);
begin
  inherited Create;
  Form := aForm;
  RepaintAll := aRepaintAll;
  Used := True;
  OrgProc := Form.WindowProc;
  Form.WindowProc := WndProc;
end;

procedure TFormObj.DoRepaint;
  procedure RepaintBtnControls(TheCtrl: TControl);
  // This method made by J Hamblin - Qtools Software.
  var
    i: integer;
  begin
    if not (TheCtrl is TWinControl) or (TheCtrl is TBitBtn) then
      exit;

    // repaint only controls of affected type
    if (TheCtrl is TButtonControl) or (TheCtrl is TStaticText) then
    begin
      TWinControl(TheCtrl).Repaint;
      exit; // TButtonControls, TStaticText do not contain controls so skip rest
    end;

    //

    for i := 0 to TWinControl(TheCtrl).ControlCount - 1 do
    begin
      // only paint controls on active tabsheet of page control
      if (TheCtrl is TTabSheet) and
          (TTabSheet(TheCtrl).PageIndex <> TTabSheet(TheCtrl).PageControl.ActivePageIndex) then
        continue;
      // recurse
      RepaintBtnControls(TWinControl(TheCtrl).Controls[i]);
    end;
  end;

  procedure DoRepaint(Ctrl: TControl);
  var
    i: integer;
  begin
    if (Ctrl is TWinControl) then
    begin
      TWinControl(Ctrl).Repaint;
      for i := 0 to TWinControl(Ctrl).ControlCount - 1 do
        DoRepaint(TWinControl(Ctrl).Controls[i]);
    end;
  end;

begin
  if NeedRepaint then
  begin
    NeedRepaint := False;
    if RepaintAll then
      DoRepaint(Form)
    else
      RepaintBtnControls(Form);
  end;
end;

procedure TFormObj.WndProc(var Message: TMessage);
begin
  OrgProc(Message);
  if (Message.Msg = WM_UPDATEUISTATE) then
    NeedRepaint := True;
end;

end.
