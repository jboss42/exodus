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
  private
    { Private declarations }
    room_jid: Widestring;
    role: bool;
    onList: Widestring;
    offList: Widestring;
  public
    { Public declarations }
  end;

var
  frmRoomAdminList: TfrmRoomAdminList;

procedure ShowRoomAdminList(tag: TXMLTag);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    JabberID, Session, Room;

{$R *.dfm}

{---------------------------------------}
procedure ShowRoomAdminList(tag: TXMLTag);
var
    i: integer;
    f: TfrmRoomAdminList;
    items: TXMLTagList;
    li: TListItem;
    rjid, r,a: WideString;
begin
    //
    if ((tag.Name <> 'iq') or (tag.Namespace <> NS_MUCADMIN)) then
        exit;

    f := TfrmRoomAdminList.Create(Application);
    rjid := tag.GetAttribute('from');
    items := tag.QueryXPTags('/iq/query/item');


    if (items.Count > 0) then with f do begin
        room_jid := rjid;

        // figure out what we're modifying
        r := items[0].GetAttribute('role');
        a := items[0].GetAttribute('affiliation');

        if (a = MUC_MEMBER) then begin
            role := false;
            onList := MUC_MEMBER;
            offList := MUC_NONE;
            end
        else if (a = MUC_OUTCAST) then begin
            role := false;
            onList := MUC_OUTCAST;
            offList := MUC_OUTCAST;
            end
        else if (r = MUC_PART) then begin
            role := true;
            onList := MUC_PART;
            offList := MUC_VISITOR;
            end;

        for i := 0 to items.Count - 1 do begin
            li := lstItems.Items.Add();
            li.Caption := items[i].GetAttribute('nick');
            li.SubItems.Add(items[i].GetAttribute('jid'));
            end;
        end;

    items.Free();
    f.Show();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.frameButtons1btnOKClick(Sender: TObject);
var
    i: integer;
    tmps, v: Widestring;
    item, q, iq: TXMLTag;
    li: TListItem;
begin
    // submit the new list
    iq := TXMLTag.Create('iq');
    iq.PutAttribute('to', room_jid);
    iq.PutAttribute('id', MainSession.generateID());
    iq.PutAttribute('type', 'set');
    q := iq.AddTag('query');
    q.PutAttribute('xmlns', NS_MUCADMIN);

    for i := 0 to lstItems.Items.Count - 1 do begin
        li := lstItems.Items[i];
        item := q.AddTag('item');
        item.PutAttribute('jid', li.SubItems[0]);
        if (li.Checked) then v := onList else v := offList;
        if (role) then
            item.PutAttribute('role', v)
        else
            item.PutAttribute('affiliation', v);
        end;

    for i := 0 to memNew.Lines.Count - 1 do begin
        tmps := Trim(memNew.Lines[i]);
        if ((tmps <> '') and (isValidJID(tmps))) then begin
            item := q.AddTag('item');
            item.PutAttribute('jid', tmps);
            if (role) then
                item.PutAttribute('role', onList)
            else
                item.PutAttribute('affiliation', onList);
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
    Action := caFree;
end;

end.
