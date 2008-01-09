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
    COMController, COMRoster, COMPPDB, JabberID,
    Unicode, Signals, XMLTag, Session, GUIFactory, Register, Notify,
    S10n, FileServer,

    // Delphi stuff
    Registry, Classes, Dialogs, Forms, SysUtils, Windows;

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
    end;

procedure PlayXMPPActions();
procedure ClearXMPPActions();
procedure ParseXMPPFile(filename: string; var connect_node: TXMLTag;
    var jid: TJabberID);


// forward declares
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function SetupSession(): boolean;
procedure TeardownSession();

procedure AddSound(reg: TRegistry; pref_name: string; user_text: string);
function CmdLine(): string;

{---------------------------------------}
resourcestring
    sCmdDebug =     ' -d '#9#9' : Debug mode on'#13#10;
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
    sUnkArg = 'Invalid command line:%s';
    sWinsock2 = 'Winsock2 is required for this application. Please obtain the winsock2 installer from Microsoft for your operating system.';

var
    sExodusMutex: Cardinal;

    ExCOMController: TExodusController;
    ExCOMRoster: TExodusRoster;
    ExCOMPPDB: TExodusPPDB;

    ExFileServer: TExodusFileServer;
    ExRegController: TRegController;
    ExStartup: TExStartParams;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$WARN UNIT_PLATFORM OFF}

uses
    ActnList, Graphics, ExtCtrls, ExRichEdit,
    Controls, GnuGetText, ConnDetails, IdWinsock2,
    ChatWin, GetOpt, Jabber1, PrefController, StandardAuth,
    PrefNotify, Room, RosterAdd, MsgRecv, Profile, RegForm,
    ExResponders, MsgDisplay,
    XMLParser, XMLUtils;

var
    // Various other key controllers
    _guibuilder: TGUIFactory;
    _Notify: TNotifyController;
    _subcontroller: TSubController;
    _richedit: THandle;
    _mutex: THandle;
    _xmpp_action_list: TList;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function SetupSession(): boolean;
var
    invisible, show_help: boolean;
    jid: TJabberID;
    expanded, pass, resource, profile_name, config, xmpp_file : String;
    prof_index: integer;

    cli_priority: integer;
    cli_show: string;
    cli_status: string;

    profile: TJabberProfile;
    reg: TRegistry;

    // some temps we use
    s, help_msg, tmp_locale: string;
    auth: TStandardAuth;

    // stuff for .xmpp
    connect_node: TXMLTag;
    auth_node: TXMLTag;
    node: TXMLTag;

    ws2: THandle;

