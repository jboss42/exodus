unit ExEvents;
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
    XMLTag, Unicode,
    Types, SysUtils, Classes;

type
    TJabberEventType = (
        evt_None,
        evt_Message,
        evt_Invite,
        evt_RosterItems,
        evt_OOB,
        evt_Version,
        evt_Time,
        evt_Last);

    TJabberEvent = class
    private
        _data_list: TWideStringlist;
        _tag: TXMLTag;

    public
        Timestamp: TDateTime;
        eType: TJabberEventType;
        from: WideString;
        id: WideString;
        edate: TDateTime;
        data_type: WideString;
        delayed: boolean;
        elapsed_time: longint;
        img_idx: integer;
        msg: WideString;
        caption: WideString;
        error: boolean;

        constructor create; overload;
        constructor create(evt: TJabberEvent); overload;
        
        destructor destroy; override;
        procedure Parse(tag: TXMLTag);

        property Data: TWideStringlist read _data_list;
        property Tag: TXMLTag read _tag;
end;

function CreateJabberEvent(tag: TXMLTag): TJabberEvent;
procedure RenderEvent(e: TJabberEvent);

function getTaskBarRect(): TRect;


resourcestring
    sPresUnavailable = 'Unavailable presence';
    sPresAvailable = 'Available presence';
    sPresChat = 'Chat presence';
    sPresAway = 'Away presence';
    sPresXA = 'Ext. Away presence';
    sPresDND = 'Do Not Disturb presence';
    sPresS10n = 'Subscription request';
    sPresGrant = 'Subscription granted';
    sPresDeny = 'Subscription denied/revoked';
    sPresUnsub = 'Unsubscribe presence packet';

    sMsgTime = 'Time Response';
    sMsgTimeInfo = 'Time, Ping Response: ';
    sMsgLocalTime = 'Local Time: ';

    sMsgVersion = 'Version Response';
    sMsgVerClient = 'Description: ';
    sMsgVerVersion = 'Version: ';
    sMsgVerOS = 'OS: ';

    sMsgLast = 'Last Activity';
    sMsgLastInfo = 'Idle for ';

    sMsgURL = 'This message contains a URL: ';

    sPresError = 'The jabber server can not contact the server where this user is hosted.' +
        'Click "Remove" to remove this contact from your roster.';


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    // Exodus/JOPL stuff
    ExUtils, JabberConst, Jabber1, JabberID, JabberMsg, MsgController, MsgRecv,
    MsgQueue, Notify, PrefController, Roster, Session, XMLUtils,

    // delphi stuff
    Messages, Windows;

var
    _taskbar_rect: TRect;

{---------------------------------------}
function CreateJabberEvent(tag: TXMLTag): TJabberEvent;
var
    e: TJabberEvent;
begin
    // Create a new event based on this tag.
    e := TJabberEvent.Create;
    e.Parse(tag);
    Result := e;
end;

{---------------------------------------}
procedure RenderEvent(e: TJabberEvent);
var
    msg: string;
    img_idx: integer;
    mqueue: TfrmMsgQueue;
    tmp_jid: TJabberID;
    m, xml, etag: TXMLTag;
    ritem: TJabberRosterItem;
    msgo: TJabberMessage;
    mc: TMsgController;
