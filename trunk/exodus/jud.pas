unit jud;

interface

uses
    IQ, XMLTag, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Dockable, StdCtrls, ExtCtrls, ComCtrls, Menus;

type
  TfrmJUD = class(TfrmDockable)
    pnlLeft: TPanel;
    lstContacts: TListView;
    lblInstructions: TLabel;
    lblSelect: TLabel;
    Panel1: TPanel;
    cboJID: TComboBox;
    pnlBottom: TPanel;
    btnAction: TButton;
    btnClose: TButton;
    pnlFields: TPanel;
    aniWait: TAnimate;
    lblWait: TLabel;
    PopupMenu1: TPopupMenu;
    popAdd: TMenuItem;
    popProfile: TMenuItem;
    N1: TMenuItem;
    popChat: TMenuItem;
    popMessage: TMenuItem;
    pnlResults: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    cboGroup: TComboBox;
    lblAddGrp: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    procedure lstContactsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure popAddClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure lblAddGrpClick(Sender: TObject);
  private
    { Private declarations }
    field_set: TStringList;
    cur_jid: string;
    cur_key: string;
    cur_state: string;

    cur_iq: TJabberIQ;

    procedure getFields;
    procedure sendRequest();
    procedure clearFields();
    procedure reset();
    procedure FieldsCallback(event: string; tag: TXMLTag);
    procedure ItemsCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
  end;

var
  frmJUD: TfrmJUD;

function StartSearch(sjid: string): TfrmJUD;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    Roster, Agents,
    JabberID,
    Session, ExUtils,
    fTopLabel, Jabber1;

{$R *.dfm}

{---------------------------------------}
function StartSearch(sjid: string): TfrmJUD;
var
    f: TfrmJUD;
    i: integer;
    a: TAgentItem;
begin
    // Start a new search
    // create a new room
    f := TfrmJUD.Create(Application);
    if MainSession.Prefs.getBool('expanded') then
        f.DockForm;

    // populate the drop down box based on our current agents..
    with f.cboJID.Items do begin
        Clear;
        for i := 0 to MainSession.Agents.Count - 1 do begin
            a := MainSession.Agents.getAgent(i);
            if (a.search) then
                Add(a.jid);
            end;
        end;

    f.Caption := 'Search';
    f.Show;

    if f.TabSheet <> nil then
        frmJabber.Tabs.ActivePage := f.TabSheet;

    // either get the fields right away,
    // or pre-select the first item
    if (sjid <> '') then begin
        f.cboJID.Text := sjid;
        f.getFields();
        end
    else if (f.cboJID.Items.Count > 0) then begin
        f.cboJID.ItemIndex := 0;
        f.getFields();
        end;

    Result := f;
end;

{---------------------------------------}
procedure TfrmJUD.FormCreate(Sender: TObject);
begin
  inherited;
    cur_jid := '';
    cur_key := '';
    cur_state := 'get_fields';
    field_set := TStringList.Create();
    cboGroup.Items.Assign(MainSession.Roster.GrpList);
    if cboGroup.Items.Count > 0 then
        cboGroup.ItemIndex := 0;
end;

{---------------------------------------}
procedure TfrmJUD.getFields;
begin
    // get the fields to search on..
    // setup a fTopLabel frame for each field

    cur_state := 'fields';

    // make sure the lstView is clear
    lstContacts.Items.BeginUpdate();
    lstContacts.Items.Clear();
    lstContacts.Columns.Clear();
    lstContacts.Items.EndUpdate();

    // show the wait stuff
    lblWait.Visible := true;
    aniWait.Visible := true;
    aniWait.Active := true;

    btnAction.Caption := 'Stop';

    cur_jid := cboJID.Text;
    cur_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), FieldsCallback);
    with cur_iq do begin
        iqType := 'get';
        Namespace := XMLNS_SEARCH;
        toJid := cur_jid;
        Send();
        end;
end;

{---------------------------------------}
procedure TfrmJUD.sendRequest();
var
    i: integer;