begin
    // setup all the session stuff, parse cmd line params, etc..
    {$ifdef TRACE_EXCEPTIONS}
    // Application.OnException := ApplicationException;
    Include(JclStackTrackingOptions, stRawMode);
    {$endif}

    // Make sure winsock2 is available..
    ws2 := LoadLibrary('WS2_32.DLL');
    if (ws2 = 0) then begin
        MessageDlg(sWinsock2, mtError, [mbOK], 0);
        Result := false;
        exit;
    end;
    FreeLibrary(ws2);

    // Make sure we ignore some stuff from translations
    TP_GlobalIgnoreClassProperty(TAction, 'Category');
    TP_GlobalIgnoreClassProperty(TControl, 'HelpKeyword');
    TP_GlobalIgnoreClassProperty(TNotebook, 'Pages');
    TP_GlobalIgnoreClassProperty(TControl, 'ImeName');
    TP_GlobalIgnoreClass(TFont);
    TP_GlobalIgnoreClass(TExRichEdit);

    // init the cmd line stuff
    cli_priority := -1;
    cli_status := sAvailable;
    cli_show := '';
    jid := nil;
    invisible := false;
    show_help := false;

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
            // -d          : debug
            // -m          : minimized
            // -v          : invisible
            // -?          : help
            // -x [yes|no] : expanded
            // -j [jid]    : jid
            // -p [pass]   : password
            // -r [res]    : resource
            // -i [pri]    : priority
            // -f [prof]   : profile name
            // -c [file]   : config file name
            // -s [status] : presence status
            // -w [show]   : presence show
            Options  := 'dmva?xjprifcswo';
            OptFlags := '-----::::::::::';
            ReqFlags := '               ';
            LongOpts := 'debug,minimized,invisible,aatest,help,expanded,jid,password,resource,priority,profile,config,status,show,xmpp';
            while GetOpt do begin
                case Ord(OptChar) of
                    0: raise EConfigException.Create(format(sUnkArg, [CmdLine()]));
                    Ord('d'): ExStartup.debug := true;
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
                    Ord('?'): show_help := true;
                    Ord('w'): cli_show := OptArg;
                    Ord('s'): cli_status := OptArg;
                    Ord('o'): xmpp_file := OptArg;
                end;
            end;
        finally
            Free();
        end;
    end;

    if (show_help) then begin
        // show the help message
        help_msg := sCommandLine;
        help_msg := help_msg + sCmdDebug;
        help_msg := help_msg + sCmdMinimized;
        help_msg := help_msg + sCmdInvisible;
        help_msg := help_msg + sCmdHelp;
        help_msg := help_msg + sCmdExpanded;
        help_msg := help_msg + sCmdJID;
        help_msg := help_msg + sCmdPassword;
        help_msg := help_msg + sCmdResource;
        help_msg := help_msg + sCmdPriority;
        help_msg := help_msg + sCmdProfile;
        help_msg := help_msg + sCmdConfig;
        MessageDlg(help_msg, mtInformation, [mbOK], 0);
        Result := false;
        exit;
    end;

    if (config = '') then
        config := getUserDir() + 'exodus.xml';

    // Create our main Session object
    MainSession := TJabberSession.Create(config);

    // Get our over-riding locale..
    // Normally, the GNUGetText stuff will try to find
    // a subdir which matches our Win32 specified locale.
    // This is used if someone wants to over-ride that.
    tmp_locale := MainSession.Prefs.getString('locale');
    if (tmp_locale <> '') then begin
        UseLanguage(tmp_locale);
    end;

    // Set our session to use the normal auth agent
    auth := TStandardAuth.Create(MainSession);
    MainSession.setAuthAgent(auth);

    // Check for a single instance
    if (MainSession.Prefs.getBool('single_instance')) then begin
        _mutex := CreateMutex(nil, true, PChar('Exodus' +
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

    ExRegController := TRegController.Create();
    ExRegController.SetSession(MainSession);
    ExFileServer := TExodusFileServer.Create();

    _guibuilder := TGUIFactory.Create();
    _guibuilder.SetSession(MainSession);

    _Notify := TNotifyController.Create;
    _Notify.SetSession(MainSession);

    _subcontroller := TSubController.Create();

    if not ExStartup.debug then
        ExStartup.debug := MainSession.Prefs.getBool('debug');

    if not ExStartup.minimized then
        ExStartup.minimized := MainSession.Prefs.getBool('min_start');

    if (expanded <> '') then
        MainSession.Prefs.SetBool('expanded', (expanded = 'yes'));

    with MainSession.Prefs do begin
        s := GetString('brand_icon');
        if (s <> '') then
            Application.Icon.LoadFromFile(s);

        connect_node := nil;
        if (xmpp_file <> '') then begin
            if (not FileExists(xmpp_file)) then
                MessageDlg('NO file:' + xmpp_file, mtWarning, [mbOK], 0);
            connect_node := nil;
            jid := nil;
            ParseXMPPFile(xmpp_file, connect_node, jid);
        end;

        // if a profile name was specified, use it.
        // otherwise, if a jid was specified, use it as the profile name.
        // otherwise, if we have no profiles yet, use the default profile name.
        if (connect_node <> nil) then begin
            profile_name := Format(sXMPP_Profile, [jid.jid]);
            profile := CreateProfile(profile_name);
            profile.temp := true;
        end
        else begin
            if (profile_name = '') then begin
                if (jid <> nil) then
                    profile_name := jid.jid
                else if (Profiles.Count = 0) then
                    profile_name := sDefaultProfile;
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
                    profile.ssl := true;
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

                    node := auth_node.GetFirstTag('tokenauth');
                    if (node <> nil) then
                        auth.TokenAuth := node;
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

    // if we don't have sound registry settings, then add them
    // sigh.  If we had an installer, that would be the place to
    // do this.
    reg := TRegistry.Create();
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('\AppEvents\Schemes\Apps\Exodus', true);
    reg.WriteString('', sExodus);
    AddSound(reg, 'notify_chatactivity', sSoundChatactivity);
    AddSound(reg, 'notify_invite', sSoundInvite);
    AddSound(reg, 'notify_keyword', sSoundKeyword);
    AddSound(reg, 'notify_newchat', sSoundNewchat);
    AddSound(reg, 'notify_normalmsg', sSoundNormalmsg);
    AddSound(reg, 'notify_offline', sSoundOffline);
    AddSound(reg, 'notify_online', sSoundOnline);
    AddSound(reg, 'notify_roomactivity', sSoundRoomactivity);
    AddSound(reg, 'notify_s10n', sSoundS10n);
    AddSound(reg, 'notify_oob', sSoundOOB);
    AddSound(reg, 'notify_autoresponse', sSoundAutoResponse);
    reg.CloseKey();
    reg.Free();

    // create COM interfaces for plugins to use
    ExCOMController := TExodusController.Create();
    ExCOMRoster := TExodusRoster.Create();
    ExCOMPPDB := TExodusPPDB.Create();

    {$ifdef TRACE_EXCEPTIONS}
    // Start Exception tracking
    JclStartExceptionTracking;
    JclAddExceptNotifier(ExceptionTracker);
    {$endif}

    ExStartup.priority := cli_priority;
    ExStartup.show := cli_show;
    ExStartup.status := cli_status;

    Result := true;

end;

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
procedure AddSound(reg: TRegistry; pref_name: string; user_text: string);
begin
    // Add a new sound entry into the registry
    reg.CreateKey('\AppEvents\Schemes\Apps\Exodus\EXODUS_' + pref_name);
    reg.OpenKey('\AppEvents\EventLabels\EXODUS_' + pref_name, true);
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
    cleanupResponders();

    // Free the Richedit library
    if (_richedit <> 0) then begin
        FreeLibrary(_richedit);
        _richedit := 0;
    end;

    // If we have a session, close it up
    // and all of the associated windows
    if MainSession <> nil then begin
        ExFileserver.Free();
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

    FreeAndNil(ExCOMRoster);
    FreeAndNil(ExCOMPPDB);
    FreeAndNil(ExCOMController);
end;

procedure PlayXMPPActions();
var
    i : integer;
    node: TXMLTag;
    jid: WideString;
    add: TfrmAdd;
    reg: TfrmRegister;
begin
    for i := 0 to _xmpp_action_list.Count - 1 do begin
        node := TXMLTag(_xmpp_action_list[i]);
        jid := node.GetAttribute('jid');
        if (node.Name = 'chat') then begin
            if (jid <> '') then
                StartChat(jid, '', true);
        end
        else if (node.Name = 'groupchat') then begin
            if (jid <> '') then
                StartRoom(jid, MainSession.Username);
        end
        else if (node.Name = 'subscribe') then begin
            if (jid <> '') then begin
                add := TfrmAdd.Create(Application);
                add.cboType.ItemIndex := 0;
                add.txtJID.Text := jid;
                add.Show;
                add.txtNickname.SetFocus();
            end;
        end
        else if (node.Name = 'message') then begin
            if (jid <> '') then begin
                StartMsg(jid);
            end;
        end
        else if (node.Name = 'vcard') then begin
            if (jid <> '') then begin
                ShowProfile(jid);
            end;
        end
        else if (node.Name = 'register') then begin
            if (jid <> '') then begin
                reg := TfrmRegister.Create(Application);
                reg.jid := jid;
                reg.Start();
            end;
        end;

        node.Free();
    end;
    _xmpp_action_list.Clear();
end;

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
    sExodusMutex := RegisterWindowMessage('EXODUS_MESSAGE');
    _xmpp_action_list := TList.Create();

finalization
    ClearXMPPActions();
    _xmpp_action_list.Free();
end.
