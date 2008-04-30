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

unit COMExodusItemWrapper;

interface

uses Exodus_TLB, COMExodusItem;

type
{
   This purpose of this class is to hold the reference to
   IExodusItem interface.
   When TExodusItem is created it's reference count is 0. Without
   having anything reference TExodusItem it will eventually get releasedd
   Having a wrapper that holds the reference to IExodusItem will
   gurantee that TExodusItem will not get released until reference to
   it is set to nil. 
}
   TExodusItemWrapper = class
   private
       _Item: IExodusItem;
       _Callback: IExodusItemCallback;
       _Pending: Boolean;
   public
       constructor Create(ctrl: IExodusItemController;
            Uid: WideString;
            Type_: WideString;
            cb: IExodusItemCallback);overload;
       destructor Destroy(); override;

       property ExodusItem: IExodusItem read _Item;
       property Callback: IExodusItemCallback read _Callback;
       property Pending: Boolean read _Pending write _Pending;
   end;

implementation

{---------------------------------------}
constructor TExodusItemWrapper.Create(ctrl: IExodusItemController;
        Uid: WideString;
        Type_: WideString;
        cb: IExodusItemCallback);
begin
    _Item := TExodusItem.Create(ctrl, Uid, Type_, cb);
    _Callback := cb;
end;

{---------------------------------------}
destructor TExodusItemWrapper.Destroy();
begin
    _Item := nil;
    
    inherited;
end;

end.
