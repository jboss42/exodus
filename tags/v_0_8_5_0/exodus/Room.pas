unit Room;
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
    Unicode, XMLTag, RegExpr,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, BaseChat, ComCtrls, StdCtrls, Menus, ExRichEdit, ExtCtrls,
    RichEdit2, TntStdCtrls, Buttons, TntComCtrls;

type
  TMemberNode = TTntListItem;
  TRoomMember = class
  public
    Nick: Widestring;
    jid: Widestring;
    Node: TMemberNode;
    status: Widestring;
    show: Widestring;
    blockShow: Widestring;
    role: WideString;
    affil: WideString;
    real_jid: WideString;
  end;

  TfrmRoom = class(TfrmBaseChat)
    Panel6: TPanel;
    Splitter2: TSplitter;
    popRoom: TPopupMenu;
    popClear: TMenuItem;
    popBookmark: TMenuItem;
    popInvite: TMenuItem;
    popNick: TMenuItem;
    N1: TMenuItem;
    popClose: TMenuItem;
    mnuOnTop: TMenuItem;
    popRoomRoster: TPopupMenu;
    popRosterChat: TMenuItem;
    popRosterBlock: TMenuItem;
    pnlSubj: TPanel;
    lblSubjectURL: TLabel;
    btnClose: TSpeedButton;
    popClearHistory: TMenuItem;
    popShowHistory: TMenuItem;
    lstRoster: TTntListView;
    lblSubject: TTntLabel;
    popAdmin: TMenuItem;
    popBanList: TMenuItem;
    popMemberList: TMenuItem;
    popVoiceList: TMenuItem;
    popKick: TMenuItem;
    popBan: TMenuItem;
    popVoice: TMenuItem;
    popConfigure: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    popDestroy: TMenuItem;
    popAdminList: TMenuItem;
    N5: TMenuItem;
    popOwner: TMenuItem;
    popOwnerList: TMenuItem;
    mnuWordwrap: TMenuItem;
    NotificationOptions1: TMenuItem;
    S1: TMenuItem;
    dlgSave: TSaveDialog;
    N6: TMenuItem;
    Message1: TMenuItem;
    SendmyJID1: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure MsgOutKeyPress(Sender: TObject; var Key: Char);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblSubjectURLClick(Sender: TObject);
    procedure popClearClick(Sender: TObject);
    procedure popNickClick(Sender: TObject);
    procedure popCloseClick(Sender: TObject);
    procedure popBookmarkClick(Sender: TObject);
    procedure popInviteClick(Sender: TObject);
    procedure mnuOnTopClick(Sender: TObject);
    procedure popRosterBlockClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure popRoomRosterPopup(Sender: TObject);
    procedure popShowHistoryClick(Sender: TObject);
    procedure popClearHistoryClick(Sender: TObject);
    procedure lstRosterDblClick(Sender: TObject);
    procedure lstRosterDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lstRosterDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lstRosterInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure popConfigureClick(Sender: TObject);
    procedure popKickClick(Sender: TObject);
    procedure popVoiceClick(Sender: TObject);
    procedure popVoiceListClick(Sender: TObject);
    procedure popDestroyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuWordwrapClick(Sender: TObject);
    procedure NotificationOptions1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure Message1Click(Sender: TObject);
    procedure SendmyJID1Click(Sender: TObject);
    procedure lstRosterData(Sender: TObject; Item: TListItem);
  private
    { Private declarations }
    jid: Widestring;            // jid of the conf. room
    _roster: TWideStringlist;   // roster for this room
    _rlist: TList;
    _isMUC: boolean;
    _mcallback: integer;        // Message Callback
    _ecallback: integer;        // Error msg callback
    _pcallback: integer;        // Presence Callback
    _scallback: integer;        // Session callback
    _nick_prefix: Widestring;   // stuff for nick completion:
    _nick_idx: integer;
    _nick_len: integer;
    _nick_start: integer;
    _keywords: TRegExpr;     // list of keywords to monitor for
    _hint_text: Widestring;

    _old_nick: WideString;

    _notify: array[0..2] of integer;

    function  checkCommand(txt: Widestring): boolean;

    procedure SetJID(sjid: Widestring);
    procedure ShowMsg(tag: TXMLTag);
    procedure RenderMember(member: TRoomMember; tag: TXMLTag);
    procedure changeSubject(subj: Widestring);
    procedure configRoom();
    procedure AddMemberItems(tag: TXMLTag; reason: WideString = '';
        NewRole: WideString = ''; NewAffiliation: WideString = '');
    procedure showStatusCode(t: TXMLTag);
    procedure selectNicks(wsl: TWideStringList);

    function newRoomMessage(body: Widestring): TXMLTag;
    procedure changeNick(new_nick: WideString);
    procedure setupKeywords();

  published
    procedure MsgCallback(event: string; tag: TXMLTag);
    procedure PresCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure ConfigCallback(event: string; Tag: TXMLTag);
  public
    { Public declarations }
    mynick: Widestring;
    COMController: TObject;

    procedure SendMsg; override;
    procedure pluginMenuClick(Sender: TObject); override;

    function GetNick(rjid: Widestring): Widestring;

    property HintText: Widestring read _hint_text;
    property getJid: WideString read jid;
    property isMUCRoom: boolean read _isMUC;

    procedure DockForm; override;
    procedure FloatForm; override;
  end;

var
  frmRoom: TfrmRoom;

  room_list: TWideStringList;

  xp_muc_presence: TXPLite;
  xp_muc_status: TXPLite;
  xp_muc_item: TXPLite;
  xp_muc_reason: TXPLite;

