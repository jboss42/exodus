
{*******************************************************}
{    The Delphi Unicode Controls Project                }
{                                                       }
{      http://home.ccci.org/wolbrink                    }
{                                                       }
{ Copyright (c) 2002, Troy Wolbrink (wolbrink@ccci.org) }
{                                                       }
{*******************************************************}

unit TntClasses;

{ If you want to use JCLUnicode that comes with Jedi Component Library,
    define JCL as a "Conditional Define" in the project options. }

interface

{$IFDEF VER140}
{$WARN SYMBOL_PLATFORM OFF} { We are going to use Win32 specific symbols! }
{$ENDIF}

uses Classes, SysUtils, Windows, ActiveX, {$IFDEF JCL} JclUnicode {$ELSE} Unicode {$ENDIF};

{$IFDEF JCL}
procedure JCL_WideStrings_Put(Strings: TWideStrings; Index: Integer; const S: WideString);
procedure JCL_WideStrings_PutObject(Strings: TWideStrings; Index: Integer; AObject: TObject);
{$ENDIF}

// Tnt-System
function WidePos(const Substr, S: Widestring): Integer;
{TNT-WARN Pos}
{TNT-WARN AnsiPos}


// Tnt-Windows
function Tnt_CreateFileW(lpFileName: PWideChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
    hTemplateFile: THandle): THandle;
function Tnt_Is_IntResource(ResStr: LPCWSTR): Boolean;
function Tnt_FindResourceW(hModule: HMODULE; lpName, lpType: PWideChar): HRSRC;
function Tnt_FindFirstFileW(lpFileName: PWideChar; var lpFindFileData: TWIN32FindDataW): THandle;
function Tnt_FindNextFileW(hFindFile: THandle; var lpFindFileData: TWIN32FindDataW): BOOL;

// Tnt-SysUtils
{$IFDEF VER130}
procedure RaiseLastOSError;
{$ENDIF}
function WideFileCreate(const FileName: WideString): Integer;
{TNT-WARN FileCreate}
function WideFileOpen(const FileName: WideString; Mode: LongWord): Integer;
{TNT-WARN FileOpen}

// FindFile - warning on TSearchRec is all that is necessary.
type
  TSearchRecW = record
    Time: Integer;
    Size: Integer;
    Attr: Integer;
    Name: WideString;
    ExcludeAttr: Integer;
    FindHandle: THandle;
    FindData: TWin32FindDataW;
  end;
{TNT-WARN TSearchRec}
function WideFindFirst(const Path: WideString; Attr: Integer; var F: TSearchRecW): Integer;
function WideFindNext(var F: TSearchRecW): Integer;
procedure WideFindClose(var F: TSearchRecW);

function WideDirectoryExists(const Name: WideString): Boolean;
{TNT-WARN DirectoryExists}
function WideFileExists(const Name: WideString): Boolean;
{TNT-WARN FileExists}
function WideFileGetAttr(const FileName: WideString): Cardinal;
{TNT-WARN FileGetAttr}
function WideFileSetAttr(const FileName: WideString; Attr: Integer): Boolean;
{TNT-WARN FileSetAttr}


type
{TNT-WARN TFileStream}
  TTntFileStream = class(THandleStream)
  public
    constructor Create(const FileName: WideString; Mode: Word);
    destructor Destroy; override;
  end;

{TNT-WARN TResourceStream}
  TTntResourceStream = class(TCustomMemoryStream)
  private
    HResInfo: HRSRC;
    HGlobal: THandle;
    procedure Initialize(Instance: THandle; Name, ResType: PWideChar);
  public
    constructor Create(Instance: THandle; const ResName: WideString; ResType: PWideChar);
    constructor CreateFromID(Instance: THandle; ResID: Word; ResType: PWideChar);
    destructor Destroy; override;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

implementation

uses Consts, {$IFDEF VER140} RTLConsts, {$ENDIF} TypInfo;

{$IFDEF JCL}
type
  TAccessWideStrings = class(TWideStrings);

procedure JCL_WideStrings_Put(Strings: TWideStrings; Index: Integer; const S: WideString);
var
  TempObject: TObject;
begin
  with TAccessWideStrings(Strings) do begin
    TempObject := GetObject(Index);
    Delete(Index);
    InsertObject(Index, S, TempObject);
  end;
end;

procedure JCL_WideStrings_PutObject(Strings: TWideStrings; Index: Integer; AObject: TObject);
begin
end;
{$ENDIF}

function WidePos(const Substr, S: Widestring): Integer;
begin
  result := Pos{TNT-ALLOW Pos}(SubStr, S);
end;

function Tnt_CreateFileW(lpFileName: PWideChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
    hTemplateFile: THandle): THandle;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := CreateFileW(lpFileName, dwDesiredAccess, dwShareMode,
      lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile)
  else
    Result := CreateFileA(PAnsiChar(AnsiString(lpFileName)), dwDesiredAccess, dwShareMode,
      lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile)
end;

function Tnt_Is_IntResource(ResStr: LPCWSTR): Boolean;
begin
  result := HiWord(Cardinal(ResStr)) = 0;
end;

function Tnt_FindResourceW(hModule: HMODULE; lpName, lpType: PWideChar): HRSRC;
var
  Ansi_Name, Ansi_Type: PAnsiChar;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := FindResourceW(hModule, lpName, lpType)
  else begin
    // Thunk Name
    if Tnt_Is_IntResource(lpName) then
      Ansi_Name := PAnsiChar(lpName)
    else
      Ansi_Name := PAnsiChar(AnsiString(lpName));
    // Thunk Type
    if Tnt_Is_IntResource(lpType) then
      Ansi_Type := PAnsiChar(lpType)
    else
      Ansi_Type := PAnsiChar(AnsiString(lpType));
    // Ansi version
    Result := FindResourceA(hModule, Ansi_Name, Ansi_Type);
  end;
end;

procedure GetWin32FindDataW(var WideFindData: TWIN32FindDataW; AnsiFindData: TWIN32FindDataA);
begin
  CopyMemory(@WideFindData, @AnsiFindData,
    Integer(@WideFindData.cFileName) - Integer(@WideFindData));
  StrPCopyW(WideFindData.cFileName, AnsiFindData.cFileName);
  StrPCopyW(WideFindData.cAlternateFileName, AnsiFindData.cAlternateFileName);
end;

function Tnt_FindFirstFileW(lpFileName: PWideChar; var lpFindFileData: TWIN32FindDataW): THandle;
var
  Ansi_lpFindFileData: TWIN32FindDataA;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    result := FindFirstFileW(lpFileName, lpFindFileData)
  else begin
    result := FindFirstFileA(PAnsiChar(AnsiString(lpFileName)), Ansi_lpFindFileData);
    if result <> INVALID_HANDLE_VALUE then
      GetWin32FindDataW(lpFindFileData, Ansi_lpFindFileData);
  end;
end;

function Tnt_FindNextFileW(hFindFile: THandle; var lpFindFileData: TWIN32FindDataW): BOOL;
var
  Ansi_lpFindFileData: TWIN32FindDataA;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    result := FindNextFileW(hFindFile, lpFindFileData)
  else begin
    result := FindNextFileA(hFindFile, Ansi_lpFindFileData);
    if result then
      GetWin32FindDataW(lpFindFileData, Ansi_lpFindFileData);
  end;
end;

{$IFDEF VER130}
procedure RaiseLastOSError;
begin
  RaiseLastWin32Error;
end;
{$ENDIF}

function WideFileCreate(const FileName: WideString): Integer;
begin
  Result := Integer(Tnt_CreateFileW(PWideChar(FileName), GENERIC_READ or GENERIC_WRITE,
    0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0))
end;

function WideFileOpen(const FileName: WideString; Mode: LongWord): Integer;
const
  AccessMode: array[0..2] of LongWord = (
    GENERIC_READ,
    GENERIC_WRITE,
    GENERIC_READ or GENERIC_WRITE);
  ShareMode: array[0..4] of LongWord = (
    0,
    0,
    FILE_SHARE_READ,
    FILE_SHARE_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE);
begin
  Result := Integer(Tnt_CreateFileW(PWideChar(FileName), AccessMode[Mode and 3],
    ShareMode[(Mode and $F0) shr 4], nil, OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL, 0));
end;

function WideFindMatchingFile(var F: TSearchRecW): Integer;
var
  LocalFileTime: TFileTime;
begin
  with F do
  begin
    while FindData.dwFileAttributes and ExcludeAttr <> 0 do
      if not Tnt_FindNextFileW(FindHandle, FindData) then
      begin
        Result := GetLastError;
        Exit;
      end;
    FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi, LongRec(Time).Lo);
    Size := FindData.nFileSizeLow;
    Attr := FindData.dwFileAttributes;
    Name := FindData.cFileName;
  end;
  Result := 0;
