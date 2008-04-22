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
        Signals, DisplayName, COMExodusItem, ComObj, Unicode;

type
   TExodusContactsCallback = class;
   TContactController = class
   private
       _JS: TObject;
       _ItemsCB: TExodusContactsCallback;
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

       function AddItem(sjid, name, group: Widestring; subscribe: Boolean): IExodusItem;
       procedure RemoveItem(item: IExodusItem); overload;
       procedure RemoveItem(sjid: Widestring); overload;
       //Properties
   end;

  TExodusContactsCallback = class(TAutoIntfObject, IExodusItemCallback)
  private
    _contactCtrl: TContactController;
    _paused: Boolean;
    _ignoring: TWidestringList;

    constructor Create(cc: TContactController);

  protected
    property Paused: Boolean read _paused write _paused;

    function IsIgnored(sjid: Widestring): Boolean;
    procedure Ignore(sjid: Widestring);
    procedure Unignore(sjid: Widestring);
  public
    destructor Destroy(); override;

    procedure ItemDeleted(const item: IExodusItem); safecall;
    procedure ItemGroupsChanged(const item: IExodusItem); safecall;
  end;

  TContactOp = class
  private
    _ctrl: TContactController;
    _item: IExodusItem;
    _stype: Widestring;

  protected
    constructor Create(ctrl: TContactController; item: IExodusItem; stype: Widestring = '');
    procedure _Callback(event:String; tag:TXMLTag); virtual;

    property Controller: TContactController read _ctrl;
    property Item: IExodusItem read _item;
  end;
  TContactAddItemOp = class(TContactOp)
  private
    _subscribe: boolean;

  protected
    constructor Create(ctrl: TContactController; item: IExodusItem; subscribe: Boolean);

    property Subscribe: Boolean read _subscribe;
    procedure _Callback(event: String; tag: TXMLTag); override;
  end;
  TContactRemItemOp = class(TContactOp)
  private

  protected
    constructor Create(ctrl: TContactController; item: IExodusItem);

    procedure _Callback(event: String; tag: TXMLTag); override;
  end;

implementation
uses IQ, JabberConst, JabberID, SysUtils,
     Session, s10n, RosterImages, COMExodusItemWrapper, ComServ;

{---------------------------------------}
constructor TContactController.Create(JS: TObject);
begin
    _JS := JS;
    _ItemsCB := TExodusContactsCallback.Create(Self);
    _SessionCB := TJabberSession(_JS).RegisterCallback(_SessionCallback, '/session');
    _IQCB := TJabberSession(_JS).RegisterCallback(_IQCallback, '/packet/iq[@type="set"]/query[@xmlns="jabber:iq:roster"]'); //add type set, skip results
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

    _ItemsCB._Release();
    _ItemsCB := nil;
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
        _ItemsCB.Paused := true;
        TJabberSession(_JS).FireEvent('/item/begin', Item);
        ContactItemTags := Tag.QueryXPTags('/iq/query/item');
        for i := 0 to ContactItemTags.Count - 1 do begin
            ContactTag := ContactItemTags.Tags[i];
            TmpJID := TJabberID.Create(ContactTag.GetAttribute('jid'));
            Item := TJabberSession(_js).ItemController.AddItemByUid(TmpJID.full, EI_TYPE_CONTACT, _ItemsCB);
            //Make sure item exists
            if (Item <> nil) then
            begin
                _ParseContact(Item, ContactTag);

                if (Item.IsVisible) then
                    TJabberSession(_JS).FireEvent('/item/add', Item);
            end;
            //DisplayName.getDisplayNameCache().UpdateDisplayName(TmpJID.jid);
            TmpJID.Free();
        end;
        //TJabberSession(_js).ItemController.SaveGroups();
        Item := nil;
        _ItemsCB.Paused := false;
        TJabberSession(_JS).FireEvent('/item/end', Item);
        TJabberSession(_JS).FireEvent('/data/item/group/restore', nil, '');

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
    Contact.Text := Tag.GetAttribute('name');
    TmpJid := TJabberID.Create(Tag.GetAttribute('jid'));
    Contact.value['Name'] := Tag.GetAttribute('name');
    Contact.value['Subscription'] := Tag.GetAttribute('subscription');
    Contact.value['Ask'] := Tag.GetAttribute('ask');
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
            end;

        end;
    end;
    
    if (Contact.GroupCount = 0) then
    begin
        Contact.AddGroup(_DefaultGroup);
    end;
    //Make sure groups for the contact exist in the global group list.
    //_SynchronizeGroups(Contact);

    if TJabberSession(_JS).IsBlocked(TmpJid) then
        Contact.value['blocked'] := 'true'
    else
        Contact.value['blocked'] := 'false';

    Grps.Free();
    TmpJid.Free();
