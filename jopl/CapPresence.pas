unit CapPresence;


interface
uses
    Presence, XMLTag,
    Contnrs, SysUtils;

type

    TCapPresence = class(TJabberPres)
    private
    public
        constructor Create; override;
        destructor Destroy; override;
        // TODO: add accessors for ver and ext, and allow setting ext.
    end;
implementation

uses
    Session, PrefController, JabberConst, XMLUtils;

{---------------------------------------}
constructor TCapPresence.Create;
var
    c : TXMLTag;
begin
    inherited;
    // Add in client capabilities if we have them enabled.
    if (MainSession.Prefs.getBool('client_caps')) then begin
        c := AddTag('c');
        c.setAttribute('xmlns', XMLNS_CLIENTCAPS);
        c.setAttribute('node', MainSession.Prefs.getString('client_caps_uri'));
        c.setAttribute('ver', GetAppVersion());
    end;
end;

{---------------------------------------}
destructor TCapPresence.Destroy;
begin
    inherited Destroy;
end;

end.
