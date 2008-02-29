unit ExRoomsTreeView;

interface

uses ExTreeView, Exodus_TLB;


type
   TExRoomsTreeView = class(TExTreeView)

   protected
       function  FilterItem(Item: IExodusItem): Boolean; override;
   end;

implementation

uses COMExodusItem;

function  TExRoomsTreeView.FilterItem(Item: IExodusItem): Boolean;
begin
    if (Item.Type_= EI_TYPE_ROOM) then
        Result := true
    else
        Result := false;
end;
end.


