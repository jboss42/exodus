unit PrefController;
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
    Unicode, XMLTag, XMLParser, Presence,
    {$ifdef Win32}
    Forms, Windows, Registry,
    {$else}
    // iniFiles,
    Math, QForms,
    {$endif}
    Classes, SysUtils;

const
    s10n_ask = 0;
    s10n_auto_roster = 1;
    s10n_auto_all = 2;

    conn_normal = 0;
    conn_http = 1;

    http_proxy_none = 1;
    http_proxy_ie = 0;
    http_proxy_custom = 2;

    roster_chat = 0;
    roster_msg = 1;

    // bits for notify events
    notify_toast = 1;
    notify_event = 2;
    notify_flash = 4;
    notify_sound = 8;
    notify_tray  = 16;

    // normal msg options
    msg_normal = 0;
    msg_all_chat = 1;
    msg_existing_chat = 2;

    // invite options
    invite_normal = 0;
    invite_popup = 1;
    invite_accept = 2;

    P_EXPANDED = 'expanded';
    P_SHOWONLINE = 'roster_only_online';
    P_SHOWUNSUB = 'roster_show_unsub';
    P_OFFLINEGROUP = 'roster_offline_group';
    P_TIMESTAMP = 'timestamp';
    P_AUTOUPDATE = 'auto_updates';
    P_CHAT = 'roster_chat';
    P_SUB_AUTO = 's10n_auto_accept';
    P_LOG = 'log';

    P_FONT_NAME = 'font_name';
    P_FONT_SIZE = 'font_size';
    P_FONT_COLOR = 'font_color';
    P_FONT_BOLD = 'font_bold';
    P_FONT_ITALIC = 'font_italic';
    P_FONT_ULINE = 'font_underline';

    P_COLOR_BG = 'color_bg';
    P_COLOR_ME = 'color_me';
    P_COLOR_OTHER = 'color_other';

    P_EVENT_WIDTH = 'event_width';

type
    TJabberProfile = class
    private
        _password: Widestring;

        function getPassword: Widestring;
        procedure setPassword(value: Widestring);
    public
        Name: Widestring;
        Username: Widestring;
        Server: Widestring;
        Resource: Widestring;
        Priority: integer;
        SavePasswd: boolean;

        ConnectionType: integer;

        // Socket connection
        Host: Widestring;
        Port: integer;
        ssl: boolean;
        SocksType: integer;
        SocksHost: Widestring;
        SocksPort: integer;
        SocksAuth: boolean;
        SocksUsername: string;
        SocksPassword: string;

        // HTTP Connection
        URL: Widestring;
        Poll: integer;
        ProxyApproach: integer;
        ProxyHost: Widestring;
        ProxyPort: integer;
        ProxyAuth: boolean;
        ProxyUsername: Widestring;
        ProxyPassword: Widestring;

        constructor Create();

        procedure Load(tag: TXMLTag);
        procedure Save(node: TXMLTag);
        function IsValid() : boolean;

        property password: Widestring read getPassword write setPassword;
    end;

    TPrefKind = (pkClient, pkServer, pkBrand);

    TPrefController = class
    private
        _js: TObject;
        _pref_filename: Widestring;
        _brand_filename: Widestring;
        _pref_node: TXMLTag;
        _brand_node: TXMLTag;
        _server_node: TXMLTag;
        _profiles: TStringList;
        _parser: TXMLTagParser;
        _server_dirty: boolean;
        _updating: boolean;

        function getDefault(pkey: Widestring): Widestring;
        function findPresenceTag(pkey: Widestring): TXMLTag;
        procedure Save;
        procedure ServerPrefsCallback(event: string; tag: TXMLTag);
    public
        constructor Create(filename: Widestring; BrandingFile: widestring);
        Destructor Destroy; override;

        function getString(pkey: Widestring; server_side: TPrefKind = pkClient): Widestring;
        function getInt(pkey: Widestring; server_side: TPrefKind = pkClient): integer;
        function getBool(pkey: Widestring; server_side: TPrefKind = pkClient): boolean;
        procedure fillStringlist(pkey: Widestring; sl: TWideStrings; server_side: TPrefKind = pkClient);

        function getAllPresence(): TList;
        function getPresence(pkey: Widestring): TJabberCustomPres;
        function getPresIndex(idx: integer): TJabberCustomPres;

        procedure setString(pkey, pvalue: Widestring; server_side: TPrefKind = pkClient);
        procedure setInt(pkey: Widestring; pvalue: integer; server_side: TPrefKind = pkClient);
        procedure setBool(pkey: Widestring; pvalue: boolean; server_side: TPrefKind = pkClient);
        procedure setStringlist(pkey: Widestring; pvalue: TWideStrings; server_side: TPrefKind = pkClient);
        procedure setPresence(pvalue: TJabberCustomPres);
        procedure removePresence(pvalue: TJabberCustomPres);
        procedure removeAllPresence();

        procedure SavePosition(form: TForm);
        procedure RestorePosition(form: TForm);

        procedure LoadProfiles;
        procedure SaveProfiles;

        procedure SetSession(js: TObject);
        procedure FetchServerPrefs();
        procedure SaveServerPrefs();

        function CreateProfile(name: Widestring): TJabberProfile;
        procedure RemoveProfile(p: TJabberProfile);
        procedure BeginUpdate();
        procedure EndUpdate();

        property Profiles: TStringlist read _profiles write _profiles;
    end;

