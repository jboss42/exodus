unit NodeItem;
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

interface
uses
    Presence, JabberID, Unicode, XMLTag, SysUtils, Classes;

type
    TJabberNodeItem = class
    public
        function getText(): Widestring; virtual; abstract;
    end;

    TJabberNest = class(TJabberNodeItem)
    private
        _parent: TJabberNest;
        _name: Widestring;
        _grps: TWidestringlist;
    public
        Data: TObject;
        
        constructor Create(parent: TJabberNest; name: Widestring);
        destructor Destroy(); override;

        function getText(): Widestring; override;
        function getChild(name: Widestring): TJabberNodeItem;

        procedure AddChild(child: TJabberNodeItem);
        procedure removeChild(child: TJabberNodeItem);
    end;


    TJabberGroup = class(TJabberNodeItem)
    private
        _online: integer;           // # of users online
        _full: Widestring;          // full name of grp: a/b/c
        _parts: TWidestringlist;    // parts of the group name, parsed on a delim.
        _jids: TWidestringlist;     // jids of the people in this grp.

        function getNestLevel: integer;
        function getTotal: integer;
        function indexOfJid(jid: TJabberID): integer;
        function getNestIndex(idx: integer): Widestring;
        
        procedure setPresence(i: integer; p: TJabberPres); overload;
    public
        Data: TObject;              // Linked to a GUI element for this grp.

        constructor create(name: Widestring);
        destructor destroy; override;

        function getText(): Widestring; override;

        procedure AddJid(jid: Widestring); overload;
        procedure AddJid(jid: TJabberID); overload;
        procedure removeJid(jid: Widestring); overload;
        procedure removeJid(jid: TJabberID); overload;

        function inGroup(jid: Widestring): boolean; overload;
        function inGroup(jid: TJabberID): boolean; overload;

        procedure setPresence(jid: TJabberID; p: TJabberPres); overload;
        procedure setPresence(jid: Widestring; p: TJabberPres); overload;

        procedure getRosterItems(l: TList; online: boolean);

        property NestLevel: integer read getNestLevel;
        property Online: integer read _online;
        property Total: integer read getTotal;

        property FullName: Widestring read _full;
        property Parts[index: integer]: Widestring read getNestIndex;
    end;

    TJabberRosterItem = class(TJabberNodeItem)
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
        function getText(): Widestring; override;

        procedure parse(tag: TXMLTag);
        procedure remove;
        procedure update;

        property RawNickname: Widestring read _nickname write _nickname;
        property Nickname: Widestring read getNick write _nickname;
    end;

    TJabberMyResource = class(TJabberNodeItem)
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

        function getText(): Widestring; override;
    end;

    TJabberBookmark = class(TJabberNodeItem)
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

        function getText(): Widestring; override;
    end;


implementation
uses
    JabberConst, Session, XMLUtils;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberNest.Create(parent: TJabberNest; name: Widestring);
begin
    inherited Create;
    _parent := parent;
    _grps := TWidestringlist.Create();
    _name := name;
end;

{---------------------------------------}
destructor TJabberNest.Destroy();
begin
    _grps.Clear();
    inherited;
end;

{---------------------------------------}
function TJabberNest.getText(): Widestring;
begin
    Result := _name;
end;

{---------------------------------------}
procedure TJabberNest.AddChild(child: TJabberNodeItem);
var
    i: integer;
begin
    i := _grps.indexOf(child.getText());
    if (i = -1) then
        _grps.AddObject(child.getText(), child)
    else
        _grps.Objects[i] := child;
end;

{---------------------------------------}
function TJabberNest.getChild(name: Widestring): TJabberNodeItem;
var
    i: integer;
begin
    i := _grps.indexOf(name);
    if (i = -1) then
        Result := nil
    else
        Result := TJabberNodeItem(_grps.Objects[i]);
end;

{---------------------------------------}
procedure TJabberNest.removeChild(child: TJabberNodeItem);
var
    i: integer;
begin
    i := _grps.indexOf(child.getText());
    if (i >= 0) then
        _grps.Delete(i);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberGroup.Create(name: Widestring);
var
    l, s, i: integer;
    p: Widestring;
begin
    //
    _online := 0;
    _full := name;
    _parts := TWidestringlist.Create();
    _jids := TWidestringlist.Create();

    // xxx: actually parse for nested groups
    l := Length(name);
    s := 1;
    for i := 1 to Length(name) do begin
        if (name[i] = '/') then begin
            p := Copy(name, s, (i - s));
            _parts.Add(p);
            s := i + 1;
        end;
    end;

    // This should take care of the remainder.
    if (s < l) then begin
        p := Copy(name, s, l - s + 1);
        _parts.Add(p);
    end;

    //_parts.Add(name);