end;

{---------------------------------------}
procedure TContactController._SessionCallback(Event: string; Tag: TXMLTag);
var
    uid: Widestring;
    item: IExodusItem;
    Pres: TJabberPres;
begin
     if Event = '/session/authenticated'  then
     begin
         _HideBlocked := TJabberSession(_JS).Prefs.getBool('roster_hide_block');
         _HideOffline := TJabberSession(_JS).Prefs.getBool('roster_only_online');
         _HidePending := not TJabberSession(_JS).Prefs.getBool('roster_show_pending');
         _HideObservers := not TJabberSession(_JS).Prefs.getBool('roster_show_observers');
         _UseDisplayName := TJabberSession(_JS).Prefs.getBool('displayname_profile_enabled');
         _DefaultGroup := TJabberSession(_JS).Prefs.getString('roster_default');
         _GetContacts();
     end
     else if Event = '/session/prefs' then
     begin
         _HideBlocked := TJabberSession(_JS).Prefs.getBool('roster_hide_block');
         _HideOffline := TJabberSession(_JS).Prefs.getBool('roster_only_online');
         _HidePending := not TJabberSession(_JS).Prefs.getBool('roster_show_pending');
         _HideObservers := not TJabberSession(_JS).Prefs.getBool('roster_show_observers');
         _UseDisplayName := TJabberSession(_JS).Prefs.getBool('displayname_profile_enabled');
         if (_DefaultGroup <> TJabberSession(_JS).Prefs.getString('roster_default')) then
         begin
             _DefaultGroup := TJabberSession(_JS).Prefs.getString('roster_default');
         end;
         _UpdateContacts();
     end
     else if Event = '/session/block' then
     begin
         uid := Tag.GetAttribute('jid');
         item := TJabberSession(_js).ItemController.GetItem(uid);

         if (item <> nil) then
         begin
             item.value['blocked'] := 'true';
             pres := TJabberSession(_JS).ppdb.FindPres(Item.uid, '');
             //We need to obtain new image and see if blocked items are visible
             _UpdateContact(Item, pres);
             if (Item.IsVisible) then
                 TJabberSession(_JS).FireEvent('/item/add',  Item)
             else
                 TJabberSession(_JS).FireEvent('/item/remove', Item);
         end;
     end
     else if Event = '/session/unblock' then
     begin
         uid := Tag.GetAttribute('jid');
         item := TJabberSession(_js).ItemController.GetItem(uid);
         if (item <> nil) then
         begin
             item.value['blocked'] := 'false';
             pres := TJabberSession(_JS).ppdb.FindPres(Item.uid, '');
              //We need to obtain new image and see if blocked items are visible
             _UpdateContact(Item, pres);
             if (Item.IsVisible) then
                 TJabberSession(_JS).FireEvent('/item/add',  Item)
             else
                 TJabberSession(_JS).FireEvent('/item/remove', Item);
         end;
     end;
end;

{---------------------------------------}
procedure TContactController._IQCallback(Event: String; Tag: TXMLTag);
var
    query: TXMLTag;
    riTag: TXMLTag;
    riList: TXMLTagList;
    idx: Integer;
    uid, subscr, ask: Widestring;
    item: IExodusItem;
    itemCtrl: IExodusItemController;
    session: TJabberSession;
