unit RTFProperty;

interface
uses
    RTFEditor, DesignIntf, DesignEditors,
    SysUtils, Controls, ComCtrls, Classes, Forms, Windows, Messages;

type
  TRTFProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
    function GetValue: string; override;
  end;

  TLanguageProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

procedure Register;

var
  GetStrProc: TGetStrProc;

  SearchId: String;
  SearchLang: Integer;
  LCType: Integer;

function EnumGetValues(LocaleStr: LPSTR): Integer; stdcall;
function EnumGetLang(LocaleStr: LPSTR): Integer; stdcall;
function IdentToLanguage(const Ident: string; var Language: Longint): Boolean;

implementation
uses
    Langs, RichEdit2;

function TRTFProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TRTFProperty.Edit;
var
  Editor: TRichEdit98Editor;
  RE: TRichEdit98;
  MS: TMemoryStream;
begin
  Editor:= TRichEdit98Editor.Create(Application);
  RE:= GetComponent(0) as TRichEdit98;
  MS:= TMemoryStream.Create;
  if RE.Perform(WM_GETTEXTLENGTH, 0, 0)>0 then
    begin
      RE.Lines.SaveToStream(MS);
      MS.Position:= 0;
      TRichEdit(Editor.Editor).Lines.LoadFromStream(MS);
      Editor.Editor.Font:= RE.Font;
      MS.Clear;
    end
  else
    Editor.Editor.SelAttributes.Assign(RE.Font);
  if Editor.ShowModal = mrOk then
    if Editor.Editor.Perform(WM_GETTEXTLENGTH, 0, 0)>0 then
      begin
        Editor.Editor.Lines.SaveToStream(MS);
        MS.Position:= 0;
        RE.Clear;
        TRichEdit(RE).Lines.LoadFromStream(MS);
        Modified;
      end
    else
      RE.Clear;
  MS.Free;
  Editor.Free;
end;

function TRTFProperty.GetValue: string;
begin
  Result:= '(TStrings)';
end;

function TLanguageProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSortList, paValueList];
end;

function TLanguageProperty.GetValue: string;
begin
  if not LanguageToIdent(TLanguage(GetOrdValue), Result) then
    FmtStr(Result, '%d', [GetOrdValue]);
end;

procedure TLanguageProperty.GetValues(Proc: TGetStrProc);
begin
  GetStrProc := Proc;
  EnumSystemLocales(@EnumGetValues, LCID_INSTALLED);
end;

procedure TLanguageProperty.SetValue(const Value: string);
var
  NewValue: Longint;
begin
  if IdentToLanguage(Value, NewValue) then
    SetOrdValue(NewValue)
  else inherited SetValue(Value);
end;

function IdentToLanguage(const Ident: string; var Language: Longint): Boolean;
begin
  SearchId := Ident;
  SearchLang := -1;
  LCType:= LOCALE_SLANGUAGE;
  EnumSystemLocales(@EnumGetLang, LCID_INSTALLED);
  if SearchLang<0 then
    begin
      LCType:= LOCALE_SENGLANGUAGE;
      EnumSystemLocales(@EnumGetLang, LCID_INSTALLED);
    end;
  if SearchLang<0 then
    begin
      LCType:= LOCALE_SABBREVLANGNAME;
      EnumSystemLocales(@EnumGetLang, LCID_INSTALLED);
    end;
  Result:= SearchLang>-1;
  if Result then
    Language:= SearchLang;
end;


function EnumGetValues(LocaleStr: LPSTR): Integer; stdcall;
var
  Buf: array[0..255]of Char;
  Locale: LCID;
  Z: Integer;
begin
  Val('$'+StrPas(LocaleStr), Locale, Z);
  GetLocaleInfo(Locale, LOCALE_SLANGUAGE, Buf, 255);
  GetStrProc(Buf);
  Result:= 1;
end;

function EnumGetLang(LocaleStr: LPSTR): Integer; stdcall;
var
  Buf: array[0..255]of Char;
  Locale: LCID;
  Z: Integer;
begin
  Val('$'+StrPas(LocaleStr), Locale, Z);
  Result:= 1;
  GetLocaleInfo(Locale, LCType, Buf, 255);
  if AnsiCompareText(SearchId, Buf)=0 then
    begin
      SearchLang:= Locale;
      Result:= 0;
    end;
end;


procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TStrings), TRichEdit98, 'Lines', TRTFProperty);
  RegisterPropertyEditor(TypeInfo(TLanguage), nil, '', TLanguageProperty);
end;

end.
 