unit PrefFile;
{
    Copyright 2003, Joe Hildebrand

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
    Unicode, XMLTag, Presence,

    {$ifdef Exodus}
    TntClasses,
    {$endif}

    Classes;

type
    TPrefState = (psReadOnly, psReadWrite, psInvisible, psUnknown);

    TPrefFile = class
    private
        _node     : TXMLTag;
        _pres     : TXMLTag;
        _pos      : TXMLTag;
        _prof     : TXMLTag;
        _filename : Widestring;
        _ctrlHash : TWideStringList;
        _dirty    : boolean;
        _need_default_pres : boolean;

        procedure init();

    public
        constructor Create(filename: Widestring); overload;
        constructor Create(const ResName: string; ResType: PChar); overload;
        constructor Create(tag: TXMLTag); overload;

        Destructor Destroy; override;

        procedure save();

        function getString(pkey: Widestring): Widestring;

        function getState(pkey: Widestring): TPrefState;
        function getControl(pkey: Widestring): string;
        function getPref(control: Widestring): Widestring;

        procedure setString(pkey: Widestring; val: Widestring);
{$ifdef EXODUS}
        procedure setStringlist(pkey: Widestring; pvalue: TWideStrings); overload;
        procedure setStringlist(pkey: Widestring; pvalue: TTntStrings); overload;
        function fillStringlist(pkey: Widestring; sl: TWideStrings): boolean; overload;
        function fillStringlist(pkey: Widestring; sl: TTntStrings): boolean; overload;
{$else}
        procedure setStringlist(pkey: Widestring; pvalue: TWideStrings);
        function fillStringlist(pkey: Widestring; sl: TWideStrings): boolean;
{$endif}

        function findPresenceTag(pkey: Widestring): TXMLTag;
        function getAllPresence(): TWidestringList;
        function getPresence(pkey: Widestring): TJabberCustomPres;
        function getPresIndex(idx: integer): TJabberCustomPres;
        procedure setPresence(pvalue: TJabberCustomPres);
        procedure removePresence(pkey: Widestring);
        procedure removeAllPresence();

        function getPositionTag(pkey: WideString; setDirty: boolean = false): TXMLTag;
        procedure clearProfiles();

        property Dirty : boolean read _dirty;
        property NeedDefaultPresence : boolean read _need_default_pres;
        property Profiles : TXMLTag read _prof;
end;

implementation

uses
    SysUtils, XMLParser, Session;

const
    // DO NOT LOCALIZE!
    PRES    = 'presii';
    ROOT    = 'exodus';
    VER     = 'version';
    VER_NUM = '0.9';
    VALUE   = 'value';
    POS     = 'positions';
    PROF    = 'profiles';

{---------------------------------------}
constructor TPrefFile.Create(tag: TXMLTag);
begin
    _filename := '';
    _node := TXMLTag.Create(tag);
    init();
end;

{---------------------------------------}
constructor TPrefFile.Create(filename: Widestring);
var
    parser: TXMLTagParser;
begin
    _filename := filename;
    parser := TXMLTagParser.Create;

    try
        if (fileExists(_filename)) then begin
            parser.ParseFile(_filename);
            if (parser.Count > 0) then begin
                _node := parser.popTag();
            end
        end
    except
    end;

    parser.Free();
    init();
end;

{---------------------------------------}
constructor TPrefFile.Create(const ResName: string; ResType: PChar);
var
    res: TResourceStream;
    sl: TStringList;
    parser: TXMLTagParser;
begin
    _filename := '';
    parser := TXMLTagParser.Create;

    try
        res := TResourceStream.Create(HInstance, ResName, ResType);
        sl := TStringList.Create();
        sl.LoadFromStream(res);
        res.Free();
        parser.ParseString(sl.Text, '');
        sl.Free();
        if (parser.Count > 0) then begin
            _node := parser.popTag();
        end
    except
    end;

    parser.Free();
    init();
end;

{---------------------------------------}
procedure TPrefFile.init();
var
    t,fs: TXMLTag;
    s, cs: TXMLTagList;
    i, j: integer;
    c: Widestring;
begin
    _dirty := false;
    _need_default_pres := false;
    _ctrlHash := TWideStringList.Create();
    _ctrlHash.Sorted := true;
    _ctrlHash.Duplicates := dupIgnore;

    if (_node = nil) then begin
        // nothing there yet.
        _node := TXmlTag.Create(ROOT);
        _node.setAttribute(VER, VER_NUM);
        _pres := _node.AddTag(PRES);
        _pos  := _node.AddTag(POS);
        _prof := _node.AddTag(PROF);
        exit;
    end;

    _pres := _node.GetFirstTag(PRES);
    if (_pres = nil) then
        _pres := _node.AddTag(PRES);

    _pos := _node.GetFirstTag(POS);
    if (_pos = nil) then
        _pos := _node.AddTag(POS);

    _prof := _node.GetFirstTag(PROF);
    if (_prof = nil) then
        _prof := _node.AddTag(PROF);

    // If the format changes again, also check VER_NUM.
    if (_node.getAttribute(VER) = '') then begin
        _dirty := true;
        _node.Name := ROOT;
        _node.setAttribute(VER, VER_NUM);

        _need_default_pres := true;
        // old-style prefs.  convert to new style, so that save() will
        // do the right thing.
        s := _node.ChildTags();
        for i:= s.Count - 1 downto 0 do begin
            t := s.Tags[i];
            if (t.Name = 'presence') then begin
                _pres.AddTag(TXMLTag.Create(t));
                _node.RemoveTag(t);
            end
            else if (t.Name = 'custom_pres') then begin // older dailies
                _need_default_pres := false;
                _node.RemoveTag(t);
            end
            else if (t.Name = 'profile') then begin
                _prof.AddTag(TXMLTag.Create(t));
                _node.RemoveTag(t);
            end
            else if ((t.Name <> PRES) and (t.Name <> POS) and (t.Name <> PROF)) then begin  // in case there was a custom_pres
                // if there are s's inside, leave them.  otherwise, pull
                // the cdata out into the value attrib
                fs := t.GetFirstTag('s');
                if ((fs = nil) and (t.Data <> '')) then begin
                    setString(t.Name, t.Data);
                    t.ClearCData();
                end;
            end;
        end;
        s.Free();
        save();
    end;

    s := _node.ChildTags();
    for i := 0 to s.Count - 1 do begin
        t := s.Tags[i];
        if (t.Name = PRES) then continue;

        c := t.GetAttribute('control');
        if (c <> '') then begin
            _ctrlHash.Values[c] := t.Name;
        end;

        cs := t.QueryTags('control');
        for j := 0 to cs.Count - 1 do begin
            c := cs.Tags[i].GetAttribute('name');
            if (c <> '') then begin
                assert(_ctrlHash.IndexOf(c) = -1);
                _ctrlHash.Add(c);
                _ctrlHash.Values[c] := t.Name;
            end;
        end;
        cs.Free;
    end;
    s.Free();
end;

{---------------------------------------}
destructor TPrefFile.Destroy;
begin
    if _node <> nil then
        _node.Free();
    _ctrlHash.Free();
end;

{---------------------------------------}
procedure TPrefFile.save();
var
    fs: TStringList;
begin
    if ((_filename = '') or (not _dirty)) then exit;

    fs := TStringList.Create;
    fs.Text := UTF8Encode(_node.xml);

    try
        fs.SaveToFile(_filename);
        _dirty := false;
    except
        MainSession.FireEvent('/session/gui/prefs-write-error', nil);
    end;

    fs.Free();
end;

{---------------------------------------}
function TPrefFile.getString(pkey: Widestring): Widestring;
var
    t: TXMLTag;
begin
    t := _node.GetFirstTag(pkey);
    if (t = nil) then
        Result := ''
    else
        Result := t.GetAttribute(VALUE);
end;

{---------------------------------------}
function TPrefFile.fillStringlist(pkey: Widestring; sl: TWideStrings): boolean;
var
    t: TXMLTag;
    s: TXMLTagList;
    i: integer;
begin
    sl.Clear();
    Result := false;

    t := _node.GetFirstTag(pkey);
    if (t = nil) then exit;

    s := t.QueryTags('s');
    for i := 0 to s.Count - 1 do
        sl.Add(s.Tags[i].Data);
    s.Free;
    
    Result := true;
end;


{---------------------------------------}
function TPrefFile.getState(pkey: Widestring): TPrefState;
var
    t: TXMLTag;
    s: Widestring;
begin
    t := _node.GetFirstTag(pkey);
    if (t = nil) then begin
        Result := psReadWrite;
        exit;
    end;

    s := t.GetAttribute('state');
    if (s = 'ro') then
        Result := psReadOnly
    else if (s = 'inv') then
        Result := psInvisible
    else if (s = 'rw') then
        Result := psReadWrite
    else
        Result := psUnknown;
end;

{---------------------------------------}
function TPrefFile.getControl(pkey: Widestring): string;
var
    t: TXMLTag;
begin
    t := _node.GetFirstTag(pkey);
    if (t = nil) then begin
        Result := '';
        exit;
    end;

    Result := t.GetAttribute('control');
end;

{---------------------------------------}
function TPrefFile.getPref(control: Widestring): Widestring;
begin
    Result := _ctrlHash.Values[control];
end;


{---------------------------------------}
procedure TPrefFile.setString(pkey: Widestring; val: Widestring);
var
    t: TXMLTag;
begin
    _dirty := true;

    t := _node.GetFirstTag(pkey);
    if ((t = nil) and (val <> '')) then
        t := _node.AddTag(pkey);

    if (val <> '') then
        t.setAttribute(VALUE, val)
    else if (t <> nil) then
        _node.removeTag(t);
end;

{---------------------------------------}
procedure TPrefFile.setStringlist(pkey: Widestring; pvalue: TWideStrings);
var
    i: integer;
    t: TXMLTag;
    s: TXMLTagList;
begin
    _dirty := true;

    // setup the stringlist in it's own parent..
    // with multiple <s> tags for each value.
    t := _node.GetFirstTag(pkey);
    if (t = nil) then
        t := _node.AddTag(pkey);

    // clear out the old
    s := t.QueryTags('s');
    for i := 0 to s.Count - 1 do
        t.removeTag(s[i]);
    s.free();

    // plug in all the values
    for i := 0 to pvalue.Count - 1 do begin
        if (pvalue[i] <> '') then
            t.AddBasicTag('s', pvalue[i]);
    end;
end;

{$ifdef EXODUS}
{---------------------------------------}
function TPrefFile.fillStringlist(pkey: Widestring; sl: TTntStrings): boolean;
var
    t: TXMLTag;
    s: TXMLTagList;
    i: integer;
begin
    sl.Clear();
    Result := false;

    t := _node.GetFirstTag(pkey);
    if (t = nil) then exit;

    s := t.QueryTags('s');
    for i := 0 to s.Count - 1 do
        sl.Add(s.Tags[i].Data);
    s.Free;

    Result := true;
end;

{---------------------------------------}
procedure TPrefFile.setStringlist(pkey: Widestring; pvalue: TTntStrings);
var
    i: integer;
    t: TXMLTag;
    s: TXMLTagList;
begin
    _dirty := true;

    // setup the stringlist in it's own parent..
    // with multiple <s> tags for each value.
    t := _node.GetFirstTag(pkey);
    if (t = nil) then
        t := _node.AddTag(pkey);

    // clear out the old
    s := t.QueryTags('s');
    for i := 0 to s.Count - 1 do
        t.removeTag(s[i]);
    s.free();

    // plug in all the values
    for i := 0 to pvalue.Count - 1 do begin
        if (pvalue[i] <> '') then
            t.AddBasicTag('s', pvalue[i]);
    end;
end;
{$endif}

{---------------------------------------}
function TPrefFile.findPresenceTag(pkey: Widestring): TXMLTag;
begin
    // get some custom pres from the list
    Result := _pres.QueryXPTag('/presence@name="' + pkey + '"');
end;

{---------------------------------------}
procedure TPrefFile.removePresence(pkey: Widestring);
var
    tag: TXMLTag;
begin
    _dirty := true;

    // remove this specific presence
    tag := _pres.QueryXPTag('/presence@name="' + pkey + '"');

    if (tag <> nil) then
        _pres.RemoveTag(tag);
end;

{---------------------------------------}
procedure TPrefFile.removeAllPresence();
begin
    _pres.ClearTags();
end;

{---------------------------------------}
function TPrefFile.getAllPresence(): TWidestringlist;
var
    i: integer;
    ptags: TXMLTagList;
    cp: TJabberCustompres;
begin
    Result := TWidestringlist.Create();
    ptags := _pres.QueryTags('presence');

    for i := 0 to ptags.Count - 1 do begin
        cp := TJabberCustompres.Create();
        cp.Parse(ptags[i]);
        Result.AddObject(cp.title, cp);
    end;

    Result.Sort();
    ptags.Free();
end;

{---------------------------------------}
function TPrefFile.getPresence(pkey: Widestring): TJabberCustomPres;
var
    p: TXMLTag;
begin
    // get some custom pres from the list
    Result := nil;
    p := Self.findPresenceTag(pkey);
    if (p <> nil) then begin
        Result := TJabberCustomPres.Create();
        Result.Parse(p);
    end;
end;

{---------------------------------------}
function TPrefFile.getPresIndex(idx: integer): TJabberCustomPres;
var
    ptags: TXMLTagList;
begin
    Result := nil;
    ptags := _pres.QueryTags('presence');
    if ((idx >= 0) and (idx < ptags.Count)) then
        Result := getPresence(ptags[idx].GetAttribute('name'));
    ptags.Free();
end;

{---------------------------------------}
procedure TPrefFile.setPresence(pvalue: TJabberCustomPres);
var
    p: TXMLTag;
begin
    _dirty := true;

    // set some custom pres into the list
    p := Self.findPresenceTag(pvalue.title);
    if (p = nil) then
        p := _pres.AddTag('presence');
    pvalue.FillTag(p);
end;

{---------------------------------------}
function TPrefFile.getPositionTag(pkey: WideString; setDirty: boolean = false): TXMLTag;
begin
    if (setDirty) then
        _dirty := true;

    Result := _pos.getFirstTag(pkey);

    // ew.  look over there. -->
    if ((Result = nil) and setDirty) then
        Result := _pos.AddTag(pkey);
end;

{---------------------------------------}
procedure TPrefFile.ClearProfiles();
begin
    _dirty := true;
    _prof.ClearTags();
end;

end.
