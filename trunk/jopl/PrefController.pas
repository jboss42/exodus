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
    XMLTag, XMLParser, Presence, 
    {$ifdef Win32}
    Forms, Windows, Registry,
    {$else}
    iniFiles, QForms,  
    {$endif}
    Classes, SysUtils;

const
    s10n_ask = 0;
    s10n_auto_roster = 1;
    s10n_auto_all = 2;

    roster_chat = 0;
    roster_msg = 1;

    // bits for notify events
    notify_toast = 1;
    notify_event = 2;
    notify_flash = 4;
    notify_sound = 8;

    P_EXPANDED = 'expanded';
    P_SHOWONLINE = 'roster_only_online';
    P_SHOWUNSUB = 'roster_show_unsub';
    P_OFFLINEGROUP = 'roster_offline_group';
    P_TIMESTAMP = 'timestamp';
    P_AUTOUPDATE = 'auto_update';
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
    public
        Name: string;
        Username: string;
        password: string;
        Server: string;
        Resource: string;
        Priority: integer;
        ssl: boolean;

        procedure Load(tag: TXMLTag);
        procedure Save(node: TXMLTag);
        function IsValid() : boolean;
    end;

    TPrefController = class
    private
        _js: TObject;
        _pref_filename: string;
        _pref_node: TXMLTag;
        _server_node: TXMLTag;
        _profiles: TStringList;
        _parser: TXMLTagParser;
        _server_dirty: boolean;

        function getDefault(pkey: string): string;
        function findPresenceTag(pkey: string): TXMLTag;
        procedure Save;
        procedure ServerPrefsCallback(event: string; tag: TXMLTag);
    public
        constructor Create(filename: string);

        function getString(pkey: string; server_side: boolean = false): string;
        function getInt(pkey: string; server_side: boolean = false): integer;
        function getBool(pkey: string; server_side: boolean = false): boolean;
        function getStringlist(pkey: string; server_side: boolean = false): TStringList;

        function getAllPresence(): TList;
        function getPresence(pkey: string): TJabberCustomPres;
        function getPresIndex(idx: integer): TJabberCustomPres;

        procedure setString(pkey, pvalue: string; server_side: boolean = false);
        procedure setInt(pkey: string; pvalue: integer; server_side: boolean = false);
        procedure setBool(pkey: string; pvalue: boolean; server_side: boolean = false);
        procedure setStringlist(pkey: string; pvalue: TStrings; server_side: boolean = false);
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

        function CreateProfile(name: string): TJabberProfile;
        procedure RemoveProfile(p: TJabberProfile);

        property Profiles: TStringlist read _profiles write _profiles;
    end;


{$ifdef Win32}
function getUserDir: string;
{$endif}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Session, IQ, XMLUtils,
    {$ifdef Win32}
    Graphics;
    {$else}
    QGraphics;
    {$endif}

var
    dflt_top: integer;
    dflt_left: integer;

{$ifdef Win32}
{---------------------------------------}
function getUserDir: string;
var
    reg: TRegistry;
    tP   : PChar;
begin
    try //except
        reg := TRegistry.Create;
        try //finally free
            with reg do begin
                RootKey := HKEY_CURRENT_USER;
                OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders');
                if ValueExists('AppData') then begin
                    Result := ReadString('AppData') + '\Exodus\';

                    //get userprofile env var and replace in path
                    getMem(tP,1024);
                    If (GetEnvironmentVariable('USERPROFILE', tP, 512) <> 0) and
                    (pos('%USERPROFILE%',Result) > 0) then
                       Result := string(tP) + copy(Result, 14,length(Result) - 13);
                    FreeMem(tP);
                end
                else
                    Result := ExtractFilePath(Application.EXEName);
            end;
        finally
            reg.Free;
        end;
    except
        Result := ExtractFilePath(Application.EXEName);
    end;

    if (not DirectoryExists(Result)) then
        MkDir(Result);
end; //getProfilePath

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

{$endif}

{---------------------------------------}
constructor TPrefController.Create(filename: string);
begin
    inherited Create;

    _pref_filename := filename;
    _parser := TXMLTagParser.Create;
    _parser.ParseFile(_pref_filename);

    if (_parser.Count > 0) then begin
        // we have something to read.. hopefully it's correct :)
        _pref_node := _parser.popTag();
        end
    else
        _pref_node := TXMLTag.Create('exodus');

    _server_node := nil;
    _server_dirty := false;

    _profiles := TStringList.Create;

    getDefaultPos();
end;

{---------------------------------------}
procedure TPrefController.Save;
var
    fs: TStringList;
begin
    fs := TStringList.Create;
    fs.Text := _pref_node.xml;
    fs.SaveToFile(_pref_filename);
end;

{---------------------------------------}
function TPrefController.getDefault(pkey: string): string;
begin
    // set the defaults for the pref controller
    if pkey = P_EXPANDED then
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
        result := 'Away as a result of idle'
    else if pkey = 'xa_status' then
        result := 'XA as a result of idle'
    else if pkey = 'log_path' then
        result := ExtractFilePath(Application.EXEName) + 'logs'
    else if pkey = 'xfer_path' then
        result := ExtractFilePath(Application.EXEName)
    else if pkey = 'inline_status' then
        result := '0'
    else if pkey = 'roster_bg' then
        result := IntToStr(Integer(clWindow))
    else if pkey = 'roster_font_name' then
        result := Screen.IconFont.Name
    else if pkey = 'roster_font_size' then
        result := IntToStr(Screen.IconFont.Size)
    else if pkey = 'roster_font_color' then
        result := IntToStr(Integer(Screen.IconFont.Color))
    else
        result := '';
