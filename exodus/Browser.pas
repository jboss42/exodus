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
    Dockable, Entity, IQ, XMLTag, XMLUtils, Contnrs, Unicode,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ImgList, Buttons, ComCtrls, ExtCtrls, Menus, ToolWin, fListbox,
    fService, TntStdCtrls, TntComCtrls, TntExtCtrls;

type

  TfrmBrowse = class(TfrmDockable)
    Panel3: TTntPanel;
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
    vwBrowse: TTntListView;
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
    pnlInfo: TTntPanel;
    pnlTop: TTntPanel;
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
    pnlJID: TTntPanel;
    cboJID: TTntComboBox;
    pnlButtons: TTntPanel;
    btnGo: TSpeedButton;
    btnRefresh: TSpeedButton;
    lblError: TTntLabel;
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
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure popContextPopup(Sender: TObject);
  private
    { Private declarations }
    _cur: integer;
    _history: TWidestringList;
    _iq: TJabberIQ;
    _blist: TList;
    _scb: integer;
    _ecb: integer;

    _ent: TJabberEntity;

    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure EntityCallback(event: string; tag:TXMLTag);
    procedure ShowItems();
    procedure ShowInfo(e: TJabberEntity);

    // Generic GUI stuff
    procedure SetupTitle(name, jid: Widestring);
    procedure StartList();
    procedure DoBrowse(jid: Widestring; refresh: boolean);
    procedure PushJID(jid: Widestring);
    procedure StartBar();
    procedure StopBar();
    procedure ContextMenu(enabled: boolean);

  public
    { Public declarations }
    procedure GoJID(jid: Widestring; refresh: boolean);

    procedure DockForm; override;
    procedure FloatForm; override;

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
    EntityCache, 
    JabberConst, JoinRoom, Room, Roster, JabberID, Bookmark,
    ExUtils, Session, JUD, Profile, RegForm, Jabber1;

var
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
procedure TfrmBrowse.SetupTitle(name, jid: Widestring);
begin
    //lblTitle.Caption := title + ': ' + name;
    //lblHeader.Caption := title;
end;

{---------------------------------------}
procedure TfrmBrowse.StartList;
begin
    // The clears the list properly.
    _blist.Clear();
    vwBrowse.Items.Count := 0;
    vwBrowse.Items.Clear();
    pnlInfo.Visible := false;
    vwBrowse.Visible := true;
end;

{---------------------------------------}
procedure TfrmBrowse.DoBrowse(jid: Widestring; refresh: boolean);
begin
    // Actually Browse to the JID entered in the address box
    if (not isValidJID(jid)) then begin
        MessageDlg(sInvalidJID, mtError, [mbOK], 0);
        exit;
    end;

    StartList;
    StartBar;

    // do the browse query
    _ent := jEntityCache.getByJid(jid);
    if (_ent = nil) then
        _ent := jEntityCache.fetch(jid, MainSession)
    else if (refresh = false) then
        _ent := jEntityCache.fetch(jid, MainSession)
    else
        _ent.Refresh(MainSession);
end;

{---------------------------------------}
procedure TfrmBrowse.GoJID(jid: Widestring; refresh: boolean);
begin
    cboJID.Text := jid;
    DoBrowse(jid, refresh);
    PushJID(jid);
end;

{---------------------------------------}
procedure TfrmBrowse.PushJID(jid: Widestring);
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
    AssignUnicodeFont(Self);
    _History := TWidestringList.Create;
    _blist := TList.Create();
    _iq := nil;
    vwBrowse.ViewStyle := TViewStyle(MainSession.Prefs.getInt('browse_view'));

    // Branding
    mJoinConf.Visible := MainSession.Prefs.getBool('brand_muc');
    mBookmark.Visible := MainSession.Prefs.getBool('brand_muc');

    pnlInfo.Visible := false;
    pnlInfo.Align := alClient;

    _scb := MainSession.RegisterCallback(SessionCallback, '/session/disconnected');
    _ecb := MainSession.RegisterCallback(EntityCallback, '/session/entity');
end;

{---------------------------------------}
procedure TfrmBrowse.FormDestroy(Sender: TObject);
begin
    // Free the History list
    if (_iq <> nil) then
        FreeAndNil(_iq);

    if (MainSession <> nil) then begin
        MainSession.UnRegisterCallback(_scb);
        MainSession.UnRegisterCallback(_ecb);
    end;

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
procedure TfrmBrowse.ContextMenu(enabled: boolean);
begin
    mBrowse.Enabled := enabled;
    mBrowseNew.Enabled := enabled;
    mBookmark.Enabled := enabled;

    mVCard.Enabled := enabled;
    mVersion.Enabled := enabled;
    mTime.Enabled := enabled;
    mLast.Enabled := enabled;
    mSearch.Enabled := enabled;
    mRegister.Enabled := enabled;
    mJoinConf.Enabled := enabled;
end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
    b: TJabberEntity;
