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

    public
        constructor Create();
        destructor Destroy(); override;

        procedure Add(jid: Widestring; e: TJabberEntity);

        function getByJid(jid: Widestring): TJabberEntity;
        function walk(jid: Widestring; js: TJabberSession): TJabberEntity;

        function getFirstFeature(f: Widestring): TJabberEntity;
        function getFirstSearch(): Widestring;
        function getFirstGroupchat(): Widestring;

        {$ifdef Exodus}
        procedure getByFeature(f: Widestring; jid_list: TWidestringList); overload;
        procedure getByFeature(f: Widestring; jid_list: TTntStrings); overload;
        {$else}
        procedure getByFeature(f: Widestring; jid_list: TWidestringList);
        {$endif}
    end;

var
    jEntityCache: TJabberEntityCache;

implementation
uses
    XMLUtils;

{---------------------------------------}
constructor TJabberEntityCache.Create();
begin
    _cache := TWidestringlist.Create();
end;

{---------------------------------------}
destructor TJabberEntityCache.Destroy();
begin
    // XXX: make an entity walker so that each child isn't in the cache
    //ClearStringlistObjects(_cache);
    _cache.Free();
end;

{---------------------------------------}
procedure TJabberEntityCache.Add(jid: Widestring; e: TJabberEntity);
begin
    _cache.AddObject(jid, e);
end;

{---------------------------------------}
function TJabberEntityCache.getByJid(jid: Widestring): TJabberEntity;
var
    i: integer;
begin
    i := _cache.IndexOf(jid);
    if (i >= 0) then
        Result := TJabberEntity(_cache.Objects[i])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberEntityCache.walk(jid: Widestring; js: TJabberSession): TJabberEntity;
var
    i: integer;
    e: TJabberEntity;
begin
    e := getByJid(jid);
    if (e <> nil) then begin
        Result := e;

        // This fires all the events..
        e.getInfo(js);
        e.getItems(js);
        for i := 0 to e.ItemCount - 1 do
            e.Items[i].getInfo(js);

        exit;
    end;
    e := TJabberEntity.Create(TJabberID.Create(jid));
    e.walk(js);
    _cache.AddObject(jid, e);
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
