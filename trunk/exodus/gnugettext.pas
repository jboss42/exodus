unit gnugettext;
(**************************************************************)
(*                                                            *)
(*  (C) Copyright by Lars B. Dybdahl and others               *)
(*  E-mail: Lars@dybdahl.dk, phone +45 70201241               *)
(*  You may distribute and modify this file as you wish       *)
(*  for free                                                  *)
(*                                                            *)
(*  Contributors: Peter Thornqvist, Frank Andreas de Groot    *)
(*                                                            *)
(*  See http://dybdahl.dk/dxgettext/ for more information     *)
(*                                                            *)
(**************************************************************)

interface

uses
  Classes;

// These two identical functions translate a text.
// Please note that szMsgId may never contain non-ascii characters
function _(const szMsgId: widestring): widestring; 
function gettext(const szMsgId: widestring): widestring;

// Translate a component's properties and all subcomponents
// Use this on a Delphi TForm or a CLX program's QForm.
// It will only translate string properties.
procedure TranslateProperties(AnObject: TObject);

// Set language to use
procedure UseLanguage(LanguageCode: string);



// ****************** DEBUGGING and advanced functionality

const
  DefaultTextDomain = 'default';

(*
 Make sure that the next TranslateProperties(self) will ignore
 the string property specified, e.g.:
 TP_Ignore (self,'ButtonOK.Caption');   // Ignores caption on ButtonOK
 TP_Ignore (self,'MyDBGrid');           // Ignores all properties on component MyDBGrid
 TP_Ignore (self,'.Caption');           // Ignores self's caption
 Only use this function just before calling TranslateProperties(self).
 If this function is being used, please only call TP_Ignore and TranslateProperties
 From the main thread.
*)
procedure TP_Ignore(AnObject:TObject; const name:string);

// Save all untranslated texts, that are found during program run,
// in this file. This is for debugging only.
procedure SaveUntranslatedMsgids(filename: string);

// Load an external GNU gettext dll to be used instead of the internal
// implementation. Returns true if the dll is loaded. If the dll was already
// loaded, this function can be used to query whether it was loaded.
// On Linux, this function does nothing and always returns True.
function LoadDLLifPossible (dllname:string='gnu_gettext.dll'):boolean;

// These functions are also from the orginal GNU gettext implementation.
// Only use these, if you need to split up your translation into several
// .mo files.
function dgettext(const szDomain: string; const szMsgId: widestring): widestring;
procedure textdomain(const szDomain: string);
function getcurrenttextdomain: string;
procedure bindtextdomain(const szDomain: string; const szDirectory: string);




implementation

{$ifdef VER100}
  {$DEFINE DELPHI5OROLDER}
  {$DEFINE DELPHI6OROLDER}
{$endif}
{$ifdef VER110}
  {$DEFINE DELPHI5OROLDER}
  {$DEFINE DELPHI6OROLDER}
{$endif}
{$ifdef VER120}
  {$DEFINE DELPHI5OROLDER}
  {$DEFINE DELPHI6OROLDER}
{$endif}
{$ifdef VER130}
  {$DEFINE DELPHI5OROLDER}
  {$DEFINE DELPHI6OROLDER}
  {$ifdef WIN32}
  {$DEFINE MSWINDOWS}
  {$endif}
{$endif}
{$ifdef VER140}
{$ifdef MSWINDOWS}
  {$DEFINE DELPHI6OROLDER}
{$endif}
{$endif}
{$ifdef MSWINDOWS}
{$ifndef DELPHI6OROLDER}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$endif}
{$endif}

uses
  {$ifdef MSWINDOWS}Windows, {$endif}
  {$ifdef LINUX}Libc, {$endif}
  {$ifdef DELPHI5OROLDER}FileCtrl, gnugettextD5, {$endif}
  SysUtils, TypInfo;

type
  TRStrinfo = record
    strlength, stroffset: cardinal;
  end;
  TStrInfoArr = array[0..10000000] of TRStrinfo;
  PStrInfoArr = ^TStrInfoArr;
  tpgettext = function(const szMsgId: PChar): PChar; cdecl;
  tpdgettext = function(const szDomain: PChar; const szMsgId: PChar): PChar; cdecl;
  tpdcgettext = function(const szDomain: PChar; const szMsgId: PChar; iCategory: integer): PChar; cdecl;
  tptextdomain = function(const szDomain: PChar): PChar; cdecl;
  tpbindtextdomain = function(const szDomain: PChar; const szDirectory: PChar): PChar; cdecl;
  tpgettext_putenv = function(const envstring: PChar): integer; cdecl;

