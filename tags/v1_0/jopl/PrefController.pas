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
    XMLParser,
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

        {$ifdef Win32}
        procedure Load(pkey: string);
        procedure Save(pkey: string);
        {$endif}

        {$ifdef linux}
        procedure Load(pkey: string; _ini: TiniFile);
        procedure Save(pkey: string; _ini: TiniFile);
        {$endif}
    end;

    TPrefController = class
    private
        {$ifdef linux}
        _ini: TiniFile;
        {$else}
        _reg: TRegistry;
        {$endif}
        _profiles: TStringList;
        _parser: TXMLTagParser;
        function getDefault(pkey: string): string;
    public
        constructor Create(RegKey: string);

        function getString(pkey: string): string;
        function getInt(pkey: string): integer;
        function getBool(pkey: string): boolean;
        function getStringlist(pkey: string): TStringList;

        procedure setString(pkey, pvalue: string);
        procedure setInt(pkey: string; pvalue: integer);
        procedure setBool(pkey: string; pvalue: boolean);
        procedure setStringlist(pkey: string; pvalue: TStrings);

        procedure SavePosition(form: TForm);
        procedure RestorePosition(form: TForm);

        procedure LoadProfiles;
        procedure SaveProfiles;

        function CreateProfile(name: string): TJabberProfile;
        procedure RemoveProfile(p: TJabberProfile);

        property Profiles: TStringlist read _profiles write _profiles;
    end;

implementation
uses
    {$ifdef Win32}
    Graphics, Dialogs,
    {$else}
    QGraphics, QDialogs,
    {$endif}
    XMLTag;

constructor TPrefController.Create(RegKey: string);
begin
    inherited Create;

    {$ifdef Win32}
    _reg := TRegistry.Create;
    with _reg do begin
        RootKey := HKEY_CURRENT_USER;
        OpenKey(RegKey, true);
        Access := KEY_ALL_ACCESS;
        end;
    {$else}
    _ini := TiniFile.Create(RegKey);
    {$endif}

    _profiles := TStringList.Create;
    _parser := TXMLTagParser.Create;
end;

function TPrefController.getDefault(pkey: string): string;
begin
    // set the defaults for the pref controller
    if pkey = P_EXPANDED then
        result := '1'
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
        result := ExtractFilePath(Application.EXEName) + 'logs\'
    else
        result := '0';
end;

function TPrefController.getString(pkey: string): string;
begin
    // find string value
    {$ifdef Win32}
    if _reg.ValueExists(pkey) then
        Result := _reg.ReadString(pkey)
    else begin
        Result := getDefault(pkey);
        setString(pkey, Result);
    end;
    {$else}
    Result := _ini.ReadString('Registry', pkey, getDefault(pkey));
    {$endif}
end;

function TPrefController.getInt(pkey: string): integer;
begin
    // find int value
    {$ifdef Win32}
    try
        Result := _reg.ReadInteger(pkey);
    except
        Result := StrToInt(getDefault(pkey));
        setInt(pkey, Result);
    end;
    {$else}
    Result := StrToInt(getString(pkey));
    {$endif}
end;

function TPrefController.getBool(pkey: string): boolean;
var
    i: integer;
begin
    {$ifdef Win32}
    try
        Result := _reg.ReadBool(pkey);
    except
        i := StrToInt(getDefault(pkey));
        if i = 0 then Result := false else Result := true;
        setBool(pkey, Result);
    end;
    {$else}
    if (lowercase(getString(pkey)) = 'true') then
        Result := true
    else
        Result := false;
    {$endif}
end;

function TPrefController.getStringlist(pkey: string): TStringList;
var
    sl: TStringList;
    txt: string;
    c, t: TXMLTag;
    s: TXMLTagList;
    i: integer;
begin
    sl := TStringList.Create;
    txt := getString(pkey);
    _parser.ParseString(txt, '');

    if (_parser.Count > 0) then begin
        t := _parser.popTag();
        s := t.QueryTags('s');
        for i := 0 to s.Count - 1 do begin
            c := s.Tags[i];
            sl.Add(c.Data);
            end;
        end;

    Result := sl;
