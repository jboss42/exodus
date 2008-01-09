unit Roster;
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

interface

uses
    JabberID, Presence, Signals, Unicode, XMLTag,
    SysUtils, Classes;

type
    TJabberRosterItem = class
    private
        _nickname: WideString;
        function getNick(): Widestring;
        procedure fillTag(tag: TXMLTag);
    public
        jid: TJabberID;
        subscription: string;
        ask: string;
        Groups: TWideStringList;
        Data: TObject;

        constructor Create; overload;
        destructor Destroy; override;

        function xml: string;
        function IsOnline: boolean;

        procedure parse(tag: TXMLTag);
        procedure remove;
        procedure update;

        property RawNickname: Widestring read _nickname write _nickname;
        property Nickname: Widestring read getNick write _nickname;
    end;

    TJabberMyResource = class
    private
    public
        jid: TJabberID;
        Groups: TWidestringList;
        Data: TObject;
        Presence: TJabberPres;
        Resource: Widestring;
        item: TJabberRosterItem;

        constructor Create;
        destructor Destroy; override;
    end;

    TJabberBookmark = class
    public
        jid: TJabberID;
        bmType: string;
        bmName: string;
        nick: string;
        autoJoin: boolean;
        Data: TObject;

        constructor Create(tag: TXMLTag);
        destructor Destroy; override;

        function AddToTag(parent: TXMLTag): TXMLTag;
        procedure Copy(bm: TJabberBookmark);
    end;

    TRosterEvent = procedure(event: string; tag: TXMLTag; ritem: TJabberRosterItem) of object;
    TRosterListener = class(TSignalListener)
    public
    end;

    TRosterSignal = class(TSignal)
    public
        procedure Invoke(event: string; tag: TXMLTag; ritem: TJabberRosterItem = nil); overload;
        function addListener(callback: TRosterEvent): TRosterListener; overload;
    end;

    TJabberRoster = class(TWideStringList)
    private
        _js: TObject;
        _groups: TWidestringlist;
        _pres_cb: integer;

        procedure ParseFullRoster(event: string; tag: TXMLTag);
        procedure Callback(event: string; tag: TXMLTag);
        procedure bmCallback(event: string; tag: TXMLTag);
        procedure presCallback(event: string; tag: TXMLTag; pres: TJabberPres);
        procedure checkGroups(ri: TJabberRosterItem);
        procedure checkGroup(grp: Widestring);
        procedure fireBookmark(bm: TJabberBookmark);

        function getItem(index: integer): TJabberRosterItem;
        function getGroupList(grp_name: Widestring): TWidestringlist;

    public
        GrpList: TWideStringList;
        Bookmarks: TWideStringList;

        constructor Create;
        destructor Destroy; override;

        procedure Clear; override;

        procedure SetSession(js: TObject);
        procedure Fetch;
        procedure SaveBookmarks;

        procedure AddItem(sjid, nickname, group: Widestring; subscribe: boolean);
        procedure AddBookmark(sjid: Widestring; bm: TJabberBookmark);
        procedure RemoveBookmark(sjid: Widestring);
        procedure UpdateBookmark(bm: TJabberBookmark);

        function Find(sjid: Widestring): TJabberRosterItem; reintroduce; overload;
        function getGroupItems(grp: Widestring; online: boolean): TList;
        function getGroupCount(grp_name: Widestring; online: boolean): integer;

        property Items[index: integer]: TJabberRosterItem read getItem;
    end;

    TRosterAddItem = class
    private
        jid: string;
        grp: string;
        nick: string;
        do_subscribe: boolean;

        procedure AddCallback(event: string; tag: TXMLTag);
    public
        constructor Create(sjid, nickname, group: string; subscribe: boolean);
    end;

resourcestring
    sGrpBookmarks = 'Bookmarks';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberConst, iq, s10n,
    XMLUtils, Session;

{---------------------------------------}
constructor TJabberBookmark.Create(tag: TXMLTag);
begin
    //
    inherited Create();

    jid := nil;
    bmName := '';
    bmType := 'conference';
    nick := '';
    autoJoin := false;

    if (tag <> nil) then begin
        jid := TJabberID.Create(tag.GetAttribute('jid'));
        bmName := tag.getAttribute('name');
        autoJoin := SafeBool(tag.GetAttribute('autojoin'));
        bmType := tag.name;
        nick := tag.GetBasicText('nick');
    end;
