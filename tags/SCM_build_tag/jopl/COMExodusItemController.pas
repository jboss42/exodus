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
  ComObj, ActiveX, Exodus_TLB, StdVcl, Unicode, XMLTag, PrefFile, GroupParser, COMExodusItemWrapper;

type
  {
    This class extends the item wrapper to actually create items, and retain
    the callback
  }
  TExodusItemRetainer = class(TExodusItemWrapper)
  private
    _Callback: IExodusItemCallback;

  public
    constructor Create(ctrl: IExodusItemController;
        Uid: WideString;
        Type_: WideString;
        cb: IExodusItemCallback);
    destructor Destroy(); override;

    property Callback: IExodusItemCallback read _Callback;
  end;
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
      procedure ClearItems; safecall;
      function GetItem(const UID: WideString): IExodusItem; safecall;
      function Get_GroupsCount: Integer; safecall;
      function Get_Item(Index: Integer): IExodusItem; safecall;
      function Get_ItemsCount: Integer; safecall;
    function GetGroupItems(const Group: WideString): IExodusItemList; safecall;
      function AddItemByUid(const UID, ItemType: WideString;
      const cb: IExodusItemCallback): IExodusItem; safecall;
      procedure CopyItem(const UID, GroupTo: WideString); safecall;
      procedure MoveItem(const UID, GroupFrom, GroupTo: WideString); safecall;
      procedure RemoveGroupMoveContent(const Group, groupTo: WideString); safecall;
      procedure RemoveItem(const Uid: WideString); safecall;
      procedure RemoveItemFromGroup(const UID, Group: WideString); safecall;
    function GetItemsByType(const Type_: WideString): IExodusItemList; safecall;
    function AddGroup(const grp: WideString): IExodusItem; safecall;
  private
      _Items: TWideStringList;
      _JS: TObject;
      _GroupsCB: IExodusItemCallback;
      _SessionCB: Integer;
      _GroupsLoaded: Boolean;
      _ServerStorage: Boolean;
      _GroupParser : TGroupParser;
      
      procedure _SessionCallback(Event: string; Tag: TXMLTag);
      procedure _GetGroups();
      procedure _ParseGroups(Event: string; Tag: TXMLTag);
      procedure _SendGroups();
      function  _GetItemRetainer(const UID: Widestring): TExodusItemRetainer;
      function  _AddGroup(const GroupUID: WideString): TExodusItemRetainer;
  public
      constructor Create(JS: TObject);
      destructor Destroy; override;
      //Properties

  end;

  TExodusGroupCallback = class(TAutoIntfObject, IExodusItemCallback)
  private
    _ctrl: TExodusItemController;

    constructor Create(ctrl: TExodusItemController);

  public
    destructor Destroy(); override;

    procedure ItemDeleted(const item: IExodusItem); safecall;
    procedure ItemGroupsChanged(const item: IExodusItem); safecall;
  end;

var
   xp_group : TXPLite;

implementation

uses ComServ, Classes,
     JabberConst, IQ, Session, {GroupInfo,} Variants, Contnrs,
     COMExodusItem, COMExodusItemList;


{---------------------------------------}
constructor TExodusItemRetainer.Create(
        ctrl: IExodusItemController;
        Uid: WideString;
        Type_: WideString;
        cb: IExodusItemCallback);
begin
    inherited Create(TExodusItem.Create(ctrl, uid, Type_, cb));
    _Callback := cb;
end;
destructor TExodusItemRetainer.Destroy;
begin
    _Callback := nil;

    inherited;
end;

{---------------------------------------}
constructor TExodusItemController.Create(JS: TObject);
begin

    _Items := TWideStringList.Create();
    _Items.Duplicates := dupError;
    _JS := JS;
    _groupsLoaded := false;
    _SessionCB := TJabberSession(_JS).RegisterCallback(_SessionCallback, '/session');
    _ServerStorage := true;
    _GroupParser := TGroupParser.Create(_JS);
    _GroupsCB := TExodusGroupCallback.Create(Self);
