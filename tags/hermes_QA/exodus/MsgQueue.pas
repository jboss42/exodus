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
  
  TfrmMsgQueue = class(TfrmDockable)
    PopupMenu1: TTntPopupMenu;
    D1: TTntMenuItem;
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
    procedure ClearItems();
  private
    { Private declarations }
    _updateCB   : integer;

    //_loading: boolean;
    _sel: integer;

    procedure removeItems();

    function FindColumnIndex(pHeader: pNMHdr): integer;
    function FindColumnWidth(pHeader: pNMHdr): integer;
    function GetEventCount(): integer;
    procedure SetEventCount(count: integer);

  protected
    procedure WMNotify(var Msg: TWMNotify); message WM_NOTIFY;
  published
    procedure SessionCallback(event: string; tag: TXMLTag);
    function GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;override;
    class procedure AutoOpenFactory(autoOpenInfo: TXMLTag);override;
    property EventCount: Integer read GetEventCount write SetEventCount;
  public
    { Public declarations }
    procedure RemoveItem(i: integer);
  end;

var
  frmMsgQueue: TfrmMsgQueue;

const
    sNoSpoolDir = ' could not create or write to the spool directory specified in the options.';
    sDefaultSpool = 'default_spool.xml';
function showMsgQueue(bringToFront: boolean=true; dockOverride: string = 'n'): TfrmMsgQueue;
procedure hideMsgQueue();
procedure closeMsgQueue();
function getMsgQueue(): TfrmMsgQueue;
function isMsgQueueShowing(): boolean;
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    DisplayName,
    MsgList, MsgController, ChatWin, ChatController,
    ShellAPI, CommCtrl, GnuGetText,
    JabberID, XMLUtils, XMLParser,
    JabberUtils, ExUtils,  MsgRecv, Session, PrefController,
    RosterImages, EventQueue;

{---------------------------------------}
function showMsgQueue(bringToFront: boolean; dockOverride: string): TfrmMsgQueue;
begin
    Result := getMsgQueue();
    Result.ShowDefault(bringToFront, dockOverride);
    frmExodus.mnuWindows_View_ShowInstantMessages1.Checked := true;
end;

procedure hideMsgQueue();
var
 msgQueue: TfrmMsgQueue;

begin
    msgQueue := getMsgQueue();
    msgQueue.Visible := false;
    frmExodus.mnuWindows_View_ShowInstantMessages1.Checked := false;
end;

procedure closeMsgQueue();
begin
    if frmMsgQueue <> nil then
      frmMsgQueue.Close();
end;
{---------------------------------------}
function getMsgQueue(): TfrmMsgQueue;
begin
    if frmMsgQueue = nil then
        frmMsgQueue := TfrmMsgQueue.Create(Application);
    Result := frmMsgQueue;
end;

function isMsgQueueShowing(): boolean;
begin
    Result := (frmMsgQueue <> nil) and frmMsgQueue.Visible;
end;

class procedure TfrmMsgQueue.AutoOpenFactory(autoOpenInfo: TXMLTag);
begin
    getMsgQueue(); //open but don't bring to front
    showMsgQueue(false);
end;

function TfrmMsgQueue.GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;
begin
    if (event = 'shutdown') then begin
        Result := TXMLtag.Create(Self.ClassName);
        useProfile := false;
    end
    else Result := inherited GetAutoOpenInfo(event, useProfile);
end;

function TfrmMsgQueue.GetEventCount() : integer;
begin
 if (lstEvents <> nil) then
   Result := lstEvents.Items.Count
 else
   Result := 0;
end;

procedure TfrmMsgQueue.SetEventCount(count: integer);
begin
 if (lstEvents <> nil) then
   lstEvents.Items.Count := count;
end;
{---------------------------------------}
procedure TfrmMsgQueue.FormCreate(Sender: TObject);
var
    tmp: integer;
begin
    inherited;

    _updateCB := CB_UNASSIGNED;

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
    
    lstEvents.Items.Count := MainSession.EventQueue.Count;

    _updateCB   := MainSession.RegisterCallback(SessionCallback, SE_UPDATE);
    ImageIndex := RosterImages.RI_NEWSITEM_INDEX;

    _windowType := 'msg_queue';
end;

{---------------------------------------}
procedure TfrmMsgQueue.SessionCallback(event: string; tag: TXMLTag);
begin
  if (event = SE_UPDATE) then begin
    EventCount := MainSession.EventQueue.Count;
    if (MainSession.EventQueue.Count = 0) then begin
        lstEvents.Items.Clear();
        txtMsg.WideLines.Clear();
    end;
  end;
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
        e := TJabberEvent(MainSession.EventQueue[Item.Index]);
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
    e := TJabberEvent(MainSession.EventQueue[lstEvents.Selected.Index]);
    if (e.eType = evt_Chat) then begin
        // startChat will automatically play the queue of msgs
        StartChat(e.from_jid.jid, e.from_jid.resource, true);
    end else begin
        StartRecvMsg(e);
        RemoveItem(lstEvents.Selected.Index);
    end;
end;

{---------------------------------------}
procedure TfrmMsgQueue.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   if (_updateCB <>CB_UNASSIGNED) then
       MainSession.UnRegisterCallback(_updateCB);
    Action := caFree;
    frmMsgQueue := nil;
    frmExodus.mnuWindows_View_ShowInstantMessages1.Checked := false;
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

    MainSession.EventQueue.Clear(); //frees references
    lstEvents.items.Clear();
    txtMsg.Clear();
end;

{---------------------------------------}
procedure TfrmMsgQueue.RemoveItem(i: integer);
begin
    MainSession.EventQueue.Delete(i); //frees reference
    lstEvents.Items.Count := MainSession.EventQueue.Count;
    if (MainSession.EventQueue.Count = 0) then begin
        lstEvents.Items.Clear();
        txtMsg.WideLines.Clear();
    end;
    MainSession.EventQueue.SaveEvents();
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
                MainSession.EventQueue.Delete(i); //frees reference
                lstEvents.Items.Count := lstEvents.Items.Count - 1;
                first := i;
            end;
        end;
        MainSession.EventQueue.SaveEvents();
        lstEvents.ClearSelection();
    end;

    if ((first <> -1) and (first < lstEvents.Items.Count)) then begin
        lstEvents.ItemIndex := first;
        e := TJabberEvent(MainSession.EventQueue[first]); //e is reference
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
    if (item.index >= MainSession.EventQueue.Count) then
        exit;

    e := TJabberEvent(MainSession.EventQueue[item.Index]);

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


initialization
    Classes.RegisterClass(TfrmMsgQueue);

end.