var
  DLLisLoaded: boolean;
  curlang: string;
  curmsgdomain: string = DefaultTextDomain;
  curresourcestringdomain: string = DefaultTextDomain;
  savefileCS: TMultiReadExclusiveWriteSynchronizer;
  savefile: TextFile;
  savememory: TStringList;
{$ifdef MSWINDOWS}
  domainlist: TStringList; // List of domain names. Objects are TDomain.
  pgettext: tpgettext;
  pdgettext: tpdgettext;
  ptextdomain: tptextdomain;
  pbindtextdomain: tpbindtextdomain;
  pgettext_putenv: tpgettext_putenv;

type
  TDomain = class
  private
    vDirectory: string;
    procedure setDirectory(dir: string);
  public
    Domain: string;
    property Directory: string read vDirectory write setDirectory;
    constructor Create;
    destructor Destroy; override;
    function gettext(msgid: ansistring): ansistring; // uses mo file
  private
    moCS: TMultiReadExclusiveWriteSynchronizer; // Covers next three lines
    doswap: boolean;
    N, O, T: Cardinal; // Values defined at http://www.linuxselfhelp.com/gnu/gettext/html_chapter/gettext_6.html
    mo: THandle;
    momapping: THandle;
    momemory: PChar;
    isopen, moexists: boolean;
    procedure OpenMoFile;
    procedure CloseMoFile;
    function gettextbyid(id: cardinal): ansistring;
    function getdsttextbyid(id: cardinal): ansistring;
    function autoswap32(i: cardinal): cardinal;
    function CardinalInMem(baseptr: PChar; Offset: Cardinal): Cardinal;
  end;

function getdomain(domain: string): TDomain;
// Retrieves the TDomain object for the specified domain.
// Creates one, if none there, yet.
var
  idx: integer;
begin
  idx := domainlist.IndexOf(Domain);
  if idx = -1 then begin
    Result := TDomain.Create;
    Result.Domain := Domain;
    Result.Directory := ExtractFilePath(paramstr(0));
    domainlist.AddObject(Domain, Result);
  end else begin
    Result := domainlist.Objects[idx] as TDomain;
  end;
end;
{$endif}

function IsWriteProp(Info: PPropInfo): Boolean;
begin
  Result := Assigned(Info) and (Info^.SetProc <> nil);
end;

procedure SaveUntranslatedMsgids(filename: string);
begin
  // If this happens, it is an internal error made by the programmer.
  if savememory <> nil then
    raise Exception.Create(_('You may not call SaveUntranslatedMsgids twice in this program.'));

  AssignFile(savefile, filename);
  Rewrite(savefile);
  writeln(savefile, 'msgid ""');
  writeln(savefile, 'msgstr ""');
  writeln(savefile);
  savememory := TStringList.Create;
  savememory.Sorted := true;
end;

function string2csyntax(s: string): string;
// Converts a string to the syntax that is used in .po files
var
  i: integer;
  c: char;
begin
  Result := '';
  for i := 1 to length(s) do begin
    c := s[i];
    case c of
      #32..#33, #35..#255: Result := Result + c;
      #13: Result := Result + '\r';
      #10: Result := Result + '\n"'#13#10'"';
      #34: Result := Result + '\"';
    else
      Result := Result + '\0x' + IntToHex(ord(c), 2);
    end;
  end;
  Result := '"' + Result + '"';
end;

procedure SaveCheck(szMsgId: string);
var
  i: integer;
begin
  { TODO -cgettext : Now only supports default domain, but should also support other domains. }
  savefileCS.BeginWrite;
  try
    if (savememory <> nil) and (szMsgId <> '') then begin
      if not savememory.Find(szMsgId, i) then begin
        savememory.Add(szMsgId);
        Writeln(savefile, 'msgid ' + string2csyntax(szMsgId));
        writeln(savefile, 'msgstr ""');
        writeln(savefile);
      end;
    end;
  finally
    savefileCS.EndWrite;
  end;
end;

function gettext(const szMsgId: widestring): widestring;
begin
  {$ifdef LINUX}
  Result := utf8decode(StrPas(Libc.gettext(PChar(utf8encode(szMsgId)))));
  {$endif}
  {$ifdef MSWINDOWS}
  if DLLisLoaded then
    Result := utf8decode(StrPas(pgettext(PChar(utf8encode(szMsgId)))))
  else
    Result := dgettext(curmsgdomain, szMsgId);
  {$endif}
  if Result = szMsgId then
    SaveCheck(szMsgId);
