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

unit ContactController;

interface

uses COMExodusItemController, Exodus_TLB, XMLTag, Presence,
     Signals, DisplayName, COMExodusItem;

type


   TContactController = class
   private
       _JS: TObject;
       _PresCB: Integer;
       _IQCB: Integer;
       _RMCB: Integer;
       _SessionCB: Integer;
       _HideBlocked: Boolean;
       _HideOffline: Boolean;
       _HidePending: Boolean;
       _HideObservers: Boolean;
       _UseDisplayName: Boolean;
       _DNListener: TDisplayNameEventListener;
       _DefaultGroup: WideString;
       //Methods
       procedure _GetContacts();
       procedure _ParseContacts(Event: string; Tag: TXMLTag);
       procedure _ParseContact(Contact: IExodusItem; Tag: TXMLTag);
       procedure _IQCallback(Event: String; Tag: TXMLTag);
       procedure _SessionCallback(Event: string; Tag: TXMLTag);
       procedure _RemoveCallback(Event: String; ContactItem: IExodusItem);
       procedure _PresCallback(Event: String; Tag: TXMLTag; Pres: TJabberPres);
       procedure _SetPresenceImage(Show: Widestring; Item: IExodusItem);
       function  _GetPresenceImage(Show: Widestring; Prefix: WideString): integer;
       procedure _UpdateContact(Item: IExodusItem; Pres: TJabberPres = nil);
       procedure _UpdateContacts();
       procedure _OnDisplayNameChange(bareJID: Widestring; DisplayName: WideString);
   public
       constructor Create(JS: TObject);
       destructor Destroy; override;
       procedure Clear();
       //Properties


   end;

implementation
uses IQ, JabberConst, JabberID, SysUtils, Unicode,
     Session, RosterImages, COMExodusItemWrapper;

{---------------------------------------}
constructor TContactController.Create(JS: TObject);
begin
    _JS := JS;
    _SessionCB := TJabberSession(_JS).RegisterCallback(_SessionCallback, '/session');
    _IQCB := TJabberSession(_JS).RegisterCallback(_IQCallback, '/packet/iq/query[@xmlns="jabber:iq:roster"]'); //add type set, skip results
    _RMCB := TJabberSession(_JS).RegisterCallback(_RemoveCallback, '/roster/remove/item[@xmlns="jabber:iq:roster"]');
    _PresCB := TJabberSession(_JS).RegisterCallback(_PresCallback);
    _HideBlocked := false;
    _HideOffline := false;
    _HidePending := false;
    _HideObservers := false;
    _UseDisplayName := false;
    _DefaultGroup := '';
    _DNListener := TDisplayNameEventListener.Create();
    _DNListener.OnDisplayNameChange := _OnDisplayNameChange;
end;

{---------------------------------------}
destructor  TContactController.Destroy();
begin
    with TJabberSession(_js) do begin
        UnregisterCallback(_IQCB);
        UnregisterCallback(_RMCB);
        UnregisterCallback(_PresCB);
    end;
    _DNListener.Free;
end;

{---------------------------------------}
//Creates and sends out an IQ to retrieve
//contacts from the server.
procedure TContactController._GetContacts();
var
    IQ: TJabberIQ;
begin
    IQ := TJabberIQ.Create(TJabberSession(_JS), TJabberSession(_JS).generateID(), _ParseContacts, 600);
    with iq do begin
        iqType := 'get';
        toJID := '';
        Namespace := XMLNS_ROSTER;
        Send();
    end;
end;

{---------------------------------------}
//Parses the xml with contacts received from the server.
procedure TContactController._ParseContacts(Event: string; Tag: TXMLTag);
var
    ContactItemTags: TXMLTagList;
    ContactTag: TXMLTag;
    TmpJID: TJabberID;
    i: Integer;
    Item: IExodusItem;
