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
    Dockable, IQ, XMLTag, XMLUtils,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ImgList, Buttons, ComCtrls, ExtCtrls, Menus, ToolWin, fListbox,
    fService;

type
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
    procedure vwBrowseDeletion(Sender: TObject; Item: TListItem);
    procedure vwBrowseChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure mRegisterClick(Sender: TObject);
    procedure mBookmarkClick(Sender: TObject);
    procedure mVCardClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mBrowseClick(Sender: TObject);
    procedure mBrowseNewClick(Sender: TObject);
    procedure mJoinConfClick(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure FormStartDock(Sender: TObject;
      var DragObject: TDragDockObject);
    procedure mSearchClick(Sender: TObject);
  private
    { Private declarations }
    _cur: integer;
    _history: TStringList;

    _iq: TJabberIQ;
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

    procedure StartDockChange();
    procedure EndDockChange();

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
    Room, 
    ExUtils, Session, JUD, Profile, RegForm, Jabber1;

var
    browseCache: TStringList;

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


function ShowBrowser(jid: string = ''): TfrmBrowse;
begin
    Result := TfrmBrowse.Create(nil);
    Application.CreateForm(TfrmBrowse, Result);
    Result.ShowDefault();

    if (jid = '') then
        Result.GoJID(MainSession.Server, true)
    else
        Result.GoJID(jid, true);
end;

{---------------------------------------}
procedure TfrmBrowse.SetupTitle(title, name, jid: string);
begin
    lblTitle.Caption := title + ': ' + name;
    lblHeader.Caption := title;
end;

{---------------------------------------}
procedure TfrmBrowse.StartList;
var
    i: integer;
    itm: TListItem;
begin
    // The clears the list properly.
    with vwBrowse do begin
        for i := 0 to Items.Count - 1 do begin
            itm := items[i];
            if itm.Data <> nil then
                TStringList(itm.Data).Free;
            itm.Data := nil;
            end;
        Items.Clear;
        end;

    fNS.List1.Items.Clear;
    with fActions do begin
        pRegister.Visible := false;
        pSearch.Visible := false;
        pConf.Visible := false;
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
    StatBar.Panels[0].Text := IntToStr(vwBrowse.Items.Count) + ' ' + sObjects;
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
            if (cur_ns = XMLNS_CONFERENCE) then
                pConf.Visible := true;
            end;
        end;

    StopBar;
end;

{---------------------------------------}
procedure TfrmBrowse.ShowBrowse(tag: TXMLTag);
var
    itm: TListItem;
    title, stype, jid, name: string;
    i, idx: integer;
    ns: TXMLTagList;
    nslist: TStringList;
begin
    // Show this item.
    itm := vwBrowse.Items.Add;
    jid := tag.getAttribute('jid');
    name := tag.getAttribute('name');
    stype := tag.GetAttribute('type');
    with itm do begin

        if (name <> '') then
            Caption := name
        else
            Caption := jid;

        // create a list of namespaces linked to the object
        nslist := TStringList.Create;
        SubItems.Add(jid);
        SubItems.Add(stype);

        title := '';
        idx := -1;
        getBrowseProps(tag, title, idx);
        ImageIndex := idx;

        // Add strings to the nslist to enable the context
        // popup support.
        ns := tag.QueryTags('ns');
        for i := 0 to ns.Count - 1 do
            nslist.Add(ns[i].Data);
        Data := nsList;
        end;
end;

{---------------------------------------}
procedure TfrmBrowse.DoBrowse(jid: string; refresh: boolean);
var
    id: string;
    i: integer;
begin
    // Actually Browse to the JID entered in the address box
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

    Self.OnDockStartChange := StartDockChange;
    Self.OnDockEndChange := EndDockChange;

end;

{---------------------------------------}
procedure TfrmBrowse.FormDestroy(Sender: TObject);
begin
    // Free the History list
    _History.Free();
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
    if Sender = Details1 then vwBrowse.ViewStyle := vsReport;
    if Sender = LargeIcons1 then vwBrowse.ViewStyle := vsIcon;
    if Sender = SmallIcons1 then vwBrowse.ViewStyle := vsSmallIcon;
    if Sender = List1 then vwBrowse.ViewStyle := vsList;
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
procedure TfrmBrowse.vwBrowseDeletion(Sender: TObject; Item: TListItem);
begin
    // An object is being deleted from the list view
    // free the associated stringlist of namespaces
    if Item.Data <> nil then begin
        TStringList(Item.Data).Free;
        Item.Data := nil;
        end;
end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
    // The selection has changed from one item to another
    if Item = nil then exit;

    if item.Data <> nil then begin
        with TStringList(Item.Data) do begin
            mVersion.Enabled := IndexOf(XMLNS_VERSION) >= 0;
            mTime.Enabled := IndexOf(XMLNS_TIME) >= 0;
            mLast.Enabled := Indexof(XMLNS_LAST) >= 0;
            mSearch.Enabled := IndexOf(XMLNS_SEARCH) >= 0;
            mRegister.Enabled := IndexOf(XMLNS_REGISTER) >= 0;
            mJoinConf.Enabled := IndexOf(XMLNS_CONFERENCE) >= 0;
            end;
        end
    else begin
        mVersion.Enabled := false;
        mTime.Enabled := false;
        mLast.Enabled := false;
        mSearch.Enabled := false;
        mRegister.Enabled := false;
        mJoinConf.Enabled := false;
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
begin
    // todo: add bookmark
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
    cjid: string;
begin
    // join conf. room
    cjid := _history[_cur - 1];
    StartRoom(cjid, MainSession.Username);
end;

procedure TfrmBrowse.StartDockChange();
begin
    vwBrowse.Items.Clear;
end;

procedure TfrmBrowse.EndDockChange();
begin
    // rebrowse to this JID to refresh the dumb listview.
    // *SIGH*
    if cboJID.Text <> '' then
        DoBrowse(cboJID.Text, false);
end;

{---------------------------------------}
procedure TfrmBrowse.FormEndDock(Sender, Target: TObject; X, Y: Integer);
begin
    Self.EndDockChange();
end;

{---------------------------------------}
procedure TfrmBrowse.FormStartDock(Sender: TObject;
  var DragObject: TDragDockObject);
begin
    Self.StartDockChange();
end;

{---------------------------------------}
procedure TfrmBrowse.mSearchClick(Sender: TObject);
var
    itm: TListItem;
begin
    // Search using this service.
    itm := vwBrowse.Selected;
    if itm = nil then exit;

    StartSearch(itm.SubItems[0]);
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
            exit;
            end;

        // we have some kind of result
        clist := tag.ChildTags();
        if (clist.Count <= 0) then begin
            Self.ShowError(tag);
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
end;


initialization
    browseCache := TStringList.Create();

finalization
    ClearStringlistObjects(browseCache);
    browseCache.Clear();
    browseCache.Free();

end.