end;

function _(const szMsgId: widestring): widestring;
begin
  Result := gettext(szMsgId);
end;

function dgettext(const szDomain: string; const szMsgId: widestring): widestring;
begin
  {$ifdef LINUX}
  Result := utf8decode(StrPas(Libc.dgettext(PChar(szDomain), PChar(utf8encode(szMsgId)))));
  {$endif}
  {$ifdef MSWINDOWS}
  if DLLisLoaded then 
    Result := utf8decode(StrPas(pdgettext(PChar(szDomain), PChar(utf8encode(szMsgId)))))
  else
    Result := UTF8Decode(getdomain(szDomain).gettext(utf8encode(szMsgId)));
  {$endif}
  if (Result = szMsgId) and (szDomain = DefaultTextDomain) then
    SaveCheck(szMsgId);
end;

procedure textdomain(const szDomain: string);
begin
  curmsgdomain := szDomain;
  {$ifdef LINUX}
  Libc.textdomain(PChar(szDomain));
  {$endif}
  {$ifdef MSWINDOWS}
  if DLLisLoaded then begin
    ptextdomain(PChar(szDomain));
  end;
  {$endif}
end;

function getcurrenttextdomain: string;
begin
  {$ifdef LINUX}
  Result := StrPas(Libc.textdomain(nil))
  {$endif}
  {$ifdef MSWINDOWS}
  if DLLisLoaded then begin
    Result := StrPas(ptextdomain(nil))
  end else
    Result := curmsgdomain;
  {$endif}
end;

procedure bindtextdomain(const szDomain: string; const szDirectory: string);
var
  dir:string;
begin
  {$ifdef LINUX}
  dir:=ExcludeTrailingPathDelimiter(szDirectory);
  Libc.bindtextdomain(PChar(szDomain), PChar(dir));
  {$endif}
  {$ifdef MSWINDOWS}
  dir:=IncludeTrailingPathDelimiter(szDirectory);
  getdomain(szDomain).Directory := dir;
  if DLLisLoaded then begin
    pbindtextdomain(PChar(szDomain), PChar(dir));
  end;
  {$endif}
end;

var
  TranslatePropertiesIgnoreList:TStringList;

procedure TP_Ignore(AnObject:TObject; const name:string);
begin
  { TODO  -cgettext : Make this thread-safe. }
  TranslatePropertiesIgnoreList.Add(uppercase(name));
end;

procedure TranslatePropertiesSub(AnObject: TObject;Name:string);
var
  i: integer;
  j, Count: integer;
  PropList: PPropList;
  PropName, UPropName: string;
  PropInfo: PPropInfo;
  sl: TObject;
  comp:TComponent;
  {$ifdef DELPHI5OROLDER}
  ws: string;
  old: string;
  Data: PTypeData;
  {$ELSE}
  ws: WideString;
  old: WideString;
  {$endif}
begin
  if (AnObject = nil) then
    Exit;
  {$ifdef DELPHI5OROLDER}
  Data := GetTypeData(AnObject.Classinfo);
  Count := Data^.PropCount;
  GetMem(PropList, Count * Sizeof(PPropInfo));
  {$endif}
  try
    {$ifdef DELPHI5OROLDER}
    GetPropInfos(AnObject.ClassInfo, PropList);
    {$ELSE}
    Count := GetPropList(AnObject, PropList);
    {$endif}
      for j := 0 to Count - 1 do begin
        PropInfo := PropList[j];
        PropName := PropInfo^.Name;
        UPropName:=uppercase(PropName);
        // Ignore the name property - this should never be translated
        if (UPropName<>'NAME') and (not TranslatePropertiesIgnoreList.Find(Name+'.'+UPropName,i)) then begin
          // Translate certain types of properties
          case PropInfo^.PropType^.Kind of
            tkString, tkLString, tkWString:
              begin
                {$ifdef DELPHI5OROLDER}
                old := GetStrProp(AnObject, PropName);
                {$ELSE}
                old := GetWideStrProp(AnObject, PropName);
                {$endif}
                if (old <> '') and (IsWriteProp(PropInfo)) then begin
                  ws := gettext(old);
                  if ws <> old then begin
                    {$ifdef DELPHI5OROLDER}
                    SetStrProp(AnObject, PropName, ws);
                    {$ELSE}
                    SetWideStrProp(AnObject, PropName, ws);
                    {$endif}
                  end;
                end;
              end;
            tkClass:
              begin
                sl := GetObjectProp(AnObject, PropName);
                if (sl = nil) then
                  Continue;
                if sl is TStrings then begin
                  old := TStrings(sl).Text;
                  if old <> '' then begin
                    ws := gettext(old);
                    if (old <> ws) then
                      TStrings(sl).Text := ws;
                  end
                end else
                if sl is TCollection then
                  for i := 0 to TCollection(sl).Count - 1 do
                    TranslateProperties(TCollection(sl).Items[i]);
              end;
            end; // case
        end;  // if
      end;  // for
  finally
    {$ifdef DELPHI5OROLDER}
    FreeMem(PropList, Data^.PropCount * Sizeof(PPropInfo));
    {$endif}
  end;
  if AnObject is TComponent then
    for i := 0 to TComponent(AnObject).ComponentCount - 1 do begin
      comp:=TComponent(AnObject).Components[i];
      if not TranslatePropertiesIgnoreList.Find(uppercase(comp.Name),j) then begin
        TranslatePropertiesSub(comp,uppercase(comp.Name));
      end;
    end;