begin
        Item := nil;
        TJabberSession(_JS).FireEvent('/item/begin', Item);
        ContactItemTags := Tag.QueryXPTags('/iq/query/item');
        for i := 0 to ContactItemTags.Count - 1 do begin
            ContactTag := ContactItemTags.Tags[i];
            TmpJID := TJabberID.Create(ContactTag.GetAttribute('jid'));
 //           Item := TJabberSession(_js).ItemController.GetItem(TmpJID.full);
            Item := TJabberSession(_js).ItemController.AddItemByUid(TmpJID.full, EI_TYPE_CONTACT);
            //Make sure item exists
            if (Item <> nil) then
            begin
                //Item := TJabberSession(_js).ItemController.AddItemByUid(TmpJID.full);
                _ParseContact(Item, ContactTag);

                if (Item.IsVisible) then
                    TJabberSession(_JS).FireEvent('/item/add', Item);
            end;
            //DisplayName.getDisplayNameCache().UpdateDisplayName(TmpJID.jid);
            TmpJID.Free();
        end;
        //TJabberSession(_js).ItemController.SaveGroups();
        Item := nil;
        TJabberSession(_JS).FireEvent('/item/end', Item);

end;

{---------------------------------------}
//Sets some specific and generic properties of
//IExodusItem interface based on the tag data.
procedure TContactController._ParseContact(Contact: IExodusItem; Tag: TXMLTag);
var
    TmpJid: TJabberID;
    Grps: TXMLTagList;
    i: Integer;
    Grp, Groups: WideString;
begin
    //Contact.Type_ := EI_TYPE_CONTACT;
    Contact.Text := Tag.GetAttribute('name');
    TmpJid := TJabberID.Create(Tag.GetAttribute('jid'));
    Contact.AddProperty('Name', Tag.GetAttribute('name'));
    Contact.AddProperty('Subscription', Tag.GetAttribute('subscription'));
    Contact.AddProperty('Ask', Tag.GetAttribute('ask'));
    _UpdateContact(Contact);

    Grps := Tag.QueryXPTags('/item/group');
    //Build temporary list of groups for future comparison of the lists.
    for i := 0 to Grps.Count - 1 do
    begin
        Grp := WideTrim(TXMLTag(grps[i]).Data);
        Groups := Groups + Grp + LineSeparator;
    end;

    if (Contact.GroupsChanged(Groups)) then
    begin
    //If groups changed, update the list.
        Contact.ClearGroups();
        for i := 0 to Grps.Count - 1 do
        begin
            Grp := WideTrim(TXMLTag(Grps[i]).Data);
            if (Grp <> '') then begin
                Contact.AddGroup(grp);
                TJabberSession(_js).ItemController.AddGroup(grp);
            end;

        end;
    end;
    
    if (Contact.GroupCount = 0) then
    begin
        Contact.AddGroup(_DefaultGroup);
    end;
    //Make sure groups for the contact exist in the global group list.
    //_SynchronizeGroups(Contact);

    Grps.Free();
    TmpJid.Free();
end;

{---------------------------------------}
procedure TContactController._SessionCallback(Event: string; Tag: TXMLTag);
begin
     if Event = '/session/authenticated'  then
     begin
         _HideBlocked := TJabberSession(_JS).Prefs.getBool('roster_hide_block');
         _HideOffline := not TJabberSession(_JS).Prefs.getBool('roster_only_online');
         _HidePending := not TJabberSession(_JS).Prefs.getBool('roster_show_pending');
         _HideObservers := not TJabberSession(_JS).Prefs.getBool('roster_show_observers');
         _UseDisplayName := TJabberSession(_JS).Prefs.getBool('displayname_profile_enabled');
         _DefaultGroup := TJabberSession(_JS).Prefs.getString('roster_default');
         _GetContacts();
     end
     else if Event = '/session/prefs' then
     begin
         _HideBlocked := TJabberSession(_JS).Prefs.getBool('roster_hide_block');
         _HideOffline := not TJabberSession(_JS).Prefs.getBool('roster_only_online');
         _HidePending := not TJabberSession(_JS).Prefs.getBool('roster_show_pending');
         _HideObservers := not TJabberSession(_JS).Prefs.getBool('roster_show_observers');
         _UseDisplayName := TJabberSession(_JS).Prefs.getBool('displayname_profile_enabled');
         if (_DefaultGroup <> TJabberSession(_JS).Prefs.getString('roster_default')) then
         begin
             _DefaultGroup := TJabberSession(_JS).Prefs.getString('roster_default');
             TJabberSession(_JS).ItemController.AddGroup(_DefaultGroup);
         end;
         _UpdateContacts();
     end;
