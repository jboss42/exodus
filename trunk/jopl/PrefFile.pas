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
    Unicode, XMLTag, Classes;
    
type
    TPrefState = (psReadOnly, psReadWrite, psInvisible);

    TPrefFile = class
    public
        constructor Create(filename: Widestring); overload;
        constructor Create(const ResName: string; ResType: PChar); overload;
        constructor Create(tag: TXMLTag); overload;

        Destructor Destroy; override;

        procedure save();

        function getString(pkey: Widestring): Widestring;
        procedure fillStringlist(pkey: Widestring; sl: TWideStrings);

        function getState(pkey: Widestring): TPrefState;
        function getControl(pkey: Widestring): string;
        function getPref(control: Widestring): Widestring;
        
    private
        _node     : TXMLTag;
        _new      : TXMLTag;
        _filename : Widestring;
        _ctrlHash : TWideStrings;
        _dirty    : boolean;

        procedure init();
end;

implementation

uses
    SysUtils, XMLParser, Session;

{---------------------------------------}
constructor TPrefFile.Create(tag: TXMLTag);
begin
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
    t,n,fs: TXMLTag;
    s: TXMLTagList;
    i, j: integer;
    c: Widestring;
begin
    _dirty := false;
    _ctrlHash := TWideStringList.Create();
    if (_node = nil) then begin
        // nothing there yet.
        _node := TXmlTag.Create('brand');
        _node.setAttribute('version', '0.9');
        _new := _node.AddTag('new_prefs');
        exit;
    end;

    // PGM: I'm not sure the version tag is adding that much.  we can
    // always use another tag name if we change formats again.

    _new := _node.GetFirstTag('new_prefs');
    if (_new = nil) then begin
        // old-style prefs.  convert to new style, so that save() will
        // do the right thing.
        _new := TXMLTag.Create('new_prefs');
        s := _node.ChildTags();
        for i:= s.Count - 1 downto 0 do begin
            t := s.Tags[i];
            // look ma, i've got suspenders, too.
            if (t.Name <> 'presence') and (t.Name <> 'new_prefs') then begin
                n := _new.AddTag(t);
                _node.RemoveTag(t);

                n.setAttribute('state', 'rw');

                // if there are s's inside, leave them.  otherwise, pull
                // the cdata out into the value attrib
                fs := n.GetFirstTag('s');
                if (fs = nil) then
                    n.setAttribute('value', n.Data);
            end;
        end;
        s.Free();
        _node.AddTag(_new);
    end;

    s := _new.ChildTags();
    for i := 0 to s.Count - 1 do begin
        t := s.Tags[i];
        c := t.GetAttribute('control');
        if (c <> '') then
            _ctrlHash.Values[c] := t.Name;

        s := t.QueryTags('control');
        for j := 0 to s.Count - 1 do begin
            c := s.Tags[i].GetAttribute('name');
            if (c <> '') then
                _ctrlHash.Values[c] := t.Name;
        end;
        s.Free;
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
    if (_filename = '') then exit;

    fs := TStringList.Create;
    fs.Text := UTF8Encode(_node.xml);

    try
        fs.SaveToFile(_filename);
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
    t := _new.GetFirstTag(pkey);
    if (t = nil) then
        Result := ''
    else
        Result := t.GetAttribute('value');
    end;
end;

{---------------------------------------}
procedure TPrefFile.fillStringlist(pkey: Widestring; sl: TWideStrings);
var
    t: TXMLTag;
    s: TXMLTagList;
    i: integer;
begin
    sl.Clear();

    t := _new.GetFirstTag(pkey);
    if (t = nil) then exit;

    s := t.QueryTags('s');
    for i := 0 to s.Count - 1 do
        sl.Add(s.Tags[i].Data);
    s.Free;
end;

{---------------------------------------}
function TPrefFile.getState(pkey: Widestring): TPrefState;
var
    t: TXMLTag;
    s: Widestring;
begin
    t := _new.GetFirstTag(pkey);
    if (t = nil) then begin
        Result := psReadWrite;
        exit;
    end;

    s := t.GetAttribute('state');
    if (s = 'ro') then
        Result := psReadOnly
    else if (s = 'inv') then
        Result := psInvisible
    else
        Result := psReadWrite;
end;

{---------------------------------------}
function TPrefFile.getControl(pkey: Widestring): string;
var
    t: TXMLTag;
begin
    t := _new.GetFirstTag(pkey);
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

end.