end;

procedure TranslateProperties(AnObject: TObject);
begin
  TranslatePropertiesSub (AnObject,'');
  TranslatePropertiesIgnoreList.Clear;
end;

{$ifdef MSWINDOWS}

// These constants are only used in Windows 95
// Thanks to Frank Andreas de Groot for this table
const
  IDAfrikaans                 = $0436;  IDAlbanian                  = $041C;
  IDArabicAlgeria             = $1401;  IDArabicBahrain             = $3C01;
  IDArabicEgypt               = $0C01;  IDArabicIraq                = $0801;
  IDArabicJordan              = $2C01;  IDArabicKuwait              = $3401;
  IDArabicLebanon             = $3001;  IDArabicLibya               = $1001;
  IDArabicMorocco             = $1801;  IDArabicOman                = $2001;
  IDArabicQatar               = $4001;  IDArabic                    = $0401;
  IDArabicSyria               = $2801;  IDArabicTunisia             = $1C01;
  IDArabicUAE                 = $3801;  IDArabicYemen               = $2401;
  IDArmenian                  = $042B;  IDAssamese                  = $044D;
  IDAzeriCyrillic             = $082C;  IDAzeriLatin                = $042C;
  IDBasque                    = $042D;  IDByelorussian              = $0423;
  IDBengali                   = $0445;  IDBulgarian                 = $0402;
  IDBurmese                   = $0455;  IDCatalan                   = $0403;
  IDChineseHongKong           = $0C04;  IDChineseMacao              = $1404;
  IDSimplifiedChinese         = $0804;  IDChineseSingapore          = $1004;
  IDTraditionalChinese        = $0404;  IDCroatian                  = $041A;
  IDCzech                     = $0405;  IDDanish                    = $0406;
  IDBelgianDutch              = $0813;  IDDutch                     = $0413;
  IDEnglishAUS                = $0C09;  IDEnglishBelize             = $2809;
  IDEnglishCanadian           = $1009;  IDEnglishCaribbean          = $2409;
  IDEnglishIreland            = $1809;  IDEnglishJamaica            = $2009;
  IDEnglishNewZealand         = $1409;  IDEnglishPhilippines        = $3409;
  IDEnglishSouthAfrica        = $1C09;  IDEnglishTrinidad           = $2C09;
  IDEnglishUK                 = $0809;  IDEnglishUS                 = $0409;
  IDEnglishZimbabwe           = $3009;  IDEstonian                  = $0425;
  IDFaeroese                  = $0438;  IDFarsi                     = $0429;
  IDFinnish                   = $040B;  IDBelgianFrench             = $080C;
  IDFrenchCameroon            = $2C0C;  IDFrenchCanadian            = $0C0C;
  IDFrenchCotedIvoire         = $300C;  IDFrench                    = $040C;
  IDFrenchLuxembourg          = $140C;  IDFrenchMali                = $340C;
  IDFrenchMonaco              = $180C;  IDFrenchReunion             = $200C;
  IDFrenchSenegal             = $280C;  IDSwissFrench               = $100C;
  IDFrenchWestIndies          = $1C0C;  IDFrenchZaire               = $240C;
  IDFrisianNetherlands        = $0462;  IDGaelicIreland             = $083C;
  IDGaelicScotland            = $043C;  IDGalician                  = $0456;
  IDGeorgian                  = $0437;  IDGermanAustria             = $0C07;
  IDGerman                    = $0407;  IDGermanLiechtenstein       = $1407;
  IDGermanLuxembourg          = $1007;  IDSwissGerman               = $0807;
  IDGreek                     = $0408;  IDGujarati                  = $0447;
  IDHebrew                    = $040D;  IDHindi                     = $0439;
  IDHungarian                 = $040E;  IDIcelandic                 = $040F;
  IDIndonesian                = $0421;  IDItalian                   = $0410;
  IDSwissItalian              = $0810;  IDJapanese                  = $0411;
  IDKannada                   = $044B;  IDKashmiri                  = $0460;
  IDKazakh                    = $043F;  IDKhmer                     = $0453;
  IDKirghiz                   = $0440;  IDKonkani                   = $0457;
  IDKorean                    = $0412;  IDLao                       = $0454;
  IDLatvian                   = $0426;  IDLithuanian                = $0427;
  IDMacedonian                = $042F;  IDMalaysian                 = $043E;
  IDMalayBruneiDarussalam     = $083E;  IDMalayalam                 = $044C;
  IDMaltese                   = $043A;  IDManipuri                  = $0458;
  IDMarathi                   = $044E;  IDMongolian                 = $0450;
  IDNepali                    = $0461;  IDNorwegianBokmol           = $0414;
  IDNorwegianNynorsk          = $0814;  IDOriya                     = $0448;
  IDPolish                    = $0415;  IDBrazilianPortuguese       = $0416;
  IDPortuguese                = $0816;  IDPunjabi                   = $0446;
  IDRhaetoRomanic             = $0417;  IDRomanianMoldova           = $0818;
  IDRomanian                  = $0418;  IDRussianMoldova            = $0819;
  IDRussian                   = $0419;  IDSamiLappish               = $043B;
  IDSanskrit                  = $044F;  IDSerbianCyrillic           = $0C1A;
  IDSerbianLatin              = $081A;  IDSesotho                   = $0430;
  IDSindhi                    = $0459;  IDSlovak                    = $041B;
  IDSlovenian                 = $0424;  IDSorbian                   = $042E;
  IDSpanishArgentina          = $2C0A;  IDSpanishBolivia            = $400A;
  IDSpanishChile              = $340A;  IDSpanishColombia           = $240A;
  IDSpanishCostaRica          = $140A;  IDSpanishDominicanRepublic  = $1C0A;
  IDSpanishEcuador            = $300A;  IDSpanishElSalvador         = $440A;
  IDSpanishGuatemala          = $100A;  IDSpanishHonduras           = $480A;
  IDMexicanSpanish            = $080A;  IDSpanishNicaragua          = $4C0A;
  IDSpanishPanama             = $180A;  IDSpanishParaguay           = $3C0A;
  IDSpanishPeru               = $280A;  IDSpanishPuertoRico         = $500A;
  IDSpanishModernSort         = $0C0A;  IDSpanish                   = $040A;
  IDSpanishUruguay            = $380A;  IDSpanishVenezuela          = $200A;
  IDSutu                      = $0430;  IDSwahili                   = $0441;
  IDSwedishFinland            = $081D;  IDSwedish                   = $041D;
  IDTajik                     = $0428;  IDTamil                     = $0449;
  IDTatar                     = $0444;  IDTelugu                    = $044A;
  IDThai                      = $041E;  IDTibetan                   = $0451;
  IDTsonga                    = $0431;  IDTswana                    = $0432;
  IDTurkish                   = $041F;  IDTurkmen                   = $0442;
  IDUkrainian                 = $0422;  IDUrdu                      = $0420;
  IDUzbekCyrillic             = $0843;  IDUzbekLatin                = $0443;
  IDVenda                     = $0433;  IDVietnamese                = $042A;
  IDWelsh                     = $0452;  IDXhosa                     = $0434;
  IDZulu                      = $0435;