begin
    if (Tag <> nil) then
        query := Tag.GetFirstTag('query')
    else
        query := nil;

    if (query <> nil) then
        riList := query.ChildTags
    else
        riList := TXMLTagList.Create();

    session := TJabberSession(_JS);
    itemCtrl := session.ItemController;
    for idx := 0 to riList.Count - 1 do begin
        riTag := riList[idx];
        uid := riTag.GetAttribute('jid');
        subscr := riTag.GetAttribute('subscription');
        ask := riTag.GetAttribute('ask');
        item := itemCtrl.GetItem(uid);

        if (subscr = 'remove') and (item <> nil) then begin
            //removing...make sure it disappears
            itemCtrl.RemoveItem(uid);
            session.FireEvent('/item/remove', item);
            SendUnSubscribe(uid, session);
        end
        else if (item <> nil) then begin
            //some sort of update
            _ParseContact(item, riTag);
            _UpdateContact(item, MainSession.ppdb.FindPres(item.UID, ''));
            if item.IsVisible then
                session.FireEvent('/item/add', item)
            else
                session.FireEvent('/item/remove', item);
        end;
    end;
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
    session: TJabberSession;
begin
    session := TJabberSession(_JS);
    Tag := TXMLTag.Create();
    Item := nil;

    session.FireEvent('/data/item/group/save', nil, '');
    session.FireEvent('/item/begin', Item);
    for i := 0 to session.ItemController.ItemsCount - 1 do
    begin
        Item := session.ItemController.Item[i];
        if (Item.Type_ <> EI_TYPE_CONTACT) then continue;

        pres := session.ppdb.FindPres(Item.uid, '');
        _UpdateContact(Item, pres);
        if (Item.IsVisible) then
            TJabberSession(_JS).FireEvent('/item/add',  Item)
        else
            TJabberSession(_JS).FireEvent('/item/remove', Item)

    end;
    session.FireEvent('/data/item/group/restore', nil, '');
    session.FireEvent('/item/end', Item);
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

    //Make sure the item is contact.
    if (Item.Type_ <> EI_TYPE_CONTACT) then exit;
    
    wasVisible := Item.IsVisible;

    _UpdateContact(Item, Pres);

  if (Item.IsVisible) then
      if (wasVisible) then
          TJabberSession(_JS).FireEvent('/item/update', Item)
      else
          // notify the window that this item needs to be updated
          TJabberSession(_JS).FireEvent('/item/add', Item)
  else
      TJabberSession(_JS).FireEvent('/item/remove', Item);

end;

{---------------------------------------}
{
procedure TContactController.Clear();
begin
    TJabberSession(_js).ItemController.ClearItems();
end;
}

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

function TContactController.AddItem(
        sjid: WideString;
        name: WideString;
        group: WideString;
        subscribe: Boolean) : IExodusItem;
var
    session: TJabberSession;
    itemCtlr: IExodusItemController;
    state: Widestring;
begin
    session := TJabberSession(_js);
    itemCtlr := session.ItemController;
    Result := itemCtlr.GetItem(sjid);
    if (Result = nil) then begin
        _ItemsCB.Ignore(sjid);
        //Actual item creation!
        Result := itemCtlr.AddItemByUid(sjid, EI_TYPE_CONTACT, _ItemsCB);
        Result.value['Name'] := name;
        Result.value['Subscription'] := 'none';
        if (group <> '') then begin
            Result.AddGroup(group);
        end;
        _UpdateContact(Result);
        _ItemsCB.Unignore(sjid);
    end
    else begin
        state := Result.value['Subscription'];
        if ((state = 'both') or (state = 'to')) and
                ((group <> '') and not Result.BelongsToGroup(group)) then begin
            //just update the groups this contact belongs to, and bail
            Result.AddGroup(group);
            session.FireEvent('/item/update', Result);
            exit;
        end;
    end;

    //now we inform the server...
    TContactAddItemOp.Create(Self, Result, subscribe);
end;
procedure TContactController.RemoveItem(item: IExodusItem);
begin
    if (item = nil) or (item.Type_ <> 'contact') then exit;
    TContactRemItemOp.Create(Self, item);
