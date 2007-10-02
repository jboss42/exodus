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
    XMLTag, ChatController, Unicode, JabberID,
    Types, SysUtils, Classes;

type
    TJabberEventType = (
        evt_None,
        evt_Message,
        evt_Invite,
        evt_AffilChange,
        evt_RosterItems,
        evt_OOB,
        evt_Version,
        evt_Time,
        evt_Last,
        evt_Chat);

    TJabberEvent = class
    private
        _data_list: TWideStringlist;
        _tag: TXMLTag;
    public
        Timestamp: TDateTime;
        eType: TJabberEventType;
        from: WideString;
        from_jid: TJabberID;
        id: WideString;
        edate: TDateTime;
        str_content: WideString;
        delayed: boolean;
        elapsed_time: longint;
        img_idx: integer;
        msg: WideString;
        caption: WideString;
        error: boolean;
        password: Widestring;

        constructor create; overload;
        constructor create(evt: TJabberEvent); overload;

        destructor Destroy; override;
        procedure Parse(tag: TXMLTag);

        property Data: TWideStringlist read _data_list;
        property tag: TXMLTag read _tag;

    end;

function CreateJabberEvent(tag: TXMLTag): TJabberEvent;
procedure RenderEvent(e: TJabberEvent);
procedure LogMsgEvent(e: TJabberEvent);
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
    DisplayName,
    RosterImages,
    Forms,
    StateForm,
    RosterRecv,
    GnuGetText,
    JabberUtils, ExUtils,  JabberConst, Jabber1, JabberMsg, MsgController, MsgRecv,
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
begin
    // Create a new event based on this tag.
    Result := TJabberEvent.Create;
    Result.Parse(tag);
end;

{---------------------------------------}
procedure RenderEvent(e: TJabberEvent);
var
    msg: string;
    img_idx: integer;
    tmp_jid: TJabberID;
    m, xml, etag: TXMLTag;
    notify: boolean;
    notifyMsg: WideString;
    notifyType: WideString;
    notifyFrm: TfrmState;
    frmMsg: TfrmMsgQueue;
    queueMsg: Boolean;
begin
    notify := false;
    // create a listview item for this event
    tmp_jid := TJabberID.Create(e.from);
    case e.etype of
        evt_Chat: begin
            img_idx := 23;
            msg := e.str_content;
            notify := true;
            notifyMsg := _('Chat with ') + DisplayName.getDisplayNameCache().getDisplayName(tmp_jid);
            notifyType := 'notify_newchat';
        end;

        evt_Message: begin
            if (e.error) then
                img_idx := RosterTreeImages.Find('error')
            else
                img_idx := RosterTreeImages.Find('newsitem');

            msg := e.str_content;

            notify := true;
            notifyMsg := _(sMsgMessage) + DisplayName.getDisplayNameCache().getDisplayName(tmp_jid);
            notifyType := 'notify_normalmsg';

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
                LogMsgEvent(e);
            end;
        end;

        evt_Invite: begin
            img_idx := 21;
            msg := e.str_content;
            notify := true;
            notifyMsg := _(sMsgInvite) + DisplayName.getDisplayNameCache().getDisplayName(tmp_jid);
            notifyType := 'notify_invite';
        end;

        evt_RosterItems: begin
            //StartRecvMsg(e);
            //e.Free();//msg queue does not own this, need to cleanup
            //exit;
            //notify := false;
        end;

        else begin
            img_idx := 12;
            msg := e.str_content;
        end;
    end; //case

    tmp_jid.Free();

  
    //Log event and display message queue based on preferences
//    MainSession.EventQueue.LogEvent(e, msg, img_idx); //e now referenced by frmMsg, don't free
//    if (MsgQueue.isMsgQueueShowing() or e.delayed or
//        MainSession.Prefs.getBool('msg_queue') or
//        (e.eType = evt_Chat)) then begin
//
//        if (not frmExodus.visible) then
//            frmMsg := ShowMsgQueue(false, 'f')
//        else frmMsg := ShowMsgQueue(false);
//
//        //invites may still be popped up, even in the messages show up here
//        if ((e.eType = evt_Invite) and
//            (MainSession.Prefs.getInt('invite_treatment') = invite_popup)) then begin
//            notifyFrm := StartRecvMsg(e);
//        end
//        else notifyFrm := frmMsg;
//
//    end
//    else begin
//        notifyFrm := StartRecvMsg(e);
//        e.Free(); //msgqueue does not own this, need to cleanup
//    end;
    queueMsg := MainSession.Prefs.getBool('queue_not_avail') and
                ((MainSession.Show = 'away') or
                 (MainSession.Show = 'xa') or
                 (MainSession.Show = 'dnd')) or
                 e.delayed;

    if (queueMsg) then begin
      MainSession.EventQueue.LogEvent(e, msg, img_idx); //e now referenced by frmMsg, don't free
      frmMsg := ShowMsgQueue(false);
      notifyFrm := frmMsg;
      if (e.delayed = false) then
        notify := false;
    end
    else begin
      notifyFrm := StartRecvMsg(e);
      e.Free(); //msgqueue does not own this, need to cleanup 
    end;
    
    if (notify) then
        DoNotify(notifyFrm, notifyType, notifyMsg, img_idx);
