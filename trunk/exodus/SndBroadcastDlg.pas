unit SndBroadcastDlg;

interface

uses
    Exodus_TLB, ExForm, JabberID, Unicode, XMLTag, ExActions,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  TntExtCtrls, StdCtrls, TntStdCtrls, ComCtrls, TntComCtrls, ToolWin,
  RichEdit2, ExRichEdit, ExtCtrls, StateForm, ImgList, Buttons, TntButtons,
  Menus, TntMenus;

type
  TSendBroadcastAction = class(TExBaseAction)
  private
    constructor Create;
  public
    function Get_Enabled: WordBool; override;
    procedure execute(const items: IExodusItemList); override;
  end;

  TItemInfo = class
  private
    _UID: Widestring;
    _bareUID: widestring; //only select by bare jid
    _IType: Widestring;
    _imageIndex: integer;
    _DisplayName: widestring;
    _JID : TJabberID;
    _lastError: Widestring;
    _validated: boolean;
    _itemTextColor: TColor;

    function GetIsValid(): boolean;

  public
    Constructor Create(IUID: widestring; IItem: IExodusItem = nil);
    Destructor Destroy();override;

    function GetExodusItem(): IExodusItem;
    procedure Validate();

    property BareUID: widestring read _bareUID;
    property UID: widestring read _UID;
    property ItemType: widestring read _IType;
    property DisplayName: widestring read _DisplayName;
    property ImageIndex: integer read _imageIndex;
    property IsValid: boolean read GetIsValid;
    property LastError: Widestring read _lastError;
    property JID: TJabberID read _JID;
    property TextColor: TColor read _itemTextColor;
  end;

  TdlgSndBroadcast = class(TExForm)
    pnlHeader: TTntPanel;
    pnlButtons: TTntPanel;
    btnSend: TTntButton;
    btnCancel: TTntButton;
    pnlComposer: TTntPanel;
    pnlRecipients: TTntPanel;
    Panel1: TPanel;
    imgState: TImageList;
    RTComposer: TExRichEdit;
    tbMsgOutToolbar: TTntToolBar;
    ChatToolbarButtonBold: TTntToolButton;
    ChatToolbarButtonUnderline: TTntToolButton;
    ChatToolbarButtonItalics: TTntToolButton;
    ChatToolbarButtonColors: TTntToolButton;
    ChatToolbarButtonSeparator1: TTntToolButton;
    ChatToolbarButtonCut: TTntToolButton;
    ChatToolbarButtonCopy: TTntToolButton;
    ChatToolbarButtonPaste: TTntToolButton;
    ChatToolbarButtonSeparator2: TTntToolButton;
    ChatToolbarButtonEmoticons: TTntToolButton;
    ChatToolbarButtonHotkeys: TTntToolButton;
    TntToolButton1: TTntToolButton;
    cmbPriority: TTntComboBox;
    pnlSubject: TPanel;
    lblSubject: TTntLabel;
    txtSendSubject: TTntMemo;
    popTo: TTntPopupMenu;
    Add1: TTntMenuItem;
    Remove1: TTntMenuItem;
    pnlSender: TTntPanel;
    splitter: TTntSplitter;
    TntLabel1: TTntLabel;
    btnAddRecipients: TTntBitBtn;
    btnRemoveRecipient: TTntBitBtn;
    pnlRecipList: TTntPanel;
    lstJIDS: TTntListView;
    pnlRecipientWarning: TTntPanel;
    Image1: TImage;
    TntLabel3: TTntLabel;
    btnRemoveInvalid: TTntButton;
    procedure btnRemoveClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstJIDSInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure lstJIDSCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnSendClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pnlRecipientWarningClick(Sender: TObject);
    procedure btnToClick(Sender: TObject);
    procedure splitterMoved(Sender: TObject);
    procedure lstJIDSEnter(Sender: TObject);
    procedure btnRemoveInvalidClick(Sender: TObject);
    procedure lstJIDSKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnRemoveRecipientClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    _supportedTypes: TWidestringList;
    _foundError: boolean;
    _sessionListener: TObject; //TSessionListener
    
    function IndexOfRecipient(itemInfo: TItemInfo): integer;
    procedure ClearRecipients();

    procedure SetSubject(value: widestring);
    function GetSubject(): WideString;

    procedure SetPlaintextMessage(value: widestring);
    function GetPlaintextMessage(): widestring;

    procedure SetListItemState(item: TTntLIstItem);

    procedure AddRecipient(itemInfo: TItemInfo);
    procedure ValidateList();
    procedure FixupWarningPanel(show: boolean);
    procedure RefreshRecipientList();
  protected
    procedure CreateParams(var Params: TCreateParams); override;

    procedure AddRecipientByUID(uid: WideString);
    procedure AddRecipientByItem(item: IExodusItem);

    procedure AddRecipientsByUIDs(UIDs: TWidestringList);
    procedure AddRecipientsByItems(items: IExodusItemList);

    procedure RemoveSelectedRecipients();

    procedure OnDisconnected(ForcedDisconnect: boolean; Reason: WideString);
  public
    constructor Create(AOwner: TComponent);override;
    Destructor Destroy(); override;

    procedure GetXHTMLMessage(var xhtml: TXMLTag);

    property Subject: widestring read GetSubject write SetSubject;
    property PlaintextMessage: widestring read GetPlaintextMessage write SetPlaintextMessage;
  end;


