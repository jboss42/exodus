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
    Unicode, Signals, XMLTag, Session, GUIFactory, Register, Notify,
    S10n, FileServer,

    // Delphi stuff
    Classes, Dialogs, Forms, SysUtils, Windows;

// forward declares
function SetupSession(): boolean;

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

const
    sExodusMutex: Cardinal;

    ExCOMController: TExodusController;
    ExCOMRoster: TExodusRoster;
    ExCOMPPDB: TExodusPPDB;

implementation

var
    // Various other key controllers
    _guibuilder: TGUIFactory;
    _regController: TRegController;
    _Notify: TNotifyController;
    _subcontroller: TSubController;
    _fileserver: TExodusFileServer;

    _richedit: THandle;
    _mutex: THandle;



function SetupSession(): boolean;
var
    debug, minimized, expanded, testaa, invisible, show_help: boolean;
    show_help: boolean;
    jid: TJabberID;
    pass, resource, profile_name, config, xmpp_file : String;

    cli_priority: integer;
    cli_show: string;
    cli_status: string;

    profile: TJabberProfile;
    reg: TRegistry;

    // some temps we use
    s, help_msg, tmp_locale: string;
    auth: TStandardAuth;

    // stuff for .xmpp
    parser: TXMLTagParser;
    xmpp_node: TXMLTag;
    connect_node: TXMLTag;
    auth_node: TXMLTag;
    node: TXMLTag;

begin
    // setup all the session stuff, parse cmd line params, etc..
    {$ifdef TRACE_EXCEPTIONS}
    // Application.OnException := ApplicationException;
    Include(JclStackTrackingOptions, stRawMode);
    {$endif}

    // init the cmd line stuff
    cli_priority := -1;
    cli_status := sAvailable;
    cli_show := '';

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
                    Ord('d'): debug := true;
                    Ord('x'): expanded := OptArg;
                    Ord('m'): minimized := true;
                    Ord('a'): testaa := true;
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
        mutex := CreateMutex(nil, true, PChar('Exodus' +
            ExtractFileName(config)));
        if (mutex <> 0) and (GetLastError = 0) then begin
            // we are good to go..
        end
        else begin
            // We are not good to go..
            // Send the Windows Msg, and bail.
            PostMessage(HWND_BROADCAST, sExodusMutex, 0, 0);
            Halt;
        end;
    end;

    _guibuilder := TGUIFactory.Create();
    _guibuilder.SetSession(MainSession);

    _regController := TRegController.Create();
    _regController.SetSession(MainSession);

    _Notify := TNotifyController.Create;
    _Notify.SetSession(MainSession);

    _subcontroller := TSubController.Create();
    _fileserver := TExodusFileServer.Create();

    if not debug then
        debug := MainSession.Prefs.getBool('debug');

    if not minimized then
        minimized := MainSession.Prefs.getBool('min_start');

    with MainSession.Prefs do begin
        s := GetString('brand_icon');
        if (s <> '') then
            Application.Icon.LoadFromFile(s);

        connect_node := nil;
        if (xmpp_file <> '') then begin
            parser := TXMLTagParser.Create;
            parser.ParseFile(xmpp_file);
            if (parser.Count > 0) then begin
                xmpp_node := parser.popTag();
                connect_node := xmpp_node.GetFirstTag('connect');
                if (connect_node <> nil) then
                    jid := TJabberID.Create(connect_node.GetBasicText('host'));
            end;
            parser.Free();
        end;

        // if a profile name was specified, use it.
        // otherwise, if a jid was specified, use it as the profile name.
        // otherwise, if we have no profiles yet, use the default profile name.

        // TODO: Let's add a profile.temp flag, and not save it
        // for .xmpp stuff, we'll just spin up a whole new profile then.
        if (connect_node <> nil) then begin
            profile_name := Format(sXMPP_Profile, [jid.jid]);
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
            _prof_index := Profiles.IndexOf(profile_name);

            if (_prof_index = -1) then begin
                // no profile called this, yet
                if (jid = nil) or (pass = '') then begin
                    MessageDlg('You must specify a JID and password to create a new profile',
                        mtError, [mbOK], 0);
                    Result := false;
                    exit;
                end;

                profile := CreateProfile(profile_name);
            end
            else
                profile := TJabberProfile(Profiles.Objects[_prof_index]);

            if (jid <> nil) then begin
                profile.Username := jid.user;
                profile.Server := jid.domain;
            end;

            if (resource <> '') then
                profile.Resource := resource;
            if (_cli_priority <> -1) then
                profile.Priority := _cli_priority;
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
                        MainSession.TokenAuth := node;
                end;

                _prof_index := Profiles.IndexOfObject(profile);
                setInt('profile_active', _prof_index);
                _auto_login := true;
            end
            else begin
                SaveProfiles();
                _prof_index := Profiles.IndexOfObject(profile);

                if (profile.IsValid()) then begin
                    setInt('profile_active', _prof_index);
                    _auto_login := true;
                end;
            end;
        end
        else begin
            _prof_index := getInt('profile_active');
            if ((_prof_index < 0) or (_prof_index >= Profiles.Count)) then
                _prof_index := 0;
            _auto_login := getBool('autologin');
        end;

        MainSession.Invisible := invisible;
    end;

    // Initialize the global responders/xpath events
    initResponders();

    // Setup emoticons
    ConfigEmoticons();

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


procedure TeardownSession();
begin
    // free all of the stuff we created
end;

initialization
    sExodusMutex := RegisterWindowMessage('EXODUS_MESSAGE');

end.
