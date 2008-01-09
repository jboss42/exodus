unit FileServer;
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

{$ifdef VER150}
    {$define INDY9}
{$endif}

interface

uses
    {$ifdef INDY9}
    IdCustomHTTPServer,
    {$endif}
    IdTCPServer, IdHTTPServer, XMLTag, 
    SysUtils, Classes;


type
    TExodusFileServer = class
    private
        _pathlist: TStringlist;
        _filelist: TStringlist;
        _server: TIdHTTPServer;
        _current: integer;
        _cb: integer;
    protected
        {$ifdef INDY9}
        procedure httpServerCommandGet9(AThread: TIdPeerThread;
          ARequestInfo: TIdHTTPRequestInfo;
          AResponseInfo: TIdHTTPResponseInfo);
        {$else}
        procedure httpServerCommandGet8(AThread: TIdPeerThread;
          RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
        {$endif}
        procedure httpServerDisconnect(AThread: TIdPeerThread);

    published
        procedure SessionCallback(event: string; tag: TXMLTag);

    public
        constructor Create();
        destructor Destroy(); override;
        procedure AddFile(filename: string);
    end;

resourcestring
    sXferNewPort = 'Your new file transfer port will not take affect until all current trasfers are stopped. Stop existing transfers?';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Controls, Dialogs, Session;

{---------------------------------------}
constructor TExodusFileServer.Create();
begin
    //
    _filelist := TStringlist.Create();
    _pathlist := TStringlist.Create();

    // setup http server
    _server := TIdHttpServer.Create(nil);
    _server.Active := false;
    _server.AutoStartSession := true;
    _server.OnDisconnect := httpServerDisconnect;
    _server.DefaultPort := MainSession.Prefs.getInt('xfer_port');
    {$ifdef INDY9}
    _server.onCommandGet := httpServerCommandGet9;
    {$else}
    _server.onCommandGet := httpServerCommandGet8;
    {$endif}
    _current := 0;

    _cb := MainSession.RegisterCallback(SessionCallback, '/session');
end;

{---------------------------------------}
destructor TExodusFileServer.Destroy();
begin
    //
    if (MainSession <> nil) then
        MainSession.UnRegisterCallback(_cb);
    _server.Free();
    _filelist.Free();
end;

{---------------------------------------}
procedure TExodusFileServer.AddFile(filename: string);
begin
    //
    _pathlist.Add(filename);
    _filelist.Add(ExtractFilename(filename));

    if (not _server.Active) then
        _server.Active := true;
end;

{---------------------------------------}
{$ifdef INDY9}
procedure TExodusFileServer.httpServerCommandGet9(AThread: TIdPeerThread;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
    f: string;
    idx: integer;
begin
    // send the file.
    f := ARequestInfo.Document;
    if (f[1] = '/') then Delete(f, 1, 1);
    idx := _filelist.IndexOf(f);

    if (idx < 0) then with AResponseInfo do begin
        ResponseNo := 404;
        CloseConnection := true;
    end
    else begin
        f := _pathlist[idx];
        _pathlist.Delete(idx);
        _filelist.Delete(idx);
        inc(_current);
        _server.ServeFile(AThread, AResponseInfo, f);
    end;
end;
{$else}
procedure TExodusFileServer.httpServerCommandGet8(AThread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
var
    f: string;
    idx: integer;
begin
    // send the file.
    f := RequestInfo.Document;
    idx := _filelist.IndexOf(f);

    if (idx < 0) then with ResponseInfo do begin
        ResponseNo := 404;
        CloseConnection := true;
    end
    else begin
        f := _pathlist[idx];
        _pathlist.Delete(idx);
        _filelist.Delete(idx);
        inc(_current);
        _server.ServeFile(AThread, AResponseInfo, f);
    end;
end;
{$endif}

{---------------------------------------}
procedure TExodusFileServer.httpServerDisconnect(AThread: TIdPeerThread);
begin
    // one of the threads has finished..
    dec(_current);
    if (_current < 0) then _current := 0;
    if ((_pathlist.Count = 0) and (_current = 0)) then
        _server.Active := false;
end;

{---------------------------------------}
procedure TExodusFileServer.SessionCallback(event: string; tag: TXMLTag);
var
    p: integer;
begin
    // check for new xfer prefs
    if (event = '/session/prefs') then begin
        p := MainSession.Prefs.getInt('xfer_port');
        if (p <> _server.DefaultPort) then begin

            // check to see if we should disconnect current xfers
            if ((_server.Active) or (_current > 0)) then
                if (MessageDlg(sXferNewPort, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
                    _server.Active := false;
                    _current := 0;
                end;

            // change it.
            _server.DefaultPort := p;

        end;
    end;
end;


end.
 