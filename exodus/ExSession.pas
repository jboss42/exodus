unit ExSession;
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
    // Exodus'y stuff
    COMEntityCache, COMToolbar, 
    COMRosterImages, COMController, COMRoster, COMPPDB, JabberID,
    Unicode, Signals, XMLTag, Session, GUIFactory, Register, Notify, Regexpr,
    S10n,

    // Delphi stuff
    Registry, Classes, Dialogs, Forms, SysUtils, StrUtils, Windows, TntSysUtils;

type
    TExStartParams = class
    public
        auto_login: boolean;
        priority: integer;
        show: Widestring;
        status: Widestring;
        debug: boolean;
        minimized: boolean;
        testaa: boolean;
        ssl_ok: boolean;
        test_menu: boolean;

        constructor create();
    end;

procedure PlayXMPPActions();
procedure ClearXMPPActions();
procedure ParseXMPPFile(filename: string;
                        var connect_node: TXMLTag;
                        var jid: TJabberID);
procedure ParseURI(uri: string;
                   var connect_node: TXMLTag;
                   var jid: TJabberID);


// forward declares
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function SetupSession(): boolean;
procedure TeardownSession();

procedure AddSound(reg: TRegistry; pref_name: string; user_text: string);
function CmdLine(): string;
function checkSSL(): boolean;

var
    sExodusMutex: Cardinal;

    ExCOMController: TExodusController;
    ExCOMRoster: TExodusRoster;
    ExCOMPPDB: TExodusPPDB;
    ExCOMRosterImages: TExodusRosterImages;
    ExCOMEntityCache: TExodusEntityCache;
    ExCOMToolbar: TExodusToolbar;

    ExRegController: TRegController;
    ExStartup: TExStartParams;
    uri_regex: TRegExpr;
    pair_regex: TRegExpr;
    im_regex: TRegExpr;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$WARN UNIT_PLATFORM OFF}

uses
    Avatar, NewUser, RosterImages,   
    ActnList, Graphics, ExtCtrls, ExRichEdit,
    Controls, GnuGetText, ConnDetails, IdWinsock2,
    Browser, ChatWin, GetOpt, Invite, Jabber1, PrefController, StandardAuth,
    PrefNotify, Room, RosterAdd, MsgRecv, NetMeetingFix, Profile, RegForm,
    JabberUtils, ExUtils,  ExResponders, MsgDisplay,  stringprep,
    XMLParser, XMLUtils, DebugLogger;

const
    sCommandLine =  'The following command line parameters are available: '#13#10#13#10;
    sCmdDebug =     ' -d '#9#9' : Debug mode on'#13#10;
    sCmdFileLog =   ' -l '#9#9' : log debug output to file'#13#10;
    sCmdMinimized = ' -m '#9#9' : Start minimized'#13#10;
    sCmdInvisible = ' -v '#9#9' : invisible mode'#13#10;
    sCmdHelp =      ' -? '#9#9' : Show Help'#13#10;
    sCmdExpanded =  ' -x [yes|no] '#9' : Expanded Mode'#13#10;
    sCmdJID =       ' -j [jid] '#9#9' : Jid'#13#10;
    sCmdPassword =  ' -p [pass] '#9' : Password'#13#10;
    sCmdResource =  ' -r [res] '#9' : Resource'#13#10;
    sCmdPriority =  ' -i [pri] '#9' : Priority'#13#10;
    sCmdProfile =   ' -f [prof] '#9' : Profile name'#13#10;
    sCmdConfig =    ' -c [file] '#9' : Config path name'#13#10;
    sCmdXMPP =      ' -X [xmpp URI] '#9' : XMPP URI handling'#13#10;
    
    sUnkArg = 'Invalid command line:%s';
    sWinsock2 = 'Winsock2 is required for this application. Please obtain the winsock2 installer from Microsoft for your operating system.';
    sDefaultProfile = 'Default Profile';

    sSoundChatactivity = 'Activity in a chat window';
    sSoundInvite = 'Invited to a room';
    sSoundKeyword = 'Keyword in a room';
    sSoundNewchat = 'New conversation';
    sSoundNormalmsg = 'Received a normal message';
    sSoundOffline = 'Contact went offline';
    sSoundOnline = 'Contact came online';
    sSoundRoomactivity = 'Activity in a room';
    sSoundS10n = 'Subscription request';
    sSoundOOB = 'File Transfers';
    sSoundAutoResponse = 'Auto response generated';
    sSoundSetup = 'Make sure to configure sounds in your Sounds Control Panel using the hotlink provided.';


