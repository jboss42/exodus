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
    XMLTag, 
    Types, SysUtils, Classes;

type
    TJabberEventType = (
        evt_None, 
        evt_Message,
        evt_Invite, 
        evt_Presence,
        evt_OOB, 
        evt_Version,
        evt_Time,
        evt_Last);

    TJabberEvent = class
    private
        _data_list: TStringlist;
    public
        Timestamp: TDateTime;
        eType: TJabberEventType;
        from: string;
        id: string;
        edate: TDateTime;
        data_type: string;
        delayed: boolean;
        elapsed_time: longint;

        constructor create;
        destructor destroy; override;
        procedure Parse(tag: TXMLTag);

        property Data: TStringlist read _data_list;
    end;

function getTaskBarRect(): TRect;
function CreateJabberEvent(tag: TXMLTag): TJabberEvent;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Messages, Windows, ExUtils, Session;

var
    _taskbar_rect: TRect;

{---------------------------------------}
function CreateJabberEvent(tag: TXMLTag): TJabberEvent;
var
    e: TJabberEvent;
begin
    e := TJabberEvent.Create;
    e.Parse(tag);
    Result := e;
end;

{---------------------------------------}
function getTaskBarRect: TRect;
var
    taskbar: HWND;
begin
    //
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
    inherited Create;
    _data_list := TStringList.Create;
    delayed := false;
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
    tmps, s, ptype, ns, t: string;
    delay, qtag, tmp_tag: TXMLTag;
    c_tags: TXMLTagList;
    i: integer;
begin
    // create the event from a xml tag
    data_type := '';
    if (tag.name = 'message') then begin
        t := tag.getAttribute('type');
        if (t = 'groupchat') then exit;
        if (t = 'chat') then exit;

        eType := evt_Message;
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
            end;

        from := tag.getAttribute('from');
        id := tag.getAttribute('id');

        if (eType = evt_Message) then begin
            tmp_tag := tag.GetFirstTag('subject');
            if (tmp_tag <> nil) then
                data_type := tmp_tag.Data;
            end;
        tmp_tag := tag.GetFirstTag('body');
        if (tmp_tag <> nil) then
            _data_list.Text := tmp_tag.Data;

        delay := tag.QueryXPTag('/message/x[@xmlns="jabber:x:delay"]');
        if (delay <> nil) then begin
            // we have a delay tag
            edate := JabberToDateTime(delay.getAttribute('stamp'));
            delayed := true;
            end
        else
            edate := Now();
        end
    else if (tag.name = 'presence') then begin
        eType := evt_Presence;
        from := tag.getAttribute('from');
        id := tag.GetAttribute('id');
        ptype := tag.getAttribute('type');
        data_type := ptype;

        if (ptype = 'unavailable') then
            tmps := 'Unavailable presence'
        else if (ptype = 'subscribe') then
            tmps := 'Subscription request'
        else if (ptype = 'subscribed') then
            tmps := 'Subscription granted'
        else if (ptype = 'unsubscribed') then
            tmps := 'Subscription denied/revoked'
        else if (ptype = 'unsubscribe') then
            tmps := 'Unsubscribe presence packet'
        else begin
            tmp_tag := tag.GetFirstTag('show');
            if (tmp_tag <> nil) then begin
                data_type := tmp_tag.Data;
                if data_type = 'xa' then
                    tmps := 'Ext. Away presence'
                else if data_type = 'away' then
                    tmps := 'Away presence'
                else if data_type = 'chat' then
                    tmps := 'Chat presence'
                else if data_type = 'dnd' then
                    tmps := 'Do Not Disturb presence';
                end
            else begin
                data_type := 'available';
                tmps := 'Available presence';
                end;
            s := tag.getAttribute('status');
            if s <> '' then
                tmps := tmps + ', (' + s + ')';
            end;
        _data_list.Add(tmps);
        end
    else if (tag.name = 'iq') then begin
        from := tag.getAttribute('from');
        id := tag.getAttribute('id');

        ns := tag.Namespace;
        if ns = XMLNS_TIME then begin
            eType := evt_Time;
            data_type := 'Time Response';
            qTag := tag.getFirstTag('query');
            tmp_tag := qtag.getFirstTag('display');
            _data_list.Add('Time, Ping Response');
            _data_list.Add('Local Time: ' + tmp_tag.Data);
            end

        else if ns = XMLNS_VERSION then begin
            eType := evt_Version;
            data_type := 'Version Response';
            qTag := tag.getFirstTag('query');
            _data_list.Add('Version Response');

            tmp_tag := qtag.getFirstTag('name');
            _data_list.Add('Client: ' + tmp_tag.Data);

            tmp_tag := qtag.getFirstTag('version');
            _data_list.Add('Version: ' + tmp_tag.Data);

            tmp_tag := qtag.getFirstTag('os');
            _data_list.Add('OS: ' + tmp_tag.Data);
            end

        else if ns = XMLNS_LAST then begin
            eType := evt_Last;
            qTag := tag.getFirstTag('query');
            data_type := 'Last Activity';
            _data_list.Add('Idle for' + secsToDuration(qTag.getAttribute('seconds')) + '.');
            end;

        {
        else if (ns = XMLNS_IQOOB) then begin
            eType := evt_OOB;
            qTag := tag.getFirstTag('query');
            tmp_tag := qtag.GetFirstTag('url');

            _data_list.Add(tag.GetAttribute('from') + ' is sending you a file. Click on the link below');
            _data_list.Add('File Transfer URL: ' + tmp_tag.Data);

            tmp_tag := qTag.GetFirstTag('desc');
            if (tmp_tag <> nil) then
                _data_list.Add('Description: ' + tmp_tag.Data);

            end;
        }
        end;
end;


end.
