unit PrefGroups;
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
  Dialogs, PrefPanel, StdCtrls, TntStdCtrls;

type
  TfrmPrefGroups = class(TfrmPrefPanel)
    StaticText1: TStaticText;
    Label18: TLabel;
    Label1: TLabel;
    txtGatewayGrp: TTntComboBox;
    txtDefaultGrp: TTntComboBox;
    chkSort: TCheckBox;
    lblFilter: TLabel;
    cboVisible: TTntComboBox;
    chkCollapsed: TCheckBox;
    chkGroupCounts: TCheckBox;
    chkOfflineGrp: TCheckBox;
    chkOnlineOnly: TCheckBox;
    procedure chkOfflineGrpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefGroups: TfrmPrefGroups;

resourcestring
    sOfflineGrpWarn = 'The offline group will only show up if you have show only online contacts turned off.';

implementation

{$R *.dfm}
uses
    ExUtils, Session, PrefController, Unicode;

procedure TfrmPrefGroups.LoadPrefs();
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

    with MainSession.Prefs do begin
        // Roster Prefs
        chkSort.Checked := getBool('roster_sort');
        chkGroupCounts.Checked := getBool('roster_groupcounts');
        chkCollapsed.Checked := getBool('roster_collapsed');
        chkOfflineGrp.Checked := getBool('roster_offline_group');
        chkOnlineOnly.Checked := getBool('roster_only_online');
        cboVisible.ItemIndex := getInt('roster_filter') - 1;
        txtDefaultGrp.Text := getString('roster_default');
        txtGatewayGrp.Text := getString('roster_transport_grp');
    end;
end;

procedure TfrmPrefGroups.SavePrefs();
begin
    //
    with MainSession.Prefs do begin
        // Roster prefs
        setBool('roster_only_online', chkOnlineOnly.Checked);
        setInt('roster_filter', cboVisible.ItemIndex + 1);
        setBool('roster_sort', chkSort.Checked);
        setBool('roster_groupcounts', chkGroupCounts.Checked);
        setBool('roster_collapsed', chkCollapsed.Checked);
        setBool('roster_offline_group', chkOfflineGrp.Checked);
        setString('roster_default', txtDefaultGrp.Text);
        setString('roster_transport_grp', txtGatewayGrp.Text);
    end;
end;


procedure TfrmPrefGroups.chkOfflineGrpClick(Sender: TObject);
begin
  inherited;
    // this only makes sense if only online is OFF.
    if (not Self.Visible) then exit;

    if ((chkOfflineGrp.Checked) and (chkOnlineOnly.Checked)) then begin
        MessageDlg(sOfflineGrpWarn, mtInformation, [mbOK], 0);
        chkOnlineOnly.Checked := false;
    end;
end;

end.
