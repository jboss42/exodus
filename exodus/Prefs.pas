unit Prefs;
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
    // panels
    PrefPanel, PrefSystem, PrefRoster, PrefSubscription, PrefFont, PrefDialogs,
    PrefMsg, PrefNotify,   

    // other stuff
    Menus, ShellAPI, Unicode,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
    ComCtrls, StdCtrls, ExtCtrls, buttonFrame, CheckLst,
    ExRichEdit, Dialogs, RichEdit2, TntStdCtrls, TntComCtrls;

type
  TfrmPrefs = class(TForm)
    ScrollBox1: TScrollBox;
    imgDialog: TImage;
    lblDialog: TLabel;
    imgFonts: TImage;
    lblFonts: TLabel;
    imgS10n: TImage;
    lblS10n: TLabel;
    imgRoster: TImage;
    lblRoster: TLabel;
    PageControl1: TPageControl;
    ColorDialog1: TColorDialog;
    imgSystem: TImage;
    lblSystem: TLabel;
    imgNotify: TImage;
    lblNotify: TLabel;
    imgAway: TImage;
    lblAway: TLabel;
    tbsAway: TTabSheet;
    chkAutoAway: TCheckBox;
    StaticText7: TStaticText;
    txtAwayTime: TEdit;
    spnAway: TUpDown;
    Label2: TLabel;
    txtXATime: TEdit;
    spnXA: TUpDown;
    Label3: TLabel;
    Label4: TLabel;
    txtAway: TEdit;
    txtXA: TEdit;
    Label9: TLabel;
    tbsKeywords: TTabSheet;
    StaticText8: TStaticText;
    memKeywords: TTntMemo;
    tbsBlockList: TTabSheet;
    StaticText9: TStaticText;
    Label10: TLabel;
    memBlocks: TTntMemo;
    imgKeywords: TImage;
    lblKeywords: TLabel;
    imgBlockList: TImage;
    lblBlockList: TLabel;
    tbsCustomPres: TTabSheet;
    lstCustomPres: TListBox;
    StaticText10: TStaticText;
    pnlCustomPresButtons: TPanel;
    btnCustomPresAdd: TButton;
    btnCustomPresRemove: TButton;
    btnCustomPresClear: TButton;
    GroupBox1: TGroupBox;
    Label11: TLabel;
    txtCPTitle: TEdit;
    Label12: TLabel;
    txtCPStatus: TEdit;
    Label13: TLabel;
    cboCPType: TComboBox;
    txtCPPriority: TEdit;
    spnPriority: TUpDown;
    Label14: TLabel;
    lblHotkey: TLabel;
    txtCPHotkey: THotKey;
    imgCustompres: TImage;
    lblCustomPres: TLabel;
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel3: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Button6: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    chkRegex: TCheckBox;
    imgMessages: TImage;
    lblMessages: TLabel;
    chkPresenceMessageListen: TCheckBox;
    chkPresenceMessageSend: TCheckBox;
    tbsPlugins: TTabSheet;
    StaticText12: TStaticText;
    imgPlugins: TImage;
    lblPlugins: TLabel;
    Label8: TLabel;
    cboPresTracking: TComboBox;
    chkAAReducePri: TCheckBox;
    btnAddPlugin: TButton;
    btnConfigPlugin: TButton;
    btnRemovePlugin: TButton;
    Label6: TLabel;
    txtPluginDir: TEdit;
    btnBrowsePluginPath: TButton;
    lstPlugins: TTntListView;
    lblPluginScan: TLabel;
    imgNetwork: TImage;
    lblNetwork: TLabel;
    tbsNetwork: TTabSheet;
    GroupBox2: TGroupBox;
    lblProxyHost: TLabel;
    lblProxyPort: TLabel;
    lblProxyUsername: TLabel;
    lblProxyPassword: TLabel;
    Label28: TLabel;
    txtProxyHost: TEdit;
    txtProxyPort: TEdit;
    chkProxyAuth: TCheckBox;
    txtProxyUsername: TEdit;
    txtProxyPassword: TEdit;
    cboProxyApproach: TComboBox;
    StaticText13: TStaticText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TabSelect(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    //procedure chkNotifyClick(Sender: TObject);
    //procedure chkToastClick(Sender: TObject);
    //procedure Label20Click(Sender: TObject);
    procedure lstCustomPresClick(Sender: TObject);
    procedure txtCPTitleChange(Sender: TObject);
    procedure btnCustomPresAddClick(Sender: TObject);
    procedure btnCustomPresRemoveClick(Sender: TObject);
    procedure btnCustomPresClearClick(Sender: TObject);
    procedure btnBrowsePluginPathClick(Sender: TObject);
    procedure lblPluginScanClick(Sender: TObject);
    procedure btnConfigPluginClick(Sender: TObject);
    procedure cboProxyApproachChange(Sender: TObject);
    procedure chkProxyAuthClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    _no_pres_change: boolean;
    _pres_list: TList;

    _cur_panel: TfrmPrefPanel;
    _system: TfrmPrefSystem;
    _roster: TfrmPrefRoster;
    _subscription: TfrmPrefSubscription;
    _font: TfrmPrefFont;
    _dialogs: TfrmPrefDialogs;
    _message: TfrmPrefMsg;
    _notify: TfrmPrefNotify;
    
    // procedure redrawChat();
    procedure clearPresList();

    procedure loadPlugins();
    procedure savePlugins();
    procedure scanPluginDir(selected: TWidestringList);
    procedure CheckPluginDll(dll : WideString; selected: TWidestringlist);

  public
    { Public declarations }
    procedure LoadPrefs;
    procedure SavePrefs;
  end;

var
  frmPrefs: TfrmPrefs;

resourcestring
    sPrefsDfltPres = 'Untitled Presence';
    sPrefsClearPres = 'Clear all custom presence entries?';

procedure StartPrefs;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.DFM}
{$WARN UNIT_PLATFORM OFF}

