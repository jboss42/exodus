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
    Menus, ShellAPI, 
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
    ComCtrls, StdCtrls, ExtCtrls, buttonFrame, CheckLst,
    ExRichEdit, Dialogs, RichEdit2, TntStdCtrls;

type
  TfrmPrefs = class(TForm)
    ScrollBox1: TScrollBox;
    imgDialog: TImage;
    lblDialog: TLabel;
    imgFonts: TImage;
    lblFonts: TLabel;
    imgS10n: TImage;
    lblS10n: TLabel;
    imgRoster: TImage;
    lblRoster: TLabel;
    PageControl1: TPageControl;
    tbsRoster: TTabSheet;
    chkOnlineOnly: TCheckBox;
    StaticText1: TStaticText;
    chkShowUnsubs: TCheckBox;
    chkOfflineGroup: TCheckBox;
    optDblClick: TRadioGroup;
    tbsSubscriptions: TTabSheet;
    StaticText2: TStaticText;
    optIncomingS10n: TRadioGroup;
    tbsFonts: TTabSheet;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    StaticText3: TStaticText;
    tbsSystem: TTabSheet;
    StaticText4: TStaticText;
    chkAutoUpdate: TCheckBox;
    chkExpanded: TCheckBox;
    imgSystem: TImage;
    lblSystem: TLabel;
    tbsDialog: TTabSheet;
    StaticText5: TStaticText;
    chkRosterAlpha: TCheckBox;
    trkRosterAlpha: TTrackBar;
    txtRosterAlpha: TEdit;
    spnRosterAlpha: TUpDown;
    chkDebug: TCheckBox;
    chkToastAlpha: TCheckBox;
    trkToastAlpha: TTrackBar;
    txtToastAlpha: TEdit;
    spnToastAlpha: TUpDown;
    tbsNotify: TTabSheet;
    chkNotify: TCheckListBox;
    optNotify: TGroupBox;
    chkFlash: TCheckBox;
    chkToast: TCheckBox;
    StaticText6: TStaticText;
    imgNotify: TImage;
    lblNotify: TLabel;
    chkAutoLogin: TCheckBox;
    imgAway: TImage;
    lblAway: TLabel;
    tbsAway: TTabSheet;
    chkAutoAway: TCheckBox;
    StaticText7: TStaticText;
    txtAwayTime: TEdit;
    spnAway: TUpDown;
    Label2: TLabel;
    txtXATime: TEdit;
    spnXA: TUpDown;
    Label3: TLabel;
    Label4: TLabel;
    txtAway: TEdit;
    txtXA: TEdit;
    Label9: TLabel;
    tbsKeywords: TTabSheet;
    StaticText8: TStaticText;
    memKeywords: TTntMemo;
    tbsBlockList: TTabSheet;
    StaticText9: TStaticText;
    Label10: TLabel;
    memBlocks: TTntMemo;
    imgKeywords: TImage;
    lblKeywords: TLabel;
    imgBlockList: TImage;
    lblBlockList: TLabel;
    chkInlineStatus: TCheckBox;
    cboInlineStatus: TColorBox;
    chkCloseMin: TCheckBox;
    tbsCustomPres: TTabSheet;
    lstCustomPres: TListBox;
    StaticText10: TStaticText;
    pnlCustomPresButtons: TPanel;
    btnCustomPresAdd: TButton;
    btnCustomPresRemove: TButton;
    btnCustomPresClear: TButton;
    GroupBox1: TGroupBox;
    Label11: TLabel;
    txtCPTitle: TEdit;
    Label12: TLabel;
    txtCPStatus: TEdit;
    Label13: TLabel;
    cboCPType: TComboBox;
    txtCPPriority: TEdit;
    spnPriority: TUpDown;
    Label14: TLabel;
    lblHotkey: TLabel;
    txtCPHotkey: THotKey;
    imgCustompres: TImage;
    lblCustomPres: TLabel;
    txtXFerPath: TEdit;
    btnTransferBrowse: TButton;
    Label15: TLabel;
    chkSnap: TCheckBox;
    txtSnap: TEdit;
    spnSnap: TUpDown;
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel3: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Button6: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    chkRegex: TCheckBox;
    chkAutoStart: TCheckBox;
    tbsMessages: TTabSheet;
    chkEmoticons: TCheckBox;
    chkTimestamp: TCheckBox;
    chkLog: TCheckBox;
    txtLogPath: TEdit;
    StaticText11: TStaticText;
    txtTimestampFmt: TEdit;
    btnLogBrowse: TButton;
    Label19: TLabel;
    imgMessages: TImage;
    lblMessages: TLabel;
    chkPresenceMessageListen: TCheckBox;
    chkPresenceMessageSend: TCheckBox;
    chkSound: TCheckBox;
    Label20: TLabel;
    chkNotifyActive: TCheckBox;
    chkMsgQueue: TCheckBox;
    chkOnTop: TCheckBox;
    chkToolbox: TCheckBox;
    Label22: TLabel;
    colorRoster: TTreeView;
    Label23: TLabel;
    Label24: TLabel;
    clrBoxBG: TColorBox;
    clrBoxFont: TColorBox;
    Label25: TLabel;
    btnFont: TButton;
    lblColor: TLabel;
    colorChat: TExRichEdit;
    Label5: TLabel;
    chkHideBlocked: TCheckBox;
    chkPresErrors: TCheckBox;
    tbsPlugins: TTabSheet;
    StaticText12: TStaticText;
    Label6: TLabel;
    memPlugins: TTntMemo;
    imgPlugins: TImage;
    lblPlugins: TLabel;
    chkLogRooms: TCheckBox;
    Label7: TLabel;
    cboMsgOptions: TComboBox;
    Label8: TLabel;
    cboPresTracking: TComboBox;
    btnLogClearAll: TButton;
    chkCloseQueue: TCheckBox;
    chkFlashInfinite: TCheckBox;
    chkAAReducePri: TCheckBox;
    chkAutoAcceptInvites: TCheckBox;
    txtSpoolPath: TEdit;
    Label16: TLabel;
    btnSpoolBrowse: TButton;
    OpenDialog1: TOpenDialog;
    chkShowPending: TCheckBox;
    chkNotifyActiveWindow: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TabSelect(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure trkRosterAlphaChange(Sender: TObject);
    procedure chkRosterAlphaClick(Sender: TObject);
    procedure txtToastAlphaChange(Sender: TObject);
    procedure txtRosterAlphaChange(Sender: TObject);
    procedure chkNotifyClick(Sender: TObject);
    procedure chkToastClick(Sender: TObject);
    procedure chkToastAlphaClick(Sender: TObject);
    procedure trkToastAlphaChange(Sender: TObject);
    procedure chkInlineStatusClick(Sender: TObject);
    procedure lstCustomPresClick(Sender: TObject);
    procedure txtCPTitleChange(Sender: TObject);
    procedure btnCustomPresAddClick(Sender: TObject);
    procedure btnCustomPresRemoveClick(Sender: TObject);
    procedure btnCustomPresClearClick(Sender: TObject);
    procedure btnLogBrowseClick(Sender: TObject);
    procedure btnTransferBrowseClick(Sender: TObject);
    procedure chkSnapClick(Sender: TObject);
    procedure Label20Click(Sender: TObject);
    procedure colorRosterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure clrBoxBGChange(Sender: TObject);
    procedure clrBoxFontChange(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure colorChatMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkLogClick(Sender: TObject);
    procedure btnLogClearAllClick(Sender: TObject);
    procedure btnSpoolBrowseClick(Sender: TObject);
  private
    { Private declarations }
    _notify: array of integer;
    _no_notify_update: boolean;
    _no_pres_change: boolean;
    _pres_list: TList;

    _clr_control: TControl;
    _clr_font_color: string;
    _clr_font: string;
    _clr_bg: string;

    procedure redrawChat();
  public
    { Public declarations }
    procedure LoadPrefs;
    procedure SavePrefs;
  end;

var
  frmPrefs: TfrmPrefs;

resourcestring
    sPrefsDfltPres = 'Untitled Presence';
    sPrefsClearPres = 'Clear all custom presence entries?';
    sPrefsLogDir = 'Select log directory';
    sPrefsXFerDir = 'Select download directory';

    sSoundChatactivity = 'Activity in a chat window';
    sSoundInvite = 'Invited to a room';
    sSoundKeyword = 'Keyword in a room';
    sSoundNewchat = 'New conversation';
    sSoundNormalmsg = 'Received a normal message';
    sSoundOffline = 'Contact went offline';
    sSoundOnline = 'Contact came online';
    sSoundRoomactivity = 'Activity in a room';
    sSoundS10n = 'Subscription request';
    sSoundOOB = 'File Transfers';
    sSoundAutoResponse = 'Auto response generated';

    sRosterFontLabel = 'Roster Font and Background';
    sChatFontLabel = 'Roster Font and Background';

procedure StartPrefs;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.DFM}
{$WARN UNIT_PLATFORM OFF}
uses
    ExUtils,
    FileCtrl,
    XMLUtils,
    Presence, MsgDisplay, JabberMsg, Jabber1,
    PrefController,
    Registry,
    Session;

const
    RUN_ONCE : string = '\Software\Microsoft\Windows\CurrentVersion\Run';
    NUM_NOTIFIES = 11;

{---------------------------------------}
procedure StartPrefs;
var
    f: TfrmPrefs;
begin
    f := TfrmPrefs.Create(Application);
    f.LoadPrefs;
    // frmExodus.PreModal(f);
    f.ShowModal;
    frmExodus.PostModal();
end;

{---------------------------------------}
procedure TfrmPrefs.LoadPrefs;
var
    i: integer;
begin
    // load prefs from the reg.
    with MainSession.Prefs do begin
        // Roster Prefs
        chkOnlineOnly.Checked := getBool('roster_only_online');
        chkShowUnsubs.Checked := getBool('roster_show_unsub');
        chkShowPending.Checked := getBool('roster_show_pending');
        chkOfflineGroup.Checked := getBool('roster_offline_group');
        chkInlineStatus.Checked := getBool('inline_status');
        cboInlineStatus.Selected := TColor(getInt('inline_color'));
        cboInlineStatus.Enabled := chkInlineStatus.Checked;
        chkHideBlocked.Checked := getBool('roster_hide_block');
        chkPresErrors.Checked := getBool('roster_pres_errors');

        if (getBool('roster_chat')) then
            optDblClick.ItemIndex := 0
        else
            optDblClick.ItemIndex := 1;

        // s10n prefs
        optIncomingS10n.ItemIndex := getInt('s10n_auto_accept');

        // Font, Color prefs
        with colorChat do begin
            Font.Name := getString('font_name');
            Font.Size := getInt('font_size');
            Font.Color := TColor(getInt('font_color'));
            Font.Charset := getInt('font_charset');
            if (Font.Charset = 0) then Font.Charset := 1;

            Font.Style := [];
            if (getBool('font_bold')) then Font.Style := Font.Style + [fsBold];
            if (getBool('font_italic')) then Font.Style := Font.Style + [fsItalic];
            if (getBool('font_underline')) then Font.Style := Font.Style + [fsUnderline];
            Color := TColor(getInt('color_bg'));
            Self.redrawChat();
            end;

        with colorRoster do begin
            Items[0].Expand(true);
            Color := TColor(getInt('roster_bg'));
            Font.Color := TColor(getInt('roster_font_color'));
            Font.Name := getString('roster_font_name');
            Font.Size := getInt('roster_font_size');
            Font.Charset := getInt('roster_font_charset');
            if (Font.Charset = 0) then Font.Charset := 1;
            Font.Style := [];
            end;
        lblColor.Caption := sRosterFontLabel;
        _clr_font := 'roster_font';
        _clr_font_color := 'roster_font_color';
        _clr_bg := 'roster_bg';
        _clr_control := colorRoster;

        btnFont.Enabled := true;
        clrBoxBG.Selected := TColor(MainSession.Prefs.getInt(_clr_bg));
        clrBoxFont.Selected := TColor(Mainsession.Prefs.getInt(_clr_font_color));

        // System Prefs
        chkAutoUpdate.Checked := getBool('auto_updates');
        chkAutoStart.Checked := getBool('auto_start');
        chkExpanded.Checked := getBool('expanded');
        chkDebug.Checked := getBool('debug');
        chkAutoLogin.Checked := getBool('autologin');
        chkOnTop.Checked := getBool('window_ontop');
        chkToolbox.Checked := getBool('window_toolbox');
        chkCloseMin.Checked := getBool('close_min');
        txtXFerPath.Text := getString('xfer_path');

        // Message Options
        chkTimestamp.Checked := getBool('timestamp');
        txtTimestampFmt.Text := getString('timestamp_format');
        chkMsgQueue.Checked := getBool('msg_queue');
        chkCloseQueue.Checked := getBool('close_queue');
        chkEmoticons.Checked := getBool('emoticons');
        chkLog.Checked := getBool('log');
        chkLogRooms.Checked := getBool('log_rooms');
        txtLogPath.Text := getString('log_path');
        txtSpoolPath.Text := getString('spool_path');
        chkAutoAcceptInvites.Checked := getBool('auto_accept_invites');
        cboMsgOptions.ItemIndex := getInt('msg_treatment');
        cboPresTracking.ItemIndex := getInt('pres_tracking');
        self.chkLogClick(nil);

        // Dialog Options
        chkRosterAlpha.Checked := getBool('roster_alpha');
        chkToastAlpha.Checked := getBool('toast_alpha');
        chkSnap.Checked := getBool('snap_on');
        chkRosterAlphaClick(Self);
        if chkRosterAlpha.Checked then begin
            trkRosterAlpha.Position := getInt('roster_alpha_val');
            spnRosterAlpha.Position := trkRosterAlpha.Position;
            end
        else begin
            trkRosterAlpha.Position := 255;
            spnRosterAlpha.Position := 255;
            end;

        chkToastAlphaClick(Self);
        if chkToastAlpha.Checked then begin
            trkToastAlpha.Position := getInt('toast_alpha_val');
            spnToastAlpha.Position := trkToastAlpha.Position;
            end
        else begin
            trkToastAlpha.Position := 255;
            spnToastAlpha.Position := 255;
            end;

        chkSnapClick(Self);
        if (chkSnap.Checked) then
            spnSnap.Position := getInt('edge_snap')
        else
            spnSnap.Position := 10;


        // Notify Options
        SetLength(_notify, NUM_NOTIFIES);

        chkSound.Checked := getBool('notify_sounds');
        chkNotifyActive.Checked := getBool('notify_active');
        chkNotifyActiveWindow.Checked := getBool('notify_active_win');
        chkFlashInfinite.Checked := getBool('notify_flasher');
        _notify[0]  := getInt('notify_online');
        _notify[1]  := getInt('notify_offline');
        _notify[2]  := getInt('notify_newchat');
        _notify[3]  := getInt('notify_normalmsg');
        _notify[4]  := getInt('notify_s10n');
        _notify[5]  := getInt('notify_invite');
        _notify[6]  := getInt('notify_keyword');
        _notify[7]  := getInt('notify_chatactivity');
        _notify[8]  := getInt('notify_roomactivity');
        _notify[9]  := getInt('notify_oob');
        _notify[10] := getInt('notify_autoresponse');

        optNotify.Enabled;
        chkToast.Checked := false;
        chkFlash.Checked := false;

        for i := 0 to NUM_NOTIFIES - 1 do
            chkNotify.Checked[i] := (_notify[i] > 0);

        chkNotify.ItemIndex := 0;
        chkNotifyClick(Self);

        // Autoaway options
        chkAutoAway.Checked := getBool('auto_away');
        chkAAReducePri.Checked := getBool('aa_reduce_pri');
        spnAway.Position := getInt('away_time');
        spnXA.Position := getInt('xa_time');
        txtAway.Text := getString('away_status');
        txtXA.Text := getString('xa_status');

        // Keywords and Blockers
        fillStringList('keywords', memKeywords.Lines);
        chkRegex.Checked := getBool('regex_keywords');
        fillStringList('blockers', memBlocks.Lines);
        fillStringList('plugins', memPlugins.Lines);

        // Custom Presence options
        _pres_list := getAllPresence();
        for i := 0 to _pres_list.Count - 1 do
            lstCustomPres.Items.Add(TJabberCustomPres(_pres_list[i]).title);
        chkPresenceMessageSend.Checked := getBool('presence_message_send');
        chkPresenceMessageListen.Checked := getBool('presence_message_listen');
        end;
end;

{---------------------------------------}
procedure TfrmPrefs.SavePrefs;
var
    i: integer;
    cp: TJabberCustomPres;
    reg: TRegistry;
    cmd: string;
begin
    // save prefs to the reg
    with MainSession.Prefs do begin
        BeginUpdate();

        // Roster prefs
        setBool('roster_only_online', chkOnlineOnly.Checked);
        setBool('roster_show_unsub', chkShowUnsubs.Checked);
        setBool('roster_show_pending', chkShowPending.Checked);
        setBool('roster_offline_group', chkOfflineGroup.Checked);
        setBool('roster_hide_block', chkHideBlocked.Checked);
        setBool('inline_status', chkInlineStatus.Checked);
        setInt('inline_color', integer(cboInlineStatus.Selected));
        setBool('roster_chat', (optDBlClick.ItemIndex = 0));
        setBool('roster_pres_errors', chkPresErrors.Checked);

        // S10n prefs
        setInt('s10n_auto_accept', optIncomingS10n.ItemIndex);

        // System Prefs
        setBool('auto_updates', chkAutoUpdate.Checked);
        setBool('auto_start', chkAutoStart.Checked);
        setBool('debug', chkDebug.Checked);
        setBool('window_ontop', chkOnTop.Checked);
        setBool('window_toolbox', chkToolbox.Checked);
        setBool('autologin', chkAutoLogin.Checked);
        setBool('close_min', chkCloseMin.Checked);
        setString('xfer_path', txtXFerPath.Text);

        // Message Prefs
        setBool('timestamp', chkTimestamp.Checked);
        setString('timestamp_format', txtTimestampFmt.Text);
        setBool('emoticons', chkEmoticons.Checked);
        setBool('msg_queue', chkMsgQueue.Checked);
        setBool('close_queue', chkCloseQueue.Checked);
        setBool('log', chkLog.Checked);
        setBool('auto_accept_invites', chkAutoAcceptInvites.Checked);
        setBool('log_rooms', chkLogRooms.Checked);
        setString('log_path', txtLogPath.Text);
        setString('spool_path', txtSpoolPath.Text);
        setInt('msg_treatment', cboMsgOptions.ItemIndex);
        setInt('pres_tracking', cboPresTracking.ItemIndex);

        reg := TRegistry.Create();
        try
            reg.RootKey := HKEY_CURRENT_USER;
            reg.OpenKey(RUN_ONCE, true);

            if (not chkAutoStart.Checked) then begin
                if (reg.ValueExists('Exodus')) then
                    reg.DeleteValue('Exodus');
                end
            else begin
                cmd := '"' + ParamStr(0) + '"';
                for i := 1 to ParamCount do
                    cmd := cmd + ' ' + ParamStr(i);
                reg.WriteString('Exodus',  cmd);
                end;
            reg.CloseKey();
        finally
            reg.Free();
        end;

        // Dialog Prefs
        setBool('roster_alpha', chkRosterAlpha.Checked);
        setInt('roster_alpha_val', trkRosterAlpha.Position);
        setBool('toast_alpha', chkToastAlpha.Checked);
        setInt('toast_alpha_val', trkToastAlpha.Position);
        setBool('snap_on', chkSnap.Checked);
        setInt('edge_snap', spnSnap.Position);

        // Notify events
        setBool('notify_sounds', chkSound.Checked);
        setBool('notify_active', chkNotifyActive.Checked);
        setBool('notify_active_win', chkNotifyActiveWindow.Checked);
        setBool('notify_flasher', chkFlashInfinite.Checked);

        setInt('notify_online', _notify[0]);
        setInt('notify_offline', _notify[1]);
        setInt('notify_newchat', _notify[2]);
        setInt('notify_normalmsg', _notify[3]);
        setInt('notify_s10n', _notify[4]);
        setInt('notify_invite', _notify[5]);
        setInt('notify_keyword', _notify[6]);
        setInt('notify_chatactivity', _notify[7]);
        setInt('notify_roomactivity', _notify[8]);
        setInt('notify_oob', _notify[9]);
        setInt('notify_autoresponse', _notify[10]);

        // Autoaway options
        setBool('auto_away', chkAutoAway.Checked);
        setBool('aa_reduce_pri', chkAAReducePri.Checked);
        setInt('away_time', spnAway.Position);
        setInt('xa_time', spnXA.Position);
        setString('away_status', txtAway.Text);
        setString('xa_status', txtXA.Text);

        // Keywords
        setStringList('keywords', memKeywords.Lines);
        setBool('regex_keywords', chkRegex.Checked);
        setStringList('blockers', memBlocks.Lines);
        setStringList('plugins', memPlugins.Lines);

        // Custom presence list
        RemoveAllPresence();
        for i := 0 to _pres_list.Count - 1 do begin
            cp := TJabberCustomPres(_pres_list.Items[i]);
            setPresence(cp);
            end;
        setBool('presence_message_send', chkPresenceMessageSend.Checked);
        setBool('presence_message_listen', chkPresenceMessageListen.Checked);
        EndUpdate();
        end;
    MainSession.FireEvent('/session/prefs', nil);
end;

{---------------------------------------}
procedure TfrmPrefs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmPrefs.FormCreate(Sender: TObject);
begin
    tbsRoster.TabVisible := false;
    tbsSubscriptions.TabVisible := false;
    tbsFonts.TabVisible := false;
    tbsSystem.TabVisible := false;
    tbsDialog.TabVisible := false;
    tbsMessages.TabVisible := false;
    tbsNotify.TabVisible := false;
    tbsAway.TabVisible := false;
    tbsKeywords.TabVisible := false;
    tbsBlockList.TabVisible := false;
    tbsCustomPres.TabVisible := false;
    tbsPlugins.TabVisible := false;

    chkNotify.Items.Strings[0]  := sSoundOnline;
    chkNotify.Items.Strings[1]  := sSoundOffline;
    chkNotify.Items.Strings[2]  := sSoundNewchat;
    chkNotify.Items.Strings[3]  := sSoundNormalmsg;
    chkNotify.Items.Strings[4]  := sSoundS10n;
    chkNotify.Items.Strings[5]  := sSoundInvite;
    chkNotify.Items.Strings[6]  := sSoundKeyword;
    chkNotify.Items.Strings[7]  := sSoundChatactivity;
    chkNotify.Items.Strings[8]  := sSoundRoomactivity;
    chkNotify.Items.Strings[9]  := sSoundOOB;
    chkNotify.Items.Strings[10] := sSoundAutoResponse;

    PageControl1.ActivePage := tbsRoster;

    _no_notify_update := false;
    _no_pres_change := false;

    MainSession.Prefs.RestorePosition(Self);
end;

{---------------------------------------}
procedure TfrmPrefs.TabSelect(Sender: TObject);
var
    // img: TImage;
    lbl: TLabel;
    i: integer;
    c: TControl;
begin
    lbl := nil;
    if ((Sender = imgRoster) or (Sender = lblRoster)) then begin
        PageControl1.ActivePage := tbsRoster;
        // img := imgRoster;
        lbl := lblRoster;
        end
    else if ((Sender = imgS10n) or (Sender = lblS10n)) then begin
        PageControl1.ActivePage := tbsSubscriptions;
        // img := imgS10n;
        lbl := lblS10n;
        end
    else if ((Sender = imgFonts) or (Sender = lblFonts)) then begin
        PageControl1.ActivePage := tbsFonts;
        // img := imgFonts;
        lbl := lblFonts;
        end
    else if ((Sender = imgSystem) or (Sender = lblSystem)) then begin
        PageControl1.ActivePage := tbsSystem;
        // img := imgSystem;
        lbl := lblSystem;
        end
    else if ((Sender = imgDialog) or (Sender = lblDialog)) then begin
        PageControl1.ActivePage := tbsDialog;
        // img := imgDialog;
        lbl := lblDialog;
        end
    else if ((Sender = imgNotify) or (Sender = lblNotify)) then begin
        PageControl1.ActivePage := tbsNotify;
        // img := imgNotify;
        lbl := lblNotify;
        end
    else if ((Sender = imgAway) or (Sender = lblAway)) then begin
        PageControl1.ActivePage := tbsAway;
        // img := imgAway;
        lbl := lblAway;
        end
    else if ((Sender = imgKeywords) or (Sender = lblKeywords)) then begin
        PageControl1.ActivePage := tbsKeywords;
        // img := imgKeywords;
        lbl := lblKeywords;
        end
    else if ((Sender = imgBlockList) or (Sender = lblBlockList)) then begin
        PageControl1.ActivePage := tbsBlockList;
        // img := imgBlocklist;
        lbl := lblBlocklist;
        end
    else if ((Sender = imgCustompres) or (Sender = lblCustomPres)) then begin
        PageControl1.ActivePage := tbsCustomPres;
        // img := imgCustompres;
        lbl := lblCustompres;
        end
    else if ((Sender = imgMessages) or (Sender = lblMessages)) then begin
        PageControl1.ActivePage := tbsMessages;
        // img := imgMessages;
        lbl := lblMessages;
        end
    else if ((Sender = imgPlugins) or (Sender = lblPlugins)) then begin
        PageControl1.ActivePage := tbsPlugins;
        // img := imgPlugins;
        lbl := lblPlugins;
        end;

    for i := 0 to ScrollBox1.ControlCount - 1 do begin
        c := ScrollBox1.Controls[i];
        if (c is TLabel) then begin
            if (c = lbl) then begin
                TLabel(c).Color := clHighlight;
                TLabel(c).Font.Color := clHighlightText;
                end
            else begin
                TLabel(c).Color := clWindow;
                TLabel(c).Font.Color := clWindowText;
                end;
            end;
        end;
end;

{---------------------------------------}
procedure TfrmPrefs.frameButtons1btnOKClick(Sender: TObject);
begin
    SavePrefs;
    Self.BringToFront();
end;

{---------------------------------------}
procedure TfrmPrefs.trkRosterAlphaChange(Sender: TObject);
begin
    spnRosterAlpha.Position := trkRosterAlpha.Position;
end;

{---------------------------------------}
procedure TfrmPrefs.chkRosterAlphaClick(Sender: TObject);
begin
    trkRosterAlpha.Enabled := chkRosterAlpha.Checked;
    spnRosterAlpha.Enabled := chkRosterAlpha.Checked;
    txtRosterAlpha.Enabled := chkRosterAlpha.Checked;
end;

{---------------------------------------}
procedure TfrmPrefs.txtToastAlphaChange(Sender: TObject);
begin
    try
        trkToastAlpha.Position := StrToInt(txtToastAlpha.Text);
    except
    end;
end;

{---------------------------------------}
procedure TfrmPrefs.txtRosterAlphaChange(Sender: TObject);
begin
    try
        trkRosterAlpha.Position := StrToInt(txtRosterAlpha.Text);
    except
    end;
end;

{---------------------------------------}
procedure TfrmPrefs.chkNotifyClick(Sender: TObject);
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

    if chkToast.Enabled then begin
        chkToast.Checked := ((_notify[i] and notify_toast) > 0);
        chkFlash.Checked := ((_notify[i] and notify_flash) > 0);
        end
    else begin
        chkToast.Checked := false;
        chkFlash.Checked := false;
        _notify[i] := 0;
        end;

    _no_notify_update := false;
end;

{---------------------------------------}
procedure TfrmPrefs.chkToastClick(Sender: TObject);
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
end;

{---------------------------------------}
procedure TfrmPrefs.chkToastAlphaClick(Sender: TObject);
begin
    trkToastAlpha.Enabled := chkToastAlpha.Checked;
    spnToastAlpha.Enabled := chkToastAlpha.Checked;
    txtToastAlpha.Enabled := chkToastAlpha.Checked;
end;

{---------------------------------------}
procedure TfrmPrefs.trkToastAlphaChange(Sender: TObject);
begin
    spnToastAlpha.Position := trkToastAlpha.Position;
end;

{---------------------------------------}
procedure TfrmPrefs.chkInlineStatusClick(Sender: TObject);
begin
    // toggle the color drop down on/off
    cboInlineStatus.Enabled := chkInlineStatus.Checked;
end;

{---------------------------------------}
procedure TfrmPrefs.lstCustomPresClick(Sender: TObject);
var
    e: boolean;
begin
    // show the props of this presence object
    _no_pres_change := true;

    e := (lstCustomPres.ItemIndex >= 0);
    txtCPTitle.Enabled := e;
    txtCPStatus.Enabled := e;
    txtCPPriority.Enabled := e;
    txtCPHotkey.Enabled := e;

    if (not e) then begin
        txtCPTitle.Text := '';
        txtCPStatus.Text := '';
        txtCPPriority.Text := '0';
        end
    else with TJabberCustomPres(_pres_list[lstCustomPres.ItemIndex]) do begin

        if (show = 'chat') then cboCPType.ItemIndex := 0
        else if (show = 'away') then cboCPType.Itemindex := 2
        else if (show = 'xa') then cboCPType.ItemIndex := 3
        else if (show = 'dnd') then cboCPType.ItemIndex := 4
        else
            cboCPType.ItemIndex := 1;

        txtCPTitle.Text := title;
        txtCPStatus.Text := status;
        txtCPPriority.Text := IntToStr(priority);
        txtCPHotkey.HotKey := TextToShortcut(hotkey);
        end;
    _no_pres_change := false;
end;

{---------------------------------------}
procedure TfrmPrefs.txtCPTitleChange(Sender: TObject);
var
    i: integer;
begin
    // something changed on the current custom pres object
    // automatically update it.
    if (lstCustomPres.ItemIndex < 0) then exit;
    if (not tbsCustomPres.Visible) then exit;
    if (_no_pres_change) then exit;

    i := lstCustomPres.ItemIndex;
    with  TJabberCustomPres(_pres_list[i]) do begin
        title := txtCPTitle.Text;
        status := txtCPStatus.Text;
        priority := SafeInt(txtCPPriority.Text);
        hotkey := ShortCutToText(txtCPHotkey.HotKey);
        case cboCPType.ItemIndex of
        0: show := 'chat';
        1: show := '';
        2: show := 'away';
        3: show := 'xa';
        4: show := 'dnd';
        end;
        if (title <> lstCustomPres.Items[i]) then
            lstCustomPres.Items[i] := title;
        end;
end;

{---------------------------------------}
procedure TfrmPrefs.btnCustomPresAddClick(Sender: TObject);
var
    cp: TJabberCustomPres;
begin
    // add a new custom pres
    cp := TJabberCustomPres.Create();
    cp.title := sPrefsDfltPres;
    cp.show := '';
    cp.Status := '';
    cp.priority := 0;
    cp.hotkey := '';
    _pres_list.Add(cp);
    lstCustompres.Items.Add(cp.title);
    lstCustompres.ItemIndex := lstCustompres.Items.Count - 1;
    lstCustompresClick(Self);
end;

{---------------------------------------}
procedure TfrmPrefs.btnCustomPresRemoveClick(Sender: TObject);
var
    cp: TJabberCustomPres;
begin
    // delete the current pres
    cp := TJabberCustomPres(_pres_list[lstCustomPres.ItemIndex]);
    _pres_list.Remove(cp);
    MainSession.Prefs.removePresence(cp);
    lstCustompres.Items.Delete(lstCustomPres.ItemIndex);
    lstCustompresClick(Self);
end;

{---------------------------------------}
procedure TfrmPrefs.btnCustomPresClearClick(Sender: TObject);
begin
    // clear all entries
    if MessageDlg(sPrefsClearPres, mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
    lstCustomPres.Items.Clear;
    _pres_list.Clear;
    lstCustompresClick(Self);
    MainSession.Prefs.removeAllPresence();
end;

{---------------------------------------}
procedure TfrmPrefs.btnLogBrowseClick(Sender: TObject);
var
    tmps: string;
begin
    tmps := txtLogPath.Text;
    if SelectDirectory(sPrefsLogDir, '', tmps) then
        txtLogPath.Text := tmps;
end;

{---------------------------------------}
procedure TfrmPrefs.btnTransferBrowseClick(Sender: TObject);
var
    tmps: string;
begin
    tmps := txtXFerPath.Text;
    if SelectDirectory(sPrefsXFerDir, '', tmps) then
        txtXFerPath.Text := tmps;
end;

{---------------------------------------}
procedure TfrmPrefs.chkSnapClick(Sender: TObject);
begin
    spnSnap.Enabled := chkSnap.Checked;
    txtSnap.Enabled := chkSnap.Checked;
end;

{---------------------------------------}
procedure TfrmPrefs.Label20Click(Sender: TObject);
var
    ver : integer;
    win : String;
begin
    ver := WindowsVersion(win);
    if (ver = cWIN_XP) then
        ShellExecute(Self.Handle, nil, 'rundll32.exe',
          'shell32.dll,Control_RunDLL mmsys.cpl,,1', nil, SW_SHOW)
    else 
        ShellExecute(Self.Handle, nil, 'rundll32.exe',
          'shell32.dll,Control_RunDLL mmsys.cpl,,0', nil, SW_SHOW);
end;

{---------------------------------------}
procedure TfrmPrefs.colorRosterMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    // find the "thing" that we clicked on in the window..
    lblColor.Caption := sRosterFontLabel;
    _clr_font := 'roster_font';
    _clr_font_color := 'roster_font_color';
    _clr_bg := 'roster_bg';
    _clr_control := colorRoster;

    btnFont.Enabled := true;
    clrBoxBG.Selected := TColor(MainSession.Prefs.getInt(_clr_bg));
    clrBoxFont.Selected := TColor(Mainsession.Prefs.getInt(_clr_font_color));
end;

{---------------------------------------}
procedure TfrmPrefs.clrBoxBGChange(Sender: TObject);
begin
    // change in the bg color
    MainSession.Prefs.setInt(_clr_bg, Integer(clrBoxBG.Selected));
    if (_clr_control = colorChat) then
        colorChat.Color := clrBoxBG.Selected
    else
        colorRoster.Color := clrBoxBG.Selected;
end;

{---------------------------------------}
procedure TfrmPrefs.clrBoxFontChange(Sender: TObject);
begin
    // change the font color
    MainSession.Prefs.setInt(_clr_font_color, integer(clrBoxFont.Selected));
    if (_clr_control = colorChat) then
        redrawChat()
    else
        colorRoster.Font.Color := clrBoxFont.Selected;
end;

{---------------------------------------}
procedure TfrmPrefs.redrawChat();
var
    m1, m2: TJabberMessage;
begin
    with colorChat do begin
        Lines.Clear;
        m1 := TJabberMessage.Create();
        with m1 do begin
            Body := 'Some text from me';
            isMe := true;
            Nick := 'pgm';
            end;
        m2 := TJabberMessage.Create();
        with m2 do begin
            Body := 'Some reply text';
            isMe := false;
            Nick := 'c-neal';
            end;

        DisplayMsg(m1, colorChat);
        DisplayMsg(m2, colorChat);

        m1.Free();
        m2.Free();
        end;
end;

{---------------------------------------}
procedure TfrmPrefs.btnFontClick(Sender: TObject);
begin
    // Change the roster font
    with FontDialog1 do begin
        if (_clr_control = colorRoster) then
            Font.Assign(colorRoster.Font)
        else
            Font.Assign(colorChat.Font);

        if Execute then begin
            if (_clr_control = colorRoster) then
                colorRoster.Font.Assign(Font)
            else begin
                colorChat.Font.Assign(Font);
                redrawChat();
                end;

            with MainSession.prefs do begin
                setString(_clr_font + '_name', Font.Name);
                setInt(_clr_font + '_charset', Font.Charset);
                setInt(_clr_font + '_size', Font.Size);
                setBool(_clr_font + '_bold', (fsBold in Font.Style));
                setBool(_clr_font + '_italic', (fsItalic in Font.Style));
                setBool(_clr_font + '_underline', (fsUnderline in Font.Style));
                end;
            end;
        end;
end;

{---------------------------------------}
procedure TfrmPrefs.colorChatMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    start: integer;
begin
    // Select the chat window
    lblColor.Caption := sChatFontLabel;
    _clr_control := colorChat;
    _clr_bg := 'color_bg';
    clrBoxBG.Selected := TColor(MainSession.Prefs.getInt(_clr_bg));

    start := colorChat.SelStart;

    if ((start >= 7) and (start <=  11)) then begin
        // on <pgm>, color-me
        _clr_font_color := 'color_me';
        _clr_font := '';
        end
    else if ((start >= 41) and (start <= 48)) then begin
        // on <c-neal>, color-other
        _clr_font_color := 'color_other';
        _clr_font := '';
        end
    else begin
        // normal window, font_color
        _clr_font_color := 'font_color';
        _clr_font := 'font';
        end;

    btnFont.Enabled := (_clr_font <> '');
    clrBoxFont.Selected := TColor(Mainsession.Prefs.getInt(_clr_font_color));

end;

procedure TfrmPrefs.chkLogClick(Sender: TObject);
begin
    chkLogRooms.Enabled := chkLog.Checked;
    txtLogPath.Enabled := chkLog.Checked;
    btnLogBrowse.Enabled := chkLog.Checked;
end;

procedure TfrmPrefs.btnLogClearAllClick(Sender: TObject);
begin
    ClearAllLogs();
end;

procedure TfrmPrefs.btnSpoolBrowseClick(Sender: TObject);
begin
    OpenDialog1.FileName := txtSpoolPath.Text;
    if (OpenDialog1.Execute) then
        txtSpoolPath.Text := OpenDialog1.FileName;
end;

end.

