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
  Unicode, 
  Menus,
  TntMenus,
  TntDialogs,
  XMLTag,
  ExActions,
  XMLParser;

type
  TResultSort = (rsJIDAsc, rsJIDDec, rsDateAsc, rsDateDec);

  {
    Action implementation to start chats with a given contact(s)
  }
  TSearchHistoryAction = class(TExBaseAction)
  private
    constructor Create;
  public
    procedure execute(const items: IExodusItemList); override;
  end;

  TResultListItem = class
    private
    protected
    public
        // Variables
        msgXML: widestring; // Store as string, bool, etc  instead of TJabberMessage to save on memory if we have XML.
        isMe: boolean;
        time: TDateTime;
        nick: widestring;

        msg: TJabberMessage; // Else store the tag

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
    mnuResultHistoryPopup: TTntPopupMenu;
    popCopy: TTntMenuItem;
    popCopyAll: TTntMenuItem;
    popPrint: TTntMenuItem;
    popSaveAs: TTntMenuItem;
    dlgSave: TTntSaveDialog;
    dlgPrint: TPrintDialog;
    btnPrint: TTntButton;
    btnDelete: TTntButton;
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
    procedure btnAddRoomClick(Sender: TObject);
    procedure btnRemoveRoomClick(Sender: TObject);
    procedure lstResultsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lstResultsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lstResultsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure popCopyClick(Sender: TObject);
    procedure popCopyAllClick(Sender: TObject);
    procedure popPrintClick(Sender: TObject);
    procedure popSaveAsClick(Sender: TObject);
    procedure lstResultsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bntPrintClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure lstRoomsClick(Sender: TObject);
  private
    // Variables
    _ResultsHistoryFrame: TObject;
    _MsglistType: integer;
    _AdvSearch: boolean;
    _SearchObj: TExodusHistorySearch;
    _ResultObj: TExodusHistoryResult;
    _ResultList: TWidestringList;
    _DoingSearch: boolean;
    _resultSort: TResultSort;
    _LastSelectedItem: TListItem;
    _PrimaryBGColor: TColor;
    _AlternateBGColor: TColor;
    _parser: TXMLTagParser;

    // Methods
    function _getMsgList(): TfBaseMsgList;
    procedure _PositionControls();
    procedure _AddContactToContactList(const contact: widestring);
    procedure _AddRoomToRoomList(const room: widestring);
    procedure _DropResults();
    procedure _DisplayHistory();
    procedure _SearchingGUI(const inSearch: boolean);
    procedure _SetAdvSearch(value: boolean);
    function _FindResultStringList(const item: TTntListItem): TWidestringList;
    function _GetTJabberMessage(const ritem: TResultListItem): TJabberMessage;
    procedure _setWindowCaption(txt: widestring);

    // Properties
    property _MsgList: TfBaseMsgList read _getMsgList;

  protected
    // Variables

    // Methods
    procedure CreateParams(Var params: TCreateParams); override;

  public
    // Variables

    // Methods
    procedure ResultCallback(msg: TJabberMessage);
    procedure AddContactBasicSearch(const jid: widestring);
    procedure AddContact(const jid: widestring);
    procedure AddRoom(const room: widestring);

    // Properties
    property AdvSearch: boolean read _AdvSearch write _SetAdvSearch;

  end;

const
    ADVPANEL_HEIGHT = 150;
    BASICPANEL_HEIGHT = 35;
    ADVGRPGUTTER_WIDTH = 8;
    DEFAULT_DATE_GAP_MONTHS = -2;

var
  frmHistorySearch: TfrmHistorySearch;
  HistoryAction: TSearchHistoryAction;


procedure RegisterActions();
procedure StartShowHistory();
procedure StartShowHistoryWithContact(const jid: widestring);
procedure StartShowHistoryWithMultipleItems(const ContactList: TWidestringList; const RoomList: TWidestringList);

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
    SelectItem,
    SQLSearchHandler,
    ExSession,
    ComObj,
    DisplayName,
    JabberID,
    IdGlobal,
    RosterImages,
    XMLUtils,
    PrtRichEdit,
    JabberUtils,
    ExActionCtrl,
    TntSysUtils,
    DateUtils;