end;

procedure TPrefController.setBool(pkey: string; pvalue: boolean);
begin
    {$ifdef Win32}
     _reg.WriteBool(pkey, pvalue);
     {$else}
     if (pvalue) then
        setString(pkey, 'true')
     else
        setString(pkey, 'false');
     {$endif}
end;

procedure TPrefController.setString(pkey, pvalue: string);
begin
    {$ifdef Win32}
    _reg.WriteString(pkey, pvalue);
    {$else}
    _ini.WriteString('Registry', pkey, pvalue);
    {$endif}
end;

procedure TPrefController.setInt(pkey: string; pvalue: integer);
begin
    {$ifdef Win32}
    _reg.WriteInteger(pkey, pvalue);
    {$else}
    setString(pkey, IntToStr(pvalue));
    {$endif}

end;

procedure TPrefController.setStringlist(pkey: string; pvalue: TStrings);
var
    i: integer;
    t: TXMLTag;
begin
    // write out all of the strings
    t := TXMLTag.Create(pkey);
    for i := 0 to pvalue.Count - 1 do
        t.AddBasicTag('s', pvalue[i]);
    setString(pkey, t.xml);
end;

procedure TPrefController.SavePosition(form: TForm);
var
    {$ifdef Win32}
    fkey: TRegistry;
    {$else}
    tmps: string;
    {$endif}