procedure ShowSendBroadcast(popUIDs: TWideStringList;     //initial populated UIDs, may be nil
                            popSubject: widestring = '';  //initial populated subject
                            popMessage: widestring = '');overload; //initial populated plaintext message

procedure ShowSendBroadcast(popItems: IExodusItemList;     //initial populated jids, may be nil
                            popSubject: widestring = '';  //initial populated subject
                            popMessage: widestring = '');overload; //initial populated plaintext message

procedure SendBroadcastMessage(Subject: widestring;
                               Recipients: TList; //list of TItemInfo
                               Plaintext: widestring;
                               xhtml: TXMLtag = nil);
implementation

{$R *.dfm}
uses
    JabberConst,
    COMExodusItem,
    COMExodusItemList,
    JabberMsg,
    AddressList,
    ExUtils,
    Entity,
    EntityCache,
    RosterImages,
    GnuGetText,
    Room,
    Contnrs,        //TObjectList
    ExActionCtrl,   //action controller
    SelectItem,     //item slection dioalog
    Session;

const
    BroadcastActionUID = '{000-exodus.googlecode.com}-042-send-broadcast';

    EI_TYPE_UNKNOWN = 'ei-type-unknown';
    EI_TYPE_JID = 'ei-type-jid';
    EI_TYPE_SERVICE = 'ei-type-service';

    ESTR_UNKNOWN = 'Unknown entity';
    ESTR_SERVICE = 'Service';
    ESTR_OUT_OF_NETWORK = 'Contact not in network';
    ESTR_NOT_IN_ROOM = 'Not in room';
    ESTR_NO_VOICE = 'No voice in room';

    IT_INVALID_ITEM = 'This item has a problem that prevents sending of a broadcast messages.';

    ROOMMSG_NO_SUBJECT = 'No subject specified';
    ROOMMSG_SUBJECT_HEADER = 'Subject: ';
    ROOMMSG_BROADCAST_HEADER = 'Broadcast Message';
    ROOMMSG_MESSAGE_HEADER = 'Message: ';
    
    ERROR_NO_RECIPIENTS = 'You must have at least one valid recipient to send a Broadcast Message.' + #10#13#10#13 + 'Would you like to add a recipient now?';
    WARNING_NO_SUBJECT = 'Are you sure you want to send this message with no Subject?"';
    ERROR_NO_MESSAGE = 'You must enter a message to send a Broadcast.';
    ERROR_WRONG = 'You''re doing it wrong.';
    ERROR_BROADCAST_TITLE = 'Broadcast Message';
{------------------------------------------------------------------------------}
procedure ExpandAndAddItems(item: IExodusItem;
                            itemList: IExodusItemList);
