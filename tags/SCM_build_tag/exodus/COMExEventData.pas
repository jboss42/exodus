unit COMExEventData;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, XMLTag, Exodus_TLB, msxml_TLB, StdVcl;

type
  TExodusEventXMLExodusEventXML = class(TAutoObject, IExodusEventXML)
  private
    _xmlTag: TXMLTag;
    _xmlDOM: IXMLDOMDocument;
  public
    destructor Destroy; override;
    function GetDOM: IXMLDOMDocument;virtual; safecall;
    function GetString: WideString; virtual; safecall;
    function GetTag: Integer; virtual; safecall;
    procedure SetDOM(const XMLDom: IXMLDOMDocument); virtual; safecall;
    procedure SetString(const XMLString: WideString); virtual; safecall;
    procedure SetTag(XMLTagPointer: Integer); virtual; safecall;
  end;

implementation

uses XMLUtils, SysUtils, ComServ;

destructor TExodusEventXMLExodusEventXML.Destroy;
begin
    FreeAndNil(_xmlTag);
    _xmlDom := nil;
    inherited;
end;

function TExodusEventXMLExodusEventXML.GetDOM: IXMLDOMDocument;
begin
    if (_xmlTag <> nil) then
    begin
        _xmlDOM := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
        _xmlDOM.loadXML(_xmlTag.XML);
        _xmlTag.free();
        _xmlTag := nil;
    end;
    Result := _xmlDOM;
end;

function TExodusEventXMLExodusEventXML.GetString: WideString;
begin
    if (_xmlTag <> nil) then
        Result := _xmlTag.XML
    else if (_xmlDOM <> nil) then
        Result := _xmlDOM.xml
    else Result := '';
end;

function TExodusEventXMLExodusEventXML.GetTag: Integer;
begin
    if (_xmlDOM <> nil) then
        _xmlTag := StringToXMLTag(_xmlDOM.xml);
    _xmlDOM := nil;
    Result := Integer(_xmlTag); 
end;

procedure TExodusEventXMLExodusEventXML.SetDOM(const XMLDom: IXMLDOMDocument);
begin
    //make a copy, not a ref.
    if (_xmlTag <> nil) then
        _xmlTag.Free();
    _xmlTag := nil;

    _xmlDOM := nil;
    if (XMLDOM <> nil) then begin
        _xmlDOM := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
        _xmlDOM.loadXML(XMLDom.xml);
    end;
end;

procedure TExodusEventXMLExodusEventXML.SetString(const XMLString: WideString);
begin
    //pick the best impl
    if (_xmlDOM <> nil) then
    begin
        _xmlDOM := nil; //let old ref go
        if (Trim(XMLString) <> '') then
        begin
            _xmlDOM := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
            _xmlDOM.loadXML(XMLString)
        end;
    end
    else begin
        if (_xmlTag <> nil) then
            _xmlTag.Free();
        _xmlTag := StringToXMLTag(XMLString);
    end;
end;

procedure TExodusEventXMLExodusEventXML.SetTag(XMLTagPointer: Integer);
begin
    _xmlDOM := nil;
    if (_xmlTag <> nil) then
        _xmlTag.Free();
    _xmlTag := nil;
    if (XMLTagPointer <> 0) then
        _xmlTag := TXMLTag.Create(TXMLTag(XMLTagPointer));
end;

initialization
    TAutoObjectFactory.Create(ComServer, TExodusEventXMLExodusEventXML, Class_ExodusEventXML,
        ciMultiInstance, tmApartment);

end.
