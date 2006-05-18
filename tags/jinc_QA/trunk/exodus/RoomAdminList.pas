unit RoomAdminList;
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
    XMLTag, IQ, Unicode, SelContact,   
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, buttonFrame, StdCtrls, ExtCtrls, CheckLst, ComCtrls,
    TntComCtrls, TntStdCtrls;

type
  TfrmRoomAdminList = class(TForm)
    frameButtons1: TframeButtons;
    lstItems: TTntListView;
    Panel2: TPanel;
    btnRemove: TTntButton;
    TntButton1: TTntButton;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lstItemsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lstItemsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnRemoveClick(Sender: TObject);
    procedure lstItemsEdited(Sender: TObject; Item: TTntListItem;
      var S: WideString);
  published
    procedure listAdminCallback(event: string; tag: TXMLTag);
  private
    { Private declarations }
    _iq: TJabberIQ;
    _adds: TWidestringlist;
    _dels: TWidestringlist;
    _selector: TfrmSelContact;


    room_jid: Widestring;
    role: bool;
    onList: Widestring;
    offList: Widestring;

    procedure AddJid(j, n: Widestring);
  public
    { Public declarations }
    procedure Start();
  end;

var
  frmRoomAdminList: TfrmRoomAdminList;

procedure ShowRoomAdminList(room_win: TForm; room_jid, role, affiliation: WideString;
    caption: WideString = '');

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    JabberUtils, ExUtils,  GnuGetText, JabberConst, JabberID, Session, Room,
    NodeItem, RosterWindow;

{$R *.dfm}

{---------------------------------------}
procedure ShowRoomAdminList(room_win: TForm; room_jid, role, affiliation: WideString;
    caption: Widestring = '' );
var
    f: TfrmRoomAdminList;
begin
    // Fire up a new form, and dispatch call Start()
    f := TfrmRoomAdminList.Create(Application);
    f.room_jid := room_jid;
    if (role <> '') then begin
        f.role := true;
        f.onList := role;
        if (role = MUC_PART) then
            f.offList := MUC_VISITOR
        else if (role = MUC_MOD) then
            f.offList := MUC_PART
        else
            f.offList := MUC_NONE;
    end
    else begin
        f.role := false;
        f.onList := affiliation;
        f.offList := MUC_NONE;
    end;

    if (caption <> '') then
        f.Caption := caption;
        
    f.Start();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.Start();
var
    item: TXMLTag;
begin
    // Get the list to be edited
    _iq := TJabberIQ.Create(MainSession, MainSession.generateID(),
        listAdminCallback, 30);
    with _iq do begin
        toJid := room_jid;
        if ((onList = MUC_ADMIN) or (onList = MUC_OWNER)) then
            Namespace := XMLNS_MUCOWNER
        else
            Namespace := XMLNS_MUCADMIN;
        iqType := 'get';
    end;

    item := _iq.qTag.AddTag('item');
    if (role) then
        item.setAttribute('role', onList)
    else
        item.setAttribute('affiliation', onList);
    _iq.Send();
    Show();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.listAdminCallback(event: string; tag: TXMLTag);
var
    li: TTntListItem;
    i: integer;
    rjid: WideString;
    items: TXMLTagList;
    itemJID: TJabberID;
begin
    // callback for list administration
    _iq := nil;
    if event <> 'xml' then exit;
    if tag = nil then exit;

    if ((tag.Name <> 'iq') or
        (tag.getAttribute('type') = 'error')) then begin
        MessageDlgW(_('There was an error fetching this room list.'),
            mtError, [mbOK], 0);
        Self.Close;
        exit;
    end;

    rjid := tag.GetAttribute('from');
    items := tag.QueryXPTags('/iq/query/item');

    room_jid := rjid;

    if (items.Count > 0) then begin
        for i := 0 to items.Count - 1 do begin
            itemJID := TJabberID.Create(items[i].GetAttribute('jid'));
            li := TTntListItem(lstItems.Items.Add());
            li.Caption := items[i].GetAttribute('nick');
            li.SubItems.Add(itemJID.getDisplayFull());
            li.Checked := true;
            itemJID.Free();
        end;
    end;

    items.Free();
end;


{---------------------------------------}
procedure TfrmRoomAdminList.frameButtons1btnOKClick(Sender: TObject);
var
    i: integer;
    item, q, iq: TXMLTag;
    li: TTntListItem;
