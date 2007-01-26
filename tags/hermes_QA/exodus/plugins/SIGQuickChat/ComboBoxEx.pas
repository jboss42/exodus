unit ComboBoxEx;

interface

uses
  SysUtils, Windows, Classes, Messages, Controls, StdCtrls;

type
  TComboBoxEx = class(TComboBox)
  procedure Win32Proc(var Message: TMessage);

  private
    { Private declarations }
  procedure SubClassControl();
  function  GetAutoComplete: Boolean;
  procedure SetAutoComplete(value: Boolean);

  protected
    { Protected declarations }
  public
    { Public declarations }
  constructor Create(AOwner: TComponent);
  property EditHandle;
  property AutoComplete: Boolean read GetAutoComplete write SetAutoComplete;

  published
    { Published declarations }
  end;

procedure Register;
var
  ObjectInstance: Pointer;
  PrevWin32Proc: Pointer;
  PrevDefWin32Proc: Pointer;
  PrevWindowProc: TWndMethod;

implementation

Procedure Register;
begin
  RegisterComponents('Samples', [TComboBoxEx]);
end;

function  TComboBoxEx.GetAutoComplete: Boolean;
begin
  Result := inherited AutoComplete;
end;

procedure TComboBoxEx.SetAutoComplete(value: Boolean);
begin
  inherited AutoComplete := value;
end;

procedure TComboBoxEx.Win32Proc(var Message: TMessage);
begin
  with Message do begin
    CallWindowProcW(PrevWin32Proc, Handle, Msg, wParam, lParam);
  end;
end;

procedure TComboBoxEx.SubClassControl();
var
  Handle : HWnd;
begin
  Handle :=  self.EditHandle;;
  PrevWin32Proc := Pointer(GetWindowLongW(Handle, GWL_WNDPROC));

  ObjectInstance := MakeObjectInstance(Win32Proc);
  SetWindowLongW(Handle, GWL_WNDPROC, Integer(ObjectInstance));
end;

constructor TComboBoxEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//SubClassControl();
end;



end.

