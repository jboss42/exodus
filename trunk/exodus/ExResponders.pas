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
    Responder,
    Session,
    XMLTag,
    ExUtils,
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
        constructor Create(Session: TJabberSession); overload;
    end;

    TDiscoItemsResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag:TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
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

procedure initResponders();
procedure cleanupResponders();

resourcestring
    sNotifyAutoResponse = '%s query from:'#10#13' %s';
    sVersion = 'Version';
    sTime = 'Time';
    sLast = 'Last';
    sBrowse = 'Browse';
    sDisco = 'Disco';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberConst, Invite,
    xData, XMLUtils, Jabber1, JabberID, Notify, Transfer, Roster;

var
    _version: TVersionResponder;
    _time: TTimeResponder;
    _last: TLastResponder;
    _browse: TBrowseResponder;
    _xdata: TFactoryResponder;
    _iqoob: TFactoryResponder;
    _muc_invite: TFactoryResponder;
    _conf_invite: TFactoryResponder;
    _disco_items: TDiscoItemsResponder;
    _disco_info: TDiscoInfoResponder;

{---------------------------------------}
function getNick(j: string): string;
var
    jid: TJabberID;
    ritem: TJabberRosterItem;
begin
    jid := TJabberID.Create(j);
    ritem := MainSession.roster.Find(jid.jid);
    if (ritem = nil) then
        result := jid.jid
    else
        result := ritem.Nickname;
    jid.Free();
end;

{---------------------------------------}
procedure initResponders();
begin
    assert(_version = nil);

    _version := TVersionResponder.Create(MainSession);
    _time := TTimeResponder.Create(MainSession);
    _last := TLastResponder.Create(MainSession);
    _browse := TBrowseResponder.Create(MainSession);
    _xdata := TFactoryResponder.Create(MainSession,
        '/packet/message/x[@xmlns="' + XMLNS_XDATA +'"]',
        showXData);
    _iqoob := TFactoryResponder.Create(MainSession,
        '/packet/iq[@type="set"]/query[@xmlns="' + XMLNS_IQOOB + '"]',
        FileReceive);
    _muc_invite := TFactoryResponder.Create(MainSession,
        '/packet/message/x[@xmlns="' + XMLNS_MUCUSER + '"]/invite',
        showRecvInvite);
    _conf_invite := TFactoryResponder.Create(MainSession,
        '/packet/message/x[@xmlns="' + XMLNS_XCONFERENCE + '"]',
        showConfInvite);
end;

{---------------------------------------}
procedure cleanupResponders();
begin
    _disco_info.Free();
    _disco_items.Free();
    _conf_invite.Free();
    _muc_invite.Free();
    _iqoob.Free();
    _xdata.Free();
    _browse.Free();
    _last.Free();
    _time.Free();
    _version.Free();

    _disco_info := nil;
    _disco_items := nil;
    _conf_invite := nil;
    _muc_invite := nil;
    _iqoob := nil;
    _xdata := nil;
    _browse := nil;
    _last := nil;
    _time := nil;
    _version := nil;
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
             Format(sNotifyAutoResponse, [sVersion,
                                          getNick(tag.getAttribute('from'))]),
             ico_info);

    win := '';
    WindowsVersion(win);
    app := GetAppVersion();

    r := TXMLTag.Create('iq');
    with r do begin
        PutAttribute('id', tag.getAttribute('id'));
        PutAttribute('type', 'result');
        PutAttribute('to', tag.getAttribute('from'));
        with AddTag('query') do begin
            PutAttribute('xmlns', XMLNS_VERSION);
            AddBasicTag('name', 'Exodus');
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
             Format(sNotifyAutoResponse, [sTime,
                                          getNick(tag.getAttribute('from'))]),
             ico_info);

    r := TXMLTag.Create('iq');
    res := GetTimeZoneInformation(tzi);
    if res = TIME_ZONE_ID_DAYLIGHT then
        utc := Now + ((tzi.Bias + 60) / 1440.0)
    else
        utc := Now + (tzi.Bias / 1440.0);

    with r do begin
        PutAttribute('to', tag.getAttribute('from'));
        PutAttribute('id', tag.getAttribute('id'));
        PutAttribute('type', 'result');

        with AddTag('query') do begin
            PutAttribute('xmlns', XMLNS_TIME);
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
             Format(sNotifyAutoResponse, [sLast,
                                          getNick(tag.getAttribute('from'))]),
             ico_info);

    // Respond to last queries
    r := TXMLTag.Create('iq');
    with r do begin
        PutAttribute('to', tag.getAttribute('from'));
        PutAttribute('id', tag.getAttribute('id'));
        PutAttribute('type', 'result');

        with AddTag('query') do begin
            PutAttribute('xmlns', XMLNS_LAST);
            idle := (GetTickCount() - frmExodus.getLastTick()) div 1000;
            PutAttribute('seconds', IntToStr(idle));
            end;
        end;

    _session.sendTag(r);
