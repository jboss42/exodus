library SIGQuickChat;

{%File 'SIGQuickChat.tlb'}
{%File '..\..\components\jcl\source\jcl.inc'}

uses
  ComServ,
  SIGQuickChat_TLB in 'SIGQuickChat_TLB.pas',
  ActiveFormImpl in 'ActiveFormImpl.pas' {ActiveFormX: TActiveForm} {ActiveFormX: CoClass},
  SIGQuickChatPlugin in 'SIGQuickChatPlugin.pas',
  Controller in 'Controller.pas',
  ComboBoxExSIG in 'Packages\ComboBoxExSIG.pas',
  Options in 'Options.pas';{Form1}

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
