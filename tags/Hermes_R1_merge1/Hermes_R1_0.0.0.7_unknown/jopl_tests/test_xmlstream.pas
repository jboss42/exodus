unit test_xmlstream;

interface
uses
    TestFramework, XMLTag, XMLStream, XMLParser, Classes;

type
    TXMLStreamTest = class(TTestCase)
    private
        // stream: TXMLStream;
    protected
        procedure Setup; override;
        procedure TearDown; override;
    published
        procedure StreamCallback(event: string; tag: TXMLTag);
        procedure PushSingleTag;
        procedure PushMultipleTags;
    end;

implementation

procedure TXMLStreamTest.Setup;
begin
    //
end;

procedure TXMLStreamTest.TearDown;
begin
    //
end;

procedure TXMLStreamTest.StreamCallback(event: string; tag: TXMLTag);
begin
    //
end;

procedure TXMLStreamTest.PushSingleTag;
begin
    //
end;

procedure TXMLStreamTest.PushMultipleTags;
begin
    //
end;

end.
