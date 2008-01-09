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
    Dialogs, StdCtrls;

type
  TfrmPrefSystem = class(TfrmPrefPanel)
    StaticText4: TStaticText;
    chkAutoUpdate: TCheckBox;
    chkExpanded: TCheckBox;
    chkDebug: TCheckBox;
    chkAutoLogin: TCheckBox;
    chkCloseMin: TCheckBox;
    chkAutoStart: TCheckBox;
    chkOnTop: TCheckBox;
    chkToolbox: TCheckBox;
    btnUpdateCheck: TButton;
    chkSingleInstance: TCheckBox;
    chkStartMin: TCheckBox;
    Label7: TLabel;
    cboLocale: TComboBox;
    lblPluginScan: TLabel;
    procedure btnUpdateCheckClick(Sender: TObject);
    procedure btnUpdateCheckMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblPluginScanClick(Sender: TObject);
  private
    { Private declarations }
    _old_locale: Widestring;

    procedure ScanLocales();
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefSystem: TfrmPrefSystem;

resourcestring
    sNoUpdate = 'No new update available.';
    sBadLocale = 'Exodus is set to use a language which is not available on your system. Resetting language to default.';
    sNewLocale = 'You must exit exodus, and restart it before your new locale settings will take affect.';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$WARN UNIT_PLATFORM OFF}
{$R *.dfm}
uses
    AutoUpdate, FileCtrl,
    PathSelector, PrefController, Registry, Session;

const
    RUN_ONCE : string = '\Software\Microsoft\Windows\CurrentVersion\Run';

{---------------------------------------}
procedure TfrmPrefSystem.ScanLocales();
var
    langs: TStringlist;
    mo, lm, lang, dir: Widestring;
    sr: TSearchRec;
begin
    // scan .\locale\... for possible lang packs
    dir := ExtractFilePath(Application.EXEName) + '\locale';
    if (not DirectoryExists(dir)) then exit;

    // look for subdirs in locale
    langs := TStringlist.Create();
    if (FindFirst(dir + '\*.*', faDirectory, sr) = 0) then begin
        repeat
            // check for a LM_MESSAGES dir, and default.mo inside of it
            lang := dir + '\' + sr.Name;
            lm := lang + '\LC_MESSAGES';
            if (DirectoryExists(lm)) then begin
                mo := lm + '\default.mo';
                if (FileExists(mo)) then
                    langs.add(sr.Name);
            end;
        until FindNext(sr) <> 0;
        FindClose(sr);
    end;

    cboLocale.Items.Clear();
    cboLocale.Items.Assign(langs);
    cboLocale.Items.Insert(0, 'Default - English');
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
    ScanLocales();
    with MainSession.Prefs do begin
        chkAutoUpdate.Checked := getBool('auto_updates');
        chkAutoStart.Checked := getBool('auto_start');
        chkExpanded.Checked := getBool('expanded');
        chkDebug.Checked := getBool('debug');
        chkStartMin.Checked := getBool('min_start');
        chkAutoLogin.Checked := getBool('autologin');
        chkOnTop.Checked := getBool('window_ontop');
        chkToolbox.Checked := getBool('window_toolbox');
        chkCloseMin.Checked := getBool('close_min');
        chkSingleInstance.Checked := getBool('single_instance');

        // locale info, we should always have at least "default-english"
        // in the drop down box here.
        tmps := getString('locale');
        if (tmps <> '') then begin
            i := cboLocale.Items.IndexOf(tmps);
            if (i >= 0) then
                cboLocale.ItemIndex := i
            else begin
                MessageDlg(sBadLocale, mtError, [mbOK], 0);
                cboLocale.ItemIndex := 0;
            end;
        end
        else
            cboLocale.ItemIndex := 0;

        // Check to see if Exodus runs when windows starts
        reg := TRegistry.Create();
        try
            reg.RootKey := HKEY_CURRENT_USER;
            reg.OpenKey(RUN_ONCE, true);
            chkAutoStart.Checked := (reg.ValueExists('Exodus'));
            reg.CloseKey();
        finally
            reg.Free();
        end;

        _old_locale := cboLocale.Text;
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
    with MainSession.Prefs do begin
        setBool('auto_updates', chkAutoUpdate.Checked);
        setBool('auto_start', chkAutoStart.Checked);
        setBool('debug', chkDebug.Checked);
        setBool('min_start', chkStartMin.Checked);
        setBool('window_ontop', chkOnTop.Checked);
        setBool('window_toolbox', chkToolbox.Checked);
        setBool('autologin', chkAutoLogin.Checked);
        setBool('close_min', chkCloseMin.Checked);
        setBool('single_instance', chkSingleInstance.Checked);

        tmp := cboLocale.Text;
        if (tmp <> _old_locale) then
            MessageDlg(sNewLocale, mtInformation, [mbOK], 0);

        setString('locale', tmp);

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
        MessageDlg(sNoUpdate, mtInformation, [mbOK], 0);
end;

{---------------------------------------}
procedure TfrmPrefSystem.btnUpdateCheckMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if (ssShift in Shift) or (ssCtrl in Shift) then begin
        MainSession.Prefs.setString('last_update', DateTimeToStr(Now()));
    end;
end;

{---------------------------------------}
procedure TfrmPrefSystem.lblPluginScanClick(Sender: TObject);
begin
  inherited;
    ScanLocales();
end;

end.
