program Exodus;

{
    Copyright 2002, Peter Millard

    This file is part of Exodus.

    Exodus is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Exodus is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Exodus; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

{%File 'README.txt'}

uses
  Forms,
  Controls,
  Windows,
  Jabber1 in 'Jabber1.pas' {frmExodus},
  Login in 'Login.pas' {frmLogin},
  RosterWindow in 'RosterWindow.pas' {frmRosterWindow},
  buttonFrame in 'buttonFrame.pas' {frameButtons: TFrame},
  MsgDisplay in 'MsgDisplay.pas',
  Subscribe in 'subscribe.pas' {frmSubscribe},
  RosterAdd in 'RosterAdd.pas' {frmAdd},
  RemoveContact in 'RemoveContact.pas' {frmRemove},
  JoinRoom in 'JoinRoom.pas' {frmJoinRoom},
  MsgRecv in 'MsgRecv.pas' {frmMsgRecv},
  Prefs in 'Prefs.pas' {frmPrefs},
  ExResponders in 'ExResponders.pas',
  ExUtils in 'ExUtils.pas',
  Profile in 'Profile.pas' {frmProfile},
  ExEvents in 'ExEvents.pas',
  Debug in 'Debug.pas' {frmDebug},
  RiserWindow in 'RiserWindow.pas' {frmRiser},
  Dockable in 'Dockable.pas' {frmDockable},
  MsgQueue in 'MsgQueue.pas' {frmMsgQueue},
  vcard in 'vcard.pas' {frmVCard},
  Invite in 'invite.pas' {frmInvite},
  About in 'About.pas' {frmAbout},
  Transfer in 'Transfer.pas' {frmTransfer},
  jud in 'jud.pas' {frmJUD},
  fTopLabel in 'fTopLabel.pas' {frameTopLabel: TFrame},
  RegForm in 'RegForm.pas' {frmRegister},
  fLeftLabel in 'fLeftLabel.pas' {frmField: TFrame},
  XMLVCard in '..\jopl\XMLVCard.pas',
  Agents in '..\jopl\Agents.pas',
  chat in '..\jopl\Chat.pas',
  iq in '..\jopl\IQ.pas',
  JabberID in '..\jopl\JabberID.pas',
  JabberMsg in '..\jopl\JabberMsg.pas',
  LibXmlComps in '..\jopl\LibXmlComps.pas',
  LibXmlParser in '..\jopl\LibXmlParser.pas',
  PrefController in '..\jopl\PrefController.pas',
  presence in '..\jopl\Presence.pas',
  Responder in '..\jopl\Responder.pas',
  Roster in '..\jopl\Roster.pas',
  s10n in '..\jopl\S10n.pas',
  sechash in '..\jopl\SecHash.pas',
  Session in '..\jopl\Session.pas',
  Signals in '..\jopl\Signals.pas',
  XMLAttrib in '..\jopl\XMLAttrib.pas',
  XMLCData in '..\jopl\XMLCData.pas',
  XMLConstants in '..\jopl\XMLConstants.pas',
  XMLNode in '..\jopl\XMLNode.pas',
  XMLParser in '..\jopl\XMLParser.pas',
  XMLStream in '..\jopl\XMLStream.pas',
  XMLTag in '..\jopl\XMLTag.pas',
  XMLUtils in '..\jopl\XMLUtils.pas',
  GUIFactory in 'GUIFactory.pas',
  Bookmark in 'Bookmark.pas' {frmBookmark},
  CustomPres in 'CustomPres.pas' {frmCustomPres},
  Register in 'Register.pas',
  Notify in 'Notify.pas',
  getopt in 'getOpt.pas',
  GrpRemove in 'GrpRemove.pas' {frmGrpRemove},
  RegExpr in 'RegExpr.pas',
  Emoticons in 'Emoticons.pas' {frmEmoticons},
  BaseChat in 'BaseChat.pas' {frmBaseChat},
  ChatWin in 'ChatWin.pas' {frmChat},
  Room in 'Room.pas' {frmRoom},
  Password in 'Password.pas' {frmPassword},
  XMLSocketStream in '..\jopl\XMLSocketStream.pas',
  RosterRecv in 'RosterRecv.pas' {frmRosterRecv},
  fRosterTree in 'fRosterTree.pas' {frameTreeRoster: TFrame},
  SelContact in 'SelContact.pas' {frmSelContact},
  XMLHttpStream in '..\jopl\XMLHttpStream.pas',
  ConnDetails in 'ConnDetails.pas' {frmConnDetails},
  InputPassword in 'InputPassword.pas' {frmInputPass},
  Browser in 'Browser.pas' {frmBrowse},
  fListbox in 'fListbox.pas' {frameListbox: TFrame},
  fService in 'fService.pas' {frameObjectActions: TFrame},
  ChatController in '..\jopl\ChatController.pas',
  WStrList in '..\jopl\WStrList.pas',
  Langs in '..\jopl\Langs.pas';

{$R *.RES}

{$R manifest.res}
{$R xtra.res}

begin
  Application.Initialize;
  Application.Title := 'Exodus';

  Application.CreateForm(TfrmExodus, frmExodus);
  Application.CreateForm(TfrmConnDetails, frmConnDetails);
  Application.CreateForm(TfrmInputPass, frmInputPass);
  frmRosterWindow := TfrmRosterWindow.Create(Application);
  frmCustomPres := TfrmCustomPres.Create(Application);
  frmEmoticons := TfrmEmoticons.Create(Application);

  Application.ShowMainForm := false;

  frmRosterWindow.DockRoster;
  frmRosterWindow.Show;
  frmExodus.Startup();
  Application.Run;
end.

