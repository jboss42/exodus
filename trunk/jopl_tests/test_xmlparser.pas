unit test_xmlparser;

interface
uses
    TestFramework, XMLParser, Classes;

type
    TXMLParserTest = class(TTestCase)
    private
        parser: TXMLTagParser;
    protected
        procedure Setup; override;
        procedure TearDown; override;
    published
        procedure testFileParse;
        procedure testStringParser;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    XMLTag, LibXmlParser;

{---------------------------------------}
procedure TXMLParserTest.Setup;
begin
    //
    parser := TXMLTagParser.Create();
end;

{---------------------------------------}
procedure TXMLParserTest.TearDown;
begin
    //
    parser.Free;
end;

{---------------------------------------}
procedure TXMLParserTest.testFileParse;
var
    t, f: TXMLTag;
begin
    //
    parser.ParseFile('jabber.xml');
    CheckEquals(1, parser.Count, 'Wrong fragment count');

    f := parser.popTag();
    CheckEquals('jabber', f.Name, 'Fragement parent has the wrong name');
    CheckEquals(9, f.ChildTags.Count, 'Wrong child count for the frag parent');
    CheckEquals(4, f.QueryTags('service').Count, 'Wrong # of service tags');
    t := f.GetFirstTag('service');
    CheckNotNull(f, 'GetFirstTag(service) returned null');
    CheckEquals('sessions', t.GetAttribute('id'), 'First session tag has wrong id attr');

    t := f.QueryXPTag('/jabber/service/jsm/filter/max_size');
    CheckNotNull(t, 'Deep QueryXPTag failed. Returned null.');
    CheckEquals('100', f.QueryXPData('/jabber/service/jsm/filter/max_size'),
        'Failed getting deep tag cdata');
end;

{---------------------------------------}
procedure TXMLParserTest.testStringParser;
var
    xml: String;
    f: TXMLTag;
begin
    //
    xml := '<foo xmlns="jabber:client"><bar>bar1</bar><bar>bar2</bar></foo>';
    parser.ParseString(xml, '');

    CheckEquals(1, parser.Count, 'Wrong fragment count');
    f := parser.popTag();

    CheckEquals('foo', f.Name, 'Fragment parent has the wrong name');
end;

{---------------------------------------}
initialization
    TestFramework.RegisterTest(TXMLParserTest.Suite);

end.
