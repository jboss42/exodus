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

{---------------------------------------}
function  TExRoomsTreeView.FilterItem(Item: IExodusItem): Boolean;
begin
    if (Item.Type_= EI_TYPE_ROOM) then
        Result := true
    else
        Result := false;
end;
end.


