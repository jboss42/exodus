program test_jopl;

uses
  Forms,
  TestFramework,
  GUITestRunner,
  test_xmltag in 'test_xmltag.pas',
  JabberMsg in '..\jopl\JabberMsg.pas',
  LibXmlComps in '..\jopl\LibXmlComps.pas',
  LibXmlParser in '..\jopl\LibXmlParser.pas',
  Signals in '..\jopl\Signals.pas',
  XMLAttrib in '..\jopl\XMLAttrib.pas',
  XMLCData in '..\jopl\XMLCData.pas',
  XMLConstants in '..\jopl\XMLConstants.pas',
  XMLNode in '..\jopl\XMLNode.pas',
  XMLParser in '..\jopl\XMLParser.pas',
  XMLStream in '..\jopl\XMLStream.pas',
  XMLTag in '..\jopl\XMLTag.pas',
  XMLUtils in '..\jopl\XMLUtils.pas',
  XMLVCard in '..\jopl\XMLVCard.pas',
  JabberID in '..\jopl\JabberID.pas',
  sechash in '..\jopl\SecHash.pas',
  test_xmlparser in 'test_xmlparser.pas',
  test_dispatcher in 'test_dispatcher.pas';

{$R *.res}

var
  myform: TGUITestRunner;

begin
  Application.Initialize;

  // Hack DUnit so that it automatically runs the tests

  Application.Title := 'DUnit';
  // Application.CreateForm(TGUITestRunner, MyForm);
  Application.CreateForm(TGUITestRunner, MyForm);
  with MyForm do begin
        Show();
        suite := registeredTests;
        RunActionExecute(nil);
    end;

  Application.Run();

end.