end;

{---------------------------------------}
function TPrefController.getString(pkey: string; server_side: boolean = false): string;
var
    t: TXMLTag;
begin
    // find string value
    if (Server_side) then
        t := _server_node.GetFirstTag(pkey)
    else
        t := _pref_node.GetFirstTag(pkey);

    if (t = nil) then
        Result := getDefault(pkey)
    else
        Result := t.Data;
end;

{---------------------------------------}
function TPrefController.getInt(pkey: string; server_side: boolean = false): integer;
begin
    // find int value
    Result := SafeInt(getString(pkey, server_side));
end;

{---------------------------------------}
function TPrefController.getBool(pkey: string; server_side: boolean = false): boolean;
begin
    if ((lowercase(getString(pkey, server_side)) = 'true') or
    (getString(pkey, server_side) = '1')) then
        Result := true
    else
        Result := false;
end;

{---------------------------------------}
function TPrefController.getStringlist(pkey: string; server_side: boolean = false): TStringList;
var
    sl: TStringList;
    p: TXMLTag;
    s: TXMLTagList;
    i: integer;
begin
    sl := TStringList.Create;

    if (server_side) then
        p := _server_node.getFirstTag(pkey)
    else
        p := _pref_node.getFirstTag(pkey);

    if (p <> nil) then begin
        s := p.QueryTags('s');
        for i := 0 to s.Count - 1 do
            sl.Add(s.Tags[i].Data);
        s.Free;
        end;
    Result := sl;
end;

{---------------------------------------}
procedure TPrefController.setBool(pkey: string; pvalue: boolean; server_side: boolean = false);
begin
     if (pvalue) then
        setString(pkey, 'true', server_side)
     else
        setString(pkey, 'false', server_side);
end;

{---------------------------------------}
procedure TPrefController.setString(pkey, pvalue: string; server_side: boolean = false);
var
    n, t: TXMLTag;
begin
    if (server_side) then begin
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
    if (not server_side) then Self.Save();
end;

{---------------------------------------}
procedure TPrefController.setInt(pkey: string; pvalue: integer; server_side: boolean = false);
begin
    setString(pkey, IntToStr(pvalue), server_side);
end;

{---------------------------------------}
procedure TPrefController.setStringlist(pkey: string; pvalue: TStrings; server_side: boolean = false);
var
    i: integer;
    n, p: TXMLTag;
begin
    // setup the stringlist in it's own parent..
    // with multiple <s> tags for each value.
    if (Server_side) then begin
        n := _server_node;
        _server_dirty := true;
        end
    else
        n := _pref_node;

    p := n.GetFirstTag(pkey);

    if (p = nil) then
        p := n.AddTag(pkey)
    else
        p.ClearTags();

    // plug in all the values
    for i := 0 to pvalue.Count - 1 do
        p.AddBasicTag('s', pvalue[i]);

    if (not server_side) then
        Self.Save();
end;

{---------------------------------------}
function TPrefController.findPresenceTag(pkey: string): TXMLTag;
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
end;

{---------------------------------------}
function TPrefController.getPresence(pkey: string): TJabberCustomPres;
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
    fkey: string;
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
    fkey: string;
    t,l,w,h: integer;
begin
    // set the bounds based on the position info
    t := dflt_top;
    l := dflt_left;
    w := 300;
    h := 300;

    fkey := MungeName(form.Classname);

    f := _pref_node.QueryXPTag('/exodus/positions/' + fkey);
    if (f <> nil) then begin
        t := SafeInt(f.getAttribute('top'));
        l := SafeInt(f.getAttribute('left'));
        w := SafeInt(f.getAttribute('width'));
        h := SafeInt(f.getAttribute('height'));
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
function TPrefController.CreateProfile(name: string): TJabberProfile;
begin
    Result := TJabberProfile.Create();
    Result.Name := name;
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
    if (not js.Stream.Active) then exit;
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
    _server_node := tag.QueryXPTag('/iq/query/storage');
    TJabberSession(_js).FireEvent('/session/server_prefs', _server_node);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TJabberProfile.Load(tag: TXMLTag);
begin
    // Read this profile from the registry
    Name := tag.getAttribute('name');
    Username := tag.GetBasicText('username');
    Server := tag.GetBasicText('server');
    Password := tag.GetBasicText('password');
    Resource := tag.GetBasicText('resource');
    Priority := SafeInt(tag.GetBasicText('priority'));
    ssl := (tag.GetBasicText('ssl') = 'yes');

    if (Name = '') then Name := 'Untitled Profile';
    if (Server = '') then Server := 'jabber.org';
    if (Resource = '') then Resource := 'Exodus';
end;

{---------------------------------------}
procedure TJabberProfile.Save(node: TXMLTag);
begin
    node.ClearTags();
    node.PutAttribute('name', Name);
    node.AddBasicTag('username', Username);
    node.AddBasicTag('server', Server);
    node.AddBasicTag('password', Password);
    node.AddBasicTag('resource', Resource);
    node.AddBasicTag('priority', IntToStr(Priority));
    if (ssl) then
        node.AddBasicTag('ssl', 'yes')
    else
        node.AddBasicTag('ssl', 'no');
end;

{---------------------------------------}
function TJabberProfile.IsValid() : boolean;
begin
    if (Name = '') then result := false
    else if (Username = '') then result := false
    else if (Server = '') then result := false
    else if (Password = '') then result := false
    else if (Resource = '') then result := false
    else result := true;
end;

end.
