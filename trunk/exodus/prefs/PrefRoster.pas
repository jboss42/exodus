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
  Dialogs, PrefPanel, StdCtrls, TntStdCtrls, ExtCtrls;

type
  TfrmPrefRoster = class(TfrmPrefPanel)
    Label18: TLabel;
    Label21: TLabel;
    chkOnlineOnly: TCheckBox;
    StaticText1: TStaticText;
    chkShowUnsubs: TCheckBox;
    chkOfflineGroup: TCheckBox;
    chkHideBlocked: TCheckBox;
    chkPresErrors: TCheckBox;
    chkShowPending: TCheckBox;
    chkMessenger: TCheckBox;
    cboDblClick: TComboBox;
    chkRosterUnicode: TCheckBox;
    chkCollapsed: TCheckBox;
    chkGroupCounts: TCheckBox;
    txtGatewayGrp: TTntComboBox;
    Label1: TLabel;
    txtDefaultGrp: TTntComboBox;
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
    ExUtils, Unicode, Session;

procedure TfrmPrefRoster.LoadPrefs();
var
    gs: TWidestringList;
begin
    // populate grp drop-downs.
    gs := TWidestringList.Create();
    gs.Assign(MainSession.Roster.GrpList);
    removeSpecialGroups(gs);
    gs.Sorted := true;
    gs.Sort();

    txtDefaultGrp.Items.Assign(gs);
    txtGatewayGrp.Items.Assign(gs);

    gs.Free();

    //
    with MainSession.Prefs do begin
        // Roster Prefs
        chkOnlineOnly.Checked := getBool('roster_only_online');
        chkShowUnsubs.Checked := getBool('roster_show_unsub');
        chkShowPending.Checked := getBool('roster_show_pending');
        chkOfflineGroup.Checked := getBool('roster_offline_group');
        chkHideBlocked.Checked := getBool('roster_hide_block');
        chkPresErrors.Checked := getBool('roster_pres_errors');
        chkMessenger.Checked := getBool('roster_messenger');
        chkRosterUnicode.Checked := getBool('roster_unicode');
        chkCollapsed.Checked := getBool('roster_collapsed');
        chkGroupCounts.Checked := getBool('roster_groupcounts');
        cboDblClick.ItemIndex := getInt('roster_chat');
        txtDefaultGrp.Text := getString('roster_default'); 
        txtGatewayGrp.Text := getString('roster_transport_grp');
    end;    
end;

procedure TfrmPrefRoster.SavePrefs();
begin
    //
    with MainSession.Prefs do begin
        // Roster prefs
        setBool('roster_only_online', chkOnlineOnly.Checked);
        setBool('roster_show_unsub', chkShowUnsubs.Checked);
        setBool('roster_show_pending', chkShowPending.Checked);
        setBool('roster_offline_group', chkOfflineGroup.Checked);
        setBool('roster_hide_block', chkHideBlocked.Checked);
        setInt('roster_chat', cboDblClick.ItemIndex);
        setBool('roster_pres_errors', chkPresErrors.Checked);
        setBool('roster_messenger', chkMessenger.Checked);
        setBool('roster_unicode', chkRosterUnicode.Checked);
        setBool('roster_collapsed', chkCollapsed.Checked);
        setBool('roster_groupcounts', chkGroupCounts.Checked);
        setString('roster_default', txtDefaultGrp.Text);
        setString('roster_transport_grp', txtGatewayGrp.Text);
    end;
end;

end.
