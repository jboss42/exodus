unit jud;
{
    Copyright 2002, Peter Millard

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
    IQ, XMLTag, Contnrs,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Dockable, StdCtrls, ExtCtrls, ComCtrls, Menus;

type

  TJUDItem = class
  private
    _count: integer;
    procedure setCount(value: integer);
  public
    xdata: boolean;
    jid: string;
    cols: array of Widestring;
    property Count: integer read _count write setCount;
  end;

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
    Splitter1: TSplitter;
    pnlFields: TScrollBox;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    procedure lstContactsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure popAddClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure lblAddGrpClick(Sender: TObject);
    procedure popProfileClick(Sender: TObject);
    procedure popChatClick(Sender: TObject);
    procedure popMessageClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lstContactsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lstContactsData(Sender: TObject; Item: TListItem);
    procedure lstContactsDataFind(Sender: TObject; Find: TItemFind;
      const FindString: String; const FindPosition: TPoint;
      FindData: Pointer; StartIndex: Integer; Direction: TSearchDirection;
      Wrap: Boolean; var Index: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    field_set: TStringList;
    virtlist: TObjectList;

    cur_jid: string;
    cur_key: string;
    cur_state: string;
    cur_iq: TJabberIQ;

    jid_col: integer;

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

resourceString
    sJUDSearch = 'Search';
    sJUDStart = 'Start';
    sJUDStop = 'Stop';
    sJUDErrorContacting = 'Could not contact the search agent.';
    sJUDTimeout = 'The search timed out.';
    sJUDEmpty = 'No Results were found.';
    sJUDAdd = 'Add Contacts';

function StartSearch(sjid: string): TfrmJUD;
function ItemCompare(Item1, Item2: Pointer): integer;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    Unicode, InputPassword,
    JabberConst, Profile, Roster, Agents, JabberID, fGeneric,
    Session, ExUtils, XMLUtils, fTopLabel, Jabber1;

var
    cur_sort: integer;
    cur_dir: boolean;

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
    f.Caption := sJUDSearch;
    if MainSession.Prefs.getBool('expanded') then
        f.DockForm;

    // populate the drop down box based on our current agents..
    with f.cboJID.Items do begin
        Clear;
        for i := 0 to MainSession.MyAgents.Count - 1 do begin
            a := MainSession.MyAgents.getAgent(i);
            if (a.search) then
                Add(a.jid);
        end;
    end;

    f.Show;

    if f.TabSheet <> nil then
        frmExodus.Tabs.ActivePage := f.TabSheet;

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
procedure TJUDItem.setCount(value: integer);
begin
    SetLength(cols, value + 1);
    _count := value;
end;

{---------------------------------------}
procedure TfrmJUD.FormCreate(Sender: TObject);
begin
  inherited;
    cur_jid := '';
    cur_key := '';
    cur_state := 'get_fields';
    cur_sort := -1;
    cur_dir := true;
    field_set := TStringList.Create();
    cboGroup.Items.Assign(MainSession.Roster.GrpList);
    removeSpecialGroups(cboGroup.Items);
    cboGroup.Text := MainSession.Prefs.getString('roster_default');
    virtlist := TObjectList.Create();
    virtlist.OwnsObjects := true;
    AssignDefaultFont(pnlLeft.Font);
    pnlLeft.Font.Size := pnlLeft.Font.Size - 1;
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

    btnAction.Caption := sJUDStop;

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
    valid: boolean;
    x, fx: TXMLTag;
begin
    // send the iq-set to the agent
    cur_jid := cboJID.Text;
    valid := true;

    // make sure we wait for a long time for really nasty queries and slow agents :)
    cur_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), ItemsCallback, 120);
    with cur_iq do begin
        iqType := 'set';
        Namespace := XMLNS_SEARCH;
        toJid := cur_jid;

        if (cur_state = 'xsearch') then begin
            x := cur_iq.qTag.AddTag('x');
            x.setAttribute('xmlns', XMLNS_XDATA);
            x.setAttribute('type', 'submit');
            cur_state := 'xitems';
        end
        else begin
            cur_state := 'items';
            x := nil;
        end;

        // go thru all the frames and add tags for each field
        for i := 0 to pnlFields.ControlCount - 1 do begin
            if (pnlFields.Controls[i] is TframeTopLabel) then begin
                with TframeTopLabel(pnlFields.Controls[i]) do begin
                    if (txtData.Text <> '') then
                        cur_iq.qTag.AddBasicTag(field_name, txtData.Text);
                end;
            end
            else if (pnlFields.Controls[i] is TframeGeneric) then begin
                with TframeGeneric(pnlFields.Controls[i]) do begin
                    if (not isValid()) then
                        valid := false;

                    if (valid and (x <> nil)) then begin
                        fx := getXML();
                        if (fx <> nil) then
                            x.AddTag(fx);
                    end;
                end;
            end;
        end;
    end;

    if (valid) then begin
        clearFields();
        lblInstructions.Visible := false;
        lblWait.Visible := true;
        aniWait.Visible := true;
        aniWait.Active := true;
        btnAction.Caption := sJUDStop;

        cur_iq.Send();
    end;
