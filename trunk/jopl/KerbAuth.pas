unit KerbAuth;
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
    IdAuthenticationSSPI, IdSSPI,
    JabberAuth, IQ, Session, XMLTag, IdCoderMime, IdHashMessageDigest,
    Classes, SysUtils;

type
    TSSPIKerbClient = class;

    TKerbState = (kerb_auth, kerb_ssf, kerb_done, kerb_error);

    // ------------------------------------------------------------------------
    // This is our JabberAuth plugin for TJabberSession
    // ------------------------------------------------------------------------
    TKerbAuth = class(TJabberAuth)
    private
        _session: TJabberSession;

        // Lets get us some useful objects
        _decoder: TIdDecoderMime;
        _encoder: TIdEncoderMime;

        // Callbacks
        _ccb: integer;
        _fail: integer;
        _resp: integer;
        _succ: integer;

        // the server SPN
        _state: TKerbState;
        _server_spn: Widestring;
        _kerb: TSSPIKerbClient;

        procedure _error(tag: TXMLTag = nil);

    published
        procedure Challenge(event: string; tag: TXMLTag);
        procedure Success(event: string; tag: TXMLTag);
        procedure Fail(event: string; tag: TXMLTag);

    public
        constructor Create(session: TJabberSession);
        destructor Destroy(); override;

        // TJabberAuth
        procedure StartAuthentication(); override;
        procedure CancelAuthentication(); override;

        function StartRegistration(): boolean; override;
        procedure CancelRegistration(); override;

    end;

    // ------------------------------------------------------------------------
    // This is stuff to interface with IdAuthenticationSSPI
    // ------------------------------------------------------------------------
    TSSPIKerbPackage = class(TCustomSSPIPackage)
    public
        constructor Create;
    end;

    TSSPIKerbClient = class
    private
        _pkg: TSSPIKerbPackage;
        _creds: TSSPIWinNTCredentials;
        _ctx: TSSPIClientConnectionContext;

    public
        constructor Create;
        destructor Destroy; override;

        procedure SetCredentials(aDomain, aUserName, aPassword: string); overload;
        procedure SetCredentials(); overload;

        function Initial(const aTargetName: string; var aToPeerToken: string): Boolean;
        function Update(const aFromPeerToken: string; var aToPeerToken: string): Boolean;
        function Unwrap(const Msg: string): Boolean;
        function Wrap(const Msg: string; var aToPeerToken: string): Boolean;

    end;

function KerbAuthFactory(session: TObject): TJabberAuth;

implementation

{ TKerbAuth }

uses
    Windows, IdException, JabberConst;

const
    SECQOP_WRAP_NO_ENCRYPT = $80000001;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function KerbAuthFactory(session: TObject): TJabberAuth;
begin
    Result := TKerbAuth.Create(TJabberSession(session));
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TKerbAuth.Create(session: TJabberSession);
begin
    _session := session;
    _decoder := TIdDecoderMime.Create(nil);
    _encoder := TIdEncoderMime.Create(nil);
    _ccb := -1;
    _fail := -1;
    _resp := -1;
    _succ := -1;
    _state := kerb_auth;
    _kerb := TSSPIKerbClient.Create();
end;

{---------------------------------------}
destructor TKerbAuth.Destroy;
begin
    FreeAndNil(_decoder);
    FreeAndNil(_encoder);
    FreeAndNil(_kerb);

  inherited;
end;

{---------------------------------------}
procedure TKerbAuth._error(tag: TXMLTag);
begin
    //_session.FireEvent('/session/error/auth', tag);
    _session.setAuthenticated(false, nil, false);
    CancelAuthentication();
end;

{---------------------------------------}
procedure TKerbAuth.StartAuthentication;
var
    i: integer;
    mechs: TXMLTagList;
    m, f: TXMLTag;
    cur_mech: Widestring;
    init, tok: string;