resourcestring
    sRoom = 'Room';
    sNotifyKeyword = 'Keyword in ';
    sNotifyActivity = 'Activity in ';
    sRoomSubjChange = '/me has changed the subject to: ';
    sRoomSubjPrompt = 'Change room subject';
    sRoomNewSubj = 'New subject';
    sRoomNewNick = 'New nickname';
    sRoomBMPrompt = 'Bookmark Room';
    sRoomNewBookmark = 'Enter bookmark name:';
    sBlocked = 'Blocked';
    sBlock = 'Block';
    sUnblock = 'UnBlock';
    sUnknownFileType = 'Unknown file type';
    sInvalidRoomJID = 'The Room Address you entered is invalid. It must be valid Jabber ID.';

    sDestroyRoom = 'Destroy Room';
    sKickReason = 'Kick Reason';
    sBanReason = 'Ban Reason';
    sDestroyReason = 'Destroy Reason';
    sKickDefault = 'You have been kicked.';
    sBanDefault = 'You have been banned.';
    sDestroyDefault = 'The owner has destroyed the room.';

    sGrantVoice = 'You have been granted voice.';
    sRevokeVoice = 'Your voice has been revoked.';

    sNewUser = '%s has entered the room.';
    sUserLeave = '%s has left the room.';
    sNewRole = '%s has a new role of %s.';

    sDestroyRoomConfirm = 'Do you really want to destroy the room? All users will be removed.';

    sStatus_100  = 'This room is not anonymous';
    sStatus_301  = '%s has been banned from this room. %s';
    sStatus_302  = 'This room has been destroyed.';
    sStatus_303  = '%s is now known as %s.';
    sStatus_307  = '%s has been kicked from this room. %s';

    sStatus_401  = 'You supplied an invalid password to enter this room.';
    sStatus_403  = 'You are on the ban list for this room.';
    sStatus_404  = 'The room is being created. Please try again later.';
    sStatus_405  = 'You are not allowed to create rooms.';
    sStatus_405a = 'You are not allowed to enter the room. You must be on the member list.';
    sStatus_407  = 'You are not on the member list for this room. Try and register?';
    sStatus_409  = 'Your nickname is already being used. Please select another one.';
    sStatus_Unknown = 'The room has been destroyed for an unknown reason.';

    sEditVoice  = 'Edit Voice List';
    sEditBan    = 'Edit Ban List';
    sEditMember = 'Edit Member List';
    sEditAdmin  = 'Edit Admin List';
    sEditOwner  = 'Edit Owner List';

const
    MUC_OWNER = 'owner';
    MUC_ADMIN = 'admin';
    MUC_MEMBER = 'member';
    MUC_OUTCAST = 'outcast';

    MUC_MOD = 'moderator';
    MUC_PART = 'participant';
    MUC_VISITOR = 'visitor';
    MUC_NONE = 'none';


function FindRoom(rjid: Widestring): TfrmRoom;
function StartRoom(rjid, rnick: Widestring; Password: WideString = ''): TfrmRoom;
function IsRoom(rjid: Widestring): boolean;
function FindRoomNick(rjid: Widestring): Widestring;

{---------------------------------------}
function ItemCompare(Item1, Item2: Pointer): integer;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    ChatWin, COMChatController, CustomNotify,
    ExSession, ExUtils,
    InputPassword,
    Invite,
    IQ,
    Jabber1,
    JabberConst,
    JabberID,
    JabberMsg,
    JoinRoom,
    MsgDisplay,
    MsgRecv,
    Notify,
    PrefController,
    Presence,
    RichEdit,
    RiserWindow,
    RoomAdminList,
    Roster,
    RosterWindow,
    Session,
    ShellAPI,
    StrUtils,
    xData,
    XMLNode,
    XMLUtils;

{$R *.DFM}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function StartRoom(rjid, rnick: Widestring; Password: WideString = ''): TfrmRoom;
var
    f: TfrmRoom;
    p: TJabberPres;
    tmp_jid: TJabberID;
    i : integer;
begin
    // is there already a room window?
    i := room_list.IndexOf(rjid);
    if (i >= 0) then
        f := TfrmRoom(room_list.Objects[i])
    else begin
        // create a new room
        f := TfrmRoom.Create(Application);
        f.SetJID(rjid);
        f.MyNick := rnick;
        tmp_jid := TJabberID.Create(rjid);
        p := TJabberPres.Create;
        p.toJID := TJabberID.Create(rjid + '/' + rnick);
        with p.AddTag('x') do begin
            setAttribute('xmlns', XMLNS_MUC);
            if (password <> '') then
                AddBasicTag('password', password);
        end;

        if (MainSession.Invisible) then
            MainSession.addAvailJid(rjid);

        MainSession.SendTag(p);
        f.Caption := tmp_jid.user + ' ' + sRoom;
        if MainSession.Prefs.getBool('expanded') then
            f.DockForm;

        // setup prefs
        with f do begin
            AssignDefaultFont(MsgList.Font);
            MsgList.Color := TColor(MainSession.Prefs.getInt('color_bg'));
            MsgOut.Color := MsgList.Color;
            MsgOut.Font.Assign(MsgList.Font);
            lstRoster.Color := MsgList.Color;
            lstRoster.Font.Name := MainSession.Prefs.getString('roster_font_name');
            lstRoster.Font.Color := TColor(MainSession.Prefs.getInt('font_color'));
            lstRoster.Font.Size := MainSession.Prefs.getInt('roster_font_size');
            lstRoster.Font.Charset := MainSession.Prefs.getInt('roster_font_charset');
            if (lstRoster.Font.Charset = 0) then
                lstRoster.Font.Charset := DEFAULT_CHARSET;
        end;

        // let the plugins know about the new room
        ExComController.fireNewRoom(tmp_jid.jid, TExodusChat(f.ComController));
        
        tmp_jid.Free();
        room_list.AddObject(rjid, f);
    end;

    f.Show;
    if f.TabSheet <> nil then
        frmExodus.Tabs.ActivePage := f.TabSheet;
    Result := f;
end;

{---------------------------------------}
procedure TfrmRoom.MsgCallback(event: string; tag: TXMLTag);
var
    body, xml: Widestring;
begin
    // plugin
    xml := tag.xml();
    body := tag.GetBasicText('body');
    TExodusChat(ComController).fireRecvMsg(body, xml);

    // We are getting a msg
    if (tag.getAttribute('type') = 'groupchat') then
        ShowMsg(tag)
    else if (tag.getAttribute('type') = 'error') then
        ShowMsg(tag);

end;

{---------------------------------------}
procedure TfrmRoom.showMsg(tag: TXMLTag);
var
    i : integer;
    Msg: TJabberMessage;
    from: Widestring;
    tmp_jid: TJabberID;
    server: boolean;
    rm: TRoomMember;
    tmps: string;
