unit AutoUpdate;
{
    Copyright 2002, Peter Millard

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
  Classes,
  XMLTag;

type
  TAutoUpdateThread = class(TThread)
  private
    { Private declarations }
    _url : string;
    _last : TDateTime;
    procedure checkDoUpdate();
  protected
    procedure Execute; override;
  public
    property URL : string read _url write _url;
    property Last : TDateTime read _last write _last;
  end;

  TAutoUpdate = class
  private
    procedure MsgCallback(event: string; tag: TXMLTag);
  public
    initialized: boolean;
  end;

procedure InitAutoUpdate();


implementation

uses
    AutoUpdateStatus,
    Controls,
    ExUtils,
    IdHttp,
    IQ,
    Dialogs,
    Forms,
    Registry,
    Session,
    ShellAPI,
    SysUtils,
    Windows,
    XMLUtils;

var
    au: TAutoUpdate;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure InitAutoUpdate();
var
    reg : TRegistry;
    j, url : string;
    last : TDateTime;
    t : TAutoUpdateThread;
    x : TXMLTag;
begin
    if (not MainSession.Prefs.getBool('auto_updates')) then exit;

    if (not au.initialized) then begin
        MainSession.RegisterCallback(au.MsgCallback,
            '/packet/message/x[@xmlns="jabber:x:autoupdate"]');
        end;

    // If we have the magic reg key, check at a specific URL
    reg := TRegistry.Create();
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey(EXODUS_REG, true);
    url := reg.ReadString('Update_URL');

    // if this is the first time we've gotten here, then let's keep track of
    // the current time, and get all *future* updates.
    try
        last := reg.ReadDateTime('Last_Update');
    except
        on ERegistryException do begin
            last := Now();
            reg.WriteDateTime('Last_Update', last);
            end;
        end;
        
    reg.CloseKey();
    reg.Free();

    if (url <> '') then begin
        t := TAutoUpdateThread.Create(true);
        t.URL := url;
        t.Last := last;
        t.FreeOnTerminate := true;
        t.Resume();
        end
    else begin
        j := JID_AUTOUPDATE + '/' + Trim(GetAppVersion());
        x := TXMLTag.Create('presence');
        x.PutAttribute('to', j);
        MainSession.SendTag(x);
        end;

end;

{---------------------------------------}
{---------------------------------------}
{ TAutoUpdateThread }
{---------------------------------------}
{---------------------------------------}
procedure TAutoUpdateThread.Execute;
var
    http : TIdHTTP;
begin
    http := nil;
    try
        http := TIdHTTP.Create(nil);
        http.Head(_url);
        if (http.ResponseCode <> 200) then begin
            //if (Sender <> nil) then ShowMessage(Format(sUpdateHTTPError, [http.ResponseText]));
            exit;
            end;

        if (http.Response.LastModified <= _last) then
            exit;

        synchronize(checkDoUpdate);
    finally
        if (http <> nil) then http.Free();
        end;
end;

{---------------------------------------}
procedure TAutoUpdateThread.checkDoUpdate();
begin
    ShowAutoUpdateStatus(_url);
end;

{---------------------------------------}
procedure TAutoUpdate.MsgCallback(event: string; tag: TXMLTag);
begin
    // we are getting a message tag telling us we have an update available
    ShowAutoUpdateStatus(tag);
end;


{---------------------------------------}
initialization
    au := TAutoUpdate.Create();
    au.initialized := false;

finalization
    au.Free();

end.
