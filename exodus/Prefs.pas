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
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ComCtrls, StdCtrls, ExtCtrls, buttonFrame, CheckLst;

type
  TfrmPrefs = class(TForm)
    frameButtons1: TframeButtons;
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
    Label5: TLabel;
    pnlFont: TPanel;
    Button1: TButton;
    Label6: TLabel;
    pnlMyColor: TPanel;
    Button2: TButton;
    Label7: TLabel;
    pnlOtherColor: TPanel;
    Button3: TButton;
    Label8: TLabel;
    pnlBGColor: TPanel;
    Button4: TButton;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    StaticText3: TStaticText;
    tbsSystem: TTabSheet;
    StaticText4: TStaticText;
    chkTimestamp: TCheckBox;
    chkAutoUpdate: TCheckBox;
    chkLog: TCheckBox;
    chkExpanded: TCheckBox;
    imgSystem: TImage;
    lblSystem: TLabel;
    tbsDialog: TTabSheet;
    StaticText5: TStaticText;
    chkRosterAlpha: TCheckBox;
    trkRosterAlpha: TTrackBar;
    txtRosterAlpha: TEdit;
    spnRosterAlpha: TUpDown;
    chkFadeRoster: TCheckBox;
    chkDebug: TCheckBox;
    chkToastAlpha: TCheckBox;
    trkToastAlpha: TTrackBar;
    txtToastAlpha: TEdit;
    spnToastAlpha: TUpDown;
    tbsNotify: TTabSheet;
    chkNotify: TCheckListBox;
    optNotify: TGroupBox;
    chkFlash: TCheckBox;
    chkEvent: TCheckBox;
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
    Label1: TLabel;
    StaticText8: TStaticText;
    memKeywords: TMemo;
    tbsBlockList: TTabSheet;
    StaticText9: TStaticText;
    Label10: TLabel;
    memBlocks: TMemo;
    imgKeywords: TImage;
    lblKeywords: TLabel;
    imgBlockList: TImage;
    lblBlockList: TLabel;
    chkSound: TCheckBox;
    chkInlineStatus: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
  private
    { Private declarations }
    _notify: array of integer;
    _no_notify_update: boolean;
  public
    { Public declarations }
    procedure LoadPrefs;
    procedure SavePrefs;
  end;

var
  frmPrefs: TfrmPrefs;

procedure StartPrefs;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.DFM}
uses
    PrefController,
    Session;

{---------------------------------------}
procedure StartPrefs;
var
    f: TfrmPrefs;
begin
    f := TfrmPrefs.Create(Application);
    f.LoadPrefs;
    f.ShowModal;
end;

{---------------------------------------}
procedure TfrmPrefs.Button1Click(Sender: TObject);
var
    mColor: TColor;
    oColor: TColor;
