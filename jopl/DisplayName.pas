unit DisplayName;
{
    Copyright 2007, Peter Millard

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
    RegExpr,
    Unicode,
    XMLTag,
    JabberID,
    IQ,     //profile request
    COMExodusItem,
    ContactController,
    Exodus_TLB; 
//    Roster; //roster callback
const
    PREF_PROFILE_DN = 'displayname_profile_enabled';
    PREF_PROFILE_DN_MAP = 'displayname_profile_map';
    PROFILE_DN_MAP_START_DELIM = '{';
    PROFILE_DN_MAP_END_DELIM = '}';

type
    TDisplayNameType = (dntRoster, dntProfile, dntNode);

    TDisplayNameChangeEvent = procedure(bareJID: Widestring; displayName: WideString) of object;

    TDisplayNameListener = class
    private
        _DNCB: Integer;
        _OnDisplayNameChange: TDisplayNameChangeEvent;
    protected
        procedure fireOnDisplayNameChange(bareJID: Widestring; displayName: WideString);virtual;
    public
        Constructor Create();
        Destructor Destroy();override;

        function getDisplayName(bareJID: TJabberID; out pendingNameChange: boolean): WideString;overload;
        function getDisplayName(bareJID: TJabberID): WideString;overload;
        function getProfileDisplayName(bareJID: TJabberID; out pendingNameChange: boolean): WideString;

        function ProfileEnabled(): Boolean;
    published
        property OnDisplayNameChange: TDisplayNameChangeEvent read _OnDisplayNameChange write _OnDisplayNameChange;
        procedure DNCallback(event: string; tag: TXMLTag);
    end;

        {a helper class for profile prefs}
    TProfileParser = class
    private
        _regEx: TRegExpr;
        _parsedProfileMap: TWidestringList;
        _profileMapStr: Widestring;

    public
        Constructor Create();
        Destructor  Destroy();override;

        procedure setProfileParseMap(profileMap: Widestring);
        function parseProfile(profileTag: TXMLTag; var displayName: WideString): boolean;
        property ProfileMapString: WideString read _profileMapStr;
    published
    end;

    {
        An entry in the display name cache.
    }
    TDisplayNameItem = class
    private
        _displayName:   array[dntRoster..dntNode] of WideString;

        _jid:               TJabberID;

        _fetchFailed:       Boolean;  //have we attempted a profile fetch before?
        _profileIQ:         TJabberIQ;

        _profileParser:     TProfileParser;
        _lastDisplayName:   WideString;

        function getProfileEnabled(): Boolean;
    public
        constructor create(jid: TJabberID; profileParser: TProfileParser);
        destructor  Destroy();override;

        function getProfileDisplayName(out pendingNameChange: boolean; ignorePending: boolean=false): WideString;
        function getDisplayName(out pendingNameChange: boolean; ignorePending: boolean=false): WideString;
    published
        procedure ProfileCallback(event: string; tag: TXMLTag);
        property ProfileEnabled: Boolean read getProfileEnabled;
    end;

    TDisplayNameCache = class
    private
        _dnCache:   TWideStringList;
        _sessionCB: Integer;
        //_rosterCB:  Integer;
        _js:        TObject; //TjabberSession, use TObject to avoid circular ref issues
                             //DNCache is initialized in session object
        _profileParser: TProfileParser;

        function getOrAddDNItem(jid: TJabberID): TDisplayNameItem;


    protected
        //list management
        function getDNItem(jid: TJabberID): TDisplayNameItem;
        procedure removeDNItem(dnItem: TDisplayNameItem);
        procedure addDNItem(dnItem: TDisplayNameItem);
        procedure clearDNCache();
    public
        Constructor create();
        Destructor Destroy(); override;

        function getDisplayName(jid: TJabberID; out pendingNameChange: boolean; ignorePending: boolean=false): Widestring;overload;
        function getDisplayName(jid: TJabberID): Widestring;overload;
        function getDisplayNameAndFullJID(jid: TJabberID): Widestring;
        function getDisplayNameAndBareJID(jid: TJabberID): Widestring;

        function getProfileDisplayName(jid: TJabberID; out pendingNameChange: boolean): WideString;
        procedure setSession(js: TObject); //TObject to avoid circular reference\
        procedure UpdateDisplayName(uid: WideString);
    published
            //callbacks
        //procedure RosterCallback(event: string; item: IExodusItem);
        procedure SessionCallback(event: string; tag: TXMLTag);

        property ProfileParser: TProfileParser read _profileParser;
    end;

    TDisplayName = class

    end;

    {pref functions}
    function useProfileDN(): boolean;
    function getProfileDNMap(): WideString;

    {Singleton accessor}
    function getDisplayNameCache(): TDisplayNameCache;

implementation
uses
    SysUtils,
    Session;
var
    _dnCache: TDisplayNameCache;

const
    PROFILE_MAP_REGEX = '{[A-Za-z0-9]*}';

function getDisplayNameCache(): TDisplayNameCache;
begin
    Result := _dnCache;
end;

function useProfileDN(): boolean;
begin
    Result := Session.MainSession.Prefs.getBool(PREF_PROFILE_DN);
end;

function getProfileDNMap(): WideString;
begin
    Result := '';
    if (useProfileDN()) then
        Result := Session.MainSession.Prefs.getString(PREF_PROFILE_DN_MAP);
end;

{-------------------------------------------------------------------------------
 ---------------------------- TDNMyJIDListener ---------------------------------
 ------------------------------------------------------------------------------}
{ a helper class to set our nickname from profile}
type
    TMyNickHandler = class(TDisplayNameListener)
        jid: TJabberID;
        procedure fireOnDisplayNameChange(bareJID: Widestring; displayName: WideString);override;
        procedure getProfileName(myJID: TJabberID);

        destructor Destroy();override;
    end;

destructor TMyNickHandler.Destroy();
begin
    jid.Free();
    jid := nil;
    inherited;
end;

procedure TMyNickHandler.fireOnDisplayNameChange(bareJID: Widestring; displayName: WideString);
begin
    if ((jid <> nil) and (jid.jid = bareJID)) then begin
        MainSession.Prefs.setString('default_nick', displayName);
        Self.Free();
    end;
end;

procedure TMyNickHandler.getProfileName(myJID: TJabberID);
var
    changePending: boolean;
    dname: WideString;
begin
    jid := TJabberID.Create(myJID);//save jid for later dispname change event
    dName := Self.getProfileDisplayName(myJID, changePending);
    if (not changePending) then begin
        MainSession.Prefs.setString('default_nick', dName);
        Self.Free();
    end;
end;

{-------------------------------------------------------------------------------
 ------------------------ TDisplayNameListener ---------------------------------
 ------------------------------------------------------------------------------}
Constructor TProfileParser.Create();
begin
    _parsedProfileMap := TWidestringList.Create();
    _profileMapStr := '';
    _regEx := TRegExpr.Create();
    _regEx.Expression := PROFILE_MAP_REGEX;
    _regEx.Compile();
end;

Destructor  TProfileParser.Destroy();
begin
    _parsedProfileMap.Free();
end;

procedure TProfileParser.setProfileParseMap(profileMap: Widestring);
begin
    _profileMapStr := profileMap;
end;

function TProfileParser.parseProfile(profileTag: TXMLTag; var displayName: WideString): boolean;
var
    strPos: integer;
    tstr: WideString;
    key: WideString;
    tags: TXMLTagList;
    foundAll: boolean;
begin
    strPos := 1;
    foundAll := true;
    if (_regEx.Exec(_profileMapStr)) then begin
        repeat
            displayName := displayName + Copy(_profileMapStr, strPos, _regEx.MatchPos[0] - strPos);
            tstr := _regEx.Match[0];
            key := WideUpperCase(Copy(tstr, 2, Length(tstr) - 2)); //strip {}
            tags := profileTag.QueryRecursiveTags(key, true);
            if ((tags.Count > 0) and (Trim(tags[0].Data) <> '')) then
                displayName := displayName + tags[0].data
            else begin
                displayName := displayName + tstr;
                foundAll := false;
            end;
            tags.Free();
            strPos := _regEx.MatchPos[0] + _regEx.MatchLen[0];
        until (not _regEx.ExecNext);
    end
    else displayName := _profileMapStr;
    Result := foundAll;
end;

{-------------------------------------------------------------------------------
 ------------------------ TDisplayNameListener ---------------------------------
 ------------------------------------------------------------------------------}
Constructor TDisplayNameListener.Create();
begin
    inherited;
    _DNCB := -1;
end;

Destructor TDisplayNameListener.Destroy();
begin
    if (_DNCB <> -1) then
        MainSession.UnRegisterCallback(_DNCB);
    _DNCB := -1;
    inherited;
end;


function TDisplayNameListener.getDisplayName(bareJID: TJabberID; out pendingNameChange: boolean): WideString;
begin
    Result := getDisplayNameCache().getDisplayName(bareJID, pendingNameChange);
    if (pendingNameChange and (_DNCB = -1)) then
        _DNCB := MainSession.RegisterCallback(DNCallback, '/session/displayname');
end;

function TDisplayNameListener.getDisplayName(bareJID: TJabberID): WideString;
var
    ignored: boolean;
begin
    Result := Self.getDisplayName(bareJID, ignored);
end;

procedure TDisplayNameListener.fireOnDisplayNameChange(bareJID: Widestring; displayName: WideString);
begin
    if (assigned(_OnDisplayNameChange)) then begin
        _OnDisplayNameChange(bareJID, displayName);
    end;
end;

procedure TDisplayNameListener.DNCallback(event: string; tag: TXMLTag);
begin
    try
        if (_DNCB <> -1) and (tag <> nil) then begin
            fireOnDisplaynameChange(tag.GetAttribute('jid'), tag.GetAttribute('dn'));
            MainSession.UnRegisterCallback(_DNCB);
            _DNCB := -1;
        end;
    except
    end;
end;

function TDisplayNameListener.getProfileDisplayName(bareJID: TJabberID; out pendingNameChange: boolean): WideString;
begin
    Result := getDisplayNameCache().getProfileDisplayName(bareJID, pendingNameChange);
    if (pendingNameChange and (_DNCB = -1)) then
        _DNCB := MainSession.RegisterCallback(DNCallback, '/session/displayname');
end;

function TDisplayNameListener.ProfileEnabled(): Boolean;
begin
    Result := useProfileDN() and Session.MainSession.Authenticated;
end;

{-------------------------------------------------------------------------------
 -------------------------- TDisplayNameItem -----------------------------------
 ------------------------------------------------------------------------------}
constructor TDisplayNameItem.create(jid: TJabberID; profileParser: TProfileParser);
begin
    inherited create();
    _jid := TJabberID.Create(jid);
    _displayName[dntNode] := _jid.removeJEP106(_jid.user);
    _profileIQ := nil;
    _fetchFailed := false;
    _profileParser := profileParser;
    _lastDisplayName := '';
end;

destructor  TDisplayNameItem.Destroy();
begin
    _jid.Free();
    inherited;
end;

function TDisplayNameItem.getProfileEnabled(): Boolean;
begin
    Result := useProfileDN() and Session.MainSession.Authenticated;
end;

function TDisplayNameItem.getProfileDisplayName(out pendingNameChange: boolean; ignorePending: boolean): WideString;
begin
    Result := _displayName[dntProfile];
    if (not _fetchFailed) then begin
        if (Result = '') and (_profileIQ = nil) then begin
            Result := _displayName[dntNode];
            if (not ignorePending) then begin
                //make profile name node name for the moment. This handles
                //a race condition when a request for a disp name is made while
                //vcard is fetching
                _displayName[dntProfile] := Result;

                _profileIQ := TJabberIQ.Create(MainSession, MainSession.generateID(), ProfileCallback);
                _profileIQ.Namespace := 'vcard-temp';
                _profileIQ.qTag.Name := 'vCard';
                _profileIQ.iqType := 'get';
                _profileIQ.toJid := _jid.jid;
                _profileIQ.Send;
            end;
        end;
    end;
    pendingNameChange := _profileIQ <> nil;
end;

function TDisplayNameItem.getDisplayName(out pendingNameChange: boolean; ignorePending: boolean): WideString;
begin
    Result := _DisplayName[dntRoster];
    pendingnameChange := false;
    if ((Result = '') and (ProfileEnabled)) then
        Result := getProfileDisplayName(pendingNameChange, ignorePending);
    if (Result = '') then
        Result := _displayName[dntNode];

    _lastDisplayName := Result;
end;

procedure TDisplayNameItem.ProfileCallback(event: string; tag: TXMLTag);
var
    tstr: Widestring;
    ttag: TXMLtag;
    changeTag: TXMLTag;
begin
    _profileIQ := nil;
    _fetchFailed := true;
    if ((event = 'xml') and (tag <> nil) and (tag.getAttribute('type') = 'result')) then begin
        tTag := tag.GetFirstTag('vCard');
        if (tTag = nil) then
            tTag := tag.GetFirstTag('vcard');
        if ((ttAg <> nil) and _profileParser.parseProfile(ttag, tstr) and (tstr <> '')) then
            _fetchfailed := false;
    end;

    if (not _fetchFailed) then
        _displayName[dntProfile] := tstr
    else begin
        _displayName[dntProfile] := '';
        tstr := _displayName[dntNode];
    end;

    changeTag := TXMLtag.Create('dispname');
    changeTag.setAttribute('jid', _jid.jid);
    changeTag.setAttribute('dn', tstr);
    TJabberSession(MainSession).FireEvent('/session/displayname', changeTag);
    changeTag.Free();
end;

{-------------------------------------------------------------------------------
 -------------------------- TDisplayNameCache ----------------------------------
 ------------------------------------------------------------------------------}
Constructor TDisplayNameCache.create();
begin
    inherited;
    _dnCache := TWideStringList.Create();
    _js := nil;
    _sessioncb := -1;
    //_rostercb := -1;
    _profileParser := TProfileParser.Create();
end;

Destructor TDisplayNameCache.Destroy();
begin
    setSession(nil);
    _dnCache.Free();
    _profileParser.Free();
    inherited;
end;

function TDisplayNameCache.getOrAddDNItem(jid: TJabberID): TDisplayNameItem;
begin
    Result := getDNItem(jid);
    if (Result = nil) then begin
        Result := TDisplayNameItem.create(jid, _profileParser);
        addDNItem(Result);
    end;
end;

procedure TDisplayNameCache.setSession(js: TObject);
begin
    if (_js <> nil) then begin
        if (_sessionCB <> -1) then
            TJabberSession(_js).UnRegisterCallback(_sessionCB);
//        if (_rosterCB <> -1) then
//            TJabberSession(_js).UnRegisterCallback(_rosterCB);
    end;
    clearDNCache();

    _js := js;
    if (_js <> nil) then begin
        _sessioncb := TJabberSession(_js).RegisterCallback(SessionCallback, '/session');
        //_rostercb := TJabberSession(_js).RegisterCallback(RosterCallback, '/item/update');
    end;
end;


{
    Roster name trumps all.

    If we receive a roster item update set the corresponding items displayname
    to the new roster name. Fire an update event if displayname actually changed.

}
procedure TDisplayNameCache.UpdateDisplayName(uid: WideString);
var
    dnItem: TDisplayNameItem;
    foundName: WideString;
    fireChange: boolean;
    changeTag: TXMLTag;
    jid: TJabberID;
    Item: IExodusItem;
begin
    Item := TJabberSession(_js).ItemController.GetItem(uid);
    if (Item = nil) then exit;
    if (Item.Type_ <> EI_TYPE_CONTACT) then exit;

    if ((Item.Value['Subscription'] = '') or (Item.Value['Subscription'] = 'remove')) then exit;

    foundName := Item.Text;

    jid := TJabberID.Create(Item.Uid);
    //add item to cache
    dnItem := getDNItem(jid);

    fireChange := (dnItem <> nil) and (foundName <> '') and (dnItem._displayName[dntRoster] <> foundName);
    if (dnItem = nil) then begin
        dnItem := TDisplayNameItem.create(jid, _profileParser);
        addDNItem(dnItem);
    end;

    if ((foundName <> '') and (dnItem._displayName[dntRoster] <> foundName)) then
        dnItem._displayName[dntRoster] := foundName;

    //fire a displayname updated event
    if (fireChange) then begin
        changeTag := TXMLtag.Create('dispname');
        changeTag.setAttribute('jid', dnItem._jid.jid);
        changeTag.setAttribute('dn', dnItem._displayName[dntRoster]);
        TJabberSession(_js).FireEvent('/session/displayname', changeTag);
        changeTag.Free();
    end;
    jid.Free();

end;

procedure TDisplayNameCache.SessionCallback(event: string; tag: TXMLTag);
var
//    idx: integer;
    dnItem: TDisplayNameItem;
    tstr: WideString;
    locked: boolean;
begin
    if (event = '/session/disconnected') then
        //clear cache on disconnect
        clearDNCache()
    else if (event = '/session/authenticated') then begin
        ProfileParser.setProfileParseMap(getProfileDNMap());
        //add our jid to the cache
         dnItem := getDNItem(MainSession.Profile.getJabberID());
        if (dnItem = nil) then begin
            dnItem := TDisplayNameItem.create(MainSession.Profile.getJabberID(), _profileParser);
            addDNItem(dnItem);
        end;
        //at this point our nick is our node.
        tstr := MainSession.Prefs.getString('default_nick');
        locked := MainSession.Prefs.getBool('brand_prevent_change_nick');
        //if nick name is not locked and we have a default nick, make the roster dn name that nickname
        if ((not locked) and (tstr <> '')) then
            dnItem._displayName[dntRoster] := tstr
        else if (locked or (tstr = '')) then begin
            //if nick name is "locked down" or no default nick is supplied, pull our nick from vcard.
            TMyNickHandler.Create().getProfileName(MainSession.Profile.getJabberID());
        end;
    end
    else if (event = '/session/prefs') then begin
        //if we've had a pref change for profile, update accordingly...
        if (ProfileParser.ProfileMapString <>  getProfileDNMap()) then
            ProfileParser.setProfileParseMap(getProfileDNMap());
        { JJF not updating for now, not sure what to do here
        for idx := 0 to _dnCache.Count - 1 do begin
            TDisplayNameItem(_dnCache.Objects[idx]).OnPrefChange();
        end;
        }
    end;
end;


function TDisplayNameCache.getDNItem(jid: TJabberID): TDisplayNameItem;
var
    i: integer;
    tstr: Widestring;
begin
    tstr := jid.full;
    i := _dnCache.IndexOf(tstr);
    if (i <> -1) then
        Result := TDisplayNameItem(_dnCache.Objects[i])
    else
        Result := nil;
end;

procedure TDisplayNameCache.removeDNItem(dnItem: TDisplayNameItem);
var
    i: integer;
begin
    i := _dnCache.IndexOf(dnItem._jid.full);
    if (i <> -1) then begin
        _dnCache.Objects[i].Free();
        _dnCache.Delete(i);
    end;
end;

procedure TDisplayNameCache.addDNItem(dnItem: TDisplayNameItem);
begin
    if (_dnCache.IndexOf(dnItem._jid.full) = -1) then
        _dnCache.AddObject(dnItem._jid.full, dnItem)
end;

procedure TDisplayNameCache.clearDNCache();
var
    i : integer;
begin
    for i := _dnCache.Count - 1 downto 0 do begin
        _dnCache.Objects[i].Free();
    end;
    _dnCache.Clear();
end;

function TDisplayNameCache.getDisplayName(jid: TJabberID; out pendingNameChange: boolean; ignorePending: boolean): Widestring;
begin
    Result := getOrAddDNItem(jid).getDisplayName(pendingNameChange, ignorePending);
end;

function TDisplayNameCache.getDisplayNameAndFullJID(jid: TJabberID): Widestring;
var
    ignored: boolean;
begin
    Result := getOrAddDNItem(jid).getDisplayName(ignored, true);
    Result := Result + ' <' + jid.GetDisplayFull() + '>';
end;

function TDisplayNameCache.getDisplayNameAndBareJID(jid: TJabberID): Widestring;
var
    ignored: boolean;
begin
    Result := getOrAddDNItem(jid).getDisplayName(ignored, true);
    Result := Result + ' <' + jid.getDisplayJID() + '>';
end;

function TDisplayNameCache.getDisplayName(jid: TJabberID): Widestring;
var
    ignored: boolean;
begin
    Result := getDisplayName(jid, ignored, true);
end;

function TDisplayNameCache.getProfileDisplayName(jid: TJabberID; out pendingNameChange: boolean): WideString;
begin
    Result := getOrAddDNItem(jid).getProfileDisplayName(pendingNameChange);
end;

initialization
    _dnCache := TDisplayNameCache.create();

finalization
    _dnCache.Free();
    _dnCache := nil;    
end.
