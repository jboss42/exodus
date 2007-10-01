unit COMRoster;
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
    Unicode, TntClasses, Menus, TntMenus,
    ComObj, ActiveX, Exodus_TLB, StdVcl, Classes;

type

  TExodusRoster = class(TAutoObject, IExodusRoster, IExodusRoster2)
  protected
    { Protected declarations }
    function addItem(const JabberID: WideString): IExodusRosterItem; safecall;
    function Find(const JabberID: WideString): IExodusRosterItem; safecall;
    procedure Fetch; safecall;
    function Item(Index: Integer): IExodusRosterItem; safecall;
    function Count: Integer; safecall;
    function addGroup(const grp: WideString): IExodusRosterGroup; safecall;
    function Get_GroupsCount: Integer; safecall;
    function getGroup(const grp: WideString): IExodusRosterGroup; safecall;
    function Groups(Index: Integer): IExodusRosterGroup; safecall;
    function Items(Index: Integer): IExodusRosterItem; safecall;
    procedure removeGroup(const grp: IExodusRosterGroup); safecall;
    procedure removeItem(const Item: IExodusRosterItem); safecall;
    function AddContextMenuItem(const menuID, caption: WideString;
      const menuListener: IExodusMenuListener): WideString; safecall;
    function addContextMenu(const id: WideString): WordBool; safecall;
    procedure removeContextMenu(const id: WideString); safecall;
    procedure removeContextMenuItem(const menu_id, item_id: WideString);
      safecall;
    function Subscribe(const JabberID, nickname, Group: WideString;
      Subscribe: WordBool): IExodusRosterItem; safecall;

    // IExodusRoster2
    procedure EnableContextMenuItem(const menuID: WideString; const itemID: WideString;
                                    enable: WordBool); safecall;
    procedure ShowContextMenuItem(const menuID: WideString; const itemID: WideString;
                                  show: WordBool); safecall;
    procedure SetContextMenuItemCaption(const menuID: WideString; const itemID: WideString; 
                                        const caption: WideString); safecall;
    function GetContextMenuItemCaption(const menuID: WideString; const itemID: WideString): WideString; safecall;

  private
    _predefined_menus: TWidestringlist;
    _menus: TWidestringlist;
    _items: Twidestringlist;

  published
    procedure MenuClick(Sender: TObject);

  public
    constructor Create();
    destructor Destroy(); override;

    function findContextMenu(id: Widestring): TTntPopupMenu;
    procedure AddPredefinedMenu(name: Widestring; menu: TTntPopupMenu);
    procedure RemovePredefinedMenu(name: Widestring; menu: TTntPopupMenu);

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    XMLTag, StrUtils, SysUtils, XMLUtils, COMRosterGroup,
    COMRosterItem, NodeItem, Roster, JabberID, Session,
    Jabber1, ComServ,RosterWindow;

{---------------------------------------}
constructor TExodusRoster.Create();
begin
    _predefined_menus := TWidestringlist.Create();
    _menus := TWidestringlist.Create();
    _items := TWidestringlist.Create();
end;

{---------------------------------------}
destructor TExodusRoster.Destroy();
begin
    ClearStringListObjects(_predefined_menus);
    ClearStringListObjects(_items);
    ClearStringListObjects(_menus);
    _items.Clear();
    _items.Free();
    _menus.Clear();
    _menus.Free();
    _predefined_menus.Clear();
    _predefined_menus.Free();
end;

{---------------------------------------}
procedure TExodusRoster.AddPredefinedMenu(name: Widestring; menu: TTntPopupMenu);
var
    idx: integer;
begin
    // used to add the GUI defined menus from RosterWindow.pas
    if (menu = nil) or
       (name = '') then exit;

    idx := _menus.IndexOf(name);
    if (idx >= 0) then exit;

    _predefined_menus.Add(name);
    _menus.AddObject(name, menu);
end;

{---------------------------------------}
procedure TExodusRoster.RemovePredefinedMenu(name: Widestring; menu: TTntPopupMenu);
var
    idx, predefined_idx: integer;
    i: Integer;
    temp_stringlist: TWidestringList;
    temp_string: string;