uses
    ActiveX, ComObj,
    AutoUpdate,
    ExUtils, ExodusCOM_TLB, COMController,
    FileCtrl, XMLUtils, PathSelector,
    Presence, MsgDisplay, JabberMsg, Jabber1,
    PrefController, Registry, Session;

{---------------------------------------}
procedure StartPrefs;
var
    f: TfrmPrefs;
begin
    f := TfrmPrefs.Create(Application);
    f.LoadPrefs;
    // frmExodus.PreModal(f);
    f.ShowModal;
    //frmExodus.PostModal();
    f.Free();
end;

{---------------------------------------}
procedure TfrmPrefs.LoadPrefs;
var
    i: integer;
    dir: Widestring;
begin
    // load prefs from the reg.
    with MainSession.Prefs do begin

        // Notify Options
        {
        SetLength(_notify, NUM_NOTIFIES);

        chkSound.Checked := getBool('notify_sounds');
        chkNotifyActive.Checked := getBool('notify_active');
        chkNotifyActiveWindow.Checked := getBool('notify_active_win');
        chkFlashInfinite.Checked := getBool('notify_flasher');
        _notify[0]  := getInt('notify_online');
        _notify[1]  := getInt('notify_offline');
        _notify[2]  := getInt('notify_newchat');
        _notify[3]  := getInt('notify_normalmsg');
        _notify[4]  := getInt('notify_s10n');
        _notify[5]  := getInt('notify_invite');
        _notify[6]  := getInt('notify_keyword');
        _notify[7]  := getInt('notify_chatactivity');
        _notify[8]  := getInt('notify_roomactivity');
        _notify[9]  := getInt('notify_oob');
        _notify[10] := getInt('notify_autoresponse');

        optNotify.Enabled;
        chkToast.Checked := false;
        chkFlash.Checked := false;
        chkTrayNotify.Checked := false;

        for i := 0 to NUM_NOTIFIES - 1 do
            chkNotify.Checked[i] := (_notify[i] > 0);

        chkNotify.ItemIndex := 0;
        chkNotifyClick(Self);
        }

        // Autoaway options
        chkAutoAway.Checked := getBool('auto_away');
        chkAAReducePri.Checked := getBool('aa_reduce_pri');
        spnAway.Position := getInt('away_time');
        spnXA.Position := getInt('xa_time');
        txtAway.Text := getString('away_status');
        txtXA.Text := getString('xa_status');

        // Keywords and Blockers
        fillStringList('keywords', memKeywords.Lines);
        chkRegex.Checked := getBool('regex_keywords');
        fillStringList('blockers', memBlocks.Lines);

        // Network config
        cboProxyApproach.ItemIndex := getInt('http_proxy_approach');
        cboProxyApproachChange(cboProxyApproach);
        txtProxyHost.Text := getString('http_proxy_host');
        txtProxyPort.Text := getString('http_proxy_port');
        chkProxyAuth.Checked := getBool('http_proxy_auth');
        chkProxyAuthClick(chkProxyAuth);
        txtProxyUsername.Text := getString('http_proxy_user');
        txtProxyPassword.Text := getString('http_proxy_password');

        // plugins
        dir := getString('plugin_dir');
        if (dir = '') then
            dir := ExtractFilePath(Application.ExeName) + 'plugins';

        if (not DirectoryExists(dir)) then
            dir := ExtractFilePath(Application.ExeName) + 'plugins';

        txtPluginDir.Text := dir;
        loadPlugins();

        // Custom Presence options
        _pres_list := getAllPresence();
        for i := 0 to _pres_list.Count - 1 do
            lstCustomPres.Items.Add(TJabberCustomPres(_pres_list[i]).title);
        cboPresTracking.ItemIndex := getInt('pres_tracking');
        chkPresenceMessageSend.Checked := getBool('presence_message_send');
        chkPresenceMessageListen.Checked := getBool('presence_message_listen');
    end;