function GetWindowsLanguage: string;
var
  langid: Cardinal;
  langcode: string;
  CountryName: array[0..4] of char;
  LanguageName: array[0..4] of char;
  works: boolean;
begin
  // The return value of GetLocaleInfo is compared with 3 = 2 characters and a zero
  works := 3 = GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SISO639LANGNAME, LanguageName, SizeOf(LanguageName));
  works := works and (3 = GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SISO3166CTRYNAME, CountryName,
    SizeOf(CountryName)));
  if works then begin
    // Windows 98, Me, NT4, 2000, XP and newer
    LangCode := PChar(@LanguageName[0]) + '_' + PChar(@CountryName[0]);
  end else begin
    // This part should only happen on Windows 95.
    langid := GetThreadLocale;
    case langid of
      IDBelgianDutch: langcode := 'nl_BE';
      IDBelgianFrench: langcode := 'fr_BE';
      IDBrazilianPortuguese: langcode := 'pt_BR';
      IDDanish: langcode := 'da_DK';
      IDDutch: langcode := 'nl_NL';
      IDEnglishUK: langcode := 'en_UK';
      IDEnglishUS: langcode := 'en_US';
      IDFinnish: langcode := 'fi_FI';
      IDFrench: langcode := 'fr_FR';
      IDFrenchCanadian: langcode := 'fr_CA';
      IDGerman: langcode := 'de_DE';
      IDGermanLuxembourg: langcode := 'de_LU';
      IDGreek: langcode := 'gr_GR';
      IDIcelandic: langcode := 'is_IS';
      IDItalian: langcode := 'it_IT';
      IDKorean: langcode := 'ko_KO';
      IDNorwegianBokmol: langcode := 'no_NO';
      IDNorwegianNynorsk: langcode := 'nn_NO';
      IDPolish: langcode := 'pl_PL';
      IDPortuguese: langcode := 'pt_PT';
      IDRussian: langcode := 'ru_RU';
      IDSpanish, IDSpanishModernSort: langcode := 'es_ES';
      IDSwedish: langcode := 'sv_SE';
      IDSwedishFinland: langcode := 'fi_SE';
    else
      langcode := 'C';
    end;
  end;
  Result := langcode;