begin
    if (name = '') then exit;

    idx := _menus.IndexOf(name);
    if (idx >= 0) then begin
        // exists
        predefined_idx := _predefined_menus.IndexOf(name);
        if (predefined_idx >=0) then begin
            // is a predefined so we can remove

            // Make sure there are no items left on menu
            // Not doing this causes a crash if item is left on predefined
            // popup menu.
            if (_items.Count > 0) then begin
                temp_stringlist := TWidestringList.Create();
                for i := 0 to menu.items.Count - 1 do begin
                    temp_string := LeftStr(menu.Items[i].Name, Length('pluginContext_item'));
                    if (temp_string = 'pluginContext_item') then
                        temp_stringlist.Add(menu.Items[i].Name);
                end;
                if (temp_stringlist.Count > 0) then begin
                    for i := 0 to temp_stringlist.Count - 1 do begin
                        Self.removeContextMenuItem(name, temp_stringlist.Strings[i]);
                    end;
                end;
                temp_stringlist.Free();
            end;

            // do actual remove
            _predefined_menus.Delete(predefined_idx);
            _menus.Delete(idx);
        end;
    end;
end;

{---------------------------------------}
procedure TExodusRoster.MenuClick(Sender: TObject);
var
    idx: integer;
{$IFDEF OLD_MENU_EVENTS}
    ri: TJabberRosterItem;
{$ELSE}
    mi : TTnTMenuItem;
    sel: TList;
    resultset, newtag: TXMLTag;
    i: integer;
{$ENDIF}
begin
    idx := _items.IndexOfObject(Sender);
    if (idx >= 0) then begin
{$IFDEF OLD_MENU_EVENTS}
        ri := MainSession.Roster.ActiveItem;
        MainSession.FireEvent(_items[idx], ri.Tag);
{$ELSE}
        mi := TTntMenuItem(_items.Objects[idx]);
        resultset:= TXMLTag.Create('selected_roster_list'); //freed by
        sel := frmRosterWindow.getSelectedContacts(false);
        if (sel.Count > 0) then begin
            for i := 0 to sel.Count - 1 do begin
                newtag := TXMLTag.Create(TJabberRosterItem(sel[i]).Tag);
                resultset.AddTag(newtag);
            end;
            IExodusMenuListener(mi.Tag).OnMenuItemClick(mi.Name, resultset.XML);
        end;
        resultset.Free();
        sel.Free();
{$ENDIF}
    end;
end;

{---------------------------------------}
function TExodusRoster.addItem(
  const JabberID: WideString): IExodusRosterItem;
var
    x: TXMLTag;
    ri: TJabberRosterItem;
begin
    x := TXMLTag.Create('item');
    x.setAttribute('jid', JabberID);
    x.setAttribute('xmlns', 'exodus:plugin-item');
    ri := MainSession.Roster.newItem(JabberID);
    ri.Tag := x;
    
    Result := TExodusRosterItem.Create(ri);
end;

{---------------------------------------}
function TExodusRoster.Subscribe(const JabberID, nickname,
  Group: WideString; Subscribe: WordBool): IExodusRosterItem;
var
    ri: TJabberRosterItem;
begin
    MainSession.roster.AddItem(JabberID, Nickname, Group, Subscribe);
    ri := MainSession.Roster.Find(JabberID);
    if (ri <> nil) then
        Result := TExodusRosterItem.Create(ri)
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusRoster.Find(const JabberID: WideString): IExodusRosterItem;
var
    ri: TJabberRosterItem;
begin
    // Should we be spinning up new COM objects for every item??
    // they should go away via RefCounting.
    ri := MainSession.roster.Find(JabberID);
    if (ri <> nil) then
        Result := TExodusRosterItem.Create(ri)
    else
        Result := nil;
end;

{---------------------------------------}
procedure TExodusRoster.Fetch;
begin
    MainSession.roster.Fetch();
end;

{---------------------------------------}
function TExodusRoster.Item(Index: Integer): IExodusRosterItem;
var
    ri: TJabberRosterItem;