{---------------------------------------}
procedure RegisterActions();
var
    actctrl: IExodusActionController;
begin
    actctrl := GetActionController();
    actctrl.registerAction('contact', HistoryAction as IExodusAction);
    actctrl.addEnableFilter('contact', '{000-exodus.googlecode.com}-040-view-history', '');
    actctrl.registerAction('room', HistoryAction as IExodusAction);
    actctrl.addEnableFilter('room', '{000-exodus.googlecode.com}-040-view-history', '');

    HistoryAction.Enabled := false; // disabled until we know branding options
end;


{---------------------------------------}
procedure StartShowHistory();
var
    frm: TfrmHistorySearch;
begin
    frm := TfrmHistorySearch.Create(Application);
    frm.Show();
end;

{---------------------------------------}
procedure StartShowHistoryWithContact(const jid: widestring);
var
    frm: TfrmHistorySearch;
begin
    frm := TfrmHistorySearch.Create(Application);
    frm.AddContactBasicSearch(jid);
    frm.Show();
end;

{---------------------------------------}
procedure StartShowHistoryWithMultipleItems(const ContactList: TWidestringList; const RoomList: TWidestringList);
var
    frm: TfrmHistorySearch;
    i: integer;
begin
    frm := TfrmHistorySearch.Create(Application);

    if (((ContactList <> nil) and (ContactList.Count = 1)) and
        ((RoomList = nil) or (RoomList.Count = 0))) then begin
        // We only have 1 contact and no rooms, so start with basic search.
        frm.AddContactBasicSearch(ContactList[0]);
    end
    else begin
        // More than 1 contact or rooms or both, so do advanced search
        frm.AdvSearch := true;

        if (ContactList <> nil) then begin
            for i := 0 to ContactList.Count - 1 do begin
                frm.AddContact(ContactList[i]);
            end;
        end;

        if (RoomList <> nil) then begin
            for i := 0 to RoomList.Count - 1 do begin
                frm.AddRoom(RoomList[i]);
            end;
        end;
    end;
    frm.Show();
end;

{---------------------------------------}
procedure StartShowHistoryWithRooms(const RoomList: TWidestringList);
var
    frm: TfrmHistorySearch;
    i: integer;
begin
    frm := TfrmHistorySearch.Create(Application);
    for i := 0 to RoomList.Count - 1 do begin
        frm.AddRoom(RoomList[i]);
    end;
    frm.AdvSearch := true;
    frm.Show();
end;

{---------------------------------------}
constructor TSearchHistoryAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-040-view-history');

    Caption := _('View History');
    Enabled := true;
end;

{---------------------------------------}
procedure TSearchHistoryAction.execute(const items: IExodusItemList);
var
    idx: Integer;
    item: IExodusItem;
    contactlist: TWidestringList;
    roomlist: TWidestringList;
begin
    if ((items.Count = 1) and
        (items.Item[0].Type_ = 'contact')) then begin
        StartShowHistoryWithContact(items.Item[0].UID);
    end
    else begin
        contactlist := TWidestringList.Create();
        roomlist := TWidestringList.Create();

        for idx := 0 to items.Count - 1 do begin
            item := items.Item[idx];

            if (item.Type_ = 'contact') then begin
                contactlist.Add(item.UID);
            end
            else if (item.Type_ = 'room') then begin
                roomlist.Add(item.UID);
            end;
        end;

        StartShowHistoryWithMultipleItems(contactlist, roomlist);

        contactlist.Clear();
        roomlist.Clear();
        contactlist.Free();
        roomlist.Free();
    end;  

    //Let's just make sure we clean up...
    item := nil;
end;

{---------------------------------------}
procedure TfrmHistorySearch.bntPrintClick(Sender: TObject);
begin
    inherited;

    popPrintClick(Sender);
end;

{---------------------------------------}
procedure TfrmHistorySearch.btnAddContactClick(Sender: TObject);
var
    jid: widestring;