end;

{---------------------------------------}
procedure TContactController._IQCallback(Event: String; Tag: TXMLTag);
begin
end;

{---------------------------------------}
procedure TContactController._RemoveCallback(Event: String; ContactItem: IExodusItem);
begin

end;

{---------------------------------------}
//This function will iterate though all contacts and
//figure out new visibility status or display name
//changes when preferences have changed.
//It will inform the GUI of the changes through
//the eventing.
procedure TContactController._UpdateContacts();
var
    i: Integer;
    Item: IExodusItem;
    Tag: TXMLTag;
    pres: TJabberPres;
begin
    Tag := TXMLTag.Create();
    Item := nil;
    TJabberSession(_JS).FireEvent('/item/begin', Item);
    for i := 0 to TJabberSession(_js).ItemController.ItemsCount - 1 do
    begin
        Item := TJabberSession(_js).ItemController.Item[i];
        pres := TJabberSession(_JS).ppdb.FindPres(Item.uid, '');
        _UpdateContact(Item, pres);
        if (Item.IsVisible) then
            TJabberSession(_JS).FireEvent('/item/add',  Item)
        else
            TJabberSession(_JS).FireEvent('/item/remove', Item)

    end;
    TJabberSession(_JS).FireEvent('/item/end', Item);
    Tag.Free();

end;

{---------------------------------------}
//This function will set properties for IExodusItem based on presence and
//subscription properties for the contacts implemented as generic properties.
procedure TContactController._UpdateContact(Item: IExodusItem; Pres: TJabberPres = nil);
var
    IsBlocked, IsOffline, IsPending, IsObserver, IsNone: boolean;
    ImagePrefix, Subs, Ask, Show: Widestring;
    Tag: TXMLTag;
begin
    Item.Active := false;
    Item.IsVisible := true;

    IsOffline := false;
    IsObserver := false;
    IsPending := false;
    IsNone := false;

    Show := '';
    Tag := TXMLTag.Create();

    GetDisplayNameCache().UpdateDisplayName(Item);
    Item.text := GetDisplayNameCache().GetDisplayName(Item.Uid);

    // is contact offline?
    //Set contact unavailable by default
    if (Pres <> nil) then
    begin
        if (Pres.PresType = 'unavailable') then
        begin
            Item.Active := false;
            IsOffline := true;
            Show := 'offline';
        end
        else
        begin
            Item.Active := true;
            //Default value for the image prefix to the presence packet "show" value
            Show := Pres.Show;
        end;
    end
    else
    begin
        Item.Active := false;
        IsOffline := true;
        Show := 'offline';
    end;

    // Is this contact blocked?
    IsBlocked := TJabberSession(_JS).isBlocked(Item.Uid);
    if (IsBlocked) then
    begin
        if (Pres <> nil) then
        begin
            if (Pres.PresType = 'unavailable') then
                Show := 'offline_blocked'
            else
            begin
                Item.Active := true;
                Show := 'online_blocked'
            end;
        end
        else
            Show := 'offline_blocked'
    end;

    // If contact is pending or observer?
    try
       Subs :=  Item.Value['Subscription'];
       Ask  :=  Item.Value['Ask'];
       if (Subs = 'none') then
          if (Ask = 'subscribe') then
          begin
              IsPending := true;
              Show := 'pending';
          end
          else
              IsNone := true
       else if (Subs = 'from') then
       begin
           IsObserver := true;
           Show := 'observer';
       end;
    except

    end;


    //Figure out status text for the item
    //Need to have presence for extended text(status).
    if (Pres <> nil) then
    begin
        if (Pres.Status <> '') then
            Item.ExtendedText := Pres.Status
        else
            if (Pres.Show <> '') then
               Item.ExtendedText := Pres.Show
            else
               Item.ExtendedText := '';
    end;

    ImagePrefix := Item.Value['ImagePrefix'];

    // Setup the image
    _SetPresenceImage(Show, Item);

    if (IsNone) then
       Item.IsVisible := false;

    if (IsBlocked and _HideBlocked) then
        Item.IsVisible := false;

    if (IsPending and _HidePending) then
        Item.IsVisible := false;

    if (IsObserver and _HideObservers) then
        Item.IsVisible := false;

   if (IsOffline and _HideOffline) then
        Item.IsVisible := false;

   Tag.Free();
