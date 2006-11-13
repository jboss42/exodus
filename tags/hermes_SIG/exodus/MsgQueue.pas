unit MsgQueue;
{
    Copyright 2001, Peter Millard

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
    Jabber1, ExEvents, XMLTag, Contnrs, Unicode,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Dockable, ComCtrls, StdCtrls, ExtCtrls, ToolWin, RichEdit2,
    ExRichEdit, Menus, TntComCtrls, TntMenus, TntStdCtrls, Buttons;

type
  {
    JJF added roster rendering for "PGM" layout.
  }
  TfrmMsgQueue = class(TfrmDockable)
    PopupMenu1: TTntPopupMenu;
    D1: TTntMenuItem;
    pnlRoster: TPanel;
    pnlMsgQueue: TPanel;
    Splitter1: TSplitter;
    lstEvents: TTntListView;
    txtMsg: TExRichEdit;
    splitRoster: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure lstEventsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstEventsDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstEventsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lstEventsData(Sender: TObject; Item: TListItem);
    procedure txtMsgURLClick(Sender: TObject; URL: String);
    procedure D1Click(Sender: TObject);
    procedure lstEventsEnter(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure splitRosterMoved(Sender: TObject);
  private
    { Private declarations }
    _queue          : TObjectList;
    _updatechatCB   : integer;
    _connectedCB    : Integer; //session connected callback ID
    _disconnectedCB : Integer; //session disconnected callback ID

    _currSpoolFile  : Widestring; //current spool file we are reading/writing
    _documentDir    : Widestring; //path to My Documents/Exodus-Logs

    _loading: boolean;
    _sel: integer;

    procedure SaveEvents();
    procedure LoadEvents();
    procedure removeItems();

    function FindColumnIndex(pHeader: pNMHdr): integer;
    function FindColumnWidth(pHeader: pNMHdr): integer;

    procedure setSpoolPath(connected : boolean);
    procedure ClearItems();
  protected
    procedure WMNotify(var Msg: TWMNotify); message WM_NOTIFY;
  published
    procedure SessionCallback(event: string; tag: TXMLTag);

    {
        Render the roster

        Embed the roster if not already showing
    }
    procedure ShowRoster();

    {
        Hide the roster

        Hide the roster and clear state if rendering it.
    }
    procedure HideRoster();

    function GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;override;
    class procedure AutoOpenFactory(autoOpenInfo: TXMLTag);override;
  public
    { Public declarations }
    procedure LogEvent(e: TJabberEvent; msg: string; img_idx: integer);
    procedure RemoveItem(i: integer);
  end;

var
  frmMsgQueue: TfrmMsgQueue;

const
    sNoSpoolDir = ' could not create or write to the spool directory specified in the options.';
    sDefaultSpool = 'default_spool.xml';

function showMsgQueue(bringToFront: boolean=true; dockOverride: string = 'n'): TfrmMsgQueue;
function getMsgQueue(bringToFront: boolean=true; dockOverride: string = 'n'): TfrmMsgQueue;
function isMsgQueueShowing(): boolean;
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    RosterWindow, //for roster rendering
    MsgList, MsgController, ChatWin, ChatController,
    ShellAPI, CommCtrl, GnuGetText,
    NodeItem, Roster, JabberID, XMLUtils, XMLParser,
    JabberUtils, ExUtils,  MsgRecv, Session, PrefController;
const
    SE_UPDATE_CHAT = '/session/gui/update-chat';
    SE_CONNECTED = '/session/authenticated';
    SE_DISCONNECTED = '/session/disconnected';

    CB_UNASSIGNED = -1; //unassigned callback ID

{---------------------------------------}
function showMsgQueue(bringToFront: boolean; dockOverride: string): TfrmMsgQueue;
begin
    Result := getMsgQueue(bringToFront, dockOverride);
end;

{---------------------------------------}
function getMsgQueue(bringToFront: boolean; dockOverride: string): TfrmMsgQueue;
begin
    if frmMsgQueue = nil then
        frmMsgQueue := TfrmMsgQueue.Create(Application);
    frmMsgQueue.ShowDefault(bringToFront, dockOverride);
    Result := frmMsgQueue;
end;

function isMsgQueueShowing(): boolean;
begin
    Result := (frmMsgQueue <> nil) and frmMsgQueue.Visible;
end;

class procedure TfrmMsgQueue.AutoOpenFactory(autoOpenInfo: TXMLTag);
begin
    getMsgQueue(false); //open but don't bring to front
end;

function TfrmMsgQueue.GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;
begin
    if (event = 'shutdown') then begin
        Result := TXMLtag.Create(Self.ClassName);
        useProfile := false;
    end
    else Result := inherited GetAutoOpenInfo(event, useProfile);
end;

{---------------------------------------}
procedure TfrmMsgQueue.LogEvent(e: TJabberEvent; msg: string; img_idx: integer);
var
    tmp_jid: TJabberID;
    ritem: TJabberRosterItem;
begin
    // display this item
    e.img_idx := img_idx;
    e.msg := msg;

    tmp_jid := TJabberID.Create(e.from);
    ritem := MainSession.roster.Find(tmp_jid.jid);
    if (ritem = nil) then
        ritem := MainSession.roster.Find(tmp_jid.full);

    if (ritem <> nil) then
        e.Caption := ritem.Text
    else
        e.Caption := tmp_jid.getDisplayJID();

    tmp_jid.Free();
    // NB: _queue now owns e... it needs to free it, etc.
    _queue.Add(e);
    lstEvents.Items.Count := lstEvents.Items.Count + 1;
    SaveEvents();
end;

{---------------------------------------}
procedure TfrmMsgQueue.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = SE_CONNECTED) then begin
        setSpoolPath(true);
        ClearItems();
        loadEvents();
    end
    else if (event = SE_DISCONNECTED) then begin
        setSpoolPath(false);
        ClearItems();
        loadEvents();
    end
    else if ((event = SE_UPDATE_CHAT) and (tag <> nil)) then begin
        SaveEvents();
    end;
end;

{---------------------------------------}
procedure TfrmMsgQueue.SaveEvents();
var
    t, i, d: integer;
    s, e: TXMLTag;
    event: TJabberEvent;
    ss: TStringList;
    c: TChatController;
    tl: TXMLTagList;
begin
    // save all of the events in the listview out to a file
    if (MainSession = nil) then exit;
    if (_loading) then exit;

    s := TXMLTag.Create('spool');
    for i := 0 to _queue.Count - 1 do begin
        event := TJabberEvent(_queue[i]);
        e := s.AddTag('event');
        with e do begin
            e.setAttribute('img', IntToStr(event.img_idx));
            e.setAttribute('caption', event.caption);
            e.setAttribute('msg', event.msg);
            e.setAttribute('timestamp', DateTimeToStr(event.Timestamp));
            e.setAttribute('edate', DateTimeToStr(event.edate));
            e.setAttribute('elapsed_time', IntToStr(event.elapsed_time));
            e.setAttribute('etype', IntToStr(integer(event.eType)));
            e.setAttribute('from', event.from);
            e.setAttribute('id', event.id);
            e.setAttribute('str_content', event.str_content);
            for d := 0 to event.Data.Count - 1 do
                e.AddBasicTag('data', event.Data.Strings[d]);

            // spool out queued chat messages to disk.
            if (event.eType = evt_Chat) then begin
                c := MainSession.ChatList.FindChat(event.from_jid.jid, event.from_jid.resource, '');
                if (c <> nil) then begin
                    tl := c.getTags();
                    for t := 0 to tl.Count - 1 do
                        e.AddTag(tl[t]);
                    tl.Free();
                end;
            end;
        end;
    end;

    ss := TStringlist.Create();
    try
        ss.Add(UTF8Encode(s.xml));
        ss.SaveToFile(_currSpoolFile);
    except
        MessageDlgW(WideFormat(_('There was an error trying to write to the file: %s'), [_currSpoolFile]),
            mtError, [mbOK], 0);
    end;

    ss.Free();
    s.Free();
end;

{---------------------------------------}
procedure TfrmMsgQueue.LoadEvents();
var
    m,i,d: integer;
    p: TXMLTagParser;
    cur_e, s: TXMLTag;
    msgs, dtags, etags: TXMLTagList;
    e: TJabberEvent;
    c: TChatController;
begin
    if (not FileExists(_currSpoolFile)) then exit;

    _loading := true;

    p := TXMLTagParser.Create();
    p.ParseFile(_currSpoolFile);

    if p.Count > 0 then begin
        s := p.popTag();
        etags := s.ChildTags();

        for i := 0 to etags.Count - 1 do begin
            cur_e := etags[i];
            e := TJabberEvent.Create();
            _queue.Add(e);
            e.eType := TJabberEventType(SafeInt(cur_e.GetAttribute('etype')));
            e.from := cur_e.GetAttribute('from');
            e.from_jid := TJabberID.Create(e.from);
            e.id := cur_e.GetAttribute('id');
            try
                e.Timestamp := StrToDateTime(cur_e.GetAttribute('timestamp'));
            except
                on EConvertError do
                    e.Timestamp := Now();
            end;
            try
                e.edate := StrToDateTime(cur_e.GetAttribute('edate'));
            except
                on EConvertError do
                    e.edate := Now();
            end;
            e.str_content := cur_e.GetAttribute('str_content');
            if (e.str_content = '') then
                // check data_type for backwards compat.
                e.str_content := cur_e.getAttribute('data_type');
            e.elapsed_time := SafeInt(cur_e.GetAttribute('elapsed_time'));
            e.msg := cur_e.GetAttribute('msg');
            e.caption := cur_e.GetAttribute('caption');
            e.img_idx := SafeInt(cur_e.GetAttribute('img'));

            lstEvents.Items.Count := lstEvents.Items.Count + 1;

            dtags := cur_e.QueryTags('data');
            for d := 0 to dtags.Count - 1 do
                e.Data.Add(dtags[d].Data);
            dtags.Free();

            // create a new chat controller for this event and populate it
            msgs := cur_e.QueryTags('message');
            if (msgs.Count > 0) then begin
                c := MainSession.ChatList.FindChat(e.from_jid.jid, e.from_jid.resource, '');
                if (c = nil) then
                    c := MainSession.ChatList.AddChat(e.from_jid.jid, e.from_jid.resource);
                c.AddRef();
                for m := 0 to msgs.Count - 1 do
                    c.PushMessage(msgs[m]);
            end;
            msgs.Free();
        end;
        etags.Free();
        s.Free();
    end;
    p.Free();

    _loading := false;
end;


{---------------------------------------}
procedure TfrmMsgQueue.FormCreate(Sender: TObject);
var
    tmp: integer;
begin
    inherited;

    _updateChatCB := CB_UNASSIGNED;
    _connectedCB  := CB_UNASSIGNED;
    _disconnectedCB := CB_UNASSIGNED;
    
    _loading := false;
    _queue := TObjectList.Create();
    _queue.OwnsObjects := true; //frees on remove, delete, destruction etc
    _documentDir := MainSession.Prefs.getString('log_path');

    lstEvents.Color := TColor(MainSession.Prefs.getInt('roster_bg'));
    txtMsg.Color := lstEvents.Color;

    // AssignDefaultFont(lstEvents.Font);
    AssignUnicodeFont(Self);
    AssignDefaultFont(txtMsg.Font);

    with lstEvents do begin
        tmp := MainSession.Prefs.getInt('quecol_1');
        if (tmp <> 0) then Column[0].Width := tmp;
        tmp := MainSession.Prefs.getInt('quecol_2');
        if (tmp <> 0) then Column[1].Width := tmp;
        tmp := MainSession.Prefs.getInt('quecol_3');
        if (tmp <> 0) then Column[2].Width := tmp;
    end;
    if (MainSession.Authenticated) then begin
        setSpoolPath(true);
    end
    else begin
        setSpoolPath(false);
    end;
    LoadEvents();

    _updateChatCB   := MainSession.RegisterCallback(SessionCallback, SE_UPDATE_CHAT);
    _connectedCB    := MainSession.RegisterCallback(SessionCallback, SE_CONNECTED);
    _disconnectedCB := MainSession.RegisterCallback(SessionCallback, SE_DISCONNECTED);
end;

{---------------------------------------}
procedure TfrmMsgQueue.WMNotify(var Msg: TWMNotify);
var
    c: integer;
    w: longint;
    pref: string;
begin
    inherited;
    if MainSession = nil then exit;

    // pgm 1/26/03 - More API madness. ph3ar my mad skillz.
    // do insane Win32 API magic to trap column resize events
    // thanx to google & the Swiss Delphi center..
    // http://www.swissdelphicenter.ch/en/showcode.php?id=1264
    case Msg.NMHdr^.code of
        HDN_ENDTRACK: begin
            // a column got resized
            c := FindColumnIndex(Msg.NMHdr);
            if (c >= 0) then begin
                w := FindColumnWidth(Msg.NMHdr);
                pref := 'quecol_' + IntToStr(c + 1);
                MainSession.Prefs.setInt(pref, w);
            end;
        end;
    end;
end;

{---------------------------------------}
function TfrmMsgQueue.FindColumnIndex(pHeader: pNMHdr): integer;
var
    hwndHeader: HWND;
    iteminfo: THdItem;
    i: integer;
    buf: array [0..128] of Char;
begin
    Result := -1;
    with lstEvents do begin
        hwndHeader := pHeader^.hwndFrom;
        i := pHDNotify(pHeader)^.Item;
        FillChar(iteminfo, sizeof(iteminfo), 0);
        iteminfo.Mask := HDI_TEXT;
        iteminfo.pszText := buf;
        iteminfo.cchTextMax := sizeof(buf) - 1;
        Header_GetItem(hwndHeader, i, iteminfo);

        // compare the column captions
        if CompareStr(Columns[i].Caption, iteminfo.pszText) = 0 then
            Result := i
        else begin
            for i := 0 to Columns.Count - 1 do begin
                if CompareStr(Columns[i].Caption, iteminfo.pszText) = 0 then begin
                    Result := i;
                    break;
                end;
            end;
        end;
    end;
end;

{---------------------------------------}
function TfrmMsgQueue.FindColumnWidth(pHeader: pNMHdr): integer;
begin
    Result := -1;
    if  (Assigned(PHDNotify(pHeader)^.pItem) and
        ((PHDNotify(pHeader)^.pItem^.mask and HDI_WIDTH) <> 0)) then
        Result := PHDNotify(pHeader)^.pItem^.cxy;
end;

{---------------------------------------}
procedure TfrmMsgQueue.lstEventsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
    e: TJabberEvent;
begin
    txtMsg.InputFormat := ifUnicode;
    if (lstEvents.SelCount <= 0) then begin
        txtMsg.WideLines.Clear;
        _sel := -1;
    end
    else begin
        e := TJabberEvent(_queue[Item.Index]);
        if ((e <> nil) and (lstEvents.SelCount = 1) and
            (e.Data.Text <> '') and (Item.Selected) and (Change = ctState) and
            (Item.Index <> _sel) and (Item.Index >= 0) ) then begin
            _sel := Item.Index;
            txtMsg.WideText := e.Data.Text;
            txtMsg.ScrollToTop();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmMsgQueue.lstEventsDblClick(Sender: TObject);
var
    e: TJabberEvent;
begin
    if (lstEvents.SelCount <= 0) then exit;
    if (MainSession = nil) then exit;
    if (not MainSession.Active) then exit;
    e := TJabberEvent(_queue.Items[lstEvents.Selected.Index]);
    if (e.eType = evt_Chat) then begin
        // startChat will automatically play the queue of msgs
        StartChat(e.from_jid.jid, e.from_jid.resource, true);
        RemoveItem(lstEvents.Selected.Index);
    end else
        StartRecvMsg(e);
end;

{---------------------------------------}
procedure TfrmMsgQueue.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    if (mainSession <> nil)  then begin
        if (_updateChatCB <>CB_UNASSIGNED) then
            MainSession.UnRegisterCallback(_updateChatCB);
        if (_connectedCB <>CB_UNASSIGNED) then
            MainSession.UnRegisterCallback(_connectedCB);
        if (_disconnectedCB <>CB_UNASSIGNED) then
            MainSession.UnRegisterCallback(_disconnectedCB);
    end;
    _queue.Free(); //owns refs, frees them here
    Action := caFree;
    frmMsgQueue := nil;
    inherited;
end;

{---------------------------------------}
procedure TfrmMsgQueue.btnCloseClick(Sender: TObject);
begin
    inherited;
    Self.Close();
end;

procedure TfrmMsgQueue.ClearItems();
begin
    if (isNotifying) then
        isNotifying := false;

    _queue.Clear(); //frees references
    lstEvents.items.Clear();
    txtMsg.Clear();
end;

{---------------------------------------}
procedure TfrmMsgQueue.RemoveItem(i: integer);
begin
    _queue.Delete(i); //frees reference
    lstEvents.Items.Count := _queue.Count;
    if (_queue.Count = 0) then begin
        lstEvents.Items.Clear();
        txtMsg.WideLines.Clear();
    end;
    Self.SaveEvents();
end;

{---------------------------------------}
procedure TfrmMsgQueue.removeItems();
var
    i: integer;
    first : integer;
    item : TListItem;
    e : TJabberEvent;
begin
    first := -1;
    if (lstEvents.SelCount = 0) then begin
        exit;
    end
    else if (lstEvents.SelCount = 1) then begin
        item := lstEvents.Selected;
        i := item.Index;
        first := i;
        RemoveItem(i);
    end
    else begin
        for i := lstEvents.Items.Count-1 downto 0 do begin
            if (lstEvents.Items[i].Selected) then begin
                _queue.Delete(i); //frees reference
                lstEvents.Items.Count := lstEvents.Items.Count - 1;
                first := i;
            end;
        end;
        Self.SaveEvents();
        lstEvents.ClearSelection();
    end;

    if ((first <> -1) and (first < lstEvents.Items.Count)) then begin
        lstEvents.ItemIndex := first;
        e := TJabberEvent(_queue[first]); //e is reference
        if ((e <> nil) and (lstEvents.SelCount = 1) and (e.Data.Text <> '')) then
            txtMsg.WideText := e.Data.Text;
    end
    else if (lstEvents.Items.Count > 0) then
        lstEvents.ItemIndex := lstEvents.Items.Count - 1;

    if (lstEvents.Selected <> nil) then begin
        lstEvents.Selected.MakeVisible(false);
        lstEvents.ItemFocused := lstEvents.Selected;
    end;

    lstEvents.Refresh;
end;

{---------------------------------------}
procedure TfrmMsgQueue.lstEventsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    c: integer;
begin
    // pickup hot-keys on the list view..
    case Key of
    VK_DELETE, VK_BACK, Ord('d'), Ord('D'): begin
        Key := $0;
        removeItems();
    end;
    Ord(' '): begin
        Key := $0;
        if txtMsg.atBottom then begin
            c := _sel;
            if (c + 1) < lstEvents.Items.Count then begin
                lstEvents.ClearSelection();
                lstEvents.ItemIndex := c + 1;
            end;
       end
       else
           txtMsg.ScrollPageDown();
    end;
    end;

end;

{---------------------------------------}
procedure TfrmMsgQueue.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    inherited;
    lstEvents.Items.Clear;
end;

{---------------------------------------}
procedure TfrmMsgQueue.lstEventsData(Sender: TObject; Item: TListItem);
var
    e: TJabberEvent;
begin
    inherited;
    if (item.index >= _queue.Count) then
        exit;

    e := TJabberEvent(_queue[item.Index]);

    TTntListItem(item).Caption := e.caption;
    item.ImageIndex := e.img_idx;
    item.SubItems.Add(DateTimeToStr(e.edate));
    item.SubItems.Add(e.msg);         // Subject
end;

{---------------------------------------}
procedure TfrmMsgQueue.txtMsgURLClick(Sender: TObject; URL: String);
begin
  inherited;
    ShellExecute(Application.Handle, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

{---------------------------------------}
procedure TfrmMsgQueue.D1Click(Sender: TObject);
begin
  inherited;
    removeItems();
end;

{---------------------------------------}
procedure TfrmMsgQueue.lstEventsEnter(Sender: TObject);
begin
  inherited;
    if ((lstEvents.ItemIndex = -1) and (lstEvents.Items.Count > 0)) then
        lstEVents.ItemIndex := 0;
end;


{---------------------------------------}
{*
    Set the path used for the spool file based on session. If disconnected, a
    global spool.xml file is used (for offline events? not sure what would
    ever be in a spool file when disconnected but might as well leave
    the option open). If connected a jid_spool file will be used.
*}
procedure TfrmMsgQueue.setSpoolPath(connected : boolean);
begin
    if (connected) then begin
        _currSpoolFile := _documentDir + '\' + MungeName(mainSession.BareJid) + '_spool.xml';
    end
    else begin
        _currSpoolFile := _documentDir + '\' + sDefaultSpool;
    end;
end;

{
    Render the roster

    Embed the roster if not already showing
}
procedure TfrmMsgQueue.ShowRoster();
begin
        //this is a mess. To get splitter working with the correct control
        //we need to hide/de-align/set their relative positions/size them and show them
        pnlRoster.Visible := false;
        splitRoster.Visible := false;
        pnlRoster.Align := alNone;
        splitRoster.Align := alNone;
        pnlMsgQueue.Align := alNone;

        pnlRoster.Left := 0;
        splitRoster.Left := pnlRoster.BoundsRect.Right + 1;
        pnlMsgQueue.Left := splitRoster.BoundsRect.Right + 1;

        pnlRoster.Width := MainSession.Prefs.getInt(PrefController.P_ROSTER_WIDTH);

        pnlRoster.Align := alLeft;
        splitRoster.Align := alLeft;
        pnlMsgQueue.Align := alClient;

        pnlRoster.Visible := true;
        splitRoster.Visible := true;
        RosterWindow.DockRoster(pnlRoster);
end;

procedure TfrmMsgQueue.splitRosterMoved(Sender: TObject);
begin
  inherited;
    if (pnlRoster.Visible and (pnlRoster.Width > 0)) then
        mainSession.Prefs.setInt(PrefController.P_ROSTER_WIDTH, pnlRoster.Width);
end;

{
    Hide the roster

    Hide the roster and clear state if rendering it.
}
procedure TfrmMsgQueue.HideRoster();
begin
    if (pnlRoster.Visible) then begin
        pnlRoster.Visible := false;
        splitRoster.Visible := false;
        pnlMsgQueue.Align := alClient; //fill it all
    end;
end;

initialization
    Classes.RegisterClass(TfrmMsgQueue);

end.
