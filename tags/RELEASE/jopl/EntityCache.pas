unit EntityCache;
{
    Copyright 2003, Peter Millard

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
    JabberID, Entity, Session, Unicode, Classes, SysUtils;

type
    TJabberEntityCache = class
    private
        _cache: TWidestringlist;

        function _getEntity(i: integer): TJabberEntity;

    public
        constructor Create();
        destructor Destroy(); override;

        procedure Clear();
        procedure Add(jid: Widestring; e: TJabberEntity);
        procedure Remove(e: TJabberEntity);
        procedure Delete(i: integer);

        function getByJid(jid: Widestring; node: Widestring = ''): TJabberEntity;
        function fetch(jid: Widestring; js: TJabberSession;
            items_limit: boolean = true; node: Widestring = ''): TJabberEntity;

        function getFirstFeature(f: Widestring): TJabberEntity;
        function getFirstSearch(): Widestring;
        function getFirstGroupchat(): Widestring;

        {$ifdef Exodus}
        procedure getByFeature(f: Widestring; jid_list: TWidestringList); overload;
        procedure getByFeature(f: Widestring; jid_list: TTntStrings); overload;
        {$else}
        procedure getByFeature(f: Widestring; jid_list: TWidestringList);
        {$endif}

        function indexOf(e: TJabberEntity): integer;
        property Entities[index: integer]: TJabberEntity read _getEntity;
    end;

var
    jEntityCache: TJabberEntityCache;

function EntityJidCompare(Item1, Item2: Pointer): integer;
function EntityNameCompare(Item1, Item2: Pointer): integer;
function EntityCatCompare(Item1, Item2: Pointer): integer;
function EntityDomainCompare(Item1, Item2: Pointer): integer;

function EntityJidCompareRev(Item1, Item2: Pointer): integer;
function EntityNameCompareRev(Item1, Item2: Pointer): integer;
function EntityCatCompareRev(Item1, Item2: Pointer): integer;
function EntityDomainCompareRev(Item1, Item2: Pointer): integer;


implementation
uses
    XMLUtils;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function _entityCompare(cur_sort: integer; ascending: boolean; Item1, Item2: Pointer): integer;
var
    j1, j2: TJabberEntity;
    s1, s2, s3, s4: Widestring;
begin
    // compare 2 items..
    if (cur_sort = -1) then begin
        Result := 0;
        exit;
    end;

    j1 := TJabberEntity(Item1);
    j2 := TJabberEntity(Item2);
    s3 := '';
    s4 := '';

    case (cur_sort) of
    0: begin
        s1 := j1.name;
        s2 := j2.name;
        end;
    1: begin
        s1 := j1.jid.full;
        s2 := j2.jid.full;
        end;
    2: begin
        s1 := j1.catType;
        s2 := j2.catType;
        end;
    3: begin
        s1 := j1.jid.domain;
        s2 := j2.jid.domain;
        s3 := j1.jid.user;
        s4 := j2.jid.user;
        end
    else begin
        Result := 0;
        exit;
        end;
    end;

    if (ascending) then
        Result := AnsiCompareText(s1, s2)
    else
        Result := AnsiCompareText(s2, s1);

    if ((Result = 0) and (s3 <> '') and (s4 <> '')) then begin
        if (ascending) then
            Result := AnsiCompareText(s3, s4)
        else
            Result := AnsiCompareText(s4, s3);
    end;

end;


// Just call _entityCompare
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function EntityJidCompare(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(1, true, Item1, Item2);
end;
function EntityNameCompare(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(0, true, Item1, Item2);
end;
function EntityCatCompare(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(2, true, Item1, Item2);
end;
function EntityJidCompareRev(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(1, false, Item1, Item2);
end;
function EntityNameCompareRev(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(0, false, Item1, Item2);
end;
function EntityCatCompareRev(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(2, false, Item1, Item2);
end;
function EntityDomainCompare(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(3, true, Item1, Item2);
end;
function EntityDomainCompareRev(item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(3, false, Item1, Item2);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberEntityCache.Create();
begin
    _cache := TWidestringlist.Create();
    _cache.CaseSensitive := true;
    _cache.Duplicates := dupAccept;
end;

{---------------------------------------}
destructor TJabberEntityCache.Destroy();
begin
    Clear();
    _cache.Free();
end;

{---------------------------------------}
procedure TJabberEntityCache.Clear();
var
    ce: TJabberEntity;
    i: integer;
begin
    for i := _cache.Count - 1 downto 0 do begin
        ce := TJabberEntity(_cache.Objects[i]);
        _cache.Objects[i] := nil;
        if ((ce <> nil) and (ce.Parent = nil)) then
            ce.Free();
    end;
    _cache.Clear();
end;

{---------------------------------------}
procedure TJabberEntityCache.Add(jid: Widestring; e: TJabberEntity);
begin
    _cache.AddObject(jid, e);
end;

{---------------------------------------}
procedure TJabberEntityCache.Remove(e: TJabberEntity);
var
    i: integer;
begin
    i := indexOf(e);
    if (i >= 0) then
        _cache.Delete(i);
end;

{---------------------------------------}
procedure TJabberEntityCache.Delete(i: integer);
begin
    if ((i >= 0) and (i < _cache.Count)) then
        _cache.Delete(i);
end;

{---------------------------------------}
function TJabberEntityCache.indexOf(e: TJabberEntity): integer;
begin
    Result := _cache.IndexOfObject(e);
end;

{---------------------------------------}
function TJabberEntityCache._getEntity(i: integer): TJabberEntity;
begin
    if (i < _cache.Count) then
        Result := TJabberEntity(_cache.Objects[i])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberEntityCache.getByJid(jid: Widestring; node: Widestring): TJabberEntity;
var
    cur: TJabberEntity;
    i: integer;
begin
    i := _cache.IndexOf(jid);
    if (i >= 0) then begin
        Result := nil;
        cur := TJabberEntity(_cache.Objects[i]);
        if (node <> '') then begin
            while (Result = nil) do begin
                if ((node = cur.Node) and (cur.Jid.jid = jid)) then begin
                    // we found a match
                    Result := cur;
                    break;
                end
                else if (cur.jid.jid <> jid) then
                    // we found the next jid, so no match
                    break;
                inc(i);
                if (i >= _cache.Count) then break;
                cur := TJabberEntity(_cache.Objects[i]);
            end;
        end
        else
            Result := cur;
    end
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberEntityCache.fetch(jid: Widestring; js: TJabberSession;
    items_limit: boolean; node: Widestring): TJabberEntity;
var
    i: integer;
    e: TJabberEntity;
begin
    e := getByJid(jid, node);
    if (e <> nil) then begin
        Result := e;

        if (e.hasItems and e.hasInfo) then begin
            // This fires all the events..
            e.getInfo(js);
            e.getItems(js);
            for i := 0 to e.ItemCount - 1 do
                e.Items[i].getInfo(js);
        end
        else
            // Re-walk since we don't have all the info.
            e.walk(js, items_limit);

        exit;
    end;

    e := TJabberEntity.Create(TJabberID.Create(jid), node);
    _cache.AddObject(jid, e);

    e.walk(js, items_limit);
    Result := e;
end;

{---------------------------------------}
function TJabberEntityCache.getFirstFeature(f: Widestring): TJabberEntity;
var
    c: TJabberEntity;
    i: integer;
begin
    Result := nil;
    for i := 0 to _cache.Count - 1 do begin
        c := TJabberEntity(_cache.Objects[i]);
        if (c.hasFeature(f)) then begin
            Result := c;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TJabberEntityCache.getFirstSearch(): Widestring;
var
    e: TJabberEntity;
begin
    e := getFirstFeature(FEAT_SEARCH);
    if (e <> nil) then
        Result := e.jid.full
    else
        Result := '';
end;

{---------------------------------------}
function TJabberEntityCache.getFirstGroupchat(): Widestring;
var
    e: TJabberEntity;
begin
    e := getFirstFeature(FEAT_GROUPCHAT);
    if (e <> nil) then
        Result := e.jid.full
    else
        Result := '';
end;

{---------------------------------------}
procedure TJabberEntityCache.getByFeature(f: Widestring; jid_list: TWidestringList);
var
    i: integer;
    e: TJabberEntity;
begin
    for i := 0 to _cache.Count -1  do begin
        e := TJabberEntity(_cache.Objects[i]);
        if (e.hasFeature(f)) then
            jid_list.Add(e.jid.full);
    end;
end;

{$ifdef Exodus}
procedure TJabberEntityCache.getByFeature(f: Widestring; jid_list: TTntStrings);
var
    i: integer;
    e: TJabberEntity;
begin
    for i := 0 to _cache.Count -1  do begin
        e := TJabberEntity(_cache.Objects[i]);
        if (e.hasFeature(f)) then
            jid_list.Add(e.jid.full);
    end;
end;
{$endif}


initialization
    jEntityCache := TJabberEntityCache.Create();

finalization
    jEntityCache.Free();


end.
