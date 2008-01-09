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

{$ifdef VER150}
    {$define INDY9}
{$endif}

interface
uses
    Unicode, XMLTag, XMLParser, Presence, IdHTTP,
    
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

    proxy_none = 0;
    proxy_socks4 = 1;
    proxy_socks4a = 2;
    proxy_socks5 = 3;
    proxy_http = 4;
    
    roster_chat = 0;
    roster_msg = 1;

    // bits for notify events
    notify_toast = 1;
    notify_event = 2;
    notify_flash = 4;
    notify_sound = 8;
    notify_tray  = 16;
    notify_front = 32;

    // normal msg options
    msg_normal = 0;
    msg_all_chat = 1;
    msg_existing_chat = 2;

    // invite options
    invite_normal = 0;
    invite_popup = 1;
    invite_accept = 2;

    // roster visible levels
    show_offline = 0;
    show_dnd = 1;
    show_xa = 2;
    show_away = 3;
    show_available = 4;

    P_EXPANDED = 'expanded';
    P_SHOWONLINE = 'roster_only_online';
    P_SHOWUNSUB = 'roster_show_unsub';
    P_OFFLINEGROUP = 'roster_offline_group';
    P_TIMESTAMP = 'timestamp';
    P_AUTOUPDATE = 'auto_updates';
    P_CHAT = 'roster_chat';
    P_SUB_AUTO = 's10n_auto_accept';

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
    TPrefController = class;

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
        temp: boolean;

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
        NumPollKeys: integer;

        constructor Create(prof_name: string);

        procedure Load(tag: TXMLTag);
        procedure Save(node: TXMLTag);
        function IsValid() : boolean;

        property password: Widestring read getPassword write setPassword;
end;

    TPrefKind = (pkClient, pkServer);

    TPrefController = class
    private
        _js: TObject;
        _pref_filename: Widestring;
        _pref_node: TXMLTag;
        _server_node: TXMLTag;
        _profiles: TStringList;
        _parser: TXMLTagParser;
        _server_dirty: boolean;
        _updating: boolean;

        function findPresenceTag(pkey: Widestring): TXMLTag;
        procedure Save;
        procedure ServerPrefsCallback(event: string; tag: TXMLTag);
    public
        constructor Create(filename: Widestring);
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

        procedure SavePosition(form: TForm); overload;
        procedure SavePosition(form: TForm; key: Widestring); overload;

        procedure RestorePosition(form: TForm); overload;
        function RestorePosition(form: TForm; key: Widestring): boolean; overload;

        procedure setProxy(http: TIdHttp);

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

procedure fillDefaultStringlist(pkey: Widestring; sl: TWideStrings);
function getDefault(pkey: Widestring): Widestring;

var
    s_brand_node: TXMLTag;
    s_default_node: TXmlTag;

resourceString
    sIdleAway = 'Away as a result of idle.';
    sIdleXA = 'XA as a result of idle.';


function getMyDocs: string;
function getUserDir: string;

{$ifdef Win32}
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
function getMyDocs: string;
var
    reg: TRegistry;
begin
    // Get the path to My Documents
    Result := '';
    
    try
    reg := TRegistry.Create;
    try //finally free
        with reg do begin
            RootKey := HKEY_CURRENT_USER;
            OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders');
            if ValueExists('Personal') then begin
                Result := ReadString('Personal') + '\';
                Result := ReplaceEnvPaths(Result);
            end;
        end;
    finally
        reg.Free();
    end;
    except
        Result := ExtractFilePath(Application.EXEName);
    end;

end;

{---------------------------------------}
function getUserDir: string;
var
    appdata: string;
    local_appdata: string;
    exe_path: string;
    reg: TRegistry;

    function testDir(dir: string; create: boolean): boolean;
    var
        dir_ok: boolean;
        f: TFileStream;
        fn: string;
    begin
        // first just check the file
        Result := false;
        fn := dir + 'exodus.xml';
        if (fileExists(fn)) then begin
            Result := true;
            exit;
        end;

        if (not Create) then exit;

        // check the directory
        dir_ok := DirectoryExists(dir);
        if (dir_ok = false) then begin
            dir_ok := CreateDir(dir);
        end;
        if (dir_ok = false) then exit;

        // try to create a new file
        try
            f := TFileStream.Create(dir + 'test.xml', fmCreate);
            f.Free();
            DeleteFile(dir + 'test.xml');
            Result := true;
        except
            // just eat these.
            on EFOpenError do exit;
        end;
    end;