begin
    // display the body of the msg
    Msg := TJabberMessage.Create(tag);

    if (Msg.isXdata) then exit;

    from := tag.GetAttribute('from');
    i := _roster.indexOf(from);
    if (i < 0) then begin
        // some kind of server msg..
        tmp_jid := TJabberID.Create(from);
        if (tmp_jid.resource <> '') then
            Msg.Nick := tmp_jid.resource
        else
            Msg.Nick := '';
        tmp_jid.Free();
        Msg.IsMe := false;
        server := true;
    end
    else begin
        rm := TRoomMember(_roster.Objects[i]);
        // if blocked ignore anything they say, even subject changes.
        if (rm.Show = sBlocked) then
           exit;
        Msg.Nick := rm.Nick;
        Msg.IsMe := (Msg.Nick = MyNick);
        server := false;
    end;

    if (Msg.Body <> '') then begin
        DisplayMsg(Msg, MsgList);

        // log if we have logs for TC turned on.
        if ((MainSession.Prefs.getBool('log_rooms')) and
            (MainSession.Prefs.getBool('log'))) then begin
            Msg.isMe := False;
            LogMessage(Msg);
        end;

        if (GetActiveWindow = Self.Handle) and (pnlInput.Visible) then
            MsgOut.SetFocus();
    end;

    if Msg.Subject <> '' then begin
        lblSubject.Caption := Msg.Subject;
        tmps := Msg.Subject;
        tmps := AnsiReplaceText(tmps, '|', Chr(13));
        tmps := AnsiReplaceText(tmps, '&', '&&');
        lblSubject.Hint := tmps;
    end;

    // this check is needed only to prevent extraneous regexing.
    if ((not server) and
        (not MainSession.IsPaused)) then begin
        // check for keywords
        if ((_keywords <> nil) and (_keywords.Exec(Msg.Body))) then
            DoNotify(Self, _notify[1],
                     sNotifyKeyword + Self.Caption + ': ' + _keywords.Match[1],
                     ico_conf, 'notify_keyword')
        else
            DoNotify(Self, _notify[0],
                     sNotifyActivity + Self.Caption,
                     ico_conf, 'notify_roomactivity');
    end;

    Msg.Free();
end;

{---------------------------------------}
procedure TfrmRoom.SendMsg;
var
    xml, txt: Widestring;
    msg: TJabberMessage;
    mtag: TXMLTag;
begin
    // Send the actual message out
    txt := getInputText(MsgOut);

    // plugin madness
    TExodusChat(ComController).fireBeforeMsg(txt);

    if (txt = '') then exit;

    if (txt[1] = '/') then begin
        if (checkCommand(txt)) then
            exit;
    end;
    msg := TJabberMessage.Create(jid, 'groupchat', txt, '');
    msg.nick := MyNick;
    msg.isMe := true;
    msg.ID := MainSession.generateID();

    // additional plugin madness
    mtag := msg.Tag;
    xml := TExodusChat(ComController).fireAfterMsg(txt);
    if (xml <> '') then
        mtag.addInsertedXML(xml);

    MainSession.SendTag(mtag);
    msg.Free();
    inherited;
end;

{---------------------------------------}
function TfrmRoom.checkCommand(txt: Widestring): boolean;
var
    cmd: Widestring;
    rest: Widestring;
    wsl: TWideStringList;
    m: TJabberMessage;
    c: integer;
