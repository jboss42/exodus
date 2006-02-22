unit CapsCache;
{
    Copyright 2006, Peter Millard

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
    {$ifdef Exodus}
    TntClasses,
    {$endif}
    XMLTag, Unicode, Classes, SysUtils;

type
    TJabberCapsCache = class
    private
        _xp: TXPLite;
        _js: TObject;
        _cache: TWidestringlist;

    published
        procedure PresCallback(event: string; tag: TXMLTag);
        procedure SessionCallback(event: string; tag: TXMLTag);

    public
        constructor Create();
        destructor Destroy(); override;

        procedure SetSession(js: TObject);

        procedure Clear();
        procedure Save(filename: Widestring);
        procedure Load(filename: Widestring);
    end;

var
    jCapsCache: TJabberCapsCache;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    XMLParser, 
    DiscoIdentity, JabberUtils, JabberID, Entity, EntityCache, JabberConst, Session;

{---------------------------------------}
constructor TJabberCapsCache.Create();
begin
    _cache := TWidestringlist.Create();
    _xp := TXPLite.Create('/presence/c[@xmlns="' + XMLNS_CAPS + '"]');
end;

{---------------------------------------}
destructor TJabberCapsCache.Destroy();
begin
    _cache.Free();
end;

{---------------------------------------}
procedure TJabberCapsCache.SetSession(js: TObject);
begin
    _js := js;
    assert(js is TJabberSession);
    TJabberSession(js).RegisterCallback(PresCallback,
        '/packet/presence/c[@xmlns="' + XMLNS_CAPS + '"]');
    TJabberSession(js).RegisterCallback(SessionCallback, '/session');
end;

{---------------------------------------}
procedure TJabberCapsCache.SessionCallback(event: string; tag: TXMLTag);
begin
    //
end;

{---------------------------------------}
procedure TJabberCapsCache.Clear();
begin
    _cache.Clear();
end;

{---------------------------------------}
procedure TJabberCapsCache.Save(filename: Widestring);
var
    c, f, i: integer;
    di: TDiscoIdentity;
    e: TJabberEntity;
    iq, q, cur, cache: TXMLTag;
    s: TWidestringlist;
begin
    if (_cache.Count = 0) then exit;

    cache := TXMLTag.Create('caps-cache');

    for c := 0 to _cache.Count - 1 do begin
        e := TJabberEntity(_cache.Objects[c]);
        iq := cache.AddTag('iq');
        iq.setAttribute('from', e.Jid.full);
        iq.setAttribute('capid', _cache[c]);
        
        q := iq.AddTagNS('query', XMLNS_DISCOINFO);
        for i := 0 to e.IdentityCount - 1 do begin
            di := e.Identities[i];
            cur := q.AddTag('identity');
            cur.setAttribute('category', di.Category);
            cur.setAttribute('type', di.DiscoType);
        end;

        for f := 0 to e.FeatureCount - 1 do begin
            cur := q.AddTag('feature');
            cur.setAttribute('var', e.Features[f]);
        end;
    end;

    s := TWidestringlist.Create();
    s.Add(cache.xml);
    s.SaveToFile(filename);
    s.Free();

    cache.Free();
end;

{---------------------------------------}
procedure TJabberCapsCache.Load(filename: Widestring);
var
    e: TJabberEntity;
    i: integer;
    parser: TXMLTagParser;
    iq, cache: TXMLTag;
    iqs: TXMLTagList;
    capid, from: Widestring;
begin
    parser := TXMLTagParser.Create();
    parser.ParseFile(filename);

    if (parser.Count = 0) then begin
        parser.Free();
        exit;
    end;

    cache := parser.popTag();
    assert(cache <> nil);

    iqs := cache.ChildTags();
    for i := 0 to iqs.Count - 1 do begin
        iq := iqs.Tags[i];
        capid := iq.GetAttribute('capid');
        from := iq.GetAttribute('from');
        if ((capid <> '') and (from <> '')) then begin
            e := jEntityCache.getByJid(from, capid);
            if (e = nil) then begin
                e := TJabberEntity.Create(TJabberID.Create(from), capid);
                jEntityCache.Add(from, e);
            end;
            e.LoadInfo(iq);
            _cache.AddObject(capid, e);
        end;
    end;

    iqs.Free();
    cache.Free();
    parser.Free();

end;

{---------------------------------------}
procedure TJabberCapsCache.PresCallback(event: string; tag: TXMLTag);

    function getCache(capid: Widestring; jid: TJabberID): TJabberEntity;
    var
        cache: TJabberEntity;
        idx: integer;
    begin
        idx := _cache.IndexOf(capid);
        if (idx >= 0) then begin
            // we've already queried for this entry, just associate the results
            // with this user's entity
            cache := TJabberEntity(_cache.Objects[idx]);
        end
        else begin
            // this is something new, query for it.
            cache := jEntityCache.discoInfo(jid.full, TJabberSession(_js), capid);
            _cache.AddObject(capid, cache);
        end;

        Result := cache;
    end;

var
    i: integer;
    cache, e: TJabberEntity;
    c: TXMLTag;
    exts: Widestring;
    from: TJabberID;
    node, capid: Widestring;
    ids: TWidestringlist;
begin
    if (event <> 'xml') then exit;

    // we get presence packets like this:
    {
    <presence from='pgvantek@aol.com'
        to='pmillard@corp.jabber.com/Jinx-pgm'
        type='subscribed'>
        <c  node='http://jabber.com/aim'
            ver='1.0.1.5'
            xmlns='http://jabber.org/protocol/caps'/>
        <priority>0</priority>
    </presence>
    }

    c := tag.QueryXPTag(_xp);
    assert(c <> nil);

    node := c.GetAttribute('node');
    capid := node + '#' + c.getAttribute('ver');

    from := TJabberID.Create(tag.getAttribute('from'));
    e := jEntityCache.getByJid(from.full);
    if (e = nil) then begin
        e := TJabberEntity.Create(from);
        jEntityCache.Add(from.full, e);
    end;

    cache := getCache(capid, from);
    e.AddReference(cache);

    exts := c.GetAttribute('ext');
    if (exts <> '') then begin
        ids := TWidestringlist.Create();
        split(exts, ids, ' ');

        for i := 0 to ids.count - 1 do begin
            capid := node + '#' + ids[i];
            cache := getCache(capid, from);
            e.AddReference(cache);
        end;
    end;

end;


initialization
    jCapsCache := TJabberCapsCache.Create();

finalization
    FreeAndNil(jCapsCache);

end.