resourceString
    sIdleAway = 'Away as a result of idle.';
    sIdleXA = 'XA as a result of idle.';


{$ifdef Win32}
function getUserDir: string;
function ReplaceEnvPaths(value: string): string;
{$endif}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef Win32}
    ComCtrls, Graphics, ShellAPI,
    {$else}
    QGraphics,
    {$endif}
    JabberConst, StrUtils, 
    IdGlobal, IdCoder3To4, Session, IQ, XMLUtils;


var
    dflt_top: integer;
    dflt_left: integer;

{$ifdef Win32}
{---------------------------------------}
function getUserDir: string;
var
    reg: TRegistry;
    f: TFileStream;
begin
    try //except
    reg := TRegistry.Create;
    try //finally free
        with reg do begin
            RootKey := HKEY_CURRENT_USER;
            OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders');
            if ValueExists('AppData') then begin
                Result := ReadString('AppData') + '\Exodus\';
                Result := ReplaceEnvPaths(Result);
                end
            else
                Result := ExtractFilePath(Application.EXEName);

            // Try to create a file here if the prefs don't already exist
            if not (FileExists(Result + 'exodus.xml')) then begin
                try
                    f := TFileStream.Create(Result + 'test.xml', fmOpenWrite);
                    f.Free();
                    DeleteFile(Result + 'test.xml');
                except
                    on EFOpenError do begin
                        // If we can't write to AppData, then use Local AppData
                        if ValueExists('Local AppData') then begin
                            Result := ReadString('Local AppData') + '\Exodus\';
                            Result := ReplaceEnvPaths(Result);
                            end;
                        end; // EFOpenError
                    end; // except
                end; // if not fileExists
            end; // with reg
    finally
        reg.Free;
    end;
    except
        // As a last result, just try the appdir
        Result := ExtractFilePath(Application.EXEName);
    end;

    // Finally, if the directory doesn't exist.. create it.
    if (not DirectoryExists(Result)) then
        MkDir(Result);
end;

{---------------------------------------}
function ReplaceEnvPaths(value: string): string;
var
    tmps: String;
    tp: PChar;
begin
    // Replace all of the env. paths.. must use a fixed size buff
    getMem(tP,1024);
    ExpandEnvironmentStrings(PChar(value), tp, 1023);
    tmps := String(tp);
    FreeMem(tP);
    Result := tmps;
end;

{---------------------------------------}
procedure getDefaultPos;
var
    taskbar: HWND;
    _taskrect: TRect;
    _taskdir: word;
    mh, mw: longint;
