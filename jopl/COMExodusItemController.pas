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

unit COMExodusItemController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl, Unicode, XMLTag;

type
  TExodusItemController = class(TAutoObject, IExodusItemController)
  {
     This class implements IExodusItemController interface. IExodusItemController
     interface allows group and item management in the contact list.
  }
  protected
      procedure Set_GroupExpanded(const Group: WideString; Value: WordBool);
      safecall;
      function Get_GroupExpanded(const Group: WideString): WordBool; safecall;
      function Get_GroupExists(const Group: WideString): WordBool; safecall;
      function GetGroups: OleVariant; safecall;
      function SaveGroups: WordBool; safecall;
      function Get_GroupsLoaded: WordBool; safecall;
      procedure ClearGroups; safecall;
      procedure ClearItems; safecall;
      function GetItem(const UID: WideString): IExodusItem; safecall;
      procedure RemoveGroup(const Group: WideString); safecall;
      function Get_Group(Index: Integer): WideString; safecall;
      function Get_GroupsCount: Integer; safecall;
      function Get_Item(Index: Integer): IExodusItem; safecall;
      function Get_ItemsCount: Integer; safecall;
      function GetGroupItems(const Group: WideString): OleVariant; safecall;
      function AddGroup(const Group: WideString): Integer; safecall;
      function AddItemByUid(const UID, ItemType: WideString): IExodusItem; safecall;
      procedure CopyItem(const UID, Group: WideString); safecall;
      procedure MoveItem(const UID, GroupFrom, GroupTo: WideString); safecall;
      procedure RemoveGroupMoveContent(const Group, groupTo: WideString); safecall;
      procedure RemoveItem(const Uid: WideString); safecall;
      procedure RemoveItemFromGroup(const UID, Group: WideString); safecall;
  private
      _Groups: TWideStringList;
      _Items: TWideStringList;
      _JS: TObject;
      _SessionCB: Integer;
      _GroupsLoaded: Boolean;

      procedure _SessionCallback(Event: string; Tag: TXMLTag);
      procedure _GetGroups();
      procedure _ParseGroups(Event: string; Tag: TXMLTag);
      procedure _SendGroups();
      function  _GetGroupItems(const Group: WideString): TWideStringList;

  public
      constructor Create(JS: TObject);
      destructor Destroy; override;
      //Properties
  end;

var
   xp_group : TXPLite;

implementation

uses ComServ, COMExodusItemWrapper, Classes,
     JabberConst, IQ, Session, GroupInfo, Variants, Contnrs;

{---------------------------------------}
constructor TExodusItemController.Create(JS: TObject);
begin

    _Groups := TWideStringList.Create();
    _Items := TWideStringList.Create();
    _Groups.Duplicates := dupError;
    _Items.Duplicates := dupError;
    _JS := JS;
    _groupsLoaded := false;
    _SessionCB := TJabberSession(_JS).RegisterCallback(_SessionCallback, '/session');

end;

{---------------------------------------}
destructor TExodusItemController.Destroy();
var
     Item: TExodusItemWrapper;
begin
   _Groups.Free;

    while _Items.Count > 0 do
    begin
        Item :=  TExodusItemWrapper(_Items.Objects[0]);
        _Items.Delete(0);
        Item.Free();
    end;
    _Items.Free;
end;


{---------------------------------------}
procedure TExodusItemController._SessionCallback(Event: string; Tag: TXMLTag);
begin
    if Event = '/session/authenticated' then begin
    //Request group info from the server
       _GroupsLoaded := false;
       _GetGroups();
    end;
end;

{---------------------------------------}
//Sends IQ to retrieves group related information
//from private storage on the server.
procedure TExodusItemController._GetGroups();
var
    IQ: TJabberIQ;
begin
    IQ := TJabberIQ.Create(TJabberSession(_JS), TJabberSession(_JS).generateID(), _ParseGroups, 180);
    with IQ do begin
        IQType := 'get';
        ToJid := '';
        Namespace := XMLNS_PRIVATE;
        with qtag.AddTag('storage') do
            setAttribute('xmlns', XMLNS_GROUPS);
        Send();
    end;
end;

{---------------------------------------}
//Parses xml containing group info received
//from private storage on the server.
procedure TExodusItemController._ParseGroups(Event: string; Tag: TXMLTag);
var
    i, Idx: Integer;
    Storage:TXMLTag;
    Expanded: Boolean;
    DefaultGroup: WideString;
begin
    Storage := Tag.QueryXPTag(xp_group);

    for i := 0 to storage.ChildCount - 1 do
    begin
        if (Storage.ChildTags[i].GetAttribute('expanded') = 'true') then
            Expanded := true
        else
            Expanded := false;

        //Add group checks for duplicates
        Idx := AddGroup(Storage.ChildTags[i].Data);
        TGroupInfo(_Groups.Objects[Idx]).Expanded := Expanded;
    end;

    //Make sure the default group is added to the list
    DefaultGroup := TJabberSession(_JS).Prefs.getString('roster_default');
    if (not Get_GroupExists(DefaultGroup)) then
        AddGroup(DefaultGroup);

    _GroupsLoaded := true;