end;

{---------------------------------------}
destructor TJabberBookmark.Destroy;
begin
    if (jid <> nil) then
        jid.Free;
    inherited Destroy;
end;

procedure TJabberBookmark.Copy(bm: TJabberBookmark);
begin
    bmType := bm.bmType;
    bmName := bm.bmName;
    nick := bm.nick;
    autoJoin := bm.autoJoin;
end;

{---------------------------------------}
function TJabberBookmark.AddToTag(parent: TXMLTag): TXMLTag;
begin
    // add this bookmark as another tag onto the parent
    Result := parent.AddTag(bmType);
    with Result do begin
        setAttribute('jid', jid.full);
        setAttribute('name', bmName);
        setAttribute('autojoin', BoolToStr(autoJoin));
        if (nick <> '') then
            AddBasicTag('nick', nick);
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberMyResource.Create;
begin
    //
    inherited;

    Groups := TWidestringList.Create();
    Data := nil;
    Presence := nil;
    Resource := '';
    item := nil;
end;

destructor TJabberMyResource.Destroy;
begin
    //
    Groups.Free();
    jid.Free();
    if (Data <> nil) then
        TObject(Data).Free();

    inherited Destroy;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberRosterItem.Create;
begin
    inherited;
    Groups := TWideStringList.Create;
    jid := TJabberID.Create('');
    subscription := 'none';
    _nickname := '';
    ask := '';
    Data := nil;
end;

{---------------------------------------}
destructor TJabberRosterItem.Destroy;
begin
    Groups.Free;
    jid.Free;

    if (Data <> nil) then
        TObject(Data).Free();

    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberRosterItem.fillTag(tag: TXMLTag);
var
    i: integer;
begin
    tag.name := 'item';
    tag.setAttribute('jid', jid.Full);
    tag.setAttribute('name', _nickname);

    for i := 0 to Groups.Count - 1 do
        tag.AddBasicTag('group', Groups[i]);

    if (subscription = 'remove') then
        tag.setAttribute('subscription', subscription);
end;

{---------------------------------------}
procedure TJabberRosterItem.Update;
var
    item, iq: TXMLTag;
begin
    iq := TXMLTag.Create('iq');
    iq.setAttribute('type', 'set');
    iq.setAttribute('id', MainSession.generateID());
    with iq.AddTag('query') do begin
        setAttribute('xmlns', XMLNS_ROSTER);
        item := AddTag('item');
        Self.fillTag(item);
    end;

    MainSession.SendTag(iq);
end;

{---------------------------------------}
procedure TJabberRosterItem.remove;
begin
    // remove this roster item from my roster;
    subscription := 'remove';
    update();
end;

{---------------------------------------}
function TJabberRosterItem.xml: string;
var
    x: TXMLTag;
begin
    x := TXMLTag.Create('item');
    Self.FillTag(x);
    Result := x.xml;
    x.Free;
end;

{---------------------------------------}
procedure TJabberRosterItem.parse(tag: TXMLTag);
var
    tmp_grp: string;
    grps: TXMLTagList;
    i: integer;
begin
    // fill the object based on the tag
    jid.ParseJID(tag.GetAttribute('jid'));
    subscription := tag.GetAttribute('subscription');
    ask := tag.GetAttribute('ask');
    if subscription = 'none' then subscription := '';
    _nickname := tag.GetAttribute('name');

    Groups.Clear;
    grps := tag.QueryXPTags('/item/group');
    for i := 0 to grps.Count - 1 do begin
        tmp_grp := Trim(TXMLTag(grps[i]).Data);
        if (tmp_grp <> '') then
            Groups.Add(TXMLTag(grps[i]).Data);
    end;
    grps.Free();
end;

{---------------------------------------}
function TJabberRosterItem.IsOnline: boolean;
begin
    Result := (MainSession.ppdb.FindPres(Self.jid.jid, '') <> nil);
end;

{---------------------------------------}
function TJabberRosterItem.getNick(): Widestring;
begin
    // either return the nickname, or the <user> part of the jid
    if (Trim(_nickname)) <> '' then
        result := _nickname
    else
        result := jid.user;
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberRoster.Create;
begin
    inherited;
    GrpList := TWideStringList.Create();
    Bookmarks := TWideStringList.Create();
    _groups := TWidestringlist.Create();