end;

{---------------------------------------}
procedure LogMsgEvent(e: TJabberEvent);
var
    m: TJabberMessage;
    ritem: TJabberRosterItem;
    tmp_jid: TJabberID;
begin
    tmp_jid := TJabberID.Create(e.from);

    m := TJabberMessage.Create(e.tag);
    m.isMe := false;
    ritem := MainSession.roster.Find(tmp_jid.jid);
    if (ritem <> nil) then
        m.Nick := ritem.Text
    else
        m.Nick := m.FromJID;
    LogMessage(m);
    m.Free();
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
var
    c: TChatController;
begin
    inherited Create();

    _data_list := TWidestringList.Create();
    _tag := nil;

    Timestamp := evt.Timestamp;
    eType := evt.eType;
    from := evt.from;
    from_jid := TJabberID.Create(from);
    id := evt.id;
    edate := evt.edate;
    str_content := evt.str_content;
    delayed := evt.delayed;
    elapsed_time := evt.elapsed_time;
    img_idx := evt.img_idx;
    msg := evt.msg;
    caption := evt.caption;
    error := evt.error;
    _data_list.Assign(evt.Data);
    //chats should not be created in this way, but for completeness sake...
    if ((eType = evt_Chat) and (from_jid <> nil) and (MainSession <> nil)) then begin
        c := MainSession.ChatList.FindChat(from_jid.jid, from_jid.resource, '');
        assert(c <> nil);
        c.addref();
    end;
end;

{---------------------------------------}
destructor TJabberEvent.destroy;
var
    c: TChatController;
begin
    if ((eType = evt_Chat) and (from_jid <> nil) and (MainSession <> nil)) then begin
        c := MainSession.ChatList.FindChat(from_jid.jid, from_jid.resource, '');
        if (c <> nil) then
            c.Release();
    end;
    ClearStringListObjects(_data_list);
    _data_list.Free();

    if (_tag <> nil) then FreeAndNil(_tag);
    if (from_jid <> nil) then FreeAndNil(from_jid);

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
    cjid: TJabberID;
    c: TChatController;
    ins: Widestring;