var
    // Various other key controllers
    _guibuilder: TGUIFactory;
    _Notify: TNotifyController;
    _subcontroller: TSubController;
    _richedit: THandle;
    _mutex: THandle;
    _xmpp_action_list: TList;


constructor TExStartParams.create();
begin
    inherited;
    auto_login := false;
    priority := 0;
    show := '';
    status := '';
    debug := false;
    minimized := false;
    testaa := false;
    ssl_ok := false;
    test_menu := false;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function SetupSession(): boolean;
var
    regdll, invisible, show_help, log_debug: boolean;
    jid: TJabberID;
    expanded, pass, resource, profile_name, config, xmpp_file, xmpp_uri : String;
    prof_index: integer;

    cli_priority: integer;
    cli_show: string;
    cli_status: string;

    profile: TJabberProfile;

    // some temps we use
    s, help_msg, tmp_locale: string;

    // stuff for .xmpp
    connect_node: TXMLTag;
    auth_node: TXMLTag;
    node: TXMLTag;

    ws2: THandle;

begin
    // setup all the session stuff, parse cmd line params, etc..
    // Initialize random # generator
    Randomize();

    // Make sure winsock2 is available..
    ws2 := LoadLibrary('WS2_32.DLL');
    if (ws2 = 0) then begin
        MessageDlgW(_(sWinsock2), mtError, [mbOK], 0);
        Result := false;
        exit;
    end;
    FreeLibrary(ws2);
    Randomize();

    // Make sure we ignore some stuff from translations
    TP_GlobalIgnoreClassProperty(TAction, 'Category');
    TP_GlobalIgnoreClassProperty(TControl, 'HelpKeyword');
    TP_GlobalIgnoreClassProperty(TNotebook, 'Pages');
    TP_GlobalIgnoreClassProperty(TControl, 'ImeName');
    TP_GlobalIgnoreClass(TFont);
    TP_GlobalIgnoreClass(TExRichEdit);

    // init the cmd line stuff
    cli_priority := -1;
    // SLK:  Why would we init the status?
    //cli_status := _('Available');
    cli_show := '';
    jid := nil;
    invisible := false;
    show_help := false;
    regdll := false;
    log_debug := false;

    ExStartup := TExStartParams.Create();

    // Hide the application's window, and set our own
    // window to the proper parameters..
    ShowWindow(Application.Handle, SW_HIDE);
    SetWindowLong(Application.Handle, GWL_EXSTYLE,
        GetWindowLong(Application.Handle, GWL_EXSTYLE)
        and not WS_EX_APPWINDOW or WS_EX_TOOLWINDOW);
    ShowWindow(Application.Handle, SW_SHOW);

    // Initialize the Riched20.dll stuff
    _richedit := LoadLibrary('Riched20.dll');

    with TGetOpts.Create(nil) do begin
        try
            // -d           : debug
            // -l           : log debug output to file
            // -m           : minimized
            // -v           : invisible
            // -?           : help
            // -0           : DLLRegisterServer
            // -x [yes|no]  : expanded
            // -u [URI]     : XMPP URL
            // -j [jid]     : jid
            // -p [pass]    : password
            // -r [res]     : resource
            // -i [pri]     : priority
            // -f [prof]    : profile name
            // -c [file]    : config file name
            // -embedding   : heh.  win32 will pass this in when we're a COM server and not running yet.
            // -s [status]  : presence status
            // -w [show]    : presence show
            // -t           : show test menu

            Options  := 'dlmva?0xujprifceswot';

            OptFlags := '-------::::::::-:::-';

            ReqFlags := '                    ';

            LongOpts := 'debug,log,minimized,invisible,aatest,help,register,expanded,uri,jid,password,resource,priority,profile,config,embedding,status,show,xmpp,testmenu';
            while GetOpt do begin
                case Ord(OptChar) of
                    0: raise EConfigException.Create(format(_(sUnkArg), [CmdLine()]));
                    Ord('d'): ExStartup.debug := true;
                    Ord('l'): log_debug := true;
                    Ord('x'): expanded := OptArg;
                    Ord('m'): ExStartup.minimized := true;
                    Ord('a'): ExStartup.testaa := true;
                    Ord('v'): invisible := true;
                    Ord('j'): jid := TJabberID.Create(OptArg);
                    Ord('p'): pass := OptArg;
                    Ord('r'): resource := OptArg;
                    Ord('i'): cli_priority := SafeInt(OptArg);
                    Ord('f'): profile_name := OptArg;
                    Ord('c'): config := OptArg;
                    Ord('e'): ;
                    Ord('?'): show_help := true;
                    Ord('0'): regdll := true;
                    Ord('w'): cli_show := OptArg;
                    Ord('s'): cli_status := OptArg;
                    Ord('o'): xmpp_file := OptArg;
                    Ord('t'): ExStartup.test_menu := true;
                    Ord('u'): xmpp_uri := OptArg;
                end;
            end;
        finally
            Free();
        end;
    end;

    if (regdll) then begin
        Result := false;
        exit;
    end;

    if (show_help) then begin
        // show the help message
        help_msg := _(sCommandLine);
        help_msg := help_msg + _(sCmdDebug);
        help_msg := help_msg + _(sCmdFileLog);
        help_msg := help_msg + _(sCmdMinimized);
        help_msg := help_msg + _(sCmdInvisible);
        help_msg := help_msg + _(sCmdHelp);
        help_msg := help_msg + _(sCmdExpanded);
        help_msg := help_msg + _(sCmdJID);
        help_msg := help_msg + _(sCmdPassword);
        help_msg := help_msg + _(sCmdResource);
        help_msg := help_msg + _(sCmdPriority);
        help_msg := help_msg + _(sCmdProfile);
        help_msg := help_msg + _(sCmdConfig);
        help_msg := help_msg + _(sCmdXMPP);
        MessageDlgW(help_msg, mtInformation, [mbOK], 0);
        Result := false;
        exit;
    end;

    // if no config was specified, grab the default
    if (config = '') then
        config := getUserDir() + getAppInfo().ID + '.xml';

    // Create our main Session object
    MainSession := TJabberSession.Create(config);

    // Get our over-riding locale..
    // Normally, the GNUGetText stuff will try to find
    // a subdir which matches our Win32 specified locale.
    // This is used if someone wants to over-ride that.
    tmp_locale := MainSession.Prefs.getString('locale');
    if (Lowercase(tmp_locale) = 'default') then begin
        // Save current lang
        tmp_locale := GetCurrentLanguage();
        if (Pos('en', tmp_locale) = 1) then
            tmp_locale := 'en';
        MainSession.Prefs.setString('locale', tmp_locale);
    end
    else if (tmp_locale <> '') then begin
        UseLanguage(tmp_locale);
    end;

    // Check for a single instance
    if (MainSession.Prefs.getBool('single_instance')) then begin
        _mutex := CreateMutex(nil, true, PChar(getAppInfo().ID +
            ExtractFileName(config)));
        if (_mutex <> 0) and (GetLastError = 0) then begin
            // we are good to go..
        end
        else begin
            // We are not good to go..
            // Send the Windows Msg, and bail.
            PostMessage(HWND_BROADCAST, sExodusMutex, 0, 0);
            Result := false;
            exit;
        end;
    end;

    // COM Controller
    ExRegController := TRegController.Create();
    ExRegController.SetSession(MainSession);

    // GUI builder for Exodus <--> JOPL bridge
    _guibuilder := TGUIFactory.Create();
    _guibuilder.SetSession(MainSession);

    // Notification singlton
    _Notify := TNotifyController.Create;
    _Notify.SetSession(MainSession);

    // S10N controller singleton
    _subcontroller := TSubController.Create();

    // if they didn't specify debug mod, grab it from the prefs
    if not ExStartup.debug then
        ExStartup.debug := MainSession.Prefs.getBool('debug');

    // if they didn't specify minimized mode, grab it from the prefs
    if not ExStartup.minimized then
        ExStartup.minimized := MainSession.Prefs.getBool('min_start');

    // if they didn't specify expanded mode, grab it from the prefs
    if (expanded <> '') then
        MainSession.Prefs.SetBool('expanded', (expanded = 'yes'));

    with MainSession.Prefs do begin
        s := GetString('brand_icon');
        if (s <> '') then begin
            // we either have an absolute or relative path
            if (FileExists(s)) then
                Application.Icon.LoadFromFile(s)
            else begin
                s := ExtractFilePath(Application.EXEName) + s;
                if (FileExists(s)) then
                    Application.Icon.LoadFromFile(s);
            end;
        end;

        connect_node := nil;
        if (xmpp_uri <> '') then begin
            ParseURI(xmpp_uri, connect_node, jid);
        end
        else if (xmpp_file <> '') then begin
            if (not FileExists(xmpp_file)) then
                MessageDlgW(_('Missing file:') + xmpp_file, mtWarning, [mbOK], 0);
            connect_node := nil;
            jid := nil;
            ParseXMPPFile(xmpp_file, connect_node, jid);
        end;

        // if a profile name was specified, use it.
        // otherwise, if a jid was specified, use it as the profile name.
        // otherwise, if we have no profiles yet, use the default profile name.
        if (connect_node <> nil) then begin
            profile_name := WideFormat(sXMPP_Profile, [jid.GetDisplayJID()]);
            profile := CreateProfile(profile_name);
            profile.temp := true;
        end
        else begin
            if (profile_name = '') then begin
                if (jid <> nil) then
                    profile_name := jid.GetDisplayJID()
                else if (Profiles.Count = 0) then
                    profile_name := _(sDefaultProfile);
            end;
        end;

        // if a profile was specified, use it, or create it if it doesn't exist.
        if (profile_name <> '') then begin
            prof_index := Profiles.IndexOf(profile_name);

            if (prof_index = -1) then
                profile := CreateProfile(profile_name)
            else
                profile := TJabberProfile(Profiles.Objects[prof_index]);

            if (jid <> nil) then begin
                profile.Username := jid.user;
                profile.Server := jid.domain;
            end;

            if (resource <> '') then
                profile.Resource := resource;
            if (cli_priority <> -1) then
                profile.Priority := cli_priority;
            if (pass <> '') then
                profile.password := pass;

            if (connect_node <> nil) then begin
                s := connect_node.GetBasicText('ip');
                if (s <> '') then
                    profile.Host := s;
                if (connect_node.GetFirstTag('ssl') <> nil) then
                    profile.ssl := ssl_port;
                s := connect_node.GetBasicText('port');
                if (s <> '') then
                    profile.Port := SafeInt(s);

                auth_node := connect_node.GetFirstTag('authenticate');
                if (auth_node <> nil) then begin
                    node := auth_node.GetFirstTag('username');
                    if (node <> nil) then begin
                        profile.Username := node.Data;
                        auth_node.RemoveTag(node);
                    end;

                    node := auth_node.GetFirstTag('password');
                    if (node <> nil) then begin
                        profile.password := node.Data;
                        auth_node.RemoveTag(node);
                    end;

                    node := auth_node.GetFirstTag('resource');
                    if (node <> nil) then begin
                        profile.Resource := node.Data;
                        auth_node.RemoveTag(node);
                    end;

                    {
                    // XXX: deal with tokenauth somehow?
                    node := auth_node.GetFirstTag('tokenauth');
                    if (node <> nil) then
                        _auth.TokenAuth := node;
                    }
                end;

                prof_index := Profiles.IndexOfObject(profile);
                setInt('profile_active', prof_index);
                ExStartup.auto_login := true;
            end
            else begin
                SaveProfiles();
                prof_index := Profiles.IndexOfObject(profile);

                if (profile.IsValid()) then begin
                    setInt('profile_active', prof_index);
                    ExStartup.auto_login := true;
                end
                else begin
                    if (not IsPositiveResult(ShowConnDetails(profile))) then begin
                    //MainSession.ActivateProfile(prof_index);
                    //XXX: if (not IsPositiveResult(ShowNewUserWizard())) then begin
                        result := false;
                        exit;
                    end;
                end;
            end;
        end
        else begin
            prof_index := getInt('profile_active');
            if ((prof_index < 0) or (prof_index >= Profiles.Count)) then
                prof_index := 0;
            ExStartup.auto_login := getBool('autologin');
        end;

        // assign the profile we want and setup invisible
        MainSession.ActivateProfile(prof_index);
        MainSession.Invisible := invisible;
    end;

    // Initialize the global responders/xpath events
    initResponders();

    if (log_debug) then begin
        StartDebugLogger(ChangeFileExt(config, '.log'));
    end;

    // if we don't have sound registry settings, then add them
    // sigh.  If we had an installer, that would be the place to
    // do this.
    {** JJf moved to installer
    try
        reg := TRegistry.Create();
        reg.RootKey := HKEY_CURRENT_USER;
        reg.OpenKey('\AppEvents\Schemes\Apps\' + getAppInfo().ID , true);
        reg.WriteString('', getAppInfo().ID);
        AddSound(reg, 'notify_chatactivity', _(sSoundChatactivity));
        AddSound(reg, 'notify_invite', _(sSoundInvite));
        AddSound(reg, 'notify_keyword', _(sSoundKeyword));
        AddSound(reg, 'notify_newchat', _(sSoundNewchat));
        AddSound(reg, 'notify_normalmsg', _(sSoundNormalmsg));
        AddSound(reg, 'notify_offline', _(sSoundOffline));
        AddSound(reg, 'notify_online', _(sSoundOnline));
        AddSound(reg, 'notify_roomactivity', _(sSoundRoomactivity));
        AddSound(reg, 'notify_s10n', _(sSoundS10n));
        AddSound(reg, 'notify_oob', _(sSoundOOB));
        AddSound(reg, 'notify_autoresponse', _(sSoundAutoResponse));
        reg.CloseKey();
    except
        // do nothing... just silently ignore
    end;
    **}
    // create COM interfaces for plugins to use
    ExCOMController := TExodusController.Create();
    ExCOMRoster := TExodusRoster.Create();
    ExCOMPPDB := TExodusPPDB.Create();
    ExCOMRosterImages := TExodusRosterImages.Create();
    ExCOMEntityCache := TExodusEntityCache.Create();
    ExCOMToolbar := TExodusToolbar.Create();

    // Setup the ExStartup object props
    ExStartup.priority := cli_priority;
    ExStartup.show := cli_show;
    ExStartup.status := cli_status;
    ExStartup.ssl_ok := checkSSL();

    // Setup our avatar cache
    Avatars.setSession(MainSession);

    Result := true;
end;

{---------------------------------------}
procedure ParseURI(uri: string; var connect_node: TXMLTag; var jid: TJabberID);
var
    target: TJabberID;
    tag: TXMLTag;
    querytype: string;
    pairs: string;
begin
    querytype := '';

   DebugMsg('Got URI: ' + uri);

    if uri_regex.Exec(uri) then begin
        // iauthxmpp  2@3
        // ipathxmpp  6@7/9
        // iquerytype 11
        // ipair      12
        // ifragment  14

        if (uri_regex.Match[2] <> '') and (uri_regex.Match[3] <> '') then begin
            jid := TJabberID.Create(percentDecode(xmpp_nodeprep(uri_regex.Match[2])),
                                                  xmpp_nameprep(uri_regex.Match[3]),
                                                  '');
            connect_node := TXMLTag.Create('connect');
        end;

        if uri_regex.Match[6] = '' then exit;

        // Note: stringprep will be applied later.
        // This is just to ensure structure is correct.
        target := TJabberID.Create(percentDecode(uri_regex.Match[6]),
                                   uri_regex.Match[7],
                                   percentDecode(uri_regex.Match[9]));
        querytype := percentDecode(uri_regex.Match[11]);
        pairs := uri_regex.Match[12];

        if querytype = '' then querytype := 'message';  // I guess.
    end
    else if im_regex.Exec(uri) then begin
        target := TJabberID.Create(xmpp_nodeprep(percentDecode(im_regex.Match[2], true)),
                                   xmpp_nameprep(im_regex.Match[3]),
                                   '');
        if im_regex.Match[1] = 'im' then
            querytype := 'message'
        else if im_regex.Match[1] = 'pres' then
            querytype := 'subscribe'
        else
            exit;
    end
    else
        exit;

    tag := TXMLTag.Create(querytype);

    if tag <> nil then begin
        if pairs <> '' then begin
            if pair_regex.Exec(pairs) then begin
                tag.AddBasicTag(pair_regex.Match[1], percentDecode(pair_regex.Match[2]));
                while (pair_regex.ExecNext) do begin
                    tag.AddBasicTag(pair_regex.Match[1], percentDecode(pair_regex.Match[2]));
                end;
            end;
        end;

        tag.setAttribute('jid', target.full);
        _xmpp_action_list.Add(tag);
    end;
end;

{---------------------------------------}
procedure ParseXMPPFile(filename: string; var connect_node: TXMLTag;
    var jid: TJabberID);
var
    parser: TXMLTagParser;
    xmpp_children: TXMLTagList;
    xmpp_node, node: TXMLTag;
    i: integer;
begin
    if (not FileExists(filename)) then exit;

    parser := TXMLTagParser.Create;
    parser.ParseFile(filename);

    if (parser.Count > 0) then begin
        xmpp_node := parser.popTag();

        ClearXMPPActions();
        xmpp_children := xmpp_node.ChildTags;
        for i := 0 to xmpp_children.Count - 1 do begin
            node := xmpp_children.Tags[i];
            if (node.Name = 'delete') then
                SysUtils.DeleteFile(filename)  // ignore return, on purpose.
            else if (node.Name = 'connect') then begin
                connect_node := TXMLTag.Create(node);
                jid := TJabberID.Create(connect_node.GetBasicText('host'));
            end
            else
                _xmpp_action_list.Add(TXMLTag.Create(node));
        end;
        xmpp_children.Free();
        xmpp_node.Free();
    end;

    parser.Free();

end;

{---------------------------------------}
{---------------------------------------}
function checkSSL(): boolean;
var
    c, s: THandle;
begin
    c := LoadLibrary('libeay32.dll');
    s := LoadLibrary('ssleay32.dll');

    Result := ((c > 0) and (s > 0));

    FreeLibrary(c);
    FreeLibrary(s);
end;

{---------------------------------------}
{---------------------------------------}
procedure AddSound(reg: TRegistry; pref_name: string; user_text: string);
begin
    // Add a new sound entry into the registry
    reg.CreateKey('\AppEvents\Schemes\Apps\' + getAppInfo().ID + '\' + UpperCase(getAppInfo().ID) + '_' + pref_name);
    reg.OpenKey('\AppEvents\EventLabels\' + UpperCase(getAppInfo().ID) + '_' + pref_name, true);
    reg.WriteString('', user_text);
end;

{---------------------------------------}
{---------------------------------------}
function CmdLine(): string;
var
    i : integer;
begin
    result := '';
    for i := 0 to ParamCount do
        result := result + ' ' + ParamStr(i);
end;

{---------------------------------------}
{---------------------------------------}
procedure TeardownSession();
begin
    // free all of the stuff we created
    // kill all of the auto-responders..
    OutputDebugString('TeardownSession');
    cleanupResponders();
    StopDebugLogger();

    // Free the Richedit library
    if (_richedit <> 0) then begin
        FreeLibrary(_richedit);
        _richedit := 0;
    end;

    // If we have a session, close it up
    // and all of the associated windows
    if MainSession <> nil then begin
        _notify.Free();
        _guiBuilder.Free();
        ExRegController.Free();
        _SubController.Free();
        MainSession.Free();
        MainSession := nil;
    end;

    if (_mutex <> 0) then begin
        CloseHandle(_mutex);
        _mutex := 0;
    end;

    if (ExStartup <> nil) then          FreeAndNil(ExStartup);
    if (ExCOMToolbar <> nil) then       FreeAndNil(ExCOMToolbar);
    if (ExCOMRoster <> nil) then        FreeAndNil(ExCOMRoster);
    if (ExCOMPPDB <> nil) then          FreeAndNil(ExCOMPPDB);
    if (ExCOMRosterImages <> nil) then  FreeAndNil(ExCOMRosterImages);
    if (ExCOMEntityCache <> nil) then   FreeAndNil(ExCOMEntityCache);
    if (ExCOMController <> nil) then    FreeAndNil(ExCOMController);

end;

{---------------------------------------}
{---------------------------------------}
procedure PlayXMPPActions();
var
    i,k : integer;
    node: TXMLTag;
    j, tmp: WideString;
    jid: TJabberID;
    msgRcv: TfrmMsgRecv;
    chatWin: TfrmChat;
    tags: TXMLTagList;
    jids: TWideStringList;
begin
    if _xmpp_action_list.Count > 0 then begin
        SetWindowPos(frmExodus.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE);
        BringWindowToTop(frmExodus.Handle);
    end;

    for i := 0 to _xmpp_action_list.Count - 1 do begin
        node := TXMLTag(_xmpp_action_list[i]);
        j := node.GetAttribute('jid');
        if j = '' then
            continue;
        jid := TJabberID.Create(j);

        if (node.Name = 'message') then begin
            if node.GetBasicText('type') = 'normal' then begin
                msgRcv := StartMsg(jid.full);
                tmp := node.GetBasicText('subject');
                msgRcv.txtSendSubject.Text := Tnt_WideStringReplace(tmp, '&', '&&', [rfReplaceAll, rfIgnoreCase]);
                msgRcv.txtMsg.Text := node.GetBasicText('body');
            end
            else begin
                chatWin := StartChat(jid.jid, jid.resource, true);
                chatWin.MsgOut.Text := node.GetBasicText('body');
            end;
        end
        else if (node.Name = 'chat') then begin
            chatWin := StartChat(jid.jid, jid.resource, true);
            chatWin.MsgOut.Text := node.GetBasicText('body');
        end
        else if (node.Name = 'join') then begin
            StartRoom(jid.jid, jid.resource, node.GetBasicText('password'), True, True);
        end
        else if (node.Name = 'invite') then begin
            StartRoom(jid.jid, jid.resource, node.GetBasicText('password'), True, True);
            tags := node.QueryTags('jid');
            if (tags.Count > 0) then begin
                jids := TWideStringList.Create();
                for k := 0 to tags.Count - 1 do
                    jids.Add(tags.Tags[k].Data);
                ShowInvite(jid.jid, jids);
                jids.Free();
            end;
            tags.Free();
        end
        else if (node.Name = 'subscribe') then begin
            ShowAddContact(jid);
        end
        else if (node.Name = 'vcard') then begin
            ShowProfile(jid.jid);
        end
        else if (node.Name = 'register') then begin
            StartServiceReg(jid.full);
        end
        else if (node.Name = 'disco') then begin
            ShowBrowser(jid.full);
        end;

        jid.Free();
        node.Free();
    end;
    _xmpp_action_list.Clear();
end;

{---------------------------------------}
{---------------------------------------}
procedure ClearXMPPActions();
var
    i : integer;
    node: TXMLTag;
begin
    for i := 0 to _xmpp_action_list.Count - 1 do begin
        node := TXMLTag(_xmpp_action_list[i]);
        node.Free();
    end;
    _xmpp_action_list.Clear();
end;

initialization
    //JJF 5/5/06 not sure if registering for EXODUS_ messages will cause
    //problems for branded clients
    //(for instance when Exodus and brand are both running). Ask Joe H.
    sExodusMutex := RegisterWindowMessage('EXODUS_MESSAGE');
    _xmpp_action_list := TList.Create();
    uri_regex := TRegExpr.Create();

    // Test URIs:
    // xmpp:romeo@montague.net?message;subject=Test%20Message;body=Here%27s%20a%20test%20message
    // xmpp://juliet@capulet.net/romeo@montague.net/Home?message;subject=Test%20Message;body=Here%27s%20a%20test%20message
    with uri_regex do begin
        Expression := 'xmpp:' +
                '(//([^@]+)@([^/?#]+)/?)?' +            // iauthxmpp  2@3
                '((([^@]+)@)?([^/?#]+)(/([^?#]+))?)' +  // ipathxmpp  6@7/9
                '(\?([^;#]+)' +                         // iquerytype 11
                '(;[^#]+)?)?' +                         // ipair      12
                '(#(\S+))?';                            // ifragment  14
        Compile();
    end;
    pair_regex := TRegExpr.Create();
    with pair_regex do begin
        Expression := ';([^=]+)=([^;]+)';
        Compile();
    end;
    im_regex := TRegExpr.Create();
    with im_regex do begin
        Expression := '(im|pres):([^@]+)@([^?]+)(\?(\S+))?'; // 1:2@3?4
        Compile();
    end;

finalization
    TeardownSession();

    if (uri_regex <> nil) then
        FreeAndNil(uri_regex);
    if (pair_regex <> nil) then
        FreeAndNil(pair_regex);
    if (im_regex <> nil) then
        FreeAndNil(im_regex);

    ClearXMPPActions();
    _xmpp_action_list.Free();

end.
