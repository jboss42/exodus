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
    Signals,
    SysUtils, Classes;

type
    TJabberRosterItem = class
    private
        procedure fillTag(tag: TXMLTag);
    public
        jid: TJabberID;
        subscription: string;
        ask: string;
        nickname: string;
        Groups: TStringList;
        Data: TObject;

        constructor Create; overload;
        destructor Destroy; override;

        function xml: string;
        procedure parse(tag: TXMLTag);
        procedure remove;
        procedure update;
    end;

    TJabberBookmark = class
    public
        jid: TJabberID;
        bmType: string;
        name: string;
        nick: string;

        constructor Create(tag: TXMLTag);
        destructor Destroy; override;

        procedure AddToTag(parent: TXMLTag);
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

    TJabberRoster = class(TStringList)
    private
        _js: TObject;
        _callbacks: TList;
        procedure Callback(event: string; tag: TXMLTag);
        procedure bmCallback(event: string; tag: TXMLTag);
        procedure checkGroups(ri: TJabberRosterItem);
        procedure checkGroup(grp: string);
    public
        GrpList: TStringList;
        Bookmarks: TStringList;

        constructor Create;
        destructor Destroy; override;

        procedure Clear; override;

        procedure SetSession(js: TObject);
        procedure Fetch;
        procedure ParseFullRoster(tag: TXMLTag);
        procedure SaveBookmarks;

        procedure AddItem(sjid, nickname, group: string; subscribe: boolean);
        function Find(sjid: string): TJabberRosterItem; reintroduce; overload;
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
    iq,
    presence,
    s10n,
    XMLUtils,
    Session;

{---------------------------------------}
constructor TJabberBookmark.Create(tag: TXMLTag);
begin
    //
    inherited Create;
    jid := nil;
    name := '';
    bmType := 'conference';
    nick := '';

    if (tag <> nil) then begin
        jid := TJabberID.Create(tag.GetAttribute('jid'));
        name := tag.getAttribute('name');
        bmType := tag.name;
        nick := tag.GetBasicText('nick');
        end;
end;

{---------------------------------------}
destructor TJabberBookmark.Destroy;
begin
    jid.Free;
    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberBookmark.AddToTag(parent: TXMLTag);
begin
    // add this bookmark as another tag onto the parent
    with parent.AddTag(bmType) do begin
        putAttribute('jid', jid.full);
        putAttribute('name', name);
        if (nick <> '') then
            AddBasicTag('nick', nick);
        end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberRosterItem.Create;
begin
    inherited Create;

    Groups := TStringList.Create;
    jid := TJabberID.Create('');
    subscription := 'none';
    nickname := '';
    ask := '';
end;

{---------------------------------------}
destructor TJabberRosterItem.Destroy;
begin
    Groups.Free;
    jid.Free;

    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberRosterItem.fillTag(tag: TXMLTag);
var
    i: integer;
begin
    tag.name := 'item';
    tag.PutAttribute('jid', jid.Full);
    tag.PutAttribute('name', nickname);

    for i := 0 to Groups.Count - 1 do
        tag.AddBasicTag('group', Groups[i]);
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
    nickname := tag.GetAttribute('name');

    Groups.Clear;
    grps := tag.QueryXPTags('/item/group');
    for i := 0 to grps.Count - 1 do begin
        tmp_grp := Trim(TXMLTag(grps[i]).Data);
        if (tmp_grp <> '') then
            Groups.Add(TXMLTag(grps[i]).Data);
        end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberRoster.Create;
begin
    inherited Create;

    GrpList := TStringList.Create;
    _callbacks := TList.Create;
    Bookmarks := TStringList.Create;
end;

{---------------------------------------}
destructor TJabberRoster.Destroy;
begin
    GrpList.Free;
    _callbacks.Free;

    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberRoster.Clear;
begin
    // Free all the roster items.
    while Count > 0 do begin
        TJabberRosterItem(Objects[Count - 1]).Free;
        Delete(Count - 1);
        end;
    GrpList.Clear;
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
    x: TXMLTag;
    bm_iq: TJabberIQ;
begin
    js := TJabberSession(_js);
    x := TXMLTag.Create('iq');
    x.PutAttribute('id', js.generateID);
    x.PutAttribute('type', 'get');
    with x.AddTag('query') do
        PutAttribute('xmlns', XMLNS_ROSTER);
    js.SendTag(x);

    bm_iq := TJabberIQ.Create(js, js.generateID(), bmCallback);
    with bm_iq do begin
        iqType := 'get';
        toJid := '';
        Namespace := 'jabber:iq:private';
        with qtag.AddTag('bookmarks') do
            putAttribute('xmlns', 'storage:bookmarks');
        Send();
        end;
end;

{---------------------------------------}
procedure TJabberRoster.bmCallback(event: string; tag: TXMLTag);
var
    s: TJabberSession;
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

        s := TJabberSession(_js);
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
                s.FireEvent('/roster/bookmark', bms[i], TJabberRosterItem(nil));
                end;
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
    if iq_type = 'set' then begin
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
        end
    else begin
        // prolly a full roster
        ParseFullRoster(tag);
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
procedure TJabberRoster.checkGroup(grp: string);
begin
    if GrpList.indexOf(grp) < 0 then
        GrpList.Add(grp);
end;

{---------------------------------------}
function TJabberRoster.Find(sjid: string): TJabberRosterItem;
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
procedure TJabberRoster.AddItem(sjid, nickname, group: string; subscribe: boolean);
begin
    // send a iq-set
    TRosterAddItem.Create(sjid, nickname, group, subscribe);
end;

{---------------------------------------}
procedure TJabberRoster.ParseFullRoster(tag: TXMLTag);
var
    ct, qtag: TXMLTag;
    ritems: TXMLTagList;
    i: integer;
    ri: TJabberRosterItem;
    s: TJabberSession;
begin
    // parse the full roster push
    Self.Clear;
    s := TJabberSession(_js);
    qtag := tag.GetFirstTag('query');
    if qtag = nil then exit;

    s.FireEvent('/roster/start', tag);

    ritems := qtag.QueryTags('item');
    for i := 0 to ritems.Count - 1 do begin
        ct := ritems.Tags[i];
        ri := TJabberRosterItem.Create;
        ri.parse(ct);
        checkGroups(ri);
        AddObject(Lowercase(ri.jid.Full), ri);
        // Fire('item', ri, ct);
        s.FireEvent('/roster/item', ritems.Tags[i], ri);
        end;

    s.FireEvent('/roster/end', nil);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TRosterAddItem.Create(sjid, nickname, group: string; subscribe: boolean);
var
    iq: TJabberIQ;
begin
    inherited Create;

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
            SendSubscribe(jid, MainSession);
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
    Self.AddObject('', l);
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
end;

end.

