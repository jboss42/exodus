unit SelectItemRoom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SelectItem, Menus, TntMenus, StdCtrls, TntStdCtrls, ExtCtrls,
  SClrRGrp, TntExtCtrls, ComCtrls, TntComCtrls, Unicode;

type
    TListItemTracker = class
        public
        jid: widestring;
        item: TTntListItem;
    end;

    TfrmSelectItemRoom = class(TfrmSelectItem)
        pnlJoinedRooms: TTntPanel;
        TntSplitter1: TTntSplitter;
        lblJoinedRooms: TTntLabel;
        lstJoinedRooms: TTntListView;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure lstJoinedRoomsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    private
    { Private declarations }
        _trackinglist: TWidestringList;
        _lstJoinedRoomsDefaultColor: TColor;
    public
    { Public declarations }

    end;

function SelectUIDByTypeRoom(title: Widestring = ''; ownerHWND: HWND = 0): Widestring;

var
  frmSelectItemRoom: TfrmSelectItemRoom;

implementation

uses
    Room,
    DisplayName;

{$R *.dfm}

function SelectUIDByTypeRoom(title: Widestring; ownerHWND: HWND): Widestring;
var
    selector: TfrmSelectItemRoom;
begin
    Result := '';
    selector := TfrmSelectItemRoom.Create(nil, 'room', ownerHWND);
    if (title <> '') then
        selector.Caption := title;

    if (selector.ShowModal = mrOk) then begin
        Result := selector.SelectedUID;
    end;

    selector.Free;
end;

procedure TfrmSelectItemRoom.FormCreate(Sender: TObject);
var
    i: integer;
    item: TTntListItem;
    track: TListItemTracker;
begin
    inherited;

    _trackinglist := TWidestringList.Create();

    for i := 0 to room_list.Count - 1 do begin
        item := lstJoinedRooms.Items.Add();
        item.Caption := DisplayName.getDisplayNameCache().getDisplayName(room_list[i]);
        item.ImageIndex := TfrmRoom(room_list.Objects[i]).ImageIndex;

        track := TListItemTracker.Create();
        track.jid := room_list[i];
        track.item := item;
        _trackingList.AddObject(item.caption, track);
    end;


end;

procedure TfrmSelectItemRoom.FormDestroy(Sender: TObject);
var
    track: TListItemTracker;
    i: integer;
begin
    for i := _trackinglist.Count - 1 downto 0 do begin
        track := TListItemTracker(_trackinglist.Objects[i]);
        track.Free();
        _trackinglist.Delete(i);
    end;
    _trackinglist.Free();

    inherited;
end;

procedure TfrmSelectItemRoom.lstJoinedRoomsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var
    i: integer;
    track: TListItemTracker;
    jid: widestring;
begin
    if (_itemView <> nil) then begin
        _itemView.ClearSelection();
    end;

    if (_trackinglist.Find(item.Caption, i)) then begin
        track := TListItemTracker(_trackinglist.Objects[i]);
        jid := track.jid;
        txtJID.text := jid;
        btnOK.Enabled := true;
    end
    else begin
        txtJID.text := '';
        btnOK.Enabled := false;
    end;
end;

end.