begin
    if ((Index >= 0) and (Index < MainSession.roster.Count)) then
        ri := MainSession.roster.Items[Index]
    else
        ri := nil;

    if (ri <> nil) then
        Result := TExodusRosterItem.Create(ri)
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusRoster.Count: Integer;
begin
    Result := MainSession.roster.Count;
end;

{---------------------------------------}
function TExodusRoster.addGroup(const grp: WideString): IExodusRosterGroup;
var
    go: TJabberGroup;
begin
    go := MainSession.Roster.addGroup(grp);
    Result := TExodusRosterGroup.Create(go);
end;

{---------------------------------------}
function TExodusRoster.Get_GroupsCount: Integer;
begin
    Result := MainSession.Roster.GroupsCount;
end;

{---------------------------------------}
function TExodusRoster.getGroup(const grp: WideString): IExodusRosterGroup;
var
    go: TJabberGroup;
begin
    go := MainSession.Roster.getGroup(grp);
    if (go <> nil) then
        Result := TExodusRosterGroup.Create(go)
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusRoster.Groups(Index: Integer): IExodusRosterGroup;
var
    go: TJabberGroup;
begin
    go := MainSession.Roster.Groups[Index];
    Result := TExodusRosterGroup.Create(go);
end;

{---------------------------------------}
function TExodusRoster.Items(Index: Integer): IExodusRosterItem;
var
    ri: TJabberRosterItem;
begin
    ri := MainSession.Roster.Items[index];
    Result := TExodusRosterItem.Create(ri);
end;

{---------------------------------------}
procedure TExodusRoster.removeGroup(const grp: IExodusRosterGroup);
var
    go: TJabberGroup;
begin
    go := MainSession.Roster.getGroup(grp.FullName);
    if (go <> nil) then
        MainSession.roster.removeGroup(go);
end;

{---------------------------------------}
procedure TExodusRoster.removeItem(const Item: IExodusRosterItem);
begin
    MainSession.Roster.RemoveItem(Item.JabberID);
end;

{---------------------------------------}
function TExodusRoster.AddContextMenuItem(const menuID, caption: WideString;
  const menuListener: IExodusMenuListener): WideString;
var
    midx: integer;
    menu: TTntPopupMenu;
    mi: TTntMenuItem;
    g: TGUID;
    guid: string;
begin
    Result := '';
    midx := _menus.IndexOf(menuID);
    if (midx = -1) then exit;

    menu := TTntPopupMenu(_menus.Objects[midx]);

    CreateGUID(g);
    guid := GUIDToString(g);
    guid := AnsiMidStr(guid, 2, length(guid) - 2);
    guid := AnsiReplaceStr(guid, '-', '_');
    mi := TTntMenuItem.Create(menu);
    mi.Name := 'pluginContext_item_' + guid;
    mi.Caption := caption;
    mi.OnClick := Self.MenuClick;
    mi.Tag := Integer(menuListener);
    menu.Items.Add(mi);

    _items.AddObject(mi.Name, mi);

    Result := mi.Name;
end;

{---------------------------------------}
function TExodusRoster.addContextMenu(const id: WideString): WordBool;
var
    idx: integer;
    menu: TTntPopupMenu;
begin
    Result := false;
    idx := _menus.IndexOf(id);
    if (idx >= 0) then exit;

    menu := TTntPopupMenu.Create(nil);
    menu.Name := 'pluginContext_' + id;
    menu.AutoHotkeys := maManual;
    menu.AutoPopup := true;

    _menus.AddObject(id, menu);
    Result := true;
end;

{---------------------------------------}
procedure TExodusRoster.removeContextMenu(const id: WideString);
var
    i, midx, idx, pidx: integer;
    menu: TTntPopupMenu;
    item: TTntMenuItem;
