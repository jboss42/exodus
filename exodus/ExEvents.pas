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

        constructor create;
        destructor destroy; override;
        procedure Parse(tag: TXMLTag);

        property Data: TWideStringlist read _data_list;
    end;

function getTaskBarRect(): TRect;
function CreateJabberEvent(tag: TXMLTag): TJabberEvent;

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
    sMsgVerClient = 'Client: ';
    sMsgVerVersion = 'Version: ';
    sMsgVerOS = 'OS: ';

    sMsgLast = 'Last Activity';
    sMsgLastInfo = 'Idle for ';

    sPresError = 'The jabber server can not contact the server where this user is hosted.' +
        'Click "Remove" to remove this contact from your roster.';


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Roster, Messages, Windows, ExUtils, Session;

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
    delayed := false;
    error := false;
    edate := Now();
end;

{---------------------------------------}
destructor TJabberEvent.destroy;
begin
    _data_list.Free;
    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberEvent.Parse(tag: TXMLTag);
var
    ns, t: Widestring;
    delay, qtag, tmp_tag: TXMLTag;
    i_tags, c_tags: TXMLTagList;
    i, j: integer;
    ri: TJabberRosterItem;
begin
    // create the event from a xml tag
    data_type := '';
    if (tag.name = 'message') then begin
        t := tag.getAttribute('type');
        if (t = 'groupchat') then exit;
        if (t = 'chat') then exit;

        eType := evt_Message;

        // Look at all of the child tags of <message>
        c_tags := tag.ChildTags();
        for i := 0 to c_tags.Count - 1 do begin
            tmp_tag := c_tags[i];
            ns := tmp_tag.Namespace;
            if ((ns = 'jabber:x:invite') or (ns = 'jabber:x:conference')) then begin
                // we are getting an invite
                eType := evt_Invite;
                if (ns = 'jabber:x:invite') then
                    data_type := tag.GetAttribute('from')
                else
                    data_type := tmp_tag.GetAttribute('jid');
                end
            else if (ns = 'jabber:x:roster') then begin
                // we are getting roster items
                eType := evt_RosterItems;
                data_type := tag.GetBasicText('body');
                i_tags := tmp_tag.QueryTags('item');
                for j := 0 to i_tags.Count - 1 do begin
                    ri := TJabberRosterItem.Create();
                    ri.parse(i_tags[j]);
                    _data_list.AddObject(ri.jid.jid, ri);
                    end;
                i_tags.Free();
                end;
            end;
        c_tags.Free();

        // pull out from & ID for all types of events
        from := tag.getAttribute('from');
        id := tag.getAttribute('id');

        // When we are doing roster items, the _data_list contains the items.
        if (eType <> evt_RosterItems) then begin
            tmp_tag := tag.GetFirstTag('body');
            if (tmp_tag <> nil) then
                _data_list.Text := tmp_tag.Data;
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

        delay := tag.QueryXPTag('/message/x[@xmlns="jabber:x:delay"]');
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
            _data_list.Add(sMsgVerClient + tmp_tag.Data);

            tmp_tag := qtag.getFirstTag('version');
            _data_list.Add(sMsgVerVersion + tmp_tag.Data);

            tmp_tag := qtag.getFirstTag('os');
            _data_list.Add(sMsgVerOS + tmp_tag.Data);
            end

        else if ns = XMLNS_LAST then begin
            eType := evt_Last;
            qTag := tag.getFirstTag('query');
            data_type := sMsgLast;
            _data_list.Add(sMsgLastInfo + secsToDuration(qTag.getAttribute('seconds')) + '.');
            end;
        end;
end;


end.
