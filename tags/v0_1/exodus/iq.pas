unit iq;
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
    ExtCtrls, Classes, SysUtils, Windows, StdVcl;

type
    TJabberIQ = class(TXMLTag)
    private
        _id: string;
        _js: TJabberSession;
        _Callback: TPacketEvent;
        _cbIndex: integer;
        _timer: TTimer;

        procedure Timeout(Sender: TObject);
        procedure iqCallback(event: string; xml: TXMLTag);
    public
        Namespace: string;
        iqType: string;
        toJid: string;
        qTag: TXMLTag;

        constructor Create(session: TJabberSession;
            id: string;
            cb: TPacketEvent;
            time: longint = 15000
            ); reintroduce; overload;
        destructor Destroy; override;

        procedure Send;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{---------------------------------------}
constructor TJabberIQ.Create(session: TJabberSession; id: string; cb: TPacketEvent; time: longint);
begin
    inherited Create;

    _js := session;
    _id := id;
    _callback := cb;
    _cbIndex := -1;
    _timer := TTimer.Create(nil);
    _timer.Interval := time;
    _timer.Enabled := false;
    _timer.OnTimer := Timeout;

    // manip the xml tag
    Self.Name := 'iq';
    qTag := Self.AddTag('query');
end;

{---------------------------------------}
destructor TJabberIQ.Destroy;
begin
    _timer.Free;
    _js.UnRegisterCallback(_cbIndex);
    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberIQ.Timeout(Sender: TObject);
begin
    // we got a timeout event
    _callback('timeout', nil);
    _js.UnRegisterCallback(_cbIndex);
    _cbIndex := -1;
    Self.Free;
end;

{---------------------------------------}
procedure TJabberIQ.Send;
begin
    if _id <> '' then
        Self.PutAttribute('id', _id);
    if iqType <> '' then
        Self.PutAttribute('type', iqType);
    if toJID <> '' then
        Self.PutAttribute('to', toJID);
    qTag.PutAttribute('xmlns', Namespace);

    _cbIndex := _js.RegisterCallback(iqCallback, '/packet/iq[@id="' + _id + '"]');
    _js.Stream.Send(Self.xml);

    _timer.Enabled := true;
end;

{---------------------------------------}
procedure TJabberIQ.iqCallback(event: string; xml: TXMLTag);
begin
    // callback from _js
    // this is our singleton
    _timer.Enabled := false;
    _js.UnRegisterCallback(_cbIndex);
    _callback('xml', xml);
    _cbIndex := -1;
    Self.Free;
end;


end.

