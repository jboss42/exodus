library IdleHooks;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
    Windows, Messages, SysUtils;

{$R *.res}


type
    THookRec = packed record
        InstanceCount: integer;
        KeyHook: HHOOK;
        MouseHook: HHOOK;
        LastTick: longint;
        end;
    PHookRec = ^THookRec;

var
    mapHandle: THandle;
    lpHookRec: PHookRec;

procedure CreateMemMap(dwAllocSize: DWORD);
begin
    // create a process wide memory mnapped variable
    mapHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE,
        0, dwAllocSize, 'ExodusHookMem');
    if (mapHandle = 0) then exit;
    // get a pointer to our record in the mem map
    lpHookRec := MapViewOfFile(mapHandle, FILE_MAP_WRITE, 0, 0, dwAllocSize);
    if (lpHookRec = nil) then exit;
end;

procedure RemoveMemMap();
begin
    // remove the memory mapped variable
    if (lpHookRec <> nil) then begin
        UnMapViewOfFile(lpHookRec);
        lpHookRec := nil;
        end;

    if (mapHandle > 0) then begin
        CloseHandle(mapHandle);
        mapHandle := 0;
        end;
end;

function getHookPointer: pointer; stdcall;
begin
    // return a pointer to our mapped variable
    Result := lpHookRec;
end;

function KeyHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
begin
    Result := 0;
    if (code = HC_ACTION) then begin
        if ((lParam and (1 shl 31)) <> 0) then
            lpHookRec^.LastTick := GetTickCount();
        end
    else if (Code < 0) then
        Result := CallNextHookEx(lpHookRec^.KeyHook, code, wParam, lParam);
end;

function MouseHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
begin
    Result := 0;
    if (code = HC_ACTION) then
        lpHookRec^.LastTick := GetTickCount()
    else if (Code < 0) then
        Result := CallNextHookEx(lpHookRec^.MouseHook, code, wParam, lParam);
end;

procedure InitHooks; stdcall;
begin
    // if ((lpHookRec <> nil) and (lpHookRec^.KeyHook = 0)) then begin
    if ((lpHookRec <> nil)) then begin

        // Unhook old hooks..
        try
            if (lpHookRec^.KeyHook <> 0) then
                UnHookWindowsHookEx(lpHookRec^.KeyHook);
        except
        end;

        try
            if (lpHookRec^.MouseHook <> 0) then
                UnHookWindowsHookEx(lpHookRec^.MouseHook);
        except
        end;

        // setup the hook and store it
        lpHookRec^.KeyHook := SetWindowsHookEx(WH_KEYBOARD, @KeyHook, hInstance, 0);
        lpHookRec^.MouseHook := SetWindowsHookEx(WH_MOUSE, @MouseHook, hInstance, 0);
        end;
end;

procedure StopHooks; stdcall;
begin
    if ((lpHookRec <> nil) and (lpHookRec^.KeyHook <> 0)) then begin
        if (lpHookRec^.InstanceCount <= 1) then begin
            UnHookWindowsHookEx(lpHookRec^.KeyHook);
            UnHookWindowsHookEx(lpHookRec^.MouseHook);
            lpHookRec^.KeyHook := 0;
            lpHookRec^.MouseHook := 0;
            end;
        end;
end;

procedure DllEntryPoint(dwReason: DWORD);
begin
    case dwReason of
    Dll_Process_Attach: begin
        mapHandle := 0;
        lpHookRec := nil;
        CreateMemMap(sizeOf(lpHookRec^));
        end;
    Dll_Process_Detach: begin
        RemoveMemMap();
        end;
    end;
end;

exports
    KeyHook name 'KeyHook',
    getHookPointer name 'GetHookPointer',
    InitHooks name 'InitHooks',
    StopHooks name 'StopHooks';

begin
    DLLProc := @DllEntryPoint;
    DllEntryPoint(Dll_Process_Attach);
end.


