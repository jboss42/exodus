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
    procedure IQCallback(event: string; tag: TXMLTag);
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
var
    iq: TJabberIQ;
begin
    // we are getting a message tag telling us we have an update available
    // do the iq to get more info.
    if (tag <> nil) then begin
        iq := TJabberIQ.Create(MainSession, MainSession.generateID(), Self.IQCallback);
        iq.toJID := tag.QueryXPData('/message/x');
        iq.iqType := 'get';
        iq.Namespace := XMLNS_AUTOUPDATE;
        iq.Send();
        end;
end;

{---------------------------------------}
procedure TAutoUpdate.IQCallback(event: string; tag: TXMLTag);
begin
    // parse this mess.. NB: We don't care if we have <beta> or <release>
    {
        <iq type="result" from="winjab@update.denmark" id="1001">
          <query xmlns="jabber:iq:autoupdate">
            <release priority="optional">
              <ver>0.9.1.1</ver>
              <desc/>
              <url>http://update.denmark/winjab/winjab_setup.exe</url>
            </release>
            <beta priority="optional">
              <ver>0.9.2.16</ver>
              <desc/>
              <url>http://update.denmark/winjab/winjab_beta.exe</url>
            </beta>
          </query>
        </iq>
    }
    if (event = 'xml') then begin
        ShowAutoUpdateStatus(tag);
        end;
end;



{---------------------------------------}
initialization
    au := TAutoUpdate.Create();
    au.initialized := false;

finalization
    au.Free();

end.
