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
    Jabber1, ExEvents, Contnrs, Unicode, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Dockable, ComCtrls, StdCtrls, ExtCtrls, ToolWin, RichEdit2,
    ExRichEdit, Menus;

type
  TfrmMsgQueue = class(TfrmDockable)
    lstEvents: TListView;
    Splitter1: TSplitter;
    txtMsg: TExRichEdit;
    PopupMenu1: TPopupMenu;
    D1: TMenuItem;
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
  private
    { Private declarations }
    _queue: TObjectList;
    procedure SaveEvents();
    procedure LoadEvents();
    procedure removeItems();

    function FindColumnIndex(pHeader: pNMHdr): integer;
    function FindColumnWidth(pHeader: pNMHdr): integer;

  protected
    procedure WMNotify(var Msg: TWMNotify); message WM_NOTIFY;

  public
    { Public declarations }
    procedure LogEvent(e: TJabberEvent; msg: string; img_idx: integer);
    procedure RemoveItem(i: integer);
  end;

var
  frmMsgQueue: TfrmMsgQueue;

resourcestring
    sNoSpoolDir = 'Exodus could not create or write to the spool directory specified in the options.';

function getMsgQueue: TfrmMsgQueue;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    ShellAPI, CommCtrl,  
    Roster, JabberID, XMLUtils, XMLParser, XMLTag,
    ExUtils, MsgRecv, Session, PrefController;

{---------------------------------------}
function getMsgQueue: TfrmMsgQueue;
begin
    if frmMsgQueue = nil then begin
        frmMsgQueue := TfrmMsgQueue.Create(Application);
    end;

    Result := frmMsgQueue;
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
    tmp_jid.Free();

    if (ritem <> nil) then
        e.Caption := ritem.nickname
    else
        e.Caption := e.from;

    // NB: _queue now owns e... it needs to free it, etc.
    _queue.Add(e);
    lstEvents.Items.Count := lstEvents.Items.Count + 1;
    SaveEvents();
end;

{---------------------------------------}
procedure TfrmMsgQueue.SaveEvents();
var
    i,d: integer;
    dir, fn: string;
    s, e: TXMLTag;
    event: TJabberEvent;
    ss: TStringList;
begin
    // save all of the events in the listview out to a file
    // fn := ExtractFilePath(Application.EXEName) + 'spool.xml';
    // fn := getUserDir() + 'spool.xml';
    if (MainSession = nil) then exit;
    
    fn := MainSession.Prefs.getString('spool_path');
    dir := ExtractFilePath(fn);

    if (not DirectoryExists(dir)) then begin
        MkDir(dir);
        if (not DirectoryExists(dir)) then begin
            MessageDlg(sNoSpoolDir, mtError, [mbOK], 0);
            exit;
        end;
    end;

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
            e.setAttribute('data_type', event.data_type);
            for d := 0 to event.Data.Count - 1 do
                e.AddBasicTag('data', event.Data.Strings[d]);
        end;
    end;

    ss := TStringlist.Create();
    ss.Add(UTF8Encode(s.xml));
    ss.SaveToFile(fn);
    ss.Free();
    s.Free();
end;

{---------------------------------------}
procedure TfrmMsgQueue.LoadEvents();
var
    i,d: integer;
    p: TXMLTagParser;
    cur_e, s: TXMLTag;
    dtags, etags: TXMLTagList;
    e: TJabberEvent;
    fn: string;
begin
    // Load events from the spool file
    // fn := ExtractFilePath(Application.EXEName) + 'spool.xml';
    // fn := getUserDir() + 'spool.xml';
    fn := MainSession.Prefs.getString('spool_path');

    if (not FileExists(fn)) then exit;

    p := TXMLTagParser.Create();
    p.ParseFile(fn);

    if p.Count > 0 then begin
        s := p.popTag();
        etags := s.ChildTags();

        for i := 0 to etags.Count - 1 do begin
            cur_e := etags[i];
            e := TJabberEvent.Create();
            _queue.Add(e);
            e.eType := TJabberEventType(SafeInt(cur_e.GetAttribute('etype')));
            e.from := cur_e.GetAttribute('from');
            e.id := cur_e.GetAttribute('id');
            e.Timestamp := StrToDateTime(cur_e.GetAttribute('timestamp'));
            e.edate := StrToDateTime(cur_e.GetAttribute('edate'));
            e.data_type := cur_e.GetAttribute('date_type');
            e.elapsed_time := SafeInt(cur_e.GetAttribute('elapsed_time'));
            e.msg := cur_e.GetAttribute('msg');
            e.caption := cur_e.GetAttribute('caption');
            e.img_idx := SafeInt(cur_e.GetAttribute('img'));

            lstEvents.Items.Count := lstEvents.Items.Count + 1;

            dtags := cur_e.QueryTags('data');
            for d := 0 to dtags.Count - 1 do
                e.Data.Add(dtags[d].Data);
            dtags.Free();

        end;
        etags.Free();
        s.Free();
    end;
    p.Free();