var
    idx: Integer;
    subitems: IExodusItemList;
begin
    //if item is not a group, just add it to the list
    if (item.Type_ <>  EI_TYPE_GROUP) then
        itemList.Add(item)
    else begin
        subitems := MainSession.ItemController.GetGroupItems(item.UID);
        for idx := 0 to subitems.Count - 1 do
            ExpandAndAddItems(subitems.Item[idx], itemList);
    end;
end;

{------------------------------------------------------------------------------}
procedure ShowSendBroadcast(popItems: IExodusItemList;    //initial populated jids, may be nil
                            popSubject: widestring = '';  //initial populated subject
                            popMessage: widestring = ''); //initial populated plaintext message
var
    idx: Integer;
    item: IExodusItem;
    fullItemList: IExodusItemList;
    bForm: TdlgSndBroadcast;
begin
    fullItemList := TExodusItemList.Create(); //released when out of scope
    for idx := 0 to popItems.Count - 1 do
    begin
        item := popItems.Item[idx];
        ExpandAndAddItems(item, fullItemList);
    end;
    bForm := TdlgSndBroadcast.create(Application);
    bForm.AddRecipientsByItems(fullItemList);

    bForm.Subject := popSubject;
    bForm.PlaintextMessage := popMessage;
    bForm.Show();

end;

{------------------------------------------------------------------------------}
procedure ShowSendBroadcast(popUIDs: TWideStringList;
                            popSubject: widestring;
                            popMessage: widestring);
var
    bForm: TdlgSndBroadcast;
begin
    bForm := TdlgSndBroadcast.create(Application);
    if (popUIDs <> nil) then
        bForm.AddRecipientsByUIDs(popUIDs);
    bForm.Subject := popSubject;
    bForm.PlaintextMessage := popMessage;
    bForm.Show();
end;

{*******************************************************************************
**************************** TItemInfo *****************************************
*******************************************************************************}

procedure RemoveInvalid(IList: TList; var valid: TList);
var
    i: integer;
    oneInfo: TItemInfo;
begin
    valid := TObjectList.Create(false);
    for i := 0 to IList.Count - 1 do
    begin
        oneInfo := TItemInfo(IList[i]);
        oneInfo.Validate();
        if (oneInfo.IsValid) then
            valid.add(oneInfo);
    end;
end;

Constructor TItemInfo.Create(IUID: widestring; IItem: IExodusItem);
var
    item: IExodusItem;
    tjid: TJabberID;
begin
    _UID := IUID;
    _bareUID := _UID;
    _itemTextColor := clWindowText;

    _imageIndex := -1; //no index
//        _imageIndex := RosterImages.RosterTreeImages.Find(RosterImages.RI_UNKNOWN_KEY);


    //see if we can make a JID out of the UID)
    tjid := TJabberID.create(_UID);
    item := IItem;
    if (item = nil) then
        item := MainSession.ItemController.GetItem(_UID);

    if (item <> nil) then
    begin
        _IType := item.Type_;
        _DisplayName := item.Text;
        _imageIndex := item.ImageIndex;
    end
    else if (not tjid.isValid) then
    begin
        _IType := EI_TYPE_UNKNOWN;
        _DisplayName := _UID;

        tjid.free();
        tjid := nil;
    end
    else if (tjid.user = '') then
    begin
        _Itype := EI_TYPE_SERVICE;
        _displayName := tjid.full;
    end
    else begin
        _Itype := EI_TYPE_JID;
        _DisplayName := tjid.userDisplay;
    end;

    _JID := tjid;

    if (_JID <> nil) then
        _bareUID := _JID.jid;
end;

{------------------------------------------------------------------------------}
Destructor TItemInfo.Destroy();
begin
    if (_JID <> nil) then
        _JID.free();
    inherited;
end;

{------------------------------------------------------------------------------}
function TItemInfo.GetIsValid(): boolean;
begin
    if (not _validated) then
        Validate();
    Result := _lastError = '';
end;

{------------------------------------------------------------------------------}
function TItemInfo.GetExodusItem(): IExodusItem;
begin
    Result := MainSession.ItemController.GetItem(_UID);
