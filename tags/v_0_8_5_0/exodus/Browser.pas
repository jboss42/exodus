unit Browser;
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
    Dockable, IQ, XMLTag, XMLUtils, Contnrs,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ImgList, Buttons, ComCtrls, ExtCtrls, Menus, ToolWin, fListbox,
    fService;

type

  TBrowseItem = class
  public
    img_idx: integer;
    jid: string;
    stype: string;
    name: string;
    nslist: TStringlist;

    constructor create;
    destructor destroy; override;
end;

  TfrmBrowse = class(TfrmDockable)
    Panel3: TPanel;
    ImageList1: TImageList;
    ImageList2: TImageList;
    Toolbar: TImageList;
    DisToolbar: TImageList;
    popHistory: TPopupMenu;
    popViewStyle: TPopupMenu;
    Details1: TMenuItem;
    LargeIcons1: TMenuItem;
    SmallIcons1: TMenuItem;
    List1: TMenuItem;
    StatBar: TStatusBar;
    vwBrowse: TListView;
    popContext: TPopupMenu;
    mBrowse: TMenuItem;
    mBrowseNew: TMenuItem;
    mBookmark: TMenuItem;
    N1: TMenuItem;
    mSearch: TMenuItem;
    mRegister: TMenuItem;
    mJoinConf: TMenuItem;
    mVersion: TMenuItem;
    mTime: TMenuItem;
    mLast: TMenuItem;
    mVCard: TMenuItem;
    pnlInfo: TPanel;
    fNS: TframeListbox;
    fActions: TframeObjectActions;
    Image1: TImage;
    Panel1: TPanel;
    pnlTitle: TPanel;
    lblTitle: TLabel;
    Splitter1: TSplitter;
    imgIcon: TImage;
    lblHeader: TLabel;
    pnlTop: TPanel;
    btnClose: TSpeedButton;
    CoolBar1: TCoolBar;
    tlbToolBar: TToolBar;
    btnBack: TToolButton;
    btnFwd: TToolButton;
    ToolButton2: TToolButton;
    btnHome: TToolButton;
    ToolButton1: TToolButton;
    btnBookmark: TToolButton;
    tlbJID: TToolBar;
    pnlJID: TPanel;
    cboJID: TComboBox;
    pnlButtons: TPanel;
    btnGo: TSpeedButton;
    btnRefresh: TSpeedButton;
    procedure btnGoClick(Sender: TObject);
    procedure ResizeAddressBar(Sender: TObject);
    procedure cboJIDKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnFwdClick(Sender: TObject);
    procedure vwBrowseClick(Sender: TObject);
    procedure Details1Click(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure vwBrowseChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure mRegisterClick(Sender: TObject);
    procedure mBookmarkClick(Sender: TObject);
    procedure mVCardClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mBrowseClick(Sender: TObject);
    procedure mBrowseNewClick(Sender: TObject);
    procedure mJoinConfClick(Sender: TObject);
    procedure mSearchClick(Sender: TObject);
    procedure vwBrowseData(Sender: TObject; Item: TListItem);
    procedure btnCloseClick(Sender: TObject);
    procedure vwBrowseResize(Sender: TObject);
    procedure vwBrowseColumnClick(Sender: TObject; Column: TListColumn);
  private
    { Private declarations }
    _cur: integer;
    _history: TStringList;
    _iq: TJabberIQ;
    _blist: TObjectList;
    procedure BrowseCallback(event: string; tag: TXMLTag);

    procedure ShowMain(tag: TXMLTag);
    procedure ShowBrowse(tag: TXMLTag);
    procedure SetupTitle(title, name, jid: string);
    procedure StartList();
    procedure DoBrowse(jid: string; refresh: boolean);
    procedure PushJID(jid: string);
    procedure StartBar();
    procedure StopBar();
    procedure getBrowseProps(tag: TXMLTag; var title: string; var image_index: integer);

    function ShowError(Tag: TXMLTag): boolean;

  public
    { Public declarations }
    procedure GoJID(jid: string; refresh: boolean);
  end;

var
  frmBrowse: TfrmBrowse;

function ShowBrowser(jid: string = ''): TfrmBrowse;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.DFM}
uses
    JabberConst, JoinRoom, Room, Roster, JabberID, Bookmark,
    ExUtils, Session, JUD, Profile, RegForm, Jabber1;

var
    browseCache: TStringList;
    cur_sort: integer;
    cur_dir: boolean;