end;

{---------------------------------------}
procedure TfrmJUD.FieldsCallback(event: string; tag: TXMLTag);
var
    fields: TXMLTagList;
    cur_tag, x: TXMLTag;
    i: integer;
    cur_frame: TframeTopLabel;
    cur_gen: TframeGeneric;
    cur_field: string;
begin
    // callback when we get the fields back
    cur_state := 'search';
    cur_iq := nil;
    lblWait.Visible := false;
    aniWait.Visible := false;
    aniWait.Active := false;
    btnAction.Caption := sJUDSearch;
    cboJID.Enabled := false;

    if (event <> 'xml') then begin
        // timeout
        MessageDlg(sJUDErrorContacting , mtError, [mbOK], 0);
        self.reset();
        exit;
    end
    else if ((tag <> nil) and (tag.GetAttribute('type') = 'error')) then begin
        // we got an iq-error back
        MessageDlg(sJUDErrorContacting, mtError, [mbOK], 0);
        Self.Reset();
        exit;
    end
    else if (tag <> nil) then begin
        // *whoop*, we got a result tag
        lblInstructions.Visible := true;
        cur_frame := nil;
        field_set.Clear();

        // Check for x-data support
        x := tag.QueryXPTag('/iq/query/x[@xmlns="jabber:x:data"]');
        if (x <> nil) then begin
            cur_state := 'xsearch';
            cur_tag := x.GetFirstTag('instructions');
            if (cur_tag <> nil) then
                lblInstructions.Caption := trimNewLines(cur_tag.Data);
            fields := x.QueryTags('field');
            pnlFields.Visible := false;
            for i := fields.Count - 1 downto 0 do begin
                cur_gen := TframeGeneric.Create(Self);
                with cur_gen do begin
                    Name := 'xDataFrame' + IntToStr(i);
                    Parent := pnlFields;
                    Visible := true;
                    render(fields[i]);
                    Align := alTop;
                    TabOrder := 0;
                end;
                AssignDefaultFont(cur_gen.Font);
                cur_gen.Font.Size := cur_gen.Font.size - 1;
            end;
            pnlFields.Visible := true;
            fields.Free();
        end
        else begin
          fields := tag.QueryXPTag('/iq/query').ChildTags();
          for i := fields.Count - 1 downto 0 do begin
              cur_tag := fields[i];
              if (cur_tag.Name = 'instructions') then
                  // do nothing
              else if (cur_tag.Namespace <> '') then
                  // ignore stuff in other namesapces
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
          fields.Free();
      end;

        if (cur_frame <> nil) then
            cur_frame.txtData.SetFocus();
    end;
end;

{---------------------------------------}
procedure TfrmJUD.ItemsCallback(event: string; tag: TXMLTag);
var
    cidx, i,c: integer;
    items, cols: TXMLTagList;
    cur: TXMLTag;
    col: TListColumn;
    ji: TJUDItem;
    jid_fld: Widestring;
    clist: TWideStringList;
    tmps: Widestring;