end;

{------------------------------------------------------------------------------}
procedure TItemInfo.Validate();
var
    item: IExodusItem;
    room: TfrmRoom;
begin
    //validate this info, true
    _lastError := '';
    try
        //if we have no jid, invalid
        if (_ITYPE = EI_TYPE_UNKNOWN) or (_JID = nil) then
            _lastError := ESTR_UNKNOWN
        else if (_ITYPE = EI_TYPE_SERVICE) then
            _lastError := ESTR_SERVICE
        else begin
            item := GetExodusItem();

            if (_ITYPE = EI_TYPE_CONTACT) and (item.value['network'] <> 'xmpp') then
                _lastError := ESTR_OUT_OF_NETWORK
            else if (_ITYPE = EI_TYPE_ROOM) then
            begin
                room := FindRoom(_JID.jid);

                if (room = nil) then
                    _lastError := ESTR_NOT_IN_ROOM
                else if (room.MyRole = MUC_VISITOR) then
                    _lastError := ESTR_NO_VOICE;
            end;
        end;
    except
        _lastError := ESTR_UNKNOWN;
    end;
    _validated := true;
end;

{*******************************************************************************
************************* TdlgSndBroadcast *************************************
*******************************************************************************}
constructor TdlgSndBroadcast.Create(AOwner: TComponent);
begin
    inherited;
    _supportedTypes := TWidestringList.Create();
    _supportedTypes.add(EI_TYPE_CONTACT);
    _supportedTypes.add(EI_TYPE_ROOM);
    _supportedTypes.add(EI_TYPE_GROUP); //!?
    _foundError := false;
    _sessionListener := Session.TSessionListener.Create(nil, OnDisconnected);
    RTComposer.Font.Size := 10;
end;

{------------------------------------------------------------------------------}
Destructor TdlgSndBroadcast.Destroy();
begin
    _supportedTypes.Free();
    _sessionListener.Free();
    inherited;
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.CreateParams(var Params: TCreateParams);
begin
    // Make each window appear on the task bar.
    inherited CreateParams(Params);
    Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
    Params.WndParent := GetDesktopWindow();
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.FormActivate(Sender: TObject);
begin
    inherited;
    RefreshRecipientList();
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    inherited;
    Action := caFree;
end;

procedure TdlgSndBroadcast.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    inherited;
    ClearRecipients(); //frees TItemInfo objects
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.FormCreate(Sender: TObject);
begin
    inherited;
    lstJIDs.SmallImages := RosterImages.RosterTreeImages.ImageList;
end;

procedure TdlgSndBroadcast.OnDisconnected(ForcedDisconnect: boolean; Reason: WideString);
begin
    Self.Close();
end;

{------------------------------------------------------------------------------}
function TdlgSndBroadcast.IndexOfRecipient(itemInfo: TItemInfo): integer;
begin
    for Result := 0 to lstJIDS.Items.Count - 1 do begin
        if (TItemInfo(lstJIDS.Items[Result].Data).BareUID = itemInfo.BareUID) then exit; //done
    end;
    Result := -1;
end;

procedure TdlgSndBroadcast.SetListItemState(item: TTntLIstItem);
var
    Info: TItemInfo;
begin
    Info := TItemINfo(item.Data);
    item.Caption := info.DisplayName;
    item.ImageIndex := info.ImageIndex;
    info._itemTextColor := clWindowText;
    item.SubItems.Clear;

    if (not info.IsValid) then
    begin
        item.ImageIndex := RosterImages.RI_DELETE_INDEX;
        item.SubItems.Add(Info.LastError);
        info._itemTextColor := TColor(RGB(130,143,154)); //gray
    end;
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.lstJIDSCustomDrawItem(Sender: TCustomListView;
            Item: TListItem;
            State: TCustomDrawState;
        var DefaultDraw: Boolean);
begin
    inherited;
    //change font color to "inactive" if item is in an error state
    Sender.Canvas.font.Color := TItemInfo(item.Data).TextColor;
