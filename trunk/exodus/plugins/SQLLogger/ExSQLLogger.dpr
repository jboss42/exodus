library ExSQLLogger;

uses
  ComServ,
  ExSQLLogger_TLB in 'ExSQLLogger_TLB.pas',
  SQLPlugin in 'SQLPlugin.pas' {SQLLogger: CoClass},
  SQLiteTable in 'SQLiteTable.pas',
  SQLite in 'SQLite.pas',
  XMLUtils in '..\..\..\jopl\XMLUtils.pas',
  JabberConst in '..\..\..\jopl\JabberConst.pas',
  JabberMsg in '..\..\..\jopl\JabberMsg.pas',
  JabberUtils in '..\..\..\jopl\JabberUtils.pas',
  LibXmlParser in '..\..\..\jopl\LibXmlParser.pas',
  XMLAttrib in '..\..\..\jopl\XMLAttrib.pas',
  XMLCData in '..\..\..\jopl\XMLCData.pas',
  XMLConstants in '..\..\..\jopl\XMLConstants.pas',
  XMLNode in '..\..\..\jopl\XMLNode.pas',
  XMLParser in '..\..\..\jopl\XMLParser.pas',
  XMLTag in '..\..\..\jopl\XMLTag.pas',
  Unicode in '..\..\..\jopl\Unicode.pas',
  SecHash in '..\..\..\jopl\SecHash.pas',
  JabberID in '..\..\..\jopl\JabberID.pas',
  Viewer in 'Viewer.pas' {frmView},
  RichEdit2 in '..\..\components\RichEdit2.pas',
  Langs in '..\..\components\Langs.pas',
  WStrList in '..\..\components\WStrList.pas',
  RichOLE in '..\..\components\richole.pas',
  ExRichEdit in '..\..\components\ExRichEdit.pas',
  RegExpr in '..\..\..\jopl\RegExpr.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
