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

  TXMLVCardPending = class(TXMLVCard)
  private
    _jid: Widestring;
    _callbacks: TList;
    _iq: TJabberIQ;
    _valid: Boolean;

    constructor Create(jid: Widestring);

    procedure ResultCallback(event: string; tag: TXMLTag);
    procedure AddCallback(cb: TXMLVCardEvent);

    property IsValid: Boolean read _valid write _valid;

  public
    destructor Destroy(); override;

    property Jid: Widestring read _jid;

  end;

  TXMLVCardCache = class
  private
    _cache: TWidestringList;
    _js: TObject;
    _timeout: Integer;
    _ttl: Double;

    procedure SessionCallback(event: string; tag: TXMLTag);

    function GetCached(jid: Widestring): TXMLVCard;

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
    _timeout := 20;
    _ttl := 14;  //14 days
end;

{---------------------------------------}
destructor TXMLVCardCache.Destroy;
var
    idx: Integer;
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
procedure TXMLVCardCache.Load(filename: WideString);
var
    cache, iq: TXMLTag;
    vcard: TXMLVCardPending;
    parser: TXMLTagParser;
    tags: TXMLTagList;
    idx: Integer;
    dt, currDT: TDateTime;
    jid, tstr: Widestring;
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

    currDT := Now() - _ttl;
    tags := cache.ChildTags;
    for idx := 0 to tags.Count - 1 do begin
        iq := tags[idx];

        jid := iq.GetAttribute('from') ;
        if (jid = '') then Continue;

        tstr := iq.getAttribute('timestamp');
        if (tstr <> '') then
            dt := XEP82DateTimeToDateTime(tstr)
        else
            dt := Now();

        if (currDT > dt) then Continue;
        
        vcard := TXMLVCardPending.Create(jid);
        vcard.Parse(iq);
        vcard.TimeStamp := dt;
        vcard.IsValid := true;

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
    if (event = '/session/authenticated') then begin
        Load();
    end
    else if (event = '/session/disconnected') then begin
        Save();
        Clear();
    end
    else if (event = '/session/prefs') then begin
        if session.Prefs.getString('vcard_iq_timeout') <> '' then
            Self._timeout := session.Prefs.getInt('vcard_iq_timeout');
        if session.Prefs.getString('vcard_cache_ttl') <> '' then
            Self._ttl := session.Prefs.getInt('vcard_cache_ttl');
    end;
end;

{---------------------------------------}
function TXMLVCardCache.GetCached(jid: WideString): TXMLVCard;
var
    idx: Integer;
    pending: TXMLVCardPending;
begin
    Result := nil;
    idx := _cache.IndexOf(jid);
    if (idx <> -1) then begin
        pending := TXMLVCardPending(_cache.Objects[idx]);
        if ((Now() - _ttl) > pending.TimeStamp) then pending.IsValid := false;
        if pending.IsValid then Result := pending;
    end
end;

{---------------------------------------}
procedure TXMLVCardCache.find(jid: WideString; cb: TXMLVCardEvent; refresh: Boolean);
var
    session: TJabberSession;
    idx: Integer;
    iq: TJabberIQ;
    pending: TXMLVCardPending;
begin
    //check the cache
    idx := _cache.IndexOf(jid);
    if (idx = -1) then begin
        refresh := true;
        pending := TXMLVCardPending.Create(jid);
        _cache.AddObject(jid, pending);
    end
    else begin
        pending := TXMLVCardPending(_cache.Objects[idx]);
        if ((Now() - _ttl) > pending.TimeStamp) then pending.IsValid := false;
    end;

    if (refresh) then begin
        //do (first or another) vcard request, fire callback later
        pending.IsValid := false;
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
constructor TXMLVCardPending.Create(jid: WideString);
begin
    inherited Create();

    _jid := jid;
    _callbacks := TList.Create();
    _iq := nil;
end;

{---------------------------------------}
destructor TXMLVCardPending.Destroy;
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
procedure TXMLVCardPending.ResultCallback(event: string; tag: TXMLTag);
var
    vcard: TXMLVCard;
    idx: Integer;
    cb: PXMLVCardEventCallback;
begin
    vcard := nil;
    _valid := false;
    _iq := nil;
    if (event = 'xml') then begin
        if (tag.GetAttribute('type') = 'result') then begin
            vcard := Self;
            vcard.Parse(tag);
            vcard.TimeStamp := Now();
            IsValid := true;
        end;
    end
    else if (event <> 'timeout') then begin
        exit;
    end;

    while (_callbacks.Count > 0) do begin
        cb := PXMLVCardEventCallback(_callbacks[0]);
        cb^.Callback(_jid, vcard);
        Dispose(cb);
        _callbacks.Delete(0);
    end;
end;

{---------------------------------------}
procedure TXMLVCardPending.AddCallback(cb: TXMLVCardEvent);
var
    session: TJabberSession;
    cbe: PXMLVCardEventCallback;
begin
    if Assigned(cb) then begin
        new(cbe);
        cbe^.Callback := cb;
        _callbacks.Add(cbe);
    end;

    if (not IsValid) and (_iq = nil) then begin
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
