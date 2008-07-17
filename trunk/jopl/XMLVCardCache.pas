unit XMLVCardCache;
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

uses XMLVCard, XMLTag, Unicode, SysUtils, Classes;

type
  TXMLVCardEvent = procedure(UID: Widestring; vcard: TXMLVCard) of object;

  TXMLVCardCacheStatus = (vpsRefresh, vpsError, vpsOK);
  TXMLVCardCacheEntry = class(TXMLVCard)
  private
    _jid: Widestring;
    _callbacks: TList;
    _iq: TObject;       //avoiding Session circular reference

    _status: TXMLVCardCacheStatus;

    constructor Create(jid: Widestring);

    procedure ResultCallback(event: string; tag: TXMLTag);
    procedure AddCallback(cb: TXMLVCardEvent);

    function CheckValidity(): Boolean;

    procedure Save();
    procedure Delete();
  public
    destructor Destroy(); override;

    function Parse(tag: TXMLTag): Boolean; override;

    property Jid: Widestring read _jid;
    property IsValid: Boolean read CheckValidity;

  end;

  TXMLVCardCache = class
  private
    _cache: TWidestringList;
    _js: TObject;

    _loaded: Boolean;
    _timeout: Integer;
    _ttl: Double;

    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure FireUpdate(tag: TXMLTag);

    function ObtainPending(jid: Widestring; create: Boolean; var pending: TXMLVCardCacheEntry): Boolean;
    function GetVCard(jid: Widestring): TXMLVCard;

    procedure Initialize();
    procedure Clear();
    procedure Load();
    procedure Save();
  public
    constructor Create();
    destructor Destroy(); override;

    procedure SetSession(js: TObject);

    procedure find(jid: Widestring; cb: TXMLVCardEvent; refresh: Boolean = false);
    property VCards[Index: Widestring]: TXMLVCard read GetVCard;

    property Timeout: Integer read _timeout write _timeout;
  end;


function GetVCardCache(): TXMLVCardCache;

const
    DEPMOD_VCARD_CACHE: Widestring = 'vcard-cache';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses ExSession, Exodus_TLB, ComObj,
    IQ, PrefController, Session, Signals, SqlUtils, XMLParser, XMLUtils;

const
    VCARD_CACHE_DIR: Widestring = 'vcards';
    VCARD_SQL_SCHEMA_TABLE: Widestring = 'CREATE TABLE vcard_cache (' +
            'jid TEXT, ' +
            'datetime FLOAT, ' +
            'xml TEXT);';
    VCARD_SQL_SCHEMA_INDEX: Widestring = 'CREATE INDEX vcard_cache_jid_idx ON vcard_cache (jid);';

    VCARD_SQL_LOAD: Widestring = 'SELECT * FROM vcard_cache;';
    VCARD_SQL_INSERT: Widestring = 'INSERT INTO vcard_cache (jid,datetime,xml) VALUES (''%s'',%8.6f,''%s'');';
    VCARD_SQL_DELETE: Widestring = 'DELETE FROM vcard_cache where (jid = ''%s'');';

var
    gVCardCache: TXMLVCardCache;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function GetVCardCache(): TXMLVCardCache;
begin
    if (gVCardCache = nil) then begin
        gVCardCache := TXMLVCardCache.Create();
    end;

    Result := gVCardCache;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TXMLVCardCache.Create;
begin
    _cache := TWidestringList.Create();
    _timeout := 20;
    _ttl := 14;  //14 days
end;

{---------------------------------------}
destructor TXMLVCardCache.Destroy;
begin
    Clear();

    FreeAndNil(_cache);
end;

{---------------------------------------}
procedure TXMLVCardCache.SetSession(js: TObject);
var
    session: TJabberSession;
begin
    _js := js;
    Assert(_js is TJabberSession);

    session := TJabberSession(_js);
    session.RegisterCallback(SessionCallback, '/session');
end;

{---------------------------------------}
procedure TXMLVCardCache.Clear();
var
    idx: Integer;
begin
    for idx := _cache.Count - 1 downto 0 do begin
        TXMLVCard(_cache.Objects[idx]).Free();
    end;
    _cache.Clear();
end;