begin
    //
    taskbar := FindWindow('Shell_TrayWnd', '');
    GetWindowRect(taskbar, _taskrect);

    mh := Screen.Height div 2;
    mw := Screen.Width div 2;
    if ((_taskrect.Left < mw) and (_taskrect.Top < mh) and (_taskrect.Right < mw)) then
        _taskdir := 0
    else if ((_taskrect.left > mw) and (_taskrect.Top < mh)) then
        _taskdir := 1
    else if (_taskrect.top < mh) then
        _taskdir := 2
    else
        _taskdir := 3;

    case _taskdir of
    0: begin
        // left
        dflt_top := 0;
        dflt_left := _taskrect.Left + 10;
        end;
    1: begin
        // right
        dflt_top := 0;
        dflt_left := 0;
        end;
    2: begin
        // top
        dflt_top := _taskrect.Bottom + 10;
        dflt_left := 0;
        end;
    3: begin
        // bottom
        dflt_top := 0;
        dflt_left := 0;
        end;
    end;
end;

{$else}

procedure getDefaultPos;
begin
    dflt_top := 10;
    dflt_left := 10;
end;

{$endif}

{---------------------------------------}
constructor TPrefController.Create(filename: Widestring; BrandingFile: Widestring);
begin
    inherited Create();

    _pref_filename := filename;
    _brand_filename := BrandingFile;
    _parser := TXMLTagParser.Create;
    _parser.ParseFile(_pref_filename);
    if (_parser.Count > 0) then begin
        // we have something to read.. hopefully it's correct :)
        _pref_node := _parser.popTag();
        _parser.Clear();
        end
    else
        // create some default node
        _pref_node := TXMLTag.Create('exodus');

    _parser.ParseFile(_brand_filename);
    if (_parser.Count > 0) then begin
        // we have something to read.. hopefully it's correct :)
        _brand_node := _parser.popTag();
        _parser.Clear();
        end
    else
        // create some default node
        _brand_node := TXMLTag.Create('brand');

    _server_node := nil;
    _server_dirty := false;
    _profiles := TStringList.Create;
    _updating := false;

    getDefaultPos();
end;

{---------------------------------------}
destructor TPrefController.Destroy;
begin
    // Kill our cache'd nodes, etc.
    if (_pref_node <> nil) then
        _pref_node.Free();
    if (_brand_node <> nil) then
        _brand_node.Free();
    if (_server_node <> nil) then
        _server_node.Free();
    _parser.Free();
    ClearStringListObjects(_profiles);

    _profiles.Free();

    inherited Destroy;

end;

{---------------------------------------}
procedure TPrefController.Save;
var
    fs: TStringList;
begin
    if (_updating) then exit;

    fs := TStringList.Create;
    fs.Text := UTF8Encode(_pref_node.xml);
    fs.SaveToFile(_pref_filename);
    fs.Free();
end;

