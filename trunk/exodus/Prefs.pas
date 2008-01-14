unit Prefs;
{
    Copyright 2001, Peter Millard

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

interface

uses
    // panels
    PrefPanel, PrefSystem, PrefRoster,  
    PrefMsg, PrefNotify, PrefAway, PrefPresence, PrefPlugins, PrefTransfer,
    PrefNetwork, PrefHotkeys, PrefDisplay,

    // other stuff
    Menus, ShellAPI, Unicode,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
    ComCtrls, StdCtrls, ExtCtrls, buttonFrame, CheckLst,
    ExRichEdit, Dialogs, RichEdit2, TntStdCtrls, TntComCtrls, TntExtCtrls, ExForm,
    ExGraphicButton, TntForms, ExFrame, ExBrandPanel;

type
  TfrmPrefs = class(TExForm)
    Panel1: TPanel;
    btnOK: TTntButton;
    btnCancel: TTntButton;
    Button6: TTntButton;
    TntPanel1: TTntPanel;
    pnlTabs: TExBrandPanel;
    imgSystem: TExGraphicButton;
    imgDisplay: TExGraphicButton;
    imgNotifications: TExGraphicButton;
    imgProfile: TExGraphicButton;
    imgContactList: TExGraphicButton;
    imgHotKeys: TExGraphicButton;
    imgPresence: TExGraphicButton;
    imgAutoAway: TExGraphicButton;
    imgMessages: TExGraphicButton;
    procedure memKeywordsKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TabSelect(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgSystemMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure OffBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    _lastSelButton: TExGraphicButton;

    _system: TfrmPrefSystem;
    _roster: TfrmPrefRoster;
    _display: TfrmPrefDisplay;
    _message: TfrmPrefMsg;
    _notify: TfrmPrefNotify;
    _away: TfrmPrefAway;
    _pres: TfrmPrefPresence;
//    _plugs: TfrmPrefPlugins;
//    _xfer: TfrmPrefTransfer;
    _network: TfrmPrefNetwork;
    _hotkeys: TfrmPrefHotkeys;

  public
    { Public declarations }
    procedure LoadPrefs;
    procedure SavePrefs;
  end;

var
  frmPrefs: TfrmPrefs;

const
    pref_system = 'system';
    pref_roster = 'roster';
    pref_display = 'display';
    pref_notify = 'notify';
    pref_msgs = 'msgs';
    pref_away = 'away';
    pref_pres = 'presence';
    pref_network = 'network';
    pref_hotkeys = 'hotkeys';


procedure StartPrefs(start_page: string = '');
function IsRequiredPluginsSelected(): WordBool;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.DFM}
{$WARN UNIT_PLATFORM OFF}

uses
    GnuGetText, PrefController, Session, ExUtils, Room, JabberUtils;

{---------------------------------------}
procedure StartPrefs(start_page: string);
var
    s: TExGraphicButton;
    f: TfrmPrefs;
begin
    if ((MainSession.Active) and (not MainSession.Authenticated)) then exit;

    f := TfrmPrefs.Create(Application);
    f.LoadPrefs;

    if (start_page = pref_roster) then s := f.imgContactList
    else if (start_page = pref_display) then s := f.imgDisplay
    else if (start_page = pref_notify) then s := f.imgNotifications
    else if (start_page = pref_msgs) then s := f.imgMessages
    else if (start_page = pref_away) then s := f.imgAutoAway
    else if (start_page = pref_pres) then s := f.imgPresence
    else if (start_page = pref_network) then s := f.imgProfile
    else if (start_page = pref_hotkeys) then s := f.imgHotkeys
    else s := f.imgSystem;
    f.TabSelect(s);
    f.ShowModal;
    f.Free();
end;

function IsRequiredPluginsSelected(): WordBool;
var
  plugins_selected: TWideStringlist;
  plugins_required: TWideStringlist;
  i,j: integer;
  plugins_msg : WideString;
begin
   Result := true;

   plugins_selected := TWideStringlist.Create();
   plugins_required := TWideStringlist.Create();
   with Mainsession.Prefs do
   begin
      fillStringList('plugin_selected',plugins_selected);
      fillStringList('brand_required_plugins',plugins_required);
      plugins_msg := getString('brand_required_plugins_message');
      if (plugins_msg = '' )  then
        plugins_msg := 'This installation is not in compliance with Instant Messaging Policy: A mandatory component %s has been disabled.';

   end;

   for i := 0 to plugins_required.Count - 1 do
   begin
       j := plugins_selected.IndexOf(plugins_required[i]);
       if ( j < 0 ) then
       begin
         plugins_msg := WideFormat(plugins_msg, [plugins_required[i]]);
         MessageDlgW(_(plugins_msg),mtWarning, [mbOK], 0);
         Result := false;
       end;
   end;

   plugins_required.Free();
   plugins_selected.Free();

end;
{---------------------------------------}
procedure TfrmPrefs.LoadPrefs;
begin
end;


procedure TfrmPrefs.memKeywordsKeyPress(Sender: TObject; var Key: Char);
begin
end;

{---------------------------------------}
procedure TfrmPrefs.SavePrefs;
begin
    // save prefs to the reg
    with MainSession.Prefs do begin
        BeginUpdate();

        // Iterate over all the panels we have
        if (_roster <> nil) then
            _roster.SavePrefs();

        if (_system <> nil) then
            _system.SavePrefs();

        if (_display <> nil) then
            _display.SavePrefs();

        if (_message <> nil) then
            _message.SavePrefs();

        if (_notify <> nil) then
            _notify.SavePrefs();

        if (_away <> nil) then
            _away.SavePrefs();

        if (_pres <> nil) then
            _pres.SavePrefs();

        if (_network <> nil) then
            _network.SavePrefs();

        if (_hotkeys <> nil) then
            _hotkeys.SavePrefs();

        endUpdate();
    end;
    MainSession.FireEvent('/session/prefs', nil);
end;

{---------------------------------------}
procedure TfrmPrefs.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if ( (MainSession.Prefs.getBool('brand_plugs') = true) and
       (IsRequiredPluginsSelected() = false)) then
  begin
    Action := caNone;
    exit;
  end;

//    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmPrefs.FormCreate(Sender: TObject);
begin
    // Setup some fonts
    AssignUnicodeFont(Self);

    TranslateComponent(Self);

    // Load the system panel


    // branding
    { JJF fix this
    with (MainSession.Prefs) do begin
        imgTransfer.Visible := getBool('brand_ft');
        lblTransfer.Visible := getBool('brand_ft');
        imgPlugins.Visible := getBool('brand_plugs');
        lblPlugins.Visible := getBool('brand_plugs');
    end;
     }
    // Init all the other panels
    _system := nil;
    _roster := nil;
    _display := nil;
    _message := nil;
    _notify := nil;
    _away := nil;
    _pres := nil;
    _network := nil;
    _hotkeys := nil;
    _lastSelButton := nil;
//    MainSession.Prefs.RestorePosition(Self);
end;

{---------------------------------------}
procedure TfrmPrefs.TabSelect(Sender: TObject);
var
    f: TfrmPrefPanel;
begin
    f := nil;
    if (not (Sender is TExGraphicButton)) then exit; //paranoid


    if (Sender = imgSystem)  then begin
        if (_system = nil) then
            _system := TfrmPrefSystem.Create(Self);
        f := _system;
    end
    else if (Sender = imgContactList)then begin
        if (_roster = nil) then
            _roster := TfrmPrefRoster.Create(Self);
        f := _roster;
    end
    else if (Sender = imgDisplay) then begin
        if (_display = nil) then
            _display := TfrmPrefDisplay.Create(Self);
        f := _display;
    end
    else if (Sender = imgMessages) then begin
        if (_message = nil) then
            _message := TfrmPrefMsg.Create(Self);
        f := _message
    end
    else if (Sender = imgNotifications) then begin
        if (_notify = nil) then
            _notify := TfrmPrefNotify.Create(Self);
        f := _notify;
    end
    else if (Sender = imgAutoAway)then begin
        if (_away = nil) then
            _away := TfrmPrefAway.Create(Self);
        f := _away
    end
    else if (Sender = imgPresence) then begin
        if (_pres = nil) then
            _pres := TfrmPrefPresence.Create(Self);
        f := _pres;
    end
    else if (Sender = imgProfile) then begin
        if (_network = nil) then
            _network := TfrmPrefNetwork.Create(Self);
        f := _network
    end
    else if (Sender = imgHotkeys)then begin
        if (_hotkeys = nil) then
            _hotkeys := TfrmPrefHotkeys.Create(Self);
        f := _hotkeys
    end;

    // setup the panel..
    if (f <> nil) then begin
        if (_lastSelButton <> nil) then
            _lastSelButton.Selected := false;

        TExGraphicButton(Sender).Selected := true;
        _lastSelButton := TExGraphicButton(Sender);

        f.Parent := Self;
        f.Align := alClient;
        f.Visible := true;
        f.BringToFront();
    end;
end;

{---------------------------------------}
procedure TfrmPrefs.frameButtons1btnOKClick(Sender: TObject);
begin
    SavePrefs;
    Self.BringToFront();
end;

{---------------------------------------}
procedure TfrmPrefs.FormDestroy(Sender: TObject);
begin
    // destroy all panels we have..
    _system.Free();
    _roster.Free();
    _display.Free();
    _message.Free();
    _notify.Free();
    _away.Free();
    _pres.Free();
    _network.Free();
    _hotkeys.Free();
end;

{---------------------------------------}
procedure TfrmPrefs.imgSystemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
end;

{---------------------------------------}
procedure TfrmPrefs.OffBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
end;

{---------------------------------------}
procedure TfrmPrefs.FormShow(Sender: TObject);
begin
    if (_lastSelButton = nil) then
        TabSelect(imgSystem);
end;

end.

