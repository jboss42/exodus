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
    Entity, XMLTag, Unicode, Classes, SysUtils;

type

    TJabberCapsPending = class
    public
        capsid: Widestring;
        jids: TWidestringlist;
        constructor Create(cid: Widestring);
        destructor Destroy(); override;
    end;

    TJabberCapsCache = class
    private
        _xp: TXPLite;
        _xp_q: TXPLite;
        _js: TObject;
        _cache: TWidestringlist;
        _pending: TWidestringlist;

        procedure addPending(ejid, node, caps_jid: Widestring);
        procedure fireCaps(jid, capid: Widestring);

    public
        constructor Create();
        destructor Destroy(); override;

        procedure SetSession(js: TObject);

        function find(capid: Widestring): TJabberEntity;

        procedure Clear();
        procedure Save(filename: Widestring = '');
        procedure Load(filename: Widestring = '');

        procedure PresCallback(event: string; tag: TXMLTag);
        procedure SessionCallback(event: string; tag: TXMLTag);

        function toString(): widestring;
    end;

var
    jCapsCache: TJabberCapsCache;

const
    capsFilename = 'capscache.xml';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    PrefController, XMLParser,
    DiscoIdentity, JabberUtils, JabberID, EntityCache, JabberConst, Session;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberCapsPending.Create(cid: Widestring);
begin
    jids := TWidestringlist.Create();
    capsid := cid;
end;

{---------------------------------------}
destructor TJabberCapsPending.Destroy();
begin
    jids.Free();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberCapsCache.Create();
begin
    _cache := TWidestringlist.Create();
    _pending := TWidestringlist.Create();
    _xp := TXPLite.Create('/presence/c[@xmlns="' + XMLNS_CAPS + '"]');
    _xp_q := TXPLite.Create('/iq/query[@xmlns="' + XMLNS_DISCOINFO + '"]');
end;

{---------------------------------------}
destructor TJabberCapsCache.Destroy();
begin
    _cache.Free();
    _pending.Free();
    _xp.Free();
    _xp_q.Free();
end;

{---------------------------------------}
procedure TJabberCapsCache.SetSession(js: TObject);
begin
    _js := js;
    assert(js is TJabberSession);
    TJabberSession(js).RegisterCallback(PresCallback,
        '/packet/presence[@type!="error"]/c[@xmlns="' + XMLNS_CAPS + '"]');
    TJabberSession(js).RegisterCallback(SessionCallback, '/session');
end;

{---------------------------------------}
procedure TJabberCapsCache.SessionCallback(event: string; tag: TXMLTag);
var
    i, idx: integer;
    p: TJabberCapsPending;
    key: Widestring;
    q: TXMLTag;
begin
    // Save when we get disconnected, and load when we get auth'd
    if (event = '/session/authenticated') then
        Load()
    else if (event = '/session/disconnected') then
        Save()
    else if ((event = '/session/entity/info') and (tag <> nil)) then begin
        // check to see if this is in our pending list
        q := tag.QueryXPTag(_xp_q);
        if (q = nil) then exit;

        // key into pending is from#node
        key := tag.getAttribute('from') + '#' + q.GetAttribute('node');
        idx := _pending.IndexOf(key);
        if (idx = -1) then exit;

        p := TJabberCapsPending(_pending.Objects[idx]);
        for i := 0 to p.jids.Count - 1 do
            fireCaps(p.jids[i], p.capsid);
        p.Free();
        _pending.Delete(idx);
    end;
end;

{---------------------------------------}
procedure TJabberCapsCache.addPending(ejid, node, caps_jid: Widestring);
var
    key: Widestring;
    p: TJabberCapsPending;
    idx: integer;
begin
    // key into pending is from#node
    key := ejid + '#' + node;
    idx := _pending.IndexOf(key);
    if (idx = -1) then begin
        p := TJabberCapsPending.Create(node);
        _pending.AddObject(key, p);
    end
    else
        p := TJabberCapsPending(_pending.Objects[idx]);

    idx := p.jids.IndexOf(caps_jid);
    if (idx = -1) then
        p.jids.Add(caps_jid);