begin
    // create the event from a xml tag
    assert(_tag = nil);
    _tag := TXMLTag.Create(tag);

    str_content := '';
    if (tag.name = 'message') then begin

        // throw out groupchat messages
        t := tag.getAttribute('type');
        if (t = 'groupchat') then exit;

        // pull out from & ID for all types of events
        from := tag.getAttribute('from');

        // Check for delay'd msgs
        delay := tag.QueryXPTag(XP_MSGDELAY);
        if (delay <> nil) then begin
            // we have a delay tag
            edate := JabberToDateTime(delay.getAttribute('stamp'));
            delayed := true;
        end
        else
            edate := Now();

        // normal default event type
        _data_list.Clear();
        id := tag.getAttribute('id');

        if (tag.getAttribute('type') = 'error') then begin
            eType := evt_Message;
            tmp_tag := tag.GetFirstTag('error');
            if (tmp_tag <> nil) then begin
                if (tmp_tag.Data() <> '') then
                    str_content := _('ERROR: ') + tmp_tag.Data()
                else
                    str_content := _('ERROR');

                ins := _('ERROR: ');
                if (tmp_tag.Data <> '') then
                    ins := ins + tmp_tag.Data() + _(', Code=')
                else
                    ins := ins + _('Code=');

                ins := ins + tmp_tag.getAttribute('code');
            end
            else
                str_content := _('Unknown Error');
            error := true;
            ins := ins + _(#13#10'Original Message was: ');
            ins := ins + tag.GetBasicText('body');
            _data_list.Insert(0, ins);
        end

        // Look for various x-tags
        else if (tag.QueryXPTag(XP_MUCADMINMSG) <> nil) then begin
            //received an adnmin message from a room (change of affiliation)
            //note this must come before invite handling as both
            //share the same common check for muc#user 
            {* <message from='room' to='me'>
                    <body>affil change</body>
                    <x xmlns='http://jabber.org/protocol/muc#user'>
                        <status code='101'/>
                    </x>
               </message> *}
            etype := evt_AffilChange;
            from := tag.getAttribute('from');
            str_content := _('Your affiliation with the room has changed.');
            _data_list.Add(tag.GetBasicText('body'));
        end
        else if (tag.QueryXPTag(XP_MUCINVITE) <> nil) then begin
            // This is a MUC invite
            eType := evt_Invite;
            tmp_tag := tag.QueryXPTag(XP_MUCINVITE);
            from := tmp_tag.QueryXPData('/x/invite@from');
            cjid := TJabberID.Create(tag.getAttribute('from'));
            str_content := cjid.jid;
            cjid.Free();
            _data_list.Add(tmp_tag.QueryXPData('/x/invite/reason'));
            password := tmp_tag.QueryXPData('/x/password');
        end

        else if (tag.QueryXPTag(XP_CONFINVITE) <> nil) then begin
            // conference invite
            eType := evt_Invite;
            tmp_tag := tag.QueryXPTag(XP_CONFINVITE);
            cjid := TJabberID.Create(tmp_tag.getAttribute('jid'));
            str_content := cjid.jid;
            cjid.Free();
        end

        else if (tag.QueryXPTag(XP_JCFINVITE) <> nil) then begin
            // GC Invite
            eType := evt_Invite;
            str_content := tag.GetAttribute('from')
        end

        else if (tag.QueryXPTag(XP_MSGXROSTER) <> nil) then begin
            // we are getting roster items
            eType := evt_RosterItems;
            tmp_tag := tag.QueryXPTag(XP_MSGXROSTER);
            str_content := tag.GetBasicText('body');
            i_tags := tmp_tag.QueryTags('item');
            for j := 0 to i_tags.Count - 1 do begin
                ri := TJabberRosterItem.Create(i_tags[j].GetAttribute('jid'));
                MainSession.roster.parseItem(ri, i_tags[j]);
                _data_list.AddObject(DisplayName.getDisplayNameCache().getDisplayName(ri.Jid), ri);
            end;
            i_tags.Free();
        end

        else if (t = 'chat') then begin
            // this is a queue'd chat msg
            eType := evt_Chat;
            str_content := tag.QueryXPData('/message/subject');
            _data_list.Clear();
            _data_list.Add(_('New chat conversation'));
            _data_list.Add('Double click to open chat window');
            cjid := TJabberID.Create(from);
            c := MainSession.ChatList.FindChat(cjid.jid, cjid.resource, '');
            assert(c <> nil);
            c.addRef();
            FreeAndNil(_tag);
        end

        else begin
            // general non-chat message
            eType := evt_Message;
            str_content := tag.QueryXPData('/message/subject');

            // Add the body to the event
            _data_list.Add(tag.QueryXPData('/message/body'));

            // check for x:oob URL's
            url_tags := tag.QueryXPTags(XP_XOOB);
            for j := 0 to url_tags.Count - 1 do begin
                tmp_tag := url_tags[j];
                _data_list.Add(_(sMsgURL));
                _data_list.Add(tmp_tag.GetBasicText('url'));
                tmps := tmp_tag.GetBasicText('desc');
                if (tmps <> '') then _data_list.Add(tmps);
            end;
            url_tags.Free();
        end;

    end

    else if (tag.name = 'iq') then begin
        from := tag.getAttribute('from');
        id := tag.getAttribute('id');

        ns := tag.Namespace(true);
        if ns = XMLNS_TIME then begin
            eType := evt_Time;
            str_content := _(sMsgTime);
            _data_list.Add(ParseTimeEvent(tag));
        end

        else if ns = XMLNS_VERSION then begin
            eType := evt_Version;
            str_content := _(sMsgVersion);
            _data_list.Add(ParseVersionEvent(tag));
        end

        else if ns = XMLNS_LAST then begin
            eType := evt_Last;
            str_content := _(sMsgLast);
            _data_list.Add(ParseLastEvent(tag));
        end;
    end;

    if (from <> '') then begin
        if (from_jid <> nil) then FreeAndNil(from_jid);
        from_jid := TJabberID.Create(from);
        caption := from;
    end;
end;


end.