end;

{---------------------------------------}
procedure TContactController._PresCallback(Event: String; Tag: TXMLTag; Pres: TJabberPres);
var
    Item: IExodusItem;
    Tmp: TJabberID;
    wasVisible: Boolean;
begin

    if (Event = '/presence/error') then
        exit;

    if (Event = '/presence/subscription') then
        exit;

    //If my user own presence, ignore
    Tmp := TJabberID.Create(Pres.FromJid);
    if (Tmp.jid = TJabberSession(_JS).BareJid) then
        exit;

    Item := TJabberSession(_js).ItemController.GetItem(Pres.fromJid.jid);
    //Is this possible?
    if (Item = nil) then exit;

    wasVisible := Item.IsVisible;

    _UpdateContact(Item, Pres);

  if (Item.IsVisible) then
      if (wasVisible) then
          TJabberSession(_JS).FireEvent('/item/update', Item)
      else
          // notify the window that this item needs to be updated
          TJabberSession(_JS).FireEvent('/item/add', Item);

end;

{---------------------------------------}
procedure TContactController.Clear();
begin
    TJabberSession(_js).ItemController.ClearGroups();
    TJabberSession(_js).ItemController.ClearItems();
end;

{---------------------------------------}
procedure TContactController._SetPresenceImage(Show: Widestring; Item: IExodusItem);
begin
    Item.ImageIndex := _GetPresenceImage(Show, Item.Value['ImagePrefix']);
end;

{---------------------------------------}
function TContactController._GetPresenceImage(Show: Widestring; Prefix:WideString): integer;
begin
    if (Show = 'offline') then
        Result := RosterTreeImages.Find(Prefix + 'offline')
    else if (Show = 'away') then
        Result := RosterTreeImages.Find(Prefix + 'away')
    else if (Show = 'xa') then
        Result := RosterTreeImages.Find(Prefix + 'xa')
    else if (Show = 'dnd') then
        Result := RosterTreeImages.Find(Prefix + 'dnd')
    else if (Show = 'chat') then
        Result := RosterTreeImages.Find(Prefix + 'chat')
    else if (Show = 'pending') then
        Result := RosterTreeImages.Find(Prefix + 'pending')
    else if (Show = 'online_blocked') then
        Result := RosterTreeImages.Find(Prefix + 'online_blocked')
    else if (Show = 'offline_blocked') then
        Result := RosterTreeImages.Find(Prefix + 'offline_blocked')
    else if (Show = 'observer') then
        Result := RosterTreeImages.Find(Prefix + 'observer')
    else
        Result := RosterTreeImages.Find(Prefix + 'available');

end;

{---------------------------------------}
procedure TContactController._OnDisplayNameChange(bareJID: Widestring; DisplayName: WideString);
var
    Item: IExodusItem;
begin
    Item := TJabberSession(_js).ItemController.GetItem(bareJID);
    if (Item = nil) then exit;
    Item.Text := DisplayName;
    TJabberSession(_JS).FireEvent('/item/update', Item);
end;


end.
