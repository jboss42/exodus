unit ComboBoxExSIG;
{
    Copyright © 2006 Susquehanna International Group, LLP.
    Author: Dave Siracusa
}

interface

uses
  SysUtils, Windows, Classes, Messages, Controls, StdCtrls, Graphics;

type
  TComboBoxExSIG = class(TComboBox)
  procedure EditWin32Proc(var Message: TMessage);

  private
    { Private declarations }
  ObjectInstance: Pointer;
  PrevWin32Proc: Pointer;
  PrevDefWin32Proc: Pointer;
  PrevWindowProc: TWndMethod;
  FCanvas: TControlCanvas;
  TheTag: String;
  procedure SubClassControl();

  procedure WTag(tag: String);
  function  RTag: string;

  protected
    { Protected declarations }
  public
    { Public declarations }
  procedure WndProc(var Message: TMessage); override;
  constructor Create(AOwner: TComponent); override;

  property Tag: String read RTag write WTag;
  property EditHandle: HWND read FEditHandle;

  published
    { Published declarations }
  end;

procedure Register;

implementation

Procedure Register;
begin
  RegisterComponents('SIG', [TComboBoxExSIG]);
end;

procedure TComboBoxExSIG.WTag(tag: String);
begin
  TheTag := tag;
  Self.Update;
end;

function  TComboBoxExSIG.RTag: string;
begin
   Result := TheTag;
end;

procedure TComboBoxExSIG.EditWin32Proc(var Message: TMessage);
var
  DC: HDC;
  PMessage: TWMPaint;
  PS: TPaintStruct;
  R: TRect;
begin
  with Message do
  begin
    case Msg of
      WM_PAINT:
        begin
          Result := CallWindowProcW(PrevWin32Proc, Handle, Msg, wParam, lParam);
          if (Self.Text<>'') OR (TheTag='') OR (Focused=true) then begin
            exit;
          end;

          if FCanvas = nil then
          begin
            FCanvas := TControlCanvas.Create;
            FCanvas.Control := Self;
          end;

          PMessage := TWMPaint(Message);
          DC := PMessage.DC;
          if DC = 0 then DC := BeginPaint(Handle, PS);
            FCanvas.Handle := DC;

          R := Rect(3, 3, ClientRect.Right, ClientRect.Bottom);
          FCanvas.Brush.Style := bsClear;
          FCanvas.Font.Color := clBtnShadow;
          DrawText(Canvas.Handle, PAnsiChar(TheTag), -1, R, DT_LEFT);

          if PMessage.DC = 0 then EndPaint(Handle, PS);
          Result := 1;
          exit;
        end;
    end;
    Result := CallWindowProcW(PrevWin32Proc, Handle, Msg, wParam, lParam);
  end;
end;

procedure TComboBoxExSIG.SubClassControl();
var
  EHandle : HWnd;
begin
  EHandle :=  EditHandle;
  if (EHandle <> HWnd(nil)) then begin
    PrevWin32Proc := Pointer(GetWindowLongW(EHandle, GWL_WNDPROC));
    SetWindowLongW(eHandle, GWL_WNDPROC, LongInt(ObjectInstance));
  end;
end;

procedure TComboBoxExSIG.WndProc(var Message: TMessage);
begin
  with Message do begin
    inherited;

    if (Msg = WM_ERASEBKGND) AND (PrevWin32Proc = nil) then begin
      SubClassControl;
    end;

  end;
end;

constructor TComboBoxExSIG.Create(AOwner: TComponent);
begin
  PrevWin32Proc := nil;
  FCanvas := nil;
  ObjectInstance := MakeObjectInstance(EditWin32Proc);
  inherited Create(AOwner);
end;



end.