begin
    // send the iq-set to the agent
    cur_state := 'items';

    cur_jid := cboJID.Text;

    // make sure we wait for a long time for really nasty queries and slow agents :)
    cur_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), ItemsCallback, 120000);
    with cur_iq do begin
        iqType := 'set';
        Namespace := XMLNS_SEARCH;
        toJid := cur_jid;

        // go thru all the frames and add tags for each field
        for i := 0 to pnlFields.ControlCount - 1 do begin
            if (pnlFields.Controls[i] is TframeTopLabel) then
            with TframeTopLabel(pnlFields.Controls[i]) do begin
                if (txtData.Text <> '') then
                    cur_iq.qTag.AddBasicTag(field_name, txtData.Text);
                end;
            end;
        end;

    clearFields();
    lblInstructions.Visible := false;
    lblWait.Visible := true;
    aniWait.Visible := true;
    aniWait.Active := true;
    btnAction.Caption := 'Stop';

    cur_iq.Send();
end;

{---------------------------------------}
procedure TfrmJUD.FieldsCallback(event: string; tag: TXMLTag);
var
    fields: TXMLTagList;
    cur_tag: TXMLTag;
    i: integer;
    cur_frame: TframeTopLabel;
    cur_field: string;
begin
    // callback when we get the fields back
    cur_state := 'search';
    lblWait.Visible := false;
    aniWait.Visible := false;
    aniWait.Active := false;
    btnAction.Caption := 'Search';
    cboJID.Enabled := false;

    if (event <> 'xml') then begin
        // timeout
        MessageDlg('Could not contact the search agent.', mtError, [mbOK], 0);
        self.reset();
        exit;
        end
    else begin
        // tag
        lblInstructions.Visible := true;
        cur_frame := nil;
        field_set.Clear();
        fields := tag.QueryXPTag('/iq/query').ChildTags();
        for i := fields.Count - 1 downto 0 do begin
            cur_tag := fields[i];
            if (cur_tag.Name = 'instructions') then
                // do nothing
            else if (cur_tag.Name = 'key') then begin
                cur_key := cur_tag.Data;
                end
            else begin
                cur_field := cur_tag.Name;
                field_set.Add(cur_field);
                cur_frame := TframeTopLabel.Create(Self);
                with cur_frame do begin
                    Parent := pnlFields;
                    Align := alTop;
                    field_name := cur_field;
                    lbl.Caption := getDisplayField(cur_field);
                    Name := 'frame_' + field_name;
                    TabOrder := 0;
                    if (cur_field = 'password') then
                        txtData.PasswordChar := '*';
                    end;
                end;
            end;
        if (cur_frame <> nil) then
            cur_frame.txtData.SetFocus();
        end;
end;

{---------------------------------------}
procedure TfrmJUD.ItemsCallback(event: string; tag: TXMLTag);
var
    i,c: integer;
    items, cols: TXMLTagList;
    cur: TXMLTag;
    item: TListItem;
    col: TListColumn;
begin
    // callback when we get our search results back
    lblWait.Visible := false;
    aniWait.Visible := false;
    aniWait.Active := false;
    btnAction.Caption := 'Start';
    cboJID.Enabled := true;

    if (event <> 'xml') then begin
        // timeout
        cur_state := 'get_fields';
        MessageDlg('The search timed out.', mtError, [mbOK], 0);
        self.reset();
        exit;
        end
    else begin
        // tag
        {
        <iq from='users.jabber.org' id='jcl_6' to='pgm-foo@jabber.org/Exodus' type='result'>
        <query xmlns='jabber:iq:search'>
        <item jid='clever@jabber.org'>
            <nick>Clever</nick>
            <first>Hennie</first>
            <email>clever@jabber.com</email>
            <last/>
        </item></query></iq>
        }

        // get all the returned items
        items := tag.QueryXPTags('/iq/query/item');

        if ((items = nil) or (items.Count = 0)) then begin
            cur_state := 'get_fields';
            lstContacts.Clear();
            self.reset();
            item := lstContacts.Items.Add();
            item.Caption := 'No Results were returned';
            exit;
            end;

        // setup the columns...
        // use the first item in the list
        cur :=  items[0];
        cols := cur.ChildTags();

        // add a JID column by default
        lstContacts.Items.BeginUpdate();
        lstContacts.Items.Clear;

        lstContacts.Columns.Clear();
        col := lstContacts.Columns.Add();
        col.Caption := 'Jabber ID';
        col.Width := ColumnTextWidth;

        for i := 0 to cols.count - 1 do begin
            col := lstContacts.Columns.Add();
            col.Caption := getDisplayField(cols[i].Name);
            col.Width := ColumnTextWidth;
            end;

        // populate the listview.
        for i := 0 to items.count - 1 do begin
            cur := items[i];
            item := lstContacts.Items.Add();
            item.Caption := cur.getAttribute('jid');
            cols := cur.ChildTags();
            for c := 0 to cols.count - 1 do
                item.SubItems.Add(cols[c].Data);
            end;

        lstContacts.Items.EndUpdate();

        // show results panel
        lblSelect.Visible := false;
        cboJID.Visible := false;
        pnlResults.Visible := true;
        pnlResults.Align := alClient;
        btnAction.Caption := 'Add Contacts';
        cur_state := 'add';
        end;