{---------------------------------------}
function TPrefController.getDefault(pkey: Widestring): Widestring;
begin
    result := getString(pkey, pkBrand);
    if (result <> '') then
        exit;

    // set the defaults for the pref controller
    if pkey = 'brand_caption' then
        result := 'Exodus'
    else if pkey = P_EXPANDED then
        result := '0'
    else if pkey = P_SHOWONLINE then
        result := '0'
    else if pkey = P_SHOWUNSUB then
        result := '0'
    else if pkey = P_OFFLINEGROUP then
        result := '0'
    else if pkey = P_TIMESTAMP then
        result := '1'
    else if pkey = P_AUTOUPDATE then
        result := '1'
    else if pkey = P_CHAT then
        result := '1'
    else if pkey = P_SUB_AUTO then
        result := '0'
    else if pkey = P_FONT_NAME then
        result := 'Arial'
    else if pkey = P_FONT_SIZE then
        result := '10'
    else if pkey = P_FONT_COLOR then
        result := IntToStr(Integer(clBlack))
    else if pkey = P_FONT_BOLD then
        result := '0'
    else if pkey = P_FONT_ITALIC then
        result := '0'
    else if pkey = P_FONT_ULINE then
        result := '0'
    else if pkey = P_COLOR_BG then
        result := IntToStr(Integer(clWhite))
    else if pkey = P_COLOR_ME then
        result := IntToStr(Integer(clBlue))
    else if pkey = P_COLOR_OTHER then
        result := IntToStr(Integer(clRed))
    else if pkey = P_EVENT_WIDTH then
        result := '315'
    else if pkey = 'edge_snap' then
        result := '15'
    else if pkey = 'snap_on' then
        result := '1'
    else if pkey = 'fade_limit' then
        result := '100'
    else if pkey = 'toolbar' then
        result := '1'
    else if pkey = 'autologin' then
        result := '0'
    else if pkey = 'profile_active' then
        result := '0'
    else if pkey = 'auto_away' then
        result := '1'
    else if pkey = 'away_time' then
        result := '5'
    else if pkey = 'xa_time' then
        result := '30'
    else if pkey = 'away_status' then
        result := sIdleAway
    else if pkey = 'xa_status' then
        result := sIdleXA
    else if pkey = 'log_path' then
        result := ExtractFilePath(Application.EXEName) + 'logs'
    else if pkey = 'xfer_path' then
        result := ExtractFilePath(Application.EXEName)
    else if pkey = 'spool_path' then
        result := getUserDir() + 'spool.xml'
    else if pkey = 'inline_status' then
        result := '0'
    else if pkey = 'roster_bg' then
        result := IntToStr(Integer(clWindow))

    {$ifdef Win32}
    else if pkey = 'roster_font_name' then
        result := Screen.IconFont.Name
    else if pkey = 'roster_font_size' then
        result := IntToStr(Screen.IconFont.Size)
    else if pkey = 'roster_font_color' then
        result := IntToStr(Integer(Screen.IconFont.Color))
    else if pkey = 'browse_view' then
        result := IntToStr(integer(vsIcon))
    {$else}
    else if pkey = 'roster_font_name' then
        result := Application.Font.Name
    else if pkey = 'roster_font_size' then
        result := IntToStr(Application.Font.Size)
    else if pkey = 'roster_font_color' then
        result := IntToStr(Integer(Application.Font.Color))
    {$endif}

    else if pkey = 'emoticons' then
        result := '1'
    else if pkey = 'timestamp_format' then
        result := 'H:MM AM/PM'
    else if pkey = 'notify_online' then
        result := IntToStr(notify_toast)
    else if pkey = 'notify_normalmsg' then
        result := IntToStr(notify_toast)
    else if pkey = 'notify_newchat' then
        result := IntToStr(notify_toast)
    else if pkey = 'notify_chatactivity' then
        result := IntToStr(notify_flash)
    else if pkey = 'notify_s10n' then
        result := IntToStr(notify_toast)
    else if pkey = 'notify_keyword' then
        result := IntToStr(notify_toast)
    else if pkey = 'notify_invite' then
        result := IntToStr(notify_toast)
    else if pkey = 'notify_roomactivity' then
        result := IntToStr(notify_toast)
    else if pkey = 'notify_oob' then
        result := IntToStr(notify_toast)
    else if pkey = 'presence_message_listen' then
        result := '1'
    else if pkey = 'presence_message_send' then
        result := '1'
    else if pkey = 'notify_sounds' then
        result := '1'
    else if pkey = 'roster_show_pending' then
        result := '1'
    else if pkey = 'auto_update_url' then
        result := 'http://exodus.jabberstudio.org/exodus-released.exe'
    else if pkey = 'roster_messenger' then
        result := '1'
    else
        result := '';
end;

{---------------------------------------}
function TPrefController.getString(pkey: Widestring; server_side: TPrefKind = pkClient): Widestring;
var
    t: TXMLTag;
begin
    t := nil;

    // find string value
    case server_side of
        pkClient: t := _pref_node.GetFirstTag(pkey);
        pkServer: t := _server_node.GetFirstTag(pkey);
        pkBrand:  t := _brand_node.GetFirstTag(pkey);
    end;

    if (t = nil) then begin
        if (server_side = pkBrand) then
            Result := ''
        else
            Result := getDefault(pkey);
        end
    else
        Result := t.Data;
end;

{---------------------------------------}
function TPrefController.getInt(pkey: Widestring; server_side: TPrefKind = pkClient): integer;
begin
    // find int value
    Result := SafeInt(getString(pkey, server_side));
end;

{---------------------------------------}
function TPrefController.getBool(pkey: Widestring; server_side: TPrefKind = pkClient): boolean;
begin
    Result := SafeBool(getString(pkey, server_side));
end;

{---------------------------------------}
procedure TPrefController.fillStringlist(pkey: Widestring; sl: TWideStrings; server_side: TPrefKind = pkClient);
var
    p: TXMLTag;
    s: TXMLTagList;
    i: integer;
