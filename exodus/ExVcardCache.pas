unit ExVcardCache;
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

uses Classes, Exodus_TLB, Unicode, XMLVCardCache, XMLTag, SyncObjs, Windows;

type
  TExVCardCache = class;

  TExVCardCacheLoader = class(TThread)
  private
    _owner: TExVCardCache;
    _list: TWidestringList;

    constructor Create(cache: TExVCardCache; data: TWidestringList);

  public
    destructor Destroy(); override;

    procedure Execute(); override;
  end;
  TExVCardCacheProc = class(TThread)
  private
    _owner: TExVCardCache;
    _queue: TList;
    _crit: TCriticalSection;

    constructor Create(cache: TExVCardCache);

  public
    destructor Destroy(); override;

    function Enque(sql: Widestring): Boolean;
    procedure Execute(); override;

  end;
  TExVCardCache = class(TXMLVCardCache)
  private
    _loader: TExVCardCacheLoader;
    _proc: TExVCardCacheProc;
    _crit: TCriticalSection;

    function GetProc(): TExVCardCacheProc;
    procedure SetProc(proc: TExVCardCacheProc);

    procedure LoadFinished();
  protected
    procedure SessionCallback(event: string; tag: TXMLTag); override;

    procedure Load(cache: TWidestringList); override;
    procedure SaveEntry(vcard: TXMLVCardCacheEntry); override;
    procedure DeleteEntry(vcard: TXMLVCardCacheEntry); override;

  public
    constructor Create(js: TObject); override;
    destructor Destroy(); override;

  end;

implementation

uses ComObj, SysUtils, Session, XMLParser, XMLUtils, SQLUtils, COMExodusDataTable, ExSession;

const
    DEPMOD_READY_EVENT = '/session/ready/';
    DEPMOD_READY_SESSION_EVENT = DEPMOD_READY_EVENT + DEPMOD_SESSION;

    VCARD_SQL_SCHEMA_TABLE: Widestring = 'CREATE TABLE vcard_cache (' +
            'jid TEXT, ' +
            'datetime FLOAT, ' +
            'xml TEXT);';
    VCARD_SQL_SCHEMA_INDEX: Widestring = 'CREATE INDEX vcard_cache_jid_idx ON vcard_cache (jid);';

    VCARD_SQL_LOAD: Widestring = 'SELECT * FROM vcard_cache;';
    VCARD_SQL_INSERT: Widestring = 'INSERT INTO vcard_cache (jid,datetime,xml) VALUES (''%s'',%8.6f,''%s'');';
    VCARD_SQL_DELETE: Widestring = 'DELETE FROM vcard_cache where (jid = ''%s'');';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TExVCardCacheLoader.Create(cache: TExVCardCache; data: TWidestringList);
begin
    inherited Create(true);

    _owner := cache;
    _list := data;
end;
{---------------------------------------}
destructor TExVCardCacheLoader.Destroy;
begin
    inherited;
end;

{---------------------------------------}
procedure TExVCardCacheLoader.Execute();
var
    cache: TWidestringList;
    tag: TXMLTag;
    pending: TXMLVCardCacheEntry;
    parser: TXMLTagParser;
    dt, currDT: TDateTime;
    jid, xml, sql: Widestring;
    rst: IExodusDataTable;
    idx: Integer;
    skipped: TWidestringList;

    procedure _initialize();
    begin
        if DataStore.CheckForTableExistence('vcard_cache') then exit;

        try
            DataStore.ExecSQL(VCARD_SQL_SCHEMA_TABLE);
            DataStore.ExecSQL(VCARD_SQL_SCHEMA_INDEX);
        except
            //TODO:  loggit!!
        end;
    end;
    function _queryTable(): Boolean;
    begin
        Result := false;
        if not DataStore.GetTable(VCARD_SQL_LOAD, rst) then exit;
        if rst.RowCount = 0 then exit;
        Result := rst.FirstRow();
    end;
begin
    _initialize();

    cache := _list;
    currDT := Now() - _owner.TimeToLive;
    skipped := TWidestringList.Create();
    parser := TXMLTagParser.Create();
    try
        //query for cache
        rst := TExodusDataTable.Create() as IExodusDataTable;
        if _queryTable() then begin
            for idx := 0 to rst.RowCount - 1 do begin
                jid := rst.GetField(0);
                dt := rst.GetFieldAsDouble(1);
                xml := rst.GetField(2);
                rst.NextRow();
                skipped.Add(jid);

                if (jid = '') then continue;
                if (cache.IndexOf(jid) <> -1) then continue;
                if (currDT > dt) then continue;
                if (xml = '') then continue;

                xml := XML_UnEscapeChars(UTF8Decode(xml));
                parser.ParseString(xml);
                if (parser.Count = 0) then continue;
                tag := parser.popTag();

                pending := TXMLVCardCacheEntry.Create(_owner, jid);
                pending.Load(tag);
                pending.TimeStamp := dt;
                if pending.IsValid then cache.AddObject(jid, pending);

                skipped.Delete(skipped.Count - 1);
            end;
        end;

        //remove stale
        while (skipped.Count > 0) do begin
            jid := skipped[0];
            skipped.Delete(0);
            sql := Format(VCARD_SQL_DELETE, [str2sql(UTF8Encode(jid))]);
            DataStore.ExecSQL(sql);
        end;
    except
        //TODO:  loggit!!
    end;

    skipped.Free();
    parser.Free();

    _owner.LoadFinished();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