end;

procedure TdlgSndBroadcast.lstJIDSEnter(Sender: TObject);
begin
    inherited;
    if (lstJIDS.SelCount = 0) and (lstJIDS.Items.Count > 0) then
        lstJIDs.Items[0].Selected := true;
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.lstJIDSInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: string);
begin
    inherited;
    InfoTip := TItemINfo(Item.Data).UID;
    if (not TItemInfo(Item.Data).IsValid) then
        InfoTip := InfoTip + #13#10 + _(IT_INVALID_ITEM) + ': ' + TItemInfo(Item.Data).LastError;
end;

procedure TdlgSndBroadcast.lstJIDSKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    inherited;
    if (key = VK_DELETE) then
        RemoveSelectedRecipients();
end;

procedure TdlgSndBroadcast.FixupWarningPanel(show: boolean);
begin
    if (pnlRecipientWarning.Visible <> show) then
    begin
        pnlRecipientWarning.Visible := show;
        Self.Realign;
    end;
    //force a colum width resize
    lstJIDs.Columns[0].Width := -1;
    lstJIDs.Columns[1].Width := -1;
end;

procedure TdlgSndBroadcast.RefreshRecipientList();
begin
    ValidateList();
    FixupWarningPanel(_foundError);
    lstJIDs.Invalidate;
end;

procedure TdlgSndBroadcast.pnlRecipientWarningClick(Sender: TObject);
begin
    inherited;
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.ClearRecipients();
var
    i: integer;
begin
    // remove all items
    for i := lstJIDS.Items.Count - 1 downto 0 do begin
        tItemInfo(lstJIDS.Items[i].Data).Free(); //free TItemInfo
        lstJIDS.Items.Delete(i);
    end;
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.SetSubject(value: widestring);
begin
    Self.txtSendSubject.Text := value;
end;

procedure TdlgSndBroadcast.splitterMoved(Sender: TObject);
begin
   inherited;
   //force lv cloumns to autosize
   lstJIDs.Columns[0].Width := -1;
   lstJIDs.Columns[1].Width := -1;
end;

procedure TdlgSndBroadcast.btnRemoveRecipientClick(Sender: TObject);
begin
  inherited;

end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.btnSendClick(Sender: TObject);
var
    IList: TObjectList;
    i: integer;
    xhtml: TXMLTag;
    oneInfo: TItemInfo;
begin
    inherited;
    // Send the outgoing msg
    IList := TObjectList.create(false);
    for i := lstJIDS.Items.Count - 1 downto 0 do
    begin
        oneInfo := tItemInfo(lstJIDS.Items[i].Data);
        oneInfo.Validate();
        if (oneInfo.IsValid) then
            ILIst.add(oneInfo); //free TItemInfo
    end;
    
    if (IList.Count = 0) then
    begin
        if MessageBoxW(Self.Handle,
                       PWideChar(_(ERROR_NO_RECIPIENTS)),
                       PWideChar(_(ERROR_BROADCAST_TITLE)),
                       MB_ICONQUESTION or MB_YESNO) = IDYES then
        begin
            btnAddClick(Sender)
        end
        else Self.lstJIDS.SetFocus();
        exit;
    end;

    if (trim(PlaintextMessage) = '') then
    begin
        MessageBoxW(Self.Handle,
                    PWideChar(_(ERROR_NO_MESSAGE)),
                    PWideChar(_(ERROR_BROADCAST_TITLE)),
                    MB_ICONINFORMATION or MB_OK);
        Self.RTComposer.SetFocus();
        exit;
    end;

    if (Trim(Subject) = '') then
    begin
        if MessageBoxW(Self.Handle,
                       PWideChar(_(WARNING_NO_SUBJECT)),
                       PWideChar(_(ERROR_BROADCAST_TITLE)),
                       MB_ICONQUESTION or MB_YESNOCANCEL) <> IDYES then
        begin
            Self.txtSendSubject.SetFocus();
            exit;
        end
    end;

    GetXHTMLMessage(xhtml);
    SendBroadcastMessage(Subject, IList, PlaintextMessage, xhtml);
    IList.free();
    Self.Close();
