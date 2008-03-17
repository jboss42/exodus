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
  TResultListItem = class
    private
    protected
    public
    msg: TJabberMessage;
    listitem: TTntListItem;
  end;

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
    grpContacts: TTntGroupBox;
    btnAddContact: TTntButton;
    btnRemoveContact: TTntButton;
    lstContacts: TTntListBox;
    txtKeywords: TTntMemo;
    TntBevel1: TTntBevel;
    grpRooms: TTntGroupBox;
    btnAddRoom: TTntButton;
    btnRemoveRoom: TTntButton;
    lstRooms: TTntListBox;
    procedure FormResize(Sender: TObject);
    procedure btnAdvBasicSwitchClick(Sender: TObject);
    procedure radioAllClick(Sender: TObject);
    procedure radioRangeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dateFromChange(Sender: TObject);
    procedure dateToChange(Sender: TObject);
    procedure btnAddContactClick(Sender: TObject);
    procedure lstContactsClick(Sender: TObject);
    procedure btnRemoveContactClick(Sender: TObject);
    procedure btnSerachClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstResultsClick(Sender: TObject);
    procedure btnAddRoomClick(Sender: TObject);
    procedure btnRemoveRoomClick(Sender: TObject);
  private
    // Variables
    _ResultsHistoryFrame: TObject;
    _MsglistType: integer;
    _DoAdvSearch: boolean;
    _SearchObj: IExodusHistorySearch;
    _ResultObj: IExodusHistoryResult;
    _ResultList: TWidestringList;
    _DoingSearch: boolean;

    // Methods
    function _getMsgList(): TfBaseMsgList;
    procedure _PossitionControls();
    procedure _AddContactToContactList(contact: widestring);
    procedure _DropResults();

    // Properties
    property _MsgList: TfBaseMsgList read _getMsgList;

  protected
    // Variables

    // Methods

  public
    // Variables

    // Methods
    procedure ResultCallback(msg: TJabberMessage);

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
    ComObj,
    DisplayName,
    JabberID;

{---------------------------------------}
procedure TfrmHistorySearch.btnAddContactClick(Sender: TObject);
var
    dlg: TfrmSelContact;
    jid: widestring;
begin
    inherited;

    dlg := TfrmSelContact.Create(Self);
    if (dlg.ShowModal() = mrOK) then begin
        jid := dlg.GetSelectedJID();
        _AddContactToContactList(jid);
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.btnAddRoomClick(Sender: TObject);
begin
    inherited;
    Sleep(1);
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
procedure TfrmHistorySearch.btnRemoveContactClick(Sender: TObject);
begin
    inherited;
    lstContacts.DeleteSelected();
    btnRemoveContact.Enabled := false; // We just removed the selected, so nothing can be selected
end;

{---------------------------------------}
procedure TfrmHistorySearch.btnRemoveRoomClick(Sender: TObject);
begin
    inherited;
    Sleep(1);
end;

{---------------------------------------}
procedure TfrmHistorySearch.btnSerachClick(Sender: TObject);
var
    i: integer;
begin
    inherited;

    if (_DoingSearch) then begin
        HistorySearchManager.CancelSearch(_SearchObj.SearchID);

        // Switch to "search done" GUI
        _DoingSearch := false;
    end
    else begin
        _SearchObj := nil;

        _DropResults();

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

            for i := 0 to lstContacts.Items.Count - 1 do begin
                if (Trim(lstContacts.Items[i]) <> '') then begin
                    _SearchObj.AddJid(Trim(lstContacts.Items[i]));
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
        _DoingSearch := true;

        HistorySearchManager.NewSearch(_SearchObj, _ResultObj);
    end;
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

    with _MsgList do begin
        Name := 'ResultsHistoryFrame';
        Parent := pnlResultsHistory;
        Align := alClient;
        Visible := true;
        Ready();
    end;

    dateTo.DateTime := Now();
    dateFrom.DateTime := IncMonth(dateTo.DateTime, DEFAULT_DATE_GAP_MONTHS);

    btnRemoveContact.Enabled := false;

    _SearchObj := nil;
    _ResultObj := nil;

    _DoingSearch := false;

    _ResultList := TWidestringList.Create();
end;

{---------------------------------------}
procedure TfrmHistorySearch.FormDestroy(Sender: TObject);
begin
    _SearchObj := nil;

    _DropResults();

    _ResultList.Free();

    inherited;
end;

{---------------------------------------}
procedure TfrmHistorySearch._DropResults();
var
    i: integer;
    j: integer;
    k: integer;
    ritem: TResultListItem;
    datelist: TWidestringList;
    itemlist: TWidestringList;
begin
    _ResultObj := nil;

    lstResults.Clear();
    _MsgList.Clear();

    for i := _ResultList.Count - 1 downto 0 do begin
        dateList := TWidestringList(_ResultList.Objects[i]);
        for j := datelist.Count - 1  downto 0 do begin
            itemlist := TWidestringList(datelist.Objects[j]);
            for k := itemlist.Count - 1 downto 0 do begin
                ritem := TResultListItem(itemlist.Objects[k]);
                ritem.msg.Free();
                itemlist.Delete(k);
            end;
            itemlist.Free();
            datelist.Delete(j);
        end;
        dateList.Free();
        _ResultList.Delete(i);
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.FormResize(Sender: TObject);
begin
    inherited;
    _PossitionControls();
end;