type
  PVCardOpEntry = ^TVCardOpEntry;
  TVCardOpEntry = record
    SQL: Widestring;
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TExVCardCacheProc.Create(cache: TExVCardCache);
begin
    inherited Create(true);

    _owner := cache;
    _queue := TList.Create();
    _crit := TCriticalSection.Create();
    FreeOnTerminate := true;
end;
{---------------------------------------}
destructor TExVCardCacheProc.Destroy;
begin
    FreeAndNil(_crit);
    FreeAndNil(_queue);

    inherited;
end;

{---------------------------------------}
procedure TExVCardCacheProc.Execute();
var
    sql: Widestring;

    function NextSQL(): Widestring;
    var
        ent: PVCardOpEntry;
    begin
        Result := '';
        if (_queue.Count = 0) then begin
            _owner.SetProc(nil);
        end;

        ent := PVCardOpEntry(_queue[0]);
        result := ent^.SQL;
        _queue.Delete(0);
        Dispose(ent);
    end;
begin
    while (true) do begin
        _crit.Acquire();
        try
            sql := NextSQL();
            if (sql <> '') then begin
                Terminate();
                Exit;
            end;
        finally
            _crit.Release();
        end;

        try
            DataStore.ExecSQL(sql);
        except
            //TODO:  loggit!!
        end;
    end;
end;

{---------------------------------------}
function TExVCardCacheProc.Enque(sql: Widestring): Boolean;
var
    ent: PVCardOpEntry;
begin
    Result := false;
    if (sql = '') then exit;

    _crit.Acquire();
    New(ent);
    ent^.SQL := sql;
    _queue.Add(ent);
    Result := true;
    _crit.Release();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TExVCardCache.Create(js: TObject);
begin
    inherited;
end;

{---------------------------------------}
destructor TExVCardCache.Destroy();
begin
    _crit.Free();
    if (_proc <> nil) then _proc.Terminate();

    inherited;
end;

{---------------------------------------}
function TExVCardCache.GetProc(): TExVCardCacheProc;
begin
    _crit.Acquire();
    if (_proc = nil) then
        _proc := TExVCardCacheProc.Create(Self)
    else
        _proc.Suspend();

    Result := _proc;
    _crit.Release();
end;
{---------------------------------------}
procedure TExVCardCache.SetProc(proc: TExVCardCacheProc);
begin
    _crit.Acquire();
    _proc := proc;
    _crit.Release();
end;

{---------------------------------------}
procedure TExVCardCache.SessionCallback(event: string; tag: TXMLTag);
var
    loader: TExVCardCacheLoader;
begin
    if (event = (DEPMOD_READY_EVENT + DEPMOD_SESSION)) then begin
        repeat
            _crit.Acquire();
            loader := _loader;
            _crit.Release();

            try
                if (loader <> nil) then loader.WaitFor();
            except
                //catch possible race-to-the-death
            end;
        until (loader = nil);
        MainSession.FireEvent(DEPMOD_READY_EVENT + DEPMOD_VCARD_CACHE, tag);
    end
    else
        inherited;
end;

{---------------------------------------}
procedure TExVCardCache.LoadFinished();
begin
    _crit.Acquire();
    _loader := nil;
    _crit.Release();
end;
{---------------------------------------}
procedure TExVCardCache.Load(cache: TWidestringList);
begin
    _crit := TCriticalSection.Create();
    _loader := TExVCardCacheLoader.Create(Self, cache);
    _loader.Resume();
end;
{---------------------------------------}
procedure TExVCardCache.SaveEntry(vcard: TXMLVCardCacheEntry);
var
    tag: TXMLTag;
    sql: Widestring;
begin
    if (vcard = nil) then exit;

    tag := TXMLTag.Create('iq');
    tag.setAttribute('from', vcard.Jid);
    vcard.fillTag(tag);

    try
        sql := Format(VCARD_SQL_INSERT, [
                str2sql(UTF8Encode(vcard.Jid)),
                vcard.Timestamp,
                str2sql(UTF8Encode(XML_EscapeChars(tag.XML)))
        ]);
        //DataStore.ExecSQL(sql);
        with GetProc() do begin
            Enque(sql);
            Resume();
        end;
    except
        //TODO:  loggit
    end;

    tag.Free();
end;
{---------------------------------------}
procedure TExVCardCache.DeleteEntry(vcard: TXMLVCardCacheEntry);
var
    sql: Widestring;
begin
    if (vcard = nil) then exit;

    try
        sql := Format(VCARD_SQL_DELETE, [str2sql(UTF8Encode(vcard.Jid))]);
        //DataStore.ExecSQL(sql);
        with GetProc() do begin
            Enque(sql);
            Resume();
        end;
    except
    end;
end;


end.