begin
    if FontDialog1.Execute then begin
        mColor := (pnlMyColor.Font.Color);
        oColor := (pnlOtherColor.Font.Color);

        pnlFont.Font.Assign(FontDialog1.Font);
        pnlBGColor.Font.Assign(FontDialog1.Font);
        pnlMyColor.Font.Assign(FontDialog1.Font);
        pnlOtherColor.Font.Assign(FontDialog1.Font);

        pnlMyColor.Font.Color := (mColor);
        pnlOtherColor.Font.Color := (oColor);
        end;
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
        chkOfflineGroup.Checked := getBool('roster_offline_group');
        chkInlineStatus.Checked := getBool('inline_status');
        if (getBool('roster_chat')) then 
            optDblClick.ItemIndex := 0
        else
            optDblClick.ItemIndex := 1;

        // s10n prefs
        optIncomingS10n.ItemIndex := getInt('s10n_auto_accept');

        // Font, Color prefs
        pnlFont.Font.Name := getString('font_name');
        pnlFont.Font.Size := getInt('font_size');
        pnlFont.Font.Color := TColor(getInt('font_color'));
        pnlFont.Font.Style := [];
        if getBool('font_bold') then
            pnlFont.Font.Style := pnlFont.Font.Style + [fsBold];
        if getBool('font_italic') then
            pnlFont.Font.Style := pnlFont.Font.Style + [fsItalic];
        if getBool('font_underline') then
            pnlFont.Font.Style := pnlFont.Font.Style + [fsUnderline];

        pnlBGColor.Color := TColor(getInt('color_bg'));
        pnlFont.Color := pnlBGColor.Color;
        pnlMyColor.Color := pnlBGColor.Color;
        pnlOtherColor.Color := pnlBGColor.Color;

        pnlBGColor.Font.Assign(pnlFont.Font);
        pnlMyColor.Font.Assign(pnlFont.Font);
        pnlOtherColor.Font.Assign(pnlFont.Font);
        pnlMyColor.Font.Color := TColor(getInt('color_me'));
        pnlOtherColor.Font.Color := TColor(getInt('color_other'));

        FontDialog1.Font.Assign(pnlFont.Font);
        pnlFont.Caption := pnlFont.Font.Name + ', ' +
            IntToStr(pnlFont.Font.Size) + ' pt.';

        // System Prefs
        chkTimestamp.Checked := getBool('timestamp');
        chkAutoUpdate.Checked := getBool('auto_updates');
        chkLog.Checked := getBool('log');
        chkExpanded.Checked := getBool('expanded');
        chkDebug.Checked := getBool('debug');
        chkAutoLogin.Checked := getBool('autologin');

        // Dialog Options
        chkRosterAlpha.Checked := getBool('roster_alpha');
        chkFadeRoster.Checked := getBool('roster_fade');
        chkToastAlpha.Checked := getBool('toast_alpha');
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

        // Notify Options
        SetLength(_notify, 7);
        _notify[0] := getInt('notify_online');
        _notify[1] := getInt('notify_offline');
        _notify[2] := getInt('notify_newchat');
        _notify[3] := getInt('notify_normalmsg');
        _notify[4] := getInt('notify_s10n');
        _notify[5] := getInt('notify_invite');
        _notify[6] := getInt('notify_keyword');

        for i := 0 to High(_notify) do
            chkNotify.Checked[i] := (_notify[i] > 0);
        optNotify.Enabled;
        chkToast.Checked := false;
        chkEvent.Checked := false;
        chkFlash.Checked := false;
        chkSound.Checked := false;

        // Autoaway options
        chkAutoAway.Checked := getBool('auto_away');
        spnAway.Position := getInt('away_time');
        spnXA.Position := getInt('xa_time');
        txtAway.Text := getString('away_status');
        txtXA.Text := getString('xa_status');

        // Keywords and Blockers
        memKeywords.Lines.Assign(getStringList('keywords'));
        memBlocks.Lines.Assign(getStringList('blockers'));
        end;
end;

{---------------------------------------}
procedure TfrmPrefs.SavePrefs;
begin
    // save prefs to the reg
    with MainSession.Prefs do begin
        // Roster prefs
        setBool('roster_only_online', chkOnlineOnly.Checked);
        setBool('roster_show_unsub', chkShowUnsubs.Checked);
        setBool('roster_offline_group', chkOfflineGroup.Checked);
        setBool('inline_status', chkInlineStatus.Checked);
        setBool('roster_chat', (optDBlClick.ItemIndex = 0));

        // S10n prefs
        setInt('s10n_auto_accept', optIncomingS10n.ItemIndex);

        // Font, Color prefs
        setString('font_name', pnlFont.Font.Name);
        setInt('font_size', pnlFont.Font.Size);
        setInt('font_color', integer(pnlFont.Font.Color));
        setBool('font_bold', (fsBold in pnlFont.Font.Style));
        setBool('font_underline', (fsUnderline in pnlFont.Font.Style));
        setBool('font_italic', (fsItalic in pnlFont.Font.Style));
        setInt('color_bg', integer(pnlBGColor.Color));
        setInt('color_me', integer(pnlMyColor.Font.Color));
        setInt('color_other', integer(pnlOtherColor.Font.Color));

        // System Prefs
        setBool('timestamp', chkTimestamp.Checked);
        setBool('auto_updates', chkAutoUpdate.Checked);
        setBool('log', chkLog.Checked);
        setBool('debug', chkDebug.Checked);
        setBool('autologin', chkAutoLogin.Checked);

        // Dialog Prefs
        setBool('roster_alpha', chkRosterAlpha.Checked);
        setInt('roster_alpha_val', trkRosterAlpha.Position);
        setBool('toast_alpha', chkToastAlpha.Checked);
        setInt('toast_alpha_val', trkToastAlpha.Position);
        setBool('roster_fade', chkFadeRoster.Checked);

        // Notify events
        setInt('notify_online', _notify[0]);
        setInt('notify_offline', _notify[1]);
        setInt('notify_newchat', _notify[2]);
        setInt('notify_normalmsg', _notify[3]);
        setInt('notify_s10n', _notify[4]);
        setInt('notify_invite', _notify[5]);
        setInt('notify_keyword', _notify[6]);

        // Autoaway options
        setBool('auto_away', chkAutoAway.Checked);
        setInt('away_time', spnAway.Position);
        setInt('xa_time', spnXA.Position);
        setString('away_status', txtAway.Text);
        setString('xa_status', txtXA.Text);

        // Keywords
        setStringList('keywords', memKeywords.Lines);
        setStringList('blockers', memBlocks.Lines);

        end;
    MainSession.FireEvent('/session/prefs', nil);