begin
    // create a listview item for this event
    tmp_jid := TJabberID.Create(e.from);
    case e.etype of
    evt_Time: begin
        img_idx := 12;
        msg := e.data_type;
        e.Data.Add(Format(sMsgPing, [IntToStr(e.elapsed_time)]));
    end;

    evt_Message: begin
        img_idx := 18;
        msg := e.data_type;
        DoNotify(nil, 'notify_normalmsg',
                 sMsgMessage + tmp_jid.jid, img_idx);
        if (e.error) then img_idx := ico_error;

        xml := e.tag;
        if (xml <> nil) then begin

            // check for displayed events
            etag := xml.QueryXPTag(XP_MSGXEVENT);
            if ((etag <> nil) and (etag.GetFirstTag('id') = nil)) then begin
                if (etag.GetFirstTag('displayed') <> nil) then begin
                    // send back a displayed event
                    m := generateEventMsg(xml, 'displayed');
                    MainSession.SendTag(m);
                end;
            end;

            // log the msg if we're logging.
            if (MainSession.Prefs.getBool('log')) then begin
                msgo := TJabberMessage.Create(xml);
                msgo.isMe := false;
                ritem := MainSession.roster.Find(tmp_jid.jid);
                if (ritem <> nil) then
                    msgo.Nick := ritem.Nickname
                else
                    msgo.Nick := msgo.FromJID;
                LogMessage(msgo);
                msgo.Free();
            end;
        end;
    end;

    evt_Invite: begin
        img_idx := 21;
        msg := e.data_type;
        DoNotify(nil, 'notify_invite',
                 sMsgInvite + tmp_jid.jid, img_idx);
    end;

    evt_RosterItems: begin
        img_idx := 26;
        msg := e.data_type;
    end;

    else begin
        img_idx := 12;
        msg := e.data_type;
    end;
    end;

    tmp_jid.Free();

    if MainSession.Prefs.getBool('expanded') then begin
        getMsgQueue().LogEvent(e, msg, img_idx);
        if ((MainSession.Prefs.getInt('invite_treatment') = invite_popup) and
            (e.eType = evt_Invite)) then begin
            StartRecvMsg(e);
        end;
    end

    else if (e.delayed) or (MainSession.Prefs.getBool('msg_queue')) then begin
        // we are collapsed, but this event was delayed (offline'd)
        // or we always want to use the msg queue
        // so display it in the msg queue, not live
        mqueue := getMsgQueue();
        mqueue.Show;

        // Note that LogEvent takes ownership of e
        mqueue.LogEvent(e, msg, img_idx);
    end

    else begin
        // we are collapsed, just display in regular popup windows
        mc := MainSession.MsgList.FindJid(e.from);
        if (mc <> nil) then
            TfrmMsgRecv(mc).PushEvent(e)
        else
            StartRecvMsg(e);
    end;
end;


{---------------------------------------}
function getTaskBarRect: TRect;
var
    taskbar: HWND;
begin
    // get the taskbar rectangle
    if (_taskbar_rect.left = _taskbar_rect.right) then begin
        taskbar := FindWindow('Shell_TrayWnd', '');
        GetWindowRect(taskbar, _taskbar_rect);
    end;
    Result := _taskbar_rect;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberEvent.create;
begin
    inherited;

    _data_list := TWideStringList.Create;
    _tag := nil;
    delayed := false;
    error := false;
    edate := Now();
end;

constructor TJabberEvent.Create(evt: TJabberEvent);
begin
    inherited Create();

    _data_list := TWidestringList.Create();
    _tag := nil;

    Timestamp := evt.Timestamp;
    eType := evt.eType;
    from := evt.from;
    id := evt.id;
    edate := evt.edate;
    data_type := evt.data_type;
    delayed := evt.delayed;
    elapsed_time := evt.elapsed_time;
    img_idx := evt.img_idx;
    msg := evt.msg;
    caption := evt.caption;
    error := evt.error;
    _data_list.Assign(evt.Data);
end;


{---------------------------------------}
destructor TJabberEvent.destroy;
begin
    ClearStringListObjects(_data_list);
    _data_list.Free;
    FreeAndNil(_tag);

    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberEvent.Parse(tag: TXMLTag);
var
    ns, t: Widestring;
    delay, qtag, tmp_tag: TXMLTag;
    i_tags: TXMLTagList;
    j: integer;
    ri: TJabberRosterItem;