begin
    // callback when we get our search results back
    cur_iq := nil;
    clist := nil;
    lblWait.Visible := false;
    aniWait.Visible := false;
    aniWait.Active := false;
    btnAction.Caption := sJUDStart;
    cboJID.Enabled := true;

    if (event <> 'xml') then begin
        // timeout
        cur_state := 'get_fields';
        MessageDlg(sJUDTimeout, mtError, [mbOK], 0);
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
        items := nil;
        if (cur_state = 'items') then
            items := tag.QueryXPTags('/iq/query/item');

        if ((items = nil) or (items.Count = 0)) then
            items := tag.QueryXPTags('//x[@xmlns="jabber:x:data"]/item');

        if ((items = nil) or (items.Count = 0)) then begin
            items.Free();
            cur_state := 'get_fields';
            lstContacts.Clear();
            self.reset();
            MessageDlg(sJUDEmpty, mtInformation, [mbOK], 0);
            exit;
        end;

        lstContacts.AllocBy := 25;
        lstContacts.Items.Clear;
        virtlist.Clear();

        lstContacts.Columns.Clear();

        // setup the columns for items (no x-data)
        if (cur_state = 'items') then begin
            // use the first item in the list
            cur :=  items[0];
            cols := cur.ChildTags();

            with lstContacts.Columns.Add() do begin
                // add a JID column by default
                Caption := sJID;
                Width := 100;
                jid_col := 0;
            end;

            for i := 0 to cols.count - 1 do begin
                col := lstContacts.Columns.Add();
                col.Caption := getDisplayField(cols[i].Name);
                col.Width := 100;
            end;

            cols.Free();
        end
        else begin
            // reported columns for x-data, setup columns
            cols := tag.QueryXPTags('//x[@xmlns="jabber:x:data"]/reported/field');
            clist := TWidestringList.Create();
            if (cols <> nil) then begin
                for i := 0 to cols.Count - 1 do begin
                    with lstContacts.Columns.Add() do begin
                        Caption := cols[i].GetAttribute('label');
                        Width := 100;
                        tmps := cols[i].getAttribute('type');
                        if ((tmps = 'jid') or (tmps = 'jid-single')) then begin
                            jid_col := i;
                            jid_fld := cols[i].GetAttribute('var');
                        end;
                    end;
                    clist.Add(cols[i].GetAttribute('var'));
                end;
                cols.Free();
            end;
        end;

        // populate the listview.
        for i := 0 to items.count - 1 do begin
            cur := items[i];
            ji := TJUDItem.Create();

            if (cur_state = 'items') then begin
                ji.xdata := false;
                cols := cur.ChildTags();
                ji.jid := cur.GetAttribute('jid');
                ji.count := lstContacts.Columns.Count + 1;
                for c := 0 to cols.count - 1 do
                    ji.cols[c + 1] := cols[c].Data;
                cols.Free();
            end

            else begin // xitems
                ji.xdata := true;
                cols := cur.QueryTags('field');
                ji.count := cols.Count;
                for c := 0 to cols.count - 1 do begin
                    tmps := cols[c].getAttribute('var');
                    cidx := clist.indexOf(tmps);
                    if (cidx > -1) then begin
                        ji.cols[cidx] := cols[c].GetBasicText('value');
                        if (tmps = jid_fld) then
                            ji.jid := ji.cols[cidx];
                    end;
                end;
                cols.Free();
            end;

            virtlist.Add(ji);
        end;

        lstContacts.Items.Count := virtlist.Count;

        if (clist <> nil) then clist.Free();
        if (items <> nil) then Items.Free();

        // hide all of the other stuff
        lblWait.Visible := false;
        aniWait.Visible := false;
        lblSelect.Visible := false;
        lblInstructions.Visible := false;
        cboJID.Visible := false;

        // show results panel
        pnlResults.Align := alNone;
        pnlResults.Align := alTop;
        pnlResults.Visible := true;
        btnAction.Caption := sJUDAdd;
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
    pnlFields.Visible := false;
    while (pnlFields.ControlCount > 0) do begin
        c := pnlFields.Controls[0];
        c.Free();
    end;
    pnlFields.Visible := true;
end;

{---------------------------------------}
procedure TfrmJUD.btnActionClick(Sender: TObject);
begin
  inherited;
    {
    states go (for non-xdata):
    init -> get_fields -> fields -> search -> items
    or (for x-data):
    init -> get_fields -> fields -> xsearch -> xitems
    }
    if ((cur_state = 'fields') or
        (cur_state = 'items') or
        (cur_state = 'xitems')) then begin
        // stop waiting for the fields, or results
        cur_iq.Free();
        cur_iq := nil;
        self.reset();
    end

    else if (cur_state = 'get_fields') then begin
        // get the fields for this agent
        getFields();
    end

    else if ((cur_state = 'search') or (cur_state = 'xsearch')) then begin
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

    btnAction.Caption := sJUDStart;
    cur_state := 'get_fields';
    cur_sort := -1;
    cur_dir := true;
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
        popAdd.Caption := sJUDAdd
    else
        popAdd.Caption := sJUDAdd;

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
        jid.Free();
        
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
    ngrp: WideString;
