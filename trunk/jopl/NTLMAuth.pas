unit NTLMAuth;
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
    Classes, SysUtils, IdAuthenticationSSPI;

type
    TNTLMAuth = class(TJabberAuth)
        _session: TJabberSession;

        // Lets get us some useful objects
        _decoder: TIdDecoderMime;
        _encoder: TIdEncoderMime;

        // Stuff we need for most mech's
        _nc: integer;
        _realm: Widestring;
        _nonce: Widestring;
        _cnonce: Widestring;

        // Callbacks
        _ccb: integer;
        _fail: integer;
        _resp: integer;

        // NTLM
        _ntlm : TIndySSPINTLMClient;

        procedure _regCallbacks();
        procedure _error(tag: TXMLTag = nil);

    published
        procedure NTLMCallback(event: string; xml: TXMLTag);
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

function NTLMAuthFactory(session: TObject): TJabberAuth;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberConst, XMLUtils, IdException, IdHash, Random;

{---------------------------------------}
function NTLMAuthFactory(session: TObject): TJabberAuth;
begin
    Result := TNTLMAuth.Create(TJabberSession(session));
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TNTLMAuth.Create(session: TJabberSession);
begin
    _session := session;
    _decoder := TIdDecoderMime.Create(nil);
    _encoder := TIdEncoderMime.Create(nil);
    _ccb := -1;
    _fail := -1;
    _resp := -1;
    _ntlm := TIndySSPINTLMClient.Create();
end;

{---------------------------------------}
destructor TNTLMAuth.Destroy();
begin
    FreeAndNil(_decoder);
    FreeAndNil(_encoder);
    FreeAndNil(_ntlm);
end;

{---------------------------------------}
procedure TNTLMAuth._error(tag: TXMLTag);
begin
    //_session.FireEvent('/session/error/auth', tag);
    _session.setAuthenticated(false, nil, false);
    CancelAuthentication();
end;

{---------------------------------------}
procedure TNTLMAuth.StartAuthentication();
var
    i: integer;
    mechs: TXMLTagList;
    m, f: TXMLTag;
    cur_mech: Widestring;
    tok: string;
begin
    CancelAuthentication();

    if (not _session.isXMPP) then begin
        // if we're not XMPP, bail
        _error();
        exit;
    end;

    f := _session.xmppFeatures;
    mechs := f.QueryXPTags('/stream:features/mechanisms/mechanism');
    if (mechs = nil) then begin
        // if we have no mechs, bail
        _error();
        exit;
    end;

    // look for the GSSAPI mech
    for i := 0 to mechs.Count - 1 do begin
        cur_mech := mechs[i].Data;
        if (cur_mech = 'NTLM') then begin
            mechs.Free();

            // Start NTLM
            _regCallbacks();
            _ccb := _session.RegisterCallback(NTLMCallback, '/packet/challenge');

            _ntlm.SetCredentialsAsCurrentUser();
            tok := _ntlm.InitAndBuildType1Message();
            m := TXMLTag.Create('auth');
            m.setAttribute('xmlns', XMLNS_XMPP_SASL);
            m.setAttribute('mechanism', 'NTLM');
            m.AddCData(_encoder.Encode(tok));
            _session.SendTag(m);
            exit;
        end;
    end;

    mechs.Free();

    // if we get here, we didn't find GSSAPI, bail
    _error();
end;

{---------------------------------------}
procedure TNTLMAuth.CancelAuthentication();
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
function TNTLMAuth.StartRegistration(): boolean;
begin
    Result := false;
end;

{---------------------------------------}
procedure TNTLMAuth.CancelRegistration();
begin
    // TODO: Do something for SASL cancel registration?
end;

{---------------------------------------}
procedure TNTLMAuth.NTLMCallback(event: string; xml: TXMLTag);
var
    c: string;
    r: TXMLTag;
begin
    if (event <> 'xml') then begin
        _session.SetAuthenticated(false, nil, false);
        exit;
    end;

    c := _decoder.DecodeString(xml.Data);
    c := _ntlm.UpdateAndBuildType3Message(c);

    r := TXMLTag.Create('response');
    r.setAttribute('xmlns', XMLNS_XMPP_SASL);

    r.AddCData(_encoder.Encode(c));

    _session.SendTag(r);
end;

{---------------------------------------}
procedure TNTLMAuth._regCallbacks();
begin
    _fail := _session.RegisterCallback(FailCallback, '/packet/failure');
    _resp := _session.RegisterCallback(SuccessCallback, '/packet/success');
end;

{---------------------------------------}
procedure TNTLMAuth.FailCallback(event: string; xml: TXMLTag);
begin
    _error(xml);
end;

{---------------------------------------}
procedure TNTLMAuth.SuccessCallback(event: string; xml: TXMLTag);
begin
    CancelAuthentication();
    _session.SetAuthenticated(true, xml, true);
end;

initialization
    RegisterJabberAuth('ntlm', NTLMAuthFactory);


end.
