unit PrefRoster;
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
  Dialogs, PrefPanel, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls;

type
  TfrmPrefRoster = class(TfrmPrefPanel)
    lblDblClick: TTntLabel;
    chkShowUnsubs: TTntCheckBox;
    chkHideBlocked: TTntCheckBox;
    chkPresErrors: TTntCheckBox;
    chkShowPending: TTntCheckBox;
    cboDblClick: TTntComboBox;
    chkRosterUnicode: TTntCheckBox;
    chkInlineStatus: TTntCheckBox;
    cboInlineStatus: TColorBox;
    chkNestedGrps: TTntCheckBox;
    txtGrpSeperator: TTntEdit;
    lblNestedGrpSeparator: TTntLabel;
    chkRosterAvatars: TTntCheckBox;
    chkUseProfileDN: TTntCheckBox;
    txtDNProfileMap: TTntEdit;
    lblDNProfileMap: TTntLabel;
    procedure chkInlineStatusClick(Sender: TObject);
    procedure chkNestedGrpsClick(Sender: TObject);
    procedure chkUseProfileDNClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefRoster: TfrmPrefRoster;

implementation
{$R *.dfm}

uses
    JabberUtils, ExUtils,  Unicode, Session;

procedure TfrmPrefRoster.LoadPrefs();
begin
    inherited;
    cboInlineStatus.Enabled := chkInlineStatus.Checked;
    if (MainSession.Prefs.getBool('branding_nested_subgroup') = false) then begin
      txtGrpSeperator.Visible := false;
      chkNestedGrps.Visible := false;
      lblNestedGrpSeparator.Visible := false;
      chkNestedGrps.Checked := false;
    end
    else
      txtGrpSeperator.Enabled := chkNestedGrps.Checked;

    Self.cboInlineStatus.Enabled := Self.chkInlineStatus.Checked;
    Self.cboInlineStatus.Visible := Self.chkInlineStatus.Visible;
    Self.lblDNProfileMap.Enabled := Self.chkUseProfileDN.Checked;
    Self.txtDNProfileMap.Enabled := Self.chkUseProfileDN.Checked;
    Self.lblDNProfileMap.Visible := Self.chkUseProfileDN.Visible;
    Self.txtDNProfileMap.Visible := Self.chkUseProfileDN.Visible;

    if (MainSession.Prefs.getBool('brand_allow_blocking_jids') = false) then
        chkHideBlocked.Enabled := false;

end;

procedure TfrmPrefRoster.SavePrefs();
begin
    inherited;

    // XXX: save nested group seperator per JEP-48
end;

procedure TfrmPrefRoster.chkInlineStatusClick(Sender: TObject);
begin
  inherited;
    // toggle the color drop down on/off
    cboInlineStatus.Enabled := chkInlineStatus.Checked;
end;

procedure TfrmPrefRoster.chkNestedGrpsClick(Sender: TObject);
begin
  inherited;
    txtGrpSeperator.Enabled := chkNestedGrps.Checked;
end;

procedure TfrmPrefRoster.chkUseProfileDNClick(Sender: TObject);
begin
  inherited;
    Self.lblDNProfileMap.Enabled := Self.chkUseProfileDN.Checked;
    Self.txtDNProfileMap.Enabled := Self.chkUseProfileDN.Checked;
end;

end.
