unit XMLTag;
{
    Copyright 2001, Peter Millard

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
    XMLNode,
    XMLAttrib,
    XMLCData,
    LibXmlParser,
    Classes,
    Contnrs,
    StdVcl;

type
  {---------------------------------------}
  {          TXMLTag Main Class Def       }
  {---------------------------------------}
  TXMLTag = class;

  TXMLNodeList = class(TObjectList)
    end;

  TXMLTagList = class(TList)
    private
        function GetTag(index: integer): TXMLTag;
    public
        property Tags[index: integer]: TXMLTag read GetTag; default;
    end;

  TXMLTag = class(TXMLNode)
  private
    _AttrList: TAttrList;       // list of attributes
    _Children: TXMLNodeList; // list of nodes
    _ns: string;
  public
    pTag: TXMLTag;

    constructor Create; overload; override;
    constructor Create(tagname: string); reintroduce; overload;
    destructor Destroy; override;

    function AddTag(tagname: string): TXMLTag;
    function AddBasicTag(tagname, cdata: string): TXMLTag;
    function AddCData(content: string): TXMLCData;

    function GetAttribute(key: string): string;
    procedure PutAttribute(key, value: string);

    function ChildTags: TXMLTagList;
    function QueryXPath(path: string): TXMLTagList;
    function QueryTags(key: string): TXMLTagList;
    function GetFirstTag(key: string): TXMLTag;

    function Data: string;
    function Namespace: string;
    function xml: string; override;

    procedure ClearTags;
    procedure ClearCData;
    procedure AssignTag(const xml: TXMLTag);

    property Attributes: TAttrList read _AttrList;
    property Nodes: TXMLNodeList read _Children;
  end;

  TXPMatch = class
  private
    _AttrList: TAttrList;       // list of attributes
    function GetAttrCount: integer;
  public
    tag_name: string;
    constructor Create;
    destructor Destroy; override;
    procedure Parse(xps: string);
    procedure putAttribute(name, value: string);
    function getAttribute(i: integer): TAttr;

    property AttrCount: integer read GetAttrCount;
  end;

  TXPLite = class
  private
    Matches: TStringList;

    Tags: TStringList;
    attr: string;
    value: string;
    function GetString: string;
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure Parse(xps: string);
    function Compare(Tag: TXMLTag): boolean;
    property AsString: string read GetString;
  end;


implementation

uses
    jclConstants,
    XMLUtils,
    SysUtils;

function TXMLTagList.GetTag(index: integer): TXMLTag;
begin
    if (index >= 0) and (index < Count) then
        Result := TXMLTag(Items[index])
    else
        Result := nil;
end;

{---------------------------------------}
{---------------------------------------}
{  TXMLTag  Class Implmenetation        }
{---------------------------------------}
{---------------------------------------}

constructor TXMLTag.Create;
begin
    // Create the object
    inherited Create;

    NodeType := xml_tag;
    _AttrList := TAttrList.Create();
    _Children := TXMLNodeList.Create(true);
    pTag := nil;
end;

{---------------------------------------}
constructor TXMLTag.Create(tagname: string);
begin
    //
    inherited Create;

    _AttrList := TAttrList.Create();
    _Children := TXMLNodeList.Create(true);
    Name := tagname;
end;

{---------------------------------------}
destructor TXMLTag.Destroy;
begin
    // Free everything for this node
    _AttrList.Free;
    _Children.Clear;
    _Children.Free;
    inherited Destroy;
end;

{---------------------------------------}
function TXMLTag.AddTag(tagname: string): TXMLTag;
var
    t: TXMLTag;
begin
    // Add a tag
    t := TXMLTag.Create;
    t.Name := tagname;
    t.pTag := Self;
    _Children.Add(t);
    Result := t;
end;

{---------------------------------------}
function TXMLTag.AddBasicTag(tagname, cdata: string): TXMLTag;
var
    t: TXMLTag;
begin
    t := AddTag(tagname);
    t.AddCData(cdata);
    Result := t;
end;

{---------------------------------------}
procedure TXMLTag.ClearTags;
var
    i: integer;
    n: TXMLNode;
begin
    // clear out all child tags
    for i := _children.Count - 1 downto 0 do begin
        n := TXMLNode(_children[i]);
        if n is TXMLTag then begin
            // remove it
            TXMLTag(n).Free;
            _children.Delete(i);
            end;
        end;
end;

{---------------------------------------}
procedure TXMLTag.ClearCData;
var
    i: integer;
    n: TXMLNode;
begin
    // clear out all child tags
    for i := _children.Count - 1 downto 0 do begin
        n := TXMLNode(_children[i]);
        if n is TXMLCDATA then begin
            // remove it
            TXMLCDATA(n).Free;
            _children.Delete(i);
            end;
        end;
end;

{---------------------------------------}
function TXMLTag.AddCData(content: string): TXMLCData;
var
    c: TXMLCData;
begin
    // Add the CData to the tag
    c := TXMLCData.Create(content);
    _Children.Add(c);
    Result := c;
end;

{---------------------------------------}
function TXMLTag.GetAttribute(key: string): string;
var
    attr: TNvpNode;
begin
    // get the attribute
    Result := '';
    attr := _AttrList.Node(key);
    if attr <> nil then
        Result := attr.Value;
end;

{---------------------------------------}
procedure TXMLTag.PutAttribute(key, value: string);
var
    a: TNvpNode;
begin
    // Setup an attribute key value pair
    a := _AttrList.Node(key);
    if a = nil then begin
        a := TAttr.Create(key, value);
        _AttrList.Add(a);
        end
    else
        a.value := value;

end;

{---------------------------------------}
function TXMLTag.QueryXPath(path: string): TXMLTagList;
begin
    // Return a tag list based on the xpath stuff
    Result := nil;
end;

{---------------------------------------}
function TXMLTag.ChildTags: TXMLTagList;
var
    t: TXMLTagList;
    n: TXMLNode;
    i: integer;
begin
    // return a list of all child elements
    t := TXMLTagList.Create();
    for i := 0 to _Children.Count - 1 do begin
        n := TXMLNode(_Children[i]);
        if (n.IsTag) then
            t.Add(TXMLTag(n));
        end;
    Result := t;
end;


{---------------------------------------}
function TXMLTag.QueryTags(key: string): TXMLTagList;
var
    t: TXMLTagList;
    n: TXMLNode;
    sname: string;
    i: integer;
begin
    //
    t := TXMLTagList.Create();
    sname := Trim(key);
    for i := 0 to _Children.Count - 1 do begin
        n := TXMLNode(_Children[i]);
        if ((n.IsTag) and (NameMatch(sname, n.name))) then
            t.Add(TXMLTag(n));
        end;

    Result := t;
end;

{---------------------------------------}
function TXMLTag.GetFirstTag(key: string): TXMLTag;
var
    sname: string;
    i: integer;
    n: TXMLNode;
begin
    Result := nil;
    sname := Trim(key);
    for i := 0 to _Children.Count - 1 do begin
        n := TXMLNode(_Children[i]);
        if ((n.IsTag) and (NameMatch(sname, n.name))) then begin
            Result := TXMLTag(n);
            exit;
            end;
        end;
end;

{---------------------------------------}
function TXMLTag.Data: string;
var
    i: integer;
    n: TXMLNode;
    r: string;
begin
    // add all CData together
    r := '';
    for i := 0 to _Children.Count - 1 do begin
        n := TXMLNode(_Children[i]);
        if (n.NodeType = xml_CDATA) then begin
            r := r + TXMLCData(n).Data + ' ';
            break;
            end;
        end;
    if r <> '' then r := Trim(r);
    Result := r;
end;

{---------------------------------------}
function TXMLTag.Namespace: string;
var
    n:  TXMLNode;
    i:  integer;
begin
    // find the namespace for this tag
    if _ns = '' then begin
        _ns := Self.GetAttribute('xmlns');
        if _ns = '' then begin
            // check thru all the tag elements
            for i := 0 to _Children.Count - 1 do begin
                n := TXMLNode(_Children[i]);
                if (n.NodeType = xml_Tag) then begin
                    _ns := TXMLTag(n).GetAttribute('xmlns');
                    if _ns <> '' then
                        break;
                    end;
                end;
            end;
        end;
    Result := _ns;
end;

{---------------------------------------}
function TXMLTag.xml: string;
var
    i: integer;
    x: string;
begin
    // Return a string containing the full
    // representation of this tag
    x := '<' + Self.Name;
    for i := 0 to _AttrList.Count - 1 do
        x := x + ' ' + _AttrList.Name(i) + '="' + _AttrList.Value(i) + '"';

    if _Children.Count <= 0 then
        x := x + '/>'
    else begin
        // iterate over all the children
        x := x + '>';
        for i := 0 to _Children.Count - 1 do
            x := x + TXMLNode(_Children[i]).xml;
        x := x + '</' + Self.name + '>';
        end;
    Result := x;
end;

{---------------------------------------}
procedure TXMLTag.AssignTag(const xml: TXMLTag);
var
    i: integer;
    t, c: TXMLTag;
begin
    // Make this tag be a duplicate of the old one.

    for i := 0 to _Children.Count - 1 do begin
        t := TXMLTag(_Children.Items[i]);
        c := xml.AddTag(t.name);
        c.AssignTag(t);
        end;

    for i := 0 to _AttrList.Count - 1 do begin
        end;

end;


{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
constructor TXPMatch.Create;
begin
    inherited Create;
    _AttrList := TAttrList.Create();
    tag_name := '';
end;

destructor TXPMatch.Destroy;
begin
    //
    _AttrList.Free;
    inherited Destroy;
end;

procedure TXPMatch.putAttribute(name, value: string);
var
    pair: TAttr;
begin
    //
    pair := TAttr.Create(name, value);
    _AttrList.Add(pair);
end;

function TXPMatch.getAttribute(i: integer): TAttr;
begin
    if ((i >= 0) and (i < _AttrList.Count)) then
        Result := TAttr(_AttrList.Node(i))
    else
        Result := nil;
end;

function TXPMatch.GetAttrCount: integer;
begin
    Result := _AttrList.Count;
end;

procedure TXPMatch.Parse(xps: string);
var
    l, i, s, s2: integer;
    state: integer;
    xp, q, name, val, c, cur: string;
begin
    // parse the /foo[@a="b"][@c="d"] stuff
    i := 2;
    xp := Trim(xps);
    l := Length(xp);
    state := 0;
    cur := '';
    while (i <= l) do begin
        c := xp[i];
        if (c = '[') then begin
            if (state = 0) then
                tag_name := cur;
            inc(i); // should be pointing to '@'
            inc(i); // should be pointing to first letter of attr
            s := i;
            while ((i <= l) and (xp[i] <> '=')) do
                inc(i);
            name := Copy(xp, s, (i-s));

            inc(i); // point to "
            s2 := i;
            q := xp[i];
            inc(i); // point to first letter
            while ((i <= l) and (xp[i] <> q)) do
                inc(i);
            val := TrimQuotes(Copy(xp, s2, (i-s2) + 1));
            PutAttribute(name, val);
            state := 1;
            inc(i);
            end
        else if (state = 0) then
            cur := cur + c;
        inc(i);
        end;

    if (state = 0) then
        tag_name := cur;
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TXPLite.Create;
begin
    inherited Create;
    tags := TStringList.Create;
    attr := '';
    value := '';

    Matches := TStringList.Create;
end;

{---------------------------------------}
destructor TXPLite.Destroy;
begin
    tags.Free;

    inherited Destroy;
end;

{---------------------------------------}
procedure TXPLite.Parse(xps: string);
var
    s, l, i, f: integer;
    c, cur: string;
    m: TXPMatch;
begin
    // parse the /foo/bar[@xmlns="jabber:iq:roster"] string
    matches.Clear;
    s := 1;
    i := 2;
    l := Length(xps);
    cur := '';
    c := '';
    while (i <= l) do begin
        c := xps[i];
        if ((c = '"') or (c = Chr(39))) then begin
            // we are in a quote sequence, find the matching quote
            f := i + 1;
            while ((f <= l) and (xps[f] <> c)) do
                inc(f);
            if (f <= l) then
                i := f;
            end
        else if ((c = '/') or (i = l)) then begin
            // we've reached a seperator
            if c = '/' then
                cur := Copy(xps, s, (i-s))
            else
                cur := Copy(xps, s, (i - s) + 1);
            s := i;
            m := TXPMatch.Create;
            m.parse(cur);
            Matches.AddObject(m.tag_name, m)
            end;
        inc(i);
        end;
end;

{---------------------------------------}
function TXPLite.Compare(Tag: TXMLTag): boolean;
var
    a, i: integer;
    t: TXMLTag;
    wild_card: boolean;
    tmps: string;
    cm: TXPMatch;
    ca: TAttr;
begin

    if (Matches.Count <= 0) then begin
        Result := true;
        exit;
        end;

    i := 0;
    Result := true;
    t := Tag;
    while (i < Matches.Count) do begin
        cm := TXPMatch(Matches.Objects[i]);

        // check tag names
        if (t = nil) then
            // do nothing
        else if (t.Name <> cm.tag_name) then begin
            Result := false;
            exit;
            end
        else begin
            // Check attribs
            for a := 0 to cm.AttrCount - 1 do begin
                ca := cm.getAttribute(a);
                wild_card := (Copy(ca.Value, length(ca.Value), 1) = '*');
                if wild_card then begin
                    tmps := ca.Value;
                    Delete(tmps, length(tmps), 1);
                    if (Pos(tmps, t.getAttribute(ca.Name)) <= 0) then begin
                        Result := false;
                        exit;
                        end;
                    end
                else begin
                    if (t.getAttribute(ca.name) <> ca.Value) then begin
                        Result := false;
                        exit;
                        end;
                    end;
                end;
            end;

        // if we get here, we matched any + all attribs,
        // so fetch the next tag
        inc(i);
        if (i >= Matches.Count) then
            t := nil
        else begin
            cm := TXPMatch(Matches.Objects[i]);
            t := t.GetFirstTag(cm.tag_name)
            end;
        end;

    ////////////////////////////////////////////////
    {
    if ((tags.Count <= 0) and (attr = '')) then begin
        Result := true;
        exit;
        end;

    if (tags[0] = Tag.Name) then begin
        t := Tag;

        // walk the nodes for tag matches
        for i := 1 to tags.Count - 1 do begin
            t := t.GetFirstTag(tags[i]);
            if (t = nil) then break;
            end;

        // check the last tag for a specific attribute if specifed
        if ((t <> nil) and (attr <> '') and (value <> '')) then begin
            wild_card := (Copy(value, length(value), 1) = '*');
            if wild_card then begin
                tmps := value;
                Delete(tmps, length(tmps), 1);
                if (Pos(tmps, t.getAttribute(attr)) <= 0) then
                    t := nil;
                end
            else begin
                if (t.getAttribute(attr) <> value) then
                    t := nil;
                end;
            end;

        Result := (t <> nil);
        end;
    }
end;

{---------------------------------------}
function TXPLite.GetString: string;
var
    i: integer;
begin
    Result := '';
    for i := 0 to tags.Count - 1 do
        Result := Result + '/' + tags[i];

    if ((attr <> '') and (value <> '')) then
        Result := Result + '@' + attr + '="' + value + '"';
end;


end.