end;

{---------------------------------------}
procedure TfrmPrefs.loadPlugins();
var
    sl: TWidestringList;
begin
    // load the listview
    lstPlugins.Clear();

    // get the list of selected plugins..
    sl := TWidestringList.Create();
    MainSession.Prefs.fillStringlist('plugin_selected', sl);

    // Scan the director
    scanPluginDir(sl);

    with lstPlugins do begin
        btnConfigPlugin.Enabled := (Items.Count > 0);
        btnRemovePlugin.Enabled := (Items.Count > 0);
    end;

    sl.Free();
end;

{---------------------------------------}
procedure TfrmPrefs.savePlugins();
var
    i: integer;
    item: TTntListItem;
    sl: TWidestringlist;
begin
    // save all "checked" captions
    sl := TWidestringlist.Create();

    for i := 0 to lstPlugins.Items.Count - 1 do begin
        item := lstPlugins.Items[i];
        if (item.Checked) then begin
            // save the Classname
            sl.Add(item.Caption);
        end;
    end;

    MainSession.Prefs.setStringlist('plugin_selected', sl);
    ReloadPlugins(sl);
    sl.Free();
end;

{---------------------------------------}
procedure TfrmPrefs.scanPluginDir(selected: TWidestringList);
var
    dir: Widestring;
    sr: TSearchRec;