begin
    sl.Clear();

    p := nil;

    case server_side of
        pkClient: p := _pref_node.GetFirstTag(pkey);
        pkServer: p := _server_node.GetFirstTag(pkey);
        pkBrand:  p := _brand_node.GetFirstTag(pkey);
    end;

    if (p <> nil) then begin
        s := p.QueryTags('s');
        for i := 0 to s.Count - 1 do
            sl.Add(s.Tags[i].Data);
        s.Free;
        end;
end;

{---------------------------------------}
procedure TPrefController.setBool(pkey: Widestring; pvalue: boolean; server_side: TPrefKind = pkClient);
begin
     if (pvalue) then
        setString(pkey, 'true', server_side)
     else
        setString(pkey, 'false', server_side);
end;

{---------------------------------------}
procedure TPrefController.setString(pkey, pvalue: Widestring; server_side: TPrefKind = pkClient);
var
    n, t: TXMLTag;
begin
    if (server_side = pkServer) then begin
        n := _server_node;
        _server_dirty := true;
        end
    else if (server_side = pkClient) then
        n := _pref_node
    else // brand
        n := _brand_node;

    t := n.GetFirstTag(pkey);
    if (t <> nil) then begin
        t.ClearCData;
        t.AddCData(pvalue);
        end
    else
        n.AddBasicTag(pkey, pvalue);

    // do we really want to ALWAYS save here?
    if (server_side = pkClient) then Self.Save();
end;

{---------------------------------------}
procedure TPrefController.setInt(pkey: Widestring; pvalue: integer; server_side: TPrefKind = pkClient);
begin
    setString(pkey, IntToStr(pvalue), server_side);
end;

{---------------------------------------}
procedure TPrefController.setStringlist(pkey: Widestring; pvalue: TWideStrings; server_side: TPrefKind = pkClient);
var
    i: integer;
    n, p: TXMLTag;
begin
    // setup the stringlist in it's own parent..
    // with multiple <s> tags for each value.
    if (Server_side = pkServer) then begin
        n := _server_node;
        _server_dirty := true;
        end
    else if (Server_side = pkClient) then
        n := _pref_node
    else // brand
        n := _brand_node;

    p := n.GetFirstTag(pkey);

    if (p = nil) then
        p := n.AddTag(pkey)
    else
        p.ClearTags();

    // plug in all the values
    for i := 0 to pvalue.Count - 1 do begin
        if (pvalue[i] <> '') then
            p.AddBasicTag('s', pvalue[i]);
        end;

    if (server_side = pkClient) then
        Self.Save();
end;

{---------------------------------------}
function TPrefController.findPresenceTag(pkey: Widestring): TXMLTag;
var
    i: integer;
    ptags: TXMLTagList;
begin
    // get some custom pres from the list
    Result := nil;

    ptags := _pref_node.QueryTags('presence');
    for i := 0 to ptags.count - 1 do begin
        if (ptags[i].GetAttribute('name') = pkey) then begin
            Result := ptags[i];
            break;
            end;
        end;

    ptags.Free;
end;

{---------------------------------------}
procedure TPrefController.removePresence(pvalue: TJabberCustomPres);
var
    tag: TXMLTag;
begin
    // remove this specific presence
    tag := _pref_node.QueryXPTag('/exodus/presence@name="' + pvalue.title + '"');

    if (tag <> nil) then
        _pref_node.RemoveTag(tag);
end;

{---------------------------------------}
procedure TPrefController.removeAllPresence();
var
    i: integer;
    ptags: TXMLTagList;
begin
    // remove all custom pres from the list
    ptags := _pref_node.QueryTags('presence');
    for i := 0 to ptags.count - 1 do
        _pref_node.RemoveTag(ptags.Tags[i]);
    ptags.Free;
end;

{---------------------------------------}
function TPrefController.getAllPresence(): TList;
var
    i: integer;
    ptags: TXMLTagList;
    cp: TJabberCustompres;
begin
    Result := Tlist.Create();
    ptags := _pref_node.QueryTags('presence');

    for i := 0 to ptags.Count - 1 do begin
        cp := TJabberCustompres.Create();
        cp.Parse(ptags[i]);
        Result.Add(cp);
        end;
    ptags.Free();
