unit stringprep;

interface

// Jabber idn stuff
function jabber_nodeprep(input: PChar): PChar; cdecl; external 'libidn.dll' name 'jabber_nodeprep';
function jabber_nameprep(input: PChar): PChar; cdecl; external 'libidn.dll' name 'jabber_nameprep';
function jabber_resourceprep(input: PChar): PChar; cdecl; external 'libidn.dll' name 'jabber_resourceprep';

// Our stuff
function xmpp_nodeprep(input: Widestring): Widestring;
function xmpp_nameprep(input: Widestring): Widestring;
function xmpp_resourceprep(input: Widestring): Widestring;

implementation
uses
    SysUtils;

function xmpp_nodeprep(input: Widestring): Widestring;
var
    uin: String;
    uout: PChar;
begin
    Result := '';
    try
        uin := UTF8Encode(input);
        uout := jabber_nodeprep(PChar(uin));
        Result := UTF8Decode(uout);
        if (uout <> nil) then SysFreeMem(uout);
    except
    end;
end;

function xmpp_nameprep(input: Widestring): Widestring;
var
    uin: String;
    uout: PChar;
begin
    Result := '';
    try
        uin := UTF8Encode(input);
        uout := jabber_nameprep(PChar(uin));
        Result := UTF8Decode(uout);
        if (uout <> nil) then SysFreeMem(uout);
    except
    end;
end;

function xmpp_resourceprep(input: Widestring): Widestring;
var
    uin: String;
    uout: PChar;
begin
    Result := '';
    try
        uin := UTF8Encode(input);
        uout := jabber_resourceprep(PChar(uin));
        Result := UTF8Decode(uout);
        if (uout <> nil) then SysFreeMem(uout);
    except
    end;
end;

end.