end;


{---------------------------------------}
procedure TfrmMsgQueue.FormCreate(Sender: TObject);
var
    tmp: integer;
begin
    inherited;

    _queue := TObjectList.Create();
    _queue.OwnsObjects := true;

    lstEvents.Color := TColor(MainSession.Prefs.getInt('roster_bg'));
    txtMsg.Color := lstEvents.Color;

    AssignDefaultFont(lstEvents.Font);
    AssignDefaultFont(txtMsg.Font);

    with lstEvents do begin
        tmp := MainSession.Prefs.getInt('quecol_1');
        if (tmp <> 0) then Column[0].Width := tmp;
        tmp := MainSession.Prefs.getInt('quecol_2');
        if (tmp <> 0) then Column[1].Width := tmp;
        tmp := MainSession.Prefs.getInt('quecol_3');
        if (tmp <> 0) then Column[2].Width := tmp;
    end;

    Self.LoadEvents();
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
    if (lstEvents.SelCount <= 0) then
        txtMsg.WideLines.Clear
    else begin
        e := TJabberEvent(_queue[lstEvents.Selected.Index]);
        if ((e <> nil) and (lstEvents.SelCount = 1) and (e.Data.Text <> '')) then
            txtMsg.WideText := e.Data.Text;
    end;
end;

{---------------------------------------}
procedure TfrmMsgQueue.lstEventsDblClick(Sender: TObject);
var
    e, edup: TJabberEvent;
begin
    if (lstEvents.SelCount <= 0) then exit;
    if (MainSession = nil) then exit;
    if (not MainSession.Active) then exit;
    
    e := TJabberEvent(_queue.Items[lstEvents.Selected.Index]);
    edup := TJabberEvent.Create(e);
    StartRecvMsg(edup);
end;

{---------------------------------------}
procedure TfrmMsgQueue.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    _queue.Free();
    Action := caFree;
    frmMsgQueue := nil;
    inherited;
end;

{---------------------------------------}
procedure TfrmMsgQueue.RemoveItem(i: integer);
begin
    _queue.Delete(i);
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
                _queue.Delete(i);
                lstEvents.Items.Count := lstEvents.Items.Count - 1;
                first := i;
            end;
        end;
        Self.SaveEvents();
        lstEvents.ClearSelection();
    end;

    if ((first <> -1) and (first < lstEvents.Items.Count)) then begin
        lstEvents.Selected := lstEvents.Items[first];
        e := TJabberEvent(_queue[first]);
        if ((e <> nil) and (lstEvents.SelCount = 1) and (e.Data.Text <> '')) then
            txtMsg.WideText := e.Data.Text;
    end
    else if (lstEvents.Items.Count > 0) then
        lstEvents.Selected := lstEvents.Items[lstEvents.Items.Count - 1];

    if (lstEvents.Selected <> nil) then begin
        lstEvents.Selected.MakeVisible(false);
        lstEvents.ItemFocused := lstEvents.Selected;
    end;

    lstEvents.Refresh;
end;

{---------------------------------------}
procedure TfrmMsgQueue.lstEventsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    // pickup hot-keys on the list view..
    case Key of
    VK_DELETE, VK_BACK, Ord('d'), Ord('D'): begin
        Key := $0;
        removeItems();
    end;
    end;

end;

{---------------------------------------}
procedure TfrmMsgQueue.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    inherited;
    if (MainSession = nil) then
        lstEvents.Items.Clear
    else if (MainSession.prefs.getBool('expanded')) and (not Docked) then begin
        CanClose := false;
        exit;
    end
    else
        lstEvents.Items.Clear;
end;

{---------------------------------------}
procedure TfrmMsgQueue.lstEventsData(Sender: TObject; Item: TListItem);
var
    e: TJabberEvent;
begin
  inherited;
    e := TJabberEvent(_queue[item.Index]);

    item.Caption := e.caption;
    item.ImageIndex := e.img_idx;
    item.SubItems.Add(DateTimeToStr(e.edate));
    item.SubItems.Add(e.msg);         // Subject
end;

{---------------------------------------}
procedure TfrmMsgQueue.txtMsgURLClick(Sender: TObject; URL: String);
begin
  inherited;
    ShellExecute(0, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

{---------------------------------------}
procedure TfrmMsgQueue.D1Click(Sender: TObject);
begin
  inherited;
    removeItems();
end;

end.
