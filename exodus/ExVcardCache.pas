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

uses Exodus_TLB, Unicode, XMLVCardCache;

type
  TExVCardCache = class(TXMLVCardCache)
  private
    _loaded: Boolean;
    
  protected
    procedure Load(cache: TWidestringList); override;
    procedure SaveEntry(vcard: TXMLVCardCacheEntry); override;
    procedure DeleteEntry(vcard: TXMLVCardCacheEntry); override;

  public
    constructor Create(js: TObject); override;
    destructor Destroy(); override;
    
  end;

implementation

uses ComObj, SysUtils, XMLTag, XMLParser, XMLUtils, SQLUtils, ExSession;

const
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
constructor TExVCardCache.Create(js: TObject);
begin
    inherited;
end;

{---------------------------------------}
destructor TExVCardCache.Destroy();
begin
    inherited;
end;
{---------------------------------------}
procedure TExVCardCache.Load(cache: TWidestringList);
var
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

    currDT := Now() - TimeToLive;
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
                if (cache.IndexOf(jid) <> -1) then continue;
                if (currDT > dt) then continue;
                if (xml = '') then continue;

                xml := XML_UnEscapeChars(UTF8Decode(xml));
                parser.ParseString(xml);
                if (parser.Count = 0) then continue;
                tag := parser.popTag();

                pending := TXMLVCardCacheEntry.Create(Self, jid);
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

    _loaded := true;
    skipped.Free();
    parser.Free();
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
        DataStore.ExecSQL(sql);
    except
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
        DataStore.ExecSQL(sql);
    except
    end;
end;


end.