begin
    // make sure any old callbacks are cleared out
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
        if (cur_mech = 'GSSAPI') then begin
            _server_spn := mechs[i].getAttribute('kerb:principal');
            mechs.Free();

            // Register for out Callbacks
            _ccb := _session.RegisterCallback(Challenge, '/packet/challenge[@xmlns="' + XMLNS_XMPP_SASL + '"]');
            _succ := _session.RegisterCallback(Success, '/packet/success[@xmlns="' + XMLNS_XMPP_SASL + '"]');
            _fail := _session.RegisterCallback(Fail, '/packet/failure[@xmlns="' + XMLNS_XMPP_SASL + '"]');

            // initialize our creds
            if (_session.Profile.WinLogin) then
                _kerb.SetCredentials()
            else
                _kerb.SetCredentials(_session.Server, _session.Username, _session.Password);

            // send out the packet letting server know we want GSSAPI
            if (not _kerb.Initial(_server_spn, tok)) then begin
                _error();
                exit;
            end;

            // encode the ticket
            init := _encoder.Encode(tok);

            // fire off our auth packet
            m := TXMLTag.Create('auth');
            m.setAttribute('xmlns', XMLNS_XMPP_SASL);
            m.setAttribute('mechanism', 'GSSAPI');
            m.AddCData(init);
            _session.SendTag(m);
            exit;
        end;
    end;

    mechs.Free();

    // if we get here, we didn't find GSSAPI, bail
    _error();

end;

{---------------------------------------}
procedure TKerbAuth.Challenge(event: string; tag: TXMLTag);
var
    ssf, data, tok, c: string;
    resp: TXMLTag;
begin
    // We got a challenge, decode it
    try
        c := _decoder.DecodeString(tag.Data);
    except
        on EIdException do begin
            CancelAuthentication();
            _session.SetAuthenticated(false, nil, false);
            exit;
        end;
    end;

    // send the challenge thru SSPI
    try
        if (_state = kerb_auth) then begin
            if (_kerb.Update(c, tok)) then begin
                data := _encoder.Encode(tok);
                resp := TXMLTag.Create('response');
                resp.setAttribute('xmlns', XMLNS_XMPP_SASL);
                resp.AddCData(data);
                _session.SendTag(resp);
            end
            else if (_kerb._ctx.Authenticated) then begin
                _state := kerb_ssf;
                resp := TXMLTag.Create('response');
                resp.setAttribute('xmlns', XMLNS_XMPP_SASL);
                _session.SendTag(resp);
            end;
        end
        else if (_state = kerb_ssf) then begin
            SetLength(ssf, 4);
            ssf[1] := Chr(1);
            ssf[2] := Chr(0);
            ssf[3] := Chr(0);
            ssf[4] := Chr(0);
            if (_kerb.Unwrap(c) and _kerb.Wrap(ssf, tok)) then begin
                data := _encoder.Encode(tok);
                resp := TXMLTag.Create('response');
                resp.setAttribute('xmlns', XMLNS_XMPP_SASL);
                resp.AddCData(data);
                _session.SendTag(resp);
            end
            else
                _error(tag);
        end;
    except
        on ESSPIException do _error(tag);
    end;
end;

{---------------------------------------}
procedure TKerbAuth.Success(event: string; tag: TXMLTag);
begin
    CancelAuthentication();
    _session.setAuthenticated(true, tag, true);
end;

{---------------------------------------}
procedure TKerbAuth.Fail(event: string; tag: TXMLTag);
begin
    // Something bad happened during the SASL exchange
    _error(tag);
end;

{---------------------------------------}
function TKerbAuth.StartRegistration: boolean;
begin
    // we don't support registration
    Result := false;
end;

{---------------------------------------}
procedure TKerbAuth.CancelAuthentication;
begin
    if (_session <> nil) then begin
        if (_ccb <> -1) then _session.UnRegisterCallback(_ccb);
        if (_succ <> -1) then _session.UnRegisterCallback(_succ);
        if (_fail <> -1) then _session.UnRegisterCallback(_fail);
    end;

    _ccb := -1;
    _succ := -1;
    _fail := -1;
end;

{---------------------------------------}
procedure TKerbAuth.CancelRegistration;
begin
  inherited;
    // NOOP
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TSSPIKerbPackage.Create;
begin
    inherited Create(MICROSOFT_KERBEROS_NAME);
end;

{---------------------------------------}
constructor TSSPIKerbClient.Create();
begin
    inherited Create;

    _pkg := TSSPIKerbPackage.Create();
    _creds := TSSPIWinNTCredentials.Create(_pkg);
    _ctx := TSSPIClientConnectionContext.Create(_creds);
    _ctx.RequestedFlags := ISC_REQ_MUTUAL_AUTH;
    _ctx.NetworkRep := true;
end;