begin
    try
    reg := TRegistry.Create;
    try //finally free
        with reg do begin
            RootKey := HKEY_CURRENT_USER;
            OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders');
            if ValueExists('AppData') then begin
                appdata := ReadString('AppData') + '\Exodus\';
                appdata := ReplaceEnvPaths(appdata);
            end;

            if ValueExists('Local AppData') then begin
                local_appdata := ReadString('Local AppData') + '\Exodus\';
                local_appdata := ReplaceEnvPaths(local_appdata);
            end;

            exe_path := ExtractFilePath(Application.EXEName);
        end;
    finally
        reg.Free();
    end;
    except
        exe_path := ExtractFilePath(Application.EXEName);
    end;

    // first try appdata,
    // then try local_appdata,
    // then use exe_path as a last resort
    Result := '';

    // these check for existing files
    if (testDir(appdata, false)) then Result := appdata
    else if (testDir(local_appdata, false)) then Result := local_appdata
    else if (testDir(exe_path, false)) then Result := exe_path;

    if (Result = '') then begin
        // these try to create a new file
        if (testDir(appData, true)) then Result := appData
        else if (testDir(local_appdata, true)) then Result := local_appdata
        else Result := exe_path;
    end;

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

procedure getUserDir(): string;
begin
    Result := '~/';
end;

procedure getMyDocs(): string;
begin
    Result := '~/';
end;

procedure getDefaultPos;
begin
    dflt_top := 10;
    dflt_left := 10;
end;

{$endif}

{---------------------------------------}
constructor TPrefController.Create(filename: Widestring);
{$ifdef Win32}
var
    reg: TRegistry;
    f, p: String;
{$endif}
begin
    inherited Create();

    _pref_filename := filename;
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


    _server_node := nil;
    _server_dirty := false;
    _profiles := TStringList.Create;
    _updating := false;

    getDefaultPos();

    {$ifdef Win32}
    // Write out the current prefs file..
    // this is so the un-installer can remove the prefs
    // when it does it's thing.

    // If we used -c, we may just be using the current dir,
    // So get the current dir, and pre-pend it.
    f := _pref_filename;
    p := ExtractFilePath(f);
    if (p = '') then begin
        p := GetCurrentDir();
        f := p + '\' + f;
    end;

    reg := TRegistry.Create();
    try
        reg.RootKey := HKEY_CURRENT_USER;
        reg.OpenKey('\Software\Jabber\Exodus', true);
        reg.WriteString('prefs_file', f);
        reg.CloseKey();
    finally
        reg.Free();
    end;
    {$endif}

end;

{---------------------------------------}
destructor TPrefController.Destroy;
begin
    // Kill our cache'd nodes, etc.
    if (_pref_node <> nil) then
        _pref_node.Free();
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
function TPrefController.getString(pkey: Widestring; server_side: TPrefKind = pkClient): Widestring;
var
    t: TXMLTag;
begin
    t := nil;

    // find string value
    case server_side of
        pkClient:  t := _pref_node.GetFirstTag(pkey);
        pkServer:  t := _server_node.GetFirstTag(pkey);
end;

    if (t = nil) then
        Result := getDefault(pkey)
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
    case server_side of
        pkClient:   p := _pref_node.GetFirstTag(pkey);
        pkServer:   p := _server_node.GetFirstTag(pkey);
        else p:= nil;
end;

    if (p <> nil) then begin
        sl.Clear();
        s := p.QueryTags('s');
        for i := 0 to s.Count - 1 do
            sl.Add(s.Tags[i].Data);
        s.Free;
    end
    else
        fillDefaultStringList(pkey, sl);
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
    else
        n := _pref_node;

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
    else
        n := _pref_node;

    if (n = nil) then
        p := nil
    else
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
begin
    fkey := MungeName(form.ClassName);
    SavePosition(form, fkey);
end;

{---------------------------------------}
procedure TPrefController.SavePosition(form: TForm; key: Widestring);
var
    p, f: TXMLTag;
begin
    // save the positions for this form
    p := _pref_node.GetFirstTag('positions');
    if (p = nil) then
        p := _pref_node.AddTag('positions');

    f := p.GetFirstTag(key);
    if (f = nil) then
        f := p.AddTag(key);

    f.setAttribute('top', IntToStr(Form.top));
    f.setAttribute('left', IntToStr(Form.left));
    f.setAttribute('width', IntToStr(Form.width));
    f.setAttribute('height', IntToStr(Form.height));

    Self.Save();
