unit DNSUtils;
{
    Copyright 2003, Peter Millard

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
  SysUtils, Classes, Windows, Session,  
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient,
  IdDNSResolver;

type

    TDNSResolverThread = class(TThread)
    protected
        _resolver: TIdDNSResolver;
        _srv: string;
        _a: string;
        _session: TJabberSession;
    public
        procedure Execute(); override;
    end;

procedure GetSRVAsync(Session: TJabberSession; Resolver: TIdDNSResolver;
    srv_req, a_req: string);
function GetSRVRecord(Resolver: TIdDNSResolver; srv_req, a_req: string;
    var ip: string; var port: Word): boolean;
function GetNameServers(): string;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    XMLTag, Registry, IdException;

{---------------------------------------}
procedure GetSRVAsync(Session: TJabberSession; Resolver: TIdDNSResolver;
    srv_req, a_req: string);
var
    thd: TDNSResolverThread;
begin
    thd := TDNSResolverThread.Create(true);
    thd._session := Session;
    thd._a := a_req;
    thd._srv := srv_req;
    thd._resolver := Resolver;
    thd.FreeOnTerminate := true;
    thd.Execute();
end;

{---------------------------------------}
procedure TDNSResolverThread.Execute();
var
    ip: string;
    p: Word;
    t: TXMLTag;
begin
    t := TXMLTag.Create('dns');
    if (GetSRVRecord(_resolver, _srv, _a, ip, p)) then begin
        // it worked..
        if (p > 0) then
            t.setAttribute('type', 'srv')
        else
            t.setAttribute('type', 'a');
        t.setAttribute('ip', ip);
        t.setAttribute('port', IntToStr(p));
    end
    else begin
        // failed.
        t.setAttribute('type', 'failed');
    end;
    _session.FireEvent('/session/dns', t);
end;

{---------------------------------------}
function GetNameServers(): string;
var
    r: TRegistry;
    OSVersionInfo32: OSVERSIONINFO;
    key: string;
    vals: string;
begin

    // Look in different places depending on OS.
    r := TRegistry.Create();
    r.RootKey := HKEY_LOCAL_MACHINE;

    OSVersionInfo32.dwOSVersionInfoSize := SizeOf(OSVersionInfo32);
    GetVersionEx(OSVersionInfo32);
    case OSVersionInfo32.dwPlatformId of
    VER_PLATFORM_WIN32_WINDOWS: begin
        with OSVersionInfo32 do begin
            { If minor version is zero, we are running on Win 95.
              Otherwise we are running on Win 98 }
            if (dwMinorVersion = 0) then begin
                { Windows 95 }
                Result := '';
                exit;
            end
            else if (dwMinorVersion < 90) then begin
                { Windows 98 }
                key := '\SYSTEM\CurrentControlSet\Services\VxD\MSTCP';
            end
            else if (dwMinorVersion >= 90) then begin
                { Windows ME }
                key := '\SYSTEM\CurrentControlSet\Services\VxD\MSTCP';
            end;
        end;
    end;
    VER_PLATFORM_WIN32_NT: begin
        with OSVersionInfo32 do begin
            if (dwMajorVersion <= 4) then begin
                { Windows NT 3.5/4.0 }
                key := '\System\CurrentControlSet\Services\Tcpip\Parameters';
            end
            else if (dwMinorVersion > 0) then begin
                { Windows XP }
                key := '\System\CurrentControlSet\Services\Tcpip\Parameters';
            end
            else begin
                { Windows 2000 }
                key := '\System\CurrentControlSet\Services\Tcpip\Parameters';
            end;
        end;
    end;
    end;

    r.OpenKeyReadOnly(key);
    vals := r.ReadString('Nameserver');
    if (vals = '') then
        vals := r.ReadString('DhcpNameServer');

    Result := vals;
    r.Free();

end;

{---------------------------------------}
function GetSRVRecord(Resolver: TIdDNSResolver; srv_req, a_req: string;
    var ip: string; var port: Word): boolean;
var
    i: integer;
    lo_pri, cur_w, cur: integer;
    srv: TSRVRecord;
    ar: TARecord;
    dns: string;
    slist: TStringlist;
begin
    // Make a SRV request first..
    // if that fails, fall back on A Records
    dns := GetNameServers();
    if (dns = '') then begin
        ip := a_req;
        port := 0;
        Result := false;
        exit;
    end;

    slist := TStringlist.Create();
    slist.Delimiter := ' ';
    slist.DelimitedText := dns;

    if (slist.Count = 0) then begin
        ip := a_req;
        port := 0;
        Result := false;
        exit;
    end;

    Resolver.Host := slist[0];
    Resolver.AllowRecursiveQueries := true;
    try
        Resolver.QueryRecords := [qtSRV];
        Resolver.Resolve(srv_req);

        // Worked... Pick the correct SRV Record.. Lowest priority, highest weight.
        lo_pri := 65535;
        cur := -1;
        cur_w := 0;
        for i := 0 to Resolver.QueryResult.Count - 1 do begin
            if (Resolver.QueryResult[i] is TSRVRecord) then begin
                srv := TSRVRecord(Resolver.QueryResult[i]);
                if (srv.Priority < lo_pri) then begin
                    cur := i;
                    lo_pri := srv.Priority;
                    cur_w := srv.Weight;
                end
                else if ((srv.Priority = lo_pri) and (srv.Weight > cur_w)) then begin
                    cur := i;
                    cur_w := srv.Weight;
                end;
            end;
        end;

        if (cur = -1) then begin
            // it worked, but we got 0 results back
            raise EIdDNSResolverError.Create('No SRV records');
        end
        else begin
            assert(cur < Resolver.QueryResult.Count);
            srv := TSRVRecord(Resolver.QueryResult[cur]);
            ip := srv.IP;
            port := srv.Port;
            a_req := srv.IP;
        end;
    except
        on E: EIdDNSResolverError do begin
            ip := '';
            port := 0;
            try
                Resolver.QueryRecords := [qtA];
                Resolver.Resolve(a_req);
            except
                Result := false;
                exit;
            end;
        end;
    end;

    // Check to see if we have an A Record matching this name
    for i := 0 to Resolver.QueryResult.Count - 1 do begin
        if (Resolver.QueryResult[i] is TARecord) then begin
            ar := TARecord(Resolver.QueryResult[i]);
            if (ar.Name = a_req) then begin
                ip := ar.IPAddress;
                break;
            end;
        end;
    end;

    Result := true;

end;

end.