resourceString
    sService = 'Service';
    sConference = 'Conference';
    sUser = 'Jabber User';
    sApplication = 'Application';
    sHeadline = 'Headline Svc.';
    sRender = 'Rendering Svc.';
    sKeyword = 'Keyword Lookup';
    sValidate = 'Validator';
    sItem = 'Jabber Object';
    sObjects = 'Objects';


{---------------------------------------}
function ShowBrowser(jid: string = ''): TfrmBrowse;
begin
    Result := TfrmBrowse.Create(Application);
    Application.CreateForm(TfrmBrowse, Result);
    Result.ShowDefault();

    if (jid = '') then
        Result.GoJID(MainSession.Server, false)
    else
        Result.GoJID(jid, true);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TBrowseItem.Create();
begin
    inherited Create;

    nslist := TStringlist.Create();
    jid := '';
    name := '';
    stype := '';
    img_idx := -1;
end;

{---------------------------------------}
destructor TBrowseItem.destroy();
begin
    nslist.Free();

    inherited Destroy;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmBrowse.SetupTitle(title, name, jid: string);
begin
    lblTitle.Caption := title + ': ' + name;
    lblHeader.Caption := title;
end;

{---------------------------------------}
procedure TfrmBrowse.StartList;
begin
    // The clears the list properly.
    _blist.Clear();
    vwBrowse.Items.Count := 0;
    vwBrowse.Items.Clear();

    fNS.List1.Items.Clear;
    with fActions do begin
        pRegister.Visible := false;
        pSearch.Visible := false;
        pConf.Visible := false;
end;

    if (_iq <> nil) then begin
        _iq.Free();
        _iq := nil;
    end;

end;

{---------------------------------------}
function TfrmBrowse.ShowError(Tag: TXMLTag): boolean;
begin
    Result := false;
    lblTitle.Caption := 'ERROR Browsing this Jabber Object!';
    StopBar;
end;

{---------------------------------------}
procedure TfrmBrowse.getBrowseProps(tag: TXMLTag; var title: string; var image_index: integer);
var
    cat: string;
begin
    cat := tag.GetAttribute('category');
    if (cat = '') then
        cat := tag.Name;

    image_index := -1;
    if (cat = 'service') then begin
        image_index := 5;
        title := sService;
    end
    else if (cat = 'conference') then begin
        image_index := 1;
        title := sConference;
    end
    else if (cat = 'user') then begin
        image_index := 0;
        title := sUser;
    end
    else if (cat = 'application') then begin
        image_index := 7;
        title := sApplication;
    end
    else if (cat = 'headline') then begin
        image_index := 6;
        title := sHeadline;
    end
    else if (cat = 'render') then begin
        image_index := 2;
        title := sRender;
    end
    else if (cat = 'keyword') then begin
        image_index := 3;
        title := sKeyword;
    end
    else begin
        image_index := 4;
        title := sItem;
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.ShowMain(tag: TXMLTag);
var
    i: integer;
    title: string;
    idx: integer;
    bmp: TBitmap;
    ns: TXMLTagList;
    cur_ns: string;
begin
    // Show the main object info
    title := '';
    idx := -1;
    getBrowseProps(tag, title, idx);

    if (idx = -1) then
        Image1.Picture.Assign(nil)
    else begin
        bmp := TBitmap.Create();
        ImageList2.GetBitmap(idx, bmp);
        imgIcon.Picture.Assign(bmp);
        bmp.Free();
    end;

    Self.SetupTitle(title, tag.GetAttribute('name'), '');
    StatBar.Panels[0].Text := IntToStr(_blist.Count) + ' ' + sObjects;
    pnlInfo.Visible := true;
    vwBrowse.Visible := true;
    ns := tag.QueryTags('ns');

    with fActions do begin
        // show properties for this object
        for i := 0 to ns.Count - 1 do begin
            cur_ns := ns[i].Data;
            fNS.List1.Items.Add(cur_ns);
            if (cur_ns = XMLNS_REGISTER) then
                pRegister.Visible := true;
            if (cur_ns = XMLNS_SEARCH) then
                pSearch.Visible := true;
            if ((cur_ns = XMLNS_CONFERENCE) or
                (cur_ns = XMLNS_MUC) or
                (cur_ns = 'gc-1.0')) then
                pConf.Visible := true;
        end;
    end;

    StopBar;
end;

{---------------------------------------}
procedure TfrmBrowse.ShowBrowse(tag: TXMLTag);
var
    itm: TBrowseItem;
    title, stype, jid, name: string;
    i, idx: integer;
    ns: TXMLTagList;