end;

{---------------------------------------}
destructor TJabberRoster.Destroy;
begin
    ClearStringListObjects(_groups);
    _groups.Free();

    {
    NB:
    The GrpList list contains group nodes in the treeview
    The Bookmarks list contains bm nodes in the treeview.
    We should NOT free these objects since they will be free'd
    when the window shuts down.
    }
    GrpList.Free;
    Bookmarks.Free;

    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberRoster.Clear;
begin
    // Free all the roster items.
    ClearStringListObjects(Bookmarks);
    ClearStringListObjects(GrpList);
    ClearStringListObjects(Self);
    ClearStringListObjects(_groups);

    Bookmarks.Clear;
    GrpList.Clear;
    _groups.Clear();

    inherited Clear();
end;

{---------------------------------------}
function TJabberRoster.getItem(index: integer): TJabberRosterItem;
begin
    // return a specific TJabberRosterItem from the Objects list
    if ((index < 0) or (index >= Self.Count)) then
        Result := nil
    else
        Result := TJabberRosterItem(Self.Objects[index]);
end;

{---------------------------------------}
procedure TJabberRoster.SetSession(js: TObject);
begin
    _js := js;
    with TJabberSession(_js) do begin
        RegisterCallback(Callback, '/packet/iq/query[@xmlns="jabber:iq:roster"]');
        _pres_cb := RegisterCallback(presCallback);
    end;
end;

{---------------------------------------}
procedure TJabberRoster.Fetch;
var
    js: TJabberSession;
    f_iq: TJabberIQ;
    bm_iq: TJabberIQ;
begin
    js := TJabberSession(_js);
    f_iq := TJabberIQ.Create(js, js.generateID(), ParseFullRoster, 180);
    with f_iq do begin
        iqType := 'get';
        toJID := '';
        Namespace := XMLNS_ROSTER;
        Send();
    end;

    bm_iq := TJabberIQ.Create(js, js.generateID(), bmCallback, 180);
    with bm_iq do begin
        iqType := 'get';
        toJid := '';
        Namespace := XMLNS_PRIVATE;
        with qtag.AddTag('bookmarks') do
            setAttribute('xmlns', XMLNS_BM);
        Send();
    end;
end;

{---------------------------------------}
procedure TJabberRoster.bmCallback(event: string; tag: TXMLTag);
var
    bms: TXMLTagList;
    i, idx: integer;
    stag: TXMLTag;
    bm: TJabberBookmark;
    jid: string;
begin
    // get all of the bm's
    if ((event = 'xml') and (tag.getAttribute('type') = 'result')) then begin
        // we got a response..
        {
        <iq type="set" id="jcl_4">
            <query xmlns="jabber:iq:private">
                <storage xmlns="storage:bookmarks">
                    <conference jid="jdev@conference.jabber.org"><nick>pgmillard</nick>
                    </conference>
                </storage>
        </query></iq>
        }

        stag := tag.QueryXPTag('/iq/query/storage');
        if (stag <> nil) then begin
            bms := stag.ChildTags();
            for i := 0 to bms.count -1  do begin
                jid := Lowercase(bms[i].GetAttribute('jid'));
                idx := Bookmarks.IndexOf(jid);
                if (idx >= 0) then begin
                    // remove the existing bm
                    TJabberBookmark(Bookmarks.Objects[idx]).Free;
                    Bookmarks.Delete(idx);
                end;
                bm := TJabberBookmark.Create(bms[i]);
                Bookmarks.AddObject(jid, bm);
                checkGroup(sGrpBookmarks);
            end;

            for i := 0 to Bookmarks.Count - 1 do
                FireBookmark(TJabberBookmark(Bookmarks.Objects[i]));
            bms.Free();
        end;
    end;
end;

{---------------------------------------}
procedure TJabberRoster.SaveBookmarks;
var
    s: TJabberSession;
    stag, iq: TXMLTag;
    i: integer;
begin
    // save bookmarks to jabber:iq:private
    s := TJabberSession(_js);

    iq := TXMLTag.Create('iq');
    with iq do begin
        setAttribute('type', 'set');
        setAttribute('id', s.generateID());
        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_PRIVATE);
            stag := AddTag('storage');
            stag.setAttribute('xmlns', XMLNS_BM);
            for i := 0 to Bookmarks.Count - 1 do
                TJabberBookmark(Bookmarks.Objects[i]).AddToTag(stag);
        end;
    end;
    s.SendTag(iq);