end;

{---------------------------------------}
destructor TExodusItemController.Destroy();
begin

    ClearItems();
    
    _Items.Free;
    _GroupParser.Free;

    _GroupsCB._Release();
    _GroupsCB := nil;
end;


{---------------------------------------}
procedure TExodusItemController._SessionCallback(Event: string; Tag: TXMLTag);
begin
    if Event = '/session/authenticated' then begin
       _GroupsLoaded := false;
       _GetGroups();
    end
    else if Event = '/session/disconnected' then begin
        _GroupsLoaded := false;
        ClearItems();
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
    i: Integer;
    Groups:TXMLTag;
    Group: IExodusItem;
begin
    Group := nil;
    Groups := nil;
    TJabberSession(_JS).FireEvent('/item/begin', Group);

    if ((Event = 'xml') and (Tag.getAttribute('type') = 'result')) then
        Groups := Tag.QueryXPTag(xp_group)
    else
    begin
        if ((Event = 'xml') and (Tag.getAttribute('type') = 'error')) then
//        begin
            _ServerStorage := false;
//            Groups := MainSession.Prefs.LoadGroups();
//            if (Groups = nil) then exit;
//        end;
    end;

    if Groups <> nil then begin
        for i := 0 to Groups.ChildCount - 1 do
        begin
            //Add will checks for duplicates
            Group := AddGroup(Groups.ChildTags[i].Data);
            Group.AddProperty('Expanded', Groups.ChildTags[i].GetAttribute('expanded'));
        end;
    end;

    _GroupsLoaded := true;
    TJabberSession(_JS).FireEvent('/item/end', Group);
    TJabberSession(_JS).FireEvent('/data/item/group/restore', nil, '');
end;

{---------------------------------------}
// Sends IQ to save group information on the server.
procedure TExodusItemController._SendGroups();
var
    i: Integer;
    IQ, STag, GTag:TXMLTag;
begin
    IQ := TXMLTag.Create('iq');
    with IQ do begin
        setAttribute('type', 'set');
        setAttribute('id', TJabberSession(_js).generateID());
        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_PRIVATE);
            STag := AddTag('storage');
            STag.setAttribute('xmlns', XMLNS_GROUPS);
            for i := 0 to Get_ItemsCount - 1 do
            begin
                if (Get_Item(i).Type_ <> EI_TYPE_GROUP) then continue;

                //Group := TGroupInfo(_Groups.Objects[i]);
                GTag := TXMLTag.Create('group', Get_Item(i).UID);
                try
                   GTag.setAttribute('expanded', Get_Item(i).Value['Expanded']);
                except
                   GTag.setAttribute('expanded', 'true');
                end;
                STag.AddTag(GTag);
            end;
        end;
    end;
    TJabberSession(_JS).SendTag(IQ);
end;

{---------------------------------------}
function TExodusItemController.Get_GroupsCount: Integer;
var
    i: Integer;
begin
    Result := 0;
    for i := 0 to Get_ItemsCount - 1 do
    begin
        if (Get_Item(i).Type_ <> EI_TYPE_GROUP) then continue;
        Inc(Result);
    end;
end;

{---------------------------------------}
function TExodusItemController.Get_Item(Index: Integer): IExodusItem;
begin
    Result := TExodusItemRetainer(_Items.Objects[index]).ExodusItem;
end;

{---------------------------------------}
function TExodusItemController.get_ItemsCount: Integer;
begin
   Result := _Items.Count;
end;

{---------------------------------------}
function TExodusItemController.GetGroupItems(
  const Group: WideString): IExodusItemList;
var
    item: IExodusItem;
    idx: Integer;
begin
    Result := TExodusItemList.Create();
    for idx := 0 to _Items.Count - 1 do begin
        item := TExodusItemRetainer(_Items.Objects[idx]).ExodusItem;
        if (item.BelongsToGroup(Group)) then
            Result.Add(item);
    end;
