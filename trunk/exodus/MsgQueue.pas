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
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lstEventsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstEventsDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstEventsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LogEvent(e: TJabberEvent; msg: string; img_idx: integer);
  end;

var
  frmMsgQueue: TfrmMsgQueue;

function getMsgQueue: TfrmMsgQueue;

implementation

{$R *.dfm}

uses
    ExUtils, MsgRecv, Session, PrefController;

function getMsgQueue: TfrmMsgQueue;
begin
    if frmMsgQueue = nil then begin
        frmMsgQueue := TfrmMsgQueue.Create(nil);
        end;

    Result := frmMsgQueue;
end;

procedure TfrmMsgQueue.LogEvent(e: TJabberEvent; msg: string; img_idx: integer);
var
    item: TListItem;
begin
    // display this item
    item := lstEvents.Items.Add;
    item.Caption := e.from;
    item.Data := e;
    item.ImageIndex := img_idx;
    item.SubItems.Add(DateTimeToStr(e.edate));
    item.SubItems.Add(msg);         // Subject
end;

procedure TfrmMsgQueue.FormCreate(Sender: TObject);
begin
    inherited;

    MainSession.Prefs.RestorePosition(Self);

    lstEvents.Color := TColor(MainSession.Prefs.getInt('roster_bg'));
    txtMsg.Color := lstEvents.Color;

    AssignDefaultFont(lstEvents.Font);
    AssignDefaultFont(txtMsg.Font);
end;

procedure TfrmMsgQueue.FormResize(Sender: TObject);
begin
    inherited;

    MainSession.prefs.SavePosition(Self);
end;

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

procedure TfrmMsgQueue.lstEventsDblClick(Sender: TObject);
var
    e: TJabberEvent;
begin
    if (lstEvents.SelCount <= 0) then exit;

    e := TJabberEvent(lstEvents.Selected.Data);
    ShowEvent(e);
end;

procedure TfrmMsgQueue.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
    frmMsgQueue := nil;

    inherited;
end;

procedure TfrmMsgQueue.lstEventsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    i: integer;
begin
    // pickup hot-keys on the list view..
    case Key of
    VK_DELETE, VK_BACK, Ord('d'), Ord('D'): begin
        // delete the selected item
        if lstEvents.Selected <> nil then begin
            i := lstEvents.Selected.Index;
            lstEvents.Items.Delete(i);
            if (i < lstEvents.Items.Count) then
                lstEvents.Selected := lstEvents.Items[i]
            else if (lstEvents.Items.Count > 0) then
                lstEvents.Selected := lstEvents.Items[lstEvents.Items.Count - 1];
            end;
        Key := $0;
        end;
    end;

end;

procedure TfrmMsgQueue.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    inherited;
    
    lstEvents.Items.Clear;
end;

end.
