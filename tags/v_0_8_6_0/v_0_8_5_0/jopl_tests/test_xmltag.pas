unit test_xmltag;

interface

uses
    TestFramework, XMLTag, Classes;

type
    TXMLNodeTest = class(TTestCase)
    private
        tag: TXMLTag;
    protected
        procedure Setup; override;
        procedure TearDown; override;
    published
        procedure testBasicNode;
        procedure testAttributes;
        procedure testXPParse;
        procedure testXPMatch;
        procedure testXPQuery;
        procedure testXPQueryTags;
        procedure testXPQueryData;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    LibXmlParser;

{---------------------------------------}
procedure TXMLNodeTest.Setup;
begin
    inherited;
    tag := TXMLTag.Create('message');
    with tag do begin
        AddBasicTag('body', 'body text');
        AddBasicTag('subject', 'subject text');
        PutAttribute('id', '1');
        PutAttribute('type', 'chat');
        PutAttribute('from', 'test@jabber.org');

        with AddTag('x') do begin
            AddCData('x1 tag');
            PutAttribute('xmlns', 'jabber:x:test');
            end;

        AddBasicTag('x', 'x2 tag');
        end;
end;

{---------------------------------------}
procedure TXMLNodeTest.TearDown;
begin
    tag.Free;
    inherited;
end;

{---------------------------------------}
procedure TXMLNodeTest.testBasicNode;
var
    tt: TXMLTag;
    tl: TXMLTagList;
begin
    // Test some basic properties of the tag.
    CheckEquals('message', tag.Name, 'Tag Name check failed: ');
    CheckEquals(4, tag.ChildTags.Count, 'Number of Children check failed');
    CheckEquals('body text', tag.GetBasicText('body'), 'GetBasicText check failed.');
    CheckNotNull(tag.GetFirstTag('body'), 'GetFirstTag failed. Null Pointer to body tag');

    tt := tag.AddBasicTag('foo', 'first foo tag');
    CheckNotNull(tt, 'AddBasicTag call returned nil.');

    tag.AddBasicTag('foo', 'second foo tag');
    tl := tag.QueryTags('foo');
    CheckEquals(2, tl.Count, 'QueryTags returned incorrect # of tags.');
end;

{---------------------------------------}
procedure TXMLNodeTest.testAttributes;
begin
    // Test some attribute stuff
    Check(tag.GetAttribute('id') = '1', 'ID Attribute check failed');
    Check(tag.GetAttribute('from') = 'test@jabber.org', 'From attribute check failed');
end;

{---------------------------------------}
procedure TXMLNodeTest.testXPParse;
var
    xp: TXPLite;
    xm: TXPMatch;
    ca: TAttr;
begin
    xp := TXPLite.Create();
    xp.Parse('/message/body[@from="test@jabber.org"]');

    CheckEquals(2, xp.XPMatchList.Count, 'XPLite parse failed. Wrong # of Match elements');

    xm := TXPMatch(xp.XPMatchList.Objects[1]);
    CheckEquals(1, xm.AttrCount, 'XPLite, Wrong attrcount for the xpmatch.');
    ca := xm.getAttribute(0);
    CheckNotNull(ca, 'XPMatch.getAttribute returned Null.');
    CheckEquals('from', ca.Name, 'XPLite, Attribute has wrong name.');
    CheckEquals('test@jabber.org', ca.Value, 'XPLite, Attribute has wrong value.');

end;

{---------------------------------------}
procedure TXMLNodeTest.testXPMatch;
var
    xp: TXPLite;
begin
    // test the XPLite object against our tag
    xp := TXPLite.Create();
    xp.Parse('/message/body');
    Check(xp.Compare(tag), 'XPLite.Compare failed');
end;

{---------------------------------------}
procedure TXMLNodeTest.testXPQuery;
begin
    // Test returning a single tag..
    CheckNotNull(tag.QueryXPTag('/message/x'), 'QueryXPTag failed for /message/x');
end;

{---------------------------------------}
procedure TXMLNodeTest.testXPQueryTags;
var
    tl: TXMLTagList;
begin
    // Test fetching a bunch of tags
    tl := tag.QueryXPTags('/message/x');
    CheckEquals(2, tl.Count, 'QueryXPTags check failed.');
end;

{---------------------------------------}
procedure TXMLNodeTest.testXPQueryData;
begin
    // Test fetching data for something..
    CheckEquals('jabber:x:test', tag.QueryXPData('/message/x@xmlns'), 'QueryXPData failed getting an attribute');
    CheckEquals('x1 tagx2 tag', tag.QueryXPData('/message/x'), 'QueryXPData failed getting CDATA');
end;

{---------------------------------------}
initialization
    TestFramework.RegisterTest(TXMLNodeTest.Suite);
end.