end;

{---------------------------------------}
procedure TfrmJUD.btnCloseClick(Sender: TObject);
begin
  inherited;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmJUD.clearFields();
var
    c: TControl;
begin
    // clear all frames from the pnlFields panel
    while (pnlFields.ControlCount > 0) do begin
        c := pnlFields.Controls[0];
        c.Free();
        end;
end;

{---------------------------------------}
procedure TfrmJUD.btnActionClick(Sender: TObject);
begin
  inherited;
    {
    states go:
    init -> get_fields -> fields -> search -> items
    }
    if ((cur_state = 'fields') or (cur_state = 'items')) then begin
        // stop waiting for the fields, or results
        cur_iq.Free();
        self.reset();
        end

    else if (cur_state = 'get_fields') then begin
        // get the fields for this agent
        getFields();
        end

    else if (cur_state = 'search') then begin
        // fire off the iq-set to do the actual search
        sendRequest();
        end

    else if (cur_state = 'add') then begin
        // add selected contacts
        popAddClick(self);
        end

    else begin
        end;
end;

{---------------------------------------}
procedure TfrmJUD.reset();
begin
    // reset the GUI
    lblWait.Visible := false;
    aniWait.Visible := false;
    aniWait.Active := false;
    pnlResults.Visible := false;
    lblSelect.Visible := true;
    cboJID.Visible := true;

    btnAction.Caption := 'Start';
    cur_state := 'get_fields';
    cboJID.Enabled := true;
    self.ClearFields();
end;

{---------------------------------------}
procedure TfrmJUD.lstContactsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
    multi: boolean;
begin
  inherited;
    multi := (lstContacts.SelCount > 1);
    if multi then
        popAdd.Caption := 'Add Contacts'
    else
        popAdd.Caption := 'Add Contact';
    popProfile.Enabled := not multi;
    popChat.Enabled := not multi;
    popMessage.Enabled := not multi;
end;

{---------------------------------------}
procedure TfrmJUD.popAddClick(Sender: TObject);
var
    i: integer;

    procedure doAdd(item: TListItem);
    var
        ritem: TJabberRosterItem;
        jid: TJabberID;
    begin
        // do the actual add stuff
        ritem := MainSession.roster.Find(item.Caption);
        if (ritem <> nil) then begin
            if ((ritem.subscription = 'to') or (ritem.subscription = 'both')) then
                exit;
            end;

        // add the item
        jid := TJabberID.Create(item.caption);
        MainSession.roster.AddItem(item.caption, jid.user, cboGroup.Text, true);
    end;

begin
  inherited;


    // add selected contacts
    if (lstContacts.SelCount = 1) then
        // only a single user
        doAdd(lstContacts.Selected)

    else begin
        for i := 0 to lstContacts.Items.Count - 1 do begin
            if lstContacts.Items[i].Selected then
                doAdd(lstContacts.Items[i]);
            end;
        end;

end;

{---------------------------------------}
procedure TfrmJUD.Label1Click(Sender: TObject);
begin
  inherited;
    // search again...
    with lstContacts do begin
        Items.BeginUpdate;
        Items.Clear;
        Items.EndUpdate;
        end;

    self.reset();
end;

{---------------------------------------}
procedure TfrmJUD.lblAddGrpClick(Sender: TObject);
var
    ngrp: String;
begin
  inherited;
    // Add a new group to the list...
    ngrp := 'Untitled Group';
    if InputQuery('Add Group', 'New Group Name', ngrp) then begin
        MainSession.Roster.GrpList.Add(ngrp);
        cboGroup.Items.Assign(MainSession.Roster.GrpList);
        end;
end;

end.
