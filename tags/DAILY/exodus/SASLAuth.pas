unit SASLAuth;
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
    JabberAuth, IQ, Session, XMLTag, IdCoderMime, IdHashMessageDigest,
    Classes, SysUtils;

type
    TSASLAuth = class(TJabberAuth)
        _session: TJabberSession;
        _digest: boolean;
        _hasher: TIdHashMessageDigest5;
        _decoder: TIdDecoderMime;
        _encoder: TIdEncoderMime;

        _nc: integer;
        _realm: Widestring;
        _nonce: Widestring;
        _cnonce: Widestring;

        _ccb: integer;                  // Callbacks
        _fail: integer;
        _resp: integer;

        procedure RegCallbacks();
        procedure StartDigest();
        procedure StartPlain();

    published
        procedure C1Callback(event: string; xml: TXMLTag);
        procedure C2Callback(event: string; xml: TXMLTag);

        procedure PlainCallback(event: string; xml: TXMLTag);

        procedure FailCallback(event: string; xml: TXMLTag);
        procedure SuccessCallback(event: string; xml: TXMLTag);

    public
        constructor Create(session: TJabberSession);
        destructor Destroy(); override;

        // TJabberAuth
        procedure StartAuthentication(); override;
        procedure CancelAuthentication(); override;

        function StartRegistration(): boolean; override;
        procedure CancelRegistration(); override;

    end;

function checkSASLFeatures(feats: TXMLTag): boolean;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Debug, XMLUtils, IdHash;

var
    _best_mech: Widestring;

{---------------------------------------}
function checkSASLFeatures(feats: TXMLTag): boolean;
var
    i: integer;
    mstr: Widestring;
    m: TXMLTag;
    mechs: TXMLTagList;
begin
    // TODO: Brute force look for plain or MD5-Digest
    m := feats.GetFirstTag('mechanisms');
    _best_mech := '';
    if (m <> nil) then begin
        mechs := m.ChildTags();
        for i := 0 to mechs.Count - 1 do begin
            mstr := mechs[i].Data;
            if (mstr = 'DIGEST-MD5') then begin
                // We have Digest!
                _best_mech := mstr;
            end
            else if ((mstr = 'PLAIN') and (_best_mech = '')) then begin
                // We have plain!
                _best_mech := mstr;
            end;
        end;
    end;
    Result := (_best_mech <> '');
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TSASLAuth.Create(session: TJabberSession);
begin
    //
    _session := session;
    _decoder := TIdDecoderMime.Create(nil);
    _encoder := TIdEncoderMime.Create(nil);
    _hasher := TIdHashMessageDigest5.Create();

    //
    _ccb := -1;
    _fail := -1;
    _resp := -1;
end;

{---------------------------------------}
destructor TSASLAuth.Destroy();
begin
    //
    FreeAndNil(_decoder);
    FreeAndNil(_encoder);
    FreeAndNil(_hasher);
end;

{---------------------------------------}
procedure TSASLAuth.StartAuthentication();
begin
    // TODO: Brute force look for plain or MD5-Digest
    CancelAuthentication();
    if (_best_mech = 'DIGEST-MD5') then
        StartDigest()
    else if (_best_mech = 'PLAIN') then
        StartPlain()
    else
        _session.setAuthenticated(false, nil, false);
end;

{---------------------------------------}
procedure TSASLAuth.CancelAuthentication();
begin
    // Make sure to remove callbacks
    if (_session <> nil) then begin
        if (_ccb <> -1) then _session.UnRegisterCallback(_ccb);
        if (_fail <> -1) then _session.UnRegisterCallback(_fail);
        if (_resp <> -1) then _session.UnRegisterCallback(_resp);
    end;
    _ccb := -1;
    _fail := -1;
    _resp := -1;
end;

{---------------------------------------}
function TSASLAuth.StartRegistration(): boolean;
begin
    Result := false;
end;

{---------------------------------------}
procedure TSASLAuth.CancelRegistration();
begin
    // no-op
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TSASLAuth.StartDigest();
var
    a: TXMLTag;
begin
    _digest := true;
    RegCallbacks();
    _ccb := _session.RegisterCallback(C1Callback, '/packet/challenge');

    _nonce := '';
    _cnonce := '';
    _nc := 0;

    a := TXMLTag.Create('auth');
    a.setAttribute('xmlns', 'urn:ietf:params:xml:ns:xmpp-sasl');
    a.setAttribute('mechanism', 'DIGEST-MD5');
    _session.SendTag(a);
end;

{---------------------------------------}
procedure TSASLAuth.StartPlain();
var
    len: integer;
    a: TXMLTag;
    ms: TMemoryStream;
    uu, upass, ujid, c, buff: string;
    jid: Widestring;
begin
    _digest := false;
    RegCallbacks();

    a := TXMLTag.Create('auth');
    a.setAttribute('xmlns', 'urn:ietf:params:xml:ns:xmpp-sasl');
    a.setAttribute('mechanism', 'PLAIN');

    jid := _session.Username + '@' + _session.Server;
    ujid := UTF8Encode(jid);
    uu := UTF8Encode(_session.Username);
    upass := UTF8Encode(_session.Password);

    ms := TMemoryStream.Create();
    len := Length(ujid) + 1 + Length(uu) + 1 + Length(upass);
    buff := ujid + ''#0 + uu + ''#0 + upass;
    ms.Write(Pointer(buff)^, len);

    ms.Seek(0, soFromBeginning);
    c := _encoder.Encode(ms);
    FreeAndNil(ms);

    a.AddCData(c);

    _session.SendTag(a);