end;

procedure TdlgSndBroadcast.btnToClick(Sender: TObject);
begin

end;

{------------------------------------------------------------------------------}
function TdlgSndBroadcast.GetSubject(): WideString;
begin
    Result := Self.txtSendSubject.Text
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.SetPlaintextMessage(value: widestring);
begin
    RTComposer.WideText := value;
end;

{------------------------------------------------------------------------------}
function TdlgSndBroadcast.GetPlaintextMessage(): widestring;
begin
    Result := ExUtils.getInputText(RTComposer);
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.GetXHTMLMessage(var xhtml: TXMLTag);
begin
    xhtml := ExUtils.getInputXHTML(RTComposer);
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.AddRecipient(itemInfo: TItemInfo);
var
    entry: TTnTListItem;
begin
    if (IndexOfRecipient(itemInfo) <> -1) then
        itemInfo.free //we own it, but its already in list
    else begin
        entry := lstJIDS.Items.Add();
        entry.Data := itemInfo;
        SetListItemState(entry);
    end;
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.AddRecipientByUID(uid: WideString);
begin
    AddRecipient(TItemInfo.Create(uid));
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.AddRecipientByItem(item: IExodusItem);
begin
    if (_supportedTypes.IndexOf(item.Type_) <> -1) then
        AddRecipient(TItemInfo.Create(item.UID, item));
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.AddRecipientsByItems(items: IExodusItemList);
var
    idx: integer;
begin
    for idx := 0 to items.Count - 1 do
        AddRecipientByItem(items.Item[idx]);
    RefreshRecipientList();
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.AddRecipientsByUIDs(uids: TWidestringList);
var
    i: integer;
begin
    for i  := 0 to uids.Count - 1 do
        Self.AddRecipientByUID(uids[i]);
    RefreshRecipientList();
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.RemoveSelectedRecipients();
var
    i: integer;
begin
    // Remove all the selected items
    for i := lstJIDS.Items.Count - 1 downto 0 do begin
        if lstJIDS.Items[i].Selected then
        begin
            TItemInfo(lstJIDS.Items[i].Data).Free();
            lstJIDS.Items.Delete(i);
        end;
    end;
    RefreshRecipientList();
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.ValidateList();
var
    i: integer;
begin
    _foundError := false;
    for i := 0 to lstJIDS.Items.Count - 1 do
    begin
        tItemInfo(lstJIDS.Items[i].Data).Validate();
        _foundError := _foundError or (not tItemInfo(lstJIDS.Items[i].Data).IsValid);
        SetListItemState(lstJIDS.Items[i]);
    end;
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.btnAddClick(Sender: TObject);
var
    newRecipient: Widestring;
    newType: widestring;
    item: IExodusItem;
    fullItemList: IExodusItemList;
begin
    inherited;
    newRecipient := SelectUIDByTypes(_supportedTypes, newType, '', Self.Handle);
    if (newRecipient <> '') then
    begin
        if (newType <> EI_TYPE_GROUP) then
            AddRecipientByUID(newRecipient)
        else begin
            item := MainSession.ItemController.GetItem(newRecipient);
            fullItemList := TExodusItemList.Create(); //released when out of scope
            ExpandAndAddItems(item, fullItemList);
            AddRecipientsByItems(fullItemList);
        end;
    end;
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.btnCancelClick(Sender: TObject);
begin
    inherited;
    Self.Close();
end;

{------------------------------------------------------------------------------}
procedure TdlgSndBroadcast.btnRemoveClick(Sender: TObject);
begin
    inherited;
    RemoveSelectedRecipients();
end;


procedure TdlgSndBroadcast.btnRemoveInvalidClick(Sender: TObject);
var
    i: integer;
begin
    inherited;
    ValidateList(); //state may have changed, given voice etc.
    // Remove all the selected items
    for i := lstJIDS.Items.Count - 1 downto 0 do begin
        if ( not TItemInfo(lstJIDS.Items[i].Data).IsValid) then
        begin
            TItemInfo(lstJIDS.Items[i].Data).Free();
            lstJIDS.Items.Delete(i);
        end;
    end;
    RefreshRecipientList();