begin
    // save the positions for this form
    {$ifdef Win32}
    fkey := TRegistry.Create;
    fkey.OpenKey(_reg.CurrentPath + '\' + form.name, true);

    fkey.WriteInteger('top', Form.top);
    fkey.WriteInteger('left', Form.left);
    fkey.WriteInteger('height', Form.height);
    fkey.WriteInteger('width', Form.width);
    {$else}
    _ini.WriteString('FORM_' + form.name, 'top', IntToStr(Form.top));
    _ini.WriteString('FORM_' + form.name, 'left', IntToStr(Form.left));
    _ini.WriteString('FORM_' + form.name, 'height', IntToStr(Form.height));
    _ini.WriteString('FORM_' + form.name, 'width', IntToStr(Form.width));
    {$endif}

end;

procedure TPrefController.RestorePosition(form: TForm);
var
    {$ifdef Win32}
    fkey: TRegistry;
    {$else}
    fkey: string;
    {$endif}
    t,l,w,h: integer;
begin
    // set the bounds based on the position info
    {$ifdef Win32}
    if (_reg.KeyExists(form.name)) then begin
        fkey := TRegistry.Create;
        fkey.OpenKey(_reg.CurrentPath + '\' + form.Name, false);
        t := fkey.ReadInteger('top');
        l := fkey.ReadInteger('left');
        w := fkey.ReadInteger('width');
        h := fkey.ReadInteger('height');

    {$else}
    fkey := 'FORM_' + form.name;
    if  (_ini.SectionExists(fkey)) then begin
        t := StrToInt(_ini.ReadString(fkey, 'top', '100'));
        l := StrToInt(_ini.ReadString(fkey, 'left', '100'));
        w := StrToInt(_ini.ReadString(fkey, 'width', '300'));
        h := StrToInt(_ini.ReadString(fkey, 'height', '300'));
    {$endif}

        if (t + h > Screen.Height) then begin
            t := Screen.Height - h;
        end;
        if (l + w > Screen.Width) then begin
            l := Screen.Width - w;
        end;

        Form.SetBounds(l, t, w, h);
        end
    else begin
        Form.Width := 300;
        Form.Height := 300;
        end;
end;

function TPrefController.CreateProfile(name: string): TJabberProfile;
begin
    Result := TJabberProfile.Create();
    Result.Name := name;
    _profiles.AddObject(name, Result);
end;

procedure TPrefController.RemoveProfile(p: TJabberProfile);
var
    i: integer;
begin
    i := _profiles.indexOfObject(p);
    p.Free;
    if (i >= 0) then
        _profiles.Delete(i);
end;

procedure TPrefController.LoadProfiles;
var
    i, pcount: integer;
    cur_profile: TJabberProfile;
begin
    _profiles.Clear;

    {$ifdef Win32}
    if _reg.ValueExists('profile_count') then begin
        pcount := _reg.ReadInteger('profile_count');
    {$else}
    pcount := getInt('profile_count');
    if (pcount > 0) then begin
    {$endif}
        for i := 0 to pcount - 1 do begin
            cur_profile := TJabberProfile.Create;
            {$ifdef Win32}
            cur_profile.Load(_reg.CurrentPath + '\profile_' + Trim(IntToStr(i)));
            {$else}
            cur_profile.Load('Profile_' + Trim(IntToStr(i)), _ini);
            {$endif}
            _profiles.AddObject(cur_profile.name, cur_profile);
            end;
        end;
end;

procedure TPrefController.SaveProfiles;
var
    i: integer;
    cur_profile: TJabberProfile;
begin
    setInt('profile_count', _profiles.Count);
    for i := 0 to _profiles.Count - 1 do begin
        cur_profile := TJabberProfile(_profiles.Objects[i]);
        {$ifdef Win32}
        cur_profile.Save(_reg.CurrentPath + '\profile_' + Trim(IntToStr(i)));
        {$else}
        cur_profile.Save('Profile_' + Trim(IntToStr(i)), _ini);
        {$endif}
        end;

end;

{$ifdef Win32}
procedure TJabberProfile.Load(pkey: string);
var
    r: TRegistry;
begin
    // Read this profile from the registry
    r := TRegistry.Create;
    r.OpenKey(pkey, true);
    if r.ValueExists('name') then
        Name := r.ReadString('name')
    else
        Name := 'Untitled Profile';

    if r.ValueExists('username') then
        Username := r.ReadString('username')
    else
        Username := '';

    if r.ValueExists('server') then
        Server := r.ReadString('server')
    else
        Server := 'jabber.org';

    if r.ValueExists('password') then
        Password := r.ReadString('password')
    else
        Password := '';

    if r.ValueExists('resource') then
        Resource := r.ReadString('resource')
    else
        Resource := 'Exodus';

    if r.ValueExists('priority') then
        Priority := r.ReadInteger('priority')
    else
        Priority := 0;
    r.Free;
end;

procedure TJabberProfile.Save(pkey: string);
var
    r: TRegistry;
begin
    r := TRegistry.Create();
    r.OpenKey(pkey, true);

    r.WriteString('name', Name);
    r.WriteString('username', Username);
    r.WriteString('server', Server);
    r.WriteString('password', Password);
    r.WriteString('resource', Resource);
    r.WriteInteger('priority', Priority);
    r.Free;
end;
{$endif}

{$ifdef linux}
procedure TJabberProfile.Load(pkey: string; _ini: TiniFile);
begin
    Name := _ini.ReadString(pkey, 'name', 'Untitled Profile');
    Username := _ini.ReadString(pkey, 'username', '');
    Server := _ini.ReadString(pkey, 'server', 'jabber.org');
    Password := _ini.ReadString(pkey, 'password', '');
    Resource := _ini.ReadString(pkey, 'resource', 'Exodus');
    Priority := StrToInt(_ini.ReadString(pkey, 'priority', '0'));
end;

procedure TJabberProfile.Save(pkey: string; _ini: TiniFile);
begin
    _ini.WriteString(pkey, 'name', Name);
    _ini.WriteString(pkey, 'username', Username);
    _ini.WriteString(pkey, 'pasword', Password);
    _ini.WriteString(pkey, 'server', Server);
    _ini.WriteString(pkey, 'resource', Resource);
    _ini.WriteString(pkey, 'priority', IntToStr(Priority));
end;
{$endif}

end.
