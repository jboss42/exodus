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
  Dialogs, PrefPanel, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, ExGroupBox,
  Buttons, TntButtons, TntForms, ExFrame, ExBrandPanel;

type
  TfrmPrefRoster = class(TfrmPrefPanel)
    ExGroupBox1: TExBrandPanel;
    pnlRosterPrefs: TExBrandPanel;
    chkInlineStatus: TTntCheckBox;
    chkUseProfileDN: TTntCheckBox;
    chkCollapsed: TTntCheckBox;
    chkHideBlocked: TTntCheckBox;
    chkGroupCounts: TTntCheckBox;
    chkOnlineOnly: TTntCheckBox;
    pnlManageBtn: TExBrandPanel;
    btnManageBlocked: TTntButton;
    grpAdvanced: TExGroupBox;
    chkNestedGrps: TTntCheckBox;
    gbDepricated: TExGroupBox;
    chkSort: TTntCheckBox;
    chkOfflineGrp: TTntCheckBox;
    pnlMinStatus: TExBrandPanel;
    lblFilter: TTntLabel;
    cboVisible: TTntComboBox;
    pnlGatewayGroup: TExBrandPanel;
    lblGatewayGrp: TTntLabel;
    txtGatewayGrp: TTntComboBox;
    chkPresErrors: TTntCheckBox;
    chkShowPending: TTntCheckBox;
    chkShowUnsubs: TTntCheckBox;
    chkRosterUnicode: TTntCheckBox;
    chkRosterAvatars: TTntCheckBox;
    pnlDblClickAction: TExBrandPanel;
    lblDblClick: TTntLabel;
    cboDblClick: TTntComboBox;
    pnlGroupSeperator: TExBrandPanel;
    lblGrpSeperator: TTntLabel;
    txtGrpSeperator: TTntEdit;
    pnlDefaultNIck: TExBrandPanel;
    lblDefaultNick: TTntLabel;
    txtDefaultNick: TTntEdit;
    pnlStatusColor: TExBrandPanel;
    lblStatusColor: TTntLabel;
    cboStatusColor: TColorBox;
    pnlDNFields: TExBrandPanel;
    lblDNProfileMap: TTntLabel;
    txtDNProfileMap: TTntEdit;
    pnlDefaultGroup: TExBrandPanel;
    lblDefaultGrp: TTntLabel;
    txtDefaultGrp: TTntComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

//var
//  frmPrefRoster: TfrmPrefRoster;

implementation
{$R *.dfm}

uses
    JabberUtils, ExUtils,  Unicode, Session,
    PrefFile, PrefController;

procedure TfrmPrefRoster.LoadPrefs();
var
    gs: TWidestringList;
begin
    inherited;

    // populate grp drop-downs.
    gs := TWidestringList.Create();
    MainSession.Roster.AssignGroups(gs);
    gs.Sorted := true;
    gs.Sort();

    AssignTntStrings(gs, txtDefaultGrp.Items);

    //populate gateway gropup cbo
    if (gs.IndexOf(txtGatewayGrp.Text) = -1) then
        gs.Add(txtGatewayGrp.Text);
    gs.Sort();
    AssignTntStrings(gs, txtGatewayGrp.Items);
    gs.Free();


    //disable/hide based on brand
    if (MainSession.Prefs.getBool('brand_allow_blocking_jids') = false) then begin
        chkHideBlocked.Enabled := false;
        chkHideBlocked.visible := false;
        btnManageBlocked.Visible := false;
    end;
        //hide nick panel if branded locked down or if pref is locked down
    if (MainSession.Prefs.GetBool('brand_prevent_change_nick')) then begin
        lblDefaultNick.Visible := false;
        txtDefaultNick.Visible := false;
    end;

    if (not MainSession.Prefs.getBool('branding_nested_subgroup')) then begin
        txtGrpSeperator.Visible := false;
        chkNestedGrps.Visible := false;
        lblGrpSeperator.Visible := false;

        chkNestedGrps.Checked := false;
    end;

    ExGroupBox1.checkAutoHide();
end;

procedure TfrmPrefRoster.SavePrefs();
begin
    inherited;

    // XXX: save nested group seperator per JEP-48
end;

end.