end;

{---------------------------------------}
procedure TSASLAuth.RegCallbacks();
begin
    _fail := _session.RegisterCallback(FailCallback, '/packet/failure');
    _resp := _session.RegisterCallback(SuccessCallback, '/packet/success');
end;

{---------------------------------------}
procedure TSASLAuth.C1Callback(event: string; xml: TXMLTag);
var
    azjid: Widestring;
    resp, pass, uname, uri, az, dig, a1, a2, p1, p2, e, c: string;
    pairs: TStringlist;
    i, v, rands: integer;
    tmp, ha1, ha2, res: T4x4LongWordRecord;
    r: TXMLTag;
    a1s: TMemoryStream;
begin
    if (event <> 'xml') then begin
        _session.SetAuthenticated(false, nil, false);
        exit;
    end;

    c := _decoder.DecodeString(xml.Data);
    pairs := TStringlist.Create();
    parseNameValues(pairs, c);

    // TODO: Use some real entropy here instead of this weak-lame-nasty attempt.
    Randomize();
    rands := Random(1024);
    v := rands;
    for i := 0 to rands do
        v := Random(1000000);

    inc(_nc);

    _realm := pairs.Values['realm'];
    _nonce := pairs.Values['nonce'];

    e := Format('%d:%s:%s', [v, _session.Username, _session.Server]);
    e := _encoder.Encode(e);
    res := _hasher.HashValue(e);
    _cnonce := Lowercase(_hasher.AsHex(res));

    // make sure all parms are UTF8 Encoded
    uname := UTF8Encode(_session.Username);
    pass := UTF8Encode(_session.Password);
    azjid := _session.Username + '@' + _session.Server;
    //az := UTF8Encode(azjid);
    uri := UTF8Encode('xmpp/' + _session.Server);

    resp := 'username="' + uname + '",';
    resp := resp + 'realm="' + _realm + '",';
    resp := resp + 'nonce="' + _nonce + '",';
    resp := resp + 'cnonce="' + _cnonce + '",';
    resp := resp + 'nc=' + Format('%8.8d', [_nc]) + ',';

    // TODO: we should be checking to ensure that qop includes auth
    resp := resp + 'qop=auth,';
    resp := resp + 'digest-uri="' + uri + '",';
    resp := resp + 'charset=utf-8,';

    // actually calc the response...
    e := uname + ':' + _realm + ':' + pass;
    tmp := _hasher.HashValue(e);

    // NB: H(A1) is just 16 bytes, not HEX(H(A1))
    a1s := TMemoryStream.Create();
    a1s.Write(tmp, 16);
    if (az <> '') then
        a1 := ':' + _nonce + ':' + _cnonce + ':' + az
    else
        a1 := ':' + _nonce + ':' + _cnonce;
    a1s.Write(Pointer(a1)^, Length(a1));
    a1s.Seek(0, soFromBeginning);
    ha1 := _hasher.HashValue(a1s);
    FreeAndNil(a1s);

    a2 := 'AUTHENTICATE:' + uri;
    ha2 := _hasher.HashValue(a2);
    p1 := Lowercase(_hasher.AsHex(ha1));
    p2 := Lowercase(_hasher.AsHex(ha2));

    e := p1 + ':' + _nonce + ':' + Format('%8.8d', [_nc]) + ':' + _cnonce + ':auth:' +
         p2;
    res := _hasher.HashValue(e);
    dig := Lowercase(_hasher.AsHex(res));

    if (az <> '') then
        resp := resp + 'authzid="' + az + '",';
    resp := resp + 'response=' + dig;

    _session.UnRegisterCallback(_ccb);
    _ccb := _session.RegisterCallback(C2Callback, '/packet/challenge');

    // Gin up the response and fire!
    r := TXMLTag.Create('response');
    r.setAttribute('xmlns', 'urn:ietf:params:xml:ns:xmpp-sasl');

    DebugMessage(resp);

    r.AddCData(_encoder.Encode(resp));
    _session.SendTag(r);

    pairs.Free();

end;

{---------------------------------------}
procedure TSASLAuth.PlainCallback(event: string; xml: TXMLTag);
var
    c: String;
    pairs: TStringlist;
begin
    if (event <> 'xml') then begin
        _session.SetAuthenticated(false, nil, false);
        exit;
    end;

    c := _decoder.DecodeString(xml.Data);
    pairs := TStringlist.Create();
    parseNameValues(pairs, c);

    // XXX: do stuff here!!

end;

{---------------------------------------}
procedure TSASLAuth.C2Callback(event: string; xml: TXMLTag);
var
    r: TXMLTag;
begin
    //
    r := TXMLTag.Create('response');
    r.setAttribute('xmlns', 'urn:ietf:params:xml:ns:xmpp-sasl');
    _session.SendTag(r);
end;

{---------------------------------------}
procedure TSASLAuth.FailCallback(event: string; xml: TXMLTag);
begin
    CancelAuthentication();
    _session.setAuthenticated(false, nil, false);
end;

{---------------------------------------}
procedure TSASLAuth.SuccessCallback(event: string; xml: TXMLTag);
begin
    CancelAuthentication();
    _session.SetAuthenticated(true, xml, true);
end;



end.
