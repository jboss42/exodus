unit Room;
{
    Copyright 2002, Peter Millard

    This file is part of Exodus.

    Exodus is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
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
    RichEdit2, TntStdCtrls, Buttons, TntComCtrls, Grids, TntGrids, TntMenus,
    JabberID, TntSysUtils, TntWideStrUtils, ToolWin, ImgList, JabberMsg;

type
  TMemberNode = TTntListItem;
  TRoomMember = class
  private
    _real_jid: TJabberID;

    function  getRealJID(): WideString;
    function  getRealDisplayJID(): WideString;
    procedure setRealJID(jid: WideString);

  public
    Nick: Widestring;
    jid: Widestring;
    Node: TMemberNode;
    status: Widestring;
    show: Widestring;
    blockShow: Widestring;
    role: WideString;
    affil: WideString;
    destructor Destroy(); override;
  published
    property real_jid: WideString read getRealJID write setRealJID;
  end;

  TfrmRoom = class(TfrmBaseChat)
    Panel6: TPanel;
    Splitter2: TSplitter;
    popRoom: TTntPopupMenu;
    popRoomRoster: TTntPopupMenu;
    lstRoster: TTntListView;
    dlgSave: TSaveDialog;
    N6: TTntMenuItem;
    popClose: TTntMenuItem;
    mnuOnTop: TTntMenuItem;
    mnuWordwrap: TTntMenuItem;
    NotificationOptions1: TTntMenuItem;
    N1: TTntMenuItem;
    popAdmin: TTntMenuItem;
    S1: TTntMenuItem;
    popNick: TTntMenuItem;
    popInvite: TTntMenuItem;
    popRegister: TTntMenuItem;
    popBookmark: TTntMenuItem;
    popClear: TTntMenuItem;
    popAdministrator: TTntMenuItem;
    popModerator: TTntMenuItem;
    popVoice: TTntMenuItem;
    popBan: TTntMenuItem;
    popKick: TTntMenuItem;
    N3: TTntMenuItem;
    popRosterBlock: TTntMenuItem;
    popRosterSendJID: TTntMenuItem;
    popRosterChat: TTntMenuItem;
    popRosterMsg: TTntMenuItem;
    popDestroy: TTntMenuItem;
    popConfigure: TTntMenuItem;
    N5: TTntMenuItem;
    popOwnerList: TTntMenuItem;
    popAdminList: TTntMenuItem;
    N4: TTntMenuItem;
    popModeratorList: TTntMenuItem;
    popMemberList: TTntMenuItem;
    popBanList: TTntMenuItem;
    popVoiceList: TTntMenuItem;
    popRosterSubscribe: TTntMenuItem;
    popRosterVCard: TTntMenuItem;
    N7: TTntMenuItem;
    popRosterBrowse: TTntMenuItem;
    popCopy: TTntMenuItem;
    popCopyAll: TTntMenuItem;
    N8: TTntMenuItem;
    Print1: TTntMenuItem;
    PrintDialog1: TPrintDialog;
    pnlSubj: TPanel;
    lblSubject: TTntLabel;
    SpeedButton1: TSpeedButton;

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
    procedure popRoomRosterPopup(Sender: TObject);
    procedure popShowHistoryClick(Sender: TObject);
    procedure popClearHistoryClick(Sender: TObject);
    procedure lstRosterDblClick(Sender: TObject);
    procedure lstRosterInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
    procedure popConfigureClick(Sender: TObject);
    procedure popKickClick(Sender: TObject);
    procedure popVoiceClick(Sender: TObject);
    procedure popVoiceListClick(Sender: TObject);
    procedure popDestroyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuWordwrapClick(Sender: TObject);
    procedure NotificationOptions1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure popRosterMsgClick(Sender: TObject);
    procedure popRosterSendJIDClick(Sender: TObject);
    procedure lstRosterData(Sender: TObject; Item: TListItem);
    procedure popRegisterClick(Sender: TObject);
    procedure sendStartPresence();
    procedure lstRosterKeyPress(Sender: TObject; var Key: Char);
    procedure lstRosterCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure popRosterSubscribeClick(Sender: TObject);
    procedure popRosterVCardClick(Sender: TObject);
    procedure popRosterBrowseClick(Sender: TObject);
    procedure popCopyClick(Sender: TObject);
    procedure popCopyAllClick(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure MsgOutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MsgOutKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    { Private declarations }
    jid: Widestring;            // jid of the conf. room
    _roster: TWideStringlist;   // roster for this room
    _rlist: TList;              // Data storage for the virtual listview
    _isMUC: boolean;            // Is this room JEP-45
    _mcallback: integer;        // Message Callback
    _ecallback: integer;        // Error msg callback
    _pcallback: integer;        // Presence Callback
    _scallback: integer;        // Session callback
    _dcallback: integer;
    _keywords: TRegExpr;        // list of keywords to monitor for
    _hint_text: Widestring;     // Current hint for nickname
    _old_nick: WideString;      // Our own last nickname
    _passwd: WideString;        // Room password
    _disconTime: TDateTime;     // Date/Time that we last got disconnected, local TZ
    _default_config: boolean;   // auto-accept the default room configuration.
    _sent_initial_presence:boolean;//did we send presence on creation? (used for room presistence)
    _subject: WideString;
    _send_unavailable: boolean;
    _custom_pres: boolean;
    _pending_start: boolean;
    _pending_destroy: boolean;  // if user is destroying room
    _passwd_from_join_room: boolean; //was the password supplied by the Join Room DLG.

    _my_membership_role: WideString; // My membership to the room.

    // Stuff for nick completions
    _nick_prefix: Widestring;
    _nick_idx: integer;
    _nick_len: integer;
    _nick_start: integer;

    _notify: array[0..2] of integer;

    function  checkCommand(txt: Widestring): boolean;
    function _countPossibleNicks(tmps: Widestring): integer;
    function _selectNick(wsl: TWidestringlist): Widestring;

    procedure _sendPresence(ptype, msg: Widestring; fireClose: boolean=true);

    procedure SetJID(sjid: Widestring);
    procedure SetPassword(pass: WideString);
    procedure RenderMember(member: TRoomMember; tag: TXMLTag);
    procedure changeSubject(subj: Widestring);
    procedure configRoom(use_default: boolean = false);
    procedure AddMemberItems(tag: TXMLTag; reason: WideString = '';
        NewRole: WideString = ''; NewAffiliation: WideString = '');
    procedure showStatusCode(t: TXMLTag);
    procedure selectNicks(wsl: TWideStringList);

    function newRoomMessage(body: Widestring): TXMLTag;
    procedure changeNick(new_nick: WideString);
    procedure setupKeywords();
    procedure _EnableSubjectButton();
  protected
    {
        Get the window state associated with this window.

        Default implementation is to return a munged classname (all XML illgal
        characters escaped). Classes should override to change pref (for instance
        chat windows might save based on munged profile&jid).
    }
    function GetWindowStateKey() : WideString;override;
  published
    procedure MsgCallback(event: string; tag: TXMLTag);
    procedure PresCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure ConfigCallback(event: string; Tag: TXMLTag);
    procedure EntityCallback(event: string; tag: TXMLTag);
    procedure autoConfigCallback(event: string; tag: TXMLTag);
    procedure roomuserCallback(event: string; tag: TXMLTag);

    class procedure AutoOpenFactory(autoOpenInfo: TXMLTag); override;
    function GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;override;

  public
    { Public declarations }
    mynick: Widestring;
    useRegisteredNick: boolean;
    COMController: TObject;

    procedure SendMsg; override;
    procedure pluginMenuClick(Sender: TObject); override;

    procedure ShowMsg(tag: TXMLTag);
    procedure SendRawMessage(body, subject, xml: Widestring; fire_plugins: boolean; priority: PriorityType = None);

    function addRoomUser(jid, nick: Widestring): TRoomMember;
    procedure removeRoomUser(jid: Widestring);
    function GetNick(rjid: Widestring): Widestring;

    property HintText: Widestring read _hint_text;
    property getJid: WideString read jid;
    property isMUCRoom: boolean read _isMUC;
    property UseDefaultConfig: boolean read _default_config write _default_config;

    procedure OnDockedDragOver(Sender, Source: TObject; X, Y: Integer;
                               State: TDragState; var Accept: Boolean);override;
    procedure OnDockedDragDrop(Sender, Source: TObject; X, Y: Integer);override;

    {
        Event fired when docking is complete.

        Docked property will be true, tabsheet will be assigned. This event
        is fired after all other docking events are complete.
    }
    procedure OnDocked();override;

    {
        Event fired when a float (undock) is complete.

        Docked property will be false, tabsheet will be nil. This event
        is fired after all other floating events are complete.
    }
    procedure OnFloat();override;
  end;

var
  frmRoom: TfrmRoom;

  room_list: TWideStringList;

  xp_muc_presence: TXPLite;
  xp_muc_status: TXPLite;
  xp_muc_item: TXPLite;
  xp_muc_reason: TXPLite;
  xp_muc_destroy_reason: TXPLite;
  
const
    sRoom = '%s'; // Room';
    sNotifyKeyword = 'Keyword in ';
    sNotifyActivity = 'Activity in ';
    sPriorityNotifyActivity = 'Priority activity in ';
    sRoomSubjChange = '/me has changed the subject to: ';
    sRoomSubjPrompt = 'Change conference room subject';
    sRoomNewSubj = 'New subject';
    sRoomNewNick = 'New nickname';
    sRoomBMPrompt = 'Bookmark Conference Room';
    sRoomNewBookmark = 'Enter bookmark name:';
    sBlocked = 'Blocked';
    sBlock = 'Block';
    sUnblock = 'UnBlock';
    sUnknownFileType = 'Unknown file type';
    sReconnected = 'Reconnected.';


    sDestroyRoom = 'Destroy Conferene Room';
    sKickReason = 'Kick Reason';
    sBanReason = 'Ban Reason';
    sDestroyReason = 'Destroy Reason';
    sKickDefault = 'You have been kicked.';
    sBanDefault = 'You have been banned.';
    sDestroyDefault = 'The owner has destroyed the room.';

    sGrantVoice = 'You have been granted voice.';
    sRevokeVoice = 'Your voice has been revoked.';
    sNoVoice = 'You are not allowed to speak in this room.';
    sCurModerator = 'You are currently a moderator of this room.';

    sNewUser = '%s has entered the room.';
    sUserLeave = '%s has left the room.';
    sNewRole = '%s has a new role of %s.';

    sRoomDestroyed = 'The conference room ''%s'' has been destroyed.';
    sReason = 'Reason:';
    sDestroyRoomConfirm = 'Do you really want to destroy the conference room? All users will be removed.';

    sStatus_100  = 'This conference room is not anonymous';
    sStatus_301  = '%s has been banned from this conference room. %s';
    sStatus_302  = 'This conference room has been destroyed.';
    sStatus_303  = '%s is now known as %s.';
    sStatus_307  = '%s has been kicked from this conference room. %s';
    sStatus_322  = '%s is not a member of this conference room and has therefore been removed from this conference room.';

    sStatus_401  = 'You supplied an invalid password to enter this room.';
    sStatus_403  = 'You are not allowed to enter this conference room because you are on the ban list.';
    sStatus_404  = 'The conference room is being created. Please try again later.';
    sStatus_405  = 'You are not allowed to create conference rooms.';
    sStatus_405a = 'You are not allowed to enter the conference room.';
    sStatus_407  = 'You are not on the member list for this conference room. Try and register?';
    sStatus_409  = 'Your nickname is already being used. Please select another one.';
    sStatus_413  = 'The conference room you were trying to enter is at maximum occupancy. Try again later.';
    sStatus_Unknown = 'The conference room has been destroyed for an unknown reason.';

    sEditVoice     = 'Edit Voice List';
    sEditBan       = 'Edit Ban List';
    sEditMember    = 'Edit Member List';
    sEditAdmin     = 'Edit Admin List';
    sEditOwner     = 'Edit Owner List';
    sEditModerator = 'Edit Moderator List';

    sNoSubjectHint = 'Click the button to change the room subject.';
    sNoSubject     = 'No conference room subject';
    sMsgRosterItems = 'This message contains %d roster items.';

const
    MUC_OWNER = 'owner';
    MUC_ADMIN = 'admin';
    MUC_MEMBER = 'member';
    MUC_OUTCAST = 'outcast';

    MUC_MOD = 'moderator';
    MUC_PART = 'participant';
    MUC_VISITOR = 'visitor';
    MUC_NONE = 'none';

    ROOM_TIMEOUT = 3;

    NOTIFY_ROOM_ACTIVITY = 0;
    NOTIFY_KEYWORD = 1;
    NOTIFY_PRIORITY_ROOM_ACTIVITY = 2;
    
function FindRoom(rjid: Widestring): TfrmRoom;
function StartRoom(rjid: Widestring; rnick: Widestring = '';
    Password: WideString = ''; send_presence: boolean = true;
    default_config: boolean = false; use_registered_nick: boolean = false;
    bring_to_front:boolean=true): TfrmRoom;
function IsRoom(rjid: Widestring): boolean;
function FindRoomNick(rjid: Widestring): Widestring;
procedure CloseAllRooms();


{---------------------------------------}
function ItemCompare(Item1, Item2: Pointer): integer;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Browser,
    CapPresence,
    ChatWin, COMChatController, CustomNotify,
    ExSession, JabberUtils, ExUtils, Entity, EntityCache,  
    GnuGetText,
    InputPassword,
    Invite,
    IQ,
    Jabber1,
    JabberConst,
    JoinRoom,
    MsgDisplay,
    MsgRecv,
    NodeItem,
    Notify,
    PrefController,
    Presence,
    Profile,
    PrtRichEdit, RTFMsgList, BaseMsgList,
    RegForm,
    RichEdit,
    RiserWindow,
    RoomAdminList,
    Roster,
    RosterImages, 
    RosterWindow,
    Session,
    ShellAPI,
    Signals,
    StrUtils,
    xData,
    XMLNode,
    XMLUtils,
    KeyWords;

{$R *.DFM}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function StartRoom(rjid: Widestring; rnick, Password: Widestring;
    send_presence, default_config, use_registered_nick: boolean;
    bring_to_front:boolean): TfrmRoom;
var
    f: TfrmRoom;
    tmp_jid: TJabberID;
    i : integer;
    n: Widestring;
begin
    Result := nil;

    // Make sure we have TC..
    if (not MainSession.Prefs.getBool('brand_muc')) then exit;
    // is there already a room window?
    i := room_list.IndexOf(rjid);
    if (i >= 0) then
        f := TfrmRoom(room_list.Objects[i])
    else begin
        // Find out nick..

        if (MainSession.Prefs.getBool('brand_prevent_change_nick') or (rnick = '')) then
            n := MainSession.Profile.getDisplayUsername()
        else
            n := rnick;

        // create a new room
        f := TfrmRoom.Create(Application);
        f.SetJID(rjid);

        if (MainSession.Prefs.getBool('brand_prevent_change_nick')) then
            f.useRegisteredNick := false
        else
            f.useRegisteredNick := use_registered_nick;
            
        f.MyNick := n;
        tmp_jid := TJabberID.Create(rjid);
        f.SetPassword(Password);
        f.UseDefaultConfig := default_config;

        if (send_presence) then
            f.sendStartPresence();

        f.Caption := tmp_jid.userDisplay; //no display name here for room names
        
        // setup prefs
        with f do begin
            lstRoster.Color := TColor(MainSession.Prefs.getInt('color_bg'));
            lstRoster.Font.Name := MainSession.Prefs.getString('roster_font_name');
            lstRoster.Font.Color := TColor(MainSession.Prefs.getInt('font_color'));
            lstRoster.Font.Size := MainSession.Prefs.getInt('roster_font_size');
            lstRoster.Font.Charset := MainSession.Prefs.getInt('roster_font_charset');
            if (lstRoster.Font.Charset = 0) then
                lstRoster.Font.Charset := DEFAULT_CHARSET;
        end;

        // let the plugins know about the new room
        ExComController.fireNewRoom(tmp_jid.jid, TExodusChat(f.ComController));

        room_list.AddObject(rjid, f);
        tmp_jid.Free();
    end;

    f.ShowDefault(bring_to_front);

    Result := f;
end;

class procedure TfrmRoom.AutoOpenFactory(autoOpenInfo: TXMLTag);
begin
    StartRoom(autoOpenInfo.getAttribute('j'), {jid}
              autoOpenInfo.getAttribute('n'), {nick}
              autoOpenInfo.getAttribute('p'), {password}
              true, //autoOpenInfo.GetAttribute('sp') = 't', {send presence on creation}
              autoOpenInfo.GetAttribute('dc') = 't', {use default config}
              autoOpenInfo.GetAttribute('rn') = 't', {use registered nickname}
              false); //don't bring these to front
end;

function TfrmRoom.GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;
var
 bm: TXMLTag;                                 
begin
    //don't auto-open rooms we have bookmoarked for join on login
    bm := MainSession.Bookmarks.FindBookmark(getJID);
    if ((event = 'disconnected') and ((bm = nil) or (bm.GetAttribute('autojoin') <> 'true'))) then begin
        //check to see if this room is bokmarked and join on startup
        Result := TXMLTag.Create(Self.classname);
        Result.setAttribute('j', getJID);
        Result.setAttribute('n', mynick);
        if (_passwd <> '') then
            Result.setAttribute('p', _passwd);
        if (_sent_initial_presence) then
            Result.setAttribute('sp', 't');
//        if (_default_config) then
            Result.setAttribute('dc', 't'); //if config is needed, just open
        if (useRegisteredNick) then
            Result.setAttribute('rn', 't');
        useProfile := true;
    end
    else Result := inherited GetAutoOpenInfo(event, useProfile);
end;

function TfrmRoom.GetWindowStateKey() : WideString;
begin
    //todo jjf remove profile from this state key once prefs are profile aware
    Result := inherited GetWindowStateKey() + '-' + MungeName(MainSession.Profile.Name) + '-' + MungeName(Self.jid);
end;

{---------------------------------------}
procedure TfrmRoom.MsgCallback(event: string; tag: TXMLTag);
var
    body, xml: Widestring;
begin
    // plugin
    xml := tag.xml();
    body := tag.GetBasicText('body');
    if not (TExodusChat(ComController).fireBeforeRecvMsg(body, xml)) then
        exit;

    // We are getting a msg
    if (tag.getAttribute('type') = 'groupchat') then
        ShowMsg(tag)
    else if (tag.getAttribute('type') = 'error') then
        ShowMsg(tag);

    TExodusChat(ComController).fireAfterRecvMsg(body);
end;

{---------------------------------------}
procedure TfrmRoom.showMsg(tag: TXMLTag);
var
    i : integer;
    Msg: TJabberMessage;
    emsg, from: Widestring;
    tmp_jid: TJabberID;
    server: boolean;
    rm: TRoomMember;
    etag: TXMLTag;
    e: TJabberEntity;
begin
    // display the body of the msg
    Msg := TJabberMessage.Create(tag);

    if (Msg.isXdata) then exit;
    if (Msg.Time < _disconTime) then exit;

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
        if (Msg.Nick = MyNick) then
            Msg.IsMe := true
        else
            Msg.IsMe := false;
        server := true;

        if (tag.getAttribute('type') = 'error') then begin
            etag := tag.GetFirstTag('error');
            if (etag <> nil) then begin
                emsg := etag.QueryXPData('/error/text[@xmlns="urn:ietf:params:xml:ns:xmpp-streams"]');
                if (emsg = '') then
                    emsg := etag.Data;
                if (emsg = '') and
                    ((etag.GetAttribute('code') = '403') or
                     (etag.GetAttribute('code') = '401')) and
                    (etag.GetAttribute('type') = 'auth') then
                    emsg := _('Not authorized.');
                if (emsg = '') then
                    emsg := _('Your message to the room bounced.');
                Msg.Body := _('ERROR: ') + emsg;
            end
            else
                Msg.Body := _('ERROR: ') + _('Your message to the room bounced.');
            DisplayMsg(Msg, MsgList);
            exit;
        end;
        
        // Room config update?
        etag := tag.GetFirstTag('x');
        if (etag <> nil) and
           (etag.GetAttribute('xmlns') = XMLNS_MUCUSER) then begin
            etag := etag.GetFirstTag('status');
            if (etag <> nil) and
               (etag.GetAttribute('code') = '104') then begin
                // We did get a room update notification.
                // Need to disco.
                e := jEntityCache.getByJid(Self.jid, '');
                // e can be null, not doing this check can cause crashes
                if ( e <> nil ) then
                	e.refresh(MainSession);
            end;
        end;

    end
    else begin
        rm := TRoomMember(_roster.Objects[i]);
        // if blocked ignore anything they say, even subject changes.
        if (rm.Show = _(sBlocked)) then
           exit;
        Msg.Nick := rm.Nick;
        Msg.IsMe := (Msg.Nick = MyNick);
        server := false;
    end;

    // this check is needed only to prevent extraneous regexing.
    if ((not server) and (not MainSession.IsPaused)) then begin
        // check for keywords
        if ((_keywords <> nil) and (_keywords.Exec(Msg.Body))) then begin
            DoNotify(Self, _notify[NOTIFY_KEYWORD],
                     _(sNotifyKeyword) + Self.Caption + ': ' + _keywords.Match[1],
                     RosterTreeImages.Find('conference'), 'notify_keyword');
            Msg.highlight := true;
        end
        else if (not Msg.IsMe) and ((Msg.FromJID <> self.jid) or (Msg.Subject <> '')) and (Msg.Tag.QueryXPTag(XP_MSGDELAY) = nil) then
          if (((Msg.Priority = High) or (Msg.Priority = Low)) and (_notify[NOTIFY_PRIORITY_ROOM_ACTIVITY] > 0)) then
            DoNotify(Self, _notify[NOTIFY_PRIORITY_ROOM_ACTIVITY],
                     GetDisplayPriority(Msg.Priority) + ' ' + _(sPriorityNotifyActivity) + Self.Caption,
                     RosterTreeImages.Find('conference'), 'notify_priority_roomactivity')
          else
            DoNotify(Self, _notify[NOTIFY_ROOM_ACTIVITY],
                     _(sNotifyActivity) + Self.Caption,
                     RosterTreeImages.Find('conference'), 'notify_roomactivity');
    end;

    if (Msg.Subject <> '') then begin
        _subject := Msg.Subject;
        if (_subject = '') then begin
            if (SpeedButton1.Enabled = false) then
              lblSubject.Hint := ''
            else
              lblSubject.Hint := _(sNoSubjectHint);
            lblSubject.Caption := _(sNoSubject);
        end
        else begin
           if (SpeedButton1.Enabled = false) then
              lblSubject.Hint := ''
            else
              lblSubject.Hint := Tnt_WideStringReplace(_subject, '|', Chr(13),[rfReplaceAll, rfIgnoreCase]);
            lblSubject.Caption := Tnt_WideStringReplace(_subject, '&', '&&',[rfReplaceAll, rfIgnoreCase]);
            Msg.Body := _(sRoomSubjChange) + Msg.Subject;
            DisplayMsg(Msg, MsgList);
        end;
    end
    else if (Msg.Body <> '') then begin
        DisplayMsg(Msg, MsgList);

        // log if we have logs for TC turned on.
        Msg.isMe := False;
        LogMessage(Msg);

        if (GetActiveWindow = Self.Handle) and (MsgOut.Visible) then
            MsgOut.SetFocus();
    end;


    Msg.Free();
end;

{---------------------------------------}
procedure TfrmRoom.SendRawMessage(body, subject, xml: Widestring; fire_plugins: boolean; priority: PriorityType);
var
    add_xml: Widestring;
    msg: TJabberMessage;
    mtag: TXMLTag;
begin
    //
    msg := TJabberMessage.Create(jid, 'groupchat', body, Subject, priority);
    msg.nick := MyNick;
    msg.isMe := true;
    msg.ID := MainSession.generateID();

    // additional plugin madness


    if (fire_plugins) then begin
        add_xml := TExodusChat(ComController).fireAfterMsg(body);
        msg.Body := body;
    end;
    mtag := msg.Tag;

    if (add_xml <> '') then
      mtag.addInsertedXML(add_xml);

    if (xml <> '') then
        mtag.AddInsertedXML(xml);

    MainSession.SendTag(mtag);
    msg.Free();
end;

{---------------------------------------}
procedure TfrmRoom.SendMsg;
var
    allowed: boolean;
    txt: Widestring;
    xhtml: TXMLTag;
    xml: Widestring;
    priority: PriorityType;
//    e: TJabberEntity;
begin
    // Send the actual message out
    txt := getInputText(MsgOut);

    // plugin madness
    //-SIG-SIG-SIG-SIG-SIG-SIG-SIG-SIG-SIG-SIG-SIG-SIG
    if (ComController <> nil) then
      allowed := TExodusChat(ComController).fireBeforeMsg(txt)
    else
      allowed := true;

    if ((allowed = false) or (txt = '')) then exit;
    //-SIG-SIG-SIG-SIG-SIG-SIG-SIG-SIG-SIG-SIG-SIG-SIG

    if (txt[1] = '/') then begin
        if (checkCommand(txt)) then
            exit;
    end;

    xml := '';

 
    
//make sure room supports xhtml-im before sending     
    if (mainSession.Prefs.getBool('richtext_enabled')) then begin
//        e := jEntityCache.getByJid(Self.jid, '');
//        if ((e <> nil) and e.hasFeature(JabberConst.XMLNS_XHTMLIM)) then begin
            xhtml := getInputXHTML(MsgOut);
            if (xhtml <> nil) then
                xml := xhtml.XML;
//        end;
    end;

    if (MainSession.Prefs.getBool('show_priority')) then
       priority := PriorityType(GetValuePriority(cmbPriority.Text))
    else
       priority := none;

    SendRawMessage(txt, '', xml, true, priority);

    inherited;
end;

{---------------------------------------}
function TfrmRoom._countPossibleNicks(tmps: Widestring): integer;
var
    m: TRoomMember;
    r, i: integer;
begin
    r := 0;
    for i := 0 to _rlist.Count - 1 do begin
        m := TRoomMember(_rlist[i]);
        if (Pos(tmps, m.Nick) = 0) then inc(r);
    end;
    Result := r;
end;

{---------------------------------------}
function TfrmRoom._selectNick(wsl: TWidestringlist): Widestring;
var
    nick, tmps, last: Widestring;
    r: integer;
begin
    // icky, since nicks can have spaces... just look until we find one.
    nick := '';
    tmps := '';
    last := '';
    repeat
        if (tmps <> '') then tmps := tmps + ' ';
        tmps := tmps + wsl[0];
        wsl.Delete(0);
        r := _countPossibleNicks(tmps);
        if (r = 1) then
            // we have just a single match
            nick := tmps
        else if (r > 1) then
            // we have more than one possible
            last := tmps
        else if (last <> '') and (r = 0) then
            // the last one matched many, but this one matches none...
            // just use the last
            nick := tmps;
    until (nick <> '') or (wsl.Count = 0);

    Result := nick;
end;

{---------------------------------------}
procedure TfrmRoom._sendPresence(ptype, msg: Widestring; fireClose: boolean);

var
    p: TJabberPres;
begin
    p := TCapPresence.Create();
    p.toJID := TJabberID.Create(jid + '/' + mynick);

    if (ptype = 'unavailable') then
        p.PresType := ptype
    else
        p.Show := ptype;

    p.Status := msg;

    MainSession.SendTag(p);

    if (ptype = 'unavailable') then begin
        _send_unavailable := false;
        TExodusChat(ComController).fireClose();
        if (fireClose) then
            Self.Close();
    end;
end;

{---------------------------------------}
function TfrmRoom.checkCommand(txt: Widestring): boolean;
var
    tmps, nick, cmd: Widestring;
    rest: Widestring;
    wsl: TWideStringList;
    m: TJabberMessage;
    i, c: integer;
    j: TJabberID;
    s: TXMLTag;
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
        msgList.Clear();
        Result := true;
    end
    else if (cmd = '/config') then begin
        configRoom();
        Result := true;
    end
    else if (cmd = '/help') then begin
        m := TJabberMessage.Create(self.jid, 'groupchat',
        '/ commands: '#13#10 +
        '/clear'#13#10 +
        '/config'#13#10 +
        '/subject <subject>'#13#10 +
        '/invite <jid>'#13#10 +
        '/block <nick>'#13#10 +
        '/ignore <nick>'#13#10 +
        '/kick <nick>'#13#10 +
        '/ban <nick>'#13#10 +
        '/nick <nick>'#13#10 +
        '/chat <nick>'#13#10 +
        '/query <nick>'#13#10 +
        '/msg <nick>'#13#10 +
        '/join <room@server/nick>'#13#10 +
        '/leave <msg>'#13#10 +
        '/part <msg>'#13#10 +
        '/partall <msg>'#13#10 +
        '/voice <nick>'#13#10 +
        '/away <msg>'#13#10 +
        '/xa <msg>'#13#10 +
        '/dnd <msg>'#13#10, '');
        DisplayMsg(m, MsgList);
        m.Destroy();
        Result := true;
    end
    else if (cmd = '/nick') then begin
        // change nickname
        if (rest = '') then exit;
        if (not MainSession.Prefs.getBool('brand_prevent_change_nick')) then
            changeNick(rest);
        Result := true;
    end
    else if ((cmd = '/chat') or (cmd = '/query')) then begin
        // chat with this user
        nick := _selectNick(wsl);
        if (nick = '') then exit;
        StartChat(self.jid, nick, true, nick);
        Result := true;
    end
    else if (cmd = '/msg') then begin
        // send a msg to this person:
        // /msg foo this is the actual msg to send.
        nick := _selectNick(wsl);
        if ((nick = '') or (wsl.Count = 0)) then exit;

        tmps := '';
        for i := 0 to wsl.count - 1 do
            tmps := tmps + wsl[i] + ' ';

        nick := self.jid + '/' + nick;
        m := TJabberMessage.Create(nick, 'normal', tmps,
            _('Groupchat private message'));
        // XXX: do we want to do plugin stuff for priv msgs?
        MainSession.SendTag(m.Tag);
        m.Free();
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
    else if ((cmd = '/block') or (cmd = '/ignore')) then begin
        selectNicks(wsl);
        popRosterBlockClick(nil);
        Result := true;
    end
    else if ((cmd = '/part') or (cmd = '/leave')) then begin
        tmps := '';
        for i := 0 to wsl.count - 1 do
            tmps := tmps + wsl[i] + ' ';
        _sendPresence('unavailable', tmps);
        Result := true;
    end
    else if (cmd = '/join') then begin
        // join a new room
        tmps := wsl[0];
        j := TJabberID.Create(tmps);
        if (j.resource = '') then
            nick := mynick
        else
            nick := j.Resource;

        // If they specified no room, show the GUI, otherwise, just join
        if (j.user = '') then
            StartJoinRoom(j, nick, '')
        else
            StartRoom(j.jid, j.resource);
        j.Free();
        Result := true;
    end
    else if (cmd = '/partall') then begin
        // close all rooms??
        tmps := '';
        for i := 0 to wsl.count - 1 do
            tmps := tmps + wsl[i] + ' ';
        s := TXMLTag.Create('partall');
        s.AddCData(tmps);
        MainSession.FireEvent('/session/close-rooms', s);
        s.Free();
        Result := true;
    end
    else if ((cmd = '/away') or (cmd = '/xa') or (cmd = '/dnd')) then begin
        tmps := '';
        for i := 0 to wsl.count - 1 do
            tmps := tmps + wsl[i] + ' ';

        tmps := Trim(tmps);
        if (tmps = '') then begin
            // we are no longer custom away
            _custom_pres := false;
            _sendPresence(MainSession.Show, MainSession.Status);
        end
        else begin
            // set a custom away msg
            _custom_pres := true;
            if (cmd = '/away') then
                _sendPresence('away', tmps)
            else if (cmd = '/xa') then
                _sendPresence('xa', tmps)
            else if (cmd = '/dnd') then
                _sendPresence('dnd', tmps);
        end;
        Result := true;
    end
    else if (cmd = '/me') then begin
        Result := false;
    end
    else begin
        m := TJabberMessage.Create(self.jid, 'groupchat', 'Unknown / command: "' +
                    cmd +'"'#13#10 + 'Try /help', '');
        DisplayMsg(m, MsgList);
        m.Destroy();
        Result := true;
    end;

    wsl.Destroy();
    if (Result) then
        MsgOut.Lines.Clear();
end;

{---------------------------------------}
procedure TfrmRoom.SessionCallback(event: string; tag: TXMLTag);
var
    tmps: Widestring;
begin
    // session callback...look for our own presence changes
    if (event = '/session/disconnected') then begin
        // post a msg to the window and disable the text input box.
        MsgOut.Visible := false;
        MsgList.DisplayPresence(_('You have been disconnected.'), '');

        MainSession.UnRegisterCallback(_mcallback);
        MainSession.UnRegisterCallback(_ecallback);
        MainSession.UnRegisterCallback(_pcallback);
        MainSession.UnRegisterCallback(_dcallback);

        _mcallback := -1;
        _ecallback := -1;
        _pcallback := -1;
        _dcallback := -1;

        _roster.Clear();
        ClearListObjects(_rlist);
        _rlist.Clear();
        lstRoster.Items.Count := 0;
        lstRoster.Invalidate();

        _disconTime := Now();
    end
    else if (event = '/session/presence') then begin
        // We changed our own presence, send it to the room
        if (MainSession.Invisible) then exit;
        if (_custom_pres) then exit;

        // previously disconnected
        if ((_mcallback = -1) or
            (_pending_start)) then begin
            MsgOut.Visible := true;
            MsgList.DisplayPresence(sReconnected, '');
            SetJID(Self.jid);             // re-register callbacks
            sendStartPresence();
        end else begin
            _sendPresence(MainSession.Show, MainSession.Status);
        end;
    end
    else if (event = '/session/close-rooms') then begin
        // close this room.
        if (tag <> nil) then tmps := tag.Data() else tmps := '';
        _sendPresence('unavailable', tmps);
    end;
end;

{---------------------------------------}
procedure TfrmRoom.roomuserCallback(event: string; tag: TXMLTag);
var
    q, ident: TXMLTag;
    tempnick: Widestring;
begin
    // we got back a response to our roomuser_item request.
    // we need to process it and then send start presence to room.
    if ((event <> 'timeout') and
        (tag <> nil)) then begin
        useRegisteredNick := false;
        if (tag.GetAttribute('type') = 'result') then begin
            q := tag.GetFirstTag('query');
            ident := q.GetFirstTag('identity');
            // It is possible to get back a blank nick which is bad.
            tempnick := ident.GetAttribute('name');
            if (Length(tempnick) > 0) then
                MyNick := tempnick;
        end;
        sendStartPresence();
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
    emsg, ptype, from: Widestring;
    tmp_jid: TJabberID;
    i: integer;
    member: TRoomMember;
    mtag, t, itag, xtag, etag, drtag: TXMLTag;
    ecode, scode, tmp1, tmp2, reason: Widestring;
    e: TJabberEntity;
begin
    // We are getting presence
    from := tag.getAttribute('from');
    ptype := tag.getAttribute('type');
    i := _roster.indexOf(from);

    // check for MUC presence
    xtag := tag.QueryXPTag(xp_muc_presence);
    if ((xtag <> nil) and (not _isMUC)) then
        _isMUC := true;

    if ((ptype = 'error') and ((from = jid) or (from = jid + '/' + MyNick))) then begin
        // check for various presence errors
        etag := tag.GetFirstTag('error');
        if (etag <> nil) then begin
            ecode := etag.GetAttribute('code');
            if (ecode = '409') then begin
                MessageDlgW(_(sStatus_409), mtError, [mbOK], 0);
                if (_old_nick = '') then begin
                    Self.Close();
                    exit;
                end
                else
                    myNick := _old_nick;
            end
            else if (ecode = '401') then begin
                e := jEntityCache.getByJid(Self.jid, '');
                if ((e <> nil) and
                    ((e.hasFeature('muc_passwordprotected') or
                     e.hasFeature('muc_password') or
                     e.hasFeature('muc-passwordprotected')) or
                     e.hasFeature('muc-password'))) then begin
                    if (_passwd = '') then begin
                        // this room needs a passwd, and they didn't give us one..
                        if (InputQueryW(e.Jid.jid, _('Room Password'), _passwd, true) = false) then begin
                            // Cancel selected, just close
                            Self.Close;
                        end
                        else begin
                            // Try new password.
                            _passwd_from_join_room := false;
                            sendStartPresence();
                        end;
                        exit;
                    end
                    else begin
                        // 401 error IS due to bad password so show password error
                        MessageDlgW(_(sStatus_401), mtError, [mbOK], 0);
                        if (_passwd_from_join_room) then begin
                            Self.Close();
                            tmp_jid := TJabberID.Create(from);
                            StartJoinRoom(tmp_jid, MyNick, '');
                            tmp_jid.Free();
                        end
                        else begin
                            if (InputQueryW(e.Jid.jid, _('Room Password'), _passwd, true) = false) then begin
                                // Cancel selected, just close
                                Self.Close;
                            end
                            else begin
                                // Try new password.
                                sendStartPresence();
                            end;
                        end;
                        exit;
                    end;
                end;
                // 401 is NOT due to password, just exit
                exit;
            end
            else if (ecode = '404') then begin
                MessageDlgW(_(sStatus_404), mtError, [mbOK], 0);
                Self.Close();
                exit;
            end
            else if (ecode = '405') then begin
                MessageDlgW(_(sStatus_405a), mtError, [mbOK], 0);
                Self.Close();
                exit;
            end
            else if (ecode = '407') then begin
                e := jEntityCache.getByJid(Self.jid, '');
                //If can't join, first check if we are allowed to regiter
                if  (e <> nil) then begin
                  if (e.hasFeature('muc-members-openreg') or e.hasFeature('muc-openreg')) then begin
                    if (MessageDlgW(_(sStatus_407), mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
                      t := TXMLTag.Create('register');
                      t.setAttribute('jid', Self.jid);
                      MainSession.FireEvent('/session/register', t);
                      t.Free();
                    end;
                  end
                  else
                    //If can't register, can't enter
                    MessageDlgW(_(sStatus_405a), mtError, [mbOK], 0)
                  end;
                Self.Close();
                exit;
            end
            else if (ecode = '403') then begin
                emsg := etag.QueryXPData('/error/text[@xmlns="urn:ietf:params:xml:ns:xmpp-streams"]');
                if (emsg = '') then
                    emsg := etag.Data();
                if (emsg = '') then
                    emsg := _(sStatus_403);
                MessageDlgW(emsg, mtError, [mbOK], 0);
                Self.Close();
                exit;
            end
            else if (ecode = '413') then begin
                //Note:  This is the JINC code for max-occupants
                MessageDlgW(_(sStatus_413), mtError, [mbOK], 0);
                Self.Close();
                exit;
            end
        end;

        MessageDlgW(_(sStatus_Unknown), mtError, [mbOK], 0);
        Self.Close();
        exit;
    end

    else if ptype = 'unavailable' then begin
        t := tag.QueryXPTag(xp_muc_status);
        if ((from = jid) or (from = jid + '/' + MyNick)) then begin
            if (t <> nil) then
                ShowStatusCode(t)
            else if (not _pending_destroy) then begin
                // Show destroy reason
                tmp_jid := TJabberID.Create(from);
                //don't use display name here for room name
                reason := WideFormat(_(sRoomDestroyed), [tmp_jid.userDisplay]);
                drtag := tag.QueryXPTag(xp_muc_destroy_reason);
                if ((drtag <> nil) and (drtag.Data <> '')) then begin
                    reason := reason + ''#13#10 + _(sReason) + ' ' + drtag.Data;
                end;

                MessageDlgW(reason, mtInformation, [mbOK], 0);
                tmp_jid.Free();
                _pending_destroy := false;
            end;
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
                        mtag := newRoomMessage(WideFormat(_(sStatus_303),
                            [tmp1, tmp2]));
                        ShowMsg(mtag);
                    end;

                    // update their room jid and nick
                    // doing this to avoid causing second enter message
                    tmp1 := jid + '/' + tmp2;
                    member.Nick := tmp2;
                    member.jid := tmp1;
                    _roster.Delete(i);
                    _roster.AddObject(member.jid, member);
                end
                else if ((scode = '301') or (scode = '307')) then begin
                    itag := tag.QueryXPTag(xp_muc_reason);
                    if (itag <> nil) then tmp1 := itag.Data else tmp1 := '';
                    if (scode = '301') then tmp2 := _(sStatus_301)
                    else if (scode = '307') then tmp2 := _(sStatus_307)
                    else if (scode = '322') then tmp2 := _(sStatus_322);
                         
                    mtag := newRoomMessage(WideFormat(tmp2, [member.Nick, tmp1]));
                    ShowMsg(mtag);
                end;
            end
            else if ((member.role <> '') and (MainSession.Prefs.getBool('room_joins'))) then begin
                mtag := newRoomMessage(WideFormat(_(sUserLeave), [member.Nick]));
                ShowMsg(mtag);
            end;

            if (scode <> '303') then begin
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
        end;
    end
    else begin
        // SOME KIND OF AVAIL
        tmp_jid := TJabberID.Create(from);

        if (i < 0) then begin
            // this is a new member
            member := AddRoomUser(from, tmp_jid.resource);

            // show new user message
            if (xtag <> nil) then begin
                _isMUC := true;

                if (MainSession.Prefs.getBool('room_joins')) then begin
                    mtag := newRoomMessage(WideFormat(_(sNewUser), [member.nick]));
                    showMsg(mtag);
                end;

                t := xtag.GetFirstTag('status');
                if ((t <> nil) and (t.getAttribute('code') = '201')) then begin
                    // we are the owner... config the room
                    _isMUC := true;
                    configRoom(_default_config);
                end;
            end;
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
                    mtag := newRoomMessage(_(sGrantVoice))
                else if ((member.role = MUC_PART) and (tmp1 = MUC_VISITOR)) then
                    mtag := newRoomMessage(_(sRevokeVoice))
                else if (member.role <> tmp1) then
                    mtag := newRoomMessage(WideFormat(_(sNewRole), [member.nick, tmp1]));
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
        member.nick := tmp_jid.resource;
        tmp_jid.Free();

        // check for role=none to fixup bugs in some mu-c servers.
        if (member.role = 'none') then begin
            _roster.Delete(i);
            i := _rlist.IndexOf(member);
            if (i >= 0) then begin
                _rlist.Delete(i);
                _rlist.Sort(ItemCompare);
                lstRoster.Items.Count := _rlist.Count;
                lstRoster.Invalidate();
            end;
            member.Free;
            exit;
        end;

        if (member.Nick = myNick) then begin
            if (i < 0) then begin
                // this is the first time I've joined the room
                mtag := nil;
                if (member.Nick = myNick) then begin
                    if (member.Role = MUC_VISITOR) then
                        mtag := newRoomMessage(_(sNoVoice))
                    else if (member.Role = MUC_MOD) then
                        mtag := newRoomMessage(_(sCurModerator));
                    if (mtag <> nil) then showMsg(mtag);
                end;
            end;

            //hold onto my role
            _my_membership_role := member.role;

            // check to see what my role is
            _send_unavailable := true;

            // These are owner-only things..
            popConfigure.Enabled := (member.Affil = MUC_OWNER);
            popDestroy.Enabled := popConfigure.Enabled;
            popAdminList.Enabled := popConfigure.Enabled;
            popAdministrator.Enabled := popConfigure.Enabled;
            popOwnerList.Enabled := popConfigure.Enabled;

            // Moderator stuff
            popAdmin.Enabled := (member.Role = MUC_MOD) or popConfigure.Enabled;
            popKick.Enabled := popAdmin.Enabled;
            popBan.Enabled := popAdmin.Enabled;
            popVoice.Enabled := popAdmin.Enabled;

            // Admin stuff
            popModerator.Enabled := (member.affil = MUC_ADMIN) or popConfigure.Enabled;

            // Voice stuff
            MsgOut.ReadOnly := (member.role = MUC_VISITOR);
            if (MsgOut.Readonly) then MsgOut.Lines.Clear();
            
            // Who can change subject
            _EnableSubjectButton();
        end;
        RenderMember(member, tag);
    end;

end;

{---------------------------------------}
function TfrmRoom.addRoomUser(jid, nick: Widestring): TRoomMember;
var
    member: TRoomMember;
begin
    //
    member := TRoomMember.Create;
    member.JID := jid;
    member.Nick := nick;

    _roster.AddObject(jid, member);
    _rlist.Add(member);
    _rlist.Sort(ItemCompare);
    lstRoster.Items.Count := _rlist.Count;
    lstRoster.Invalidate();

    Result := member;
end;

{---------------------------------------}
procedure TfrmRoom.removeRoomUser(jid: Widestring);
var
    i: integer;
    member: TRoomMember;
begin
    //
    i := _roster.IndexOf(jid);
    if (i = -1) then exit;

    member := TRoomMember(_roster.Objects[i]);
    _roster.Delete(i);
    i := _rlist.IndexOf(member);
    if (i >= 0) then begin
        _rlist.Delete(i);
        _rlist.Sort(ItemCompare);
        lstRoster.Items.Count := _rlist.Count;
        lstRoster.Invalidate();
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

    if (scode = '301') then fmt := _(sStatus_301)
    else if (scode = '302') then fmt := _(sStatus_302)
    else if (scode = '303') then fmt := _(sStatus_303)
    else if (scode = '307') then fmt := _(sStatus_307)
    else if (scode = '322') then fmt := _(sStatus_322)         
    else if (scode = '403') then msg := _(sStatus_403)
    else if (scode = '405') then msg := _(sStatus_405)
    else if (scode = '407') then msg := _(sStatus_407)
    else if (scode = '409') then msg := _(sStatus_409);

    if (fmt <> '') then
        msg := WideFormat(fmt, [MyNick, '']);

    if (msg <> '') then
        MessageDlgW(msg, mtInformation, [mbOK], 0);
end;

{---------------------------------------}
procedure TfrmRoom.configRoom(use_default: boolean);
var
    cb: TPacketEvent;
    iq: TJabberIQ;
    x: TXMLTag;
begin
    if (use_default) then
        cb := autoConfigCallback
    else
        cb := configCallback;

    iq := TJabberIQ.Create(MainSession, MainSession.generateID(), cb, 10);
    with iq do begin
        toJid := Self.jid;
        Namespace := XMLNS_MUCOWNER;
        iqType := 'get';
    end;

    if (use_default) then begin
        iq.iqType := 'set';
        x := iq.qTag.AddTag('x');
        x.setAttribute('xmlns', 'jabber:x:data');
        x.setAttribute('type', 'submit');
    end;
    iq.Send();

end;

{---------------------------------------}
procedure TfrmRoom.autoConfigCallback(event: string; tag: TXMLTag);
begin
    if ((event <> 'xml') or (tag.getAttribute('type') <> 'result')) then begin
        MessageDlgW(_('There was an error using the default room configuration. Configuring it manually.'),
            mtError, [mbOK], 0);
        configRoom();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.configCallback(event: string; Tag: TXMLTag);
var
    iq: TJabberIQ;
    x: TXMLTag;
    roomCaption: widestring;
    roomJID: TJabberID;
begin
    // We are configuring the room
    if ((event = 'xml') and (tag.GetAttribute('type') = 'result')) then begin
        roomJID := TJabberID.Create(jid);
        roomCaption := roomJID.userDisplay + _(' Configuration');
        if (ShowXDataEx(tag, roomCaption) = false) then begin
            // there are no fields... submit a blank form.
            iq := TJabberIQ.Create(MainSession, MainSession.generateID());
            iq.toJid := Self.Jid;
            iq.Namespace := XMLNS_MUCOWNER;
            iq.iqType := 'set';
            x := iq.qTag.AddTag('x');
            x.setAttribute('xmlns', 'jabber:x:data');
            x.setAttribute('type', 'submit');
            iq.Send();
        end;
        roomJID.Free;
    end;
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
        p := TJabberPres.Create(tag);
        p.parse();

        if (member.show = _(sBlocked)) then
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
    _dcallback := -1;
    _roster := TWideStringList.Create;
    _roster.CaseSensitive := true;
    _rlist := TList.Create;
    _isMUC := false;
    _nick_prefix := '';
    _nick_idx := 0;
    _nick_start := 0;
    _hint_text := '';
    _old_nick := '';
    _disconTime := 0;
    _keywords := nil;
    _send_unavailable := false;
    _custom_pres := false;
    _pending_start := false;
    _pending_destroy := false;
    _passwd_from_join_room := true;

    ImageIndex := RosterImages.RI_CONFERENCE_INDEX;

    _notify[NOTIFY_ROOM_ACTIVITY] := MainSession.Prefs.getInt('notify_roomactivity');
    _notify[NOTIFY_KEYWORD] := MainSession.Prefs.getInt('notify_keyword');
    _notify[NOTIFY_PRIORITY_ROOM_ACTIVITY] := MainSession.Prefs.getInt('notify_priority_roomactivity');

    AssignUnicodeFont(lblSubject.Font, 8);
    lblSubject.Hint := _(sNoSubjectHint);
    lblSubject.Caption := _(sNoSubject);
    _subject := '';

    if (_notify[NOTIFY_KEYWORD] <> 0) then
        setupKeywords();

    MyNick := '';

    _wrap_input := MainSession.Prefs.getBool('wrap_input');
    MsgOut.WordWrap := _wrap_input;
    mnuWordwrap.Checked := _wrap_input;

    e := TExodusChat.Create();
    e.setRoom(Self);
    e.ObjAddRef();
    COMController := e;

    // Setup MsgList;
    MsgList.setContextMenu(popRoom);
    MsgList.setDragOver(OnDockedDragOver);
    MsgList.setDragDrop(OnDockedDragDrop);

    if (MainSession.Prefs.getBool('brand_prevent_change_nick')) then
        popNick.Enabled := False;
end;

{---------------------------------------}
procedure TfrmRoom.setupKeywords();
begin
    _keywords := Keywords.CreateKeywordsExpr();
end;

{---------------------------------------}
procedure TfrmRoom.SetJID(sjid: Widestring);
var
    j: TJabberID;
begin
    // setup our callbacks
    if (_mcallback = -1) then begin
        _mcallback := MainSession.RegisterCallback(MsgCallback, '/packet/message[@type="groupchat"][@from="' + sjid + '*"]');
        _ecallback := MainSession.RegisterCallback(MsgCallback, '/packet/message[@type="error"][@from="' + sjid + '"]');
        _pcallback := MainSession.RegisterCallback(PresCallback, '/packet/presence[@from="' + sjid + '*"]');
        _dcallback := MainSession.RegisterCallback(EntityCallback, '/session/entity/info');
        if (_scallback = -1) then
            _scallback := MainSession.RegisterCallback(SessionCallback, '/session');
    end;
    Self.jid := sjid;

    j := TJabberID.Create(sjid);
    MsgList.setTitle(j.user);
    j.Free();
end;

{---------------------------------------}
procedure TfrmRoom.SetPassword(pass: Widestring);
begin
    _passwd := pass;
end;

{---------------------------------------}
procedure TfrmRoom.MsgOutKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = 0) then exit;
    TExodusChat(ComController).fireMsgKeyUp(Key, Shift);
    inherited;
end;
{---------------------------------------}
procedure TfrmRoom.MsgOutKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = 0) then exit;
    TExodusChat(ComController).fireMsgKeyDown(Key, Shift);
    inherited;
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

            prefix := Trim(WideLowerCase(prefix));
            _nick_prefix := prefix;
            _nick_idx := 0;
        end
        else begin
            with MsgOut do begin
                SelStart := _nick_start;
                SelLength := _nick_len;
                WideSelText := '';
            end;
        end;

        found := false;
        exloop := false;
        repeat
            // for i := _nick_idx to lstRoster.Items.Count - 1 do begin
            for i := _nick_idx to _roster.Count - 1 do begin
                nick := TRoomMember(_roster.Objects[i]).Nick;
                if nick[1] = '@' then nick := Copy(nick, 2, length(nick) - 1);
                if nick[1] = '+' then nick := Copy(nick, 2, length(nick) - 1);

                if WideTextPos(_nick_prefix, WideLowercase(nick)) = 1 then with MsgOut do begin
                    _nick_idx := i + 1;
                    if _nick_start <= 0 then
                        WideSelText := nick + ': '
                    else
                        WideSelText := nick + ' ';
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
            MsgOut.WideSelText := _nick_prefix;
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
    msg := TJabberMessage.Create(jid, 'groupchat',
                                 _(sRoomSubjChange) + subj, subj);
    MainSession.SendTag(msg.Tag);
    msg.Free;
end;

{---------------------------------------}
procedure TfrmRoom.lblSubjectURLClick(Sender: TObject);
var
    o, s: WideString;
begin
    // Change the subject
    s := _subject;
    o := s;
    if InputQueryW(_(sRoomSubjPrompt), _(sRoomNewSubj), s) then begin
        if (o <> s) then changeSubject(s);
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popClearClick(Sender: TObject);
begin
  inherited;
    MsgList.Clear();
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
        if (WideLowerCase(rm.Nick) = WideLowerCase(new_nick)) then begin
            // they match
            MessageDlgW(_(sStatus_409), mtError, [mbOK], 0);
            exit;
        end;
    end;

    // go ahead and change it
    myNick := new_nick;
    p := TCapPresence.Create;
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
    if (InputQueryW(_(sRoomNewNick), _(sRoomNewNick), new_nick)) then begin
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
    bm_name: WideString;
    tmp_jid: TJabberID;
begin
  inherited;
    // bookmark this room..
    tmp_jid := TJabberID.Create(Self.jid);
    bm_name := tmp_jid.getDisplayJID();

    if (inputQueryW(_(sRoomBMPrompt), _(sRoomNewBookmark), bm_name)) then begin
        MainSession.Bookmarks.AddBookmark(Self.jid, bm_name, myNick, false, false);
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
procedure CloseAllRooms();
var
    i: integer;
    f: TfrmRoom;
begin
    for i := 0 to room_list.Count - 1 do begin
        f := TfrmRoom(room_list.Objects[0]); //rooms removed from list during close
        f.Close();
        Application.ProcessMessages();
    end;
    room_list.Clear();
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
    e: boolean;
    rm: TRoomMember;
begin
    if (lstRoster.Selected = nil) then
        rm := nil
    else begin
        rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
        if (rm <> nil) then begin
           if (rm.show = _(sBlocked)) then begin
              //unblock
              rm.show := rm.blockShow;
              rm.blockShow := '';
          end
           else begin
              //block
              rm.blockShow := rm.show;
              rm.show := _(sBlocked);
          end;
          lstRoster.Invalidate();
       end;
    end;

    e := (rm <> nil);
    popRosterMsg.Enabled := e;
    popRosterChat.Enabled := e;
    popRosterSendJID.Enabled := e;
    popRosterblock.Enabled := e;

    inherited;

end;

{---------------------------------------}
procedure TfrmRoom.popRoomRosterPopup(Sender: TObject);
var
    e: boolean;
    rm: TRoomMember;
begin
    e := (lstRoster.Selected <> nil);

    popRosterMsg.Enabled := e;
    popRosterChat.Enabled := e;
    popRosterSendJID.Enabled := e;
    popRosterblock.Enabled := e;

    popRosterSubscribe.Enabled := false;
    popRosterVCard.Enabled := false;
    popRosterBrowse.Enabled := false;

    if (not e) then exit;

    rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
    if (rm <> nil) then begin
        if (rm.show = _(sBlocked)) then
            popRosterBlock.Caption := _(sUnblock)
        else
            popRosterBlock.Caption := _(sBlock);


        if (rm.real_jid <> '') then begin
            popRosterSubscribe.Enabled := true;
            popRosterVCard.Enabled := true;
            popRosterBrowse.Enabled := true;
        end;

        // If we have clicked on our own Nick, dis-allow various menu options.
        if (rm.Nick = myNick) then begin
            popRosterMsg.Enabled := false;
            popRosterChat.Enabled := false;
            popRosterSendJID.Enabled := false;
            popRosterblock.Enabled := false;
            popRosterSubscribe.Enabled := false;
            popRosterVCard.Enabled := false;
            popRosterBrowse.Enabled := false;
            popKick.Enabled := false;
            popBan.Enabled := false;
            popVoice.Enabled := false;
            popModerator.Enabled := false;
            popAdministrator.Enabled := false;
        end
        else begin
            popAdministrator.Enabled := popConfigure.Enabled;
            popModerator.Enabled := (_my_membership_role = MUC_MOD) or popConfigure.Enabled;
            popKick.Enabled := popModerator.Enabled;
            popBan.Enabled := popModerator.Enabled;
            popVoice.Enabled := popModerator.Enabled;
        end;
    end;
    inherited;
end;

{---------------------------------------}
procedure TfrmRoom.popShowHistoryClick(Sender: TObject);
begin
    inherited;
    ShowRoomLog(Self.jid);
end;

{---------------------------------------}
procedure TfrmRoom.popClearHistoryClick(Sender: TObject);
begin
    inherited;
    ClearRoomLog(Self.jid);
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterDblClick(Sender: TObject);
var
    rm: TRoomMember;
    tmp_jid: TJabberID;
begin
  inherited;
    // start chat w/ room participant
    // Chat w/ this person..
    if (lstRoster.Selected = nil) then exit;

    rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
    if (rm = nil) or (WideLowerCase(rm.Nick) = WideLowerCase(mynick)) then exit;
    
    tmp_jid := TJabberID.Create(rm.jid);
    if (Length(rm._real_jid.jid()) = 0) then
        StartChat(tmp_jid.jid, tmp_jid.resource, true, rm.Nick)
    else
        StartChat(rm._real_jid.jid(), rm._real_jid.resource, true);
    tmp_jid.Free();
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
var
    tmps: Widestring;
    m: TRoomMember;
begin
  inherited;
    m := TRoomMember(_rlist[Item.Index]);
    if (m = nil) then
        InfoTip := ''
    else begin
        // pgm: Away (At lunch)
        tmps := m.Nick + ': ';
        tmps := tmps + m.show;
        if ((m.status <> '') and (m.status <> m.show)) then
            tmps := tmps + ' (' + m.status + ')';

        if (_isMUC) then begin
            if ((m.role <> '') or (m.affil <> '')) then begin
                tmps := tmps + ''#13#10 + _('Role: ') + m.role;
                tmps := tmps + ''#13#10 + _('Affiliation: ') + m.affil;
            end;
            if (m.real_jid <> '') then
                tmps := tmps + ''#13#10 + '<' + m.getRealDisplayJID() + '>';
        end;
        InfoTip := tmps;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popConfigureClick(Sender: TObject);
begin
  inherited;
    configRoom(false);
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
        reason := _(sKickDefault);
        if (not InputQueryW(_(sKickReason), _(sKickReason), reason)) then exit;
    end
    else if (Sender = popBan) then begin
        reason := _(sBanDefault);
        if (not InputQueryW(_(sBanReason), _(sBanReason), reason)) then exit;
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
    else if (Sender = popModerator) then
        AddMemberItems(q, '', MUC_MOD, '')
    else if (Sender = popAdministrator) then
        AddMemberItems(q, '', '', MUC_ADMIN);

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
        ShowRoomAdminList(self, self.jid, MUC_PART, '', _(sEditVoice))
    else if (Sender = popBanList) then
        ShowRoomAdminList(self, self.jid, '', MUC_OUTCAST, _(sEditBan))
    else if (Sender = popMemberList) then
        ShowRoomAdminList(self, self.jid, '', MUC_MEMBER, _(sEditMember))
    else if (Sender = popModeratorList) then
        ShowRoomAdminList(self, self.jid, MUC_MOD, '', _(sEditModerator))
    else if (Sender = popAdminList) then
        ShowRoomAdminList(self, self.jid, '', MUC_ADMIN, _(sEditAdmin))
    else if (Sender = popOwnerList) then
        ShowRoomAdminList(self, self.jid, '', MUC_OWNER, _(sEditOwner));
end;

{---------------------------------------}
procedure TfrmRoom.popDestroyClick(Sender: TObject);
var
    reason: WideString;
    iq, q, d: TXMLTag;
begin
  inherited;
    // Destroy Room
    if (MessageDlgW(_(sDestroyRoomConfirm), mtConfirmation, [mbYes,mbNo], 0) = mrNo) then
        exit;
    reason := _(sDestroyDefault);
    if InputQueryW(_(sDestroyRoom), _(sDestroyReason), reason) = false then exit;

    iq := TXMLTag.Create('iq');
    iq.setAttribute('type', 'set');
    iq.setAttribute('id', MainSession.generateID());
    iq.setAttribute('to', jid);
    q := iq.AddTag('query');
    q.setAttribute('xmlns', XMLNS_MUCOWNER);
    d := q.AddTag('destroy');
    // TODO: alt-jid goes onto <destroy jid="newroom@server">
    d.AddBasicTag('reason', reason);
    _pending_destroy := true;
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
    i: integer;
begin
    // Unregister callbacks and send unavail pres.
    if (MainSession <> nil) then begin
        MainSession.UnRegisterCallback(_mcallback);
        MainSession.UnRegisterCallback(_ecallback);
        MainSession.UnRegisterCallback(_pcallback);
        MainSession.UnRegisterCallback(_scallback);
        MainSession.UnRegisterCallback(_dcallback);

        if (MainSession.Invisible) then
            MainSession.removeAvailJid(jid);
    end;

    if ((MainSession <> nil) and (MainSession.Active) and (_send_unavailable)) then begin
        _sendPresence('unavailable', '', false);
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
    f.addItem('Priority room activity');
    f.setVal(0, _notify[NOTIFY_ROOM_ACTIVITY]);
    f.setVal(1, _notify[NOTIFY_KEYWORD]);
    f.setVal(2, _notify[NOTIFY_PRIORITY_ROOM_ACTIVITY]);

    if (f.ShowModal) = mrOK then begin
        _notify[NOTIFY_ROOM_ACTIVITY] := f.getVal(0);
        _notify[NOTIFY_KEYWORD] := f.getVal(1);
        _notify[NOTIFY_PRIORITY_ROOM_ACTIVITY] := f.getVal(2);

        if ((_notify[NOTIFY_KEYWORD] <> 0) and (_keywords = nil)) then
            setupKeywords();
    end;

    f.Free();
end;

{---------------------------------------}
procedure TfrmRoom.S1Click(Sender: TObject);
var
    fn: widestring;
    filetype: integer;
begin
    dlgSave.FileName := MungeName(self.jid);
    if (not dlgSave.Execute()) then exit;
    fn := dlgSave.FileName;
    filetype := dlgSave.FilterIndex;
    if (filetype = 1) then begin
        // .rtf file
        if (LowerCase(RightStr(fn, 3)) <> '.rtf') then
            fn := fn + '.rtf';
    end
    else if (filetype = 2) then begin
        // .txt file
        if (LowerCase(RightStr(fn, 3)) <> '.txt') then
            fn := fn + '.txt';
    end;
    MsgList.Save(fn);
end;

{---------------------------------------}
procedure TfrmRoom.pluginMenuClick(Sender: TObject);
begin
    TExodusChat(COMController).fireMenuClick(Sender);
end;

{---------------------------------------}
procedure TfrmRoom.popRosterMsgClick(Sender: TObject);
var
    rm: TRoomMember;
    tmp_jid: TJabberID;
begin
  inherited;
    // start chat w/ room participant
    // Chat w/ this person..
    if (lstRoster.Selected = nil) then exit;

    rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
    if (rm <> nil) then begin
        tmp_jid := TJabberID.Create(rm.jid);
        StartMsg(tmp_jid.full);
        tmp_jid.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popRosterSendJIDClick(Sender: TObject);
var
    rm: TRoomMember;
    b: WideString;
    msg, x, item: TXMLTag;
begin

  inherited;
    // Send my JID to this user
    if (lstRoster.Selected = nil) then exit;

    rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
    if (rm <> nil) then begin
        msg := TXMLTag.Create('message');
        msg.setAttribute('id', MainSession.generateID());
        msg.setAttribute('to', rm.jid);
        b := WideFormat(_(sMsgRosterItems), [1]);
        b := b + Chr(13) + Chr(10) + MainSession.getDisplayUsername + ': ' + MainSession.BareJid;
        x := msg.AddTag('x');
        x.setAttribute('xmlns', XMLNS_XROSTER);
        item := x.AddTag('item');
        item.setAttribute('jid', MainSession.BareJid);
        item.setAttribute('name', MainSession.getDisplayUsername);
        jabberSendMsg(rm.jid, msg, x, b, '');
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
    TTntListItem(Item).Caption := rm.Nick;
    if (rm.show = _(sBlocked)) then item.ImageIndex := RosterTreeImages.Find('online_blocked')
    else if rm.show = 'away' then Item.ImageIndex := RosterTreeImages.Find('away')
    else if rm.show = 'xa' then Item.ImageIndex := RosterTreeImages.Find('xa')
    else if rm.show = 'dnd' then Item.ImageIndex := RosterTreeImages.Find('dnd')
    else if rm.show = 'chat' then Item.ImageIndex := RosterTreeImages.Find('chat')
    else Item.ImageIndex := RosterTreeImages.Find('available');

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

    Result := AnsiCompareText(s1,s2);
end;

{---------------------------------------}
procedure TfrmRoom.popRegisterClick(Sender: TObject);
begin
  inherited;
    StartServiceReg(jid);
end;

{---------------------------------------}
procedure TfrmRoom.EntityCallback(event: string; tag: TXMLTag);
begin
    if (_pending_start = false) then begin
        // Not starting so we don't want to send start presence.
        // We probably have new disco info (like change of room config).
        // Process that info

        // Who can change subject?
        _EnableSubjectButton();
        exit;
    end;
        
    if (tag = nil) then begin
        // just try anyways
        sendStartPresence();
        exit;
    end;

    if (tag.getAttribute('from') = Self.jid) then begin
        // we got info from our room...
        sendStartPresence();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.sendStartPresence();
var
    e: TJabberEntity;
    p : TJabberPres;
    iq: TJabberIQ;
    cb: TPacketEvent;
begin
    e := jEntityCache.getByJid(Self.jid, '');
    if ((e = nil) or (not e.hasInfo)) then begin
        // try to disco#info this room
        _pending_start := true;
        jEntityCache.discoInfo(self.jid, MainSession, '', ROOM_TIMEOUT);
        exit;
    end
    else if ((useRegisteredNick) and
             (e.hasFeature('muc_membersonly') or
             e.hasFeature('muc-members-only'))) then begin
        cb := Self.roomuserCallback;
        iq := TJabberIQ.Create(MainSession, MainSession.generateID(), cb, 10);
        with iq do begin
            toJid := jid;
            iqType := 'get';
            Namespace := XMLNS_DISCOINFO;
            qTag.setAttribute('node', 'x-roomuser-item');
        end;
        iq.Send();
        exit;
    end;

    _pending_start := false;
    p := TCapPresence.Create;
    p.toJID := TJabberID.Create(self.jid + '/' + self.mynick);
    with p.AddTag('x') do begin
        setAttribute('xmlns', XMLNS_MUC);
        if (self._passwd <> '') then
            AddBasicTag('password', _passwd);
    end;

    if (MainSession.Invisible) then
        MainSession.addAvailJid(self.jid);

    p.Show := MainSession.Show;
    p.Status := MainSession.Status;

    MainSession.SendTag(p);
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
    // If typing starts on the MsgList, then bump it to the outgoing
    // text box.
    if (not Self.Visible) then exit;
    if (Ord(key) < 32) then exit;

    if (MsgOut.Visible) then begin
        MsgOut.SetFocus();
        MsgOut.WideSelText := Key;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
    rm: TRoomMember;
    xRect: TRect;
    nRect: TRect;
    main_color: TColor;
    moderator, visitor: boolean;
    c1: Widestring;
begin
  inherited;
    // Bold if they are a moderator.. gray if no voice
    DefaultDraw := true;
    if (not _isMUC) then exit;

    rm := TRoomMember(_rlist[Item.Index]);
    moderator := (rm.role = 'moderator');
    visitor := (rm.role = 'visitor');

    with lstRoster.Canvas do begin
        TextFlags := ETO_OPAQUE;
        xRect := Item.DisplayRect(drLabel);
        nRect := Item.DisplayRect(drBounds);

        // draw the selection box, or just the bg color
        if (cdsSelected in State) then begin
            Font.Color := clHighlightText;
            Brush.Color := clHighlight;
            FillRect(xRect);
        end
        else begin
            if (visitor) then
                Font.Color := clGrayText
            else
                Font.Color := lstRoster.Font.Color;
            Brush.Color := lstRoster.Color;
            Brush.Style := bsSolid;
            FillRect(xRect);
        end;

        // Bold moderators
        if (moderator) then
            Font.Style := [fsBold]
        else
            Font.Style := [];

        // draw the image
        frmExodus.Imagelist2.Draw(lstRoster.Canvas,
            nRect.Left, nRect.Top, Item.ImageIndex);

        // draw the text
        if (cdsSelected in State) then begin
            main_color := clHighlightText;
            //stat_color := main_color;
        end
        else begin
            main_color := lstRoster.Canvas.Font.Color;
            //stat_color := clGrayText;
        end;

        c1 := rm.Nick;
        if (CanvasTextWidthW(lstRoster.Canvas, c1) > (xRect.Right - xRect.Left)) then begin
            // XXX: somehow truncate the nick
        end;

        SetTextColor(lstRoster.Canvas.Handle, ColorToRGB(main_color));
        CanvasTextOutW(lstRoster.Canvas, xRect.Left + 1,
            xRect.Top + 1, c1);

        if (cdsSelected in State) then
            // Draw the focus box.
            lstRoster.Canvas.DrawFocusRect(xRect);

        // make sure the control doesn't redraw this.
        DefaultDraw := false;
    end;

end;

{---------------------------------------}
procedure TfrmRoom.popRosterSubscribeClick(Sender: TObject);
var
    j: TJabberID;
    rm: TRoomMember;
    dgrp: Widestring;
begin
  inherited;
    // subscribe to this person
    if (lstRoster.Selected = nil) then exit;

    rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
    if ((rm <> nil) and (rm.real_jid <> '')) then begin
        j := TJabberID.Create(rm.real_jid);
        dgrp := MainSession.Prefs.getString('roster_default');
        MainSession.Roster.AddItem(j.jid, rm.nick, dgrp, true);
        j.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popRosterVCardClick(Sender: TObject);
var
    j: TJabberID;
    rm: TRoomMember;
begin
  inherited;
    // lookup the vcard.
    if (lstRoster.Selected = nil) then exit;

    rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
    if ((rm <> nil) and (rm.real_jid <> '')) then begin
        j := TJabberID.Create(rm.real_jid);
        ShowProfile(j.jid);
        j.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popRosterBrowseClick(Sender: TObject);
var
    j: TJabberID;
    rm: TRoomMember;
begin
  inherited;
    if (lstRoster.Selected = nil) then exit;

    rm := TRoomMember(_rlist[lstRoster.Selected.Index]);
    if ((rm <> nil) and (rm.real_jid <> '')) then begin
        j := TJabberID.Create(rm.real_jid);
        ShowBrowser(j.jid);
        j.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popCopyClick(Sender: TObject);
begin
  inherited;
    MsgList.Copy();
end;

{---------------------------------------}
procedure TfrmRoom.popCopyAllClick(Sender: TObject);
begin
  inherited;
    MsgList.CopyAll();
end;

{---------------------------------------}
procedure TfrmRoom.Print1Click(Sender: TObject);
var
    cap: Widestring;
    ml: TfBaseMsgList;
    msglist: TfRTFMsgList;
begin
  inherited;
    ml := getMsgList();

    if (ml is TfRTFMsgList) then begin
        msglist := TfRTFMsgList(ml);
        with PrintDialog1 do begin
            if (not Execute) then exit;

            cap := _('Room Transcript: %s');
            cap := WideFormat(cap, [Self.Caption]);

            PrintRichEdit(cap, TRichEdit(msglist.MsgList), Copies, PrintRange);
        end;
    end;
end;

procedure TfrmRoom.OnDockedDragOver(Sender, Source: TObject; X, Y: Integer;
                               State: TDragState; var Accept: Boolean);
begin
    inherited;
    Accept := (Source = frmRosterWindow.treeRoster);
end;

procedure TfrmRoom.OnDockedDragDrop(Sender, Source: TObject; X, Y: Integer);
var
    n: TTreeNode;
    ritem: TJabberRosterItem;
    i: integer;
    jids: TList;
    o: TObject;
begin
  inherited;
    // drag drop
    if (Source = frmRosterWindow.treeRoster) then begin
        // We want to invite someone into this TC room
        jids := TList.Create();
        with frmRosterWindow.treeRoster do begin
            for i := 0 to SelectionCount - 1 do begin
                n := Selections[i];
                o := TObject(n.Data);
                assert(o <> nil);

                if (o is TJabberRosterItem) then begin
                    ritem := TJabberRosterItem(n.Data);
                    jids.Add(ritem);
                end
                else if (o is TJabberGroup) then begin
                    TJabberGroup(o).getRosterItems(jids, true);
                end;
            end;
        end;
        ShowInvite(Self.jid, jids);
    end;
end;

{
    Event fired when docking is complete.

    Docked property will be true, tabsheet will be assigned. This event
    is fired after all other docking events are complete.
}
procedure TfrmRoom.OnDocked();
begin
    inherited;
    _scrollBottom();
    Self.Refresh();
    //SIG-SIG-SIG
    TExodusChat(ComController).fireNewWindow(Self.Handle);
    //SIG-SIG-SIG
end;

{
    Event fired when a float (undock) is complete.

    Docked property will be false, tabsheet will be nil. This event
    is fired after all other floating events are complete.
}
procedure TfrmRoom.OnFloat();
begin
    inherited;
    _scrollBottom();
    Self.Refresh();
    //SIG-SIG-SIG
    TExodusChat(ComController).fireNewWindow(Self.Handle);
    //SIG-SIG-SIG
end;

function TRoomMember.getRealJID(): WideString;
begin
    Result := '';
    if (_real_jid <> nil) then
    begin
        Result := _real_jid.full();
    end;
end;

function TRoomMember.getRealDisplayJID(): WideString;
begin
    Result := '';
    if (_real_jid <> nil) then
    begin
        Result := _real_jid.getDisplayFull();
    end;
end;

procedure TRoomMember.setRealJID(jid: WideString);
begin
    if (_real_jid <> nil) then
      _real_jid.Free();

    _real_jid := TJabberID.Create(jid);
end;

{---------------------------------------}
procedure TfrmRoom._EnableSubjectButton();
var
    e: TJabberEntity;
    enable: boolean;
begin
    // This code enables or disables the change subject button
    // based on what the disco info tells us about premissions
    // to change subject.
    // If no disco info is available, enable and let
    // error codes take care of preventing changing of subject.
    enable := true;
    e := jEntityCache.getByJid(Self.jid, '');
    if (e = nil) then exit;

    if (_my_membership_role = MUC_OWNER) or
       (_my_membership_role = MUC_ADMIN) then
            enable := true //always
    else if (e.hasFeature('muc-subj-moderator')) or
            (e.hasFeature('muc-subj-participant')) then
        begin
            // we have a specification as to who can change
            if (e.hasFeature('muc-subj-moderator')) and
               (_my_membership_role = MUC_MOD) then
                enable := true
            else if (e.hasFeature('muc-subj-participant')) and
                    ( (_my_membership_role = MUC_MOD) or
                      (_my_membership_role = MUC_MEMBER) or
                      (_my_membership_role = MUC_PART) ) then
                enable := true
            else
                enable := false;
        end;

    SpeedButton1.Enabled := enable;
    if (enable) then
        SpeedButton1.Hint := _('Edit Subject')
    else begin
        SpeedButton1.Hint := '';
        lblSubject.Hint := '';
    end;
end;


destructor TRoomMember.Destroy();
begin
    inherited Destroy();
    if (_real_jid <> nil) then
      _real_jid.Free();
end;

initialization
    // list for all of the current rooms
    room_list := TWideStringlist.Create();

    // pre-compile some xpath's
    xp_muc_presence := TXPLite.Create('/presence/x[@xmlns="' + XMLNS_MUCUSER + '"]');
    xp_muc_status := TXPLite.Create('//x[@xmlns="' + XMLNS_MUCUSER + '"]/status');
    xp_muc_item := TXPLite.Create('//x[@xmlns="' + XMLNS_MUCUSER + '"]/item');
    xp_muc_reason := TXPLite.Create('//x[@xmlns="' + XMLNS_MUCUSER + '"]/item/reason');
    xp_muc_destroy_reason := TXPLite.Create('//x[@xmlns="' + XMLNS_MUCUSER + '"]/destroy/reason');

    Classes.RegisterClass(TfrmRoom); //auto-open RTII
finalization
    xp_muc_reason.Free();
    xp_muc_item.Free();
    xp_muc_status.Free();
    xp_muc_presence.Free();
    room_list.Free();

end.