end;

{---------------------------------------}
destructor TJabberGroup.Destroy();
begin
    FreeAndNil(_parts);
    FreeAndNil(_jids);
end;

{---------------------------------------}
function TJabberGroup.getTotal: integer;
begin
    Result := _jids.Count;
end;

{---------------------------------------}
function TJabberGroup.getNestIndex(idx: integer): Widestring;
begin
    if (idx >= _parts.Count) then
        Result := ''
    else
        Result := _parts[idx];
end;

{---------------------------------------}
function TJabberGroup.getNestLevel: integer;
begin
    Result := _parts.Count;
end;

{---------------------------------------}
function TJabberGroup.GetText(): Widestring;
begin
    Result := _parts[_parts.Count - 1];
end;

{---------------------------------------}
function TJabberGroup.indexOfJid(jid: TJabberID): integer;
begin
    Result := _jids.IndexOf(jid.jid);
    if (Result = -1) then
        Result := _jids.IndexOf(jid.full);
end;

{---------------------------------------}
procedure TJabberGroup.AddJid(jid: Widestring);
begin
    if (_jids.indexOf(jid) = -1) then
        _jids.Add(jid);
end;

{---------------------------------------}
procedure TJabberGroup.AddJid(jid: TJabberID);
begin
    if (_jids.indexOf(jid.jid) = -1) then
        _jids.Add(jid.jid);
end;

{---------------------------------------}
procedure TJabberGroup.removeJid(jid: Widestring);
var
    i: integer;
begin
    i := _jids.IndexOf(jid);
    if (i >= 0) then begin
        if (_jids.Objects[i] <> nil) then begin
            dec(_online);
        end;
        _jids.Delete(i);
    end;
end;

{---------------------------------------}
procedure TJabberGroup.removeJid(jid: TJabberID);
var
    i: integer;
begin
    i := indexOfJid(jid);
    if (i >= 0) then begin
        if (_jids.Objects[i] <> nil) then begin
            dec(_online);
        end;
        _jids.Delete(i);
    end;
end;

{---------------------------------------}
function TJabberGroup.inGroup(jid: Widestring): boolean;
begin
    Result := (_jids.indexOf(jid) >= 0);
end;

{---------------------------------------}
function TJabberGroup.inGroup(jid: TJabberID): boolean;
begin
    Result := (indexOfJid(jid) >= 0);
end;

{---------------------------------------}
procedure TJabberGroup.setPresence(jid: TJabberID; p: TJabberPres);
var
    i: integer;
begin
    i := indexOfJid(jid);
    setPresence(i, p);
end;

{---------------------------------------}
procedure TJabberGroup.setPresence(jid: Widestring; p: TJabberPres);
var
    i: integer;
begin
    i := _jids.indexOf(jid);
    setPresence(i, p);
end;

{---------------------------------------}
procedure TJabberGroup.setPresence(i: integer; p: TJabberPres);
var
    o: TObject;
begin
    if (i = -1) then exit;

    // o is the old object, p is the new one.
    // if o != NULL, and p == NULL, then the user went offline.
    // if o == NULL, and p != NULL, then the user came online.

    o := TObject(_jids.Objects[i]);
    if (o <> nil) then begin
        if ((p = nil) or (p.PresType = 'unavailable')) then
            dec(_online);
    end
    else if (p <> nil) then
        inc(_online);

    if ((p <> nil) and (p.PresType = 'unavailable')) then
        _jids.Objects[i] := nil
    else
        _jids.Objects[i] := p;
end;

{---------------------------------------}
procedure TJabberGroup.getRosterItems(l: TList; online: boolean);
var
    ri: TJabberRosterItem;
    i: integer;
begin
    for i := 0 to _jids.Count - 1 do begin
        ri := MainSession.Roster.Find(_jids[i]);
        if ((online = false) or (_jids.Objects[i] <> nil)) then
            l.Add(ri);
    end;
end;

{---------------------------------------}
{---------------------------------------}
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

{---------------------------------------}
function TJabberBookmark.getText(): Widestring;
begin
    Result := bmName;
end;

{---------------------------------------}
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

{---------------------------------------}
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
function TJabberMyResource.getText(): Widestring;
begin
    Result := Resource;
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
function TJabberRosterItem.getText(): Widestring;
begin
    Result := Self.getNick();
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


end.