begin
    // The selection has changed from one item to another
    if Item = nil then begin
        ContextMenu(false);
        exit;
    end;

    ContextMenu(true);

    b := TJabberEntity(_blist[Item.Index]);

    mVersion.Enabled := b.hasFeature(XMLNS_VERSION);
    mTime.Enabled := b.hasFeature(XMLNS_TIME);
    mLast.Enabled := b.hasFeature(XMLNS_LAST);
    mSearch.Enabled := b.hasFeature(FEAT_SEARCH);
    mRegister.Enabled := b.hasFeature(FEAT_REGISTER);

    // various conference namespaces
    if (b.hasFeature(XMLNS_CONFERENCE)) then mJoinConf.Enabled := true
    else if (b.hasFeature(FEAT_GROUPCHAT)) then mJoinConf.Enabled := true
    else if (b.hasFeature(XMLNS_MUC)) then mJoinConf.Enabled := true
    else if (b.hasFeature('gc-1.0')) then mJoinConf.Enabled := true
    else if (b.category = 'conference') then mJoinConf.Enabled := true
    else mJoinConf.Enabled := false;
end;

{---------------------------------------}
procedure TfrmBrowse.mRegisterClick(Sender: TObject);
var
    j: Widestring;
begin
    // Register to this Service
    if vwBrowse.Selected = nil then exit;
    j := vwBrowse.Selected.SubItems[0];
    StartServiceReg(j);
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
    if (_iq <> nil) then begin
        _iq.Free();
        _iq := nil;
    end;
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
    itm := vwBrowse.Selected;
    cjid := itm.SubItems[0];

    tmpjid := TJabberID.Create(cjid);
    if (tmpjid.user = '') then
        StartJoinRoom(tmpjid, '', '')
    else
        StartRoom(cjid, '');
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
    itm := vwBrowse.Selected;
    j := itm.SubItems[0];

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
procedure TfrmBrowse.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/disconnected') then begin
        StartList;
        StartBar;
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.EntityCallback(event: string; tag:TXMLTag);
var
    tmps: Widestring;
    ce: TJabberEntity;
begin
    if (_ent = nil) then exit;
    if (tag = nil) then exit;

    tmps := tag.getAttribute('from');

    if (_ent.jid.full = tmps) then begin
        if (event = '/session/entity/items') then
            ShowItems()
        else begin
            ShowInfo(_ent);

            setupTitle(_ent.Name, _ent.Jid.full);
            StatBar.Panels[0].Text := IntToStr(_blist.Count) + ' ' + sObjects;
            pnlInfo.Visible := false;
            vwBrowse.Visible := true;

            StopBar();

        end;
    end
    else if (event = '/session/entity/info') then begin
        // check to see if this is a child item of _ent
        ce := _ent.ItemByJid(tmps);
        if (ce <> nil) then
            ShowInfo(ce);
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.ShowItems();
var
    i: integer;
begin
    // populate listview with empty items.
    _blist.Clear();
    for i := 0 to _ent.ItemCount - 1 do
        _blist.Add(_ent.Items[i]);

    // set the listview count
    vwBrowse.Items.Count := _blist.Count;
end;

{---------------------------------------}
procedure TfrmBrowse.ShowInfo(e: TJabberEntity);
var
    i: integer;
begin
    //
    e.tag := -1;
    if (e.category =  'service') then begin
        e.tag := 5;
    end
    else if (e.category =  'conference') then begin
        e.tag := 1;
    end
    else if (e.category =  'user') then begin
        e.tag := 0;
    end
    else if (e.category =  'application') then begin
        e.tag := 7;
    end
    else if (e.category =  'headline') then begin
        e.tag := 6;
    end
    else if (e.category =  'render') then begin
        e.tag := 2;
    end
    else if (e.category =  'keyword') then begin
        e.tag := 3;
    end
    else begin
        e.tag := 4;
    end;

    i := _blist.IndexOf(e);
    if (i >= 0) then
        vwBrowse.Invalidate();

end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseData(Sender: TObject; Item: TListItem);
var
    b: TJabberEntity;
begin
  inherited;
    with Item do begin
        b := TJabberEntity(_blist[index]);
        if (b.name <> '') then
            caption := b.name
        else
            caption := b.jid.full;

        if (b.Tag = -1) then
            ImageIndex := 8
        else
            ImageIndex := b.tag;
        SubItems.Add(b.jid.full);
        SubItems.Add(b.catType);
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
    j1, j2: TJabberEntity;
    s1, s2: Widestring;
begin
    // compare 2 items..
    if (cur_sort = -1) then begin
        Result := 0;
        exit;
    end;

    j1 := TJabberEntity(Item1);
    j2 := TJabberEntity(Item2);

    case (cur_sort) of
    0: begin
        s1 := j1.name;
        s2 := j2.name;
    end;
    1: begin
        s1 := j1.jid.full;
        s2 := j2.jid.full;
    end;
    2: begin
        s1 := j1.catType;
        s2 := j2.catType;
    end
    else begin
        Result := 0;
        exit;
    end;
    end;

    if (cur_dir) then
        Result := AnsiCompareText(s1, s2)
    else
        Result := AnsiCompareText(s2, s1);

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

  _blist.Sort(ItemCompare);
  vwBrowse.Refresh;
end;

{---------------------------------------}
procedure TfrmBrowse.DockForm;
begin
    inherited;
    btnClose.Visible := true;
end;

{---------------------------------------}
procedure TfrmBrowse.FloatForm;
begin
    inherited;
    btnClose.Visible := false;
end;

{---------------------------------------}
procedure TfrmBrowse.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  inherited;
    btnClose.Visible := Docked;
end;

{---------------------------------------}
procedure TfrmBrowse.popContextPopup(Sender: TObject);
begin
  inherited;
    // Check for valid actions..
    if ((vwBrowse.Selected = nil) or (not MainSession.Active)) then
        ContextMenu(false);
end;


end.