begin
    // create the event from a xml tag
    _tag := TXMLTag.Create(tag);
    
    data_type := '';
    if (tag.name = 'message') then begin
        t := tag.getAttribute('type');
        if (t = 'groupchat') then exit;
        if (t = 'chat') then exit;

        // normal default event type
        eType := evt_Message;
        _data_list.Clear();

        // pull out from & ID for all types of events
        from := tag.getAttribute('from');
        id := tag.getAttribute('id');

        // Look for various x-tags
        if (tag.QueryXPTag(XP_MUCINVITE) <> nil) then begin
            // This is a MUC invite
            eType := evt_Invite;
            tmp_tag := tag.QueryXPTag(XP_MUCINVITE);
            from := tmp_tag.QueryXPData('/x/invite@from');
            data_type := tag.getAttribute('from');
            _data_list.Add(tmp_tag.QueryXPData('/x/invite/reason'));
        end

        else if (tag.QueryXPTag(XP_CONFINVITE) <> nil) then begin
            // conference invite
            eType := evt_Invite;
            tmp_tag := tag.QueryXPTag(XP_CONFINVITE);
            data_type := tmp_tag.getAttribute('jid');
        end

        else if (tag.QueryXPTag(XP_JCFINVITE) <> nil) then begin
            // GC Invite
            eType := evt_Invite;
            data_type := tag.GetAttribute('from')
        end

        else if (tag.QueryXPTag(XP_MSGXROSTER) <> nil) then begin
            // we are getting roster items
            eType := evt_RosterItems;
            tmp_tag := tag.QueryXPTag(XP_MSGXROSTER);
            data_type := tag.GetBasicText('body');
            i_tags := tmp_tag.QueryTags('item');
            for j := 0 to i_tags.Count - 1 do begin
                ri := TJabberRosterItem.Create();
                ri.parse(i_tags[j]);
                _data_list.AddObject(ri.jid.jid, ri);
            end;
            i_tags.Free();
        end;

        // When we are doing roster items, the _data_list contains the items.
        if (eType <> evt_RosterItems) then begin
            tmp_tag := tag.GetFirstTag('body');
            if (tmp_tag <> nil) then
                _data_list.Add(tmp_tag.Data);

            // check for x:oob URL's
            tmp_tag := tag.QueryXPTag(XP_XOOB);
            if (tmp_tag <> nil) then begin
                _data_list.Add(sMsgURL);
                _data_list.Add(tmp_tag.GetBasicText('desc'));
                _data_list.Add(tmp_tag.GetBasicText('url'));
            end;
        end;

        // For messages, pull out the subject
        if (eType = evt_Message) then begin
            tmp_tag := tag.GetFirstTag('subject');
            if (tmp_tag <> nil) then
                data_type := tmp_tag.Data;

            // check for errors..
            if (tag.getAttribute('type') = 'error') then begin
                tmp_tag := tag.GetFirstTag('error');
                if (tmp_tag <> nil) then begin
                    data_type := 'ERROR: ' + tmp_tag.Data();
                    _data_list.Insert(0, 'ERROR: ' + tmp_tag.Data() + ', Code=' +
                        tmp_tag.getAttribute('code'));
                end
                else
                    data_type := 'Unknown Error';
                error := true;
                _data_list.Insert(1, 'Original Message was:');
            end;
        end;

        delay := tag.QueryXPTag(XP_MSGDELAY);
        if (delay <> nil) then begin
            // we have a delay tag
            edate := JabberToDateTime(delay.getAttribute('stamp'));
            delayed := true;
        end
        else
            edate := Now();
    end

    else if (tag.name = 'iq') then begin
        from := tag.getAttribute('from');
        id := tag.getAttribute('id');

        ns := tag.Namespace(true);
        if ns = XMLNS_TIME then begin
            eType := evt_Time;
            data_type := sMsgTime;
            qTag := tag.getFirstTag('query');
            tmp_tag := qtag.getFirstTag('display');
            _data_list.Add(sMsgTimeInfo);
            if (tmp_tag <> nil) then
                _data_list.Add(sMsgLocalTime + tmp_tag.Data);
        end

        else if ns = XMLNS_VERSION then begin
            eType := evt_Version;
            data_type := sMsgVersion;
            qTag := tag.getFirstTag('query');
            _data_list.Add(sMsgVersion);

            tmp_tag := qtag.getFirstTag('name');
            if (tmp_tag <> nil) then
                _data_list.Add(sMsgVerClient + tmp_tag.Data);

            tmp_tag := qtag.getFirstTag('version');
            if (tmp_tag <> nil) then
                _data_list.Add(sMsgVerVersion + tmp_tag.Data);

            tmp_tag := qtag.getFirstTag('os');
            if (tmp_tag <> nil) then
                _data_list.Add(sMsgVerOS + tmp_tag.Data);
        end

        else if ns = XMLNS_LAST then begin
            eType := evt_Last;
            qTag := tag.getFirstTag('query');
            if (qtag = nil) then exit;
            _data_list.Add(sMsgLastInfo + secsToDuration(qTag.getAttribute('seconds')) + '.');
        end;
    end;
end;


end.