begin
    dir := txtPluginDir.Text;
    if (not DirectoryExists(dir)) then exit;
    if (FindFirst(dir + '\\*.dll', faAnyFile, sr) = 0) then begin
        repeat
            CheckPluginDll(dir + '\' + sr.Name, selected);
        until FindNext(sr) <> 0;
        FindClose(sr);
    end;
end;

{---------------------------------------}
procedure TfrmPrefs.CheckPluginDll(dll : WideString; selected: TWidestringList);
var
    lib : ITypeLib;
    idx, i, j : integer;
    item: TTntListItem;
    tinfo, iface : ITypeInfo;
    tattr, iattr: PTypeAttr;
    r: cardinal;
    libname, obname, doc: WideString;
begin
    // load the .dll.  This SHOULD register the bloody thing if it's not, but that
    // doesn't seem to work for me.
    OleCheck(LoadTypeLibEx(pwidechar(dll), REGKIND_REGISTER, lib));
    // get the project name
    OleCheck(lib.GetDocumentation(-1, @libname, nil, nil, nil));

    // for each type in the project
    for i := 0 to lib.GetTypeInfoCount() - 1 do begin
        // get the info about the type
        OleCheck(lib.GetTypeInfo(i, tinfo));

        // get attributes of the type
        OleCheck(tinfo.GetTypeAttr(tattr));
        // is this a coclass?
        if (tattr.typekind <> TKIND_COCLASS) then continue;

        // for each interface that the coclass implements
        for j := 0 to tattr.cImplTypes - 1 do begin
            // get the type info for the interface
            OleCheck(tinfo.GetRefTypeOfImplType(j, r));
            OleCheck(tinfo.GetRefTypeInfo(r, iface));

            // get the attributes of the interface
            OleCheck(iface.GetTypeAttr(iattr));

            // is this the IExodusPlugin interface?
            if  (IsEqualGUID(iattr.guid, ExodusCOM_TLB.IID_IExodusPlugin)) then begin
                // oho!  it IS.  Get the name of this coclass, so we can show
                // what we did.  Get the doc string, just to show off.
                OleCheck(tinfo.GetDocumentation(-1, @obname, @doc, nil, nil));
                // SysFreeString of obname and doc needed?  In C, yes, but here?

                item := lstPlugins.Items.Add();
                item.Caption := libname + '.' + obname;
                item.SubItems.Add(doc);
                item.SubItems.Add(dll);

                // check to see if this is selected
                idx := selected.IndexOf(item.Caption);
                item.Checked := (idx >= 0);

                // let her rip!!
                // OleCheck(tinfo.CreateInstance(nil, ExodusCOM_TLB.IID_IExodusPlugin, ep));
            end;
            iface.ReleaseTypeAttr(iattr);
            //iface._Release(); // crash
        end;
        tinfo.ReleaseTypeAttr(tattr);
        //tinfo._Release();
    end;
    // lib._Release(); // crash
end;

{---------------------------------------}
procedure TfrmPrefs.SavePrefs;
var
    i: integer;
    cp: TJabberCustomPres;
begin
    // save prefs to the reg
    with MainSession.Prefs do begin
        BeginUpdate();

        // Iterate over all the panels we have
        if (_roster <> nil) then
            _roster.SavePrefs();

        if (_system <> nil) then
            _system.SavePrefs();

        if (_subscription <> nil) then
            _system.SavePrefs();

        if (_font <> nil) then
            _font.SavePrefs();

        if (_dialogs <> nil) then
            _dialogs.SavePrefs();

        if (_message <> nil) then
            _message.SavePrefs();

        if (_notify <> nil) then
            _notify.SavePrefs();

        // Notify events
        {
        setBool('notify_sounds', chkSound.Checked);
        setBool('notify_active', chkNotifyActive.Checked);
        setBool('notify_active_win', chkNotifyActiveWindow.Checked);
        setBool('notify_flasher', chkFlashInfinite.Checked);

        setInt('notify_online', _notify[0]);
        setInt('notify_offline', _notify[1]);
        setInt('notify_newchat', _notify[2]);
        setInt('notify_normalmsg', _notify[3]);
        setInt('notify_s10n', _notify[4]);
        setInt('notify_invite', _notify[5]);
        setInt('notify_keyword', _notify[6]);
        setInt('notify_chatactivity', _notify[7]);
        setInt('notify_roomactivity', _notify[8]);
        setInt('notify_oob', _notify[9]);
        setInt('notify_autoresponse', _notify[10]);
        }

        // Autoaway options
        setBool('auto_away', chkAutoAway.Checked);
        setBool('aa_reduce_pri', chkAAReducePri.Checked);
        setInt('away_time', spnAway.Position);
        setInt('xa_time', spnXA.Position);
        setString('away_status', txtAway.Text);
        setString('xa_status', txtXA.Text);

        // Keywords
        setStringList('keywords', memKeywords.Lines);
        setBool('regex_keywords', chkRegex.Checked);
        setStringList('blockers', memBlocks.Lines);

        // Network
        setInt('http_proxy_approach', cboProxyApproach.ItemIndex);
        setString('http_proxy_host', txtProxyHost.Text);
        setInt('http_proxy_port', StrToIntDef(txtProxyPort.Text, 0));
        setBool('http_proxy_auth', chkProxyAuth.Checked);
        setString('http_proxy_user', txtProxyUsername.Text);
        setString('http_proxy_password', txtProxyPassword.Text);

        // Plugins
        setString('plugin_dir', txtPluginDir.Text);
        savePlugins();

        // Custom presence list
        RemoveAllPresence();
        for i := 0 to _pres_list.Count - 1 do begin
            cp := TJabberCustomPres(_pres_list.Items[i]);
            setPresence(cp);
        end;
        setInt('pres_tracking', cboPresTracking.ItemIndex);
        setBool('presence_message_send', chkPresenceMessageSend.Checked);
        setBool('presence_message_listen', chkPresenceMessageListen.Checked);

    endUpdate();
    end;
    MainSession.FireEvent('/session/prefs', nil);
end;

{---------------------------------------}
procedure TfrmPrefs.clearPresList();
var
    i: integer;
begin
    for i := 0 to _pres_list.Count - 1 do
        TJabberCustomPres(_pres_list[i]).Free();
    _pres_list.Clear();
end;

{---------------------------------------}
procedure TfrmPrefs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    clearPresList();
    _pres_list.Free();
    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmPrefs.FormCreate(Sender: TObject);
begin
    //tbsRoster.TabVisible := false;
    //tbsSubscriptions.TabVisible := false;
    //tbsFonts.TabVisible := false;
    //tbsSystem.TabVisible := false;
    //tbsDialog.TabVisible := false;
    //tbsMessages.TabVisible := false;
    //tbsNotify.TabVisible := false;
    tbsAway.TabVisible := false;
    tbsKeywords.TabVisible := false;
    tbsBlockList.TabVisible := false;
    tbsCustomPres.TabVisible := false;
    tbsNetwork.TabVisible := false;
    tbsPlugins.TabVisible := false;

    // note these are already pre-populated, so no leaks
    {
    chkNotify.Items.Strings[0]  := sSoundOnline;
    chkNotify.Items.Strings[1]  := sSoundOffline;
    chkNotify.Items.Strings[2]  := sSoundNewchat;
    chkNotify.Items.Strings[3]  := sSoundNormalmsg;
    chkNotify.Items.Strings[4]  := sSoundS10n;
    chkNotify.Items.Strings[5]  := sSoundInvite;
    chkNotify.Items.Strings[6]  := sSoundKeyword;
    chkNotify.Items.Strings[7]  := sSoundChatactivity;
    chkNotify.Items.Strings[8]  := sSoundRoomactivity;
    chkNotify.Items.Strings[9]  := sSoundOOB;
    chkNotify.Items.Strings[10] := sSoundAutoResponse;
    }

    _cur_panel := nil;
    //_no_notify_update := false;
    _no_pres_change := false;

    // Load the system panel
    TabSelect(lblSystem);

    _roster := nil;
    _subscription := nil;
    _font := nil;
    _dialogs := nil;
    _message := nil;
    _notify := nil;

    MainSession.Prefs.RestorePosition(Self);
end;

{---------------------------------------}
procedure TfrmPrefs.TabSelect(Sender: TObject);

    procedure toggleSelector(lbl: TLabel);
    var
        i: integer;
        c: TControl;
    begin
        for i := 0 to ScrollBox1.ControlCount - 1 do begin
            c := ScrollBox1.Controls[i];
            if (c is TLabel) then begin
                if (c = lbl) then begin
                    TLabel(c).Color := clHighlight;
                    TLabel(c).Font.Color := clHighlightText;
                end
                else begin
                    TLabel(c).Color := clWindow;
                    TLabel(c).Font.Color := clWindowText;
                end;
            end;
        end;
        Self.ScrollBox1.Repaint();
    end;


var
    f: TfrmPrefPanel;
begin
    f := nil;
    if ((Sender = imgSystem) or (Sender = lblSystem)) then begin
        // PageControl1.ActivePage := tbsSystem;
        toggleSelector(lblSystem);
        if (_system <> nil) then
            f := _system
        else begin
            _system := TfrmPrefSystem.Create(Self);
            f := _system;
        end;
    end
    else if ((Sender = imgRoster) or (Sender = lblRoster)) then begin
        // PageControl1.ActivePage := tbsRoster;
        toggleSelector(lblRoster);
        if (_roster <> nil) then
            f := _roster
        else begin
            _roster := TfrmPrefRoster.Create(Self);
            f := _roster;
        end;
    end
    else if ((Sender = imgS10n) or (Sender = lblS10n)) then begin
        // PageControl1.ActivePage := tbsSubscriptions;
        toggleSelector(lblS10n);
        if (_subscription <> nil) then
            f := _subscription
        else begin
            _subscription := TfrmPrefSubscription.Create(Self);
            f := _subscription;
        end;
    end
    else if ((Sender = imgFonts) or (Sender = lblFonts)) then begin
        // PageControl1.ActivePage := tbsFonts;
        toggleSelector(lblFonts);
        if (_font <> nil) then
            f := _font
        else begin
            _font := TfrmPrefFont.Create(Self);
            f := _font;
        end;
    end
    else if ((Sender = imgDialog) or (Sender = lblDialog)) then begin
        // PageControl1.ActivePage := tbsDialog;
        toggleSelector(lblDialog);
        if (_dialogs <> nil) then
            f := _dialogs
        else begin
            _dialogs := TfrmPrefDialogs.Create(Self);
            f := _dialogs;
        end;
    end
    else if ((Sender = imgMessages) or (Sender = lblMessages)) then begin
        // PageControl1.ActivePage := tbsMessages;
        toggleSelector(lblMessages);
        if (_message <> nil) then
            f := _message
        else begin
            _message := TfrmPrefMsg.Create(Self);
            f := _message;
        end;
    end
    else if ((Sender = imgNotify) or (Sender = lblNotify)) then begin
        // PageControl1.ActivePage := tbsNotify;
        toggleSelector(lblNotify);
        if (_notify <> nil) then
            f := _notify
        else begin
            _notify := TfrmPrefNotify.Create(Self);
            f := _notify;
        end;
    end
    else if ((Sender = imgAway) or (Sender = lblAway)) then begin
        PageControl1.ActivePage := tbsAway;
        toggleSelector(lblAway);
    end
    else if ((Sender = imgKeywords) or (Sender = lblKeywords)) then begin
        PageControl1.ActivePage := tbsKeywords;
        toggleSelector(lblKeywords);
    end
    else if ((Sender = imgBlockList) or (Sender = lblBlockList)) then begin
        PageControl1.ActivePage := tbsBlockList;
        toggleSelector(lblBlocklist);
    end
    else if ((Sender = imgCustompres) or (Sender = lblCustomPres)) then begin
        PageControl1.ActivePage := tbsCustomPres;
        toggleSelector(lblCustompres);
    end
    else if ((Sender = imgNetwork) or (Sender = lblNetwork)) then begin
        PageControl1.ActivePage := tbsNetwork;
        toggleSelector(lblNetwork);
    end
    else if ((Sender = imgPlugins) or (Sender = lblPlugins)) then begin
        PageControl1.ActivePage := tbsPlugins;
        toggleSelector(lblPlugins);
    end;

    // setup the panel..
    if (f <> nil) then begin
        if PageControl1.Visible then
            PageControl1.Visible := false;

        f.Parent := Self;
        f.Align := alClient;
        f.Visible := true;
        f.BringToFront();
        _cur_panel := f;
    end
    else begin
        if (not PageControl1.Visible) then
            PageControl1.Visible := true;
        PageControl1.BringToFront();
    end;
end;

{---------------------------------------}
procedure TfrmPrefs.frameButtons1btnOKClick(Sender: TObject);
begin
    SavePrefs;
    Self.BringToFront();
end;

{---------------------------------------}
{
procedure TfrmPrefs.chkNotifyClick(Sender: TObject);
var
    e: boolean;
    i: integer;
begin
    // Show this item's options in the optNotify box.
    i := chkNotify.ItemIndex;

    _no_notify_update := true;

    e := chkNotify.Checked[i];
    chkToast.Enabled := e;
    chkFlash.Enabled := e;
    chkTrayNotify.Enabled := e;

    if chkToast.Enabled then begin
        chkToast.Checked := ((_notify[i] and notify_toast) > 0);
        chkFlash.Checked := ((_notify[i] and notify_flash) > 0);
        chkTrayNotify.Checked := ((_notify[i] and notify_tray) > 0);
    end
    else begin
        chkToast.Checked := false;
        chkFlash.Checked := false;
        chkTrayNotify.Checked := false;
        _notify[i] := 0;
    end;

    _no_notify_update := false;
end;
}

{---------------------------------------}
{
procedure TfrmPrefs.chkToastClick(Sender: TObject);
var
    i: integer;
begin
    // update the current notify selection
    if (_no_notify_update) then exit;
    i := chkNotify.ItemIndex;

    if (i < 0) then exit;
    if (i > NUM_NOTIFIES) then exit;

    _notify[i] := 0;
    if (chkToast.Checked) then _notify[i] := _notify[i] + notify_toast;
    if (chkFlash.Checked) then _notify[i] := _notify[i] + notify_flash;
    if (chkTrayNotify.Checked) then _notify[i] := _notify[i] + notify_tray;
end;
}

{---------------------------------------}
procedure TfrmPrefs.lstCustomPresClick(Sender: TObject);
var
    e: boolean;
begin
    // show the props of this presence object
    _no_pres_change := true;

    e := (lstCustomPres.ItemIndex >= 0);
    txtCPTitle.Enabled := e;
    txtCPStatus.Enabled := e;
    txtCPPriority.Enabled := e;
    txtCPHotkey.Enabled := e;

    if (not e) then begin
        txtCPTitle.Text := '';
        txtCPStatus.Text := '';
        txtCPPriority.Text := '0';
    end
    else with TJabberCustomPres(_pres_list[lstCustomPres.ItemIndex]) do begin

        if (show = 'chat') then cboCPType.ItemIndex := 0
        else if (show = 'away') then cboCPType.Itemindex := 2
        else if (show = 'xa') then cboCPType.ItemIndex := 3
        else if (show = 'dnd') then cboCPType.ItemIndex := 4
        else
            cboCPType.ItemIndex := 1;

        txtCPTitle.Text := title;
        txtCPStatus.Text := status;
        txtCPPriority.Text := IntToStr(priority);
        txtCPHotkey.HotKey := TextToShortcut(hotkey);
    end;
    _no_pres_change := false;
end;

{---------------------------------------}
procedure TfrmPrefs.txtCPTitleChange(Sender: TObject);
var
    i: integer;
begin
    // something changed on the current custom pres object
    // automatically update it.
    if (lstCustomPres.ItemIndex < 0) then exit;
    if (not tbsCustomPres.Visible) then exit;
    if (_no_pres_change) then exit;

    i := lstCustomPres.ItemIndex;
    with  TJabberCustomPres(_pres_list[i]) do begin
        title := txtCPTitle.Text;
        status := txtCPStatus.Text;
        priority := SafeInt(txtCPPriority.Text);
        hotkey := ShortCutToText(txtCPHotkey.HotKey);
        case cboCPType.ItemIndex of
        0: show := 'chat';
        1: show := '';
        2: show := 'away';
        3: show := 'xa';
        4: show := 'dnd';
    end;
        if (title <> lstCustomPres.Items[i]) then
            lstCustomPres.Items[i] := title;
    end;
end;

{---------------------------------------}
procedure TfrmPrefs.btnCustomPresAddClick(Sender: TObject);
var
    cp: TJabberCustomPres;
begin
    // add a new custom pres
    cp := TJabberCustomPres.Create();
    cp.title := sPrefsDfltPres;
    cp.show := '';
    cp.Status := '';
    cp.priority := 0;
    cp.hotkey := '';
    _pres_list.Add(cp);
    lstCustompres.Items.Add(cp.title);
    lstCustompres.ItemIndex := lstCustompres.Items.Count - 1;
    lstCustompresClick(Self);
end;

{---------------------------------------}
procedure TfrmPrefs.btnCustomPresRemoveClick(Sender: TObject);
var
    cp: TJabberCustomPres;
begin
    // delete the current pres
    cp := TJabberCustomPres(_pres_list[lstCustomPres.ItemIndex]);
    _pres_list.Remove(cp);
    MainSession.Prefs.removePresence(cp);
    lstCustompres.Items.Delete(lstCustomPres.ItemIndex);
    lstCustompresClick(Self);
    cp.Free();
end;

{---------------------------------------}
procedure TfrmPrefs.btnCustomPresClearClick(Sender: TObject);
begin
    // clear all entries
    if MessageDlg(sPrefsClearPres, mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
    lstCustomPres.Items.Clear;
    clearPresList();
    lstCustompresClick(Self);
    MainSession.Prefs.removeAllPresence();
end;

{---------------------------------------}
{
procedure TfrmPrefs.Label20Click(Sender: TObject);
var
    ver : integer;
    win : String;
begin
    // pop open the proper control panel applet.
    // It sure was nice of MS to change this for various versions
    // of the OS. *SIGH*
    ver := WindowsVersion(win);
    if (ver = cWIN_XP) then
        ShellExecute(Self.Handle, nil, 'rundll32.exe',
          'shell32.dll,Control_RunDLL mmsys.cpl,,1', nil, SW_SHOW)
    else if ((ver = cWIN_98) or (ver = cWIN_NT)) then
        ShellExecute(Self.Handle, nil, 'rundll32.exe',
            'shell32.dll,Control_RunDLL mmsys.cpl,sounds,0', nil, SW_SHOW)
    else
        ShellExecute(Self.Handle, nil, 'rundll32.exe',
          'shell32.dll,Control_RunDLL mmsys.cpl,,0', nil, SW_SHOW);
end;
}

{---------------------------------------}
procedure TfrmPrefs.btnBrowsePluginPathClick(Sender: TObject);
var
    p: String;
begin
    // Change the plugin dir
    p := txtPluginDir.Text;
    if (browsePath(p)) then begin
        if (p <> txtPluginDir.Text) then begin
            txtPluginDir.Text := p;
            loadPlugins();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmPrefs.lblPluginScanClick(Sender: TObject);
begin
    loadPlugins();
end;

{---------------------------------------}
procedure TfrmPrefs.btnConfigPluginClick(Sender: TObject);
var
    li: TListItem;
    com_name: string;
begin
    li := lstPlugins.Selected;
    if (li = nil) then exit;
    com_name := li.Caption;
    ConfigurePlugin(com_name);
end;

{---------------------------------------}
procedure TfrmPrefs.cboProxyApproachChange(Sender: TObject);
begin
    if (cboProxyApproach.ItemIndex = http_proxy_custom) then begin
        txtProxyHost.Enabled := true;
        txtProxyPort.Enabled := true;
        chkProxyAuth.Enabled := true;
        lblProxyHost.Enabled := true;
        lblProxyPort.Enabled := true;
    end
    else begin
        txtProxyHost.Enabled := false;
        txtProxyPort.Enabled := false;
        chkProxyAuth.Enabled := false;
        chkProxyAuth.Checked := false;
        txtProxyUsername.Enabled := false;
        txtProxyPassword.Enabled := false;
        lblProxyHost.Enabled := false;
        lblProxyPort.Enabled := false;
        lblProxyUsername.Enabled := false;
        lblProxyPassword.Enabled := false;
    end;
end;

{---------------------------------------}
procedure TfrmPrefs.chkProxyAuthClick(Sender: TObject);
begin
    if (chkProxyAuth.Checked) then begin
        lblProxyUsername.Enabled := true;
        lblProxyPassword.Enabled := true;
        txtProxyUsername.Enabled := true;
        txtProxyPassword.Enabled := true;
    end
    else begin
        lblProxyUsername.Enabled := false;
        lblProxyPassword.Enabled := false;
        txtProxyUsername.Enabled := false;
        txtProxyPassword.Enabled := false;
    end;
end;
procedure TfrmPrefs.FormDestroy(Sender: TObject);
begin
    // destroy all panels we have..
    _system.Free();
    _roster.Free();
    _subscription.Free();
    _font.Free();
    _dialogs.Free();
    _message.Free();
    _notify.Free();
end;

end.