end;

{---------------------------------------}
procedure TJabberCapsCache.Clear();
begin
    _cache.Clear();
    _pending.Clear();
end;

{---------------------------------------}
procedure TJabberCapsCache.Save(filename: Widestring = '');
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

        if ((e.hasInfo) and (not e.discoInfoError)) then begin
            iq := cache.AddTag('iq');
            iq.setAttribute('from', 'caps-cache');
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
    end;

    s := TWidestringlist.Create();
    s.Add(cache.xml);

    if (filename = '') then
        filename := getUserDir() + capsFilename;

    s.SaveToFile(filename);
    s.Free();

    cache.Free();
end;

{---------------------------------------}
procedure TJabberCapsCache.Load(filename: Widestring = '');
var
    e: TJabberEntity;
    i: integer;
    parser: TXMLTagParser;
    iq, cache: TXMLTag;
    iqs: TXMLTagList;
    capid, from: Widestring;
begin
    parser := TXMLTagParser.Create();

    if (filename = '') then
        filename := getUserDir() + capsFilename;
    if (not FileExists(filename)) then exit;

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
        from := 'caps-cache';
        if ((capid <> '') and (from <> '')) then begin
            e := jEntityCache.getByJid(from, capid);
            if (e = nil) then begin
                e := TJabberEntity.Create(TJabberID.Create(from), capid, ent_cached_disco);
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
function TJabberCapsCache.find(capid: Widestring): TJabberEntity;
var
    idx: integer;
begin
    Result := nil;
    idx := _cache.IndexOf(capid);
    if (idx >= 0) then
        Result := TJabberEntity(_cache.Objects[idx]);
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

    function checkInfo(cache: TJabberEntity; capid: Widestring; jid: TJabberID): boolean;
    begin
        Result := cache.hasInfo;
        if (not Result) then
            addPending(cache.Jid.full, capid, jid.full);
    end;

var
    has_info: boolean;
    i: integer;
    cache, e: TJabberEntity;
    c: TXMLTag;
    exts: Widestring;
    from: TJabberID;
    node, cid, capid: Widestring;
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
    cid := capid;

    from := TJabberID.Create(tag.getAttribute('from'));
    e := jEntityCache.getByJid(from.full);
    if (e = nil) then begin
        e := TJabberEntity.Create(TJabberID.Create(from));
        jEntityCache.Add(from.full, e);
    end;

    e.ClearReferences(); //refs will be rebuilt here

    cache := getCache(capid, from);
    e.AddReference(cache);
    has_info := checkInfo(cache, cid, from);

    exts := c.GetAttribute('ext');
    if (exts <> '') then begin
        ids := TWidestringlist.Create();
        split(exts, ids, ' ');
        for i := 0 to ids.count - 1 do begin
            capid := node + '#' + ids[i];
            cache := getCache(capid, from);
            has_info := (has_info and checkInfo(cache, capid, from));
            e.AddReference(cache);
        end;
        ids.Free();
    end;

    if (has_info) then
        fireCaps(from.full, cid);

    from.Free();
end;

{---------------------------------------}
procedure TJabberCapsCache.fireCaps(jid, capid: Widestring);
var
    caps: TXMLTag;
begin
    // we have all the info for this jid, send an event.
    caps := TXMLTag.Create('caps');
    caps.setAttribute('from', jid);
    caps.setAttribute('capid', capid);
    MainSession.FireEvent('/session/caps', caps);
    caps.Free();
end;

function TJabberCapsCache.toString(): widestring;
var
    c: integer;
begin
    Result := 'Caps Cache.' + #13#10 + 'Enity Count: ' + intToStr(_cache.Count) + #13#10 + 'Entities:' + #13#10;
    for c := 0 to _cache.Count - 1 do begin
        Result := Result + #13#10 + '***** Entity#' + IntToStr(c) + ' *****' + #13#10 + TJabberEntity(_cache.Objects[c]).toString();
    end;
end;

initialization
    jCapsCache := TJabberCapsCache.Create();

finalization
    FreeAndNil(jCapsCache);

end.