end;

{---------------------------------------}
function TPrefController.getPresence(pkey: Widestring): TJabberCustomPres;
var
    p: TXMLTag;
begin
    // get some custom pres from the list
    Result := nil;

    p := Self.findPresenceTag(pkey);

    if (p <> nil) then begin
        Result := TJabberCustomPres.Create();
        Result.Parse(p);
        end;
end;

{---------------------------------------}
function TPrefController.getPresIndex(idx: integer): TJabberCustomPres;
var
    ptags: TXMLTagList;
begin
    Result := nil;
    ptags := _pref_node.QueryTags('presence');
    if ((idx >= 0) and (idx < ptags.Count)) then
        Result := getPresence(ptags[idx].GetAttribute('name'));
end;

{---------------------------------------}
procedure TPrefController.setPresence(pvalue: TJabberCustomPres);
var
    p: TXMLTag;
begin
    // set some custom pres into the list
    p := Self.findPresenceTag(pvalue.title);
    if (p = nil) then
        p := _pref_node.AddTag('presence');
    pvalue.FillTag(p);
    Self.Save();
end;

{---------------------------------------}
procedure TPrefController.SavePosition(form: TForm);
var
    fkey: Widestring;
    p, f: TXMLTag;
begin
    // save the positions for this form
    fkey := MungeName(form.ClassName);
    p := _pref_node.GetFirstTag('positions');
    if (p = nil) then
        p := _pref_node.AddTag('positions');

    f := p.GetFirstTag(fkey);
    if (f = nil) then
        f := p.AddTag(fkey);

    f.PutAttribute('top', IntToStr(Form.top));
    f.PutAttribute('left', IntToStr(Form.left));
    f.PutAttribute('width', IntToStr(Form.width));
    f.PutAttribute('height', IntToStr(Form.height));

    Self.Save();
end;

{---------------------------------------}
procedure TPrefController.RestorePosition(form: TForm);
var
    f: TXMLTag;
    fkey: Widestring;
    t,l,w,h: integer;
begin
    // set the bounds based on the position info
    {
    t := dflt_top;
    l := dflt_left;
    w := 300;
    h := 300;
    }
    fkey := MungeName(form.Classname);

    f := _pref_node.QueryXPTag('/exodus/positions/' + fkey);
    if (f <> nil) then begin
        t := SafeInt(f.getAttribute('top'));
        l := SafeInt(f.getAttribute('left'));
        w := SafeInt(f.getAttribute('width'));
        h := SafeInt(f.getAttribute('height'));
        end
    else begin
        t := form.Top;
        l := form.Left;
        w := form.Width;
        h := form.Height;
        end;

    if (t < dflt_top) then t := dflt_top;
    if (l < dflt_left) then l := dflt_left;


    if (t + h > Screen.Height) then begin
        t := Screen.Height - h;
    end;
    if (l + w > Screen.Width) then begin
        l := Screen.Width - w;
    end;

    Form.SetBounds(l, t, w, h);
end;

{---------------------------------------}
function TPrefController.CreateProfile(name: Widestring): TJabberProfile;
begin
    Result := TJabberProfile.Create();
    Result.Name := name;
    Result.Port := 5222;
    _profiles.AddObject(name, Result);
end;

{---------------------------------------}
procedure TPrefController.RemoveProfile(p: TJabberProfile);
var
    i: integer;
begin
    i := _profiles.indexOfObject(p);
    p.Free;
    if (i >= 0) then
        _profiles.Delete(i);
end;

{---------------------------------------}
procedure TPrefController.LoadProfiles;
var
    ptags: TXMLTagList;
    i, pcount: integer;
    cur_profile: TJabberProfile;
begin
    _profiles.Clear;

    ptags := _pref_node.QueryTags('profile');
    pcount := ptags.Count;

    for i := 0 to pcount - 1 do begin
        cur_profile := TJabberProfile.Create;
        cur_profile.Load(ptags[i]);
        _profiles.AddObject(cur_profile.name, cur_profile);
        end;

    ptags.Free;
end;