begin
    inherited;

    jid := SelectUIDByType('contact');
    if (jid <> '') then begin
        _AddContactToContactList(jid);
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.btnAddRoomClick(Sender: TObject);
var
    jid: widestring;
begin
    inherited;

    jid := SelectUIDByType('room');
    if (jid <> '') then begin
        _AddRoomToRoomList(jid);
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.btnAdvBasicSwitchClick(Sender: TObject);
begin
    inherited;

    if (_AdvSearch) then begin
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

    _AdvSearch := (not _AdvSearch);
    _PositionControls();
end;

{---------------------------------------}
procedure TfrmHistorySearch.btnDeleteClick(Sender: TObject);
var
    jid: TJabberID;
    datestart: TDateTime;
    dateend: TDateTime;
    listitem: TTntListItem;
    itemlist: TWidestringList;
    i: integer;
    ritem: TResultListItem;
    tmpmsg: TJabberMessage;
    warning: widestring;
begin
    inherited;

    listitem := lstResults.Selected;

    // Confirm they want to delete THIS history
    warning := _('Are you sure you wish to delete the history for %s on %s?');
    warning := Format(warning, [listitem.Caption, listitem.SubItems[0]]);

    if (MessageDlgW(warning, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
        // Setup the delete params
        itemlist := _FindResultStringList(listitem);
        if ((itemlist <> nil) and
            (itemlist.Count > 0)) then begin
            try
                datestart := 0;
                dateend := 0;

                ritem := TResultListItem(itemList.Objects[0]);
                if (ritem <> nil) then begin
                    tmpmsg := _GetTJabberMessage(ritem);


                    if (tmpmsg.isMe) then begin
                        jid := TJabberID.Create(tmpmsg.ToJID);
                    end
                    else begin
                        jid := TJabberID.Create(tmpmsg.FromJID);
                    end;

                    // date is local date, not GMT
                    datestart := Trunc(tmpmsg.Time); // Midnight
                    dateend := Trunc(tmpmsg.Time) + 0.999999; //just shy of midnight
                end;

                // Execute the Delete
                if ((jid <> nil) and
                    (datestart > 0) and
                    (dateend > 0)) then begin
                    MsgLogger.DeleteLogEntries(jid.jid, datestart, dateend);
                end;
            except
            end;

            jid.Free();

            lstResults.DeleteSelected();
            _MsgList.Clear();
            btnPrint.Enabled := false;
            btnDelete.Enabled := false;
        end;
    end;
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
    lstRooms.DeleteSelected();
    btnRemoveRoom.Enabled := false; // We just removed the selected, so nothing can be selected
end;

{---------------------------------------}
procedure TfrmHistorySearch.btnSerachClick(Sender: TObject);
var
    i: integer;
begin
    inherited;

    if (_DoingSearch) then begin
        HistorySearchManager.CancelSearch(_SearchObj.Get_SearchID);

        // Switch to "search done" GUI
        _DoingSearch := false;
        _SearchingGUI(false);

        _SearchObj.Free();
        _SearchObj := nil;
        _ResultObj.Free();
        _ResultObj := nil;
    end
    else begin
        _LastSelectedItem := nil;

        _SearchObj.Free();
        _SearchObj := nil;
        _ResultObj.Free();
        _ResultObj := nil;

        _DropResults();

        //_SearchObj := CreateCOMObject(CLASS_ExodusHistorySearch) as IExodusHistorySearch;
        _SearchObj := TExodusHistorySearch.Create();
        _SearchObj.ObjAddRef();
        //_ResultObj := CreateCOMObject(CLASS_ExodusHistoryResult) as IExodusHistoryResult;
        _ResultObj := TExodusHistoryResult.Create();
        _ResultObj.ObjAddRef();

        _SearchObj.AddAllowedSearchType(SQLSEARCH_CHAT);
        _SearchObj.AddAllowedSearchType(SQLSEARCH_ROOM);

        if (_AdvSearch) then begin
            // Advanced Search
            if (radioRange.Checked) then begin
                _SearchObj.Set_minDate(dateFrom.DateTime); // Midnight
                _SearchObj.Set_maxDate(dateTo.DateTime + 0.999999); // Just shy of midnight
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

            for i := 0 to lstRooms.Items.Count - 1 do begin
                if (Trim(lstRooms.Items[i]) <> '') then begin
                    _SearchObj.AddJid(Trim(lstRooms.Items[i]));
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
        ExodusHistoryResultCallbackMap.AddCallback(Self.ResultCallback, _ResultObj, false);

        // Change to "searching GUI"
        _DoingSearch := true;
        _SearchingGUI(true);

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
        HTML_MSGLIST : begin
            _ResultsHistoryFrame := TfIEMsgList.Create(Self);
            TfIEMsgList(_ResultsHistoryFrame).IgnoreMsgLimiting := true;
        end
        else begin
            _ResultsHistoryFrame := TfRTFMsgList.Create(Self);
        end;
    end;

    with _MsgList do begin
        Name := 'ResultsHistoryFrame';
        Parent := pnlResultsHistory;
        Align := alClient;
        Visible := true;
        setContextMenu(mnuResultHistoryPopup);
        Ready();
    end;

    dateTo.DateTime := Now();
    dateFrom.DateTime := IncMonth(dateTo.DateTime, DEFAULT_DATE_GAP_MONTHS);

    btnRemoveContact.Enabled := false;
    btnRemoveRoom.Enabled := false;

    _SearchObj.Free();
    _SearchObj := nil;
    _ResultObj.Free();
    _ResultObj := nil;

    _DoingSearch := false;

    _ResultList := TWidestringList.Create();

    _resultSort := rsJIDAsc;
    lstResults.Columns.Items[0].ImageIndex := RosterTreeImages.Find('arrow_up');
    lstResults.Columns.Items[1].ImageIndex := -1;

    _setWindowCaption(_('History'));

    _PrimaryBGColor := MainSession.Prefs.getInt('search_history_primary_bg_color');
    _AlternateBGColor := MainSession.Prefs.getInt('search_history_alternate_bg_color');

    if (not MainSession.Prefs.getBool('brand_print')) then begin
        popPrint.Visible := false;
        popPrint.Enabled := false;
        btnPrint.Visible := false;
    end;
    btnPrint.Enabled := false;
    btnDelete.Enabled := false;

    _parser := TXMLTagParser.Create();
end;

{---------------------------------------}
procedure TfrmHistorySearch.FormDestroy(Sender: TObject);
begin
    _SearchObj.Free();
    _SearchObj := nil;
    _ResultObj.Free();
    _ResultObj := nil;

    _parser.Free();

    _DropResults();

    _ResultList.Free();

    case _MsglistType of
        RTF_MSGLIST  : TfRTFMsgList(_ResultsHistoryFrame).Free();
        HTML_MSGLIST : TfIEMsgList(_ResultsHistoryFrame).Free();
        else begin
            _ResultsHistoryFrame.Free();
        end;
    end;

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
    lstResults.Clear();
    _MsgList.Reset();
    if (_MsglistType = HTML_MSGLIST) then begin
        TfIEMsgList(_ResultsHistoryFrame).IgnoreMsgLimiting := true;
    end;

    for i := _ResultList.Count - 1 downto 0 do begin
        dateList := TWidestringList(_ResultList.Objects[i]);
        for j := datelist.Count - 1  downto 0 do begin
            itemlist := TWidestringList(datelist.Objects[j]);
            for k := itemlist.Count - 1 downto 0 do begin
                ritem := TResultListItem(itemlist.Objects[k]);
                ritem.msg.Free();
                ritem.Free();
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
    _PositionControls();
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
procedure TfrmHistorySearch.lstResultsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
    inherited;
    if (Change = ctState) then begin
        if ((Item.Selected) and
            (Item <> _LastSelectedItem)) then begin
            _DisplayHistory();
            _LastSelectedItem := Item;
        end;
    end;
end;

{---------------------------------------}
function TfrmHistorySearch._FindResultStringList(const item: TTntListItem): TWidestringList;
var
    i: integer;
    j: integer;
    k: integer;
    dateList: TWidestringList;
    itemList: TWidestringList;
    ritem: TResultListItem;
begin
    Result := nil;
    if (item = nil) then exit;

    for i := 0 to _ResultList.Count - 1 do begin
        dateList := TWidestringList(_ResultList.Objects[i]);
        for j := 0 to dateList.Count - 1 do begin
            itemList := TWidestringList(dateList.Objects[j]);
            for k := 0 to itemList.Count - 1 do begin
                ritem := TResultListItem(itemList.Objects[k]);
                if (ritem.listitem = item) then begin
                    Result := itemList;
                    exit;  // Get out of this tripple list madness
                end;
            end;
        end;
    end;
end;

{---------------------------------------}
function TfrmHistorySearch._GetTJabberMessage(const ritem: TResultListItem): TJabberMessage;
var
    tag: TXMLTag;
begin
    Result := nil;
    if (ritem = nil) then exit;

    if (ritem.msg = nil) then begin
        _parser.ParseString(ritem.msgXML, '');
        tag := _parser.popTag();
        Result := TJabberMessage.Create(tag);
        Result.Nick := ritem.nick;
        Result.Time := ritem.time;
        Result.isMe := ritem.isMe;
        tag.Free();
    end
    else begin
        Result := TJabberMessage.Create(ritem.msg);
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch._DisplayHistory();
var
    l: integer;
    ritem: TResultListItem;
    listItem: TTntListItem;
    itemList: TWidestringList;
    msg: TJabberMessage;
begin
    btnPrint.Enabled := true;
    btnDelete.Enabled := true;

    listItem := lstResults.Selected;

    _MsgList.Reset();
    if (_MsglistType = HTML_MSGLIST) then begin
        TfIEMsgList(_ResultsHistoryFrame).IgnoreMsgLimiting := true;
    end;

    itemlist := _FindResultStringList(listItem);
    if (itemlist <> nil) then begin
        // We have a match.
        // So, run through list adding all dates to display box
        for l := 0 to itemList.Count - 1 do begin
            ritem := TResultListItem(itemList.Objects[l]);
            msg := _GetTJabberMessage(ritem);
            if (msg <> nil) then begin
                _MsgList.DisplayMsg(msg, false);
                msg.Free();
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.lstResultsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
    inherited;

    if (Column = lstResults.Columns.Items[0]) then begin
        if (_resultSort = rsJIDAsc) then begin
            _resultSort := rsJIDDec;

        end
        else begin
            _resultSort := rsJIDAsc;
        end;
        lstResults.SortType := stNone;
        lstResults.SortType := stBoth;
    end
    else if (Column = lstResults.Columns.Items[1]) then begin
        if (_resultSort = rsDateAsc) then begin
            _resultSort := rsDateDec;
        end
        else begin
            _resultSort := rsDateAsc;
        end;
        lstResults.SortType := stNone;
        lstResults.SortType := stBoth;
    end
    else begin
        // Do nothing if Message column
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.lstResultsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
    dt1: TDateTime;
    dt2: TDateTime;
begin
    inherited;

    case _resultSort of
        rsJIDAsc: begin
            lstResults.Columns.Items[0].ImageIndex := RosterTreeImages.Find('arrow_up');
            lstResults.Columns.Items[1].ImageIndex := -1;
            if (Item1.Caption > Item2.Caption) then begin
                Compare := 1;
            end
            else if (Item1.Caption < Item2.Caption) then begin
                Compare := -1;
            end
            else begin
                Compare := 0;
            end;
        end;
        rsJIDDec: begin
            lstResults.Columns.Items[0].ImageIndex := RosterTreeImages.Find('arrow_down');
            lstResults.Columns.Items[1].ImageIndex := -1;
            if (Item1.Caption > Item2.Caption) then begin
                Compare := -1;
            end
            else if (Item1.Caption < Item2.Caption) then begin
                Compare := 1;
            end
            else begin
                Compare := 0;
            end;
        end;
        rsDateAsc: begin
            lstResults.Columns.Items[0].ImageIndex := -1;
            lstResults.Columns.Items[1].ImageIndex := RosterTreeImages.Find('arrow_up');
            try
                dt1 := StrToDateTime(Item1.SubItems[0]);
                dt2 := StrToDateTime(Item2.SubItems[0]);
                if (dt1 > dt2) then begin
                    Compare := 1;
                end
                else if (dt1 < dt2) then begin
                    Compare := -1;
                end
                else begin
                    Compare := 0;
                end;
            except
            end;
        end;
        rsDateDec: begin
            lstResults.Columns.Items[0].ImageIndex := -1;
            lstResults.Columns.Items[1].ImageIndex := RosterTreeImages.Find('arrow_down');
            try
                dt1 := StrToDateTime(Item1.SubItems[0]);
                dt2 := StrToDateTime(Item2.SubItems[0]);
                if (dt1 > dt2) then begin
                    Compare := -1;
                end
                else if (dt1 < dt2) then begin
                    Compare := 1;
                end
                else begin
                    Compare := 0;
                end;
            except
            end;
        end;
    end;

end;

{---------------------------------------}
procedure TfrmHistorySearch.lstResultsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
    inherited;

    if ((item.Index mod 2) = 0) then begin
        Sender.Canvas.Brush.Color := _PrimaryBGColor;
    end
    else begin
        Sender.Canvas.Brush.Color := _AlternateBGColor;
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.lstRoomsClick(Sender: TObject);
begin
    inherited;
    if (lstRooms.SelCount > 0) then begin
        btnRemoveRoom.Enabled := true;
    end
    else begin
        btnRemoveRoom.Enabled := false;
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.popCopyAllClick(Sender: TObject);
begin
    inherited;
    _MsgList.CopyAll();
end;

{---------------------------------------}
procedure TfrmHistorySearch.popCopyClick(Sender: TObject);
begin
    inherited;
    _MsgList.Copy();
end;

{---------------------------------------}
procedure TfrmHistorySearch.popPrintClick(Sender: TObject);
var
    cap: Widestring;
    ml: TfBaseMsgList;
    msglist: TfRTFMsgList;
    htmlmsglist: TfIEMsgList;
begin
    inherited;
    ml := _getMsgList();

    if (ml is TfRTFMsgList) then begin
        msglist := TfRTFMsgList(ml);
        with dlgPrint do begin
            if (not Execute) then exit;

            cap := _('Room Transcript: %s');
            cap := WideFormat(cap, [Self.Caption]);

            PrintRichEdit(cap, TRichEdit(msglist.MsgList), Copies, PrintRange);
        end;
    end
    else if (ml is TfIEMsgList) then begin
        htmlmsglist := TfIEMsgList(ml);
        htmlmsglist.print(true);
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.popSaveAsClick(Sender: TObject);
var
    fn: widestring;
    filetype: integer;
begin
    dlgSave.FileName := MungeName(lstResults.Selected.Caption);

    case _MsglistType of
        RTF_MSGLIST  : dlgSave.Filter := 'RTF (*.rtf)|*.rtf|Text (*.txt)|*.txt'; // RTF
        HTML_MSGLIST : dlgSave.Filter := 'HTML (*.htm)|*.htm'; // HTML
    end;

    if (not dlgSave.Execute()) then exit;
    fn := dlgSave.FileName;
    filetype := dlgSave.FilterIndex;

    case _MsglistType of
        RTF_MSGLIST  :
            begin
                if (filetype = 1) then begin
                    // .rtf file
                    if (LowerCase(RightStr(fn, 3)) <> '.rtf') then
                        fn := fn + '.rtf';
                end
                else if (filetype = 2) then begin
                    // .txt file
                    if (LowerCase(RightStr(fn, 3)) <> '.txt') then
                        fn := fn + '.txt';
                end;
            end;
        HTML_MSGLIST :
            begin
                // .htm file
                if (LowerCase(RightStr(fn, 3)) <> '.htm') then
                    fn := fn + '.htm';
            end;
    end;
    _MsgList.Save(fn);
end;

{---------------------------------------}
procedure TfrmHistorySearch.radioAllClick(Sender: TObject);
begin
    inherited;
    _PositionControls();
end;

{---------------------------------------}
procedure TfrmHistorySearch.radioRangeClick(Sender: TObject);
begin
    inherited;
    _PositionControls();
end;

{---------------------------------------}
function TfrmHistorySearch._getMsgList(): TfBaseMsgList;
begin
    Result := TfBaseMsgList(_ResultsHistoryFrame);
end;

{---------------------------------------}
procedure TfrmHistorySearch._PositionControls();
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
    if (_AdvSearch) then begin
        pnlSearchBar.Height := ADVPANEL_HEIGHT;
        pnlControlBar.Top := ADVPANEL_HEIGHT;
    end
    else begin
        pnlSearchBar.Height := BASICPANEL_HEIGHT;
        pnlControlBar.Top := BASICPANEL_HEIGHT;
    end;

    if (not btnPrint.Visible) then begin
        btnDelete.Left := btnPrint.Left;
        btnDelete.Top := btnPrint.Top;
    end;

    // Result Table
    if ((lstResults.Columns.Items[0].Width +
         lstResults.Columns.Items[1].Width +
         lstResults.Columns.Items[2].Width) < lstResults.ClientWidth) then begin
        // Make sure Body column is at least large enough to fit to right side of table
        lstResults.Columns.Items[2].Width := lstResults.ClientWidth -
                                             lstResults.Columns.Items[0].Width -
                                             lstResults.Columns.Items[1].Width;
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch._AddContactToContactList(const contact: widestring);
var
    i: integer;
begin
    if (Trim(contact) = '') then exit;

    // Check for dupe
    for i := 0 to lstContacts.Count - 1 do begin
        if (Trim(contact) = lstContacts.Items[i]) then exit; // is a dupe
    end;

    // no dupes so go ahead and add to lsit
    lstContacts.AddItem(Trim(contact), nil);
end;

{---------------------------------------}
procedure TfrmHistorySearch._AddRoomToRoomList(const room: widestring);
var
    i: integer;
begin
    if (Trim(room) = '') then exit;

    // Check for dupe
    for i := 0 to lstRooms.Count - 1 do begin

        if (Trim(room) = lstRooms.Items[i]) then exit; // is a dupe
    end;

    // no dupes so go ahead and add to lsit
    lstRooms.AddItem(Trim(room), nil);
end;

{---------------------------------------}
procedure TfrmHistorySearch.ResultCallback(msg: TJabberMessage);
    function StripString(const str: widestring): widestring;
    begin
        Result := Tnt_WideStringReplace(str, ''#13, ' ',[rfReplaceAll, rfIgnoreCase]);
        Result := Tnt_WideStringReplace(Result, ''#10, ' ',[rfReplaceAll, rfIgnoreCase]);
        Result := Tnt_WideStringReplace(Result, ''#9, ' ',[rfReplaceAll, rfIgnoreCase]);
        Result := Tnt_WideStringReplace(Result, ''#11, ' ',[rfReplaceAll, rfIgnoreCase]);
    end;
    function CreateNewListItem(const newmsg: TJabberMessage): TTntListItem;
    var
        id: TJabberID;
        exItem: IExodusItem;
    begin
        if (newmsg.isMe) then begin
            id := TJabberID.Create(newmsg.ToJid);
        end
        else begin
            id := TJabberID.Create(newmsg.FromJid);
        end;

        Result := lstResults.Items.Add();
        // Display Name
        Result.Caption := DisplayName.getDisplayNameCache().getDisplayName(id.jid);
        // Image Index
        exItem := MainSession.ItemController.GetItem(id.jid);
        if (exItem <> nil) then begin
            Result.ImageIndex := exItem.ImageIndex;
        end
        else begin
            // We may not know presence or this could be a unbookmarked room
            if (newmsg.MsgType = 'groupchat') then begin
                Result.ImageIndex := RosterTreeImages.Find('conference');
            end
            else begin
                Result.ImageIndex := RosterTreeImages.Find('unknown');
            end;
        end;
        exItem := nil;
        id.Free();
        Result.SubItems.Add(DateToStr(newmsg.Time));

        Result.SubItems.Add(StripString(newmsg.Body));
    end;
var
    newmsg: TJabberMessage;
    ritem: TResultListItem;
    i: integer;
    j: integer;
    jid: TJabberID;
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
        _SearchingGUI(false);

        _SearchObj.Free();
        _SearchObj := nil;
        _ResultObj.Free();
        _ResultObj := nil;
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
        if (newmsg.Tag = nil) then begin
            ritem.msg := newmsg;
            ritem.msgXML := '';
            ritem.isMe := false;
            ritem.time := 0;
            ritem.nick := '';
        end
        else begin
            // Store details of the TJabberMessage Object instead of the actual object
            // if we can as it uses far less memory.
            ritem.msg := nil;
            ritem.msgXML := newmsg.Tag.XML;
            ritem.isMe := newmsg.isMe;
            ritem.time := newmsg.Time;
            ritem.nick := newmsg.Nick;
        end;

        ritem.listitem := nil;

        if (newmsg.isMe) then begin
            jid := TJabberID.Create(newmsg.ToJid);
        end
        else begin
            jid := TJabberID.Create(newmsg.FromJID);
        end;
        date := IntToStr(Trunc(newmsg.Time));

        jidfound := false;
        datefound := false;
        for i := 0 to _ResultList.Count - 1 do begin
            if (jid.jid = _ResultList[i]) then begin
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
            _ResultList.AddObject(jid.jid, dateList);
            dateList.AddObject(date, itemList);
            itemList.AddObject('', ritem);
        end;

        if (ritem.msg = nil) then begin
           newmsg.Free();
        end;

        jid.Free();
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    inherited;

    if (_DoingSearch) then begin
        MessageDlgW(_('Search currently in progress.  Please cancel the serach or wait for search to end before closing.'), mtWarning, [mbOK], 0);
        CanClose := false;
    end;
end;

{---------------------------------------}
procedure TfrmHistorySearch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    inherited;
    Self.Free();
end;

{---------------------------------------}
procedure TfrmHistorySearch._SearchingGUI(const inSearch: boolean);
begin
    if (inSearch) then begin
        btnSerach.Caption := _('Cancel');
        Screen.Cursor := crHourglass;
    end
    else begin
        btnSerach.Caption := _('Search');
        Screen.Cursor := crDefault;
    end;
    btnAdvBasicSwitch.Enabled := (not inSearch);
    pnlSearchBar.Enabled := (not inSearch);
    pnlResults.Enabled := (not inSearch);
end;

{---------------------------------------}
procedure TfrmHistorySearch.AddContactBasicSearch(const jid: widestring);
begin
    if (Trim(jid) = '') then exit;

    txtBasicHistoryFor.Text := Trim(jid);
end;

{---------------------------------------}
procedure TfrmHistorySearch.AddContact(const jid: widestring);
begin
    if (Trim(jid) = '') then exit;

    _AddContactToContactList(jid);
end;

{---------------------------------------}
procedure TfrmHistorySearch.AddRoom(const room: widestring);
begin
    if (Trim(room) = '') then exit;

    _AddRoomToRoomList(room);
end;

{---------------------------------------}
procedure TfrmHistorySearch._SetAdvSearch(value: boolean);
begin
    btnAdvBasicSwitchClick(nil);
    _AdvSearch := value;
end;

{---------------------------------------}
procedure TfrmHistorySearch.CreateParams(Var params: TCreateParams);
begin
    // Make this window show up on the taskbar
    inherited CreateParams( params );
    params.ExStyle := params.ExStyle or WS_EX_APPWINDOW;
    params.WndParent := GetDesktopwindow;
end;

{---------------------------------------}
procedure TfrmHistorySearch._setWindowCaption(txt: widestring);
begin
    if (txt = '') then begin
        Caption := MainSession.Prefs.getString('brand_caption');
    end
    else begin
        Caption := txt +
                   ' - ' +
                   MainSession.Prefs.getString('brand_caption');
    end;
end;







initialization
    HistoryAction := TSearchHistoryAction.Create;
    RegisterActions();


end.
