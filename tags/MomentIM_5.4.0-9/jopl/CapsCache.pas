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
    Entity, JabberID, XMLTag, Unicode, Classes, SysUtils;

type
    TJabberCapsEntity = class(TJabberEntity)
    private
        _ver: Widestring;
        _hash: Widestring;
        _verified: Boolean;

    protected
        constructor Create(jid: TJabberID; node: Widestring; hash: Widestring = '');

        procedure ProcessSpecifiedInfo(tag: TXMLTag); override;
        function CalculateHash(): Widestring; virtual;
    public
        destructor Destroy(); override;

        property Hash: Widestring read _hash;
        property Verified: Boolean read _verified;
    end;

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
    PrefController, XMLParser, SecHash, IdCoderMIME,
    DiscoIdentity, JabberUtils, EntityCache, JabberConst, Session;

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
    if (event = DEPMOD_READY_SESSION_EVENT) then
    begin
        Load();
        TJabberSession(_js).FireEvent(DEPMOD_READY_EVENT + DEPMOD_CAPS_CACHE, tag);
    end
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
    e: TJabberCapsEntity;
    iq, q, cur, cache: TXMLTag;
    s: TWidestringlist;
begin
    if (_cache.Count = 0) then exit;

    cache := TXMLTag.Create('caps-cache');

    for c := 0 to _cache.Count - 1 do begin
        e := TJabberCapsEntity(_cache.Objects[c]);

        if ((not e.hasInfo) or (e.discoInfoError)) then continue;
        if ((not e.Verified) and not TJabberSession(_js).Prefs.getBool('brand_caps_cacheuntrusted')) then continue;

        iq := cache.AddTag('iq');
        iq.setAttribute('from', 'caps-cache');
        iq.setAttribute('capid', _cache[c]);
        if (e.Verified) then iq.setAttribute('hash', e.Hash);

        q := iq.AddTagNS('query', XMLNS_DISCOINFO);
        for i := 0 to e.IdentityCount - 1 do begin
            di := e.Identities[i];
            cur := q.AddTag('identity');
            cur.setAttribute('category', di.Category);
            cur.setAttribute('type', di.DiscoType);
            cur.setAttribute('name', di.RawName);
            if (di.Language <> '') then cur.setAttribute('xml:lang', di.Language);
        end;

        for f := 0 to e.FeatureCount - 1 do begin
            cur := q.AddTag('feature');
            cur.setAttribute('var', e.Features[f]);
        end;

        for f := 0 to e.FormCount - 1 do begin
            q.addInsertedXML(e.Forms[f].XML);
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
    capid, from, hash: Widestring;
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
        hash := iq.getAttribute('hash');
        from := 'caps-cache';

        if ((capid = '') or (from = '')) then continue;
        if ((hash = '') and not TJabberSession(_js).Prefs.getBool('brand_caps_cacheuntrusted')) then continue;

        e := jEntityCache.getByJid(from, capid);
        if (not e.InheritsFrom(TJabberCapsEntity)) then begin
            jEntityCache.Remove(e);
            e.Free();
            e := nil;
        end;
        if (e = nil) then begin
            //e := TJabberEntity.Create(TJabberID.Create(from), capid, ent_cached_disco);
            e := TJabberCapsEntity.Create(TJabberID.Create(from), capid, hash);
            jEntityCache.Add(from, e);
        end;
        e.LoadInfo(iq);
        _cache.AddObject(capid, e);
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

    function getCache(capid, hash: Widestring; jid: TJabberID): TJabberEntity;
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
            //cache := jEntityCache.discoInfo(jid.full, TJabberSession(_js), capid);
            
            //TODO:  create caps-specific Entity object
            cache := TJabberCapsEntity.Create(jid, capid, hash);
            jEntityCache.Add(jid.full, cache);
            _cache.AddObject(capid, cache);
            
            cache.getInfo(TJabberSession(_js));
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
    node, cid, capid, ver, hash: Widestring;
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

    OR like this:

    <presence from='pgvantek@aol.com'
        to='pmillard@corp.jabber.com/Jinx-pgm'
        type='subscribed'>
        <c  node='http://jabber.com/aim'
            ver='q1elkfdslvnq2ein2klvenl12//=='
            hash='sha-1'
            xmlns='http://jabber.org/protocol/caps'/>
        <priority>0</priority>
    </presence>
    }

    c := tag.QueryXPTag(_xp);
    assert(c <> nil);

    node := c.GetAttribute('node');
    ver := c.getAttribute('ver');
    hash := c.getAttribute('hash');
    capid := node + '#' + ver;
    cid := capid;

    from := TJabberID.Create(tag.getAttribute('from'));
    //make sure we aren't trying to query a conf server...
    e := jEntityCache.getByJid(from.domain);
    if (e = nil) or (not e.hasFeature(FEAT_GROUPCHAT)) then 
    begin
        e := jEntityCache.getByJid(from.full);
        if (e = nil) then begin
            e := TJabberEntity.Create(TJabberID.Create(from));
            jEntityCache.Add(from.full, e);
        end;

        e.ClearReferences(); //refs will be rebuilt here

        cache := getCache(capid, hash, from);
        e.AddReference(cache);
        has_info := checkInfo(cache, cid, from);

        //TODO:  differentiate between 'ext' and 'hash' (one or the other)
        //NOTE:  we *might* trust persisting of this caps if hash is present
        //NOTE:  we *never* trust persisting if no hash
        exts := c.GetAttribute('ext');
        if (exts <> '') then begin
            ids := TWidestringlist.Create();
            split(exts, ids, ' ');
            for i := 0 to ids.count - 1 do begin
                capid := node + '#' + ids[i];
                cache := getCache(capid, '', from);
                has_info := (has_info and checkInfo(cache, capid, from));
                e.AddReference(cache);
            end;
            ids.Free();
        end;

        if (has_info) then
            fireCaps(from.full, cid);
    end;

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


