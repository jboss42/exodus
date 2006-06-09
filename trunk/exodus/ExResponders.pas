unit ExResponders;
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
    Responder, Session, Signals, 
    XMLTag, Unicode, JabberUtils, ExUtils, 
    Windows, Classes, SysUtils;

type

    TResponderFactory = procedure(tag: TXMLTag);

    TVersionResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TTimeResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TLastResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TBrowseResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        Namespaces: TWidestringList;
        constructor Create(Session: TJabberSession); overload;
        destructor Destroy; override;
    end;

    TDiscoItem = class
        Name: Widestring;
        JID: Widestring;
    end;

    TDiscoItemsResponder = class(TJabberResponder)
    private
        _items: TWidestringList;
    published
        procedure iqCallback(event: string; tag:TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
        destructor Destroy; override;
        function addItem(Name, JabberID: Widestring): Widestring;
        procedure removeItem(id: Widestring);
    end;

    TDiscoInfoResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag:TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TFactoryResponder = class
    private
        _session: TJabberSession;
        _cb: integer;
        _factory: TResponderFactory;
    published
        procedure respCallback(event: string; tag: TXMLTag);
    public
        constructor Create(Session: TJabberSession; xpath: string; factory: TResponderFactory);
        destructor Destroy; override;
    end;

    TUnhandledResponder = class
    private
        _session: TJabberSession;
        _cbid: integer;
    published
        procedure callback(event: string; tag: TXMLTag);
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TAvatarResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TConfirmationResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

procedure initResponders();
procedure cleanupResponders();

procedure ExHandleException(e_data: TWidestringlist);

var
    Exodus_Disco_Items: TDiscoItemsResponder;
    Exodus_Disco_Info: TDiscoInfoResponder;
    Exodus_Browse: TBrowseResponder;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef TRACE_EXCEPTIONS}
    IdException, JclDebug, JclHookExcept, TypInfo,
    {$endif}

    RosterImages, COMController, ExSession, GnuGetText,
    JabberConst, Invite, Dialogs, PrefController, Registry, Forms,
    XferManager, xData, XMLUtils, Jabber1, JabberID, Notify, NodeItem, Roster;

const
    sNotifyAutoResponse = '%s query from: %s';
    sVersion = 'Version';
    sTime = 'Time';
    sLast = 'Last';
    sBrowse = 'Browse';
    sDisco = 'Disco';
    sExceptionMsg = 'An error has occurred. An error log file will automatically be saved to your desktop. Use this file to submit a bug report at the website.';
    sConfirm = 'HTTP authentication';
    sConfirmationDialog = 'Accept authentication request from %s';

var
    _version: TVersionResponder;
    _time: TTimeResponder;
    _last: TLastResponder;
    _xdata: TFactoryResponder;
    _iqoob: TFactoryResponder;
    _muc_invite: TFactoryResponder;
    _conf_invite: TFactoryResponder;
    _unhandled: TUnhandledResponder;
    _sistart: TFactoryResponder;
    _avatar: TAvatarResponder;
    _confirmation: TConfirmationResponder;

{---------------------------------------}
function getNick(j: Widestring): Widestring;
var
    jid: TJabberID;
    ritem: TJabberRosterItem;
begin
    jid := TJabberID.Create(j);
    ritem := MainSession.roster.Find(jid.jid);
    if (ritem = nil) then
        result := jid.getDisplayJID()
    else
        result := ritem.Text;
    jid.Free();
end;