{---------------------------------------}
procedure TPrefController.SaveProfiles;
var
    ptag: TXMLTag;
    ptags: TXMLTagList;
    i: integer;
    cur_profile: TJabberProfile;
begin

    ptags := _pref_node.QueryTags('profile');

    for i := 0 to ptags.count - 1 do
        _pref_node.RemoveTag(ptags[i]);

    for i := 0 to _profiles.Count - 1 do begin
        cur_profile := TJabberProfile(_profiles.Objects[i]);
        ptag := _pref_node.AddTag('profile');
        cur_profile.Save(ptag);
        end;

    Self.Save();
    ptags.Free;
end;

{---------------------------------------}
procedure TPrefController.SetSession(js: TObject);
begin
    // Save the session pointer;
    _js := js;
end;

{---------------------------------------}
procedure TPrefController.FetchServerPrefs();
var
    iq: TJabberIQ;
    js: TJabberSession;
begin
    // Fetch the server stored prefs
    js := TJabberSession(_js);
    iq := TJabberIQ.Create(js, js.generateID(), ServerprefsCallback, 60);
    with iq do begin
        iqType := 'get';
        toJID := '';
        Namespace := XMLNS_PRIVATE;
        with qtag.AddTag('storage') do
            putAttribute('xmlns', XMLNS_PREFS);
        Send();
        end;
end;

{---------------------------------------}
procedure TPrefController.SaveServerPrefs();
var
    js: TJabberSession;
    stag, iq: TXMLTag;
begin
    // Save the prefs to the server
    if (_server_node = nil) then exit;
    if (_js = nil) then exit;
    js := TJabberSession(_js);
    if (not js.Active) then exit;
    if (not _server_dirty) then exit;

    iq := TXMLTag.Create('iq');
    with iq do begin
        putAttribute('type', 'set');
        putAttribute('id', js.generateID());
        with AddTag('query') do begin
            putAttribute('xmlns', XMLNS_PRIVATE);
            stag := AddTag('storage');
            stag.AssignTag(_server_node);
            stag.PutAttribute('xmlns', XMLNS_PREFS);
            end;
        end;
    js.SendTag(iq);
    _server_dirty := false;
end;

{---------------------------------------}
procedure TPrefController.ServerprefsCallback(event: string; tag: TXMLTag);
begin
    // Cache the prefs node
    if (tag = nil) then exit;
    _server_node := TXMLTag.Create(tag.QueryXPTag('/iq/query/storage'));
    TJabberSession(_js).FireEvent('/session/server_prefs', _server_node);
end;

{---------------------------------------}
procedure TPrefController.BeginUpdate();
begin
    _updating := true;
end;

{---------------------------------------}
procedure TPrefController.EndUpdate();
begin
    _updating := false;
    Save();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberProfile.Create();
begin
    inherited Create;

    Name := '';
    Username := '';
    password := '';
    Server := '';
    Resource := '';
    Priority := 0;
    SavePasswd := true;

    ConnectionType := conn_normal;

    // Socket connection
    Host := '';
    Port := 0;
    ssl := false;
    SocksType := 0;
    SocksHost := '';
    SocksPort := 0;
    SocksAuth := false;
    SocksUsername := '';
    SocksPassword := '';

    // HTTP Connection
    URL := '';
    Poll := 0;
    ProxyApproach := 0;
    ProxyHost := '';
    ProxyPort := 0;
    ProxyAuth := false;
    ProxyUsername := '';
    ProxyPassword := '';
end;

{---------------------------------------}
function TJabberProfile.getPassword: Widestring;
begin
    // accessor for password
    result := _password;
end;

{---------------------------------------}
procedure TJabberProfile.setPassword(value: Widestring);
begin
    // accessor for password
    _password := Trim(value);
end;

{---------------------------------------}
procedure TJabberProfile.Load(tag: TXMLTag);
var
    ptag: TXMLTag;