end;

{---------------------------------------}
// Sends IQ to save group information on the server.
procedure TExodusItemController._SendGroups();
var
    i: Integer;
    IQ, STag, GTag:TXMLTag;
    Group: TGroupInfo;
    Expanded: WideString;
begin
    IQ := TXMLTag.Create('iq');
    with IQ do begin
        setAttribute('type', 'set');
        setAttribute('id', TJabberSession(_js).generateID());
        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_PRIVATE);
            STag := AddTag('storage');
            STag.setAttribute('xmlns', XMLNS_GROUPS);
            for i := 0 to _Groups.Count - 1 do
            begin
                Group := TGroupInfo(_Groups.Objects[i]);
                GTag := TXMLTag.Create('group', Group.Name);
                if (Group.Expanded) then
                    Expanded := 'true'
                else
                    Expanded := 'false';
                GTag.setAttribute('expanded', Expanded);
                STag.AddTag(GTag);
            end;
        end;
    end;
    TJabberSession(_JS).SendTag(IQ);
end;

{---------------------------------------}
function  TExodusItemController._GetGroupItems(const Group: WideString): TWideStringList;
var
    i: Integer;
begin
    Result := TWideStringList.Create();
    for i := 0 to _Items.Count - 1 do
    begin
        if ((TExodusItemWrapper(_Items.Objects[i]).ExodusItem).BelongsToGroup(Group)) then
            Result.AddObject(_Items[i], _Items.Objects[i]);
    end;
end;

{---------------------------------------}
function TExodusItemController.Get_Group(Index: Integer): WideString;
begin
    Result := _groups[index];
end;

{---------------------------------------}
function TExodusItemController.Get_GroupsCount: Integer;
begin
    Result := _Groups.Count;
end;

{---------------------------------------}
function TExodusItemController.Get_Item(Index: Integer): IExodusItem;
begin
    Result := TExodusItemWrapper(_Items.Objects[index]).ExodusItem;
end;

{---------------------------------------}
function TExodusItemController.get_ItemsCount: Integer;
begin
   Result := _Items.Count;
end;

{---------------------------------------}
function TExodusItemController.GetGroupItems(
  const Group: WideString): OleVariant;
var
    List: TWideStringList;
    Items: Variant;
    i: Integer;
begin
    List := _GetGroupItems(group);
    Items := VarArrayCreate([0,List.Count], varOleStr);

    for i := 0 to List.Count - 1 do begin
        VarArrayPut(Items, List[i], i);
    end;
    list.Free();
    Result := items;
end;

{---------------------------------------}
function TExodusItemController.AddGroup(const Group: WideString): Integer;
var
    GroupInfo: TGroupInfo;
    Idx: Integer;
begin
    Result := -1;
    Idx := _Groups.IndexOf(Group);
    if (Idx > -1) then
    begin
         Result := Idx;
         exit;
    end;
    GroupInfo := TGroupInfo.Create();
    GroupInfo.Name := Group;
    GroupInfo.Expanded := true;
    Result := _Groups.AddObject(Group, GroupInfo);
     TJabberSession(_JS).FireEvent('/data/item/group/add', nil, Group);
    //If adding new groups and groups have
    //been loaded, need to save to the server's
    //private storage.
    if (_GroupsLoaded) then
    begin
        _SendGroups();
    end;
end;

{---------------------------------------}
function TExodusItemController.AddItemByUid(const UID,
  ItemType: WideString): IExodusItem;
var
    Item: TExodusItemWrapper;
    Idx: Integer;
begin
    //Check if item exists
    Idx := _items.IndexOf(Uid);
    //If new item, create and append to the list
    if (Idx = -1) then
    begin
       Item := TExodusItemWrapper.Create(Uid, ItemType);
       Idx := _Items.AddObject(Uid, Item);
    end;
    //Return interface
    Result := TExodusItemWrapper(_Items.Objects[Idx]).ExodusItem;
end;

{---------------------------------------}
procedure TExodusItemController.CopyItem(const UID, Group: WideString);
var
    Item: IExodusItem;
    Idx: Integer;
begin
    //Check if item exists
    Idx := _Items.IndexOf(Uid);
    if (Idx < 0) then exit;
    //Copy item from one group to another, or in other words,
    //add group to the item's group list.
    Item := TExodusItemWrapper(_Items.Objects[Idx]).ExodusItem;
    if (Item <> nil) then
       Item.AddGroup(Group);
end;

{---------------------------------------}
procedure TExodusItemController.MoveItem(const UID, GroupFrom,
  GroupTo: WideString);
var
    Idx: Integer;
    Item: IExodusItem;
begin
    Idx := _Items.IndexOf(Uid);
    if (Idx < 0) then exit;
    Item := TExodusItemWrapper(_Items.Objects[Idx]).ExodusItem;
    //To move item between the groups, we just need to change group name.
    if (Item <> nil) then
        Item.MoveGroup(GroupFrom, GroupTo);