begin
    // Cannot remove predefined menus.
    pidx := _predefined_menus.IndexOf(id);
    if (pidx >= 0) then exit;

    idx := _menus.IndexOf(id);
    if (idx = -1) then exit;

    menu := TTntPopupMenu(_menus.Objects[idx]);
    for i := menu.Items.Count - 1 downto 0 do begin
        item := TTntMenuItem(menu.Items[i]);
        midx := _items.IndexOfObject(item);
        assert(midx <> -1);
        _items.Delete(midx);
        item.Tag := 0;
        item.Free();
    end;
    menu.Items.Clear();
    menu.Free();

    _menus.Delete(idx);
end;

{---------------------------------------}
procedure TExodusRoster.removeContextMenuItem(const menu_id,
  item_id: WideString);
var
    i, midx, idx: integer;
    menu: TTntPopupMenu;
    item: TTntMenuitem;
begin
    idx := _menus.IndexOf(menu_id);
    if (idx = -1) then exit;

    menu := TTntPopupMenu(_menus.Objects[idx]);

    for i := 0 to menu.Items.Count - 1 do begin
        item := TTntMenuItem(menu.Items[i]);
        if (item.Name = item_id) then begin
            menu.Items.Delete(i);
            midx := _items.IndexOfObject(item);
            assert(midx <> -1);
            _items.Delete(midx);
            item.Tag := 0;
            item.Free();
            exit;
        end;
    end;
end;

{---------------------------------------}
function TExodusRoster.findContextMenu(id: Widestring): TTntPopupMenu;
var
    idx: integer;
    menu: TTntPopupMenu;
begin
    Result := nil;
    idx := _menus.IndexOf(id);
    if (idx = -1) then exit;

    menu := TTntPopupMenu(_menus.Objects[idx]);
    Result := menu;
end;

{---------------------------------------}
procedure TExodusRoster.EnableContextMenuItem(const menuID: WideString; const itemID: WideString; enable: WordBool);
var
    i, idx: integer;
    menu: TTntPopupMenu;
    item: TTntMenuitem;
begin
    idx := _menus.IndexOf(menuID);
    if (idx = -1) then exit;

    menu := TTntPopupMenu(_menus.Objects[idx]);

    for i := 0 to menu.Items.Count - 1 do begin
        item := TTntMenuItem(menu.Items[i]);
        if (item.Name = itemID) then begin
            item.Enabled := enable;
            exit;
        end;
    end;
end;

{---------------------------------------}
procedure TExodusRoster.ShowContextMenuItem(const menuID: WideString; const itemID: WideString; show: WordBool);
var
    i, idx: integer;
    menu: TTntPopupMenu;
    item: TTntMenuitem;
begin
    idx := _menus.IndexOf(menuID);
    if (idx = -1) then exit;

    menu := TTntPopupMenu(_menus.Objects[idx]);

    for i := 0 to menu.Items.Count - 1 do begin
        item := TTntMenuItem(menu.Items[i]);
        if (item.Name = itemID) then begin
            item.Visible := show;
            exit;
        end;
    end;
end;

{---------------------------------------}
procedure TExodusRoster.SetContextMenuItemCaption(const menuID: WideString; const itemID: WideString; const caption: WideString);
var
    i, idx: integer;
    menu: TTntPopupMenu;
    item: TTntMenuitem;
begin
    idx := _menus.IndexOf(menuID);
    if (idx = -1) then exit;

    menu := TTntPopupMenu(_menus.Objects[idx]);

    for i := 0 to menu.Items.Count - 1 do begin
        item := TTntMenuItem(menu.Items[i]);
        if (item.Name = itemID) then begin
            item.Caption := caption;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TExodusRoster.GetContextMenuItemCaption(const menuID: WideString; const itemID: WideString): WideString;
var
    i, idx: integer;
    menu: TTntPopupMenu;
    item: TTntMenuitem;
begin
    idx := _menus.IndexOf(menuID);
    if (idx = -1) then exit;

    menu := TTntPopupMenu(_menus.Objects[idx]);

    for i := 0 to menu.Items.Count - 1 do begin
        item := TTntMenuItem(menu.Items[i]);
        if (item.Name = itemID) then begin
            Result := item.Caption;
            exit;
        end;
    end;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TExodusRoster, Class_ExodusRoster,
    ciMultiInstance, tmApartment);


end.
