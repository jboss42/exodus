unit PrefNotify;
{
    Copyright 2003, Peter Millard

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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, CheckLst, TntStdCtrls, TntCheckLst,
  ExtCtrls, TntExtCtrls;

type
  TfrmPrefNotify = class(TfrmPrefPanel)
    lblConfigSounds: TTntLabel;
    chkNotify: TTntCheckListBox;
    chkSound: TTntCheckBox;
    chkNotifyActive: TTntCheckBox;
    chkFlashInfinite: TTntCheckBox;
    chkNotifyActiveWindow: TTntCheckBox;
    optNotify: TTntGroupBox;
    chkFlash: TTntCheckBox;
    chkToast: TTntCheckBox;
    chkTrayNotify: TTntCheckBox;
    chkFront: TTntCheckBox;
    chkFlashTabInfinite: TTntCheckBox;
    procedure lblConfigSoundsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkNotifyClick(Sender: TObject);
    procedure chkToastClick(Sender: TObject);
    procedure chkSoundClick(Sender: TObject);
  private
    { Private declarations }
    _notify: array of integer;
    _no_notify_update: boolean;
    _loading: boolean;

  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefNotify: TfrmPrefNotify;

implementation
{$R *.dfm}
uses
    GnuGetText, JabberUtils, ExUtils,  PrefController, Session, ShellAPI;

const
    sSoundChatactivity = 'Activity in a chat window';
    sSoundPriorityChatActivity = 'Priority activity in a chat window';
    sSoundInvite = 'Invited to a conference room';
    sSoundKeyword = 'Keyword in a conference room';
    sSoundNewchat = 'New conversation';
    sSoundNormalmsg = 'Received new message';
    sSoundOffline = 'Contact goes offline';
    sSoundOnline = 'Contact comes online';
    sSoundRoomactivity = 'Activity in a conference room';
    sSoundPriorityRoomactivity = 'Priority activity in a conference room';
    sSoundS10n = 'Subscription request';
    sSoundOOB = 'File Transfers';
    sSoundAutoResponse = 'Auto response generated';
    sSoundSetup = 'Make sure to configure sounds in your Sounds Control Panel using the hotlink provided.';

const
    NUM_NOTIFIES = 13;


procedure TfrmPrefNotify.LoadPrefs();
var
    i: integer;
begin

    _loading := true;

    chkNotify.Items.Clear();
    chkNotify.Items.Add(_(sSoundOnline));
    chkNotify.Items.Add(_(sSoundOffline));
    chkNotify.Items.Add(_(sSoundNewchat));
    chkNotify.Items.Add(_(sSoundNormalmsg));
    chkNotify.Items.Add(_(sSoundS10n));
    chkNotify.Items.Add(_(sSoundInvite));
    chkNotify.Items.Add(_(sSoundKeyword));
    chkNotify.Items.Add(_(sSoundChatactivity));
    chkNotify.Items.Add(_(sSoundPriorityChatactivity));
    chkNotify.Items.Add(_(sSoundRoomactivity));
    chkNotify.Items.Add(_(sSoundPriorityRoomactivity));    
    chkNotify.Items.Add(_(sSoundOOB));
    chkNotify.Items.Add(_(sSoundAutoResponse));
    SetLength(_notify, NUM_NOTIFIES);

    inherited;

    with MainSession.Prefs do begin
        // Notify Options
        _notify[0]  := getInt('notify_online');
        _notify[1]  := getInt('notify_offline');
        _notify[2]  := getInt('notify_newchat');
        _notify[3]  := getInt('notify_normalmsg');
        _notify[4]  := getInt('notify_s10n');
        _notify[5]  := getInt('notify_invite');
        _notify[6]  := getInt('notify_keyword');
        _notify[7]  := getInt('notify_chatactivity');
        _notify[8]  := getInt('notify_priority_chatactivity');
        _notify[9]  := getInt('notify_roomactivity');
        _notify[10] := getInt('notify_priority_roomactivity');
        _notify[11] := getInt('notify_oob');
        _notify[12] := getInt('notify_autoresponse');

        optNotify.Enabled;
        chkToast.Checked := false;
        chkFlash.Checked := false;
        chkTrayNotify.Checked := false;
        chkFront.Checked := false;

        for i := 0 to NUM_NOTIFIES - 1 do
            chkNotify.Checked[i] := (_notify[i] > 0);

    end;

    chkNotify.ItemIndex := 0;
    chkNotifyClick(Self);

    if (chkSound.Visible = true) then
      lblConfigSounds.Visible := true
    else
       lblConfigSounds.Visible := false;
       
    _loading := false;
end;

procedure TfrmPrefNotify.SavePrefs();
begin
    inherited;
    
    with MainSession.Prefs do begin
        // Notify events
        setInt('notify_online', _notify[0]);
        setInt('notify_offline', _notify[1]);
        setInt('notify_newchat', _notify[2]);
        setInt('notify_normalmsg', _notify[3]);
        setInt('notify_s10n', _notify[4]);
        setInt('notify_invite', _notify[5]);
        setInt('notify_keyword', _notify[6]);
        setInt('notify_chatactivity', _notify[7]);
        setInt('notify_priority_chatactivity', _notify[8]);
        setInt('notify_roomactivity', _notify[9]);
        setInt('notify_priority_roomactivity', _notify[10]);
        setInt('notify_oob', _notify[11]);
        setInt('notify_autoresponse', _notify[12]);
    end;
end;

procedure TfrmPrefNotify.lblConfigSoundsClick(Sender: TObject);
var
    ver : integer;
    win : String;
begin
    // pop open the proper control panel applet.
    // It sure was nice of MS to change this for various versions
    // of the OS. *SIGH*
    ver := WindowsVersion(win);
    if (ver = cWIN_XP) then
        ShellExecute(Self.Handle, nil, 'rundll32.exe',
          'shell32.dll,Control_RunDLL mmsys.cpl,,1', nil, SW_SHOW)
    else if ((ver = cWIN_98) or (ver = cWIN_NT)) then
        ShellExecute(Self.Handle, nil, 'rundll32.exe',
            'shell32.dll,Control_RunDLL mmsys.cpl,sounds,0', nil, SW_SHOW)
    else
        ShellExecute(Self.Handle, nil, 'rundll32.exe',
          'shell32.dll,Control_RunDLL mmsys.cpl,,0', nil, SW_SHOW);

end;

procedure TfrmPrefNotify.FormCreate(Sender: TObject);
begin
  inherited;
    SetLength(_notify, NUM_NOTIFIES);
    AssignUnicodeURL(lblConfigSounds.Font, 8);
end;

procedure TfrmPrefNotify.chkNotifyClick(Sender: TObject);
var
    e: boolean;
    i: integer;
begin
    // Show this item's options in the optNotify box.
    i := chkNotify.ItemIndex;

    _no_notify_update := true;

    e := chkNotify.Checked[i];
    chkToast.Enabled := e;
    chkFlash.Enabled := e;
    chkTrayNotify.Enabled := e;
    chkFront.Enabled := e;

    if chkToast.Enabled then begin
        chkToast.Checked := ((_notify[i] and notify_toast) > 0);
        chkFlash.Checked := ((_notify[i] and notify_flash) > 0);
        chkTrayNotify.Checked := ((_notify[i] and notify_tray) > 0);
        chkFront.Checked := ((_notify[i] and notify_front) > 0);
    end
    else begin
        chkToast.Checked := false;
        chkFlash.Checked := false;
        chkTrayNotify.Checked := false;
        chkFront.Checked := false;
        _notify[i] := 0;
    end;

    _no_notify_update := false;
end;

procedure TfrmPrefNotify.chkToastClick(Sender: TObject);
var
    i: integer;
begin
    // update the current notify selection
    if (_no_notify_update) then exit;

    i := chkNotify.ItemIndex;

    if (i < 0) then exit;
    if (i > NUM_NOTIFIES) then exit;

    _notify[i] := 0;
    if (chkToast.Checked) then _notify[i] := _notify[i] + notify_toast;
    if (chkFlash.Checked) then _notify[i] := _notify[i] + notify_flash;
    if (chkTrayNotify.Checked) then _notify[i] := _notify[i] + notify_tray;
    if (chkFront.Checked) then _notify[i] := _notify[i] + notify_front;
end;

procedure TfrmPrefNotify.chkSoundClick(Sender: TObject);
begin
  inherited;
    if (_loading) then exit;

    if (chkSound.Checked) then
        MessageDlgW(_(sSoundSetup), mtInformation, [mbOK], 0);
end;

end.
