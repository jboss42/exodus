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
    Jabber1, ExEvents,  
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Dockable, ComCtrls, StdCtrls, ExtCtrls, ToolWin;

type
  TfrmMsgQueue = class(TfrmDockable)
    lstEvents: TListView;
    Splitter1: TSplitter;
    txtMsg: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure lstEventsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstEventsDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstEventsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    procedure SaveEvents(exclude: TListItem = nil);
    procedure LoadEvents();
  public
    { Public declarations }
    procedure LogEvent(e: TJabberEvent; msg: string; img_idx: integer);
  end;

var
  frmMsgQueue: TfrmMsgQueue;

function getMsgQueue: TfrmMsgQueue;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
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
    item: TListItem;
begin
    // display this item
    item := lstEvents.Items.Add;

    tmp_jid := TJabberID.Create(e.from);
    ritem := MainSession.roster.Find(tmp_jid.jid);
    if (ritem = nil) then
        ritem := MainSession.roster.Find(tmp_jid.full);
    tmp_jid.Free();

    if (ritem <> nil) then
        item.Caption := ritem.nickname
    else
        item.Caption := e.from;
    item.Data := e;
    item.ImageIndex := img_idx;
    item.SubItems.Add(DateTimeToStr(e.edate));
    item.SubItems.Add(msg);         // Subject

    SaveEvents();
end;

{---------------------------------------}
procedure TfrmMsgQueue.SaveEvents(exclude: TListItem = nil);
var
    i,d: integer;
    itm: TListItem;
    fn: string;
    s, e: TXMLTag;
    event: TJabberEvent;
    ss: TStringList;
begin
    // save all of the events in the listview out to a file

    fn := ExtractFilePath(Application.EXEName) + 'spool.xml';

    s := TXMLTag.Create('spool');
    for i := 0 to lstEvents.Items.Count - 1 do begin
        itm := lstEvents.Items[i];
        if (itm <> exclude) then begin
            event := TJabberEvent(itm.Data);
            e := s.AddTag('event');
            with e do begin
                e.PutAttribute('img', IntToStr(itm.ImageIndex));
                e.PutAttribute('caption', itm.Caption);
                e.PutAttribute('msg', itm.SubItems[1]);
                e.PutAttribute('timestamp', DateTimeToStr(event.Timestamp));
                e.PutAttribute('edate', DateTimeToStr(event.edate));
                e.PutAttribute('elapsed_time', IntToStr(event.elapsed_time));
                e.PutAttribute('etype', IntToStr(integer(event.eType)));
                e.PutAttribute('from', event.from);
                e.PutAttribute('id', event.id);
                e.PutAttribute('data_type', event.data_type);
                for d := 0 to event.Data.Count - 1 do
                    e.AddBasicTag('data', event.Data.Strings[d]);
                end;
            end;
        end;

    ss := TStringlist.Create();
    ss.Add(s.xml);
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
    itm: TListItem;
    fn: string;
begin
    // Load events from the spool file
    fn := ExtractFilePath(Application.EXEName) + 'spool.xml';

    if (not FileExists(fn)) then exit;

    p := TXMLTagParser.Create();
    p.ParseFile(fn);

    if p.Count > 0 then begin
        s := p.popTag();
        etags := s.ChildTags();

        for i := 0 to etags.Count - 1 do begin
            cur_e := etags[i];
            e := TJabberEvent.Create();
            itm := lstEvents.Items.Add();
            e.eType := TJabberEventType(SafeInt(cur_e.GetAttribute('etype')));
            e.from := cur_e.GetAttribute('from');
            e.id := cur_e.GetAttribute('id');
            e.Timestamp := StrToDateTime(cur_e.GetAttribute('timestamp'));
            e.edate := StrToDateTime(cur_e.GetAttribute('edate'));
            e.data_type := cur_e.GetAttribute('date_type');
            e.elapsed_time := SafeInt(cur_e.GetAttribute('elapsed_time'));

            itm.ImageIndex := SafeInt(cur_e.GetAttribute('img'));
            itm.Caption := cur_e.GetAttribute('caption');
            itm.SubItems.Add(DateTimeToStr(e.edate));
            itm.SubItems.Add(cur_e.GetAttribute('msg'));

            dtags := cur_e.QueryTags('data');
            for d := 0 to dtags.Count - 1 do
                e.Data.Add(dtags[d].Data);

            itm.Data := e;
            end;
        end;

    p.Free();

end;


{---------------------------------------}
procedure TfrmMsgQueue.FormCreate(Sender: TObject);
begin
    inherited;

    lstEvents.Color := TColor(MainSession.Prefs.getInt('roster_bg'));
    txtMsg.Color := lstEvents.Color;

    AssignDefaultFont(lstEvents.Font);
    AssignDefaultFont(txtMsg.Font);

    Self.LoadEvents();
end;

{---------------------------------------}
procedure TfrmMsgQueue.lstEventsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
    e: TJabberEvent;
begin
    e := TJabberEvent(Item.Data);
    if (lstEvents.SelCount <= 0) then
        txtMsg.Lines.Clear
    else if ((e <> nil) and (lstEvents.SelCount = 1)) then
        txtMsg.Lines.Assign(e.Data);
end;

{---------------------------------------}
procedure TfrmMsgQueue.lstEventsDblClick(Sender: TObject);
var
    e: TJabberEvent;
begin
    if (lstEvents.SelCount <= 0) then exit;

    e := TJabberEvent(lstEvents.Selected.Data);
    ShowEvent(e);
end;

{---------------------------------------}
procedure TfrmMsgQueue.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
    frmMsgQueue := nil;

    inherited;
end;

{---------------------------------------}
procedure TfrmMsgQueue.lstEventsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    i: integer;
    first : integer;
    item : TListItem;
begin
    // pickup hot-keys on the list view..
    case Key of
    VK_DELETE, VK_BACK, Ord('d'), Ord('D'): begin
        Key := $0;
        first := -1;
        if (lstEvents.SelCount = 0) then begin
            exit;
            end
        else if (lstEvents.SelCount = 1) then begin
            item := lstEvents.Selected;
            i := item.Index;
            first := i;
            lstEvents.Items.Delete(i);
            Self.SaveEvents();
            end
        else begin
            for i := lstEvents.Items.Count-1 downto 0 do begin
                if (lstEvents.Items[i].Selected) then begin
                    lstEvents.Items.Delete(i);
                    first := i;
                    end;
                end;
            Self.SaveEvents();
            end;

        if (first < lstEvents.Items.Count) then
            lstEvents.Selected := lstEvents.Items[first]
        else if (lstEvents.Items.Count > 0) then
            lstEvents.Selected := lstEvents.Items[lstEvents.Items.Count - 1];
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

end.