end;

function TExodusItemController._GetItemRetainer(const UID: WideString): TExodusItemRetainer;
var
    idx: Integer;
begin
    idx := _Items.IndexOf(UID);
    if (idx <> -1) then
        Result := TExodusItemRetainer(_Items.Objects[idx])
    else
        Result := nil;
end;
function  TExodusItemController._AddGroup(const GroupUID: WideString): TExodusItemRetainer;
var
    i: Integer;
    SubGroup: TExodusItemRetainer;
    Groups: TWideStringList;
    GroupParent: WideString;
begin
    Result := _GetItemRetainer(GroupUID);
    if (Result <> nil) then exit;

    //Get nested groups
    Groups := _GroupParser.GetNestedGroups(GroupUID);
    //Add nested groups to the item list
    for i := 0 to Groups.Count - 1 do
    begin
        if (Get_GroupExists(Groups[i])) then continue;
        SubGroup := TExodusItemRetainer.Create(Self, Groups[i], EI_TYPE_GROUP, _GroupsCB);
        _Items.AddObject(Groups[i], SubGroup);
        SubGroup.ExodusItem.Text := _GroupParser.GetGroupName(SubGroup.ExodusItem.UID);
        GroupParent := _GroupParser.GetGroupParent(SubGroup.ExodusItem.UID);
        if (GroupParent <> '') then
            SubGroup.ExodusItem.AddGroup(GroupParent);
        if (i = Groups.Count - 1) then
            Result := SubGroup;
    end;

    if (Result = nil) then
        Result := _GetItemRetainer(GroupUID);

    Groups.Free;
    TJabberSession(_JS).FireEvent('/item/add', Result.ExodusItem);
    //If adding new groups and groups have
    //been loaded, need to save to the server's
    //private storage.
    if (_GroupsLoaded) then
    begin
        SaveGroups();
    end;
end;

{---------------------------------------}
function TExodusItemController.AddItemByUid(const UID, ItemType: WideString;
  const cb: IExodusItemCallback): IExodusItem;
var
    wrapper: TExodusItemRetainer;
begin
    //Check if item exists
    wrapper := _GetItemRetainer(UID);
    //If new item, create and append to the list
    if (wrapper = nil) then
    begin
       if (ItemType = EI_TYPE_GROUP) then
            wrapper := _AddGroup(UID)
       else
       begin
           wrapper := TExodusItemRetainer.Create(Self, Uid, ItemType, cb);
           _Items.AddObject(Uid, wrapper);
       end;
    end;

    //Return interface
    Result := wrapper.ExodusItem;
end;

{---------------------------------------}
procedure TExodusItemController.CopyItem(const UID, GroupTo: WideString);
var
    Wrapper: TExodusItemRetainer;
    Item: IExodusItem;
    Idx: Integer;
    subgrp: Widestring;
    subitems: IExodusItemList;
begin
    //Check if item exists
    Wrapper := _GetItemRetainer(UID);
    if (Wrapper = nil) then exit;

    Item := Wrapper.ExodusItem;
    if (Item.Type_ = EI_TYPE_GROUP) then begin
        if (_GroupParser.Separator <> '') then begin
            if (GroupTo <> '') then begin
                //Make this group a subgroup of Group...
                subgrp := GroupTo + _GroupParser.Separator + _GroupParser.GetGroupName(UID)
            end
            else begin
                //Make this group a top-level Group...
                subgrp := _GroupParser.GetGroupName(UID);
            end;
        end
        else begin
            //Copy this group's items into Group...
            subgrp := GroupTo;
        end;

        subitems := GetGroupItems(UID);
        for idx := 0 to subitems.Count - 1 do
            CopyItem(subitems.Item[idx].UID, subgrp);
    end
    else begin
        //Copy item from one group to another, or in other words,
        //add group to the item's group list.
        Item.AddGroup(GroupTo);
    end;
