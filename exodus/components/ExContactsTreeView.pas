unit ExContactsTreeView;

interface

uses ExTreeView, Exodus_TLB;


type
   TExContactsTreeView = class(TExTreeView)

   protected
       function  FilterItem(Item: IExodusItem): Boolean; override;
   end;

implementation

uses COMExodusItem;

function  TExContactsTreeView.FilterItem(Item: IExodusItem): Boolean;
begin
    if (Item.Type_= EI_TYPE_CONTACT) then
        Result := true
    else
        Result := false;
end;
end.





