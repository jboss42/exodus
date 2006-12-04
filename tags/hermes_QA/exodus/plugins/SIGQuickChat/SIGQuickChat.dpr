library SIGQuickChat;

{%File 'SIGQuickChat.tlb'}
{%File '..\..\components\jcl\source\jcl.inc'}

uses
  ComServ,
  Unicode in '..\..\..\jopl\Unicode.pas',
  LibXmlParser in '..\..\..\jopl\LibXmlParser.pas',
  XMLTag in '..\..\..\jopl\XMLTag.pas',
  XMLNode in '..\..\..\jopl\XMLNode.pas',
  XMLAttrib in '..\..\..\jopl\XMLAttrib.pas',
  XMLUtils in '..\..\..\jopl\XMLUtils.pas',
  XMLCData in '..\..\..\jopl\XMLCData.pas',
  SecHash in '..\..\..\jopl\SecHash.pas',
  XMLParser in '..\..\..\jopl\XMLParser.pas',
  SIGQuickChat_TLB in 'SIGQuickChat_TLB.pas',
  ActiveFormImpl in 'ActiveFormImpl.pas' {ActiveFormX: TActiveForm} {ActiveFormX: CoClass},
  SIGQuickChatPlugin in 'SIGQuickChatPlugin.pas',
  Controller in 'Controller.pas',
  XMLConstants in '..\..\..\jopl\XMLConstants.pas',
  ComboBoxExSIG in 'Packages\ComboBoxExSIG.pas',
  Options in 'Options.pas' {Form1},
  JclStrings in '..\..\components\jcl\source\common\JclStrings.pas',
  JclWideStrings in '..\..\components\jcl\source\common\JclWideStrings.pas',
  JclBase in '..\..\components\jcl\source\common\JclBase.pas',
  JclResources in '..\..\components\jcl\source\common\JclResources.pas',
  JclLogic in '..\..\components\jcl\source\common\JclLogic.pas';

{$E dll}
exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