end;

function WideFindFirst(const Path: WideString; Attr: Integer; var F: TSearchRecW): Integer;
const
  faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;
begin
  F.ExcludeAttr := not Attr and faSpecial;
  F.FindHandle := Tnt_FindFirstFileW(PWideChar(Path), F.FindData);
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := WideFindMatchingFile(F);
    if Result <> 0 then WideFindClose(F);
  end else
    Result := GetLastError;
end;

function WideFindNext(var F: TSearchRecW): Integer;
begin
  if Tnt_FindNextFileW(F.FindHandle, F.FindData) then
    Result := WideFindMatchingFile(F) else
    Result := GetLastError;
end;

procedure WideFindClose(var F: TSearchRecW);
begin
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(F.FindHandle);
    F.FindHandle := INVALID_HANDLE_VALUE;
  end;
end;

function WideDirectoryExists(const Name: WideString): Boolean;
var
  Code: Cardinal;
begin
  Code := WideFileGetAttr(Name);
  Result := (Integer(Code) <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function WideFileExists(const Name: WideString): Boolean;
var
  Code: Cardinal;
begin
  Code := WideFileGetAttr(Name);
  Result := (Integer(Code) <> -1) and ((FILE_ATTRIBUTE_DIRECTORY and Code) = 0);
end;

function WideFileGetAttr(const FileName: WideString): Cardinal;
begin
  if Win32Platform <> VER_PLATFORM_WIN32_NT	then
    Result := GetFileAttributesA(PAnsiChar(AnsiString(FileName)))
  else
    Result := GetFileAttributesW(PWideChar(FileName));
end;

function WideFileSetAttr(const FileName: WideString; Attr: Integer): Boolean;
begin
  if Win32Platform <> VER_PLATFORM_WIN32_NT	then
    Result := SetFileAttributesA(PAnsiChar(AnsiString(FileName)), Attr)
  else
    Result := SetFileAttributesW(PWideChar(FileName), Attr);
end;

{ TTntFileStream }

constructor TTntFileStream.Create(const FileName: WideString; Mode: Word);
var
  CreateHandle: Integer;
begin
  if Mode = fmCreate then
  begin
    CreateHandle := WideFileCreate(FileName);
    if CreateHandle < 0 then
      raise EFCreateError.CreateResFmt(PResStringRec(@SFCreateError), [FileName]);
  end else
  begin
    CreateHandle := WideFileOpen(FileName, Mode);
    if CreateHandle < 0 then
      raise EFOpenError.CreateResFmt(PResStringRec(@SFOpenError), [FileName]);
  end;
  inherited Create(CreateHandle);
end;

destructor TTntFileStream.Destroy;
begin
  if Handle >= 0 then FileClose(Handle);
end;

{ TTntResourceStream }

constructor TTntResourceStream.Create(Instance: THandle; const ResName: WideString;
  ResType: PWideChar);
begin
  inherited Create;
  Initialize(Instance, PWideChar(ResName), ResType);
end;

constructor TTntResourceStream.CreateFromID(Instance: THandle; ResID: Word;
  ResType: PWideChar);
begin
  inherited Create;
  Initialize(Instance, PWideChar(ResID), ResType);
end;

procedure TTntResourceStream.Initialize(Instance: THandle; Name, ResType: PWideChar);

  procedure Error;
  begin
    raise EResNotFound.CreateFmt(SResNotFound, [Name]);
  end;

begin
  HResInfo := Tnt_FindResourceW(Instance, Name, ResType);
  if HResInfo = 0 then Error;
  HGlobal := LoadResource(Instance, HResInfo);
  if HGlobal = 0 then Error;
  SetPointer(LockResource(HGlobal), SizeOfResource(Instance, HResInfo));
end;

destructor TTntResourceStream.Destroy;
begin
  UnlockResource(HGlobal);
  FreeResource(HGlobal);
  inherited Destroy;
end;

function TTntResourceStream.Write(const Buffer; Count: Longint): Longint;
begin
  raise EStreamError.CreateRes(PResStringRec(@SCantWriteResourceStreamError));
end;

end.