{--------------------------}
{--------------------------}
{--------------------------}
constructor TJabberCapsEntity.Create(jid: TJabberID; node: Widestring; hash: Widestring);
var
    idx: Integer;
begin
    inherited Create(jid, node, ent_disco);

    _hash := hash;
    if (hash <> '') then begin
        idx := AnsiPos('#', node);
        if (idx <> 0) then
            _ver := Copy(node, idx + 1, Length(node));
    end;
end;

{--------------------------}
destructor TJabberCapsEntity.Destroy;
begin
    inherited;
end;

{--------------------------}
procedure TJabberCapsEntity.ProcessSpecifiedInfo(tag: TXMLTag);
begin
    inherited ProcessSpecifiedInfo(tag);

    //TODO:  process hash
    if not Verified and (Hash <> '') then begin
        _verified := CalculateHash() = _ver;
    end;
end;

function TJabberCapsEntity.CalculateHash(): Widestring;
var
    Str: Widestring;
    idx: Integer;
    ident: TDiscoIdentity;

    function EncodeForm(form: TXMLTag): Widestring;
    var
        fvar: Widestring;
        field: TXMLTag;
        fset: TXMLTagList;
        fsorted, vsorted: TWidestringList;
        idx, jdx: Integer;
    begin
        Result := '';

        fsorted := TWidestringList.Create();
        fsorted.Sorted := true;
        fsorted.Duplicates := dupAccept;

        vsorted := TWidestringList.Create();
        vsorted.Sorted := true;
        vsorted.Duplicates := dupAccept;

        //sort fields
        fset := form.QueryTags('field');
        for idx := 0 to fset.Count - 1 do begin
            field := fset[idx];
            fvar := field.getAttribute('var');
            if (fvar = 'FORM_TYPE') then
                Result := field.QueryXPData('value') + '<'
            else
                fsorted.AddObject(fvar, field);
        end;
        fset.Free();

        //process fields
        for idx := 0 to fsorted.Count - 1 do begin
            //sort values
            field := TXMLTag(fsorted.Objects[idx]);
            fset := field.QueryTags('value');
            for jdx := 0 to fset.Count - 1 do begin
                vsorted.Add(fset[jdx].Data);
            end;
            fset.Free();

            //process values
            Result := Result + fsorted[idx] + '<';
            for jdx := 0 to vsorted.Count - 1 do begin
                Result := Result + vsorted[jdx] + '<';
            end;
            vsorted.Clear();
        end;

        //Cleanup
        vsorted.Free();
        fsorted.Free();
    end;

    function GenHashSHA1(input: Widestring): Widestring;
    var
        sha1: TSecHash;
        b64: TIdEncoderMIME;
        tmp: String;
        idx: Integer;
        h: TByteDigest;
    begin
        tmp := UTF8Encode(input);

        sha1 := TSecHash.Create(nil);
        h := sha1.IntDigestToByteDigest(sha1.computeString(tmp));
        sha1.Free();

        tmp := '';
        for idx := 0 to 19 do tmp := tmp + Chr(h[idx]);
        b64 := TIdEncoderMIME.Create(nil);
        result := b64.encode(tmp);
        b64.Free();
    end;
begin
    Str := '';

    //include identities
    for idx := 0 to IdentityCount - 1 do begin
        ident := Identities[idx];
        Str := Str + ident.Category + '/' + ident.DiscoType + '/' + ident.Language + '/' + ident.RawName + '<';
    end;

    //include features
    for idx := 0 to FeatureCount - 1 do begin
        Str := Str + Features[idx] + '<';
    end;

    //include forms
    for idx := 0 to FormCount - 1 do begin
        Str := Str + EncodeForm(Forms[idx]);
    end;

    if Hash = 'sha-1' then begin
        Result := GenHashSHA1(Str);
    end
    else begin
        Result := '';
    end;
end;

initialization
    jCapsCache := TJabberCapsCache.Create();

finalization
    FreeAndNil(jCapsCache);

end.