{---------------------------------------}
procedure initResponders();
begin
    assert(_version = nil);

    _version := TVersionResponder.Create(MainSession);
    _time := TTimeResponder.Create(MainSession);
    _last := TLastResponder.Create(MainSession);
    _xdata := TFactoryResponder.Create(MainSession,
        '/pre/message/x[@xmlns="' + XMLNS_XDATA +'"]',
        showXData);
    _iqoob := TFactoryResponder.Create(MainSession,
        '/packet/iq[@type="set"]/query[@xmlns="' + XMLNS_IQOOB + '"]',
        FileReceive);
    _muc_invite := TFactoryResponder.Create(MainSession,
        '/pre/message/x[@xmlns="' + XMLNS_MUCUSER + '"]/invite',
        showRecvInvite);
    _conf_invite := TFactoryResponder.Create(MainSession,
        '/pre/message/x[@xmlns="' + XMLNS_XCONFERENCE + '"]',
        showConfInvite);
    _unhandled := TUnhandledResponder.Create(MainSession);
    _sistart := TFactoryResponder.Create(MainSession,
        '/packet/iq[@type="set"]/si[@xmlns="' + XMLNS_SI + '"]',
        SIStart);
    _avatar := TAvatarResponder.Create(MainSession);
    _confirmation := TConfirmationResponder.Create(MainSession);

    // Create some globally accessable responders.
    Exodus_Browse := TBrowseResponder.Create(MainSession);
    Exodus_Disco_Items := TDiscoItemsResponder.Create(MainSession);
    Exodus_Disco_Info := TDiscoInfoResponder.Create(MainSession);

    // Register the dispatcher exception handler
    MainSession.Dispatcher.ExceptionHandler := ExHandleException;
end;

{---------------------------------------}
procedure ExHandleException(e_data: TWidestringlist);
var
    s, i: integer;
    msg, ver, orig, fname, dir: String;
    reg: TRegistry;
    sig: TSignal;
    l: TSignalListener;
    {$ifdef TRACE_EXCEPTIONS}
    sl: TStringlist;
    {$endif}
begin
    // We got an exception during signal dispatching.
    MessageDlgW(_(sExceptionMsg), mtError, [mbOK], 0);

    // Put error logs in user dir, not on desktop anymore.
    dir := getUserDir();
   
    // Send the data to a file in dir
    orig := dir + '\Error log';
    fname := orig + '.txt';
    i := 1;
    while (FileExists(fname)) do begin
        fname := orig + '-' + IntToStr(i) + '.txt';
        i := i + 1;
    end;

    // Insert some more debugging info
    ver := '';
    WindowsVersion(ver);
    e_data.Insert(0, '---------------------------------------');
    e_data.Insert(0, 'Date, Time: ' + DateTimeToStr(Now()));
    e_data.Insert(0, PrefController.getAppInfo.ID + ' ver: ' + GetAppVersion());
    e_data.Insert(0, ver);

    // Dump current plugins
    e_data.Add('---------------------------------------');
    e_data.Add('Plugins:');
    for s := 0 to plugs.Count - 1 do begin
        e_data.Add(plugs[s]);
    end;
    e_data.Add('---------------------------------------');

    // Dump current dispatcher table:
    e_data.Add('Dispatcher Dump');
    with MainSession.Dispatcher do begin
        for s := 0 to Count - 1 do begin
            sig := TSignal(Objects[s]);
            e_data.Add('SIGNAL: ' + Strings[s] + ' of class: ' + sig.ClassName);
            e_data.Add('---------------------------------------');
            for i := 0 to sig.Count - 1 do begin
                l := TSignalListener(sig.Objects[i]);
                msg := 'LID: ' + IntToStr(l.cb_id) + ', ';
                msg := msg + sig.Strings[i] + ', ';
                msg := msg + l.classname + ', ';
                msg := msg + l.methodname;
                e_data.Add(msg);
            end;
        end;
    end;

    {$ifdef TRACE_EXCEPTIONS}
    e_data.Add('---------------------------------------');
    e_data.Add('Stack Trace:');
    e_data.Add('---------------------------------------');
    sl := TStringlist.Create();
    JclLastExceptStackListToStrings(sl, true, false, false);
    for i := 0 to sl.count - 1 do
        e_data.Add(sl[i]);
    sl.Free();
    e_data.Add('---------------------------------------');
    {$endif}


    e_data.SaveToFile(fname);
    e_data.Free();

    //Halt execution.
    Windows.ExitProcess(0);

end;

{---------------------------------------}
procedure cleanupResponders();
begin
    if (Exodus_Disco_Info = nil) then exit;

    FreeAndNil(Exodus_Disco_Info);
    FreeAndNil(Exodus_Disco_Items);
    FreeAndNil(Exodus_Browse);

    FreeAndNil(_unhandled);
    FreeAndNil(_conf_invite);
    FreeAndNil(_muc_invite);
    FreeAndNil(_iqoob);
    FreeAndNil(_xdata);
    FreeAndNil(_last);
    FreeAndNil(_time);
    FreeAndNil(_version);
    FreeAndNil(_sistart);