end;

function MyLoadResString(ResStringRec: PResStringRec): string;
var
  Buffer: array[0..1023] of char;
begin
  if ResStringRec = nil then
    Exit;
  if ResStringRec.Identifier < 64 * 1024 then begin
    SetString(Result, Buffer,
      LoadString(FindResourceHInstance(ResStringRec.Module^),
      ResStringRec.Identifier, Buffer, SizeOf(Buffer)))
  end else
    Result := PChar(ResStringRec.Identifier);
  if Result <> '' then
    Result := dgettext(curresourcestringdomain, Result);
end;

procedure OverwriteProcedure(OldProcedure, NewProcedure: pointer);
{ OverwriteProcedure originally from Igor Siticov }
var
  x: pchar;
  y: integer;
  ov2, ov: cardinal;
begin
  x := PChar(OldProcedure);
  if not VirtualProtect(Pointer(x), 5, PAGE_EXECUTE_READWRITE, @ov) then
    RaiseLastOSError;

  x[0] := char($E9);
  y := integer(NewProcedure) - integer(OldProcedure) - 5;
  x[1] := char(y and 255);
  x[2] := char((y shr 8) and 255);
  x[3] := char((y shr 16) and 255);
  x[4] := char((y shr 24) and 255);

  if not VirtualProtect(Pointer(x), 5, ov, @ov2) then
    RaiseLastOSError;
end;

procedure gettext_putenv(const envstring: string);
begin
  if DLLisLoaded then
    pgettext_putenv(PChar(envstring));
end;

var
  dllmodule: THandle;
{$endif}

{$ifdef LINUX}
const
  ResStringTableLen = 16;

type
  ResStringTable = array[0..ResStringTableLen - 1] of LongWord;

function MyLoadResString(ResStringRec: PResStringRec): string;
var
  Handle: TResourceHandle;
  Tab: ^ResStringTable;
  ResMod: HMODULE;
begin
  if ResStringRec = nil then
    Exit;
  ResMod := FindResourceHInstance(ResStringRec^.Module^);
  Handle := FindResource(ResMod,
    PChar(ResStringRec^.Identifier div ResStringTableLen),
    PChar(6)); // RT_STRING
  Tab := Pointer(LoadResource(ResMod, Handle));
  if Tab = nil then
    Result := ''
  else
    Result := PChar(Tab) + Tab[ResStringRec^.Identifier mod ResStringTableLen];
  if Result <> '' then
    Result := dgettext(curresourcestringdomain, Result);
end;
{$endif}

procedure UseLanguage(LanguageCode: string);
{$ifdef mswindows}
var
  i:integer;
  dom:TDomain;
{$endif}
begin
  if curlang=LanguageCode then
    exit;
  curlang := LanguageCode;
  {$ifdef mswindows}
  gettext_putenv('LANG=' + LanguageCode);
  for i:=0 to domainlist.Count-1 do begin
    dom:=domainlist.Objects[i] as TDomain;
    dom.CloseMOFile;
  end;
  {$endif}
  {$ifdef LINUX}
  setlocale (LC_MESSAGES, PChar(LanguageCode));
  {$endif}
