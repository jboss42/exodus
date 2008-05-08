unit COMRosterItem;
{
    Copyright 2003, Peter Millard

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

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ContactController, ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusRosterItem = class(TAutoObject, IExodusRosterItem)
  protected
    function Get_JabberID: WideString; safecall;
    procedure Set_JabberID(const Value: WideString); safecall;
    function Get_Subscription: WideString; safecall;
    procedure Set_Subscription(const Value: WideString); safecall;
    function Get_Ask: WideString; safecall;
    function Get_GroupCount: Integer; safecall;
    function Group(Index: Integer): WideString; safecall;
    function Get_Nickname: WideString; safecall;
    function Get_RawNickname: WideString; safecall;
    function XML: WideString; safecall;
    procedure Remove; safecall;
    procedure Set_Nickname(const Value: WideString); safecall;
    procedure Update; safecall;
    function Get_ContextMenuID: WideString; safecall;
    procedure Set_ContextMenuID(const Value: WideString); safecall;
    function Get_Action: WideString; safecall;
    function Get_ImageIndex: Integer; safecall;
    function Get_InlineEdit: WordBool; safecall;
    function Get_Status: WideString; safecall;
    function Get_Tooltip: WideString; safecall;
    procedure Set_Action(const Value: WideString); safecall;
    procedure Set_ImageIndex(Value: Integer); safecall;
    procedure Set_InlineEdit(Value: WordBool); safecall;
    procedure Set_Status(const Value: WideString); safecall;
    procedure Set_Tooltip(const Value: WideString); safecall;
    procedure fireChange; safecall;
    function Get_IsContact: WordBool; safecall;
    procedure Set_IsContact(Value: WordBool); safecall;
    procedure addGroup(const grp: WideString); safecall;
    procedure removeGroup(const grp: WideString); safecall;
    procedure setCleanGroups; safecall;
    function Get_ImagePrefix: WideString; safecall;
    procedure Set_ImagePrefix(const Value: WideString); safecall;
    function Get_CanOffline: WordBool; safecall;
    function Get_IsNative: WordBool; safecall;
    procedure Set_CanOffline(Value: WordBool); safecall;
    procedure Set_IsNative(Value: WordBool); safecall;
    { Protected declarations }
  private
    //_ritem: TJabberRosterItem;
    _menu_id: Widestring;
    
  public
    //constructor Create(ritem: TJabberRosterItem);
    constructor Create();
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    TntMenus, Menus, ExSession, COMRoster, Session, JabberID, ComServ;

{---------------------------------------}
constructor TExodusRosterItem.Create();
begin
    // this is just a wrapper for the roster item
    //_ritem := ritem;
    _menu_id := '';
end;

{---------------------------------------}
function TExodusRosterItem.Get_JabberID: WideString;
begin
    //Result := _ritem.jid.full();
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_JabberID(const Value: WideString);
begin
    // XXX: remove Set_JabberID from the interface
    {
    if (_ritem.jid <> nil) then
        _ritem.jid.Free();

    _ritem.setJid(value);
    }
end;

{---------------------------------------}
function TExodusRosterItem.Get_Subscription: WideString;
begin
    //Result := _ritem.subscription;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_Subscription(const Value: WideString);
begin
    //_ritem.Tag.setAttribute('subscription', value);
end;

{---------------------------------------}
function TExodusRosterItem.Get_Ask: WideString;
begin
    //Result := _ritem.ask;
end;

{---------------------------------------}
function TExodusRosterItem.Get_GroupCount: Integer;
begin
    //Result := _ritem.GroupCount;
end;

{---------------------------------------}
function TExodusRosterItem.Group(Index: Integer): WideString;
begin
//    if ((index >= 0) and (Index < _ritem.GroupCount)) then
//        Result := _ritem.Group[Index]
//    else
//        Result := '';
end;

{---------------------------------------}
function TExodusRosterItem.Get_Nickname: WideString;
begin
   // Result := _ritem.Text;
end;

{---------------------------------------}
function TExodusRosterItem.Get_RawNickname: WideString;
begin
  //  Result := _ritem.Text;
end;

{---------------------------------------}
function TExodusRosterItem.XML: WideString;
begin
    //Result := _ritem.Tag.xml();
end;

{---------------------------------------}
procedure TExodusRosterItem.Remove;
begin
   // _ritem.remove();
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_Nickname(const Value: WideString);
begin
   // _ritem.Text := Value;
end;

{---------------------------------------}
procedure TExodusRosterItem.Update;
begin
  //  _ritem.update();
end;

{---------------------------------------}
function TExodusRosterItem.Get_ContextMenuID: WideString;
begin
    Result := _menu_id;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_ContextMenuID(const Value: WideString);
var
    menu: TTntPopupMenu;
begin
    menu := ExCOMRoster.findContextMenu(value);
    if (menu <> nil) then begin
        _menu_id := Value;
       // _ritem.CustomContext := menu;
    end;
end;

{---------------------------------------}
function TExodusRosterItem.Get_Action: WideString;
begin
   // Result := _ritem.Action;
end;

{---------------------------------------}
function TExodusRosterItem.Get_ImageIndex: Integer;
begin
  //  Result := _ritem.ImageIndex;
end;

{---------------------------------------}
function TExodusRosterItem.Get_InlineEdit: WordBool;
begin
   // Result := _ritem.InlineEdit;
end;

{---------------------------------------}
function TExodusRosterItem.Get_Status: WideString;
begin
   // Result := _ritem.Status;
end;

{---------------------------------------}
function TExodusRosterItem.Get_Tooltip: WideString;
begin
   // Result := _ritem.Tooltip;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_Action(const Value: WideString);
begin
  //  _ritem.Action := Value;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_ImageIndex(Value: Integer);
begin
  //  _ritem.ImageIndex := Value;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_InlineEdit(Value: WordBool);
begin
   // _ritem.InlineEdit := Value;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_Status(const Value: WideString);
begin
   // _ritem.Status := Value;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_Tooltip(const Value: WideString);
begin
   // _ritem.Tooltip := Value;
end;

{---------------------------------------}
procedure TExodusRosterItem.fireChange;
begin
    //MainSession.FireEvent('/roster/item', _ritem.tag, _ritem);
end;

{---------------------------------------}
function TExodusRosterItem.Get_IsContact: WordBool;
begin
  //  Result := _ritem.IsContact;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_IsContact(Value: WordBool);
begin
   // _ritem.IsContact := Value;
end;

{---------------------------------------}
procedure TExodusRosterItem.addGroup(const grp: WideString);
begin
    //_ritem.AddGroup(grp);
end;

{---------------------------------------}
procedure TExodusRosterItem.removeGroup(const grp: WideString);
begin
    //_ritem.DelGroup(grp);
end;

{---------------------------------------}
procedure TExodusRosterItem.setCleanGroups;
begin
    //_ritem.SetCleanGroups();
end;

{---------------------------------------}
function TExodusRosterItem.Get_ImagePrefix: WideString;
begin
  //  Result := _ritem.ImagePrefix;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_ImagePrefix(const Value: WideString);
begin
    //_ritem.ImagePrefix := Value;
end;

{---------------------------------------}
function TExodusRosterItem.Get_CanOffline: WordBool;
begin
   //Result := _ritem.CanOffline;
end;

{---------------------------------------}
function TExodusRosterItem.Get_IsNative: WordBool;
begin
    //Result := _ritem.IsNative;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_CanOffline(Value: WordBool);
begin
    //_ritem.CanOffline := Value;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_IsNative(Value: WordBool);
begin
    //_ritem.IsNative := Value;
end;

end.