end;


{---------------------------------------}
function TPrefController.RestorePosition(form: TForm; key: Widestring): boolean;
var
    f: TXMLTag;
    t,l,w,h: integer;
begin
    f := _pref_node.QueryXPTag('/exodus/positions/' + key);
    if (f <> nil) then begin
        t := SafeInt(f.getAttribute('top'));
        l := SafeInt(f.getAttribute('left'));
        w := SafeInt(f.getAttribute('width'));
        h := SafeInt(f.getAttribute('height'));
    end
    else begin
        Result := false;
        exit;
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
    Result := true;
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
procedure TPrefController.setProxy(http: TIdHttp);
var
    {$ifdef Win32}
    reg: TRegistry;
    {$endif}
    srv: string;
    colon: integer;
begin
    if (getInt('http_proxy_approach') = http_proxy_ie) then begin
        // get IE settings from registry

        // todo: figure out some way of doing this XP??
        {$ifdef Win32}
        reg := TRegistry.Create();
        try
            reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings', false);
            if (reg.ValueExists('ProxyEnable') and
                (reg.ReadInteger('ProxyEnable') <> 0)) then begin
                srv := reg.ReadString('ProxyServer');
                colon := pos(':', srv);
                {$ifdef INDY9}
                with http.ProxyParams do begin
                    ProxyServer := Copy(srv, 1, colon-1);
                    ProxyPort := StrToInt(Copy(srv, colon+1, length(srv)));
                end;
                {$else}
                with http.Request do begin
                    ProxyServer := Copy(srv, 1, colon-1);
                    ProxyPort := StrToInt(Copy(srv, colon+1, length(srv)));
                end;
                {$endif}
            end;
        finally
            reg.Free();
        end;
        {$endif}
        
    end
    else if (getInt('http_proxy_approach') = http_proxy_custom) then begin
        {$ifdef INDY9}
        with http.ProxyParams do begin
        {$else}
        with http.Request do begin
        {$endif}
            ProxyServer := getString('http_proxy_host');
            ProxyPort := SafeInt(getString('http_proxy_port'));
            if (getBool('http_proxy_auth')) then begin
                ProxyUsername := getString('http_proxy_user');
                ProxyPassword := getString('http_proxy_password');
            end;
        end;
    end;
end;


{---------------------------------------}
function TPrefController.CreateProfile(name: Widestring): TJabberProfile;
begin
    Result := TJabberProfile.Create(name);
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
        cur_profile := TJabberProfile.Create('');
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
        // don't save temp profiles.
        if (not cur_profile.temp) then begin
            ptag := _pref_node.AddTag('profile');
            cur_profile.Save(ptag);
        end;
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
            setAttribute('xmlns', XMLNS_PREFS);
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
        setAttribute('type', 'set');
        setAttribute('id', js.generateID());
        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_PRIVATE);
            stag := AddTag('storage');
            stag.AssignTag(_server_node);
            stag.setAttribute('xmlns', XMLNS_PREFS);
        end;
    end;
    js.SendTag(iq);
    _server_dirty := false;
end;

{---------------------------------------}
procedure TPrefController.ServerPrefsCallback(event: string; tag: TXMLTag);
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
constructor TJabberProfile.Create(prof_name : string);
begin
    inherited Create;

    Name       := prof_name;

    Username   := getDefault('brand_profile_username');
    password   := getDefault('brand_profile_password');
    Server     := getDefault('brand_profile_server');
    Resource   := getDefault('brand_profile_resource');
    Priority   := SafeInt(getDefault('brand_profile_priority'));
    SavePasswd := SafeBool(getDefault('brand_profile_save_password'));
    ConnectionType := SafeInt(getDefault('brand_profile_conn_type'));
    temp       := false;

    // Socket connection
    Host          := getDefault('brand_profile_host');
    Port          := SafeInt(getDefault('brand_profile_port'));
    ssl           := SafeBool(getDefault('brand_profile_ssl'));
    SocksType     := SafeInt(getDefault('brand_profile_socks_type'));
    SocksHost     := getDefault('brand_profile_socks_host');
    SocksPort     := SafeInt(getDefault('brand_profile_socks_port'));
    SocksAuth     := SafeBool(getDefault('brand_profile_socks_auth'));
    SocksUsername := getDefault('brand_profile_socks_user');
    SocksPassword := getDefault('brand_profile_socks_password');

    // HTTP Connection
    URL           := getDefault('brand_profile_http_url');
    Poll          := SafeInt(getDefault('brand_profile_http_poll'));
    NumPollKeys   := SafeInt(getDefault('brand_profile_num_poll_keys'));
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
    Poll := StrToIntDef(tag.GetBasicText('poll'), 10);
    NumPollKeys := StrToIntDef(tag.GetBasicText('num_poll_keys'), 256);

    if (Name = '') then Name := 'Untitled Profile';
    if (Server = '') then Server := 'jabber.org';
    if (Resource = '') then Resource := 'Exodus';