end;

{$ifdef mswindows}

{ TDomain }

function TDomain.CardinalInMem (baseptr:PChar; Offset:Cardinal):Cardinal;
var pc:^Cardinal;
begin
  inc (baseptr,offset);
  pc:=Pointer(baseptr);
  Result:=pc^;
  if doswap then
    autoswap32(Result);
end;

function TDomain.autoswap32(i: cardinal): cardinal;
var
  cnv1, cnv2:
    record
      case integer of
        0: (arr: array[0..3] of byte);
        1: (int: cardinal);
    end;
begin
  if doswap then begin
    cnv1.int := i;
    cnv2.arr[0] := cnv1.arr[3];
    cnv2.arr[1] := cnv1.arr[2];
    cnv2.arr[2] := cnv1.arr[1];
    cnv2.arr[3] := cnv1.arr[0];
    Result := cnv2.int;
  end else
    Result := i;
end;

procedure TDomain.CloseMoFile;
begin
  moCS.BeginWrite;
  try
    if isopen then begin
      UnMapViewOfFile (momemory);
      CloseHandle (momapping);
      CloseHandle (mo);
      
      isopen := False;
    end;
    moexists := True;
  finally
    moCS.EndWrite;
  end;
end;

constructor TDomain.Create;
begin
  moCS := TMultiReadExclusiveWriteSynchronizer.Create;
  isOpen := False;
  moexists := True;
end;

destructor TDomain.Destroy;
begin
  CloseMoFile;
  FreeAndNil(moCS);
  inherited;
end;

function TDomain.gettextbyid(id: cardinal): ansistring;
var
  offset: cardinal;
begin
  offset := CardinalInMem (momemory,O+8*id+4);
  Result := strpas(momemory+offset);
end;

function TDomain.getdsttextbyid(id: cardinal): ansistring;
var
  offset: cardinal;
begin
  offset := CardinalInMem (momemory,T+8*id+4);
  Result := strpas(momemory+offset);
end;

function TDomain.gettext(msgid: ansistring): ansistring;
var
  i, nn, step: cardinal;
  s: string;
begin
  if (not isopen) and (moexists) then
    OpenMoFile;
  if not isopen then begin
    Result := msgid;
    exit;
  end;

  // Calculate start conditions for a binary search
  nn := N;
  i := 1;
  while nn <> 0 do begin
    nn := nn shr 1;
    i := i shl 1;
  end;
  i := i shr 1;
  step := i shr 1;
  // Do binary search
  while true do begin
    // Get string for index i
    s := gettextbyid(i-1);
    if msgid = s then begin
      // Found the msgid
      Result := getdsttextbyid(i-1);
      break;
    end;
    if step = 0 then begin
      // Not found
      Result := msgid;
      break;
    end;
    if msgid < s then begin
      if i < 1+step then
        i := 1
      else
        i := i - step;
      step := step shr 1;
    end else
    if msgid > s then begin
      i := i + step;
      if i > N then
        i := N;
      step := step shr 1;
    end;
  end;
end;

procedure TDomain.OpenMoFile;
var
  i: cardinal;
  filename: string;
  ofs:_OFSTRUCT;
begin
  moCS.BeginWrite;
  try
    // Check if it is already open
    if isopen then
      exit;

    // Check if it has been attempted to open the file before
    if not moexists then
      exit;

    if sizeof(i) <> 4 then
      raise Exception.Create('TDomain in gnugettext is written for an architecture that has 32 bit integers.');

    filename := Directory + curlang + PathDelim + 'LC_MESSAGES' + PathDelim + domain + '.mo';
    if not fileexists(filename) then
      filename := Directory + copy(curlang, 1, 2) + PathDelim + 'LC_MESSAGES' + PathDelim + domain + '.mo';
    if not fileexists(filename) then begin
      moexists := False;
      exit;
    end;

    // Map the mo file into memory and let the operating system decide how to cache
    mo:=openfile (PChar(filename),ofs,OF_READ or OF_SHARE_DENY_NONE);
    if mo=HFILE_ERROR then
      raise Exception.Create ('Cannot open file '+filename);
    momapping:=CreateFileMapping (mo, nil, PAGE_READONLY, 0, 0, nil);
    if momapping=0 then
      raise Exception.Create ('Cannot create memory map on file '+filename);
    momemory:=MapViewOfFile (momapping,FILE_MAP_READ,0,0,0);
    if momemory=nil then
      raise Exception.Create ('Cannot map file '+filename+' into memory');
    isOpen := True;

    // Check the magic number
    doswap:=False;
    i:=CardinalInMem(momemory,0);
    if (i <> $950412DE) and (i <> $DE120495) then
      raise Exception.Create('This file is not a valid GNU gettext mo file: ' + filename);
    doswap := (i = $DE120495);

    CardinalInMem(momemory,4);       // Read the version number, but don't use it for anything.
    N:=CardinalInMem(momemory,8);    // Get string count
    O:=CardinalInMem(momemory,12);   // Get offset of original strings
    T:=CardinalInMem(momemory,16);   // Get offset of translated strings
  finally
    moCS.EndWrite;
  end;