end;

{---------------------------------------}
procedure TExodusItemController.RemoveGroupMoveContent(const Group,
  groupTo: WideString);
var
    Items: TWideStringList;
    Item: IExodusItem;
    i: Integer;
begin
    //Get list of items in the group
    Items := _GetGroupItems(Group);
    for i := 0 to Items.Count do
    begin
       //Iterate through the list and move each item to the new group
       Item := TExodusItemWrapper(Items.Objects[i]).ExodusItem;
       if (Item <> nil) then
           Item.MoveGroup(Group, GroupTo);
    end;
    Items.Free;
end;

{---------------------------------------}
procedure TExodusItemController.RemoveItem(const Uid: WideString);
var
    ItemWrapper: TExodusItemWrapper;
    Idx: Integer;
begin
    //Check if item exists
    Idx := _items.IndexOf(uid);
    if (Idx < 0) then exit;
    //Remove item from the list, call remove for the item
    ItemWrapper := TExodusItemWrapper(_Items.Objects[Idx]);
    _Items.Delete(Idx);
    ItemWrapper.Free;

end;

{---------------------------------------}
procedure TExodusItemController.RemoveItemFromGroup(const UID,
  Group: WideString);
var
    Item: IExodusItem;
    Idx: Integer;
begin
    //Check if item exists
    Idx := _Items.IndexOf(Uid);
    if (Idx < 0) then exit;
    //Remove item from the list, call remove for the item
    Item := TExodusItemWrapper(_Items.Objects[Idx]).ExodusItem;
    Item.RemoveGroup(Group);
end;

{---------------------------------------}
procedure TExodusItemController.RemoveGroup(const group: WideString);
var
    Idx: Integer;
    GroupInfo: TGroupInfo;
begin
    Idx := _Groups.IndexOf(Group);
    if (Idx = -1) then exit;
    GroupInfo := TGroupInfo(_Groups.Objects[Idx]);
    _Groups.Delete(Idx);
    GroupInfo.Free;
    if (_GroupsLoaded) then
    begin
        //Since the group is deleted, and groups are loaded,
        //we need to save groups to the server
        _SendGroups();
    end;
end;

{---------------------------------------}
function TExodusItemController.GetItem(const UID: WideString): IExodusItem;
var
    Idx: Integer;
begin
    Result := nil;
    Idx := _Items.IndexOf(Uid);
    if (Idx = -1) then exit;
    Result := TExodusItemWrapper(_Items.Objects[Idx]).ExodusItem;
end;

{---------------------------------------}
procedure TExodusItemController.ClearGroups;
var
    Group: TGroupInfo;
begin
    while _Groups.Count > 0 do
    begin
        Group :=  TGroupInfo(_Groups.Objects[0]);
        _Groups.Delete(0);
        Group.Free();
    end;
end;

{---------------------------------------}
procedure TExodusItemController.ClearItems;
var
    Item: TExodusItemWrapper;
begin
    while _Items.Count > 0 do
    begin
        Item :=  TExodusItemWrapper(_Items.Objects[0]);
        _Items.Delete(0);
        Item.Free();
    end;
end;


function TExodusItemController.Get_GroupsLoaded: WordBool;
begin
   Result := _GroupsLoaded;
end;


function TExodusItemController.SaveGroups: WordBool;
begin
    _SendGroups();
end;

function TExodusItemController.GetGroups: OleVariant;
var
    Groups : Variant;
    i: Integer;
begin
    Groups := VarArrayCreate([0,_Groups.Count], varOleStr);

    for i := 0 to _Groups.Count - 1 do
    begin
        VarArrayPut(Groups, _Groups[i], i);
    end;

    Result := Groups;
end;

function TExodusItemController.Get_GroupExists(
  const Group: WideString): WordBool;
var
    i: Integer;
begin
    Result := false;
    for i := 0 to _Groups.Count - 1 do
    begin
        if (_Groups[i] = Group) then
        begin
            Result := true;
            exit;
        end;
    end;
end;

function TExodusItemController.Get_GroupExpanded(
  const Group: WideString): WordBool;
var
    i: Integer;
begin
    Result := false;
    for i := 0 to _Groups.Count - 1 do
    begin
        if (_Groups[i] = Group) then
        begin
            Result := TGroupInfo(_Groups.Objects[i]).Expanded;
            exit;
        end;
    end;
end;

procedure TExodusItemController.Set_GroupExpanded(const Group: WideString;
  Value: WordBool);
var
    i: Integer;
begin
    for i := 0 to _Groups.Count - 1 do
    begin
        if (_Groups[i] = Group) then
        begin
            TGroupInfo(_Groups.Objects[i]).Expanded := Value;
            exit;
        end;
    end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusItemController, Class_ExodusItemController,
    ciMultiInstance, tmApartment);

  xp_group := TXPLite.Create('//storage[@xmlns="' + XMLNS_GROUPS + '"]');
end.