{---------------------------------------}
procedure TfrmHistorySearch.lstContactsClick(Sender: TObject);
begin
    inherited;
    if (lstContacts.SelCount > 0) then begin
        btnRemoveContact.Enabled := true;
    end
    else begin
        btnRemoveContact.Enabled := false;
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.lstResultsClick(Sender: TObject);
var
    i: integer;
    j: integer;
    k: integer;
    l: integer;
    ritem: TResultListItem;
    listItem: TTntListItem;
    dateList: TWidestringList;
    itemList: TWidestringList;
begin
    inherited;

    listItem := lstResults.Selected;

    _MsgList.Clear();

    for i := 0 to _ResultList.Count - 1 do begin
        dateList := TWidestringList(_ResultList.Objects[i]);
        for j := 0 to dateList.Count - 1 do begin
            itemList := TWidestringList(dateList.Objects[j]);
            for k := 0 to itemList.Count - 1 do begin
                ritem := TResultListItem(itemList.Objects[k]);
                if (ritem.listitem = listItem) then begin
                    // We have a match.
                    // So, run through list adding all dates to display box
                    for l := 0 to itemList.Count - 1 do begin
                        ritem := TResultListItem(itemList.Objects[l]);
                        _MsgList.DisplayMsg(ritem.msg, false);
                    end;
                    exit; // Get out of this tripple list madness
                end;
            end;
        end;
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
    GroupBoxWidth := (pnlAdvancedSearchBar.Width - (5 * ADVGRPGUTTER_WIDTH)) div 4;
    grpDate.Width := GroupBoxWidth;
    grpKeyword.Width := GroupBoxWidth;
    grpContacts.Width := GroupBoxWidth;
    grpRooms.Width := GroupBoxWidth;
    grpKeyword.Left := grpDate.Left + grpDate.Width + ADVGRPGUTTER_WIDTH;
    grpContacts.Left := grpKeyword.Left + grpKeyword.Width + ADVGRPGUTTER_WIDTH;
    grpRooms.Left := grpContacts.Left + grpContacts.Width + ADVGRPGUTTER_WIDTH;

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

    // Result Table
    if ((lstResults.Columns.Items[0].Width +
         lstResults.Columns.Items[1].Width +
         lstResults.Columns.Items[2].Width +
         lstResults.Columns.Items[3].Width) < lstResults.ClientWidth) then begin
        // Make sure Body column is at least large enough to fit to right side of table
        lstResults.Columns.Items[3].Width := lstResults.ClientWidth -
                                             lstResults.Columns.Items[0].Width -
                                             lstResults.Columns.Items[1].Width -
                                             lstResults.Columns.Items[2].Width;
    end;
    
end;

{---------------------------------------}
procedure TfrmHistorySearch._AddContactToContactList(contact: widestring);
var
    i: integer;
begin
    if (Trim(contact) = '') then exit;

    // Check for dupe
    for i := 0 to lstContacts.Count - 1 do begin
        if (contact = lstContacts.Items[i]) then exit; // is a dupe
    end;

    // no dupes so go ahead and add to lsit
    lstContacts.AddItem(contact, nil);
end;

{---------------------------------------}
procedure TfrmHistorySearch.ResultCallback(msg: TJabberMessage);
    function CreateNewListItem(newmsg: TJabberMessage): TTntListItem;
    var
        id: TJabberID;
    begin
        Result := lstResults.Items.Add();
        Result.Caption := '';
        if (newmsg.isMe) then begin
            id := TJabberID.Create(newmsg.ToJid);
        end
        else begin
            id := TJabberID.Create(newmsg.FromJid);
        end;
        Result.SubItems.Add(DisplayName.getDisplayNameCache().getDisplayName(id.jid));
        id.Free();
        Result.SubItems.Add(DateTimeToStr(newmsg.Time));
        Result.SubItems.Add(newmsg.Body);
    end;
var
    newmsg: TJabberMessage;
    ritem: TResultListItem;
    i: integer;
    j: integer;
    jid: widestring;
    date: widestring;
    dateList: TWidestringList;
    itemList: TWidestringList;
    jidfound: boolean;
    datefound: boolean;
begin
    if (msg = nil) then begin
        // End of results - remove from Result callback map
        ExodusHistoryResultCallbackMap.DeleteCallback(_ResultObj);

        // Change GUI to "done searching"
        _DoingSearch := false;
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

        ritem := TResultListItem.Create();
        ritem.msg := newmsg;
        ritem.listitem := nil;

        if (newmsg.isMe) then begin
            jid := newmsg.ToJid;
        end
        else begin
            jid := newmsg.FromJID;
        end;
        date := IntToStr(Trunc(newmsg.Time));

        jidfound := false;
        datefound := false;
        for i := 0 to _ResultList.Count - 1 do begin
            if (jid = _ResultList[i]) then begin
                // found via jid
                jidfound := true;
                dateList := TWidestringList(_ResultList.Objects[i]);
                for j := 0 to dateList.Count - 1 do begin
                    if (date = datelist[j]) then begin
                    // found date - just add msg
                    datefound := true;
                    itemList := TWidestringList(dateList.Objects[j]);
                    itemList.AddObject('', ritem);
                    end;
                end;

                if (not datefound) then begin
                    // need to add date and msg
                    ritem.listitem := CreateNewListItem(newmsg);
                    itemList := TWidestringList.Create();
                    dateList.AddObject(date, itemList);
                    itemList.AddObject('', ritem);
                end;
            end
        end;

        if (not jidfound) then begin
            // Nothing found so create it all
            ritem.listitem := CreateNewListItem(newmsg);
            dateList := TWidestringList.Create();
            itemList := TWidestringList.Create();
            _ResultList.AddObject(jid, dateList);
            dateList.AddObject(date, itemList);
            itemList.AddObject('', ritem);
        end;
    end;
end;



end.