{---------------------------------------}
procedure TXMLVCardCache.Initialize();
begin
    if DataStore.CheckForTableExistence('vcard_cache') then exit;

    try
        DataStore.ExecSQL(VCARD_SQL_SCHEMA_TABLE);
        DataStore.ExecSQL(VCARD_SQL_SCHEMA_INDEX);
    except
        //TODO:  loggit!!
    end;
end;
{---------------------------------------}
procedure TXMLVCardCache.Load();
var
    tag: TXMLTag;
    pending: TXMLVCardCacheEntry;
    parser: TXMLTagParser;
    dt, currDT: TDateTime;
    jid, xml, sql: Widestring;
    rst: IExodusDataTable;
    idx: Integer;
    skipped: TWidestringList;

    function _queryTable(): Boolean;
    begin
        Result := false;
        if not DataStore.GetTable(VCARD_SQL_LOAD, rst) then exit;
        if rst.RowCount = 0 then exit;
        Result := rst.FirstRow();
    end;
begin
    Initialize();

    currDT := Now() - _ttl;
    skipped := TWidestringList.Create();
    parser := TXMLTagParser.Create();
    rst := CreateCOMObject(CLASS_ExodusDataTable) as IExodusDataTable;
    try
        //query for cache
        if _queryTable() then begin
            for idx := 0 to rst.RowCount - 1 do begin
                jid := rst.GetField(0);
                dt := rst.GetFieldAsDouble(1);
                xml := rst.GetField(2);
                rst.NextRow();
                skipped.Add(jid);

                if (jid = '') then continue;
                if (_cache.IndexOf(jid) <> -1) then continue;
                if (currDT > dt) then continue;
                if (xml = '') then continue;

                xml := XML_UnEscapeChars(UTF8Decode(xml));
                parser.ParseString(xml);
                if (parser.Count = 0) then continue;
                tag := parser.popTag();

                pending := TXMLVCardCacheEntry.Create(jid);
                pending.Parse(tag);
                pending.TimeStamp := dt;
                if pending.IsValid then _cache.AddObject(jid, pending);

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

    _loaded := true;
    skipped.Free();
    parser.Free();
end;
{---------------------------------------}
procedure TXMLVCardCache.Save();
begin
end;

{---------------------------------------}
procedure TXMLVCardCache.SessionCallback(event: string; tag: TXMLTag);
var
    session: TJabberSession;
begin
    session := TJabberSession(_js);
    if (event = '/session/connected') then begin
        _timeout := session.Prefs.getInt('vcard_iq_timeout');
        _ttl := session.Prefs.getInt('vcard_cache_ttl');
        if (not _loaded) then Load();
        
    end
    else if (event = '/session/disconnected') then begin
        //Save();
        //Clear();
    end;
end;
{---------------------------------------}
procedure TXMLVCardCache.FireUpdate(tag: TXMLTag);
begin
    TJabberSession(_js).FireEvent('/session/vcard/update', tag);
end;

{---------------------------------------}
function TXMLVCardCache.ObtainPending(
        jid: WideString;
        create: Boolean;
        var pending: TXMLVCardCacheEntry): Boolean;
var
    idx: Integer;
begin
    idx := _cache.IndexOf(jid);
    pending := nil;
    Result := false;
    if (idx <> -1) then begin
        pending := TXMLVCardCacheEntry(_cache.Objects[idx]);
    end
    else if create then begin
        pending := TXMLVCardCacheEntry.Create(jid);
        _cache.AddObject(jid, pending);
        Result := true;
    end;
end;

{---------------------------------------}
function TXMLVCardCache.GetVCard(jid: WideString): TXMLVCard;
var
    pending: TXMLVCardCacheEntry;
begin
    ObtainPending(jid, false, pending);
    if (pending <> nil) and (not pending.IsValid) then
        pending := nil;
        
    result := pending;
end;


{---------------------------------------}
procedure TXMLVCardCache.find(jid: WideString; cb: TXMLVCardEvent; refresh: Boolean);
var
    pending: TXMLVCardCacheEntry;
begin
    //check the cache
    if ObtainPending(jid, true, pending) then
        refresh := true;    //new pending == refresh

    if (refresh) then begin
        //do (first or another) vcard request, fire callback later
        pending._status := vpsRefresh;
        pending.AddCallback(cb);
    end
    else if Assigned(cb) then begin
        //cached result, fire callback now
        if pending.IsValid then
            cb(jid, pending)
        else
            cb(jid, nil);
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
type
    PXMLVCardEventCallback = ^TXMLVCardEventCallback;
    TXMLVCardEventCallback = record
        Callback: TXMLVCardEvent;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TXMLVCardCacheEntry.Create(jid: WideString);
