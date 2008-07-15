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

uses IQ, XMLVCard, XMLTag, Unicode, SysUtils, Classes;

type
  TXMLVCardEvent = procedure(UID: Widestring; vcard: TXMLVCard) of object;

  TXMLVCardEventItem = class
  private
    _cb: TXMLVCardEvent;

  public
    constructor Create(cb: TXMLVCardEvent);
    destructor Destroy(); override;

    property Callback: TXMLVCardEvent read _cb;
  end;
  
  TXMLVCardPending = class
  private
    _jid: Widestring;
    _callbacks: TList;
    _iq: TJabberIQ;

    constructor Create(jid: Widestring);

    procedure ResultCallback(event: string; tag: TXMLTag);
  public
    destructor Destroy(); override;

    procedure Add(cb: TXMLVCardEvent);
  end;

  TXMLVCardCache = class
  private
    _cache: TWidestringList;
    _pending: TWidestringList;
    _js: TObject;
    _timeout: Integer;
    _ttl: Double;

    procedure SessionCallback(event: string; tag: TXMLTag);

    function GetPending(jid: Widestring): TXMLVCardPending;
    procedure ClearPending(jid: Widestring);

    function GetCached(jid: Widestring): TXMLVCard;
    procedure AddCached(jid: Widestring; vcard: TXMLVCard);

    procedure Clear();
    procedure Load(filename: Widestring = '');
    procedure Save(filename: Widestring = '');
  public
    constructor Create();
    destructor Destroy(); override;

    procedure SetSession(js: TObject);

    procedure find(jid: Widestring; cb: TXMLVCardEvent; refresh: Boolean = false);
    property VCards[Index: Widestring]: TXMLVCard read GetCached;

    property Timeout: Integer read _timeout write _timeout;
  end;


function GetVCardCache(): TXMLVCardCache;

const
    VCARD_CACHE_FILENAME : Widestring = 'vcard-cache.xml';
    DEPMOD_VCARD_CACHE: Widestring = 'vcard-cache';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses PrefController, Session, Signals, XMLParser, XMLUtils;

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
    _pending := TWidestringList.Create();
    _timeout := 20;
    _ttl := 14;  //24 hours, or one day
end;

{---------------------------------------}
destructor TXMLVCardCache.Destroy;
var
    idx: Integer;
begin
    Clear();

    FreeAndNil(_cache);
    FreeAndNil(_pending);
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

    for idx := _pending.Count - 1 downto 0 do begin
        TList(_pending.Objects[idx]).Free();
    end;
    _pending.Clear();
end;
{---------------------------------------}
procedure TXMLVCardCache.Load(filename: WideString);
var
    cache, iq: TXMLTag;
    vcard: TXMLVCard;
    parser: TXMLTagParser;
    tags: TXMLTagList;
    idx: Integer;
    dt, currDT: TDateTime;
    tstr: Widestring;
begin
    parser := TXMLTagParser.Create();

    if (filename = '') then
        filename := getUserDir() + VCARD_CACHE_FILENAME;
    if (not FileExists(filename)) then exit;

    parser.ParseFile(filename);

    if (parser.Count = 0) then begin
        parser.Free();
        exit;
    end;

    cache := parser.popTag();

    currDT := Now();
    tags := cache.ChildTags;
    for idx := 0 to tags.Count - 1 do begin
        iq := tags[idx];

        vcard := TXMLVCard.Create();
        vcard.Parse(iq);

        tstr := iq.getAttribute('timestamp');
        if (tstr <> '') then
            vcard.TimeStamp := XEP82DateTimeToDateTime(tstr);
            
        //TODO:  check Timestamp
        if ((currDT - _ttl) <= vcard.TimeStamp) then
            _cache.AddObject(iq.getAttribute('from'), vcard);
    end;
end;
{---------------------------------------}
procedure TXMLVCardCache.Save(filename: WideString);
var
    idx: Integer;
    vcard: TXMLVCard;
    cache, iq: TXMLTag;
    s: TWidestringList;
begin
    if (_cache.Count = 0) then exit;

    cache := TXMLTag.Create('vcard-cache');
    for idx := 0 to _cache.Count - 1 do begin
        iq := cache.AddTag('iq');
        iq.setAttribute('from', _cache[idx]);

        vcard := TXMLVCard(_cache.Objects[idx]);
        iq.setAttribute('timestamp', DateTimeToXEP82DateTime(vcard.TimeStamp));
        vcard.fillTag(iq);
    end;

    if (filename = '') then
        filename := getUserDir() + VCARD_CACHE_FILENAME;

    s := TWidestringList.Create();
    s.Add(cache.XML);

    s.SaveToFile(filename);
    s.Free();
end;

{---------------------------------------}
procedure TXMLVCardCache.SessionCallback(event: string; tag: TXMLTag);
var
    session: TJabberSession;