end;

{---------------------------------------}
procedure TExodusItemController.MoveItem(const UID, GroupFrom,
  GroupTo: WideString);
var
    Wrapper: TExodusItemRetainer;
    Item: IExodusItem;
    Idx: Integer;
    subgrp: Widestring;
    subitems: IExodusItemList;
begin
    //Check if item exists
    Wrapper := _GetItemRetainer(UID);
    if (Wrapper = nil) then exit;

    Item := Wrapper.ExodusItem;
    if (Item.Type_ = EI_TYPE_GROUP) then begin
        if (_GroupParser.Separator <> '') then begin
            if (GroupTo <> '') then begin
                //Make this group a subgroup of Group...
                subgrp := GroupTo + _GroupParser.Separator + _GroupParser.GetGroupName(UID)
            end
            else begin
                //Make this group a top-level Group...
                subgrp := _GroupParser.GetGroupName(UID);
            end;

            //Now let's make sure the new group exists!
            AddGroup(subgrp);
        end
        else begin
            //Move this group's items into GroupTo...
            subgrp := GroupTo;
        end;

        subitems := GetGroupItems(UID);
        for idx := 0 to subitems.Count - 1 do
            MoveItem(subitems.Item[idx].UID, UID, subgrp);

        RemoveItem(UID);
    end
    else begin
        //Move item from one group to another, or in other words,
        //add GroupFrom to, and remove GroupTo from, the item's group list.
        item.MoveGroup(GroupFrom, GroupTo);
    end;
end;

{---------------------------------------}
procedure TExodusItemController.RemoveGroupMoveContent(const Group,
  groupTo: WideString);
var
    Items: IExodusItemList;
    Item: IExodusItem;
    i: Integer;
begin
    //Get list of items in the group
    Items := GetGroupItems(Group);
    for i := 0 to Items.Count do
    begin
       //Iterate through the list and move each item to the new group
       Item := Items.Item[i];
       if (Item <> nil) then
           Item.MoveGroup(Group, GroupTo);
    end;
end;

{---------------------------------------}
procedure TExodusItemController.RemoveItem(const Uid: WideString);
var
    ItemWrapper: TExodusItemRetainer;
    cb: IExodusItemCallback;
    subItems: IExodusItemList;
    Idx: Integer;
begin
    //Check if item exists
    Idx := _Items.IndexOf(Uid);
    if (Idx = -1) then exit;

    //Reference and delete from list
    ItemWrapper := TExodusItemRetainer(_Items.Objects[idx]);
    _Items.Delete(Idx);

    if (ItemWrapper.ExodusItem.Type_ = EI_TYPE_GROUP) then begin
        //remove all of the group's items...
        subItems := GetGroupItems(ItemWrapper.ExodusItem.UID);
        for idx := 0 to subItems.Count - 1 do begin
            if (subItems.Item[idx].Type_ = EI_TYPE_GROUP) then
                RemoveItem(subItems.Item[idx].UID)
            else
                subItems.Item[idx].RemoveGroup(ItemWrapper.ExodusItem.UID);
        end;
    end;

    //notify callback
    cb := ItemWrapper.Callback;
    if (cb <> nil) then cb.ItemDeleted(ItemWrapper.ExodusItem);

    //then finally, we delete
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
    Item := TExodusItemRetainer(_Items.Objects[Idx]).ExodusItem;
    Item.RemoveGroup(Group);
end;


{---------------------------------------}
function TExodusItemController.GetItem(const UID: WideString): IExodusItem;
var
    Idx: Integer;
begin
    Result := nil;
    Idx := _Items.IndexOf(Uid);
    if (Idx = -1) then exit;
    Result := TExodusItemRetainer(_Items.Objects[Idx]).ExodusItem;
end;


{---------------------------------------}
procedure TExodusItemController.ClearItems;
var
    Item: TExodusItemRetainer;
