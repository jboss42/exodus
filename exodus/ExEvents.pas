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

function ParseTimeEvent(iq: TXMLTag): Widestring;
function ParseVersionEvent(iq: TXMLTag): Widestring;
function ParseLastEvent(iq: TXMLTag): Widestring;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    // Exodus/JOPL stuff
    GnuGetText,
    ExUtils, JabberConst, Jabber1, JabberID, JabberMsg, MsgController, MsgRecv,
    MsgQueue, Notify, PrefController, NodeItem, Roster, Session, XMLUtils,

    // delphi stuff
    Messages, Windows;

const
    sMsgMessage = 'Msg from ';
    sMsgInvite = 'Invite from ';
    sMsgTime = 'Time Response';
    sMsgTimeInfo = 'Time, Ping Response: ';
    sMsgLocalTime = 'Local Time: ';
    sMsgPing = 'Ping Time: %s seconds.';

    sMsgVersion = 'Version Response';
    sMsgVerClient = 'Description: ';
    sMsgVerVersion = 'Version: ';
    sMsgVerOS = 'OS: ';

    sMsgLast = 'Last Activity';
    sMsgLastInfo = 'Idle for ';

    sMsgURL = 'This message contains a URL: ';

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
    end;

    evt_Message: begin
        img_idx := 18;
        msg := e.data_type;
        DoNotify(nil, 'notify_normalmsg',
                 _(sMsgMessage) + tmp_jid.jid, img_idx);
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
                 _(sMsgInvite) + tmp_jid.jid, img_idx);
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

        if (not mqueue.Visible) then with mqueue do begin
            if (frmExodus.isMinimized()) then
                ShowWindow(Handle, SW_SHOWMINNOACTIVE)
            else
                ShowWindow(Handle, SW_SHOWNOACTIVATE);
            Visible := true;
        end;


        // Note that LogEvent takes ownership of e
        mqueue.LogEvent(e, msg, img_idx);
    end

    else begin
        // we are collapsed, just display in regular popup windows
        mc := MainSession.MsgList.FindJid(e.from);
        if (mc <> nil) then
            TfrmMsgRecv(mc.Data).PushEvent(e)
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
function ParseTimeEvent(iq: TXMLTag): Widestring;
var
    tmp_tag, qTag: TXMLTag;
    s, msg: Widestring;
begin
    Result := '';
    qTag := iq.getFirstTag('query');
    if (qTag = nil) then exit;
    
    msg := _(sMsgTime);
    tmp_tag := qtag.getFirstTag('display');
    if (tmp_tag <> nil) then
        msg := msg + #13 + _(sMsgLocalTime) + tmp_tag.Data;
    s := iq.GetAttribute('iq_elapsed_time');
    if (s <> '') then
        msg := msg + #13 + WideFormat(_(sMsgPing), [s]);
    Result := msg;
end;

{---------------------------------------}
function ParseVersionEvent(iq: TXMLTag): Widestring;
var
    tmp_tag, qTag: TXMLTag;
    msg: Widestring;
begin
    Result := '';
    qTag := iq.getFirstTag('query');
    if (qTag = nil) then exit;

    tmp_tag := qtag.getFirstTag('name');
    if (tmp_tag <> nil) then
        msg := _(sMsgVersion) + #13 + _(sMsgVerClient) + tmp_tag.Data + #13;

    tmp_tag := qtag.getFirstTag('version');
    if (tmp_tag <> nil) then
        msg := msg + _(sMsgVerVersion) + tmp_tag.Data + #13;

    tmp_tag := qtag.getFirstTag('os');
    if (tmp_tag <> nil) then
        msg := msg + _(sMsgVerOS) + tmp_tag.Data;

    Result := msg;
end;

{---------------------------------------}
function ParseLastEvent(iq: TXMLTag): Widestring;
var
    qTag: TXMLTag;
begin
    Result := '';
    qTag := iq.getFirstTag('query');
    if (qTag = nil) then exit;

    Result := _(sMsgLastInfo) + secsToDuration(qTag.getAttribute('seconds')) + '.';
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
    tmps, ns, t: Widestring;
    delay, tmp_tag: TXMLTag;
    i_tags: TXMLTagList;
    j: integer;
    ri: TJabberRosterItem;
    url_tags: TXMLTagList;
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
            url_tags := tag.QUeryXPTags(XP_XOOB);
            for j := 0 to url_tags.Count - 1 do begin
                tmp_tag := url_tags[j];
                _data_list.Add(_(sMsgURL));
                _data_list.Add(tmp_tag.GetBasicText('url'));
                tmps := tmp_tag.GetBasicText('desc');
                if (tmps <> '') then _data_list.Add(tmps);
            end;
            url_tags.Free();
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
                    data_type := _('ERROR: ') + tmp_tag.Data();
                    _data_list.Insert(0, _('ERROR: ') + tmp_tag.Data() + _(', Code=') +
                        tmp_tag.getAttribute('code'));
                end
                else
                    data_type := _('Unknown Error');
                error := true;
                _data_list.Insert(1, _('Original Message was:'));
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
            data_type := _(sMsgTime);
            _data_list.Add(ParseTimeEvent(tag));
        end

        else if ns = XMLNS_VERSION then begin
            eType := evt_Version;
            data_type := _(sMsgVersion);
            _data_list.Add(ParseVersionEvent(tag));
        end

        else if ns = XMLNS_LAST then begin
            eType := evt_Last;
            data_type := _(sMsgLast);
            _data_list.Add(ParseLastEvent(tag));
        end;
    end;

    if (from <> '') then
        caption := from;
end;


end.