end;

{---------------------------------------}
procedure TJabberRoster.Callback(event: string; tag: TXMLTag);
var
    q: TXMLTag;
    ritems: TXMLTagList;
    ri: TJabberRosterItem;
    g, idx, i: integer;
    iq_type, j: Widestring;
    s: TJabberSession;
    grp_list: TWidestringlist;
    cur_grp: Widestring;
begin
    // callback from the session
    s := TJabberSession(_js);

    // this is some kind of roster push
    iq_type := tag.GetAttribute('type');
    if (iq_type <> 'set') then exit;

    // a roster push
    q := tag.GetFirstTag('query');
    if q = nil then exit;
    ritems := q.QueryTags('item');

    for i := 0 to ritems.Count - 1 do begin
        j := Lowercase(ritems[i].GetAttribute('jid'));
        ri := Find(j);

        if ri = nil then begin
            ri := TJabberRosterItem.Create;
            Self.AddObject(j, ri);
        end
        else begin
            // remove this JID from all old groups
            // before we reparse, etc..
            // xxx: there is a better way to do this (diffs)...
            // but we can always optimize later
            for g := 0 to ri.Groups.Count - 1 do begin
                cur_grp := ri.Groups[g];
                grp_list := getGroupList(cur_grp);
                if (grp_list <> nil) then begin
                    idx := grp_list.IndexOf(ri.jid.full);
                    if (idx >= 0) then
                        grp_list.Delete(idx);
                end;
            end;
        end;

        ri.parse(ritems[i]);
        checkGroups(ri);
        s.FireEvent('/roster/item', tag, ri);
        if (ri.subscription = 'remove') then begin
            idx := Self.indexOfObject(ri);
            ri.Free;
            Self.Delete(idx);
        end;
    end;

    ritems.Free();
end;

{---------------------------------------}
procedure TJabberRoster.presCallback(event: string; tag: TXMLTag; pres: TJabberPres);
var
    ri: TJabberRosterItem;
    i, idx: integer;
    cur_grp: Widestring;
    grp_list: TWidestringlist;
    insert: boolean;
begin
    // we are getting /preseence events
    if ((event = '/presence/online') or (event = '/presence/offline')) then begin
        // this JID is coming online... inc group counters
        insert := (event = '/presence/online');
        ri := Self.Find(pres.fromJid.jid);
        if (ri = nil) then
            ri := Self.Find(pres.fromJid.full);

        if (ri = nil) then exit;

        // iterate over all groups for this user.
        for i := 0 to ri.Groups.Count - 1 do begin
            cur_grp := ri.Groups[i];
            grp_list := getGroupList(cur_grp);

            // we didn't find a group.. assert here?
            if ((grp_list = nil) and (insert)) then begin
                grp_list := TWidestringlist.Create();
                _groups.AddObject(cur_grp, grp_list);
            end;
            idx := grp_list.IndexOf(ri.jid.full);

            // this jid isn't in the grp list.. assert here?
            if ((idx < 0) and (insert)) then idx := grp_list.add(ri.jid.full);

            if (insert) then
                grp_list.Objects[idx] := pres
            else
                grp_list.Objects[idx] := nil;
        end;
    end;
end;


{---------------------------------------}
function TJabberRoster.getGroupList(grp_name: Widestring): TWidestringlist;
var
    idx: integer;
begin
    idx := _groups.indexOf(grp_name);
    if (idx >= 0) then
        Result := TWidestringList(_groups.Objects[idx])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberRoster.GetGroupCount(grp_name: Widestring; online: boolean): integer;
var
    grp_list: TWidestringList;
    c, i: integer;
begin
    //
    Result := 0;
    grp_list := getGroupList(grp_name);
    if (grp_list <> nil) then begin

        if (not online) then begin
            Result := grp_list.Count;
            exit;
        end;

        // iterate through each JID...
        c := 0;
        for i := 0 to grp_list.Count - 1 do begin
            if (grp_list.Objects[i] <> nil) then inc(c);
        end;
        Result := c;
    end;
end;

{---------------------------------------}
procedure TJabberRoster.checkGroups(ri: TJabberRosterItem);
var
    g: integer;
    cur_grp: Widestring;
    grp_list: TWidestringlist;
    idx: integer;
