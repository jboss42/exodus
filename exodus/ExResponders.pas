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
    TVersionResponder = class(TJabberResponder)
    protected
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload; 
    end;

    TTimeResponder = class(TJabberResponder)
    protected
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TLastResponder = class(TJabberResponder)
    protected
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TBrowseResponder = class(TJabberResponder)
    protected
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;



{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Jabber1;

{---------------------------------------}
constructor TVersionResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, 'jabber:iq:version');
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

    win := '';
    WindowsVersion(win);
    app := GetAppVersion;

    r := TXMLTag.Create('iq');
    with r do begin
        PutAttribute('id', tag.getAttribute('id'));
        PutAttribute('type', 'result');
        PutAttribute('to', tag.getAttribute('from'));
        with AddTag('query') do begin
            PutAttribute('xmlns', 'jabber:iq:version');
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
    inherited Create(Session, 'jabber:iq:time');
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
            PutAttribute('xmlns', 'jabber:iq:time');
            AddBasicTag('utc', DateTimeToJabber(utc));
            AddBasicTag('tz', tzi.StandardName);
            AddBasicTag('display', DateTimeToStr(Now));
            end;
        end;

    _session.sendTag(r);
end;

constructor TLastResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, 'jabber:iq:last');
end;

procedure TLastResponder.iqCallback(event: string; tag: TXMLTag);
var
    idle: dword;
    r: TXMLTag;
begin
    // Respond to time queries
    r := TXMLTag.Create('iq');
    with r do begin
        PutAttribute('to', tag.getAttribute('from'));
        PutAttribute('id', tag.getAttribute('id'));
        PutAttribute('type', 'result');

        with AddTag('query') do begin
            PutAttribute('xmlns', 'jabber:iq:last');
            idle := (GetTickCount() - IdleUIGetLastInputTime()) div 1000;
            PutAttribute('seconds', IntToStr(idle));
            end;
        end;

    _session.sendTag(r);
end;

constructor TBrowseResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, 'jabber:iq:browse');
end;

procedure TBrowseResponder.iqCallback(event: string; tag: TXMLTag);
var
    r: TXMLTag;
begin
    r := TXMLTag.Create('iq');
    with r do begin
        PutAttribute('to', tag.getAttribute('from'));
        PutAttribute('id', tag.GetAttribute('id'));
        PutAttribute('type', 'result');

        with AddTag('user') do begin
            PutAttribute('xmlns', 'jabber:iq:browse');
            PutAttribute('type', 'client');
            PutAttribute('jid', _session.Username + '@' + _session.Server +
                '/' + _session.Resource);
            PutAttribute('name', _session.Username);

            AddBasicTag('ns', 'jabber:x:conference');
            AddBasicTag('ns', 'jabber:x:oob');
            AddBasicTag('ns', 'jabber:iq:oob');
            AddBasicTag('ns', 'jabber:iq:browse');
            AddBasicTag('ns', 'jabber:iq:time');
            AddBasicTag('ns', 'jabber:iq:version');
            AddBasicTag('ns', 'jabber:iq:last');

            end;
        end;
    _session.SendTag(r);
end;






end.