end;

{---------------------------------------}
procedure TJabberProfile.Save(node: TXMLTag);
var
    ptag: TXMLTag;
begin
    if (temp) then exit;

    node.ClearTags();
    node.setAttribute('name', Name);
    node.AddBasicTag('username', Username);
    node.AddBasicTag('server', Server);
    node.AddBasicTag('save_passwd', SafeBoolStr(SavePasswd));

    ptag := node.AddTag('password');
    if (SavePasswd) then begin
        ptag.setAttribute('encoded', 'yes');
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
    node.AddBasicTag('num_poll_keys', IntToStr(NumPollKeys));
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

{---------------------------------------}
procedure fillDefaultStringlist(pkey: Widestring; sl: TWideStrings);
var
    t: TXMLTag;
    s: TXMLTagList;
    i: integer;
begin
    sl.Clear();
    t := s_brand_node.GetFirstTag(pkey);
    if (t = nil) then
        t := s_default_node.GetFirstTag(pkey);
    if (t = nil) then exit;

    s := t.QueryTags('s');
    for i := 0 to s.Count - 1 do
        sl.Add(s.Tags[i].Data);
    s.Free;
end;

{---------------------------------------}
function getDefault(pkey: Widestring): Widestring;
var
    t: TXMLTag;
begin
    t := s_brand_node.GetFirstTag(pkey);
    if (t <> nil) then begin
        result := t.Data;
        exit;
    end;

    t := s_default_node.GetFirstTag(pkey);
    if (t <> nil) then begin
        result := t.Data;
        exit;
    end;

    // set the defaults for the pref controller
    if pkey = 'away_status' then
        result := sIdleAway
    else if pkey = 'xa_status' then
        result := sIdleXA
    else if pkey = 'log_path' then
        result := getMyDocs() + 'Exodus-Logs'
    else if pkey = 'xfer_path' then
        result := getMyDocs() + 'Exodus-Downloads'
    else if pkey = 'spool_path' then
        result := getUserDir() + 'spool.xml'

    {$ifdef Win32}
    else if pkey = 'roster_font_name' then
        result := Screen.IconFont.Name
    else if pkey = 'roster_font_size' then
        result := IntToStr(Screen.IconFont.Size)
    else if pkey = 'roster_font_color' then
        result := IntToStr(Integer(Screen.IconFont.Color))
    {$else}
    else if pkey = 'roster_font_name' then
        result := Application.Font.Name
    else if pkey = 'roster_font_size' then
        result := IntToStr(Application.Font.Size)
    else if pkey = 'roster_font_color' then
        result := IntToStr(Integer(Application.Font.Color))
    {$endif}
    else
        result := '';
end;

procedure init();
var
    res: TResourceStream;
    sl: TStringList;
    parser: TXMLTagParser;
begin
    parser := TXMLTagParser.Create;

    // WTF is HInstance?
    res := TResourceStream.Create(HInstance, 'defaults', 'XML');
    sl := TStringList.Create();
    sl.LoadFromStream(res);
    res.Free();
    parser.ParseString(sl.Text, '');
    sl.Free();
    if (parser.Count > 0) then begin
        s_default_node := parser.popTag();
        parser.Clear();
    end
    else
        s_default_node := TXmlTag.Create('brand');

    parser.ParseFile(ExtractFilePath(Application.EXEName) + 'branding.xml');
    if (parser.Count > 0) then begin
        // we have something to read.. hopefully it's correct :)
        s_brand_node := parser.popTag();
        parser.Clear();
    end
    else
        // create some default node
        s_brand_node := TXMLTag.Create('brand');

    parser.Free();
end;

initialization
    init();

finalization
    s_default_node.Free();
    s_brand_node.Free();
end.
