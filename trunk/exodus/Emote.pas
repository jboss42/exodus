unit Emote;
{
    Copyright 2004, Peter Millard

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

interface

uses
  Unicode, iniFiles, RegExpr;

type
  TEmoticon = class
  private
    _resHandle : Cardinal;
    _file      : WideString;
    _img       : WideString;
    _rtf       : string;

  protected
    function GetRTF(): string; virtual; abstract;

  public
    constructor Create(resHandle: cardinal; resFile: WideString; resType: string; fileName: WideString);

    property RTF:string read GetRTF;
  end;

  TGifEmoticon = class(TEmoticon)
  protected
    function GetRTF(): string; override;

  public
    constructor Create(resHandle: cardinal; resFile: WideString; resType: string; fileName: WideString);
  end;

  TEmoticonList = class
  public
    constructor Create();
    destructor Destroy(); override;

    procedure AddResourceFile(resdll: WideString);
    procedure Clear();

  private
    _text      : THashedStringList;
    _objects   : THashedStringList;

    function LoadObject(mime: WideString; fileName: WideString; resHandle: cardinal; resFile: WideString): TEmoticon;

  end;

  procedure InitializeEmoticonLists();
  procedure ClearEmoticonLists();
  function GetEmoticonIMG(candidate: WideString): WideString;
  function GetEmoticonRTF(candidate: WideString): WideString;
  function ProcessIEEmoticons(txt: Widestring): WideString;

  var
    EmoticonList   : TEmoticonList;
    use_emoticons  : boolean;
    emoticon_regex : TRegExpr;

implementation

uses
    Windows, graphics, GIFImage, SysUtils, Session, XmlUtils,
    XMLParser, XMLTag, Classes, StrUtils;


constructor TEmoticon.Create(resHandle: cardinal; resFile: WideString; resType: string; fileName: WideString);
begin
    _resHandle := resHandle;
    _file := midstr(filename, 0, length(fileName) - 4);
    _rtf := '';
    _img := '';
end;

constructor TGifEmoticon.Create(resHandle: cardinal; resFile: WideString; resType: string; fileName: WideString);
begin
    inherited;

    _img := '<img src="res://' + resFile + '/GIF/' + _file + '" />';
end;

function BitmapToRTF(pict: Graphics.TBitmap): string;
var
    bi, bb, rtf: string;
    bis, bbs: Cardinal;
    achar: ShortString;
    hexpict: string;
    i: Integer;
begin
    GetDIBSizes(pict.Handle, bis, bbs);
    SetLength(bi,bis);
    SetLength(bb,bbs);
    GetDIB(pict.Handle, pict.Palette, PChar(bi)^, PChar(bb)^);
    rtf := '{\rtf1 {\pict\dibitmap ';
    SetLength(hexpict,(Length(bb) + Length(bi)) * 2);
    i := 2;
    for bis := 1 to Length(bi) do begin
        achar := Format('%x',[Integer(bi[bis])]);
        if Length(achar) = 1 then
            achar := '0' + achar;
        hexpict[i-1] := achar[1];
        hexpict[i] := achar[2];
        inc(i,2);
    end;
    for bbs := 1 to Length(bb) do begin
        achar := Format('%x',[Integer(bb[bbs])]);
        if Length(achar) = 1 then
            achar := '0' + achar;
        hexpict[i-1] := achar[1];
        hexpict[i] := achar[2];
        inc(i,2);
    end;
    rtf := rtf + hexpict + ' }}';
    Result := rtf;
end;

function TGifEmoticon.getRTF(): string;
var
    rs : TResourceStream;
    g  : TGifImage;
begin
    if (_rtf <> '') then begin
        result := _rtf;
        exit;
    end;
    rs := TResourceStream.Create(_resHandle, _file, 'GIF');
    g := TGifImage.Create();
    g.LoadFromStream(rs);
    rs.Free();
    _rtf := BitmapToRTF(g.Bitmap);
    result := _rtf;
end;

function TEmoticonList.LoadObject(mime: WideString; fileName: WideString; resHandle: cardinal; resFile: WideString): TEmoticon;
var
    key : WideString;
    i : integer;
begin
    key := resFile + '/' + fileName;
    i := _objects.IndexOf(key);
    if (i >= 0) then begin
        result := TEmoticon(_objects[i]);
        exit;
    end;

    if (mime = 'image/gif') then begin
        result := TGifEmoticon.Create(resHandle, resFile, 'GIF', fileName);
        _objects.AddObject(key, result);
    end
    else
        result := nil;
end;

constructor TEmoticonList.Create();
begin
    _text      := THashedStringList.Create();
    _objects   := THashedStringList.Create();
end;

procedure TEmoticonList.AddResourceFile(resdll: WideString);
var
    parser : TXMLTagParser;
    icondef : TXMLTag;
    icons, ts, os : TXMLTagList;
    icon, obj : TXMLTag;
    i, j : integer;
    e: TEmoticon;
    h: cardinal;
begin
    h := LoadLibraryW(PWChar(resdll));
    if (h = 0) then begin
        // TODO: debug warning
        exit;
    end;

    parser := TXMLTagParser.Create();
    parser.ParseResource(h, 'icondef');
    if (parser.Count <= 0) then begin
        parser.Free();
        exit;
    end;

    icondef := parser.popTag();
    parser.Free();

    icons := icondef.QueryTags('icon');
    for i := 0 to icons.Count - 1 do begin
        icon := icons[i];

        e := nil;
        os := icon.QueryTags('object');
        for j := 0 to os.Count - 1 do begin
            obj := os[j];
            e := LoadObject(obj.GetAttribute('mime'), obj.Data, h, resdll);
            if (e <> nil) then break;
        end;
        os.Free();

        if (e <> nil) then begin
            ts := icon.QueryTags('text');
            for j := 0 to ts.Count - 1 do begin
                _text.AddObject(ts[j].Data, e);
            end;
            ts.Free();
        end;

    end;
    icons.Free();
end;

destructor TEmoticonList.Destroy();
begin
    Clear();
    _text.Free();
    _objects.Free();
end;

procedure TEmoticonList.Clear();
begin
    ClearStringListObjects(_objects);
    _objects.Clear();
    _text.Clear();
end;

function GetEmoticonIMG(candidate: WideString): WideString;
var
    i: integer;
begin
    result := '';
    i := EmoticonList._text.IndexOf(candidate);
    if (i >= 0) then
        result := TEmoticon(EmoticonList._text.Objects[i])._img;
end;

function GetEmoticonRTF(candidate: WideString): WideString;
var
    i: integer;
begin
    result := '';
    i := EmoticonList._text.IndexOf(candidate);
    if (i >= 0) then
        result := TEmoticon(EmoticonList._text.Objects[i]).GetRTF();
end;

procedure ClearEmoticonLists();
begin
      EmoticonList.Clear();
end;

procedure InitializeEmoticonLists();
var
    dlls : TWideStringList;
    i : integer;
begin
    dlls := TWideStringList.Create();
    MainSession.Prefs.fillStringlist('emoticon_dlls', dlls);
    for i := 0 to dlls.Count - 1 do begin
        EmoticonList.AddResourceFile(dlls[i]);
    end;
    dlls.Free();
end;


function ProcessIEEmoticons(txt: Widestring): WideString;
var
    m: boolean;
    ms, s: Widestring;
    lm: integer;
    img: WideString;
    res: WideString;
begin
    // search for various smileys

    res := '';
    s := txt;
    m := emoticon_regex.Exec(txt);
    lm := 0;
    while(m) do begin
        // we have a match
        lm := emoticon_regex.MatchPos[0] + emoticon_regex.MatchLen[0];
        res := res + emoticon_regex.Match[1];
        
        img := '';
        // Grab the match text and look it up in our emoticon list
        ms := emoticon_regex.Match[2];
        if (ms <> '') then begin
            img := GetEmoticonIMG(ms);
        end;

        // if we have a legal emoticon object, insert it..
        // otherwise insert the matched text
        if (img <> '') then
            res := res + img
        else
            res := res + ms;

        // Match-6 is any trailing whitespace
        if (lm <= length(txt)) then
            res := res + emoticon_regex.Match[6];

        // Search for the next emoticon
        m := emoticon_regex.ExecNext();

        // do a sanity check here, probably because the regex prolly isn't
        // _REALLY_ widestr compliant
        if (m) then begin
            if (length(txt) < emoticon_regex.MatchPos[0]) then
                m := false;
        end;
    end;

    if (lm <= length(txt)) then begin
        // we have a remainder
        res := res +  Copy(txt, lm, length(txt) - lm + 1);
    end;
    result := res;
end;

initialization
    EmoticonList := TEmoticonList.Create();
    // Create the static regex object and compile it.
    emoticon_regex := TRegExpr.Create();
    emoticon_regex.ModifierG := false;
    // This is a "meta-regex" that should match everything
    emoticon_regex.Expression := '(.*)((\([a-zA-Z0-9@{}%&~?/^]+\))|([:;BoOxX][^\t ]+)|(=[;)]))(\s|$)';
    emoticon_regex.Compile();

finalization
    EmoticonList.Free();
    if (emoticon_regex <> nil) then
        emoticon_regex.Free();

end.