begin
    // check for no changes
    if ((_adds.Count = 0) and (_dels.Count = 0)) then begin
        Self.Close();
        exit;
    end;

    // submit the new list
    iq := TXMLTag.Create('iq');
    iq.setAttribute('to', room_jid);
    iq.setAttribute('id', MainSession.generateID());
    iq.setAttribute('type', 'set');
    q := iq.AddTag('query');
    if ((onList = MUC_ADMIN) or (onList = MUC_OWNER)) then
        q.setAttribute('xmlns', XMLNS_MUCOWNER)
    else
        q.setAttribute('xmlns', XMLNS_MUCADMIN);

    // Take all the "dels" off the list
    for i := 0 to _dels.Count - 1 do begin
        item := q.AddTag('item');
        item.setAttribute('jid', _dels[i]);
        if (role) then
            item.setAttribute('role', offList)
        else
            item.setAttribute('affiliation', offList);
    end;

    // Put all the "adds" on the list
    for i := 0 to _adds.Count - 1 do begin
        item := q.AddTag('item');
        item.setAttribute('jid', _adds[i]);
        li := TTntListItem(_adds.Objects[i]);
        if (li.Caption <> '') then
            item.SetAttribute('nick', li.Caption);
        if (role) then
            item.setAttribute('role', onList)
        else
            item.setAttribute('affiliation', onList);
    end;

    MainSession.SendTag(iq);
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmRoomAdminList.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
    _iq := nil;
    _adds := TWidestringlist.Create();
    _dels := TWidestringlist.Create();
    _selector := TfrmSelContact.Create(nil);

    MainSession.Prefs.RestorePosition(Self);
end;

{---------------------------------------}
procedure TfrmRoomAdminList.FormDestroy(Sender: TObject);
begin
    if (_iq <> nil) then FreeAndNil(_iq);
    FreeAndNil(_adds);
    FreeAndNil(_dels);
    _selector.Free();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.btnAddClick(Sender: TObject);
var
    j: Widestring;
    ritem: TJabberRosterItem;
begin
    // Add a JID
    if (_selector.ShowModal = mrOK) then begin
        j := _selector.GetSelectedJID();
        ritem := MainSession.Roster.Find(j);
        if (ritem <> nil) then
            AddJid(j, ritem.Text)
        else
            AddJid(j, '');
    end;
end;

{---------------------------------------}
procedure TfrmRoomAdminList.AddJid(j,n: Widestring);
var
    tmp_jid: TJabberID;
    li: TTntListItem;
begin
    tmp_jid := TJabberID.Create(j);
    if (not tmp_jid.isValid) then begin
        tmp_jid.Free();
        MessageDlgW(_('The Jabber ID you entered is invalid.'), mtError, [mbOK], 0);
        exit;
    end;

    li := TTntListItem(lstItems.Items.Add());
    li.Caption := n;
    li.SubItems.Add(tmp_jid.getDisplayFull());
    li.Checked := true;
    _adds.AddObject(tmp_jid.full, li);

    tmp_jid.Free();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.lstItemsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    // Accept roster items
    Accept := (Source = frmRosterWindow.treeRoster) or
        (Source = _selector.frameTreeRoster1.treeRoster);
end;

{---------------------------------------}
procedure TfrmRoomAdminList.lstItemsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    tree: TTreeView;
    n: TTreeNode;
    i,j: integer;
    ritem: TJabberRosterItem;
    gitems: TList;
    grp: TJabberGroup;
begin
    // dropping from main roster window
    tree := TTreeView(Source);
    with tree do begin
        for i := 0 to SelectionCount - 1 do begin
            n := Selections[i];
            if ((n.Data <> nil) and (TObject(n.Data) is TJabberRosterItem)) then begin
                // We have a roster item
                ritem := TJabberRosterItem(n.Data);
                AddJid(ritem.jid.jid, ritem.Text);
            end
            else if ((n.Data <> nil) and (TObject(n.Data) is TJabberGroup)) then begin
                // We have a roster grp
                grp := TJabberGroup(n.Data);
                gitems := MainSession.roster.getGroupItems(grp.FullName, false);
                for j := 0 to gitems.count - 1 do begin
                    ritem := TJabberRosterItem(gitems[j]);
                    AddJid(ritem.Jid.jid, ritem.Text);
                end;
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRoomAdminList.btnRemoveClick(Sender: TObject);
var
    j: Widestring;
    idx, i: integer;
    itemJID: TJabberID;
begin
    // Remove these folks from the list
    for i := lstItems.Items.Count - 1 downto 0 do begin
        if (lstItems.Items[i].Selected) then begin
            itemJID := TJabberID.Create(lstItems.Items[i].SubItems[0], false);
            j := itemJID.full();
            idx := _adds.IndexOf(j);
            if (idx >= 0) then
                _adds.Delete(idx)
            else
                _dels.Add(j);
            lstItems.Items.Delete(i);
        end;
    end;
end;

procedure TfrmRoomAdminList.lstItemsEdited(Sender: TObject;
  Item: TTntListItem; var S: WideString);
begin
    // after an item is edited, put them on the add list,
    // so we send in their updated nick
    _adds.AddObject(Item.Caption, Item)
end;

end.
