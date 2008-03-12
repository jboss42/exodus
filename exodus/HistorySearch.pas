unit HistorySearch;
{
    Copyright 2008, Estate of Peter Millard

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
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  Exform, ExtCtrls, TntExtCtrls,
  ComCtrls, TntComCtrls, StdCtrls,
  TntStdCtrls, StateForm,
  COMExodusHistorySearch,
  COMExodusHistoryResult,
  BaseMsgList,
  Exodus_TLB,
  JabberMsg,
  Unicode;

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
    lstResults: TTntListView;
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
    chkExact: TTntCheckBox;
    TntLabel3: TTntLabel;
    grpJID: TTntGroupBox;
    btnAddJID: TTntButton;
    btnRemoveJID: TTntButton;
    lstJids: TTntListBox;
    txtKeywords: TTntMemo;
    procedure FormResize(Sender: TObject);
    procedure btnAdvBasicSwitchClick(Sender: TObject);
    procedure radioAllClick(Sender: TObject);
    procedure radioRangeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dateFromChange(Sender: TObject);
    procedure dateToChange(Sender: TObject);
    procedure btnAddJIDClick(Sender: TObject);
    procedure lstJidsClick(Sender: TObject);
    procedure btnRemoveJIDClick(Sender: TObject);
    procedure btnSerachClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    // Variables
    _ResultsHistoryFrame: TObject;
    _MsglistType: integer;
    _DoAdvSearch: boolean;
    _SearchObj: IExodusHistorySearch;
    _ResultObj: IExodusHistoryResult;
    _ResultList: TWidestringList;

    // Methods
    function _getMsgList(): TfBaseMsgList;
    procedure _PossitionControls();
    procedure _AddJidToJIDList(jid: widestring);

  protected
    // Variables

    // Methods

  public
    // Variables

    // Methods
    procedure ResultCallback(msg: TJabberMessage);

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
    gnuGetText,
    SelContact,
    SQLSearchHandler,
    ExSession,
    ComObj;

{---------------------------------------}
procedure TfrmHistorySearch.btnAddJIDClick(Sender: TObject);
var
    dlg: TfrmSelContact;
    jid: widestring;
begin
    inherited;

    dlg := TfrmSelContact.Create(Self);
    if (dlg.ShowModal() = mrOK) then begin
        jid := dlg.GetSelectedJID();
        _AddJidToJIDList(jid);
    end;
end;

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
procedure TfrmHistorySearch.btnRemoveJIDClick(Sender: TObject);
begin
    inherited;
    lstJids.DeleteSelected();
    btnRemoveJID.Enabled := false; // We just removed the selected, so nothing can be selected
end;

{---------------------------------------}
procedure TfrmHistorySearch.btnSerachClick(Sender: TObject);
var
    i: integer;
begin
    inherited;

    _SearchObj := nil;
    _ResultObj := nil;

    _SearchObj := CreateCOMObject(CLASS_ExodusHistorySearch) as IExodusHistorySearch;
    _ResultObj := CreateCOMObject(CLASS_ExodusHistoryResult) as IExodusHistoryResult;

    _SearchObj.AddAllowedSearchType(SQLSEARCH_CHAT);
    _SearchObj.AddAllowedSearchType(SQLSEARCH_ROOM);

    if (_DoAdvSearch) then begin
        // Advanced Search
        if (radioRange.Checked) then begin
            _SearchObj.Set_maxDate(dateTo.DateTime);
            _SearchObj.Set_minDate(dateFrom.DateTime);
        end;

        for i := 0 to txtKeywords.Lines.Count - 1 do begin
            if (Trim(txtKeywords.Lines[i]) <> '') then begin
                _SearchObj.AddKeyword(Trim(txtkeywords.Lines[i]));
            end;
        end;

        _SearchObj.Set_ExactKeywordMatch(chkExact.Checked);

        for i := 0 to lstJids.Items.Count - 1 do begin
            if (Trim(lstJids.Items[i]) <> '') then begin
                _SearchObj.AddJid(Trim(lstJids.Items[i]));
            end;
        end;
    end
    else begin
        // Basic Search
        if (Trim(txtBasicHistoryFor.Text) <> '') then begin
            _SearchObj.AddJid(txtBasicHistoryFor.Text);
        end;

        if (Trim(txtBasicKeywordSearch.Text) <> '') then begin
            _SearchObj.AddKeyword(Trim(txtBasicKeywordSearch.Text));
        end;
    end;

    // Set Callback
    ExodusHistoryResultCallbackMap.AddCallback(Self.ResultCallback, _ResultObj);

    // Change to "searching GUI"

    HistorySearchManager.NewSearch(_SearchObj, _ResultObj);
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

    btnRemoveJID.Enabled := false;

    _SearchObj := nil;
    _ResultObj := nil;

    _ResultList := TWidestringList.Create();
end;

{---------------------------------------}
procedure TfrmHistorySearch.FormDestroy(Sender: TObject);
var
    i: integer;
    msg: TJabberMessage;
begin
    _SearchObj := nil;
    _ResultObj := nil;

    for i := _ResultList.Count - 1 downto 0 do begin
        msg := TJabberMessage(_ResultList.Objects[i]);
        msg.Free();
        _ResultList.Delete(i);
    end;
    _ResultList.Free();

    inherited;
end;

{---------------------------------------}
procedure TfrmHistorySearch.FormResize(Sender: TObject);
begin
    inherited;
    _PossitionControls();
end;

procedure TfrmHistorySearch.lstJidsClick(Sender: TObject);
begin
    inherited;
    if (lstJids.SelCount > 0) then begin
        btnRemoveJID.Enabled := true;
    end
    else begin
        btnRemoveJID.Enabled := false;
    end;
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

{---------------------------------------}
procedure TfrmHistorySearch._AddJidToJIDList(jid: widestring);
var
    i: integer;
begin
    if (Trim(jid) = '') then exit;

    // Check for dupe
    for i := 0 to lstJids.Count - 1 do begin
        if (jid = lstJids.Items[i]) then exit; // is a dupe
    end;

    // no dupes so go ahead and add to lsit
    lstJids.AddItem(jid, nil);

end;

{---------------------------------------}
procedure TfrmHistorySearch.ResultCallback(msg: TJabberMessage);
var
    newItem: TTntListItem;
    newmsg: TJabberMessage;
begin
    if (msg = nil) then begin
        // End of results - remove from Result callback map
        ExodusHistoryResultCallbackMap.DeleteCallback(_ResultObj);

        // Change GUI to "done searching"
    end
    else begin
        // Got another result so check to see if we should display it.
        newmsg := TJabberMessage.Create(msg);

        // Override the TJabberMessage timestamp
        // as it puts a Now() timestamp on when it
        // doesn't find the MSGDELAY tag.  As we
        // are pulling the original XML, it probably
        // didn't have this tag when we stored it.
        newmsg.Time := msg.Time;

        _ResultList.AddObject('', newmsg);

        newItem := lstResults.Items.Add();
        newItem.Caption := '';
        if (newmsg.isMe) then begin
            newItem.SubItems.Add(newmsg.ToJID);
        end
        else begin
            newItem.SubItems.Add(newmsg.FromJID);
        end;
        newItem.SubItems.Add(DateTimeToStr(newmsg.Time));
        newItem.SubItems.Add(newmsg.Body);
    end;
end;



end.
