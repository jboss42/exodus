
{*******************************************************}
{    The Delphi Unicode Controls Project                }
{                                                       }
{      http://home.ccci.org/wolbrink                    }
{                                                       }
{ Copyright (c) 2002, Troy Wolbrink (wolbrink@ccci.org) }
{                                                       }
{*******************************************************}

unit TntControls;

{
  Windows NT provides support for native Unicode windows.  To add Unicode support to a
    TWinControl descendant, override CreateWindowHandle() and call CreateUnicodeHandle().

  One major reason this works is because the VCL only uses the ANSI version of
    SendMessage() -- SendMessageA().  If you call SendMessageA() on a UNICODE
    window, Windows deals with the ANSI/UNICODE conversion automatically.  So
    for example, if the VCL sends WM_SETTEXT to a window using SendMessageA,
    Windows actually *expects* a PAnsiChar even if the target window is a UNICODE
    window.  So caling SendMessageA with PChars causes no problems.

  A problem in the VCL has to do with the TControl.Perform() method. Perform()
    calls the window procedure directly and assumes an ANSI window.  This is a
    problem if, for example, the VCL calls Perform(WM_SETTEXT, ...) passing in a
    PAnsiChar which eventually gets passed downto DefWindowProcW() which expects a PWideChar.

  This is the reason for SubClassUnicodeControl().  This procedure will subclass the
    Windows WndProc, and the TWinControl.WindowProc pointer.  It will determine if the
    message came from Windows or if the WindowProc was called directly.  It will then
    call SendMessageA() for Windows to perorm proper conversion on certain text messages.

  Another problem has to do with TWinControl.DoKeyPress().  It is called from the WM_CHAR
    message.  It casts the WideChar to an AnsiChar, and sends the resulting character to
    DefWindowProc.  In order to avoid this, the DefWindowProc is subclasses as well.  WindowProc
    will make a WM_CHAR message safe for ANSI handling code by converting the char code to
    #FF before passing it on.  It stores the original WideChar in the .Unused field of TWMChar.
    The code #FF is converted back to the WideChar before passing onto DefWindowProc.
}

interface

uses Windows, Messages, Classes, Controls, Forms, TntForms, TntClasses;

const
  UNICODE_CLASS_EXT = '.UnicodeClass';

function IsTextMessage(Msg: UINT): Boolean;
procedure MakeWMCharMsgSafeForAnsi(var Message: TMessage);
procedure RestoreWMCharMsg(var Message: TMessage);
function GetWideCharFromWMCharMsg(Message: TWMChar): WideChar;
procedure SetWideCharForWMCharMsg(var Message: TWMChar; Ch: WideChar);
function HandleIMEComposition(hWnd: THandle; Message: TMessage): Boolean;

procedure SubClassUnicodeControl(Control: TWinControl);
procedure CreateUnicodeHandle(Control: TWinControl; const Params: TCreateParams;
                                                                   const SubClass: WideString);

function WideGetWindowText(Control: TWinControl): WideString;
procedure WideSetWindowText(Control: TWinControl; const Text: WideString);

function TntAdjustLineBreaks(const S: WideString): WideString;
function GetParentTntForm(Control: TControl): TTntForm;

implementation

uses SysUtils, Graphics, Imm;

procedure DestroyUnicodeHandle(Control: TWinControl); forward;

function IsTextMessage(Msg: UINT): Boolean;
begin
  // WM_CHAR is omitted because of the special handling it receives
  result := (Msg = WM_SETTEXT)
         or (Msg = WM_GETTEXT)
         or (Msg = WM_GETTEXTLENGTH);
end;

const
  ANSI_UNICODE_HOLDER = $FF;

procedure MakeWMCharMsgSafeForAnsi(var Message: TMessage);
begin
  with TWMChar(Message) do begin
    Assert(Msg = WM_CHAR);
    Assert(Unused = 0);
    if (CharCode > Word(High(AnsiChar))) then begin
      Unused := CharCode;
      CharCode := ANSI_UNICODE_HOLDER;
    end;
  end;
end;

procedure RestoreWMCharMsg(var Message: TMessage);
begin
  with TWMChar(Message) do begin
    Assert(Message.Msg = WM_CHAR);
    if (Unused > 0)
    and (CharCode = ANSI_UNICODE_HOLDER) then
      CharCode := Unused;
    Unused := 0;
  end;
end;

function GetWideCharFromWMCharMsg(Message: TWMChar): WideChar;
begin
  if (Message.CharCode = ANSI_UNICODE_HOLDER)
  and (Message.Unused <> 0) then
    result := WideChar(Message.Unused)
  else
    result := WideChar(Message.CharCode);
end;

procedure SetWideCharForWMCharMsg(var Message: TWMChar; Ch: WideChar);
begin
  Message.CharCode := Word(Ch);
  Message.Unused := 0;
  MakeWMCharMsgSafeForAnsi(TMessage(Message));
end;

function HandleIMEComposition(hWnd: THandle; Message: TMessage): Boolean;
var
  IMC: HIMC;
  Buff: WideString;
  i: integer;
begin
  Result := False;
  if  (Win32Platform = VER_PLATFORM_WIN32_NT)
  and (Message.Msg = WM_IME_COMPOSITION)
  and ((Message.lParam and GCS_RESULTSTR) <> 0) then
  begin
    IMC := ImmGetContext(hWnd);
    if IMC <> 0 then begin
      try
        Result := True;
        // Get the result string
        SetLength(Buff, ImmGetCompositionStringW(IMC, GCS_RESULTSTR, nil, 0) div SizeOf(WideChar));
        ImmGetCompositionStringW(IMC, GCS_RESULTSTR, PWideChar(Buff), Length(Buff) * SizeOf(WideChar));
      finally
        ImmReleaseContext(hWnd, IMC);
      end;
      // send WM_CHAR messages for each char in string
      for i := 1 to Length(Buff) do begin
        SendMessageW(hWnd, WM_CHAR, Integer(Buff[i]), 0);
      end;
    end;
  end;
end;

//-----------------------------------------------------------------------------------
type
  TWinControlTrap = class
  private
    ObjectInstance: Pointer;
    DefObjectInstance: Pointer;
    FControl: TWinControl;
    Handle: THandle;
    PrevWin32Proc: Pointer;
    PrevDefWin32Proc: Pointer;
    PrevWindowProc: TWndMethod;
    LastWin32Msg: UINT;
    procedure Win32Proc(var Message: TMessage);
    procedure DefWin32Proc(var Message: TMessage);
    procedure WindowProc(var Message: TMessage);
    procedure HandleWMDestroy(var Message: TMessage);
  end;

procedure TWinControlTrap.HandleWMDestroy(var Message: TMessage);
var
  ThisPrevWin32Proc: Pointer;
  ThisHandle: THandle;
begin
  with Message do begin
    Assert(Msg = WM_DESTROY);
    // store local copies of values, since this object is about to be freed
    ThisPrevWin32Proc := PrevWin32Proc;
    ThisHandle := Handle;

    // handle destruction
    DestroyUnicodeHandle(FControl);

    // pass on the WM_DESTROY message
    Result := CallWindowProc(ThisPrevWin32Proc, ThisHandle, Msg, wParam, lParam);
  end;
end;

procedure TWinControlTrap.Win32Proc(var Message: TMessage);
begin
  with Message do begin
    if Msg = WM_DESTROY then begin
      HandleWMDestroy(Message);
      exit; { Do not access any data in object. Object is freed. }
    end;
    if not HandleIMEComposition(Handle, Message) then begin
      LastWin32Msg := Msg;
      Result := CallWindowProcW(PrevWin32Proc, Handle, Msg, wParam, lParam);
    end;
  end;
end;

procedure TWinControlTrap.DefWin32Proc(var Message: TMessage);
begin
  with Message do begin
    if (Msg = WM_CHAR) then begin
      RestoreWMCharMsg(Message)
    end;
    Result := CallWindowProcW(PrevDefWin32Proc, Handle, Msg, wParam, lParam);
  end;
end;

procedure TWinControlTrap.WindowProc(var Message: TMessage);
var
  CameFromWindows: Boolean;
begin
  CameFromWindows := LastWin32Msg <> WM_NULL;
  LastWin32Msg := WM_NULL;
  with Message do begin
    if (not CameFromWindows)
    and (IsTextMessage(Msg)) then
      Result := SendMessageA(Handle, Msg, wParam, lParam)
    else begin
      if (Msg = WM_CHAR) then begin
        MakeWMCharMsgSafeForAnsi(Message);
      end;
      PrevWindowProc(Message)
    end;
  end;
end;

{$IFDEF VER140}
function MakeObjectInstance(Method: TWndMethod): Pointer;
begin
  Result := Classes.MakeObjectInstance(Method);
end;
procedure FreeObjectInstance(ObjectInstance: Pointer);
begin
  Classes.FreeObjectInstance(ObjectInstance);
end;
{$ENDIF}

//----------------------------------------------------------------------------------
var
  WinControlTrap_Atom: TAtom = 0;

type TAccessWinControl = class(TWinControl);

procedure SubClassUnicodeControl(Control: TWinControl);
var
  WinControlTrap: TWinControlTrap;
begin
  if IsWindowUnicode(Control.Handle) then begin
    // create trap object, save reference
    WinControlTrap := TWinControlTrap.Create;
    SetProp(Control.Handle, MakeIntAtom(WinControlTrap_Atom), Cardinal(WinControlTrap));

    with WinControlTrap do begin
      // initialize trap object
      FControl := Control;
      Handle := Control.Handle;
      PrevWin32Proc := Pointer(GetWindowLong(Control.Handle, GWL_WNDPROC));
      PrevDefWin32Proc := TAccessWinControl(Control).DefWndProc;
      PrevWindowProc := Control.WindowProc;

      // subclass Window Procedures
      ObjectInstance := MakeObjectInstance(Win32Proc);
      SetWindowLongW(Control.Handle, GWL_WNDPROC, Integer(ObjectInstance));
      DefObjectInstance := MakeObjectInstance(DefWin32Proc);
      TAccessWinControl(Control).DefWndProc := DefObjectInstance;
      Control.WindowProc := WindowProc;
    end;
  end;
end;

procedure UnSubClassUnicodeControl(Control: TWinControl);
var
  WinControlTrap: TWinControlTrap;
begin
  if IsWindowUnicode(Control.Handle) then begin
    // get referenct to trap object
    WinControlTrap := TWinControlTrap(GetProp(Control.Handle, MakeIntAtom(WinControlTrap_Atom)));
    RemoveProp(Control.Handle, MakeIntAtom(WinControlTrap_Atom));

    with WinControlTrap do begin
      // restore window procs
      Control.WindowProc := PrevWindowProc;
      TAccessWinControl(Control).DefWndProc := PrevDefWin32Proc;
      SetWindowLongW(Control.Handle, GWL_WNDPROC, Integer(PrevWin32Proc));
      FreeObjectInstance(ObjectInstance);
      FreeObjectInstance(DefObjectInstance);

      // free trap object
      Free;
    end;
  end;
end;

//----------------------------------------------- CREATE/DESTROY UNICODE HANDLE
type
  TWideCaptionHolder = class(TComponent)
  private
    WideCaption: WideString;
  end;

function FindWideCaptionHolder(Control: TWinControl; Default: WideString = ''): TWideCaptionHolder;
var
  i: integer;
begin
  result := nil;
  for i := 0 to Control.ComponentCount - 1 do begin
    if (Control.Components[i] is TWideCaptionHolder) then begin
      result := TWideCaptionHolder(Control.Components[i]);
      exit; // found it!
    end;
  end;
  if result = nil then begin
    result := TWideCaptionHolder.Create(Control);
    result.WideCaption := Default;
  end;
end;

procedure CreateUnicodeHandle(Control: TWinControl; const Params: TCreateParams;
                                                                   const SubClass: WideString);
var
  WideSubClass: TWndClassW;
  WideWinClassName: WideString;
  WideClass: TWndClassW;
  TempClass: TWndClassW;
  Handle: THandle;
begin
  if Win32Platform <> VER_PLATFORM_WIN32_NT then begin
    with Params do
      TAccessWinControl(Control).WindowHandle := CreateWindowEx(ExStyle, WinClassName,
        Caption, Style, X, Y, Width, Height, WndParent, 0, WindowClass.hInstance, Param);
  end else begin
    // SubClass the unicode version of this control by getting the correct DefWndProc
    if SubClass <> '' then begin
      GetClassInfoW(hInstance, PWideChar(SubClass), WideSubClass);
      TAccessWinControl(Control).DefWndProc := WideSubClass.lpfnWndProc;
    end else
      TAccessWinControl(Control).DefWndProc := @DefWindowProcW;

    with Params do begin
      WideWinClassName := WinClassName + UNICODE_CLASS_EXT;
      if not GetClassInfoW(Params.WindowClass.hInstance, PWideChar(WideWinClassName), TempClass)
      then begin
        // Prepare a TWndClassW record
        WideClass := TWndClassW(WindowClass);
        if not Tnt_Is_IntResource(PWideChar(WindowClass.lpszMenuName)) then begin
          WideClass.lpszMenuName := PWideChar(WideString(WindowClass.lpszMenuName));
        end;
        WideClass.lpszClassName := PWideChar(WideWinClassName);

        // Register the UNICODE class
        if RegisterClassW(WideClass) = 0 then RaiseLastOSError;
      end;

      // Create UNICODE window
      Handle := CreateWindowExW(ExStyle, PWideChar(WideWinClassName), nil,
        Style, X, Y, Width, Height, WndParent, 0, WindowClass.hInstance, Param);

      // SetWindowLongW needs to be called because InitWndProc converts control to ANSI
      //  CallingSetWindowLongA(.., GWL_WNDPROC) makes Windows think it is an ANSI window
      //    But CallingSetWindowLongW(.., GWL_WNDPROC) make Windows think it is a UNICODE window.
      SetWindowLongW(Handle, GWL_WNDPROC, GetWindowLong(Handle, GWL_WNDPROC));

      // set handle for control
      TAccessWinControl(Control).WindowHandle := Handle;

      // sub-class
      SubClassUnicodeControl(Control);

      // For some reason, caption gets garbled after calling SetWindowLongW(.., GWL_WNDPROC).
      WideSetWindowText(Control, FindWideCaptionHolder(Control, Caption).WideCaption);
    end;
  end;
end;

procedure DestroyUnicodeHandle(Control: TWinControl);
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then begin
    // remember caption for future window creation
    if not (csDestroying in Control.ComponentState) then
      FindWideCaptionHolder(Control).WideCaption := WideGetWindowText(Control);
    // un sub-class
    UnSubClassUnicodeControl(Control);
  end;
end;

//----------------------------------------------- GET/SET WINDOW TEXT

function WideGetWindowText(Control: TWinControl): WideString;
begin
  if (not Control.HandleAllocated)
  or (not IsWindowUnicode(Control.Handle)) then begin
    // NO HANDLE -OR- NOT UNICODE
    result := TAccessWinControl(Control).Text;
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      result := FindWideCaptionHolder(Control, result).WideCaption
  end else begin
    // UNICODE & HANDLE
    SetLength(Result, GetWindowTextLengthW(Control.Handle) + 1);
    GetWindowTextW(Control.Handle, PWideChar(Result), Length(Result));
    SetLength(Result, Length(Result) - 1);
  end;
end;

procedure WideSetWindowText(Control: TWinControl; const Text: WideString);
begin
  if (not Control.HandleAllocated)
  or (not IsWindowUnicode(Control.Handle)) then begin
    // NO HANDLE -OR- NOT UNICODE
    TAccessWinControl(Control).Text := Text;
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      FindWideCaptionHolder(Control).WideCaption := Text;
  end else if WideGetWindowText(Control) <> Text then begin
    // UNICODE & HANDLE
    SetWindowTextW(Control.Handle, PWideChar(Text));
    Control.Perform(CM_TEXTCHANGED, 0, 0);
  end;
end;

function TntAdjustLineBreaks(const S: WideString): WideString;
var
  Source, SourceEnd, Dest: PWideChar;
  Extra: Integer;
begin
  Source := Pointer(S);
  SourceEnd := Source + Length(S);
  Extra := 0;
  while Source < SourceEnd do
  begin
    case Source^ of
      #10:
        Inc(Extra);
      #13:
        if Source[1] = #10 then Inc(Source) else Inc(Extra);
    end;
    Inc(Source);
  end;
  if Extra = 0 then Result := S else
  begin
    Source := Pointer(S);
    SetString(Result, nil, SourceEnd - Source + Extra);
    Dest := Pointer(Result);
    while Source < SourceEnd do
      case Source^ of
        #10:
          begin
            Dest^ := #13;
            Inc(Dest);
            Dest^ := #10;
            Inc(Dest);
            Inc(Source);
          end;
        #13:
          begin
            Dest^ := #13;
            Inc(Dest);
            Dest^ := #10;
            Inc(Dest);
            Inc(Source);
            if Source^ = #10 then Inc(Source);
          end;
      else
        Dest^ := Source^;
        Inc(Dest);
        Inc(Source);
      end;
  end;
end;

function GetParentTntForm(Control: TControl): TTntForm;
begin
  while Control.Parent <> nil do
    Control := Control.Parent;
  if Control is TTntForm then
    Result := TTntForm(Control)
  else
    Result := nil;
end;

var
  AtomText: array[0..127] of AnsiChar;

initialization
  WinControlTrap_Atom := GlobalAddAtom(StrFmt(AtomText, 'WinControlTrap.UnicodeClass.%d',
    [GetCurrentProcessID]));

finalization
  GlobalDeleteAtom(WinControlTrap_Atom);

end.