end;

{---------------------------------------}
constructor TVersionResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_VERSION);
end;

{---------------------------------------}
procedure TVersionResponder.iqCallback(event: string; tag: TXMLTag);
var
    r: TXMLTag;
    app, win: string;
begin
    // respond w/ our version info
    {
    <iq from='rynok@jabber.com/Jabber Instant Messenger'
        to='pgmillard@jabber.org/workage'
        type='result'>
    <query xmlns='jabber:iq:version'>
        <name>Jabber Instant Messenger</name>
        <version>1.10.0.7</version>
        <os>NT 5.0</os>
    </query></iq>
    }
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    DoNotify(nil, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sVersion),
                                          getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

    win := '';
    WindowsVersion(win);
    app := GetAppVersion();

    r := TXMLTag.Create('iq');
    with r do begin
        setAttribute('id', tag.getAttribute('id'));
        setAttribute('type', 'result');
        setAttribute('to', tag.getAttribute('from'));
        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_VERSION);
            AddBasicTag('name', PrefController.getAppInfo.ID);
            AddBasicTag('version', app);
            AddBasicTag('os', win);
        end;
    end;
    _session.sendTag(r);

end;

{---------------------------------------}
constructor TTimeResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_TIME);
end;

{---------------------------------------}
procedure TTimeResponder.iqCallback(event: string; tag: TXMLTag);
var
    r: TXMLTag;
    tzi: TTimeZoneInformation;
    utc: TDateTime;
    res: integer;
begin
    // Respond to time queries
    {
    <iq from='smorris@jabber.com/Work' id='wj_4'
        to='pgmillard@jabber.org/workage'
        type='result'>
    <query xmlns='jabber:iq:time'>
        <utc>20011026T01:36:58</utc>
        <tz>Mountain Standard Time</tz>
        <display>10/25/2001 5:36:58 PM</display>
    </query></iq>
    }
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    DoNotify(nil, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sTime),
                                          getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

    r := TXMLTag.Create('iq');
    res := GetTimeZoneInformation(tzi);
    if res = TIME_ZONE_ID_DAYLIGHT then
        utc := Now + ((tzi.Bias - 60) / 1440.0)
    else
        utc := Now + (tzi.Bias / 1440.0);

    with r do begin
        setAttribute('to', tag.getAttribute('from'));
        setAttribute('id', tag.getAttribute('id'));
        setAttribute('type', 'result');

        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_TIME);
            AddBasicTag('utc', DateTimeToJabber(utc));
            AddBasicTag('tz', tzi.StandardName);
            AddBasicTag('display', DateTimeToStr(Now));
        end;
    end;

    _session.sendTag(r);
end;

{---------------------------------------}
constructor TLastResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_LAST);
end;

{---------------------------------------}
procedure TLastResponder.iqCallback(event: string; tag: TXMLTag);
var
    idle: dword;
    r: TXMLTag;
begin
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    DoNotify(nil, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sLast),
                                          getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

    // Respond to last queries
    r := TXMLTag.Create('iq');
    with r do begin
        setAttribute('to', tag.getAttribute('from'));
        setAttribute('id', tag.getAttribute('id'));
        setAttribute('type', 'result');

        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_LAST);
            idle := (GetTickCount() - frmExodus.getLastTick()) div 1000;
            setAttribute('seconds', IntToStr(idle));
        end;
    end;

    _session.sendTag(r);
end;

{---------------------------------------}
constructor TConfirmationResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, 'http://jabber.org/protocol/http-auth', 'confirm');
end;

{---------------------------------------}
procedure TConfirmationResponder.iqCallback(event: string; tag: TXMLTag);
var
    x, r: TXMLTag;
    url: WideString;
