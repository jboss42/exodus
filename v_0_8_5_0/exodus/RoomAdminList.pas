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
    XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, buttonFrame, StdCtrls, ExtCtrls, CheckLst, ComCtrls;

type
  TfrmRoomAdminList = class(TForm)
    frameButtons1: TframeButtons;
    Splitter1: TSplitter;
    Label1: TLabel;
    memNew: TMemo;
    lstItems: TListView;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  published
    procedure listAdminCallback(event: string; tag: TXMLTag);
  private
    { Private declarations }
    room_jid: Widestring;
    role: bool;
    onList: Widestring;
    offList: Widestring;
  public
    { Public declarations }
    procedure Start();
  end;

var
  frmRoomAdminList: TfrmRoomAdminList;

procedure ShowRoomAdminList(room_jid, role, affiliation: WideString;
    caption: WideString = '');

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    GnuGetText, IQ, JabberConst, JabberID, Session, Room;

{$R *.dfm}

{---------------------------------------}
procedure ShowRoomAdminList(room_jid, role, affiliation: WideString;
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
    iq: TJabberIQ;
    item: TXMLTag;
begin
    // Get the list to be edited
    iq := TJabberIQ.Create(MainSession, MainSession.generateID(),
        listAdminCallback, 30);
    with iq do begin
        toJid := room_jid;
        if ((onList = MUC_ADMIN) or (onList = MUC_OWNER)) then
            Namespace := XMLNS_MUCOWNER
        else
            Namespace := XMLNS_MUCADMIN;
        iqType := 'get';
    end;

    item := iq.qTag.AddTag('item');
    if (role) then
        item.setAttribute('role', onList)
    else
        item.setAttribute('affiliation', onList);
    iq.Send();

    Show();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.listAdminCallback(event: string; tag: TXMLTag);
var
    li: TListItem;
    i: integer;
    rjid: WideString;
    items: TXMLTagList;
begin
    // callback for list administration
    if event <> 'xml' then exit;
    if tag = nil then exit;

    if ((tag.Name <> 'iq') or
        (tag.getAttribute('type') = 'error')) then begin
        MessageDlg('There was an error fetching this room list.',
            mtError, [mbOK], 0);
        Self.Close;
        exit;
    end;

    rjid := tag.GetAttribute('from');
    items := tag.QueryXPTags('/iq/query/item');

    room_jid := rjid;

    if (items.Count > 0) then begin
        for i := 0 to items.Count - 1 do begin
            li := lstItems.Items.Add();
            li.Caption := items[i].GetAttribute('nick');
            li.SubItems.Add(items[i].GetAttribute('jid'));
            li.Checked := true;
        end;
    end;

    items.Free();
end;


{---------------------------------------}
procedure TfrmRoomAdminList.frameButtons1btnOKClick(Sender: TObject);
var
    i: integer;
    tmps: Widestring;
    item, q, iq: TXMLTag;
    li: TListItem;
begin
    // submit the new list
    iq := TXMLTag.Create('iq');
    iq.setAttribute('to', room_jid);
    iq.setAttribute('id', MainSession.generateID());
    iq.setAttribute('type', 'set');
    q := iq.AddTag('query');
    q.setAttribute('xmlns', XMLNS_MUCADMIN);

    // Take the unchecked items off the list
    for i := 0 to lstItems.Items.Count - 1 do begin
        li := lstItems.Items[i];
        if (not li.Checked) then begin
            item := q.AddTag('item');
            item.setAttribute('jid', li.SubItems[0]);
            if (role) then
                item.setAttribute('role', offList)
            else
                item.setAttribute('affiliation', offList);
        end;
    end;

    // Add the following jids to the list.
    for i := 0 to memNew.Lines.Count - 1 do begin
        tmps := Trim(memNew.Lines[i]);
        if ((tmps <> '') and (isValidJID(tmps))) then begin
            item := q.AddTag('item');
            item.setAttribute('jid', tmps);
            if (role) then
                item.setAttribute('role', onList)
            else
                item.setAttribute('affiliation', onList);
        end;
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
    TranslateProperties(Self);
    Action := caFree;
end;

end.