begin
    // check for various / commands
    result := false;

    wsl := TWideStringList.Create();
    Split(txt, wsl);
    if (wsl.Count = 0) then begin
        wsl.Destroy();
        exit;
    end;
    cmd := wsl[0];
    if (cmd = '') or (cmd[1] <> '/') then begin
        wsl.Destroy();
        exit;
    end;

    wsl.Delete(0);
    c := pos(cmd, txt) + length(cmd) + 1;
    rest := copy(txt, c, length(txt) - c + 1);

    if (cmd = '/clear') then begin
        msgList.Lines.Clear;
        Result := true;
    end
    else if (cmd = '/config') then begin
        configRoom();
        Result := true;
    end
    else if (cmd = '/help') then begin
        m := TJabberMessage.Create(self.jid, 'groupchat',
        '/ commands: '#13#10'/clear'#13#10'/config'#13#10 +
        '/subject <subject>'#13#10'/invite <jid>'#13#10 +
        '/block <nick>'#13#10'/kick <nick>'#13#10 +
        '/ban <nick>'#13#10'/nick <nick>'#13#10'/voice <nick>', '');
        DisplayMsg(m, MsgList);
        m.Destroy();
        Result := true;
    end
    else if (cmd = '/nick') then begin
        // change nickname
        if (rest = '') then exit;
        changeNick(rest);
        Result := true;
    end
    else if (cmd = '/subject') then begin
        // set subject
        changeSubject(rest);
        Result := true;
    end
    else if (cmd = '/invite') then begin
        ShowInvite(Self.jid, wsl);
        Result := true;
    end
    else if (cmd = '/kick') then begin
        selectNicks(wsl);
        popKickClick(popKick);
        Result := true;
    end
    else if (cmd = '/ban') then begin
        selectNicks(wsl);
        popKickClick(popBan);
        Result := true;
    end
    else if (cmd = '/voice') then begin
        selectNicks(wsl);
        popVoiceClick(nil);
        Result := true;
    end
    else if (cmd = '/block') then begin
        selectNicks(wsl);
        popRosterBlockClick(nil);
        Result := true;
    end;

    wsl.Destroy();
    if (Result) then
        MsgOut.Lines.Clear();
end;

{---------------------------------------}
procedure TfrmRoom.SessionCallback(event: string; tag: TXMLTag);
var
    p: TJabberPres;
begin
    // session callback...look for our own presence changes
    if (event = '/session/disconnected') then begin
        // post a msg to the window and disable the text input box.
        pnlInput.Visible := false;
        DisplayPresence(sDisconnected, MsgList);

        MainSession.UnRegisterCallback(_mcallback);
        MainSession.UnRegisterCallback(_ecallback);
        MainSession.UnRegisterCallback(_pcallback);

        _mcallback := -1;
        _ecallback := -1;
        _pcallback := -1;
    end
    else if (event = '/session/presence') then begin
        // We changed our own presence, send it to the room
        if (MainSession.Invisible) then exit;
        p := TJabberPres.Create();
        p.toJID := TJabberID.Create(self.jid);
        p.Show := MainSession.Show;
        p.Status := MainSession.Status;
        MainSession.SendTag(p);
    end;
end;

{---------------------------------------}
function TfrmRoom.newRoomMessage(body: Widestring): TXMLTag;
begin
    Result := TXMLTag.Create('message');
    Result.setAttribute('from', jid);
    Result.setAttribute('type', 'groupchat');
    Result.AddBasicTag('body', body);
end;

{---------------------------------------}
procedure TfrmRoom.presCallback(event: string; tag: TXMLTag);
var
    ptype, from: Widestring;
    tmp_jid: TJabberID;
    i: integer;
    member: TRoomMember;
    mtag, t, itag, xtag, etag: TXMLTag;
    ecode, scode, tmp1, tmp2: Widestring;
begin
    // We are getting presence
    from := tag.getAttribute('from');
    ptype := tag.getAttribute('type');
    i := _roster.indexOf(from);

    // check for MUC presence
    xtag := nil;
    if (not _isMUC) then begin
        xtag := tag.QueryXPTag(xp_muc_presence);
        if (xtag <> nil) then _isMUC := true;
    end;

    if ((ptype = 'error') and ((from = jid) or (from = jid + '/' + MyNick))) then begin
        // check for various presence errors
        etag := tag.GetFirstTag('error');
        if (etag <> nil) then begin
            ecode := etag.GetAttribute('code');
            if (ecode = '409') then begin
                MessageDlg(sStatus_409, mtError, [mbOK], 0);
                if (_old_nick = '') then begin
                    Self.Close();
                    exit;
                end
                else
                    myNick := _old_nick;
            end
            else if (ecode = '401') then begin
                MessageDlg(sStatus_401, mtError, [mbOK], 0);
                Self.Close();
                tmp_jid := TJabberID.Create(from);
                StartJoinRoom(tmp_jid, MyNick, '');
                tmp_jid.Free();
                exit;
            end
            else if (ecode = '404') then begin
                MessageDlg(sStatus_404, mtError, [mbOK], 0);
                Self.Close();
                exit;
            end
            else if (ecode = '405') then begin
                MessageDlg(sStatus_405a, mtError, [mbOK], 0);
                Self.Close();
                exit;
            end
            else if (ecode = '407') then begin
                if (messageDlg(sStatus_407, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
                    t := TXMLTag.Create('register');
                    t.setAttribute('jid', Self.jid);
                    MainSession.FireEvent('/session/register', t);
                    t.Free();
                end;
                Self.Close();
                exit;
            end
            else if (ecode = '403') then begin
                MessageDlg(etag.Data(), mtError, [mbOK], 0);
                Self.Close();
                exit;
            end
        end;

        MessageDlg(sStatus_Unknown, mtError, [mbOK], 0);
        Self.Close();
        exit;
    end

    else if ptype = 'unavailable' then begin
        t := tag.QueryXPTag(xp_muc_status);
        if ((from = jid) or (from = jid + '/' + MyNick)) then begin
            if (t <> nil) then
                ShowStatusCode(t);
            Self.Close();
            exit;
        end
        else if (i >= 0) then begin
            member := TRoomMember(_roster.Objects[i]);
            if (t <> nil) then begin
                scode := t.GetAttribute('code');
                if (scode = '303') then begin
                    // this user has changed their nick..
                    itag := tag.QueryXPTag(xp_muc_item);
                    if (itag <> nil) then begin
                        tmp1 := member.Nick;
                        tmp2 := itag.GetAttribute('nick');
                        mtag := newRoomMessage(Format(sStatus_303,
                            [tmp1, tmp2]));
                        ShowMsg(mtag);
                    end;
                end
                else if ((scode = '301') or (scode = '307')) then begin
                    itag := tag.QueryXPTag(xp_muc_reason);
                    if (itag <> nil) then tmp1 := itag.Data else tmp1 := '';
                    if (scode = '301') then tmp2 := sStatus_301
                    else if (scode = '307') then tmp2 := sStatus_307;
                    mtag := newRoomMessage(Format(tmp2, [member.Nick, tmp1]));
                    ShowMsg(mtag);
                end;
            end
            else if (member.role <> '') then begin
                mtag := newRoomMessage(Format(sUserLeave, [member.Nick]));
                ShowMsg(mtag);
            end;

            _roster.Delete(i);
            i := _rlist.IndexOf(member);
            if (i >= 0) then begin
                _rlist.Delete(i);
                _rlist.Sort(ItemCompare);
                lstRoster.Items.Count := _rlist.Count;
                lstRoster.Invalidate();
            end;
            member.Free;
        end;
    end
    else begin
        // SOME KIND OF AVAIL
        if i < 0 then begin
            // this is a new member
            tmp_jid := TJabberID.Create(from);
            member := TRoomMember.Create;
            member.JID := from;
            member.Nick := tmp_jid.resource;

            _roster.AddObject(from, member);
            _rlist.Add(member);
            _rlist.Sort(ItemCompare);
            lstRoster.Items.Count := _rlist.Count;
            lstRoster.Invalidate();

            // show new user message
            if (xtag <> nil) then begin
                _isMUC := true;
                mtag := newRoomMessage(Format(sNewUser, [member.nick]));
                showMsg(mtag);

                t := xtag.GetFirstTag('status');
                if ((t <> nil) and (t.getAttribute('code') = '201')) then begin
                    // we are the owner... config the room
                    _isMUC := true;
                    configRoom();
                end;
            end;

            tmp_jid.Free();

        end
        else begin
            member := TRoomMember(_roster.Objects[i]);

            tmp1 := '';
            itag := tag.QueryXPTag(xp_muc_item);
            if (itag <> nil) then begin
                _isMUC := true;
                tmp1 := itag.getAttribute('role');
            end;

            mtag := nil;
            if ((tmp1 <> '') and (member.nick = myNick)) then begin
                // someone maybe changed my role
                if ((member.role = MUC_VISITOR) and (tmp1 = MUC_PART)) then
                    mtag := newRoomMessage(sGrantVoice)
                else if ((member.role = MUC_PART) and (tmp1 = MUC_VISITOR)) then
                    mtag := newRoomMessage(sRevokeVoice)
                else if (member.role <> tmp1) then
                    mtag := newRoomMessage(Format(sNewRole, [member.nick, tmp1]));
                if (mtag <> nil) then showMsg(mtag);
            end;
        end;

        // get extended stuff for MUC, and update the member struct
        if (xtag <> nil) then begin
            _isMUC := true;
            t := xtag.GetFirstTag('item');
            if (t <> nil) then begin
                member.role := t.GetAttribute('role');
                member.real_jid := t.GetAttribute('jid');
                member.affil := t.GetAttribute('affiliation');
            end;
        end;

        // for all protocols, our nick is our resource
        tmp_jid := TJabberID.Create(from);
        member.nick := tmp_jid.resource;
        tmp_jid.Free();

        if (member.Nick = myNick) then begin
            // check to see what my role is
            popConfigure.Enabled := (member.Affil = MUC_OWNER);
            popDestroy.Enabled := popConfigure.Enabled;
            popAdminList.Enabled := popConfigure.Enabled;

            popAdmin.Enabled := (member.Role = MUC_MOD) or popConfigure.Enabled;
            popKick.Enabled := popAdmin.Enabled;
            popBan.Enabled := popAdmin.Enabled;
            popVoice.Enabled := popAdmin.Enabled;
            popOwner.Enabled := popConfigure.Enabled;
        end;
        RenderMember(member, tag);
    end;

end;

{---------------------------------------}
procedure TfrmRoom.showStatusCode(t: TXMLTag);
var
    msg, fmt: string;
    scode: WideString;
begin
    scode := t.getAttribute('code');

    fmt := '';

    if (scode = '301') then fmt := sStatus_301
    else if (scode = '302') then fmt := sStatus_302
    else if (scode = '303') then fmt := sStatus_303
    else if (scode = '307') then fmt := sStatus_307
    else if (scode = '403') then msg := sStatus_403
    else if (scode = '405') then msg := sStatus_405
    else if (scode = '407') then msg := sStatus_407
    else if (scode = '409') then msg := sStatus_409;

    if (fmt <> '') then
        msg := Format(fmt, [MyNick, '']);

    if (msg <> '') then
        MessageDlg(msg, mtInformation, [mbOK], 0);
end;

{---------------------------------------}
procedure TfrmRoom.configRoom();
var
    iq: TJabberIQ;
begin
    //
    iq := TJabberIQ.Create(MainSession, MainSession.generateID(),
        configCallback, 10);
    with iq do begin
        toJid := Self.jid;
        Namespace := XMLNS_MUCOWNER;
        iqType := 'get';
    end;
    iq.Send();
end;

{---------------------------------------}
procedure TfrmRoom.configCallback(event: string; Tag: TXMLTag);
begin
    // We are configuring the room
    if ((event = 'xml') and (tag.GetAttribute('type') = 'result')) then
        ShowXData(tag);
end;

{---------------------------------------}
procedure TfrmRoom.RenderMember(member: TRoomMember; tag: TXMLTag);
var
    i: integer;
    p: TJabberPres;
begin
    // show the member
    if member = nil then exit;

    if tag = nil then
        member.show := ''

    else begin
        p := TJabberPres.Create;
        p.parse(tag);

        if (member.show = sBlocked) then
           member.blockShow := p.Show
        else begin
            member.show := p.Show;
        end;
        member.status := p.Status;
        p.Free();
    end;

    if (member.show = '') then
        member.show := 'Available';

    i := _rlist.IndexOf(member);
    if (i >= 0) then
        lstRoster.UpdateItems(i, i);
    lstRoster.Invalidate();
end;

{---------------------------------------}
procedure TfrmRoom.FormCreate(Sender: TObject);
var
    e: TExodusChat;
begin
    inherited;

    // Create
    _mcallback := -1;
    _ecallback := -1;
    _pcallback := -1;
    _scallback := -1;
    _roster := TWideStringList.Create;
    _rlist := TList.Create;
    _isMUC := false;
    _nick_prefix := '';
    _nick_idx := 0;
    _nick_start := 0;
    _hint_text := '';
    _old_nick := '';

    _keywords := nil;

    _notify[0] := MainSession.Prefs.getInt('notify_roomactivity');
    _notify[1] := MainSession.Prefs.getInt('notify_keyword');

    lblSubject.Caption := '';

    if (_notify[1] <> 0) then
        setupKeywords();

    MyNick := '';

    _wrap_input := MainSession.Prefs.getBool('wrap_input');
    MsgOut.WordWrap := _wrap_input;
    mnuWordwrap.Checked := _wrap_input;

    e := TExodusChat.Create();
    e.setRoom(Self);
    e.ObjAddRef();
    COMController := e;
end;

{---------------------------------------}
procedure TfrmRoom.setupKeywords();
var
    kw_list : TWideStringList;
    re : bool;
    e : Widestring;
    first : bool;
    i : integer;
begin
    kw_list := TWideStringList.Create();
    MainSession.Prefs.fillStringlist('keywords', kw_list);
    if (kw_list.Count > 0) then begin
        re := MainSession.Prefs.getBool('regex_keywords');
        first := true;
        e :=  '(';
        for i := 0 to kw_list.Count-1 do begin
            if (first) then
                first := false
            else
                e := e + '|';
            if (re) then
                e := e + kw_list[i]
            else
                e := e + QuoteRegExprMetaChars(kw_list[i]);
        end;
            e := e + ')';
        _keywords := TRegExpr.Create();
        _keywords.Expression := e;
        _keywords.Compile();
    end;
    kw_list.Free();
end;

{---------------------------------------}
procedure TfrmRoom.SetJID(sjid: Widestring);
begin
    // setup our callbacks
    if (_mcallback = -1) then begin
        _mcallback := MainSession.RegisterCallback(MsgCallback, '/packet/message[@type="groupchat"][@from="' + sjid + '*"]');
        _ecallback := MainSession.RegisterCallback(MsgCallback, '/packet/message[@type="errror"][@from="' + sjid + '"]');
        _pcallback := MainSession.RegisterCallback(PresCallback, '/packet/presence[@from="' + sjid + '*"]');
        if (_scallback = -1) then
            _scallback := MainSession.RegisterCallback(SessionCallback, '/session');
    end;
    Self.jid := sjid;
end;

{---------------------------------------}
procedure TfrmRoom.MsgOutKeyPress(Sender: TObject; var Key: Char);
var
    tmps: Widestring;
    prefix: Widestring;
    i: integer;
    found, exloop: boolean;
    nick: Widestring;
begin
    inherited;
    if (Key = #0) then exit;

    // dispatch key-presses to Plugins
    TExodusChat(ComController).fireMsgKeyPress(Key);

    // Send the msg if they hit return
    if (Key = #09) then begin
        // do tab completion
        tmps := MsgOut.Lines.Text;
        if _nick_prefix = '' then begin
            // grab the new prefix..
            prefix := '';
            for i := length(tmps) downto 1 do
                if tmps[i] = ' ' then begin
                    _nick_start := i;
                    MsgOut.SelStart := i;
                    prefix := Copy(tmps, i+1, length(tmps) - i);
                    MsgOut.SelLength := Length(prefix);
                    break;
                end;

            if prefix = '' then begin
                _nick_start := 0;
                prefix := tmps;
                MsgOut.SelStart := 0;
                MsgOut.SelLength := Length(prefix);
            end;

            prefix := Trim(lowercase(prefix));
            _nick_prefix := prefix;
            _nick_idx := 0;
        end
        else begin
            with MsgOut do begin
                SelStart := _nick_start;
                SelLength := _nick_len;
                SelText := '';
            end;
        end;

        found := false;
        exloop := false;
        repeat
            // for i := _nick_idx to lstRoster.Items.Count - 1 do begin
            for i := _nick_idx to _roster.Count - 1 do begin
                // nick := lstRoster.Items[i].Caption;
                nick := TRoomMember(_roster.Objects[i]).Nick;
                if nick[1] = '@' then nick := Copy(nick, 2, length(nick) - 1);
                if nick[1] = '+' then nick := Copy(nick, 2, length(nick) - 1);

                if Pos(_nick_prefix, Lowercase(nick)) = 1 then with MsgOut do begin
                    _nick_idx := i + 1;
                    if _nick_start <= 0 then
                        SelText := nick + ': '
                    else
                        SelText := nick + ' ';
                    SelStart := Length(Lines.text) + 1;
                    _nick_len := SelStart - _nick_start;
                    SelLength := 0;
                    exloop := true;
                    found := true;
                    break;
                end;
            end;

            if (not found) and (_nick_idx = 0) then
                exloop := true
            else if (not found) then
                _nick_idx := 0;
        until (found) or (exloop);

        if not found then begin
            MsgOut.SelText := _nick_prefix;
            _nick_prefix := '';
            _nick_idx := 0;
        end;
        Key := Chr(0);
    end
    else begin
        _nick_prefix := '';
        _nick_idx := 0;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.btnCloseClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmRoom.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    inherited;
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmRoom.changeSubject(subj: Widestring);
var
    msg: TJabberMessage;
begin
    // send the msg out
    msg := TJabberMessage.Create(jid,
                                 'groupchat',
                                 sRoomSubjChange + subj,
                                 subj);
    MainSession.SendTag(msg.Tag);
    msg.Free;
end;

{---------------------------------------}
procedure TfrmRoom.lblSubjectURLClick(Sender: TObject);
var
    s: WideString;
begin
    // Change the subject
    s := lblSubject.Caption;
    if InputQueryW(sRoomSubjPrompt, sRoomNewSubj, s) then begin
        changeSubject(s);
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popClearClick(Sender: TObject);
begin
  inherited;
    MsgList.Lines.Clear;
end;

{---------------------------------------}
procedure TfrmRoom.changeNick(new_nick: WideString);
var
    p: TJabberPres;
    i: integer;
    rm: TRoomMember;
begin
    // check room roster for this nick already
    for i := 0 to _roster.Count - 1 do begin
        rm := TRoomMember(_roster.Objects[i]);
        if (AnsiCompareText(rm.Nick, new_nick) = 0) then begin
            // they match
            MessageDlg(sStatus_409, mtError, [mbOK], 0);
            exit;
        end;
    end;

    // go ahead and change it
    myNick := new_nick;
    p := TJabberPres.Create;
    p.toJID := TJabberID.Create(jid + '/' + myNick);
    MainSession.SendTag(p);
end;

{---------------------------------------}
procedure TfrmRoom.popNickClick(Sender: TObject);
var
    new_nick: WideString;
begin
  inherited;
    new_nick := myNick;
    if (InputQueryW(sRoomNewNick, sRoomNewNick, new_nick)) then begin
        if (new_nick = myNick) then exit;
        changeNick(new_nick);
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popCloseClick(Sender: TObject);
begin
  inherited;
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRoom.popBookmarkClick(Sender: TObject);
var
    bm: TJabberBookmark;
    bm_name: WideString;
begin
  inherited;
    // bookmark this room..
    bm_name := Self.jid;

    if (inputQueryW(sRoomBMPrompt, sRoomNewBookmark, bm_name)) then begin
        bm := TJabberBookmark.Create(nil);
        bm.jid := TJabberID.Create(Self.jid);
        bm.bmType := 'conference';
        bm.nick := myNick;
        bm.bmName := bm_name;
        MainSession.roster.AddBookmark(bm.jid.full, bm);
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popInviteClick(Sender: TObject);
begin
  inherited;
    ShowInvite(Self.jid, TWideStringList(nil));
end;

{---------------------------------------}
function TfrmRoom.GetNick(rjid: Widestring): Widestring;
var
    i: integer;
begin
    // Get a nick based on the NickJID
    i := _roster.indexOf(rjid);
    if (i >= 0) then
        Result := TRoomMember(_roster.Objects[i]).Nick
    else
        Result := '';
end;

{---------------------------------------}
function IsRoom(rjid: Widestring): boolean;
begin
    result := (room_list.IndexOf(rjid) >= 0);
end;

{---------------------------------------}
function FindRoom(rjid: Widestring): TfrmRoom;
var
    idx: integer;
begin
    // finds a room form given a jid.
    idx := room_list.IndexOf(rjid);
    if (idx >= 0) then
        Result := TfrmRoom(room_list.Objects[idx])
    else
        Result := nil;
end;

{---------------------------------------}
function FindRoomNick(rjid: Widestring): Widestring;
var
    i: integer;
    room: TfrmRoom;
    tmp_jid: TJabberID;
begin
    // find the proper nick
    Result := '';

    tmp_jid := TJabberID.Create(rjid);
    i := room_list.IndexOf(tmp_jid.jid);
    tmp_jid.Free();
    if (i < 0) then exit;

    room := TfrmRoom(room_list.Objects[i]);
    Result := room.GetNick(rjid);
end;

{---------------------------------------}
procedure TfrmRoom.mnuOnTopClick(Sender: TObject);
begin
  inherited;
    mnuOnTop.Checked := not mnuOnTop.Checked;

    if (mnuOnTop.Checked) then
        Self.FormStyle := fsStayOnTop
    else
        Self.FormStyle := fsNormal;
end;

{---------------------------------------}
procedure TfrmRoom.popRosterBlockClick(Sender: TObject);
var
    rm: TRoomMember;
begin
    inherited;
    rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
    if (rm <> nil) then begin
       if (rm.show = sBlocked) then begin
          //unblock
          rm.show := rm.blockShow;

          if rm.Show = 'away' then rm.Node.ImageIndex := ico_Away
          else if rm.Show = 'xa' then rm.Node.ImageIndex := ico_XA
          else if rm.Show = 'dnd' then rm.Node.ImageIndex := ico_DND
          else if rm.Show = 'chat' then rm.Node.ImageIndex := ico_Chat
          else rm.Node.ImageIndex := ico_Online;
      end
       else begin
          //block
          rm.blockShow := rm.show;
          rm.show := sBlocked;
          rm.Node.ImageIndex := ico_blocked;
      end;
   end;
end;

{---------------------------------------}
procedure TfrmRoom.popRoomRosterPopup(Sender: TObject);
var
    rm: TRoomMember;
begin
  rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
  if (rm <> nil) then begin
     if (rm.show = sBlocked) then
        popRosterBlock.Caption := sUnblock
     else
        popRosterBlock.Caption := sBlock;
 end;
  inherited;
end;

{---------------------------------------}
procedure TfrmRoom.FormResize(Sender: TObject);
begin
  inherited;
    // make the close btn right justified, and resize
    // the text box for the subject
    btnClose.Left := Panel1.Width - btnClose.Width - 2;
    lblSubject.Width := btnClose.Left - lblSubject.Left - 10;
    pnlSubj.Width := Panel1.Width - btnClose.Width - 5;
end;

{---------------------------------------}
procedure TfrmRoom.FormEndDock(Sender, Target: TObject; X, Y: Integer);
begin
  inherited;
    if (Docked and (Self.TabSheet <> nil)) then
        Self.TabSheet.ImageIndex := -1;

    btnClose.Visible := Docked;

    // scroll the MsgView to the bottom.
    _scrollBottom();
    Self.Refresh();
end;

{---------------------------------------}
procedure TfrmRoom.popShowHistoryClick(Sender: TObject);
begin
    inherited;
    ShowLog(Self.jid);
end;

{---------------------------------------}
procedure TfrmRoom.popClearHistoryClick(Sender: TObject);
begin
    inherited;
    ClearLog(Self.jid);
end;

{---------------------------------------}
procedure TfrmRoom.DockForm;
begin
    inherited;
    btnClose.Visible := true;
end;

{---------------------------------------}
procedure TfrmRoom.FloatForm;
begin
    inherited;
    btnClose.Visible := false;
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterDblClick(Sender: TObject);
var
    rm: TRoomMember;
    tmp_jid: TJabberID;
    chat_win: TfrmChat;
begin
  inherited;
    // start chat w/ room participant
    // Chat w/ this person..
    rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
    if (rm <> nil) then begin
        tmp_jid := TJabberID.Create(rm.jid);
        chat_win := StartChat(tmp_jid.jid, tmp_jid.resource, true, rm.Nick);
        if (chat_win.TabSheet <> nil) then
            frmExodus.Tabs.ActivePage := chat_win.TabSheet;
        tmp_jid.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
    // drag over
    Accept := (Source = frmRosterWindow.treeRoster);
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    r, n: TTreeNode;
    ritem: TJabberRosterItem;
    i,j: integer;
    jids: TWideStringList;
begin
  inherited;
    // drag drop
    if (Source = frmRosterWindow.treeRoster) then begin
        // We want to invite someone into this TC room
        jids := TWideStringList.Create;
        with frmRosterWindow.treeRoster do begin
            for i := 0 to SelectionCount - 1 do begin
                n := Selections[i];
                if ((n.Data <> nil) and (TObject(n.Data) is TJabberRosterItem)) then begin
                    ritem := TJabberRosterItem(n.Data);
                    jids.Add(ritem.jid.jid);
                end
                else if (n.Level = 0) then begin
                    for j := 0 to n.Count - 1 do begin
                        r := n.Item[j];
                        if ((r.Data <> nil) and (TObject(r.Data) is TJabberRosterItem)) then
                            jids.Add(TJabberRosterItem(r.Data).jid.jid);
                    end;
                end;
            end;
        end;
        ShowInvite(Self.jid, jids);
    end;
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
var
    m: TRoomMember;
begin
  inherited;
    m := TRoomMember(_rlist[Item.Index]);
    if (m = nil) then
        InfoTip := ''
    else begin
        InfoTip := m.show;
        if (m.status <> '') then
            InfoTip := InfoTip + ': ' + m.status;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popConfigureClick(Sender: TObject);
begin
  inherited;
    configRoom();
end;

{---------------------------------------}
procedure TfrmRoom.popKickClick(Sender: TObject);
var
    reason: WideString;
    iq, q: TXMLTag;
begin
  inherited;
    // Kick the selected participant
    if (lstRoster.SelCount = 0) then exit;

    if (Sender = popKick) then begin
        reason := sKickDefault;
        if (not InputQueryW(sKickReason, sKickReason, reason)) then exit;
    end
    else if (Sender = popBan) then begin
        reason := sBanDefault;
        if (not InputQueryW(sBanReason, sBanReason, reason)) then exit;
    end;

    iq := TXMLTag.Create('iq');
    iq.setAttribute('type', 'set');
    iq.setAttribute('id', MainSession.generateID());
    iq.setAttribute('to', jid);
    q := iq.AddTag('query');
    q.setAttribute('xmlns', XMLNS_MUCADMIN);

    if (Sender = popKick) then
        AddMemberItems(q, reason, MUC_NONE)
    else if (Sender = popBan) then
        AddMemberItems(q, reason, '', MUC_OUTCAST)
    else if (Sender = popOwner) then
        AddMemberItems(q, '', '', MUC_OWNER);

    MainSession.SendTag(iq);
end;

{---------------------------------------}
procedure TfrmRoom.AddMemberItems(tag: TXMLTag; reason: WideString = '';
    NewRole: WideString = ''; NewAffiliation: WideString = '');
var
    i: integer;
    rm: TRoomMember;
begin
    for i := 0 to lstRoster.Items.Count - 1 do begin
        if lstRoster.Items[i].Selected then begin
            with tag.AddTag('item') do begin
                rm := TRoomMember(_rlist[i]);
                setAttribute('nick', rm.Nick);
                if (NewRole <> '') then
                    setAttribute('role', NewRole);
                if (Reason <> '') then
                    AddBasicTag('reason', reason);
                if (NewAffiliation <> '') then
                    setAttribute('affiliation', NewAffiliation);
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popVoiceClick(Sender: TObject);
var
    iq, q: TXMLTag;
    i: integer;
    cur_member: TRoomMember;
    new_role: WideString;
begin
  inherited;
    // Toggle Voice
    if (lstRoster.SelCount = 0) then exit;

    iq := TXMLTag.Create('iq');
    iq.setAttribute('type', 'set');
    iq.setAttribute('id', MainSession.generateID());
    iq.setAttribute('to', jid);
    q := iq.AddTag('query');
    q.setAttribute('xmlns', XMLNS_MUCADMIN);

    // Iterate over all selected items, and toggle
    // voice by changing roles
    for i := 0 to lstRoster.Items.Count - 1 do begin
        if (lstRoster.Items[i].Selected) then begin
            // cur_member := TRoomMember(lstRoster.Items[i].Data);
            cur_member := TRoomMember(_rlist[i]);
            new_role := '';
            if (cur_member.role = MUC_PART) then
                new_role := MUC_VISITOR
            else if (cur_member.role = MUC_VISITOR) then
                new_role := MUC_PART;
            if (new_role <> '') then begin
                with q.AddTag('item') do begin
                    setAttribute('nick', cur_member.Nick);
                    setAttribute('role', new_role);
                end;
            end;
        end;
    end;

    MainSession.SendTag(iq);
end;

{---------------------------------------}
procedure TfrmRoom.popVoiceListClick(Sender: TObject);
begin
  inherited;
    // edit a list
    if (Sender = popVoiceList) then
        ShowRoomAdminList(self.jid, MUC_PART, '', sEditVoice)
    else if (Sender = popBanList) then
        ShowRoomAdminList(self.jid, '', MUC_OUTCAST, sEditBan)
    else if (Sender = popMemberList) then
        ShowRoomAdminList(self.jid, '', MUC_MEMBER, sEditMember)
    else if (Sender = popAdminList) then
        ShowRoomAdminList(self.jid, '', MUC_ADMIN, sEditAdmin)
    else if (Sender = popOwnerList) then
        ShowRoomAdminList(self.jid, '', MUC_OWNER, sEditOwner);
end;

{---------------------------------------}
procedure TfrmRoom.popDestroyClick(Sender: TObject);
var
    reason: WideString;
    iq, q, d: TXMLTag;
begin
  inherited;
    // Destroy Room
    if (MessageDlg(sDestroyRoomConfirm, mtConfirmation, [mbYes,mbNo], 0) = mrNo) then
        exit;
    reason := sDestroyDefault;
    if InputQueryW(sDestroyRoom, sDestroyReason, reason) = false then exit;

    iq := TXMLTag.Create('iq');
    iq.setAttribute('type', 'set');
    iq.setAttribute('id', MainSession.generateID());
    iq.setAttribute('to', jid);
    q := iq.AddTag('query');
    q.setAttribute('xmlns', XMLNS_MUCOWNER);
    d := q.AddTag('destroy');
    // xxx: alt-jid goes onto <destroy jid="newroom@server">
    d.AddBasicTag('reason', reason);
    MainSession.SendTag(iq);
end;

{---------------------------------------}
procedure TfrmRoom.selectNicks(wsl: TWideStringList);
var
    i, c: integer;
begin
    for i := 0 to wsl.Count - 1 do begin
        c := _roster.indexOf(Self.jid + '/' + wsl[i]);
        if (c >=0) then
            lstRoster.Items[c].Selected := true;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.FormDestroy(Sender: TObject);
var
    p: TJabberPres;
    i: integer;
begin
    // Unregister callbacks and send unavail pres.
    if (MainSession <> nil) then begin
        MainSession.UnRegisterCallback(_mcallback);
        MainSession.UnRegisterCallback(_ecallback);
        MainSession.UnRegisterCallback(_pcallback);
        MainSession.UnRegisterCallback(_scallback);

        if (MainSession.Invisible) then
            MainSession.removeAvailJid(jid);
    end;

    if ((MainSession <> nil) and (MainSession.Active)) then begin
        p := TJabberPres.Create();
        p.toJID := TJabberID.Create(jid);
        p.PresType := 'unavailable';
        MainSession.SendTag(p);
    end;

    _keywords.Free;
    ClearStringListObjects(_roster);
    _rlist.Clear();
    _roster.Free();
    _rlist.Free();

    i := room_list.IndexOf(jid);
    if (i >= 0) then
        room_list.Delete(i);

    inherited;
end;

{---------------------------------------}
procedure TfrmRoom.mnuWordwrapClick(Sender: TObject);
begin
    inherited;
    mnuWordwrap.Checked := not mnuWordWrap.Checked;
    _wrap_input := mnuWordwrap.Checked;
    MsgOut.WordWrap := _wrap_input;
    MainSession.Prefs.setBool('wrap_input', _wrap_input);
end;

{---------------------------------------}
procedure TfrmRoom.NotificationOptions1Click(Sender: TObject);
var
    f: TfrmCustomNotify;
begin
    // change notification options..
    f := TfrmCustomNotify.Create(Application);

    f.addItem('Room activity');
    f.addItem('Keywords');
    f.setVal(0, _notify[0]);
    f.setVal(1, _notify[1]);

    if (f.ShowModal) = mrOK then begin
        _notify[0] := f.getVal(0);
        _notify[1] := f.getVal(1);

        if ((_notify[1] <> 0) and (_keywords = nil)) then
            setupKeywords();
    end;

    f.Free();
end;

{---------------------------------------}
procedure TfrmRoom.S1Click(Sender: TObject);
var
    fn     : widestring;
    ext    : widestring;
    fmt : TOutputFormat;
begin
    dlgSave.FileName := MungeName(self.jid);
    if (not dlgSave.Execute()) then exit;
    fn := dlgSave.FileName;
    ext := copy(fn, length(fn) - 2, 3);

    fmt := MsgList.OutputFormat;
    if (ext = 'rtf') then
        MsgList.OutputFormat := ofRTF
    else if (ext = 'txt') then
        MsgList.OutputFormat := ofUnicode;
    MsgList.WideLines.SaveToFile(fn);
    MsgList.OutputFormat := fmt;
end;

{---------------------------------------}
procedure TfrmRoom.pluginMenuClick(Sender: TObject);
begin
    TExodusChat(COMController).fireMenuClick(Sender);
end;

{---------------------------------------}
procedure TfrmRoom.Message1Click(Sender: TObject);
var
    rm: TRoomMember;
    tmp_jid: TJabberID;
begin
  inherited;
    // start chat w/ room participant
    // Chat w/ this person..
    rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
    if (rm <> nil) then begin
        tmp_jid := TJabberID.Create(rm.jid);
        StartMsg(tmp_jid.full);
        tmp_jid.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.SendmyJID1Click(Sender: TObject);
var
    rm: TRoomMember;
    ri: TJabberRosterItem;
    itms: TList;
begin
  inherited;
    // Send my JID to this user
    rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
    if (rm <> nil) then begin
        ri := MainSession.Roster.Find(MainSession.BareJid);
        itms := TList.Create();
        itms.Add(ri);
        jabberSendRosterItems(rm.jid, itms);
        itms.Clear();
        itms.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterData(Sender: TObject; Item: TListItem);
var
    rm: TRoomMember;
begin
  inherited;
    // get the data for this person..
    rm := TRoomMember(_rlist[Item.Index]);
    Item.Caption := rm.Nick;
    if rm.show = 'away' then Item.ImageIndex := 2
    else if rm.show = 'xa' then Item.ImageIndex := 10
    else if rm.show = 'dnd' then Item.ImageIndex := 3
    else if rm.show = 'chat' then Item.ImageIndex := 4
    else Item.ImageIndex := 1;

end;

{---------------------------------------}
function ItemCompare(Item1, Item2: Pointer): integer;
var
    m1, m2: TRoomMember;
    s1, s2: Widestring;
begin
    // compare 2 items..
    m1 := TRoomMember(Item1);
    m2 := TRoomMember(Item2);

    s1 := m1.Nick;
    s2 := m2.Nick;

    Result := AnsiCompareText(s1, s2);
end;


initialization
    // list for all of the current rooms
    room_list := TWideStringlist.Create();

    // pre-compile some xpath's
    xp_muc_presence := TXPLite.Create('/presence/x[@xmlns="' + XMLNS_MUCUSER + '"]');
    xp_muc_status := TXPLite.Create('//x[@xmlns="' + XMLNS_MUCUSER + '"]/status');
    xp_muc_item := TXPLite.Create('//x[@xmlns="' + XMLNS_MUCUSER + '"]/item');
    xp_muc_reason := TXPLite.Create('//x[@xmlns="' + XMLNS_MUCUSER + '"]/reason');

finalization
    xp_muc_reason.Free();
    xp_muc_item.Free();
    xp_muc_status.Free();
    xp_muc_presence.Free();
    room_list.Free();

end.