begin
    // Show this item.
    itm := TBrowseItem.Create();
    jid := tag.getAttribute('jid');
    name := tag.getAttribute('name');
    stype := tag.GetAttribute('type');

    itm.name := name;
    itm.jid := jid;
    itm.stype := stype;

    with itm do begin
        // create a list of namespaces linked to the object
        title := '';
        idx := -1;
        getBrowseProps(tag, title, idx);
        img_idx := idx;

        // Add strings to the nslist to enable the context
        // popup support.
        ns := tag.QueryTags('ns');
        for i := 0 to ns.Count - 1 do
            nslist.Add(ns[i].Data);
    end;
    _blist.Add(itm);
end;

{---------------------------------------}
procedure TfrmBrowse.DoBrowse(jid: string; refresh: boolean);
var
    id: string;
    i: integer;
begin
    // Actually Browse to the JID entered in the address box
    if (not isValidJID(jid)) then begin
        MessageDlg(sInvalidJID, mtError, [mbOK], 0);
        exit;
    end;

    StartList;
    StartBar;

    if (not refresh) then begin
        // check the browse cache
        i := browseCache.IndexOf(jid);
        if (i >= 0) then begin
            // we have the tag in the cache
            BrowseCallback('cache', TXMLTag(browseCache.Objects[i]));
            exit;
        end;
    end;

    // do the browse query
    id := MainSession.generateID();
    _iq := TJabberIQ.Create(MainSession, id, BrowseCallback, 30);
    with _iq do begin
        Namespace := XMLNS_BROWSE;
        iqType := 'get';
        toJid := jid;
        Send();
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.GoJID(jid: string; refresh: boolean);
begin
    cboJID.Text := jid;
    DoBrowse(jid, refresh);
    PushJID(jid);
end;

{---------------------------------------}
procedure TfrmBrowse.PushJID(jid: string);
var
    hi, lo, i: integer;
begin
    // Deal with the history list, and menu items
    if _cur < _history.count then begin
        // we aren't at the beginning..
        // clear the history stack from here.
        for i := _history.count - 1 downto _cur + 1 do
            _history.Delete(i);
    end;

    _history.Add(jid);
    hi := _history.Count - 1;
    lo := hi - 10;
    if lo < 0 then lo := 0;
    cboJID.Items.Clear;
    for i := lo to hi do
        cboJID.Items.Add(_history[i]);
    _cur := _history.count;
    btnBack.Enabled := true;
end;

{---------------------------------------}
procedure TfrmBrowse.btnGoClick(Sender: TObject);
begin
    DoBrowse(cboJID.Text, false);
    PushJID(cboJID.Text);
end;

{---------------------------------------}
procedure TfrmBrowse.ResizeAddressBar(Sender: TObject);
begin
    cboJid.Width := tlbJID.Width - (pnlJID.Width + pnlButtons.Width);
    btnClose.Left := Self.ClientWidth - btnClose.Width - 2;
    Coolbar1.Width := Self.ClientWidth - btnClose.Width - 5;
end;

{---------------------------------------}
procedure TfrmBrowse.cboJIDKeyPress(Sender: TObject; var Key: Char);
begin
    // Do a a 'GO' if the <enter> key is hit
    if Key = Chr(13) then btnGoClick(Self);
end;

{---------------------------------------}
procedure TfrmBrowse.FormCreate(Sender: TObject);
begin
    // Create the History list
    _History := TStringList.Create;
    _blist := TObjectList.Create();
    _iq := nil;
    vwBrowse.ViewStyle := TViewStyle(MainSession.Prefs.getInt('browse_view'));

end;

{---------------------------------------}
procedure TfrmBrowse.FormDestroy(Sender: TObject);
begin
    // Free the History list
    _History.Free();
    _blist.Clear();
    _blist.Free();
end;

{---------------------------------------}
procedure TfrmBrowse.btnBackClick(Sender: TObject);
begin
    // Browse to the last JID
    if _cur >= _history.count then
        _cur := _cur - 2
    else
        dec(_cur);
    if _cur < 0 then begin
        _cur := 0;
        btnBack.Enabled := false;
        exit;
    end;

    btnFwd.Enabled := true;
    cboJID.Text := _history[_cur];
    DoBrowse(_history[_cur], false);
    if _cur = 0 then btnBack.Enabled := false;
end;

{---------------------------------------}
procedure TfrmBrowse.btnFwdClick(Sender: TObject);
begin
    // Browse to the next JID in the history
    inc(_cur);
    if _cur >= _history.Count then begin
        _cur := _History.Count;
        btnFwd.Enabled := false;
        exit;
    end;
    btnBack.Enabled := true;
    DoBrowse(_history[_cur], false);
    if _cur = _history.Count then btnFwd.Enabled := false;
