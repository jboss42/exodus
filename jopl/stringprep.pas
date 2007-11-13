unit stringprep;

interface

// Jabber idn stuff
function jabber_nodeprep(input: PChar; output: PChar; buf_sz: integer): integer; cdecl; external 'libidn.dll' name 'jabber_nodeprep';
function jabber_nameprep(input: PChar; output: PChar; buf_sz: integer): integer; cdecl; external 'libidn.dll' name 'jabber_nameprep';
function jabber_resourceprep(input: PChar; output: PChar; buf_sz: integer): integer; cdecl; external 'libidn.dll' name 'jabber_resourceprep';

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
    uout: array[0..1024] of Char;
begin
    Result := '';
    try
        uin := UTF8Encode(input);
        if (jabber_nodeprep(PChar(uin), @uout, 1024) = 0) then
            Result := UTF8Decode(uout);
    except
    end;
end;

function xmpp_nameprep(input: Widestring): Widestring;
var
    uin: String;
    uout: array[0..1024] of Char;
begin
    Result := '';
    try
        uin := UTF8Encode(input);
        if (jabber_nameprep(PChar(uin), @uout, 1024) = 0) then
            Result := UTF8Decode(uout);
    except
    end;
end;

function xmpp_resourceprep(input: Widestring): Widestring;
var
    uin: String;
    uout: array[0..1024] of Char;
begin
    Result := '';
    try
        uin := UTF8Encode(input);
        if (jabber_resourceprep(PChar(uin), @uout, 1024) = 0) then
            Result := UTF8Decode(uout);
    except
    end;
end;

end.