begin
    // make sure the GrpList is populated.
    for g := 0 to ri.Groups.Count - 1 do begin
        cur_grp := ri.Groups[g];
        checkGroup(cur_grp);

        // make sure this grp exists
        grp_list := getGroupList(cur_grp);
        if (grp_list = nil) then begin
            grp_list := TWidestringList.Create();
            _groups.AddObject(cur_grp, grp_list);
        end;

        idx := grp_list.IndexOf(ri.jid.full);
        if (idx < 0) then
            grp_list.Add(ri.jid.full);
    end;
end;

{---------------------------------------}
procedure TJabberRoster.checkGroup(grp: Widestring);
begin
    if GrpList.indexOf(grp) < 0 then
        GrpList.Add(grp);

end;

{---------------------------------------}
function TJabberRoster.Find(sjid: Widestring): TJabberRosterItem;
var
    i: integer;
begin
    i := indexOf(Lowercase(sjid));
    if (i >= 0) and (i < Count) then
        Result := TJabberRosterItem(Objects[i])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberRoster.GetGroupItems(grp: Widestring; online: boolean): TList;
var
    i: integer;
    ri: TJabberRosterItem;
begin
    Result := TList.Create();
    for i := 0 to Self.Count - 1 do begin
        ri := Self.Items[i];
        if (ri.Groups.IndexOf(grp) >= 0) then begin
            if (((online) and (ri.IsOnline)) or (not online)) then
                Result.add(ri);
        end;
    end;
end;


{---------------------------------------}
procedure TJabberRoster.AddItem(sjid, nickname, group: Widestring; subscribe: boolean);
begin
    // send a iq-set
    TRosterAddItem.Create(sjid, nickname, group, subscribe);
end;

{---------------------------------------}
procedure TJabberRoster.FireBookmark(bm: TJabberBookmark);
var
    p: TXMLTag;
    t: TXMLTag;
begin
    p := TXMLTag.Create('bm');
    t := bm.AddToTag(p);
    with TJabberSession(_js) do
        FireEvent('/roster/bookmark', t);
    p.Free();
end;

{---------------------------------------}
procedure TJabberRoster.AddBookmark(sjid: Widestring; bm: TJabberBookmark);
var
    tbm : TJabberBookmark;
    i : integer;
begin
    // Add a new bookmark to the list,
    // save them, and fire out a new event
    i := Bookmarks.IndexOf(sjid);
    if (i >= 0) then begin
        tbm := TJabberBookmark(Bookmarks.Objects[i]);
        tbm.Copy(bm);
        bm.Free();
    end
    else begin
        Self.Bookmarks.AddObject(sjid, bm);
        tbm := bm;
    end;

    Self.SaveBookmarks();
    fireBookmark(tbm);
end;

{---------------------------------------}
procedure TJabberRoster.RemoveBookmark(sjid: Widestring);
var
    bm: TJabberBookmark;
    i: integer;
    t: TXMLTag;
begin
    // remove a bm from the list
    i := Bookmarks.IndexOf(sjid);
    if ((i >= 0) and (i < Bookmarks.Count)) then begin
        t := TXMLTag.Create('bm-delete');
        bm := TJabberBookmark(Bookmarks.Objects[i]);
        bm.AddToTag(t);
        TJabberSession(_js).FireEvent('/session/del-bookmark', t);
        t.Free();
        bm.Free();
        Bookmarks.Delete(i);
    end;
    Self.SaveBookmarks();
end;

{---------------------------------------}
procedure TJabberRoster.UpdateBookmark(bm: TJabberBookmark);
begin
    Self.SaveBookmarks();
    Self.fireBookmark(bm);
end;

{---------------------------------------}
procedure TJabberRoster.ParseFullRoster(event: string; tag: TXMLTag);
var
    ct, etag: TXMLTag;
    ritems: TXMLTagList;
    idx, i: integer;
    ri: TJabberRosterItem;
    s: TJabberSession;
    tmp_jid: TJabberID;