end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseClick(Sender: TObject);
var
    itm: TListItem;
begin
    // Browse to this object
    itm := vwBrowse.Selected;
    if itm <> nil then begin
        cboJID.Text := itm.SubItems[0];
        btnGOClick(Self);
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.Details1Click(Sender: TObject);
begin
    // Change the View
    if Sender = Details1 then begin
        vwBrowse.ViewStyle := vsReport;
    end
    else if Sender = LargeIcons1 then begin
        vwBrowse.ViewStyle := vsIcon;
    end
    else if Sender = SmallIcons1 then begin
        vwBrowse.ViewStyle := vsSmallIcon;
    end
    else if Sender = List1 then begin
        vwBrowse.ViewStyle := vsList;
    end;

    MainSession.Prefs.setInt('browse_view', integer(vwBrowse.ViewStyle));

end;

{---------------------------------------}
procedure TfrmBrowse.btnHomeClick(Sender: TObject);
begin
    // browse to the Jabber Server
    cboJID.Text := MainSession.Server;
    btnGOClick(btnHome);
    btnBack.Enabled := false;
    btnFwd.Enabled := false;
end;

{---------------------------------------}
procedure TfrmBrowse.btnRefreshClick(Sender: TObject);
begin
    // Refresh
    StartList;

    // re-browse to this JID..
    DoBrowse(cboJID.Text, true);
    PushJID(cboJID.Text);
end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
    b: TBrowseItem;
begin
    // The selection has changed from one item to another
    if Item = nil then exit;

    b := TBrowseItem(_blist[Item.Index]);
    with b.nslist do begin
        mVersion.Enabled := IndexOf(XMLNS_VERSION) >= 0;
        mTime.Enabled := IndexOf(XMLNS_TIME) >= 0;
        mLast.Enabled := Indexof(XMLNS_LAST) >= 0;
        mSearch.Enabled := IndexOf(XMLNS_SEARCH) >= 0;
        mRegister.Enabled := IndexOf(XMLNS_REGISTER) >= 0;

        // various conference namespaces
        if (IndexOf(XMLNS_CONFERENCE) >= 0) then mJoinConf.Enabled := true;
        if (IndexOf(XMLNS_MUC) >= 0) then mJoinConf.Enabled := true;
        if (IndexOf('gc-1.0') >= 0) then mJoinConf.Enabled := true;
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.mRegisterClick(Sender: TObject);
var
    j: string;
    regform: TfrmRegister;
begin
    // Register to this Service
    if Sender = fActions.lblRegister then
        j := cboJID.Text
    else begin
        if vwBrowse.Selected = nil then exit;
        j := vwBrowse.Selected.SubItems[0];
    end;

    regform := TfrmRegister.Create(Application);
    regform.jid := j;
    regform.Start();
end;

{---------------------------------------}
procedure TfrmBrowse.mBookmarkClick(Sender: TObject);
var
    itm: TListItem;
    fbm: TfrmBookmark;
begin
    itm := vwBrowse.Selected;
    if itm = nil then exit;

    fbm := ShowBookmark('');
    fbm.txtJID.Text := itm.SubItems[0];
    fbm.txtName.Text := itm.Caption;
end;

{---------------------------------------}
procedure TfrmBrowse.mVCardClick(Sender: TObject);
var
    itm: TListItem;
    jid: string;
begin
    // do some CTCP stuff
    itm := vwBrowse.Selected;
    if itm = nil then exit;

    jid := itm.SubItems[0];
    if Sender = mVCard then
        ShowProfile(itm.SubItems[0])
    else begin
        if Sender = mVersion then jabberSendCTCP(jid, XMLNS_VERSION);
        if Sender = mTime then jabberSendCTCP(jid, XMLNS_TIME);
        if Sender = mLast then jabberSendCTCP(jid, XMLNS_LAST);
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if (_iq <> nil) then
        _iq.Free();

    Action := caFree;
end;

{---------------------------------------}
procedure TfrmBrowse.mBrowseClick(Sender: TObject);
var
    itm: TListItem;
begin
    // Browse to this JID
    itm := vwBrowse.Selected;
    if itm = nil then exit;

    cboJID.Text := itm.SubItems[0];
    btnGoClick(Self);
end;

{---------------------------------------}
procedure TfrmBrowse.mBrowseNewClick(Sender: TObject);
var
    itm: TListItem;
begin
    // Browse to this JID
    itm := vwBrowse.Selected;
    if itm = nil then exit;

    GoJID(itm.SubItems[0], true);
end;