end;

{*******************************************************************************
*********************** TSendBroadcastAction ***********************************
*******************************************************************************}
constructor TSendBroadcastAction.Create;
begin
    inherited Create(BroadcastActionUID);

    Caption := _('Broadcast Message...');
end;

{------------------------------------------------------------------------------}
function TSendBroadcastAction.Get_Enabled: WordBool;
begin
    Result := true;
end;

{------------------------------------------------------------------------------}
procedure TSendBroadcastAction.execute(const items: IExodusItemList);
begin
    ShowSendBroadcast(items);
end;

{------------------------------------------------------------------------------}
procedure RegisterActions();
begin
    GetActionController().registerAction('', TSendBroadcastAction.Create()); //reg for all types
end;


function FormatRoomBroadcastPlainText(Header: widestring;
                                      Plaintext: widestring;
                                      Subject: widestring): widestring;
begin
    Result := header;
    if (Result <> '') then
        Result := Result + #13#10;
    Result := Result + _(ROOMMSG_SUBJECT_HEADER);
    if (Subject <> '') then
        Result := Result + Subject
    else
        Result := Result + _(ROOMMSG_NO_SUBJECT);

    Result := Result +  #13#10 + _(ROOMMSG_MESSAGE_HEADER) + Plaintext;
end;

procedure FormatRoomBroadcastXHTML(Header: widestring;
                                   xhtmlTag: TXMLTag;
                                   Plaintext: widestring;
                                   Subject: widestring;
                                   var formattedTag: TXMLTag);
var
    sstr: WideString;
    i: integer;
    children: TXMLTagList;

    tTag, topTag, dtag: TXMLTag;
begin
    //if no xhtml is given, dummy one from subject and plaintext. If
    //chtml is gievn, preface it with room broadcast message header and subject
    formattedTag := TXMLTag.create('html');
    formattedTag.setAttribute('xmlns', XMLNS_XHTMLIM);
    ttag := formattedTag.AddTag('body');
    ttag.setAttribute('xmlns', XMLNS_XHTML);
    //add header and subject
    //JJF just using span tags right now, should use a table of somesort
    topTag := tTag.AddTag('span');
    //header
    sstr := header;
    if (header <> '') then
    begin
        ttag := toptag.AddBasicTag('span', header);
        ttag.SetAttribute('style','font-weight:bold');
    end;
    //subject
    dtag := topTag.AddTag('div');
    dtag.AddBasicTag('span', _(ROOMMSG_SUBJECT_HEADER)).setAttribute('style','font-weight:bold');
    sstr := Subject;
    if (sstr = '') then
        sstr := _(ROOMMSG_NO_SUBJECT);
    dtag.AddBasicTag('span', sstr);

    dtag := topTag.AddTag('div');
    ttag := dtag.AddBasicTag('span', _(ROOMMSG_MESSAGE_HEADER));
    ttag.SetAttribute('style','font-weight:bold');
    
    //now add children of the given xhtml or use the plaintext
    ttag := nil;
    if (xhtmlTag <> nil) then
        ttag := xhtmlTag.QueryXPTag('/message/html[@xmlns="' + XMLNS_XHTMLIM + '"]/body[@xmlns="' + XMLNS_XHTML + '"]');

    if (ttag = nil) then
        dTag.AddBasicTag('span',plaintext)
    else begin
        //add all current children of xhtml body tag
        children := tTag.ChildTags;
        for i := 0 to children.Count -1 do
        begin
            dTag.AddTag(TXMLTag.Create(children[i]));
        end;
    end;
end;
{*******************************************************************************
*********************** SendBroadcastMessage ***********************************
*******************************************************************************}
procedure SendBroadcastMessage(Subject: widestring;
                               Recipients: TList; //list of TItemInfo
                               Plaintext: widestring;
                               xhtml: TXMLtag = nil);