end;

procedure TDomain.setDirectory(dir: string);
begin
  vDirectory := IncludeTrailingPathDelimiter(dir);
  CloseMoFile;
end;
{$endif}

function LoadDLLifPossible (dllname:string='gnu_gettext.dll'):boolean;
begin
  {$ifdef MSWINDOWS}
  if not DLLisLoaded then begin
    dllmodule := LoadLibraryEx(PChar(dllname), 0, 0);
    DLLisLoaded := (dllmodule <> 0);
    if DLLisLoaded then begin
      pgettext := tpgettext(GetProcAddress(dllmodule, 'gettext'));
      pdgettext := tpdgettext(GetProcAddress(dllmodule, 'dgettext'));
      ptextdomain := tptextdomain(GetProcAddress(dllmodule, 'textdomain'));
      pbindtextdomain := tpbindtextdomain(GetProcAddress(dllmodule, 'bindtextdomain'));
      pgettext_putenv := tpgettext_putenv(GetProcAddress(dllmodule, 'gettext_putenv'));
    end;
  end;
{$endif}
{$ifdef LINUX}
  // On Linux, gettext is always there as part of the Libc library.
  DLLisLoaded := True;
{$endif}
  Result:=DLLisLoaded;
end;

procedure SetSystemDefaults;
var
  dir: string;
{$ifdef mswindows}
  lang: string;
  p:integer;
{$endif}
begin
  dir := IncludeTrailingPathDelimiter(extractfilepath(paramstr(0)))+'locale';
  if not DirectoryExists (dir) then
    dir := ExcludeTrailingPathDelimiter(extractfilepath(paramstr(0)));

  {$ifdef MSWINDOWS}
  lang := GetEnvironmentVariable('LANG');
  if lang = '' then
    lang := GetWindowsLanguage;
  p:=pos('.',lang);
  if p<>0 then
    lang:=copy(lang,1,p-1);
  if not DirectoryExists(dir + PathDelim + lang) then
    lang := copy(lang, 1, 2);
  if lang<>'' then
    UseLanguage(lang);
  {$endif}
  {$ifdef LINUX}
  UseLanguage('');
  {$endif}

  bindtextdomain(DefaultTextDomain, dir);
  textdomain(DefaultTextDomain);

  {$ifdef LINUX}
  bind_textdomain_codeset(DefaultTextDomain,'utf-8')
  {$endif}
end;

initialization
  savefileCS := TMultiReadExclusiveWriteSynchronizer.Create;
{$ifdef MSWINDOWS}
  domainlist := TStringList.Create;
{$endif}
  TranslatePropertiesIgnoreList:=TStringList.Create;
  TranslatePropertiesIgnoreList.Sorted:=True;
  SetSystemDefaults;

{$ifdef MSWINDOWS}
  // replace Borlands LoadResString with gettext enabled version:
  OverwriteProcedure(@LoadResString, @MyLoadResString);
{$endif}

finalization
  if savememory <> nil then begin
    savefileCS.BeginWrite;
    try
      CloseFile(savefile);
    finally
      savefileCS.EndWrite;
    end;
    FreeAndNil(savememory);
    FreeAndNil(savefileCS);
  end;
  FreeAndNil (TranslatePropertiesIgnoreList);
{$ifdef MSWINDOWS}
  while domainlist.Count <> 0 do begin
    domainlist.Objects[0].Free;
    domainlist.Delete(0);
  end;
  FreeAndNil(domainlist);
  // Unload the dll
  if dllmodule <> 0 then
    FreeLibrary(dllmodule);
{$endif}

end.
