unit Signals;
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
    Classes, SysUtils;

type

    {---------------------------------------}
    TSignalDispatcher = class(TStringList)
    private
        _id: longint;
    public
        procedure DeleteListener(id: longint);
        procedure DispatchSignal(event: string; tag: TXMLTag);
        function getNextID: longint;
        function TotalCount: longint;
    end;

    {---------------------------------------}
    TSignalEvent = procedure (event: string; tag: TXMLTag) of object;
    TSignalListener = class
    public
        cb_id: longint;
        callback: TMethod;
    end;

    TSignal = class(TStringList)
    private
        _pattern: string;
    public
        constructor Create(event_pattern: string);
        destructor Destroy; override;

        function addListener(callback: TSignalEvent): TSignalListener; overload;
        procedure Invoke(event: string; tag: TXMLTag); overload; virtual;
    end;


    {---------------------------------------}
    TPacketEvent = procedure(event: string; tag: TXMLTag) of object;

    TPacketListener = class(TSignalListener)
    private
        xp: TXPLite;
    public
        constructor Create;
        destructor Destroy; override;
        procedure ParseXPLite(xplite: string);
        property XPLite: TXPLite read xp;
    end;

    TPacketSignal = class(TSignal)
    public
        function addListener(callback: TPacketEvent; xplite: string): TPacketListener; overload;
        procedure Invoke(event: string; tag: TXMLTag); override;
    end;



implementation
uses
    XMLUtils;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
procedure TSignalDispatcher.DispatchSignal(event: string; tag: TXMLTag);
var
    levt: string;
    i: integer;
    sig: TSignal;
begin     
    // find the correct signal to dispatch this event on
    levt := Lowercase(Trim(event));
    for i := Self.Count - 1 downto 0 do begin
        if (Pos(Lowercase(Strings[i]), levt) = 1) then begin
            sig := TSignal(Objects[i]);
            if (sig <> nil) then
                sig.Invoke(event, tag);
            end;
        end;
end;

{---------------------------------------}
function TSignalDispatcher.getNextID: longint;
begin
    inc(_id);
    Result := _id;
end;

{---------------------------------------}
procedure TSignalDispatcher.DeleteListener(id: longint);
var
    i,j: integer;
    sig: TSignal;
    l: TSignalListener;
begin
    for i := 0 to Self.Count - 1 do begin
        sig := TSignal(Objects[i]);
        for j := 0 to sig.Count - 1 do begin
            l := TSignalListener(sig.Objects[j]);
            if l.cb_id = id then begin
                l.Free;
                sig.Delete(j);
                exit;
                end;
            end;
        end;
end;

{---------------------------------------}
function TSignalDispatcher.TotalCount: longint;
var
    i: integer;
    sig: TSignal;
begin
    Result := 0;
    for i := 0 to Self.Count - 1 do begin
        sig := TSignal(Objects[i]);
        Result := Result + sig.Count;
        end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
constructor TSignal.Create(event_pattern: string);
begin
    inherited Create;
    _pattern := event_pattern;
end;

{---------------------------------------}
destructor TSignal.Destroy;
begin
    _pattern := '';

    inherited Destroy;
end;

{---------------------------------------}
function TSignal.addListener(callback: TSignalEvent): TSignalListener;
var
    l: TSignalListener;
begin
    l := TSignalListener.Create;
    l.callback := TMethod(callback);
    Self.AddObject('', l);
    Result := l;
end;

{---------------------------------------}
procedure TSignal.Invoke(event: string; tag: TXMLTag);
var
    i: integer;
    l: TSignalListener;
    cmp, e: string;
    sig: TSignalEvent;
begin
    // dispatch this to all interested listeners
    cmp := Lowercase(Trim(event));
    for i := Self.Count - 1 downto 0 do begin
        e := Strings[i];
        l := TSignalListener(Objects[i]);
        if (l <> nil) then begin
            sig := TSignalEvent(l.callback);
            if (e <> '') then begin
                // check to see if the listener's string is a substring of the event
                if (Pos(e, cmp) >= 1) then
                    sig(event, tag);
                end
            else
                sig(event, tag);
            end;
        end;
end;


{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
constructor TPacketListener.Create;
begin
    inherited Create;
    xp := TXPLite.Create;
end;

{---------------------------------------}
destructor TPacketListener.Destroy;
begin
    xp.free;
    inherited Destroy;
end;

{---------------------------------------}
procedure TPacketListener.ParseXPLite(xplite: string);
begin
    xp.Parse(xplite);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
function TPacketSignal.addListener(callback: TPacketEvent; xplite: string): TPacketListener;
var
    l: TPacketListener;
    xps: string;
begin
    // create a new PacketListener for this signal
    l := TPacketListener.Create;
    l.callback := TMethod(callback);
    xps := Copy(xplite, 8, length(xplite) - 7);
    l.xp.Parse(xps);
    Self.AddObject(xplite, l);
    Result := l;
end;

{---------------------------------------}
procedure TPacketSignal.Invoke(event: string; tag: TXMLTag);
var
    i: integer;
    pe: TPacketEvent;
    pl: TPacketListener;
    xp: TXPLite;
begin
    {
    check this packet against this xplite
    use basic syntax like:
    /iq/query@xmlns='jabber:iq:roster'
    }
    for i := Self.Count - 1 downto 0 do begin
        pl := TPacketListener(Self.Objects[i]);
        xp := pl.XPLite;
        if xp.Compare(tag) then begin
            pe := TPacketEvent(pl.Callback);
            pe('xml', tag);
            end;
        end;
end;



end.