begin
    session := TJabberSession(_js);
    if (event = DEPMOD_READY_SESSION_EVENT) then begin
        if session.Prefs.getString('vcard_iq_timeout') <> '' then
            Self._timeout := session.Prefs.getInt('vcard_iq_timeout');
        if session.Prefs.getString('vcard_cache_ttl') <> '' then
            Self._ttl := session.Prefs.getDateTime('vcard_cache_ttl');

        Load();
        session.FireEvent(DEPMOD_READY_EVENT + DEPMOD_VCARD_CACHE, tag);
    end
    else if (event = '/session/disconnected') then begin
        Save();
        Clear();
    end;
end;

function TXMLVCardCache.GetPending(jid: WideString): TXMLVCardPending;
var
    idx: Integer;
begin
    idx := _pending.IndexOf(jid);
    if (idx <> -1) then begin
        Result := TXMLVCardPending(_pending.Objects[idx]);
    end
    else begin
        Result := TXMLVCardPending.Create(jid);
        _pending.AddObject(jid, Result);
    end;
end;
{---------------------------------------}
procedure TXMLVCardCache.ClearPending(jid: WideString);
var
    idx: Integer;
    pending: TXMLVCardPending;
begin
    idx := _pending.IndexOf(jid);
    if (idx <> -1) then begin
        pending := TXMLVCardPending(_pending.Objects[idx]);
        _pending.Delete(idx);
        pending.Free();
    end;
end;

{---------------------------------------}
function TXMLVCardCache.GetCached(jid: WideString): TXMLVCard;
var
    idx: Integer;
begin
    idx := _cache.IndexOf(jid);
    if (idx <> -1) then
        Result := TXMLVCard(_cache.Objects[idx])
    else
        Result := nil;
end;
{---------------------------------------}
procedure TXMLVCardCache.AddCached(jid: WideString; vcard: TXMLVCard);
var
    idx: Integer;
begin
    idx := _cache.IndexOf(jid);
    if (idx <> -1) then begin
        _cache.Objects[idx].Free();
        _cache.Delete(idx);
    end;

    _cache.AddObject(jid, vcard);
end;

{---------------------------------------}
procedure TXMLVCardCache.find(jid: WideString; cb: TXMLVCardEvent; refresh: Boolean);
var
    session: TJabberSession;
    idx: Integer;
    iq: TJabberIQ;
    vcard: TXMLVCard;
begin
    vcard := nil;
    idx := _cache.IndexOf(jid);
    if (idx <> -1) then begin
        vcard := TXMLVCard(_cache.Objects[idx]);
        if (refresh) then begin
            _cache.Delete(idx);
            FreeAndNil(vcard);
        end;
    end;
    
    if (vcard <> nil) then begin
        cb(jid, vcard);
    end
    else if (@cb <> nil) then begin
        GetPending(jid).Add(cb);
    end;

end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TXMLVCardEventItem.Create(cb: TXMLVCardEvent);
begin
    _cb := cb;
end;
{---------------------------------------}
destructor TXMLVCardEventItem.Destroy;
begin
    inherited;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TXMLVCardPending.Create(jid: WideString);
begin
    _jid := jid;
    _callbacks := TList.Create();
    _iq := nil;
end;

{---------------------------------------}
destructor TXMLVCardPending.Destroy;
begin
    FreeAndNil(_callbacks);

    inherited;
end;

{---------------------------------------}
procedure TXMLVCardPending.ResultCallback(event: string; tag: TXMLTag);
var
    vcard: TXMLVCard;
    idx: Integer;
    cb: TXMLVCardEventItem;
begin
    vcard := nil;

    if (event = 'xml') then begin
        if (tag.GetAttribute('type') <> 'error') then begin
            vcard := TXMLVCard.Create();
            vcard.Parse(tag);
            vcard.TimeStamp := Date();
            GetVCardCache().AddCached(_jid, vcard);
        end;
    end
    else if (event = 'timeout') then begin
    end
    else begin
        exit;
    end;

    for idx := _callbacks.Count - 1 downto 0 do begin
        cb := TXMLVCardEventItem(_callbacks[idx]);
        cb.Callback(_jid, vcard);
        cb.Free();
        _callbacks.Delete(idx);
    end;

    GetVCardCache().ClearPending(_jid);
end;

{---------------------------------------}
procedure TXMLVCardPending.Add(cb: TXMLVCardEvent);
var
    session: TJabberSession;
begin
    _callbacks.Add(TXMLVCardEventItem.Create(cb));

    if (_iq = nil) then begin
        session := TJabberSession(GetVCardCache()._js);
        _iq := TJabberIQ.Create(
                session,
                session.generateID,
                ResultCallback,
                GetVCardCache().Timeout);
        _iq.Namespace := 'vcard-temp';
        _iq.iqType := 'get';
        _iq.qTag.Name := 'vCard';
        _iq.toJid := _jid;

        _iq.Send();
    end;
end;

initialization
    gVCardCache := TXMLVCardCache.Create();

finalization
    gVCardCache.Free();
    gVCardCache := nil;

end.
