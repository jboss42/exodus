
{*******************************************************}
{    The Delphi Unicode Controls Project                }
{                                                       }
{      http://home.ccci.org/wolbrink                    }
{                                                       }
{ Copyright (c) 2002, Troy Wolbrink (wolbrink@ccci.org) }
{                                                       }
{*******************************************************}

unit TntForms;

interface
                           
{$IFDEF VER140}
{$WARN SYMBOL_PLATFORM OFF} { We are going to use Win32 specific symbols! }
{$ENDIF}

uses
  Classes, TntClasses, Windows, Messages, Controls, Forms;

{TNT-WARN TForm}
type
  TTntForm = class(TForm{TNT-ALLOW TForm})
  private
    function GetCaption: WideString;
    procedure SetCaption(const Value: WideString);
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
  public
    procedure DefaultHandler(var Message); override;
  published
    property Caption: WideString read GetCaption write SetCaption;
  end;

{TNT-WARN PeekMessage}
{TNT-WARN PeekMessageA}
{TNT-WARN PeekMessageW}
procedure EnableManualPeekMessageWithRemove;
procedure DisableManualPeekMessageWithRemove;

implementation

{$R *.DFM}

uses SysUtils, Consts, TntControls;

{$IFDEF VER130}
const
  WS_EX_LAYERED = $00080000;
{$ENDIF}

{ TTntForm }

procedure TTntForm.CreateWindowHandle(const Params: TCreateParams);
var
  NewParams: TCreateParams;
  WideWinClassName: WideString;
begin
  if Win32Platform <> VER_PLATFORM_WIN32_NT	then
    inherited
  else if (FormStyle = fsMDIChild) and not (csDesigning in ComponentState) then
  begin
    if (Application.MainForm = nil) or
      (Application.MainForm.ClientHandle = 0) then
        raise EInvalidOperation.Create(SNoMDIForm);
    WideWinClassName := Params.WinClassName + UNICODE_CLASS_EXT;
    DefWndProc := @DefMDIChildProcW;
    WindowHandle := CreateMDIWindowW(PWideChar(WideWinClassName),
      nil, Params.style, Params.X, Params.Y, Params.Width, Params.Height,
        Application.MainForm.ClientHandle, hInstance, Longint(Params.Param));
    if WindowHandle = 0 then
      RaiseLastOSError;
    SetWindowLongW(Handle, GWL_WNDPROC, GetWindowLong(Handle, GWL_WNDPROC));
    WideSetWindowText(Self, Params.Caption);
    SubClassUnicodeControl(Self);
    Include(FFormState, fsCreatedMDIChild);
  end else
  begin
    NewParams := Params;
    NewParams.ExStyle := NewParams.ExStyle and not WS_EX_LAYERED;
    CreateUnicodeHandle(Self, NewParams, '');
    Exclude(FFormState, fsCreatedMDIChild);
  end;
{$IFDEF VER140}
  if AlphaBlend then begin
    // toggle AlphaBlend to force update
    AlphaBlend := False;
    AlphaBlend := True;
  end;
{$ENDIF}
end;

procedure TTntForm.DefaultHandler(var Message);
begin
  if (ClientHandle <> 0)
  and (Win32Platform = VER_PLATFORM_WIN32_NT) then
    with TMessage(Message) do
      if Msg = WM_SIZE then
        Result := DefWindowProcW(Handle, Msg, wParam, lParam)
      else
        Result := DefFrameProcW(Handle, ClientHandle, Msg, wParam, lParam)
  else
    inherited DefaultHandler(Message)
end;

function TTntForm.GetCaption: WideString;
begin
  result := WideGetWindowText(Self)
end;

procedure TTntForm.SetCaption(const Value: WideString);
begin
  WideSetWindowText(Self, Value)
end;

//===========================================================================
//   The NT GetMessage Hook is needed to support entering Unicode
//     characters directly from the keyboard (bypassing the IME).
//   Special thanks go to Francisco Leong for developing this solution.
//
//  Example:
//    1. Install "Turkic" language support.
//    2. Add "Azeri (Latin)" as an input locale.
//    3. In an EDIT, enter Shift+I.  (You should see a capital "I" with dot.)
//    4. In an EDIT, enter single quote (US Keyboard).  (You should see an upturned "e".)
//
var
  NTGetMessageHook: HHOOK = 0;

function IsDlgMsg(var Msg: TMsg): Boolean;
begin
  result := (Application.DialogHandle <> 0)
        and (IsDialogMessage(Application.DialogHandle, Msg))
end;

var
  ManualPeekMessageWithRemove: Integer = 0;

function GetMessageForNT(Code: Integer; wParam: Integer; lParam: Integer): LRESULT; stdcall;
var
  ThisMsg: PMSG;
  Handled: Boolean;
begin
  if (Code >= 0)
  and (wParam = PM_REMOVE)
  and (ManualPeekMessageWithRemove = 0) then
  begin
    ThisMsg := PMSG(lParam);
    if (ThisMsg.message = WM_CHAR)
    and (ThisMsg.wParam > Integer(High(AnsiChar)))
    and IsWindowUnicode(ThisMsg.hwnd) then
    begin
      // more than 8-bit WM_CHAR destined for Unicode window
      Handled := False;
      if Assigned(Application.OnMessage) then
        Application.OnMessage(ThisMsg^, Handled);
      Application.CancelHint;
      // dispatch msg if not a dialog message
      if (not Handled) and (not IsDlgMsg(ThisMsg^)) then
        DispatchMessageW(ThisMsg^);
      // clear for further processing
      ThisMsg.message := WM_NULL;
    end;
  end;
  Result := CallNextHookEx(NTGetMessageHook, Code, wParam, lParam);
end;

procedure CreateMessageHookForNT;
begin
  Assert(Win32Platform = VER_PLATFORM_WIN32_NT);
  NTGetMessageHook := SetWindowsHookExW(WH_GETMESSAGE, GetMessageForNT, 0, GetCurrentThreadID);
  if NTGetMessageHook = 0 then
    RaiseLastOSError;
end;

procedure EnableManualPeekMessageWithRemove;
begin
  Inc(ManualPeekMessageWithRemove);
end;

procedure DisableManualPeekMessageWithRemove;
begin
  if (ManualPeekMessageWithRemove > 0) then
    Dec(ManualPeekMessageWithRemove);
end;

initialization
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    CreateMessageHookForNT;

finalization
  if NTGetMessageHook <> 0 then
    Win32Check(UnhookWindowsHookEx(NTGetMessageHook));

end.
