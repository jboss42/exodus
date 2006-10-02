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
  Dialogs, PrefPanel, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls;

type
  TfrmPrefGroups = class(TfrmPrefPanel)
    lblGatewayGrp: TTntLabel;
    lblDefaultGrp: TTntLabel;
    txtGatewayGrp: TTntComboBox;
    txtDefaultGrp: TTntComboBox;
    chkSort: TTntCheckBox;
    lblFilter: TTntLabel;
    cboVisible: TTntComboBox;
    chkCollapsed: TTntCheckBox;
    chkGroupCounts: TTntCheckBox;
    chkOfflineGrp: TTntCheckBox;
    chkOnlineOnly: TTntCheckBox;
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

const
    sOfflineGrpWarn = 'The offline group will only show up if you have show only online contacts turned off.';

implementation

{$R *.dfm}
uses
    GnuGetText, JabberUtils, ExUtils,  Session, PrefController, Unicode;

procedure TfrmPrefGroups.LoadPrefs();
var
    gs: TWidestringList;
begin
    // populate grp drop-downs.
    gs := TWidestringList.Create();
    MainSession.Roster.AssignGroups(gs);
    gs.Sorted := true;
    gs.Sort();

    AssignTntStrings(gs, txtDefaultGrp.Items);
    AssignTntStrings(gs, txtGatewayGrp.Items);

    gs.Free();

    inherited;
end;

procedure TfrmPrefGroups.SavePrefs();
begin
    inherited;
end;


procedure TfrmPrefGroups.chkOfflineGrpClick(Sender: TObject);
begin
  inherited;
    // this only makes sense if only online is OFF.
    if (not Self.Visible) then exit;

    if ((chkOfflineGrp.Checked) and (chkOnlineOnly.Checked)) then begin
        MessageDlgW(_(sOfflineGrpWarn), mtInformation, [mbOK], 0);
        chkOnlineOnly.Checked := false;
    end;
end;

end.
