program Exodus;

uses
  Forms,
  Controls,
  Windows,
  XMLUtils in 'XMLUtils.pas',
  ChatWin in 'ChatWin.pas' {frmChat},
  iq in 'iq.pas',
  Jabber1 in 'Jabber1.pas' {frmJabber},
  JabberID in 'JabberID.pas',
  jclConstants in 'jclConstants.pas',
  LibXmlComps in 'LibXmlComps.pas',
  LibXmlParser in 'LibXmlParser.pas',
  Login in 'Login.pas' {frmLogin},
  presence in 'presence.pas',
  Roster in 'Roster.pas',
  RosterWindow in 'RosterWindow.pas' {frmRosterWindow},
  Session in 'Session.pas',
  XMLAttrib in 'XMLAttrib.pas',
  XMLCData in 'XMLCData.pas',
  XMLNode in 'XMLNode.pas',
  XMLStream in 'XMLStream.pas',
  XMLTag in 'XMLTag.pas',
  buttonFrame in 'buttonFrame.pas' {frameButtons: TFrame},
  Chat in 'Chat.pas',
  JabberMsg in 'jabbermsg.pas',
  MsgDisplay in 'MsgDisplay.pas',
  s10n in 's10n.pas',
  Subscribe in 'subscribe.pas' {frmSubscribe},
  RosterAdd in 'RosterAdd.pas' {frmAdd},
  RemoveContact in 'RemoveContact.pas' {frmRemove},
  Room in 'Room.pas' {frmRoom},
  JoinRoom in 'JoinRoom.pas' {frmJoinRoom},
  MsgRecv in 'MsgRecv.pas' {frmMsgRecv},
  Prefs in 'Prefs.pas' {frmPrefs},
  PrefController in 'PrefController.pas',
  Responder in 'Responder.pas',
  ExResponders in 'ExResponders.pas',
  ExUtils in 'ExUtils.pas',
  Profile in 'Profile.pas' {frmProfile},
  ExEvents in 'ExEvents.pas',
  Debug in 'Debug.pas' {frmDebug},
  RiserWindow in 'RiserWindow.pas' {frmRiser},
  Notify in 'Notify.pas',
  Signals in 'Signals.pas',
  Dockable in 'Dockable.pas' {frmDockable},
  MsgQueue in 'MsgQueue.pas' {frmMsgQueue},
  vcard in 'vcard.pas' {frmVCard},
  XMLVCard in 'XMLVCard.pas',
  Invite in 'Invite.pas' {frmInvite},
  About in 'About.pas' {frmAbout},
  Transfer in 'Transfer.pas' {frmTransfer},
  XMLParser in 'XMLParser.pas',
  jud in 'jud.pas' {frmJUD},
  fTopLabel in 'fTopLabel.pas' {frameTopLabel: TFrame},
  Agents in 'Agents.pas',
  Register in 'Register.pas',
  RegForm in 'RegForm.pas' {frmRegister};

{$R *.RES}

{$R manifest.res}

begin
  Application.Initialize;
  Application.Title := 'Exodus';
  Application.CreateForm(TfrmJabber, frmJabber);
  Application.CreateForm(TfrmRosterWindow, frmRosterWindow);
  Application.CreateForm(TfrmDebug, frmDebug);
  Application.CreateForm(TfrmRegister, frmRegister);
  Application.ShowMainForm := false;
  frmRosterWindow.DockRoster;
  frmRosterWindow.Show;

  with MainSession.Prefs do begin

    if getBool('expanded') then begin
        frmDebug.DockForm;
        frmDebug.Show;
        end;

    if getBool('autologin') then begin
        // snag default profile, etc..
        MainSession.ActivateProfile(getInt('profile_active'));
        MainSession.Connect;
        end
    else
        ShowLogin();
    end;

  Application.Run;
end.