begin
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    DoNotify(nil, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sLast),
                getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

    url := tag.QueryXPData('/iq/confirm@url');
    if MessageBoxW(0, PWideChar(WideFormat(_(sConfirmationDialog), [url])),
               PWideChar(_(sConfirm)),
               MB_ICONQUESTION or MB_OKCANCEL) = IDCANCEL then begin
        r := TXMLTag.Create('iq');
        r.setAttribute('to', tag.getAttribute('from'));
        r.setAttribute('id', tag.getAttribute('id'));
        r.setAttribute('type', 'error');
        x := r.AddTag('error');
        x.setAttribute('code', '401');
        x.setAttribute('type', 'auth');
        x.AddTag('not-authorized').setAttribute('xmlns', 'urn:ietf:params:xml:xmpp-stanzas');
        _session.SendTag(r);
    end
    else begin
        // return iq/result
        r := TXMLTag.Create('iq');
        r.setAttribute('to', tag.getAttribute('from'));
        r.setAttribute('id', tag.getAttribute('id'));
        r.setAttribute('type', 'result');
        _session.SendTag(r);
    end;

end;

{---------------------------------------}
constructor TAvatarResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, 'jabber:iq:avatar');
end;

{---------------------------------------}
procedure TAvatarResponder.iqCallback(event: string; tag: TXMLTag);
var
    x, r: TXMLTag;
begin
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    if (_session.Profile.Avatar = '') then begin
        r := TXMLTag.Create('iq');
        r.setAttribute('to', tag.getAttribute('from'));
        r.setAttribute('id', tag.getAttribute('id'));
        r.setAttribute('type', 'error');
        x := r.AddTag('error');
        x.setAttribute('code', '404');
        x.setAttribute('type', 'cancel');
        x.AddTag('item-not-found');
        _session.SendTag(r);
    end
    else begin
        DoNotify(nil, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sLast),
                getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

        // Respond to last queries
        r := TXMLTag.Create('iq');
        with r do begin
            setAttribute('to', tag.getAttribute('from'));
            setAttribute('id', tag.getAttribute('id'));
            setAttribute('type', 'result');

            with AddTag('query') do begin
                setAttribute('xmlns', 'jabber:iq:avatar');
                x := AddTag('data');
                x.setAttribute('mimetype', _session.Profile.AvatarMime);
                x.AddCData(_session.Profile.Avatar);
            end;
        end;
        _session.sendTag(r);
    end;
end;

{---------------------------------------}
constructor TBrowseResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_BROWSE);
    Namespaces := TWidestringlist.Create();
end;

{---------------------------------------}
destructor TBrowseResponder.Destroy();
begin
    Namespaces.Free();
    inherited;
end;

{---------------------------------------}
procedure TBrowseResponder.iqCallback(event: string; tag: TXMLTag);
var
    i: integer;
    r: TXMLTag;
begin
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    DoNotify(nil, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sBrowse),
                                          getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

    r := TXMLTag.Create('iq');
    with r do begin
        setAttribute('to', tag.getAttribute('from'));
        setAttribute('id', tag.GetAttribute('id'));
        setAttribute('type', 'result');

        with AddTag('user') do begin
            setAttribute('xmlns', XMLNS_BROWSE);
            setAttribute('type', 'client');
            setAttribute('jid', _session.Profile.getJabberID.full());
            setAttribute('name', _session.Username);

            AddBasicTag('ns', XMLNS_SEARCH);
            AddBasicTag('ns', XMLNS_AGENTS);

            AddBasicTag('ns', XMLNS_IQOOB);
            AddBasicTag('ns', XMLNS_BROWSE);
            AddBasicTag('ns', XMLNS_TIME);
            AddBasicTag('ns', XMLNS_VERSION);
            AddBasicTag('ns', XMLNS_LAST);
            AddBasicTag('ns', XMLNS_DISCOITEMS);
            AddBasicTag('ns', XMLNS_DISCOINFO);

            AddBasicTag('ns', XMLNS_BM);
            AddBasicTag('ns', XMLNS_XDATA);
            AddBasicTag('ns', XMLNS_XCONFERENCE);
            AddBasicTag('ns', XMLNS_XEVENT);

            AddBasicTag('ns', XMLNS_MUC);
            AddBasicTag('ns', XMLNS_MUCUSER);
            AddBasicTag('ns', XMLNS_MUCOWNER);

            for i := 0 to Namespaces.Count - 1 do
                AddBasicTag('ns', Namespaces[i]);
        end;
    end;
    _session.SendTag(r);
