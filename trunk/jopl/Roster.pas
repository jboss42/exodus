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
    XMLTag,
    JabberID,
    Unicode, Signals,
    SysUtils, Classes;

type
    TJabberRosterItem = class
    private
        _nickname: string;
        function getNick(): string;
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

        property RawNickname: string read _nickname write _nickname;
        property Nickname: string read getNick write _nickname;
    end;

    TJabberBookmark = class
    public
        jid: TJabberID;
        bmType: string;
        bmName: string;
        nick: string;
        Data: TObject;

        constructor Create(tag: TXMLTag);
        destructor Destroy; override;

        function AddToTag(parent: TXMLTag): TXMLTag;
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
        procedure ParseFullRoster(event: string; tag: TXMLTag);
        procedure Callback(event: string; tag: TXMLTag);
        procedure bmCallback(event: string; tag: TXMLTag);
        procedure checkGroups(ri: TJabberRosterItem);
        procedure checkGroup(grp: Widestring);
        procedure fireBookmark(bm: TJabberBookmark);
        function getItem(index: integer): TJabberRosterItem;
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
        function GetGroupItems(grp: Widestring; online: boolean): TList;

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



{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberConst, iq,
    presence,
    s10n,
    XMLUtils,
    Session;

{---------------------------------------}
constructor TJabberBookmark.Create(tag: TXMLTag);
begin
    //
    inherited Create();

    jid := nil;
    bmName := '';
    bmType := 'conference';
    nick := '';

    if (tag <> nil) then begin
        jid := TJabberID.Create(tag.GetAttribute('jid'));
        bmName := tag.getAttribute('name');
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

{---------------------------------------}
function TJabberBookmark.AddToTag(parent: TXMLTag): TXMLTag;
begin
    // add this bookmark as another tag onto the parent
    Result := parent.AddTag(bmType);
    with Result do begin
        putAttribute('jid', jid.full);
        putAttribute('name', bmName);
        if (nick <> '') then
            AddBasicTag('nick', nick);
        end;
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
    tag.PutAttribute('jid', jid.Full);
    tag.PutAttribute('name', _nickname);

    for i := 0 to Groups.Count - 1 do
        tag.AddBasicTag('group', Groups[i]);

    if (subscription = 'remove') then
        tag.PutAttribute('subscription', subscription);
end;

{---------------------------------------}
procedure TJabberRosterItem.Update;
var
    item, iq: TXMLTag;
begin
    iq := TXMLTag.Create('iq');
    iq.PutAttribute('type', 'set');
    iq.PutAttribute('id', MainSession.generateID());
    with iq.AddTag('query') do begin
        putAttribute('xmlns', XMLNS_ROSTER);
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
function TJabberRosterItem.getNick(): string;
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
    GrpList := TWideStringList.Create;
    Bookmarks := TWideStringList.Create;
end;

{---------------------------------------}
destructor TJabberRoster.Destroy;
begin

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
    Bookmarks.Clear;
    GrpList.Clear;

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
    with TJabberSession(_js) do
        RegisterCallback(Callback, '/packet/iq/query[@xmlns="jabber:iq:roster"]');
end;

{---------------------------------------}
procedure TJabberRoster.Fetch;
var
    js: TJabberSession;
    f_iq: TJabberIQ;
    bm_iq: TJabberIQ;
begin
    js := TJabberSession(_js);
    f_iq := TJabberIQ.Create(js, js.generateID(), ParseFullRoster);
    with f_iq do begin
        iqType := 'get';
        toJID := '';
        Namespace := XMLNS_ROSTER;
        Send();
        end;

    bm_iq := TJabberIQ.Create(js, js.generateID(), bmCallback);
    with bm_iq do begin
        iqType := 'get';
        toJid := '';
        Namespace := XMLNS_PRIVATE;
        with qtag.AddTag('bookmarks') do
            putAttribute('xmlns', XMLNS_BM);
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
    if (event = 'xml') then begin
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
                checkGroup('Bookmarks');
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
        putAttribute('type', 'set');
        putAttribute('id', s.generateID());
        with AddTag('query') do begin
            putAttribute('xmlns', XMLNS_PRIVATE);
            stag := AddTag('storage');
            stag.PutAttribute('xmlns', XMLNS_BM);
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
    idx, i: integer;
    iq_type, j: string;
    s: TJabberSession;
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
end;

{---------------------------------------}
procedure TJabberRoster.checkGroups(ri: TJabberRosterItem);
var
    g: integer;
    cur_grp: string;
begin
    // make sure the GrpList is populated.
    for g := 0 to ri.Groups.Count - 1 do begin
        cur_grp := ri.Groups[g];
        checkGroup(cur_grp);
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
        tbm.bmName := bm.bmName;
        tbm.nick := bm.nick;
        end
    else
        Self.Bookmarks.AddObject(sjid, bm);

    Self.SaveBookmarks();
    fireBookmark(bm);
end;

{---------------------------------------}
procedure TJabberRoster.RemoveBookmark(sjid: Widestring);
var
    i: integer;
begin
    // remove a bm from the list
    i := Bookmarks.IndexOf(sjid);
    if ((i >= 0) and (i < Bookmarks.Count)) then begin
        TJabberBookmark(Bookmarks.Objects[i]).Free;
        Bookmarks.Delete(i);
        end;
    Self.SaveBookmarks();
    // todo: Fire an event here to tell everyone we nuked a BM???
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
begin
    // parse the full roster push

    // Don't clear out the list.. we may have gotten roster pushes
    // in before this from mod_groups or something similar.

    s := TJabberSession(_js);

    if (event <> 'xml') then begin
        // timeout!
        Self.Fetch();
        end

    else if (tag.GetAttribute('type') = 'error') then begin
        // some kind of roster fetch error
        etag := tag.QueryXPTag('/iq/error');
        if (etag <> nil) then begin
            if (etag.GetAttribute('code') = '404') then
                Self.Fetch();
            end;
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
            PutAttribute('jid', jid);
            PutAttribute('name', nick);
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
            if (Pos(e, cmp) >= 1) then
                sig(event, tag, ritem);
            end
        else
            sig(event, tag, ritem);
        end;
    invoking := false;

    if change_list.Count > 0 then
        Self.processChangeList();

end;

end.