begin
    // Read this profile from the registry
    Name := tag.getAttribute('name');
    Username := tag.GetBasicText('username');
    Server := tag.GetBasicText('server');

    // check for this flag this way, so that if the tag
    // doesn't exist, it'll default to true.
    ptag := tag.GetFirstTag('save_passwd');
    if (ptag <> nil) then
        SavePasswd := SafeBool(tag.GetBasicText('save_passwd'))
    else
        SavePasswd := true;

    ptag := tag.GetFirstTag('password');
    if (ptag.GetAttribute('encoded') = 'yes') then
        Password := DecodeString(ptag.Data)
    else
        Password := ptag.Data;

    Resource := tag.GetBasicText('resource');
    Priority := SafeInt(tag.GetBasicText('priority'));
    ConnectionType := SafeInt(tag.GetBasicText('connection_type'));

    // Socket connection
    Host := tag.GetBasicText('host');
    Port := StrToIntDef(tag.GetBasicText('port'), 5222);
    ssl := SafeBool(tag.GetBasicText('ssl'));
    SocksType := StrToIntDef(tag.GetBasicText('socks_type'), 0);
    SocksHost := tag.GetBasicText('socks_host');
    SocksPort := StrToIntDef(tag.GetBasicText('socks_port'), 0);
    SocksAuth := SafeBool(tag.GetBasicText('socks_auth'));
    SocksUsername := tag.GetBasicText('socks_username');
    SocksPassword := tag.GetBasicText('socks_password');

    // HTTP Connection
    URL := tag.GetBasicText('url');
    Poll := StrToIntDef(tag.GetBasicText('poll'), 10);;
    ProxyApproach := StrToIntDef(tag.GetBasicText('proxy_approach'), 0);;
    ProxyHost := tag.GetBasicText('proxy_host');
    ProxyPort := StrToIntDef(tag.GetBasicText('proxy_port'), 0);
    ProxyAuth := SafeBool(tag.GetBasicText('proxy_auth'));
    ProxyUsername := tag.GetBasicText('proxy_username');
    ProxyPassword := tag.GetBasicText('proxy_password');

    if (Name = '') then Name := 'Untitled Profile';
    if (Server = '') then Server := 'jabber.org';
    if (Resource = '') then Resource := 'Exodus';
end;

{---------------------------------------}
procedure TJabberProfile.Save(node: TXMLTag);
var
    ptag: TXMLTag;
begin
    node.ClearTags();
    node.PutAttribute('name', Name);
    node.AddBasicTag('username', Username);
    node.AddBasicTag('server', Server);
    node.AddBasicTag('save_passwd', SafeBoolStr(SavePasswd));

    // node.AddBasicTag('password', Password);
    ptag := node.AddTag('password');
    if (SavePasswd) then begin
        ptag.PutAttribute('encoded', 'yes');
        ptag.AddCData(EncodeString(Password));
        end;

    node.AddBasicTag('resource', Resource);
    node.AddBasicTag('priority', IntToStr(Priority));

    node.AddBasicTag('connection_type', IntToStr(ConnectionType));

    // Socket connection
    node.AddBasicTag('host', Host);
    node.AddBasicTag('port', IntToStr(Port));
    node.AddBasicTag('ssl', SafeBoolStr(ssl));
    node.AddBasicTag('socks_type', IntToStr(SocksType));
    node.AddBasicTag('socks_host', SocksHost);
    node.AddBasicTag('socks_port', IntToStr(SocksPort));
    node.AddBasicTag('socks_auth', SafeBoolStr(SocksAuth));
    node.AddBasicTag('socks_username', SocksUsername);
    node.AddBasicTag('socks_password', SocksPassword);

    // HTTP Connection
    node.AddBasicTag('url', URL);
    node.AddBasicTag('poll', FloatToStr(Poll));
    node.AddBasicTag('proxy_approach', IntToStr(ProxyApproach));
    node.AddBasicTag('proxy_host', ProxyHost);
    node.AddBasicTag('proxy_port', IntToStr(ProxyPort));
    node.AddBasicTag('proxy_auth', SafeBoolStr(ProxyAuth));
    node.AddBasicTag('proxy_username', ProxyUsername);
    node.AddBasicTag('proxy_password', ProxyPassword);
end;

{---------------------------------------}
function TJabberProfile.IsValid() : boolean;
begin
    if (Name = '') then result := false
    else if (Username = '') then result := false
    else if (Server = '') then result := false
    else if (Password = '') then result := false
    else if (Resource = '') then result := false
    else if (Port = 0) then result := false
    else result := true;
end;

end.