end;

{---------------------------------------}
constructor TDiscoItemsResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_DISCOITEMS);

    _items := TWidestringList.Create();
end;

{---------------------------------------}
destructor TDiscoItemsResponder.Destroy();
var
    i: integer;
begin
    for i := 0 to _items.Count - 1 do
        _items.Objects[i].Free();
    _items.Free();
    inherited;
end;

{---------------------------------------}
function TDiscoItemsResponder.addItem(Name, JabberID: Widestring): Widestring;
var
    di: TDiscoItem;
begin
    //
    Result := IntToStr(_items.Count);
    di := TDiscoitem.Create();
    di.Name := Name;
    di.JID := JabberID;
    _items.AddObject(Result, di);
end;

{---------------------------------------}
procedure TDiscoItemsResponder.removeItem(id: Widestring);
var
    idx: integer;
begin
    //
    idx := _items.IndexOf(ID);
    if ((idx >= 0) and (idx < _items.Count)) then begin
        _items.Objects[idx].Free();
        _items.Delete(idx);
    end;
end;

{---------------------------------------}
procedure TDiscoItemsResponder.iqCallback(event: string; tag:TXMLTag);
var
    di: TDiscoItem;
    i: integer;
    n, r, q: TXMLTag;
begin
    // return an empty result set.
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    r := TXMLTag.Create('iq');
    with r do begin
        setAttribute('to', tag.getAttribute('from'));
        setAttribute('id', tag.GetAttribute('id'));
        setAttribute('type', 'result');
        q := AddTag('query');
        q.setAttribute('xmlns', XMLNS_DISCOITEMS);

        for i := 0 to _items.Count - 1 do begin
            di := TDiscoItem(_items.Objects[i]);
            n := q.AddTag('entity');
            n.setAttribute('name', di.Name);
            n.setAttribute('jid', di.JID);
        end;
    end;

    DoNotify(nil, 'notify_autoresponse',
        WideFormat(_(sNotifyAutoResponse), [_(sDisco),
            getNick(tag.getAttribute('from'))]),
        RosterTreeImages.Find('info'));

    _session.SendTag(r);
end;

{---------------------------------------}
constructor TDiscoInfoResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_DISCOINFO);
end;
{---------------------------------------}
procedure TDiscoInfoResponder.iqCallback(event: string; tag:TXMLTag);

    procedure addFeature(qtag: TXMLTag; stype: WideString);
    begin
        with qtag.AddTag('feature') do
            setAttribute('var', stype);
    end;

var
    i, j: integer;
    r, q: TXMLTag;
    node: WideString;
    uri, ext: WideString;
    extension : TWideStringList;
    error: boolean;
