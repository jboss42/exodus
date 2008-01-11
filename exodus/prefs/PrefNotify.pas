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
  ExtCtrls, TntExtCtrls, pngextra, ExGroupBox, TntForms, ExFrame, ExBrandPanel,
  Buttons, TntButtons, TntDialogs,
  Contnrs;

type
    TNotifyInfo = class
    private
        _key: widestring;
        _strValue: WideString;

        _caption: WideString;
        _isReadonly: boolean;
        _isVisible: boolean;

        function getStringValue(): widestring;
        function getBoolValue(): Boolean;
        function getIntValue(): Integer;
        function getWriteable(): boolean;
        procedure setStringValue(str: widestring);
        procedure setBoolValue(bool: boolean);
        procedure setIntValue(int: Integer);

    public
        constructor create(Caption: widestring; key: widestring);overload;
        constructor create(src: TNotifyInfo);overload;
        procedure saveValue();
        property IntValue: Integer read getIntValue write setIntValue;
        property Value: WideString read getStringValue write setStringValue;
        property BoolValue: boolean read getBoolValue write setBoolValue;
        property IsVisible: boolean read _isVisible;
        property IsReadOnly: boolean read _isReadOnly;
        property IsWriteable: boolean read getWriteable;
    end;

  TfrmPrefNotify = class(TfrmPrefPanel)
    pnlContainer: TExBrandPanel;
    pnlSoundEnable: TExBrandPanel;
    imgSound: TImage;
    chkSound: TTntCheckBox;
    pnlAlertSources: TExBrandPanel;
    chkNotify: TTntCheckListBox;
    lblNotifySources: TTntLabel;
    gbActions: TExGroupBox;
    chkFlash: TTntCheckBox;
    chkFront: TTntCheckBox;
    pnlSoundAction: TExBrandPanel;
    chkPlaySound: TTntCheckBox;
    txtSoundFile: TTntEdit;
    btnPlaySound: TTntBitBtn;
    btnBrowse: TTntButton;
    dlgOpenSoundFile: TTntOpenDialog;
    pnlSoundFile: TExBrandPanel;
    chkTrayNotify: TTntCheckBox;
    gbAdvancedPrefs: TExGroupBox;
    chkNotifyActive: TTntCheckBox;
    chkNotifyActiveWindow: TTntCheckBox;
    chkFlashInfinite: TTntCheckBox;
    chkFlashTabInfinite: TTntCheckBox;
    pnlToast: TExBrandPanel;
    chkToast: TTntCheckBox;
    btnToastSettings: TTntButton;
    procedure btnToastSettingsClick(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure btnPlaySoundClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure lblConfigSoundsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkNotifyClick(Sender: TObject);
    procedure chkToastClick(Sender: TObject);
    procedure chkSoundClick(Sender: TObject);
  private
    { Private declarations }
    _no_notify_update: boolean;
    _loading: boolean;

    _notifyList: TObjectList;

    _canEnableToast: boolean;
    _canEnableFlash: boolean;
    _canEnableTray: boolean;
    _canEnableSound: boolean;
    _canEnableFront: boolean;

    _toastAlpha: TNotifyInfo;
    _toastAlphaValue: TNotifyInfo;
    _toastDuration: TNotifyInfo;
    
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
    MMSystem,
    PrefFile,
    XMLUtils,
    ToastSettings,
    GnuGetText, JabberUtils, ExUtils,  PrefController, Session, ShellAPI;

const
    sSoundChatactivity = 'Activity in a chat window';
    sSoundPriorityChatActivity = 'High priority activity in a chat window';
    sSoundInvite = 'Invitation to a conference room is received';
    sSoundKeyword = 'Keyword appears in a conference room';
    sSoundNewchat = 'New conversation is initiated';
    sSoundNormalmsg = 'Message is received';
    sSoundOffline = 'Contact goes offline';
    sSoundOnline = 'Contact comes online';
    sSoundRoomactivity = 'Activity in a conference room';
    sSoundPriorityRoomactivity = 'High priority activity in a conference room';
    sSoundS10n = 'Subscription request is received';
    sSoundOOB = 'File Transfers';
    sSoundAutoResponse = 'Auto response generated';

    sSoundSetup = 'Make sure to configure sounds in your Sounds Control Panel using the hotlink provided.';

const
    NUM_NOTIFIES = 13;


constructor TNotifyInfo.create(Caption: widestring; key: widestring);
var
    s: TPrefState;

begin
    _caption := Caption;
    _key := key;
    _strValue := MainSession.Prefs.getString(_key);
    s := getPrefState(_key);
    _isReadOnly := (s = psReadOnly);
    _isVisible := (s <> psInvisible);
end;

constructor TNotifyInfo.create(src: TNotifyInfo);
begin
    if (src <> nil) then begin
        _caption := src._caption;
        _key := src._key;
        _strValue := src._strValue;
        _isReadOnly := src._isReadonly;
        _isVisible := src._isVisible;
    end
    else begin
        _caption := '';
        _key := '';
        _strValue := '';
        _isReadOnly := false;
        _isVisible := true;
    end;
end;

function TNotifyInfo.getStringValue(): widestring;
begin
    Result := _strValue;
end;

function TNotifyInfo.getBoolValue(): Boolean;
begin
    Result := safeBool(_strValue);
end;

function TNotifyInfo.getIntValue(): Integer;
begin
    Result := safeInt(_strValue);
end;

function TNotifyInfo.getWriteable(): boolean;
begin
    Result := IsVisible and not IsReadOnly;
end;

procedure TNotifyInfo.setStringValue(str: widestring);
begin
    if (_isVisible and not _isReadonly) then
        _strValue := str;
end;

procedure TNotifyInfo.setBoolValue(bool: boolean);
begin
    if (bool) then
        setStringValue('1')
    else
        setStringValue('0');
end;

procedure TNotifyInfo.setIntValue(int: Integer);
begin
    try
        setStringValue(IntToStr(int));
    except
        setStringValue('');
    end;
end;

procedure TNotifyInfo.saveValue();
begin
    if (_isVisible and not _isReadonly) then
        MainSession.Prefs.setString(_key, _strValue);
end;

procedure loadNotificationPrefs(list: TObjectList);
var
    oobNI: TNotifyInfo;
begin
    if (list = nil) then exit;
    list.Clear();

    list.add(TNotifyInfo.create(_(sSoundOnline), 'notify_online'));
    list.add(TNotifyInfo.create(_(sSoundOffline), 'notify_offline'));
    list.add(TNotifyInfo.create(_(sSoundNewchat), 'notify_newchat'));
    list.add(TNotifyInfo.create(_(sSoundNormalmsg), 'notify_normalmsg'));
    list.add(TNotifyInfo.create(_(sSoundS10n), 'notify_s10n'));
    list.add(TNotifyInfo.create(_(sSoundInvite), 'notify_invite'));
    list.add(TNotifyInfo.create(_(sSoundKeyword), 'notify_keyword'));
    list.add(TNotifyInfo.create(_(sSoundChatactivity), 'notify_chatactivity'));
    list.add(TNotifyInfo.create(_(sSoundPriorityChatactivity), 'notify_priority_chatactivity'));
    list.add(TNotifyInfo.create(_(sSoundRoomactivity), 'notify_roomactivity'));
    list.add(TNotifyInfo.create(_(sSoundPriorityRoomactivity), 'notify_priority_roomactivity'));
    list.add(TNotifyInfo.create(_(sSoundAutoResponse), 'notify_autoresponse'));
    oobNI := TNotifyInfo.create(_(sSoundOOB), 'notify_oob');
    //check oob branding as well
    oobNI._isVisible := (oobNI._isVisible and mainSession.Prefs.getBool('brand_ft'));
    list.add(oobNI);
end;

procedure TfrmPrefNotify.LoadPrefs();
var
    i: integer;
    oneNI: TNotifyInfo;
    s: TPrefState;
    foundOne: boolean;
begin
    _loading := true;

    _notifyList := TObjectList.Create(true);
    loadNotificationPrefs(_notifyList);
    chkNotify.Items.Clear();
    foundOne := false;
    for i := 0 to _notifyList.Count - 1 do begin
        oneNI := TNotifyInfo(_notifyList[i]);
        if (oneNI._isVisible) then begin
            foundOne := true;
            chkNotify.AddItem(oneNI._caption, oneNI);
            chkNotify.ItemEnabled[i] := not oneNI._isReadonly;
            chkNotify.Checked[i] := (oneNI.IntValue > 0);
        end;
    end;

    _toastAlpha := TNotifyInfo.create('', 'toast_alpha');
    _toastAlphaValue := TNotifyInfo.create('', 'toast_alpha_val');
    _toastDuration := TNotifyInfo.create('', 'toast_duration');

    inherited;

    chkNotify.Visible := foundOne;
    lblNotifySources.Visible := foundOne;
    
    //visiblity and read status of sound has been set by parent...
    imgSound.Visible := chkSound.Visible;
//    pnlSoundEnable.Visible := chkSound.Visible;
    //set visiblity and read status of actions
    s := GetPrefState('notify_type_toast');
    _canEnableToast := (s <> psReadOnly);
    chkToast.Visible := (s <> psInvisible);
    s := GetPrefState('notify_type_flash');
    _canEnableFlash := (s <> psReadOnly);
    chkFlash.Visible := (s <> psInvisible);
    s := GetPrefState('notify_type_tray');
    _canEnableTray := (s <> psReadOnly);
    chkTrayNotify.Visible := (s <> psInvisible);
    s := GetPrefState('notify_type_sound');
    _canEnableSound := (s <> psReadOnly);
    chkPlaySound.Visible := (s <> psInvisible);
    Self.txtSoundFile.Visible := chkPlaySound.Visible;
    Self.btnPlaySound.Visible := chkPlaySound.Visible;
    Self.btnBrowse.Visible := chkPlaySound.Visible;
    s := GetPrefState('notify_type_front');
    _canEnableFront := (s <> psReadOnly);
    chkFront.Visible := (s <> psInvisible);

        //alpha value is locked because of locked use alpha pref?
    btnToastSettings.Visible := true;
    if (_toastAlphaValue.IsWriteable and
        (not _toastAlpha.IsWriteable) and
        (not _toastAlpha.BoolValue)) then
        btnToastSettings.Visible := false;
    //is any setting available?
    btnToastSettings.Visible := (btnToastSettings.Visible and
                                (_toastAlpha.IsWriteable or
                                 _toastAlphaValue.IsWriteable or
                                 _toastDuration.IsWriteable));

    chkToast.Checked := false;
    chkFlash.Checked := false;
    chkTrayNotify.Checked := false;
    chkFront.Checked := false;
    chkPlaySound.Checked := false;

    pnlToast.enabled := false;
    chkFlash.enabled := false;
    chkTrayNotify.enabled := false;
    chkFront.enabled := false;
    chkPlaySound.Enabled := false;

    if (chkNotify.Count > 0) then begin
        chkNotify.ItemIndex := 0;
        chkNotifyClick(Self);
    end;

    //allow panels to autohide...
    pnlContainer.checkAutoHide();

    _loading := false;
end;

procedure TfrmPrefNotify.SavePrefs();
var
    i: integer;
    oneNI: TNotifyInfo;
begin
    inherited;
    for i := 0 to _notifyList.Count - 1 do begin
        TNotifyInfo(_notifyList[i]).saveValue();
    end;
    _toastAlpha.saveValue();
    _toastAlphaValue.saveValue();
    _toastDuration.saveValue();
end;

procedure TfrmPrefNotify.TntFormDestroy(Sender: TObject);
begin
    inherited;
    _notifyList.Free();
    _toastAlpha.Free();
    _toastAlphaValue.Free();
    _toastDuration.Free();
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
    _notifyList := TObjectList.Create();
    inherited; //will call loadprefs
end;

procedure TfrmPrefNotify.btnBrowseClick(Sender: TObject);
var
    tmps: string;
begin
    inherited;
    tmps := txtSoundFile.Text;
    dlgOpenSoundFile.FileName := tmps;
    if (dlgOpenSoundFile.Execute) then
        txtSoundFile.Text := dlgOpenSoundFile.FileName;
end;

procedure TfrmPrefNotify.btnPlaySoundClick(Sender: TObject);
var
    tstr: string;
begin
    inherited;
    tstr := txtSoundFile.Text;
    PlaySound(pchar(tstr), 0,
                  SND_FILENAME or SND_ASYNC or SND_NOWAIT or SND_NODEFAULT);
end;

procedure TfrmPrefNotify.btnToastSettingsClick(Sender: TObject);
var
    dlg: TToastSettings;
begin
    inherited;
    dlg := TToastSettings.Create(Self);
    dlg.setPrefs(_toastAlpha, _toastAlphaValue, _toastDuration);
    dlg.ShowModal();
end;

procedure TfrmPrefNotify.chkNotifyClick(Sender: TObject);
var
    e: boolean;
    i: integer;
    oneNI: TNotifyInfo;
begin
    // Show this item's options in the optNotify box.
    i := chkNotify.ItemIndex;
    if (i = -1) then exit;
    oneNI := TNotifyInfo(chkNotify.Items.Objects[i]);

    _no_notify_update := true; //stop checkbox click processing

    e := chkNotify.Checked[i] and not oneNI._isReadonly;
    pnlToast.Enabled := e and _canEnableToast;
    chkFlash.Enabled := e and _canEnableFlash;
    chkTrayNotify.Enabled := e and _canEnableTray;
    chkFront.Enabled := e and _canEnableFront;
    chkPlaySound.Enabled := e and _canEnableSound;

    if (not chkNotify.Checked[i]) then
        oneNI.IntValue := 0;

    chkToast.Checked := ((oneNI.IntValue and notify_toast) > 0);
    chkFlash.Checked := ((oneNI.IntValue and notify_flash) > 0);
    chkTrayNotify.Checked := ((oneNI.IntValue and notify_tray) > 0);
    chkFront.Checked := ((oneNI.IntValue and notify_front) > 0);
    chkPlaySound.Checked := ((oneNI.IntValue and notify_sound) > 0);

    pnlSoundFile.enabled := chkPlaySound.Checked;
    btnToastSettings.Enabled := chkToast.Checked;

    _no_notify_update := false;
end;

procedure TfrmPrefNotify.chkToastClick(Sender: TObject);
var
    i: integer;
    oneNI: TNotifyInfo;
begin
    // update the current notify selection
    if (_no_notify_update) or (chkNotify.ItemIndex = -1) then exit;

    i := chkNotify.ItemIndex;
    oneNI := TNotifyInfo(chkNotify.Items.Objects[i]);

    oneNI.IntValue := 0;
    if (chkToast.Checked) then oneNI.IntValue := notify_toast;
    if (chkFlash.Checked) then oneNI.IntValue := oneNI.IntValue + notify_flash;
    if (chkTrayNotify.Checked) then oneNI.IntValue := oneNI.IntValue + notify_tray;
    if (chkFront.Checked) then oneNI.IntValue := oneNI.IntValue + notify_front;
    if (chkPlaySound.Checked) then oneNI.IntValue := oneNI.IntValue + notify_sound;
    if (Sender = chkPlaySound) then
        pnlSoundFile.Enabled := chkPlaySound.Checked
    else if (Sender = chkToast) then
        btnToastSettings.Enabled := chkToast.checked;
end;

procedure TfrmPrefNotify.chkSoundClick(Sender: TObject);
begin
  inherited;
    if (_loading) then exit;

    if (chkSound.Checked) then
        MessageDlgW(_(sSoundSetup), mtInformation, [mbOK], 0);
end;

end.