{---------------------------------------}
destructor TSSPIKerbClient.Destroy();
begin
    FreeAndNil(_ctx);
    FreeAndNil(_creds);
    FreeAndNil(_pkg);
end;

{---------------------------------------}
procedure TSSPIKerbClient.SetCredentials(aDomain, aUserName, aPassword: string);
begin
    _creds.Acquire(scuOutBound, aDomain, aUserName, aPassword);
end;

{---------------------------------------}
procedure TSSPIKerbClient.SetCredentials();
begin
    _creds.Acquire(scuOutBound);
end;

{---------------------------------------}
function TSSPIKerbClient.Initial(const aTargetName: string; var aToPeerToken: string): Boolean;
begin
    Result := _ctx.GenerateInitialChalenge(aTargetName, aToPeerToken);
end;

{---------------------------------------}
function TSSPIKerbClient.Update(const aFromPeerToken: string; var aToPeerToken: string): Boolean;
begin
    Result := _ctx.UpdateAndGenerateReply(aFromPeerToken, aToPeerToken);
end;

{---------------------------------------}
function TSSPIKerbClient.Unwrap(const Msg: string): Boolean;
var
    buffs: Array[0..1] of SecBuffer;
    buffDesc: SecBufferDesc;
    g: TSSPIInterface;
    r: SECURITY_STATUS;
    qop: ULONG;
begin
    Result := false;
    g := getSSPIInterface();
    if (g = nil) then exit;

    // this is for encrypted data
    buffs[0].BufferType := SECBUFFER_STREAM;
    buffs[0].cbBuffer := Length(Msg);
    buffs[0].pvBuffer := @(Msg[1]);

    // this is for decrypted data
    buffs[1].BufferType := SECBUFFER_DATA;
    buffs[1].cbBuffer := 0;
    buffs[1].pvBuffer := nil;

    buffDesc.ulVersion := SECBUFFER_VERSION;
    buffDesc.cBuffers := 2;
    buffDesc.pBuffers := @(buffs[0]);

    r := g.FunctionTable.DecryptMessage(_ctx.Handle, @buffDesc, 0, @qop);
    Result := (r = SEC_E_OK);
end;

{---------------------------------------}
function TSSPIKerbClient.Wrap(const Msg: string; var aToPeerToken: string): Boolean;
var
    sizes: SecPkgContext_Sizes;
    buffs: Array[0..2] of SecBuffer;
    buffDesc: SecBufferDesc;
    r: SECURITY_STATUS;
    g: TSSPIInterface;
    b0, b1, b2: string;
begin
    Result := false;
    g := getSSPIInterface();
    if (g = nil) then exit;

    g.FunctionTable.QueryContextAttributesA(_ctx.Handle, SECPKG_ATTR_SIZES, @sizes);

    buffs[0].BufferType := SECBUFFER_TOKEN;
    buffs[0].cbBuffer := sizes.cbSecurityTrailer;
    buffs[0].pvBuffer := AllocMem(sizes.cbSecurityTrailer);

    buffs[1].BufferType := SECBUFFER_DATA;
    buffs[1].cbBuffer := Length(Msg);
    buffs[1].pvBuffer := @(Msg[1]);

    buffs[2].BufferType := SECBUFFER_PADDING;
    buffs[2].cbBuffer := sizes.cbBlockSize;
    buffs[2].pvBuffer := AllocMem(sizes.cbBlockSize);

    buffDesc.ulVersion := SECBUFFER_VERSION;
    buffDesc.cBuffers := 3;
    buffDesc.pBuffers := @(buffs[0]);

    r := g.FunctionTable.EncryptMessage(_ctx.Handle, SECQOP_WRAP_NO_ENCRYPT, @buffDesc, 0);
    if (r = SEC_E_OK) then begin
        SetString(b0, PChar(buffs[0].pvBuffer), buffs[0].cbBuffer);
        SetString(b1, PChar(buffs[1].pvBuffer), buffs[1].cbBuffer);
        SetString(b2, PChar(buffs[2].pvBuffer), buffs[2].cbBuffer);
        aToPeerToken := '';
        aToPeerToken := ConCat(b0, b1);
        aToPeerToken := ConCat(aToPeerToken, b2);
        Result := true;
    end;

    FreeMem(buffs[0].pvBuffer);
    FreeMem(buffs[2].pvBuffer);

end;


initialization
    RegisterJabberAuth('kerberos', KerbAuthFactory);


end.