begin
    // return info results
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    q := tag.GetFirstTag('query');
    if (q = nil) then exit;

    error := false;
    extension := nil;

    // The disco node should either not be present: "give me all of your features"
    // Be URI#version: "give me the base features for this version" or
    // Be URI#ext: "give me the features for this extension"
    // other nodes, from plugins for example, MUST register their own callback
    node := q.GetAttribute('node');
    if (node <> '') then begin
        i := pos('#', node);
        if (i = 0) then
            error := true
        else begin
            uri := copy(node, 1, i - 1);
            if (uri <> _session.Prefs.getString('client_caps_uri')) then
                error := true
            else begin
                ext := copy(node, i+1, length(node) - i + 1);
                if ext <> GetAppVersion() then begin
                    j := MainSession.GetExtList().IndexOf(ext);
                    if (j < 0) then
                        error := true
                    else begin
                        extension := TWideStringList(MainSession.GetExtList().Objects[j]);
                    end;
                end;
            end;
        end;
    end;

    r := TXMLTag.Create('iq');
    r.setAttribute('to', tag.getAttribute('from'));
    r.setAttribute('id', tag.GetAttribute('id'));
    q := r.AddTag('query');
    q.setAttribute('xmlns', XMLNS_DISCOINFO);
    if (node <> '') then
        q.setAttribute('node', node);

    if (error) then begin
        r.setAttribute('type', 'error');
        with r.AddTag('error') do begin
            setAttribute('code', '404');
            setAttribute('type', 'cancel');
            AddTagNS('item-not-found', XMLNS_STREAMERR);
        end;
        _session.SendTag(r);
        exit;
    end;

    r.setAttribute('type', 'result');

    if (extension <> nil) then begin
        for j := 0 to extension.Count - 1 do begin
            addFeature(q, extension[j]);
        end;
    end
    else begin
        // no node or uri#ver
        addFeature(q, XMLNS_SEARCH);
        addFeature(q, XMLNS_AGENTS);

        addFeature(q, XMLNS_IQOOB);
        addFeature(q, XMLNS_BROWSE);
        addFeature(q, XMLNS_TIME);
        addFeature(q, XMLNS_VERSION);
        addFeature(q, XMLNS_LAST);
        addFeature(q, XMLNS_DISCOITEMS);
        addFeature(q, XMLNS_DISCOINFO);

        // Various core extensions
        addFeature(q, XMLNS_BM);
        addFeature(q, XMLNS_XDATA);
        addFeature(q, XMLNS_XCONFERENCE);
        addFeature(q, XMLNS_XEVENT);

        // MUC Stuff
        addFeature(q, XMLNS_MUC);
        addFeature(q, XMLNS_MUCUSER);
        addFeature(q, XMLNS_MUCOWNER);

        // File xfer
        addFeature(q, XMLNS_SI);
        addFeature(q, XMLNS_FTPROFILE);
        addFeature(q, XMLNS_BYTESTREAMS);

        if (node = '') then begin
            with q.AddTag('identity') do begin
                setAttribute('category', 'user');
                setAttribute('type', 'client');
                setAttribute('name', _session.Username);
            end;

            for i := 0 to MainSession.GetExtList().Count - 1 do begin
                extension := TWideStringList(MainSession.GetExtList().Objects[i]);
                for j := 0 to extension.Count - 1 do begin
                    addFeature(q, extension[j]);
                end;
            end;
        end;
    end;


    DoNotify(nil, 'notify_autoresponse',
        WideFormat(_(sNotifyAutoResponse), [_(sDisco),
            getNick(tag.getAttribute('from'))]),
        RosterTreeImages.Find('info'));

    _session.SendTag(r);
end;

{---------------------------------------}
constructor TFactoryResponder.Create(Session: TJabberSession; xpath: string; factory: TResponderFactory);
begin
    _factory := factory;
    _session := Session;
    _cb := _session.RegisterCallback(respCallback, xpath);
end;

{---------------------------------------}
destructor TFactoryResponder.Destroy();
begin
    _session.UnRegisterCallback(_cb);
end;

{---------------------------------------}
procedure TFactoryResponder.respCallback(event: string; tag: TXMLTag);
begin
    _factory(tag);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TUnhandledResponder.Create(Session: TJabberSession);
begin
    //
    _session := Session;
    _cbid := _session.RegisterCallback(self.Callback, '/unhandled');
end;

{---------------------------------------}
procedure TUnhandledResponder.callback(event: string; tag: TXMLTag);
var
    t, f: Widestring;
    b, e: TXMLTag;
begin
    //
    t := tag.GetAttribute('type');
    if ((tag.Name = 'iq') and ((t = 'get') or (t = 'set'))) then begin
        b := TXMLTag.Create(tag);
        f := b.GetAttribute('from');
        b.setAttribute('from', b.getAttribute('to'));
        b.setAttribute('to', f);
        b.setAttribute('type', 'error');
        e := b.AddBasicTag('error', 'Not Implemented');
        e.setAttribute('code', '501');
        _session.SendTag(b);
    end
    else if ((tag.Name = 'message') and (t = 'error')) then begin
        // display this error using the msg queue
        MainSession.MsgList.MsgCallback('/unhandled', tag);
    end;
end;


initialization
    Exodus_Browse := nil;
    Exodus_Disco_Items := nil;
    Exodus_Disco_Info := nil;
    
    _version := nil;
    _time := nil;
    _last := nil;
    _xdata := nil;
    _iqoob := nil;

end.