begin
  inherited;
    // Add a new group to the list...
    ngrp := sDefaultGroup;
    if InputQueryW(sNewGroup, sNewGroupPrompt, ngrp) then begin
        MainSession.Roster.GrpList.Add(ngrp);
        cboGroup.Items.Assign(MainSession.Roster.GrpList);
        removeSpecialGroups(cboGroup.Items);
    end;
end;

{---------------------------------------}
procedure TfrmJUD.popProfileClick(Sender: TObject);
begin
  inherited;
    // view the profile for the user
    ShowProfile(lstContacts.Selected.Caption);
end;

{---------------------------------------}
procedure TfrmJUD.popChatClick(Sender: TObject);
begin
  inherited;
    // Chat with this person
end;

{---------------------------------------}
procedure TfrmJUD.popMessageClick(Sender: TObject);
begin
  inherited;
    // Send a message to this person
end;

{---------------------------------------}
procedure TfrmJUD.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
    if (cur_iq <> nil) then begin
        cur_iq.Free();
        cur_iq := nil;
    end;
end;

{---------------------------------------}
procedure TfrmJUD.lstContactsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  inherited;
  if (Column.Index = cur_sort) then
    cur_dir := not cur_dir
  else
    cur_dir := true;

  cur_sort := Column.Index;

  // lstContacts.SortType := stText;
  // lstContacts.AlphaSort();

  virtlist.Sort(ItemCompare);
  lstContacts.Refresh;
end;

function ItemCompare(Item1, Item2: Pointer): integer;
var
    j1, j2: TJUDItem;
    s1, s2: string;
begin
    // compare 2 items..
    if (cur_sort = -1) then begin
        Result := 0;
        exit;
    end;

    j1 := TJUDItem(Item1);
    j2 := TJUDItem(Item2);

    if (cur_sort = 0) then begin
        if (cur_dir) then begin
            s1 := j1.jid;
            s2 := j2.jid;
        end
        else begin
            s1 := j2.jid;
            s2 := j1.jid;
        end;
    end
    else begin
        if (cur_dir) then begin
            s1 := j1.cols[cur_sort];
            s2 := j2.cols[cur_sort];
        end
        else begin
            s1 := j2.cols[cur_sort];
            s2 := j1.cols[cur_sort];
        end;
    end;

    Result := StrComp(PChar(LowerCase(s1)),
                      PChar(LowerCase(s2)));
end;

{---------------------------------------}
procedure TfrmJUD.lstContactsData(Sender: TObject; Item: TListItem);
var
    i: integer;
    ji: TJUDItem;
begin
  inherited;
    if (Item.Index < 0) then exit;
    if (Item.Index >= virtlist.Count) then exit;

    ji := TJUDItem(virtlist[Item.Index]);
    if ji <> nil then begin
        if (ji.xdata) then
            Item.Caption := ji.cols[0]
        else
            Item.Caption := ji.jid;
        Item.SubItems.Clear();
        for i := 1 to ji.count do
            item.SubItems.Add(ji.cols[i]);
    end;
end;

{---------------------------------------}
procedure TfrmJUD.lstContactsDataFind(Sender: TObject; Find: TItemFind;
  const FindString: String; const FindPosition: TPoint; FindData: Pointer;
  StartIndex: Integer; Direction: TSearchDirection; Wrap: Boolean;
  var Index: Integer);
var
    ji: TJUDItem;
    i: integer;
    f: boolean;
begin
  inherited;
    // todo: This may have bugs still.. incremental searching in JUD results

    // OnDataFind gets called in response to calls to FindCaption, FindData,
    // GetNearestItem, etc. It also gets called for each keystroke sent to the
    // ListView (for incremental searching)

    i := StartIndex;

    if (Find = ifExactString) or (Find = ifPartialString) then begin
        repeat
            if (i = virtlist.Count - 1) then begin
                if Wrap then i := 0 else exit;
            end;
            ji := TJUDItem(virtlist[i]);
            f := Pos(FindString, ji.jid) > 0;
            inc(i);
        until (f or (i = StartIndex));
        if (f) then Index := i - 1;
    end;
end;


procedure TfrmJUD.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
    field_set.Free();
    virtlist.Free();
    Action := caFree;
end;

end.
