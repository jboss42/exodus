unit DNSUtils;

interface

uses
  SysUtils, Classes,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient,
  IdDNSResolver;


function GetSRVRecord(Resolver: TIdDNSResolver; srv_req, a_req: string;
    var ip: string; var port: Word): boolean;


implementation

uses
    IdException;

function GetSRVRecord(Resolver: TIdDNSResolver; srv_req, a_req: string;
    var ip: string; var port: Word): boolean;
var
    i: integer;
    lo_pri, cur_w, cur: integer;
    srv: TSRVRecord;
    ar: TARecord;
begin
    // Make a SRV request first..
    // if that fails, fall back on A Records
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

        assert(cur >= 0);
        assert(cur < Resolver.QueryResult.Count);
        srv := TSRVRecord(Resolver.QueryResult[cur]);
        ip := srv.IP;
        port := srv.Port;

        a_req := srv.IP;

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
