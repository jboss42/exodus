unit PrefGroups;

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
    Label2: TLabel;
    cboVisible: TTntComboBox;
    chkCollapsed: TCheckBox;
    chkGroupCounts: TCheckBox;
    chkOfflineGrp: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefGroups: TfrmPrefGroups;

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

    //
    with MainSession.Prefs do begin
        // Roster Prefs
        cboVisible.ItemIndex := getInt('roster_visible');
        chkSort.Checked := getBool('roster_sort');
        chkGroupCounts.Checked := getBool('roster_groupcounts');
        chkCollapsed.Checked := getBool('roster_collapsed');
        chkOfflineGrp.Checked := getBool('roster_offline_group');
        txtDefaultGrp.Text := getString('roster_default');
        txtGatewayGrp.Text := getString('roster_transport_grp');
    end;
end;

procedure TfrmPrefGroups.SavePrefs();
begin
    //
    with MainSession.Prefs do begin
        // Roster prefs
        setInt('roster_visible', cboVisible.ItemIndex);
        setBool('roster_sort', chkSort.Checked);
        setBool('roster_groupcounts', chkGroupCounts.Checked);
        setBool('roster_collapsed', chkCollapsed.Checked);
        setBool('roster_offline_group', chkOfflineGrp.Checked);
        setString('roster_default', txtDefaultGrp.Text);
        setString('roster_transport_grp', txtGatewayGrp.Text);
    end;
end;


end.
