unit PrefSystem;
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
    PrefPanel, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls;

type
  TfrmPrefSystem = class(TfrmPrefPanel)
    chkAutoUpdate: TTntCheckBox;
    chkDebug: TTntCheckBox;
    chkAutoLogin: TTntCheckBox;
    chkCloseMin: TTntCheckBox;
    chkAutoStart: TTntCheckBox;
    chkOnTop: TTntCheckBox;
    chkToolbox: TTntCheckBox;
    btnUpdateCheck: TTntButton;
    chkSingleInstance: TTntCheckBox;
    chkStartMin: TTntCheckBox;
    lblLang: TTntLabel;
    cboLocale: TTntComboBox;
    lblLangScan: TTntLabel;
    lblDefaultNick: TTntLabel;
    txtDefaultNick: TTntEdit;
    procedure btnUpdateCheckClick(Sender: TObject);
    procedure btnUpdateCheckMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblLangScanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    _dirty_locale: Widestring;
    _old_locale: Widestring;
    _lang_codes: TStringlist;

    procedure ScanLocales();
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefSystem: TfrmPrefSystem;

const
    sNoUpdate = 'No new update available.';
    sBadLocale = ' is set to use a language which is not available on your system. Resetting language to default.';
    sNewLocale1 = 'You must exit ';
    sNewLocale2 = ' and restart it before your new locale settings will take affect.';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$WARNINGS OFF}
{$R *.dfm}
uses
    LocalUtils, JabberUtils, ExUtils,  GnuGetText,
    AutoUpdate, FileCtrl,
    PathSelector, PrefController, Registry, Session, StrUtils;

const
    RUN_ONCE : string = '\Software\Microsoft\Windows\CurrentVersion\Run';

{---------------------------------------}
procedure TfrmPrefSystem.ScanLocales();
var
    langs: TStringlist;
    mo, lm, lang, dir: Widestring;
    sr: TSearchRec;
    lang_name: string;
begin
    // scan .\locale\... for possible lang packs
    dir := ExtractFilePath(Application.EXEName) + '\locale';

    // look for subdirs in locale
    langs := TStringlist.Create();
    _lang_codes.Clear();
    _lang_codes.Add('Default');
    _lang_codes.Add('en');
    if (DirectoryExists(dir)) then begin
        if (FindFirst(dir + '\*.*', faDirectory, sr) = 0) then begin
            repeat
                // check for a LM_MESSAGES dir, and default.mo inside of it
                lang := dir + sr.Name;
                lm := lang + '\LC_MESSAGES';
                if (DirectoryExists(lm)) then begin
                    mo := lm + '\default.mo';
                    if (FileExists(mo)) then begin
                        _lang_codes.add(sr.Name);
                        lang_name := getLocaleName(sr.Name);
                        if (lang_name <> '') then
                            langs.add(lang_name)
                        else
                            langs.add(sr.Name);
                    end;
                end;
            until FindNext(sr) <> 0;
            FindClose(sr);
        end;
    end;
    cboLocale.Items.Clear();
    cboLocale.Items.Assign(langs);
    cboLocale.Items.Insert(0, 'Default');
    cboLocale.Items.Insert(1, 'English');
    FreeAndNil(langs);
end;

{---------------------------------------}
procedure TfrmPrefSystem.LoadPrefs();
var
    i: integer;
    tmps: Widestring;
    reg: TRegistry;
begin
    // System Prefs
    _dirty_locale := '';
    if (_lang_codes = nil) then
        _lang_codes := TStringlist.Create();
    ScanLocales();

    inherited;

    with MainSession.Prefs do begin
        // locale info, we should always have at least "default-english"
        // in the drop down box here.
        tmps := getString('locale');
        // stay compatible with old prefs
        if (Pos('Default', tmps) = 1) then begin
            tmps := 'Default';
        end;
        _old_locale := tmps;
        _dirty_locale := tmps;

        if (tmps <> '') then begin
            i := _lang_codes.IndexOf(tmps);
            if (i >= 0) then
                cboLocale.ItemIndex := i
            else begin

                // check for en when given en_US
                i := Pos('_', tmps);
                if (i > 1) then begin
                    tmps := Copy(tmps, 1, i - 1);
                    i := _lang_codes.indexOf(tmps);
                end;

                if (i = -1) then begin
                    MessageDlgW(getAppInfo().ID +  _(sBadLocale), mtError, [mbOK], 0);
                    cboLocale.ItemIndex := 0;
                end
                else begin
                    _old_locale := tmps;
                    setString('locale', tmps);
                    cboLocale.ItemIndex := i;
                end;
            end;
        end
        else
            cboLocale.ItemIndex := 0;

        // Check to see if Exodus runs when windows starts
        reg := TRegistry.Create();
        try
            reg.RootKey := HKEY_CURRENT_USER;
            reg.OpenKey(RUN_ONCE, true);
            chkAutoStart.Checked := (reg.ValueExists(PrefController.getAppInfo.ID));
            reg.CloseKey();
        finally
            reg.Free();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmPrefSystem.SavePrefs();
var
    reg: TRegistry;
    tmp, cmd: Widestring;
    i: integer;
begin
    // System Prefs
    inherited;

    with MainSession.Prefs do begin
        i := cboLocale.ItemIndex;
        if (i < 0) then i := 0;
        tmp := _lang_codes[i];

        if (tmp <> _dirty_locale) then begin
            _dirty_locale := tmp;
            MessageDlgW(_(sNewLocale1) + getAppInfo().ID +  _(sNewLocale2), mtInformation, [mbOK], 0);
        end;

        setString('locale', tmp);

        reg := TRegistry.Create();
        try
            reg.RootKey := HKEY_CURRENT_USER;
            reg.OpenKey(RUN_ONCE, true);

            if (not chkAutoStart.Checked) then begin
                if (reg.ValueExists(PrefController.getAppInfo.ID)) then
                    reg.DeleteValue(PrefController.getAppInfo.ID);
            end
            else begin
                cmd := '"' + ParamStr(0) + '"';
                for i := 1 to ParamCount do
                    cmd := cmd + ' "' + ParamStr(i) + '"';
                reg.WriteString(PrefController.getAppInfo.ID,  cmd);
            end;
            reg.CloseKey();
        finally
            reg.Free();
        end;

    end;
end;

{---------------------------------------}
procedure TfrmPrefSystem.btnUpdateCheckClick(Sender: TObject);
var
    available : boolean;
begin
    Screen.Cursor := crHourGlass;
    available := InitAutoUpdate(false);
    Screen.Cursor := crDefault;

    if (not available) then
        MessageDlgW(_(sNoUpdate), mtInformation, [mbOK], 0);
end;

{---------------------------------------}
procedure TfrmPrefSystem.btnUpdateCheckMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if (ssShift in Shift) or (ssCtrl in Shift) then begin
        MainSession.Prefs.setDateTime('last_update', Now());
    end;
end;

{---------------------------------------}
procedure TfrmPrefSystem.lblLangScanClick(Sender: TObject);
begin
  inherited;
    ScanLocales();
end;

procedure TfrmPrefSystem.FormCreate(Sender: TObject);
begin
  inherited;
    AssignUnicodeURL(lblLangScan.Font, 8);
    if (MainSession.Prefs.getBool('brand_prevent_change_nick')) then begin
        txtDefaultNick.Visible := False;
        lblDefaultNick.Visible := False;
    end;
end;

end.
