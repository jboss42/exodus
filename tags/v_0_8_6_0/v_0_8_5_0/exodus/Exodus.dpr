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
{%File '..\todo.txt'}
{$R 'version.res' 'version.rc'}
{%File 'defaults.xml'}

{$ifdef VER150}
    {$define INDY9}
{$endif}

uses
  Forms,
  Controls,
  Windows,  
  About in 'About.pas' {frmAbout},
  Agents in '..\jopl\Agents.pas',
  AutoUpdate in '..\jopl\AutoUpdate.pas',
  AutoUpdateStatus in 'AutoUpdateStatus.pas' {frmAutoUpdateStatus},
  BaseChat in 'BaseChat.pas' {frmBaseChat},
  Bookmark in 'Bookmark.pas' {frmBookmark},
  Browser in 'Browser.pas' {frmBrowse},
  chat in '..\jopl\Chat.pas',
  ChatController in '..\jopl\ChatController.pas',
  ChatWin in 'ChatWin.pas' {frmChat},
  COMChatController in 'COMChatController.pas' {ExodusChatController: CoClass},
  COMController in 'COMController.pas' {ExodusController: CoClass},
  COMPPDB in 'COMPPDB.pas' {ExodusPPDB: CoClass},
  COMPresence in 'COMPresence.pas' {ExodusPresence: CoClass},
  COMRoster in 'COMRoster.pas' {ExodusRoster: CoClass},
  COMRosterItem in 'COMRosterItem.pas' {ExodusRosterItem: CoClass},
  ConnDetails in 'ConnDetails.pas' {frmConnDetails},
  CustomNotify in 'CustomNotify.pas' {frmCustomNotify},
  CustomPres in 'CustomPres.pas' {frmCustomPres},
  Debug in 'Debug.pas' {frmDebug},
  Dockable in 'Dockable.pas' {frmDockable},
  DropTarget in 'DropTarget.pas' {ExDropTarget: CoClass},
  Emoticons in 'Emoticons.pas' {frmEmoticons},
  ExEvents in 'ExEvents.pas',
  ExodusCOM_TLB in 'ExodusCOM_TLB.pas',
  ExResponders in 'ExResponders.pas',
  ExUtils in 'ExUtils.pas',
  fGeneric in 'fGeneric.pas' {frameGeneric: TFrame},
  fLeftLabel in 'fLeftLabel.pas' {frmField: TFrame},
  fListbox in 'fListbox.pas' {frameListbox: TFrame},
  fRosterTree in 'fRosterTree.pas' {frameTreeRoster: TFrame},
  fService in 'fService.pas' {frameObjectActions: TFrame},
  fTopLabel in 'fTopLabel.pas' {frameTopLabel: TFrame},
  getopt in 'getOpt.pas',
  GrpRemove in 'GrpRemove.pas' {frmGrpRemove},
  GUIFactory in 'GUIFactory.pas',
  InputPassword in 'InputPassword.pas' {frmInputPass},
  InvalidRoster in 'InvalidRoster.pas' {frmInvalidRoster},
  Invite in 'invite.pas' {frmInvite},
  iq in '..\jopl\IQ.pas',
  Jabber1 in 'Jabber1.pas' {frmExodus},
  JabberAuth in '..\jopl\JabberAuth.pas',
  JabberConst in '..\jopl\JabberConst.pas',
  JabberID in '..\jopl\JabberID.pas',
  JabberMsg in '..\jopl\JabberMsg.pas',
  JoinRoom in 'JoinRoom.pas' {frmJoinRoom},
  jud in 'jud.pas' {frmJUD},
  Langs in '..\jopl\Langs.pas',
  LibXmlComps in '..\jopl\LibXmlComps.pas',
  LibXmlParser in '..\jopl\LibXmlParser.pas',
  Login in 'Login.pas' {frmLogin},
  MsgController in '..\jopl\MsgController.pas',
  MsgDisplay in 'MsgDisplay.pas',
  MsgList in '..\jopl\MsgList.pas',
  MsgQueue in 'MsgQueue.pas' {frmMsgQueue},
  MsgRecv in 'MsgRecv.pas' {frmMsgRecv},
  Notify in 'Notify.pas',
  Password in 'Password.pas' {frmPassword},
  PathSelector in 'PathSelector.pas' {frmPathSelector},
  PluginAuth in 'PluginAuth.pas',
  PrefAway in 'prefs\PrefAway.pas' {frmPrefAway},
  PrefController in '..\jopl\PrefController.pas',
  PrefDialogs in 'prefs\PrefDialogs.pas' {frmPrefDialogs},
  PrefFont in 'prefs\PrefFont.pas' {frmPrefFont},
  PrefMsg in 'prefs\PrefMsg.pas' {frmPrefMsg},
  PrefNotify in 'prefs\PrefNotify.pas' {frmPrefNotify},
  PrefPanel in 'prefs\PrefPanel.pas' {frmPrefPanel},
  PrefPlugins in 'prefs\PrefPlugins.pas' {frmPrefPlugins},
  PrefPresence in 'prefs\PrefPresence.pas' {frmPrefPresence},
  PrefRoster in 'prefs\PrefRoster.pas' {frmPrefRoster},
  Prefs in 'Prefs.pas' {frmPrefs},
  PrefSubscription in 'prefs\PrefSubscription.pas' {frmPrefSubscription},
  PrefSystem in 'prefs\PrefSystem.pas' {frmPrefSystem},
  presence in '..\jopl\Presence.pas',
  Profile in 'Profile.pas' {frmProfile},
  RegExpr in 'RegExpr.pas',
  RegForm in 'RegForm.pas' {frmRegister},
  Register in 'Register.pas',
  RemoveContact in 'RemoveContact.pas' {frmRemove},
  Responder in '..\jopl\Responder.pas',
  RiserWindow in 'RiserWindow.pas' {frmRiser},
  Room in 'Room.pas' {frmRoom},
  RoomAdminList in 'RoomAdminList.pas' {frmRoomAdminList},
  Roster in '..\jopl\Roster.pas',
  RosterAdd in 'RosterAdd.pas' {frmAdd},
  RosterRecv in 'RosterRecv.pas' {frmRosterRecv},
  RosterWindow in 'RosterWindow.pas' {frmRosterWindow},
  s10n in '..\jopl\S10n.pas',
  sechash in '..\jopl\SecHash.pas',
  SelContact in 'SelContact.pas' {frmSelContact},
  Session in '..\jopl\Session.pas',
  Signals in '..\jopl\Signals.pas',
  StandardAuth in '..\jopl\StandardAuth.pas',
  Subscribe in 'subscribe.pas' {frmSubscribe},
  Transfer in 'Transfer.pas' {frmTransfer},
  Transports in 'Transports.pas',
  Unicode in '..\jopl\Unicode.pas',
  vcard in 'vcard.pas' {frmVCard},
  xdata in 'xdata.pas' {frmXData},
  XMLAttrib in '..\jopl\XMLAttrib.pas',
  XMLCData in '..\jopl\XMLCData.pas',
  XMLConstants in '..\jopl\XMLConstants.pas',
  XMLHttpStream in '..\jopl\XMLHttpStream.pas',
  XMLNode in '..\jopl\XMLNode.pas',
  XMLParser in '..\jopl\XMLParser.pas',
  XMLSocketStream in '..\jopl\XMLSocketStream.pas',
  XMLStream in '..\jopl\XMLStream.pas',
  XMLTag in '..\jopl\XMLTag.pas',
  XMLUtils in '..\jopl\XMLUtils.pas',
  XMLVCard in '..\jopl\XMLVCard.pas',
  FileServer in 'FileServer.pas',
  gnugettext in 'gnugettext.pas',
  PrefTransfer in 'prefs\PrefTransfer.pas' {frmPrefTransfer},
  buttonFrame in 'buttonFrame.pas' {frameButtons: TFrame},
  ExSession in 'ExSession.pas',
  WebGet in 'WebGet.pas' {frmWebDownload},
  PrefNetwork in 'prefs\PrefNetwork.pas' {frmPrefNetwork},
  PrefGroups in 'prefs\PrefGroups.pas' {frmPrefGroups},
  HttpProxyIOHandler in '..\jopl\HttpProxyIOHandler.pas';

{$R *.TLB}

{$R *.RES}

{$R manifest.res}
{$R xtra.res}

var
    continue: boolean;

begin
  Application.Initialize;
  Application.Title := '';
  Application.ShowMainForm := false;

  // Main startup stuff
  continue := SetupSession();
  if (not continue) then exit;

  Application.CreateForm(TfrmExodus, frmExodus);
  frmRosterWindow := TfrmRosterWindow.Create(Application);
  frmCustomPres := TfrmCustomPres.Create(Application);
  frmEmoticons := TfrmEmoticons.Create(Application);

  frmRosterWindow.DockRoster;
  frmRosterWindow.Show;
  frmExodus.Startup();
  Application.Run;
end.