begin
    inherited Create();

    _jid := jid;
    _callbacks := TList.Create();
    _iq := nil;
    _status := vpsRefresh;
end;

{---------------------------------------}
destructor TXMLVCardCacheEntry.Destroy;
begin
    while (_callbacks.Count > 0) do begin
        Dispose(_callbacks[0]);
        _callbacks.Delete(0);
    end;

    FreeAndNil(_callbacks);
    _iq := nil;

    inherited;
end;

{---------------------------------------}
function TXMLVCardCacheEntry.Parse(tag: TXMLTag): Boolean;
begin
    Result := inherited Parse(tag);

    if not Result then
        _status := vpsError
    else begin
        _status := vpsOK;
        TimeStamp := Now();
    end;
end;

{---------------------------------------}
procedure TXMLVCardCacheEntry.Save();
var
    tag: TXMLTag;
    sql: Widestring;
begin
    tag := TXMLTag.Create('iq');
    tag.setAttribute('from', Jid);
    fillTag(tag);

    try
        sql := Format(VCARD_SQL_INSERT, [
                str2sql(UTF8Encode(Jid)),
                Timestamp,
                str2sql(UTF8Encode(XML_EscapeChars(tag.XML)))
        ]);
        DataStore.ExecSQL(sql);
    except
    end;

    tag.Free();
end;
{---------------------------------------}
procedure TXMLVCardCacheEntry.Delete();
var
    sql: Widestring;
begin
    try
        sql := Format(VCARD_SQL_DELETE, [str2sql(UTF8Encode(Jid))]);
        DataStore.ExecSQL(sql);
    except
    end;
end;

{---------------------------------------}
function TXMLVCardCacheEntry.CheckValidity(): Boolean;
begin
    if (_status = vpsOK) then begin
        //double-check TTL here
        if (Now() - GetVCardCache()._ttl) > Self.TimeStamp then
            _status := vpsRefresh;
    end;

    Result := (_status = vpsOK);
    if not Result then Delete();
end;

{---------------------------------------}
procedure TXMLVCardCacheEntry.ResultCallback(event: string; tag: TXMLTag);
var
    vcard: TXMLVCard;
    cb: PXMLVCardEventCallback;
begin
    vcard := nil;
    _iq := nil;
    if (event = 'xml') then begin
        if (tag.GetAttribute('type') = 'result') then begin
            Parse(tag);
            Save();
            _status := vpsOK;
            vcard := Self;
        end
        else begin
            Delete();
            _status := vpsError;
        end;
    end
    else if (event = 'timeout') then begin
        Delete();
        _status := vpsRefresh;
    end
    else begin
        //shouldn't happen, but...
        exit;
    end;

    while (_callbacks.Count > 0) do begin
        cb := PXMLVCardEventCallback(_callbacks[0]);
        _callbacks.Delete(0);

        try
            cb^.Callback(_jid, vcard);
        except
            //TODO:  loggit
        end;
        
        Dispose(cb);
    end;
    
    if (vcard <> nil) then begin
        GetVCardCache().FireUpdate(tag);
    end;
end;

{---------------------------------------}
procedure TXMLVCardCacheEntry.AddCallback(cb: TXMLVCardEvent);
var
    session: TJabberSession;
    iq: TJabberIQ;
    cbe: PXMLVCardEventCallback;
begin
    if Assigned(cb) then begin
        new(cbe);
        cbe^.Callback := cb;
        _callbacks.Add(cbe);
    end;

    if (_status = vpsRefresh) and (_iq = nil) then begin
        session := TJabberSession(GetVCardCache()._js);
        iq := TJabberIQ.Create(
                session,
                session.generateID,
                ResultCallback,
                GetVCardCache().Timeout);
        iq.Namespace := 'vcard-temp';
        iq.iqType := 'get';
        iq.qTag.Name := 'vCard';
        iq.toJid := _jid;
        _iq := iq;

        iq.Send();
    end;
end;

initialization
    gVCardCache := TXMLVCardCache.Create();

finalization
    gVCardCache.Free();
    gVCardCache := nil;

end.