end;

{---------------------------------------}
constructor TBrowseResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_BROWSE);
end;

{---------------------------------------}
procedure TBrowseResponder.iqCallback(event: string; tag: TXMLTag);
var
    r: TXMLTag;
begin
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    DoNotify(nil, 'notify_autoresponse',
             Format(sNotifyAutoResponse, [sBrowse,
                                          getNick(tag.getAttribute('from'))]),
             ico_info);

    r := TXMLTag.Create('iq');
    with r do begin
        PutAttribute('to', tag.getAttribute('from'));
        PutAttribute('id', tag.GetAttribute('id'));
        PutAttribute('type', 'result');

        with AddTag('user') do begin
            PutAttribute('xmlns', XMLNS_BROWSE);
            PutAttribute('type', 'client');
            PutAttribute('jid', _session.Username + '@' + _session.Server +
                '/' + _session.Resource);
            PutAttribute('name', _session.Username);

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
            end;
        end;
    _session.SendTag(r);
end;

{---------------------------------------}
constructor TDiscoItemsResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_DISCOITEMS);
end;

{---------------------------------------}
procedure TDiscoItemsResponder.iqCallback(event: string; tag:TXMLTag);
var
    r, q: TXMLTag;
begin
    // return an empty result set.
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;
    DoNotify(nil, 'notify_autoresponse',
             Format(sNotifyAutoResponse, [sDisco,
                                          getNick(tag.getAttribute('from'))]),
             ico_info);

    r := TXMLTag.Create('iq');
    with r do begin
        PutAttribute('to', tag.getAttribute('from'));
        PutAttribute('id', tag.GetAttribute('id'));
        PutAttribute('type', 'result');
        q := AddTag('query');
        q.PutAttribute('xmlns', XMLNS_DISCOITEMS);
        end;
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
            PutAttribute('type', stype);
    end;

var
    r, q: TXMLTag;
begin
    // return info results
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;
    DoNotify(nil, 'notify_autoresponse',
             Format(sNotifyAutoResponse, [sDisco,
                                          getNick(tag.getAttribute('from'))]),
             ico_info);

    r := TXMLTag.Create('iq');
    with r do begin
        PutAttribute('to', tag.getAttribute('from'));
        PutAttribute('id', tag.GetAttribute('id'));
        PutAttribute('type', 'result');
        q := AddTag('query');
        with q do begin
            PutAttribute('xmlns', XMLNS_DISCOINFO);
            with AddTag('identity') do begin
                PutAttribute('category', 'user');
                PutAttribute('type', 'client');
                PutAttribute('name', _session.Username);
                end;
            end;

        addFeature(q, XMLNS_SEARCH);
        addFeature(q, XMLNS_AGENTS);

        addFeature(q, XMLNS_IQOOB);
        addFeature(q, XMLNS_BROWSE);
        addFeature(q, XMLNS_TIME);
        addFeature(q, XMLNS_VERSION);
        addFeature(q, XMLNS_LAST);
        addFeature(q, XMLNS_DISCOITEMS);
        addFeature(q, XMLNS_DISCOINFO);

        addFeature(q, XMLNS_BM);
        addFeature(q, XMLNS_XDATA);
        addFeature(q, XMLNS_XCONFERENCE);
        addFeature(q, XMLNS_XEVENT);

        addFeature(q, XMLNS_MUC);
        addFeature(q, XMLNS_MUCUSER);
        addFeature(q, XMLNS_MUCOWNER);
        end;

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

initialization
    _version := nil;
    _time := nil;
    _last := nil;
    _browse := nil;
    _xdata := nil;
    _iqoob := nil;

end.
