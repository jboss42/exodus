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

unit ExContactsTreeView;

interface

uses ExTreeView, Exodus_TLB, ExActions;


type
   TSendContactsAction = class(TExBaseAction)
   private
       constructor Create();

   public
       procedure execute(const items: IExodusItemList); override;
   end;

   TExContactsTreeView = class(TExTreeView)

   protected
       function  FilterItem(Item: IExodusItem): Boolean; override;
   end;

   procedure RegisterActions();

implementation

uses Classes, COMExodusItem, ExUtils, ExActionCtrl, gnugettext, SelectItem, Unicode;

{---------------------------------------}
function  TExContactsTreeView.FilterItem(Item: IExodusItem): Boolean;
begin
    if (Item.Type_= EI_TYPE_CONTACT) then
        Result := true
    else
        Result := false;
end;

constructor TSendContactsAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-060-send-contacts');

    Set_Caption(_('Send contacts to...'));
    Set_Enabled(true);
end;

procedure TSendContactsAction.execute(const items: IExodusItemList);
var
    idx: Integer;
    item: IExodusItem;
    subjects: TList;
    target: Widestring;
begin

    target := SelectUIDByType('contact');
    if (target <> '') then begin
        subjects := TList.Create;

        for idx := 0 to items.Count - 1 do begin
            item := items.Item[idx];
            subjects.Add(Pointer(item));
        end;

        jabberSendRosterItems(target, subjects);
    end;
end;

procedure RegisterActions();
var
    actCtrl: IExodusActionController;
begin
    actCtrl := GetActionController();
    actCtrl.registerAction('contact', TSendContactsAction.Create() as IExodusAction);
end;

initialization
    RegisterActions();
    
end.