end;

{---------------------------------------}
procedure TfrmPrefs.Button4Click(Sender: TObject);
begin
    // change the bgcolor
    if ColorDialog1.Execute then begin
        pnlFont.Color := ColorDialog1.Color;
        pnlBGColor.Color := ColorDialog1.Color;
        pnlMyColor.Color := ColorDialog1.Color;
        pnlOtherColor.Color := ColorDialog1.Color;
        end;
end;

{---------------------------------------}
procedure TfrmPrefs.Button2Click(Sender: TObject);
begin
    // change my color
    if ColorDialog1.Execute then
        pnlMyColor.Font.Color := ColorDialog1.Color;
end;

{---------------------------------------}
procedure TfrmPrefs.Button3Click(Sender: TObject);
begin
    // change other color
    if ColorDialog1.Execute then
        pnlOtherColor.Font.Color := ColorDialog1.Color;
end;

{---------------------------------------}
procedure TfrmPrefs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
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
    tbsNotify.TabVisible := false;
    tbsAway.TabVisible := false;
    tbsKeywords.TabVisible := false;
    tbsBlockList.TabVisible := false;

    PageControl1.ActivePage := tbsRoster;

    _no_notify_update := false;
end;

{---------------------------------------}
procedure TfrmPrefs.TabSelect(Sender: TObject);
begin
    if ((Sender = imgRoster) or (Sender = lblRoster)) then
        PageControl1.ActivePage := tbsRoster;
    if ((Sender = imgS10n) or (Sender = lblS10n)) then
        PageControl1.ActivePage := tbsSubscriptions;
    if ((Sender = imgFonts) or (Sender = lblFonts)) then
        PageControl1.ActivePage := tbsFonts;
    if ((Sender = imgSystem) or (Sender = lblSystem)) then
        PageControl1.ActivePage := tbsSystem;
    if ((Sender = imgDialog) or (Sender = lblDialog)) then
        PageControl1.ActivePage := tbsDialog;
    if ((Sender = imgNotify) or (Sender = lblNotify)) then
        PageControl1.ActivePage := tbsNotify;
    if ((Sender = imgAway) or (Sender = lblAway)) then
        PageControl1.ActivePage := tbsAway;
    if ((Sender = imgKeywords) or (Sender = lblKeywords)) then
        PageControl1.ActivePage := tbsKeywords;
    if ((Sender = imgBlockList) or (Sender = lblBlockList)) then
        PageControl1.ActivePage := tbsBlockList;

end;

{---------------------------------------}
procedure TfrmPrefs.frameButtons1btnOKClick(Sender: TObject);
begin
    SavePrefs;
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
    i: integer;
begin
    // Show this item's options in the optNotify box.
    i := chkNotify.ItemIndex;

    _no_notify_update := true;

    optNotify.Enabled := chkNotify.Checked[i];
    if optNotify.Enabled then begin
        chkToast.Checked := ((_notify[i] and notify_toast) > 0);
        chkEvent.Checked := ((_notify[i] and notify_event) > 0);
        chkFlash.Checked := ((_notify[i] and notify_flash) > 0);
        chkSound.Checked := ((_notify[i] and notify_sound) > 0);
        end
    else begin
        chkToast.Checked := false;
        chkEvent.Checked := false;
        chkFlash.Checked := false;
        chkSound.Checked := false;
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

    _notify[i] := 0;
    if (chkToast.Checked) then _notify[i] := _notify[i] + notify_toast;
    if (chkEvent.Checked) then _notify[i] := _notify[i] + notify_event;
    if (chkFlash.Checked) then _notify[i] := _notify[i] + notify_flash;
end;

{---------------------------------------}
procedure TfrmPrefs.chkToastAlphaClick(Sender: TObject);
begin
    trkToastAlpha.Enabled := chkToastAlpha.Checked;
    spnToastAlpha.Enabled := chkToastAlpha.Checked;
    txtToastAlpha.Enabled := chkToastAlpha.Checked;
end;

procedure TfrmPrefs.trkToastAlphaChange(Sender: TObject);
begin
    spnToastAlpha.Position := trkToastAlpha.Position;
end;

end.