begin
    while _Items.Count > 0 do
    begin
        Item :=  TExodusItemRetainer(_Items.Objects[0]);
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
   if (_ServerStorage) then
       _SendGroups();
//   else
//   begin
//       Groups := TXMLTag.Create('local-groups');
//       for i := 0 to _Groups.Count - 1 do
//       begin
//           Group := TGroupInfo(_Groups.Objects[i]);
//           GTag := TXMLTag.Create('group', Group.Name);
//           if (Group.Expanded) then
//               Expanded := 'true'
//           else
//               Expanded := 'false';
//           GTag.setAttribute('expanded', Expanded);
//           Groups.AddTag(GTag);
//       end;
//       TJabberSession(_js).Prefs.SaveGroups(Groups);
//   end;

end;

function TExodusItemController.GetGroups: OleVariant;
var
    Groups : Variant;
    i: Integer;
begin
    Groups := VarArrayCreate([0,Get_GroupsCount], varOleStr);

    for i := 0 to Get_ItemsCount - 1 do
    begin
        if (Get_Item(i).Type_ <> EI_TYPE_GROUP) then continue;

        VarArrayPut(Groups, Get_Item(i).UID, i);
    end;

    Result := Groups;
end;

function TExodusItemController.Get_GroupExists(
  const Group: WideString): WordBool;
begin
    Result := false;
    if (_Items.IndexOf(Group) > -1) then
       Result := true;
end;

function TExodusItemController.Get_GroupExpanded(
  const Group: WideString): WordBool;
var
    Idx: Integer;
begin
    Result := false;
    Idx := _Items.IndexOf(Group);
    if (Idx = -1) then exit;
    try
       if (Get_Item(Idx).value['Expanded'] = 'true') then
           Result := true;
    except

    end;
end;

procedure TExodusItemController.Set_GroupExpanded(const Group: WideString;
  Value: WordBool);
var
    Wrapper: TExodusItemRetainer;
    state: Widestring;
begin
    Wrapper := _GetItemRetainer(Group);
    if (Wrapper = nil) then exit;
    if Value then
        state := 'true'
    else
        state := 'false';

    try
       if (Wrapper.ExodusItem.value['Expanded'] <> state) then begin
           Wrapper.ExodusItem.value['Expanded'] := state;
           TJabberSession(_JS).FireEvent('/item/update', Wrapper.ExodusItem);
       end;
    except

    end;
end;

function TExodusItemController.GetItemsByType(
  const Type_: WideString): IExodusItemList;
var
    item: IExodusItem;
    idx: Integer;
begin
    Result := TExodusItemList.Create();
    for idx := 0 to _Items.Count - 1 do begin
        item := TExodusItemRetainer(_Items.Objects[idx]).ExodusItem;
        if (item.Type_ = Type_) then
            Result.Add(item);
    end;
end;

function TExodusItemController.AddGroup(const grp: WideString): IExodusItem;
begin
    Result := _AddGroup(grp).ExodusItem;
end;


constructor TExodusGroupCallback.Create(ctrl: TExodusItemController);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusItemCallback);

    _ctrl := ctrl;

    _AddRef();
end;
destructor TExodusGroupCallback.Destroy;
begin
    inherited;
end;

procedure TExodusGroupCallback.ItemDeleted(const item: IExodusItem);
begin
    _ctrl._SendGroups();
    item.IsVisible := false;
    TJabberSession(_ctrl._JS).FireEvent('/item/remove', item);
end;
procedure TExodusGroupCallback.ItemGroupsChanged(const item: IExodusItem);
begin
    //TODO:  something??
    _ctrl._SendGroups();
    TJabberSession(_ctrl._JS).FireEvent('/item/update', item);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusItemController, Class_ExodusItemController,
    ciMultiInstance, tmApartment);

  xp_group := TXPLite.Create('//storage[@xmlns="' + XMLNS_GROUPS + '"]');
end.