{---------------------------------------}
procedure TfrmBrowse.mJoinConfClick(Sender: TObject);
var
    itm: TListItem;
    tmpjid: TJabberID;
    cjid: string;
begin
    // join conf. room
    cjid := '';
    if (Sender = fActions.lblConf) then
        cjid := cboJID.Text
    else begin
        itm := vwBrowse.Selected;
        cjid := itm.SubItems[0];
    end;
    tmpjid := TJabberID.Create(cjid);
    if (tmpjid.user = '') then
        StartJoinRoom(tmpjid, MainSession.username, '')
    else
        StartRoom(cjid, MainSession.Username);
    tmpjid.Free();
end;

{---------------------------------------}
procedure TfrmBrowse.mSearchClick(Sender: TObject);
var
    itm: TListItem;
    j: string;
begin
    // Search using this service.
    j := '';
    if (Sender = fActions.lblSearch) then
        j := cboJID.Text
    else begin
        itm := vwBrowse.Selected;
        j := itm.SubItems[0];
    end;

    if (j <> '') then
        StartSearch(j);
end;

{---------------------------------------}
procedure TfrmBrowse.StartBar;
begin
    //
end;

{---------------------------------------}
procedure TfrmBrowse.StopBar;
begin
    //
end;

{---------------------------------------}
procedure TfrmBrowse.BrowseCallback(event: string; tag: TXMLTag);
var
    i: integer;
    dup, ptag: TXMLTag;
    clist: TXMLTagList;
    jid: string;
begin
    // IQ Callback for current query
    if ((event = 'xml') or (event = 'cache')) then begin
        if (tag.GetAttribute('type') = 'error') then begin
            Self.ShowError(tag);
            _iq := nil;
            exit;
        end;

        // we have some kind of result
        clist := tag.ChildTags();
        if (clist.Count <= 0) then begin
            Self.ShowError(tag);
            _iq := nil;
            exit;
        end;

        ptag := clist[0];
        clist.Free();

        // show the main parent details
        clist := ptag.ChildTags();
        for i := 0 to clist.Count - 1 do begin
            if (clist[i].Name <> 'ns') then
                ShowBrowse(clist[i]);
        end;
        ShowMain(ptag);

        if (event <> 'cache') then begin
            // cache the tag..
            jid := ptag.GetAttribute('jid');
            dup := TXMLTag.Create('iq');
            dup.AssignTag(tag);
            i := browseCache.indexOf(jid);
            if (i < 0) then
                browseCache.AddObject(jid, dup)
            else begin
                TXMLTag(browseCache.Objects[i]).Free();
                browseCache.Objects[i] := dup;
            end;
        end;
    end
    else begin
        // probably a timeout
    end;

    vwBrowse.Items.Count := _blist.Count;
    _iq := nil;
end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseData(Sender: TObject; Item: TListItem);
var
    b: TBrowseItem;
begin
  inherited;
    with Item do begin
        b := TBrowseItem(_blist[index]);
        if (b.name <> '') then
            caption := b.name
        else
            caption := b.jid;
        ImageIndex := b.img_idx;
        SubItems.Add(b.jid);
        SubItems.Add(b.stype);
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.btnCloseClick(Sender: TObject);
begin
  inherited;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseResize(Sender: TObject);
begin
  inherited;
    vwBrowse.Invalidate();
end;

{---------------------------------------}
function ItemCompare(Item1, Item2: Pointer): integer;
var
    j1, j2: TBrowseItem;
    s1, s2: string;
begin
    // compare 2 items..
    if (cur_sort = -1) then begin
        Result := 0;
        exit;
    end;

    j1 := TBrowseItem(Item1);
    j2 := TBrowseItem(Item2);

    case (cur_sort) of
    0: begin
        s1 := j1.name;
        s2 := j2.name;
    end;
    1: begin
        s1 := j1.jid;
        s2 := j2.jid;
    end;
    2: begin
        s1 := j1.stype;
        s2 := j2.stype;
    end
    else begin
        Result := 0;
        exit;
    end;
    end;

    if (cur_dir) then
        Result := StrComp(PChar(LowerCase(s1)),
                          PChar(LowerCase(s2)))
    else
        Result := StrComp(PChar(LowerCase(s2)),
                          PChar(LowerCase(s1)));

end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseColumnClick(Sender: TObject;
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

  _blist.Sort(ItemCompare);
  vwBrowse.Refresh;
end;

initialization
    browseCache := TStringList.Create();

finalization
    ClearStringlistObjects(browseCache);
    browseCache.Clear();
    browseCache.Free();

end.
