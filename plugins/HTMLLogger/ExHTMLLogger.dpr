library ExHTMLLogger;

uses
  ComServ,
  ExHTMLLogger_TLB in 'ExHTMLLogger_TLB.pas',
  LoggerPlugin in 'LoggerPlugin.pas' {HTMLLogger: CoClass},
  XMLUtils in '..\..\..\jopl\XMLUtils.pas',
  JabberConst in '..\..\..\jopl\JabberConst.pas',
  JabberID in '..\..\..\jopl\JabberID.pas',
  JabberMsg in '..\..\..\jopl\JabberMsg.pas',
  LibXmlParser in '..\..\..\jopl\LibXmlParser.pas',
  SecHash in '..\..\..\jopl\SecHash.pas',
  Unicode in '..\..\..\jopl\Unicode.pas',
  XMLAttrib in '..\..\..\jopl\XMLAttrib.pas',
  XMLCData in '..\..\..\jopl\XMLCData.pas',
  XMLConstants in '..\..\..\jopl\XMLConstants.pas',
  XMLNode in '..\..\..\jopl\XMLNode.pas',
  XMLParser in '..\..\..\jopl\XMLParser.pas',
  XMLTag in '..\..\..\jopl\XMLTag.pas',
  JabberUtils in '..\..\..\jopl\JabberUtils.pas',
  Prefs in 'Prefs.pas' {frmPrefs},
  RegExpr in '..\..\..\jopl\RegExpr.pas',
  Stringprep in '..\..\..\jopl\Stringprep.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