var
    oneMessage: TJabberMessage;
    i: integer;
    ent: TJabberEntity;
    nick: Widestring;
    oneInfo: TItemInfo;
    room: TfrmRoom;
    validContacts: TObjectList;
    xhtmlStr: widestring;
    roomMessage: widestring;
    roomXhtml: TXMLTag;
    roomXhtmlStr: widestring;

    function createMessage(jidStr: widestring): TJabberMessage;
    begin
        Result := TJabberMessage.Create(jidstr, 'normal', Plaintext, Subject);

        // these must be set so that logging works right
        Result.isMe := true;
        Result.Nick := nick;
    end;

    procedure FireMessage(msg: TJabberMessage);
    var
        mtag: TXMLTag;
    begin
        mtag := msg.GetTag; //get a reference to msg's xml representation
        mtag.addInsertedXML(xhtmlStr);

        (* JJF todo fire com events
        // plugin stuff
        if (ComController <> nil) then
            x2 := TExodusChat(ComController).fireAfterMsg(txt);
        if (x2 <> '') then
            mtag.addInsertedXML(x2);
        *)

        // log the msg
        LogMessage(msg);

        jabberSendMsg(msg.toJID, mtag, '', Plaintext, Subject);
    end;
begin
    if (Plaintext = '') or (Recipients.Count = 0) then exit;

    // let plugins know about message going out
    // if they don't want to allow it, they change txt to NULL
    (* JJF todo fire com events
    if (ComController <> nil) then
        allowed := TExodusChat(ComController).fireBeforeMsg(txt)
    else
        allowed := true;

    if ((allowed = false) or (txt = '')) then exit;
    *)

    //process any messages to rooms by using the room to send the actual message
    //create another list with non room valid items
    //room will event plugins as needed
    validContacts := TObjectList.Create(false);
    roomMessage := formatRoomBroadcastPlaintext(_(ROOMMSG_BROADCAST_HEADER), Plaintext, Subject);
    formatRoomBroadcastXHTML(_(ROOMMSG_BROADCAST_HEADER), xhtml, Plaintext, Subject, roomXhtml);
    roomXHTMLStr := roomXHTML.XML;

    for i := 0 to Recipients.Count - 1 do
    begin
        oneInfo := TItemInfo(Recipients[i]);
        oneInfo.Validate();
        if (oneInfo.IsValid) then
        begin
            if (oneInfo.ItemType = EI_TYPE_ROOM) then
            begin
                room := FindRoom(oneInfo.JID.jid);
                room.SendRawMessage(roomMessage, '', roomXhtmlStr, true);
            end
            else validContacts.Add(oneInfo);
        end;
    end;

    if (validContacts.Count = 0) then exit;

    // Check for multicast service
    ent := jEntityCache.getFirstFeature(XMLNS_ADDRESS);
    nick := MainSession.getDisplayUsername();
    if (ent = nil) then
    begin
        //no multicast, send msg to all valid recipients, include
        //XMLNS_ADDRESS node for client hint
        for i := 0 to validContacts.Count - 1 do
        begin
            oneInfo := TItemInfo(validContacts[i]);
            oneMessage := createMessage(oneInfo.JID.jid);
            oneMessage.Addresses.AddAddress(oneInfo.JID.jid, ADDRESS_TYPE_TO); //client hint
            oneMessage.Addresses.AddAddress(ADDRESS_REPLYTO_JID, ADDRESS_TYPE_NOREPLY);
            fireMessage(oneMessage);
            oneMessage.Free();
        end;
    end
    else begin
        // We have a multicast service - use it
        oneMessage := createMessage(ent.Jid.jid);
        // add recipient <address> elements to the message
        for i := 0 to validContacts.Count - 1 do
            oneMessage.Addresses.AddAddress(TItemInfo(validContacts[i]).JID.jid, ADDRESS_TYPE_TO);
        oneMessage.Addresses.AddAddress(ADDRESS_REPLYTO_JID, ADDRESS_TYPE_NOREPLY);
        fireMessage(oneMessage);
        oneMessage.Free();
    end;
end;


initialization
    RegisterActions();
end.