begin
    // parse the full roster push

    // Don't clear out the list.. we may have gotten roster pushes
    // in before this from mod_groups or something similar.

    s := TJabberSession(_js);

    if (event <> 'xml') then begin
        // timeout!
        if (s.Stream <> nil) then Self.Fetch();
    end

    else if (tag.GetAttribute('type') = 'error') then begin
        // some kind of roster fetch error
        etag := tag.GetFirstTag('error');
        if (etag <> nil) then begin
            if (etag.GetAttribute('code') = '404') then begin
                Self.Fetch();
                exit;
            end;
        end;

        // this will happen if people are not using
        // mod_roster, but using mod_groups or something
        // similar
        s.FireEvent('/roster/start', nil);
        s.FireEvent('/roster/end', nil);
        exit;
    end

    else begin
        // fire off the start event..
        // then cycle thru all the item tags
        s.FireEvent('/roster/start', tag);
        ritems := tag.QueryXPTags('/iq/query/item');
        for i := 0 to ritems.Count - 1 do begin
            ct := ritems.Tags[i];
            idx := Self.IndexOf(ct.GetAttribute('jid'));
            if (idx = -1) then
                ri := TJabberRosterItem.Create
            else
                ri := TJabberRosterItem(Self.Objects[idx]);
            ri.parse(ct);
            checkGroups(ri);
            if (idx = -1) then
                AddObject(Lowercase(ri.jid.Full), ri);
            s.FireEvent('/roster/item', ritems.Tags[i], ri);
        end;

        // I know this is evil... but lets just put in a "fake"
        // roster item which represents us.
        // this way, when we receive our own presence, we just
        // let the normal stuff render it.
        ct := TXMLTag.Create('item');
        tmp_jid := TJabberID.Create(s.Jid);
        ct.setAttribute('jid', tmp_jid.jid);
        tmp_jid.Free();
        ct.setAttribute('subscription', 'both');
        ct.setAttribute('name', s.Username);
        ri := TJabberRosterItem.Create();
        ri.parse(ct);
        Self.AddObject(Lowercase(ri.jid.Full), ri);
        s.FireEvent('/roster/item', ct, ri);
        ct.Free();

        ritems.Free();
        s.FireEvent('/roster/end', nil);
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TRosterAddItem.Create(sjid, nickname, group: string; subscribe: boolean);
var
    iq: TJabberIQ;
begin
    inherited Create();

    jid := sjid;
    nick := nickname;
    grp := group;
    do_subscribe := subscribe;

    iq := TJabberIQ.Create(MainSession, MainSession.generateID, Self.AddCallback);
    with iq do begin
        Namespace := XMLNS_ROSTER;
        iqType := 'set';
        with qTag.AddTag('item') do begin
            setAttribute('jid', jid);
            setAttribute('name', nick);
            if group <> '' then
                AddBasicTag('group', grp);
        end;
    end;
    iq.Send;
end;

{---------------------------------------}
procedure TRosterAddItem.AddCallback(event: string; tag: TXMLTag);
var
    iq_type: string;
begin
    // callback for the roster add.
    if (tag <> nil) then begin
        iq_type := tag.getAttribute('type');
        if (((iq_type = 'set') or (iq_type = 'result')) and (do_subscribe)) then
            SendSubscribe(jid, MainSession
            );
    end;

    Self.Free();
end;



{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function TRosterSignal.addListener(callback: TRosterEvent): TRosterListener;
var
    l: TRosterListener;
begin
    l := TRosterListener.Create();
    l.callback := TMethod(callback);
    inherited addListener('', l);
    Result := l;
end;

{---------------------------------------}
procedure TRosterSignal.Invoke(event: string; tag: TXMLTag; ritem: TJabberRosterItem = nil);
var
    i: integer;
    l: TRosterListener;
    cmp, e: string;
    sig: TRosterEvent;
begin
    // dispatch this to all interested listeners
    cmp := Lowercase(Trim(event));
    invoking := true;
    for i := 0 to Self.Count - 1 do begin
        e := Strings[i];
        l := TRosterListener(Objects[i]);
        sig := TRosterEvent(l.callback);
        if (e <> '') then begin
            // check to see if the listener's string is a substring of the event
            if (Pos(e, cmp) >= 1) then begin
                try
                    sig(event, tag, ritem);
                except
                    on x: Exception do
                        Dispatcher.handleException(Self, x, l, tag);
                end;
            end;
        end
        else begin
            try
                sig(event, tag, ritem);
            except
                on x: Exception do
                    Dispatcher.handleException(Self, x, l, tag);
            end;
        end;
    end;
    invoking := false;

    if change_list.Count > 0 then
        Self.processChangeList();

end;

end.