end;
procedure TContactController.RemoveItem(sjid: WideString);
begin
    RemoveItem(TJabberSession(_JS).ItemController.GetItem(sjid));
end;

constructor TExodusContactsCallback.Create(cc: TContactController);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusItemCallback);

    _contactCtrl := cc;
    _ignoring := TWidestringList.Create;
    _AddRef();
end;
destructor TExodusContactsCallback.Destroy;
begin
    _ignoring.Free();

    inherited;
end;

function TExodusContactsCallback.IsIgnored(sjid: WideString): Boolean;
begin
    Result := (_ignoring.IndexOf(sjid) <> -1);
end;
procedure TExodusContactsCallback.Ignore(sjid: WideString);
begin
    _ignoring.Add(sjid);
end;
procedure TExodusContactsCallback.Unignore(sjid: WideString);
var
    idx: Integer;
begin
    idx := _ignoring.IndexOf(sjid);
    if (idx <> -1) then _ignoring.Delete(idx);
end;

procedure TExodusContactsCallback.ItemDeleted(const item: IExodusItem);
begin
    if Paused then exit;
    if IsIgnored(item.UID) then exit;
    
    _contactCtrl.RemoveItem(item);
end;
procedure TExodusContactsCallback.ItemGroupsChanged(const item: IExodusItem);
begin
    if Paused then exit;
    if IsIgnored(item.UID) then exit;
    
    TContactOp.Create(_contactCtrl, item);
end;

constructor TContactOp.Create(
        ctrl: TContactController;
        item: IExodusItem;
        stype: WideString);
var
    session: TJabberSession;
    iq: TJabberIQ;
    idx: Integer;
begin
    _ctrl := ctrl;
    _item := item;
    _stype := stype;

    session := TJabberSession(_ctrl._JS);
    iq := TJabberIQ.Create(session, session.generateID, Self._Callback);
    with iq do begin
        Namespace := XMLNS_ROSTER;
        iqType := 'set';
        with qTag.AddTag('item') do begin
            setAttribute('jid', item.UID);
            setAttribute('name', item.value['Name']);
            if (_stype <> '') then
                setAttribute('subscription', _stype);

            if (_stype <> 'remove') then begin
                for idx := 0 to item.GroupCount - 1 do begin
                    AddBasicTag('group', item.Group[idx]);
                end;
            end;
       end;
    end;

    iq.Send();
end;
procedure TContactOp._Callback(event: string; tag: TXMLTag);
var
    session: TJabberSession;
begin
    if (tag <> nil) and (tag.GetAttribute('type') = 'result') then begin
        session := TJabberSession(Controller._JS);

        if item.IsVisible then
            session.FireEvent('/item/update', item);
    end;

    Self.Free();
end;

constructor TContactAddItemOp.Create(
        ctrl: TContactController;
        item: IExodusItem;
        subscribe: Boolean);
var
    session: TJabberSession;
    iq: TJabberIQ;
    idx: Integer;
begin
    _subscribe := subscribe;

    inherited Create(ctrl, item);
end;
procedure TContactAddItemOp._Callback(event: string; tag: TXMLTag);
var
    session: TJabberSession;
begin
    if (tag <> nil) and (tag.GetAttribute('type') = 'result') then begin
        session := TJabberSession(Controller._JS);

        if Subscribe then
            SendSubscribe(item.UID, session);

        if item.IsVisible then
            session.FireEvent('/item/update', item);
    end;

    Self.Free();
end;

constructor TContactRemItemOp.Create(ctrl: TContactController; item: IExodusItem);
var
    session: TJabberSession;
    iq: TJabberIQ;
begin
    inherited Create(ctrl, item, 'remove');
end;
procedure TContactRemItemOp._Callback(event: string; tag: TXMLTag);
var
    session: TJabberSession;
begin
    if (tag <> nil) and (tag.GetAttribute('type') = 'result') then begin
        session := TJabberSession(Controller._JS);

        //TODO:  allow flag here??
        SendUnSubscribe(item.UID, session);
        SendUnSubscribed(item.UID, session);
    end;
end;

end.
