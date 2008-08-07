unit IQ;
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
    Signals, 
    Session,
    {$ifdef Win32}
    ExtCtrls, Windows, StdVcl,
    {$else}
    QExtCtrls,
    {$endif}
    Classes, SysUtils;

const
    BRANDED_MIN_TIMEOUT = 'brand_minimum_iq_timeout';
    PREF_DEFAULT_TIMEOUT = 'test_default_iq_timeout';

    DEFAULT_TIMEOUT = 15;
type
    TJabberIQ = class(TXMLTag)
    private
        _id: Widestring;
        _js: TJabberSession;
        _Callback: TPacketEvent;
        _cbIndex: integer;
        _cbSession: integer;
        _timer: TTimer;
        _ticks: longint;
        _timeout: longint;
    public
        Namespace: string;
        iqType: string;
        toJid: Widestring;
        qTag: TXMLTag;

        constructor Create(session: TJabberSession;
            id: Widestring; cb: TPacketEvent;
            seconds: longint = -1); reintroduce; overload;

        constructor Create(session: TJabberSession; id: Widestring;
            seconds: longint = -1); reintroduce; overload;

        constructor Create(session: TJabberSession; id: Widestring;
            payload: TXMLTag; cb: TPacketEvent;
            seconds: longint = -1); reintroduce; overload;

        destructor Destroy; override;
        procedure Send;

        procedure Timeout(Sender: TObject);
        procedure iqCallback(event: string; xml: TXMLTag);
        procedure disCallback(event: string; xml: TXMLTag);

        property ElapsedTime: longint read _ticks;
        property JabberSession: TJabberSession read _js;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

var
    _computedMinTimeout: integer;

constructor TJabberIQ.Create(session: TJabberSession;
                             id: Widestring;
                             seconds: longint);
begin
    inherited Create();

    _js := session;
    _id := id;
    _cbIndex := -1;
    _timer := TTimer.Create(nil);
    _timer.Interval := 1000;
    _timer.Enabled := false;
    _timer.OnTimer := Timeout;
    _ticks := 0;

    //see if a default has been set in the prefs
    if (_computedMinTimeout < 0) then
    begin
        //use a default if its specified in prefs, if not, use hard coded DEFAULT_TIMEOUT
        //this allows us to set short timeouts for testing
        _computedMinTimeout := session.Prefs.getInt(PREF_DEFAULT_TIMEOUT);
        if (_computedMinTimeout <= 0) then _computedMinTimeout := DEFAULT_TIMEOUT;

        _timeout := session.Prefs.getInt(BRANDED_MIN_TIMEOUT);
        if (_timeout >  _computedMinTimeout) then
            _computedMinTimeout := _timeout;
    end;
    _timeout := _computedMinTimeout;

    if (seconds > _timeout) then
        _timeout := seconds;

    // manip the xml tag
    Self.Name := 'iq';
    qTag := Self.AddTag('query');
end;


{---------------------------------------}
constructor TJabberIQ.Create(session: TJabberSession; id: Widestring;
    cb: TPacketEvent; seconds: longint);
begin
    Self.create(Session, id, seconds);
    _callback := cb;
end;

{---------------------------------------}
constructor TJabberIQ.Create(session: TJabberSession; id: Widestring;
    payload: TXMLTag; cb: TPacketEvent; seconds: longint);
begin
    Self.create(Session, id, cb, seconds);
    //remove default query tag and add payload
    RemoveTag(qTag);

    qTag := Self.AddTag(TXMLTag.Create(payload));
end;
{---------------------------------------}
destructor TJabberIQ.Destroy;
begin
    _timer.Free;
    if (_cbIndex >= 0) then
        _js.UnRegisterCallback(_cbIndex);
    if (_cbSession >= 0) then
        _js.UnRegisterCallback(_cbSession);
    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberIQ.Send;
begin
    // if we're not connected, just bail
    if ((_js.Stream = nil) or (_js.Active = false)) then begin
        _callback('/session/disconnected', nil);
        Self.Free();
        exit;
    end;

    if _id <> '' then
        Self.setAttribute('id', _id);
    if iqType <> '' then
        Self.setAttribute('type', iqType);
    if toJID <> '' then
        Self.setAttribute('to', toJID);
    qTag.setAttribute('xmlns', Namespace);

    if (_js.xmlLang <> '') then
        self.setAttribute('xml:lang', _js.xmlLang);

    _cbSession := _js.RegisterCallback(disCallback, '/session/disconnected');
    _cbIndex := _js.RegisterCallback(iqCallback, '/packet/iq[@id="' + _id + '"]');
    _js.Stream.Send(Self.xml);

    _timer.Enabled := true;
end;

{---------------------------------------}
procedure TJabberIQ.Timeout(Sender: TObject);
begin
    // we got a timeout event
    _timer.Enabled := false;
    inc(_ticks);

    if (_ticks >= _timeout) then begin
        _js.UnRegisterCallback(_cbIndex);
        _cbIndex := -1;
        _js.UnRegisterCallback(_cbSession);
        _cbSession := -1;
        try
            if (Assigned(_callback)) then _callback('timeout', nil);
        except
        end;
        Self.Free;
    end
    else
        _timer.Enabled := true;
end;

{---------------------------------------}
procedure TJabberIQ.iqCallback(event: string; xml: TXMLTag);
begin
    // callback from _js
    // this is our singleton
    _timer.Enabled := false;
    _js.UnRegisterCallback(_cbIndex);
    _js.UnRegisterCallback(_cbSession);
    _cbIndex := -1;
    _cbSession := -1;
    xml.setAttribute('iq_elapsed_time', IntToStr(_ticks));
    try
        if (Assigned(_callback)) then _callback('xml', xml);
    except
    end;
    Self.Free;
end;

procedure TJabberIQ.disCallback(event: string; xml: TXMLTag);
begin
    // we got disconnected
    _timer.Enabled := false;
    _js.UnRegisterCallback(_cbIndex);
    _js.UnRegisterCallback(_cbSession);
    _cbIndex := -1;
    _cbSession := -1;
    try
        if (Assigned(_callback)) then _callback(event, nil);
    except
    end;
    Self.Free();
end;


initialization
    _computedMinTimeout := -1;

end.
