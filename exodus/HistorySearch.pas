unit HistorySearch;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  Exform, ExtCtrls, TntExtCtrls,
  ComCtrls, TntComCtrls, StdCtrls,
  TntStdCtrls, StateForm,
  BaseMsgList;

type
  TfrmHistorySearch = class(TExForm)
    pnlAdvancedSearchBar: TTntPanel;
    pnlBasicSearchBar: TTntPanel;
    lblBasicHistoryFor: TTntLabel;
    lblBasicKeywordSearch: TTntLabel;
    txtBasicHistoryFor: TTntEdit;
    txtBasicKeywordSearch: TTntEdit;
    pnlBasicSearchHistoryFor: TTntPanel;
    pnlSearchBar: TTntPanel;
    pnlBasicSearchKeywordSearch: TTntPanel;
    pnlResults: TTntPanel;
    pnlControlBar: TTntPanel;
    btnSerach: TTntButton;
    btnAdvBasicSwitch: TTntButton;
    pnlResultsList: TTntPanel;
    TntListView1: TTntListView;
    Splitter1: TSplitter;
    pnlResultsHistory: TTntPanel;
    radioAll: TTntRadioButton;
    radioRange: TTntRadioButton;
    dateFrom: TTntDateTimePicker;
    dateTo: TTntDateTimePicker;
    lblFrom: TTntLabel;
    grpDate: TTntGroupBox;
    lblTo: TTntLabel;
    grpKeyword: TTntGroupBox;
    txtKeywords: TTntEdit;
    chkExact: TTntCheckBox;
    TntLabel3: TTntLabel;
    grpJID: TTntGroupBox;
    btnAddJID: TTntButton;
    btnRemoveJID: TTntButton;
    lstJids: TTntListBox;
    procedure FormResize(Sender: TObject);
    procedure btnAdvBasicSwitchClick(Sender: TObject);
    procedure radioAllClick(Sender: TObject);
    procedure radioRangeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dateFromChange(Sender: TObject);
    procedure dateToChange(Sender: TObject);
  private
    // Variables
    _ResultsHistoryFrame: TObject;
    _MsglistType: integer;
    _DoAdvSearch: boolean;

    // Methods
    function _getMsgList(): TfBaseMsgList;
    procedure _PossitionControls();
  protected
    // Variables

    // Methods

  public
    // Variables

    // Methods

    // Properties
    property MsgList: TfBaseMsgList read _getMsgList;
  end;

const
    ADVPANEL_HEIGHT = 150;
    BASICPANEL_HEIGHT = 35;
    ADVGRPGUTTER_WIDTH = 8;
    DEFAULT_DATE_GAP_MONTHS = -2;

var
  frmHistorySearch: TfrmHistorySearch;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    IEMsgList,
    RTFMsgList,
    Session,
    BaseChat,
    gnuGetText;

{---------------------------------------}
procedure TfrmHistorySearch.btnAdvBasicSwitchClick(Sender: TObject);
begin
    inherited;

    if (_DoAdvSearch) then begin
        // Currently in adv serach
        pnlAdvancedSearchBar.Visible := false;
        pnlBasicSearchBar.Visible := true;
        btnAdvBasicSwitch.Caption := _('Advanced');
    end
    else begin
        // Currently in basic serach
        pnlBasicSearchBar.Visible := false;
        pnlAdvancedSearchBar.Visible := true;
        btnAdvBasicSwitch.Caption := _('Basic');
    end;

    _DoAdvSearch := (not _DoAdvSearch);
    _PossitionControls();
end;

{---------------------------------------}
procedure TfrmHistorySearch.dateFromChange(Sender: TObject);
begin
    inherited;
    if (dateFrom.DateTime > dateTo.DateTime) then begin
        dateTo.DateTime := dateFrom.DateTime;
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.dateToChange(Sender: TObject);
begin
    inherited;
    if (dateTo.DateTime < dateFrom.DateTime) then begin
        dateFrom.DateTime := dateTo.DateTime;
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.FormCreate(Sender: TObject);
begin
  inherited;

    _MsglistType := MainSession.prefs.getInt('msglist_type');
    case _MsglistType of
        RTF_MSGLIST  : _ResultsHistoryFrame := TfRTFMsgList.Create(Self);
        HTML_MSGLIST : _ResultsHistoryFrame := TfIEMsgList.Create(Self);
        else begin
            _ResultsHistoryFrame := TfRTFMsgList.Create(Self);
        end;
    end;

    with MsgList do begin
        Name := 'ResultsHistoryFrame';
        Parent := pnlResultsHistory;
        Align := alClient;
        Visible := true;
        Ready();
    end;

    dateTo.DateTime := Now();
    dateFrom.DateTime := IncMonth(dateTo.DateTime, DEFAULT_DATE_GAP_MONTHS);
end;

{---------------------------------------}
procedure TfrmHistorySearch.FormResize(Sender: TObject);
begin
    inherited;
    _PossitionControls();
end;

{---------------------------------------}
procedure TfrmHistorySearch.radioAllClick(Sender: TObject);
begin
    inherited;
    _PossitionControls();
end;

{---------------------------------------}
procedure TfrmHistorySearch.radioRangeClick(Sender: TObject);
begin
    inherited;
    _PossitionControls();
end;

{---------------------------------------}
function TfrmHistorySearch._getMsgList(): TfBaseMsgList;
begin
    Result := TfBaseMsgList(_ResultsHistoryFrame);
end;

{---------------------------------------}
procedure TfrmHistorySearch._PossitionControls();
var
    GroupBoxWidth: integer;
begin
    // Basic search bar
    pnlBasicSearchHistoryFor.Width := pnlBasicSearchBar.Width div 2;
    pnlBasicSearchKeywordSearch.Left := pnlBasicSearchBar.Width div 2;
    pnlBasicSearchKeywordSearch.Width := pnlBasicSearchBar.Width div 2;

    // Adv serach bar
    GroupBoxWidth := (pnlAdvancedSearchBar.Width - (4 * ADVGRPGUTTER_WIDTH)) div 3;
    grpDate.Width := GroupBoxWidth;
    grpKeyword.Width := GroupBoxWidth;
    grpJID.Width := GroupBoxWidth;
    grpKeyword.Left := grpDate.Left + grpDate.Width + ADVGRPGUTTER_WIDTH;
    grpJID.Left := pnlAdvancedSearchBar.Width - grpJID.Width - ADVGRPGUTTER_WIDTH;

    lblFrom.Enabled := radioRange.Checked;
    lblTo.Enabled := radioRange.Checked;
    dateFrom.Enabled := radioRange.Checked;
    dateTo.Enabled := radioRange.Checked;

    // Control bar
    if (_DoAdvSearch) then begin
        pnlSearchBar.Height := ADVPANEL_HEIGHT;
        pnlControlBar.Top := ADVPANEL_HEIGHT;
    end
    else begin
        pnlSearchBar.Height := BASICPANEL_HEIGHT;
        pnlControlBar.Top := BASICPANEL_HEIGHT;
    end;
end;







end.
