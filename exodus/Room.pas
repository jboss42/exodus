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
    XMLTag, RegExpr,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, BaseChat, ComCtrls, StdCtrls, Menus, ExRichEdit, ExtCtrls,
    RichEdit2, TntStdCtrls, Buttons;

type
  TRoomMember = class
  public
    Nick: Widestring;
    jid: Widestring;
    Node: TTreeNode;
    status: Widestring;
    show: Widestring;
    blockShow: Widestring;
  end;

  TfrmRoom = class(TfrmBaseChat)
    Panel6: TPanel;
    treeRoster: TTreeView;
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
    lblSubject: TLabel;
    lblSubjectURL: TLabel;
    btnClose: TSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure MsgOutKeyPress(Sender: TObject; var Key: Char);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure treeRosterDblClick(Sender: TObject);
    procedure lblSubjectURLClick(Sender: TObject);
    procedure treeRosterDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure treeRosterDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure popClearClick(Sender: TObject);
    procedure popNickClick(Sender: TObject);
    procedure popCloseClick(Sender: TObject);
    procedure popBookmarkClick(Sender: TObject);
    procedure popInviteClick(Sender: TObject);
    procedure MsgListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure treeRosterMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mnuOnTopClick(Sender: TObject);
    procedure popRosterBlockClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure popRoomRosterPopup(Sender: TObject);
  private
    { Private declarations }
    jid: Widestring;                // jid of the conf. room
    _roster: TStringlist;       // roster for this room
    _isGC: boolean;
    _callback: integer;         // Message Callback
    _pcallback: integer;        // Presence Callback
    _scallback: integer;        // Session callback
    _nick_prefix: Widestring;       // stuff for nick completion:
    _nick_idx: integer;
    _nick_len: integer;
    _nick_start: integer;
    _keywords: TRegExpr;     // list of keywords to monitor for
    _hint_text: Widestring;

    function  AddMember(member: TRoomMember): TTreeNode;
    function  checkCommand(txt: Widestring): boolean;
    function  GetCurrentMember(): TRoomMember;

    procedure SetJID(sjid: Widestring);
    procedure ShowMsg(tag: TXMLTag);
    procedure RemoveMember(member: TRoomMember);
    procedure RenderMember(member: TRoomMember; tag: TXMLTag);
    procedure changeSubject(subj: Widestring);
  published
    procedure MsgCallback(event: string; tag: TXMLTag);
    procedure PresCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
    mynick: Widestring;
    procedure SendMsg; override;
    function GetNick(rjid: Widestring): Widestring;
    property HintText: Widestring read _hint_text;
  end;

var
  frmRoom: TfrmRoom;
  room_list: TStringList;

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

function StartRoom(rjid, rnick: Widestring): TfrmRoom;
function IsRoom(rjid: Widestring): boolean;
function FindRoomNick(rjid: Widestring): Widestring;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    ExUtils,
    RiserWindow,
    ShellAPI,
    RichEdit,
    Invite,
    ChatWin,
    RosterWindow,
    Presence,
    Roster,
    Session,
    JabberID,
    MsgDisplay,
    Notify,
    PrefController,
    JabberMsg, Jabber1;

{$R *.DFM}

{---------------------------------------}
function StartRoom(rjid, rnick: Widestring): TfrmRoom;
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
        MainSession.SendTag(p);
        if MainSession.Prefs.getBool('expanded') then
            f.DockForm;

        // setup prefs
        with f do begin
            AssignDefaultFont(MsgList.Font);
            MsgList.Color := TColor(MainSession.Prefs.getInt('color_bg'));
            MsgOut.Color := MsgList.Color;
            MsgOut.Font.Assign(MsgList.Font);
            treeRoster.Color := MsgList.Color;
            treeRoster.Font.Color := TColor(MainSession.Prefs.getInt('font_color'));
            Caption := tmp_jid.user + ' ' + sRoom;
            end;
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
begin
    // We are getting a msg
    if (tag.getAttribute('type') = 'groupchat') then
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
begin
    // display the body of the msg
    Msg := TJabberMessage.Create(tag);

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
            (MainSession.Prefs.getBool('log'))) then
            LogMessage(Msg);

        if (GetActiveWindow = Self.Handle) and (pnlInput.Visible) then
            MsgOut.SetFocus();
        end;

    if Msg.Subject <> '' then begin
        lblSubject.Caption := '  ' + Msg.Subject;
        lblSubject.Hint := Msg.Subject;
        end;

    // this check is needed only to prevent extraneous regexing.
    if ((not server) and
        (not MainSession.IsPaused)) then begin
        // check for keywords
        if ((_keywords <> nil) and (_keywords.Exec(Msg.Body))) then
            DoNotify(Self,
                     'notify_keyword',
                     sNotifyKeyword + Self.Caption + ': ' + _keywords.Match[1],
                     ico_conf)
        else
            DoNotify(Self,
                     'notify_roomactivity',
                     sNotifyActivity + Self.Caption,
                     ico_conf);
        end;

    Msg.Free();
end;

{---------------------------------------}
procedure TfrmRoom.SendMsg;
var
    txt: Widestring;
    msg: TJabberMessage;
begin
    // Send the actual message out
    // txt := MsgOut.WideText;
    // txt := getMemoText(MsgOut);
    txt := Trim(MsgOut.Text);

    if (txt = '') then exit;

    if (txt[1] = '/') then begin
        if (checkCommand(txt)) then exit;
        end;
    msg := TJabberMessage.Create(jid, 'groupchat', txt, '');
    msg.nick := MyNick;
    msg.isMe := true;
    MainSession.SendTag(msg.Tag);
    inherited;
end;

{---------------------------------------}
function TfrmRoom.checkCommand(txt: Widestring): boolean;
var
    l, i: integer;
    c, tmps, tok: Widestring;
    p: TJabberPres;
begin
    // check for various / commands
    result := false;
    tmps := trim(txt);
    i := 1;
    l := length(tmps);
    repeat
        inc(i);
        if (i < l) then
            c := tmps[i]
        else
            c := '';
    until (c = ' ') or (c = #9) or (i >= l);

    if (i < l) then begin
        tok := Copy(tmps, 1, i - 1);
        if (tok = '/nick') then begin
            // change nickname
            myNick := Trim(Copy(tmps, 6, length(tmps) - 5));
            p := TJabberPres.Create;
            p.toJID := TJabberID.Create(jid + '/' + myNick);
            MainSession.SendTag(p);
            MsgOut.Lines.Clear;
            Result := true;
            end
        else if (tok = '/clear') then begin
            msgList.Lines.Clear;
            Result := true;
            end
        else if (tok = '/subject') then begin
            // set subject
            tok := Trim(Copy(tmps, 9, length(tmps) - 8));
            changeSubject(tok);
            MsgOut.Lines.Clear;
            Result := true;
            end;
        end;

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

        MainSession.UnRegisterCallback(_callback);
        MainSession.UnRegisterCallback(_pcallback);
        // MainSession.UnRegisterCallback(_scallback);

        _callback := -1;
        _pcallback := -1;
        end
    else if (event = '/session/presence') then begin
        // We changed our own presence, send it to the room
        p := TJabberPres.Create();
        p.toJID := TJabberID.Create(self.jid);
        p.Show := MainSession.Show;
        p.Status := MainSession.Status;
        MainSession.SendTag(p);
        end;
end;

{---------------------------------------}
procedure TfrmRoom.presCallback(event: string; tag: TXMLTag);
var
    ptype, from: Widestring;
    _jid: TJabberID;
    i: integer;
    member: TRoomMember;
    etag: TXMLTag;
begin
    // We are getting presence
    from := tag.getAttribute('from');
    ptype := tag.getAttribute('type');
    _jid := TJabberID.Create(from);
    i := _roster.indexOf(from);

    if ((ptype = 'error') and (_jid.resource = mynick)) then begin
        // check for 409, conflicts.
        etag := tag.GetFirstTag('error');
        if ((etag <> nil) and (etag.GetAttribute('code') = '409')) then begin
            MessageDlg('Your selected Nickname is already in use. Please select another.',
                mtError, [mbOK], 0);
            Self.Close();
            end;
        end
        
    else if ptype = 'unavailable' then begin
        if (i >= 0) then begin
            member := TRoomMember(_roster.Objects[i]);
            // ShowPresence(member.Nick, ' has left the room.');
            RemoveMember(member);
            member.Free;
            _roster.Delete(i);
            end;
        end
    else begin
        if i < 0 then begin
            member := TRoomMember.Create;
            member.JID := from;
            member.Nick := _jid.resource;
            _roster.AddObject(from, member);
            member.Node := AddMember(member);
            // ShowPresence(member.Nick, ' has joined the room.');
            end
        else
            member := TRoomMember(_roster.Objects[i]);

        if _isGC then
            member.nick := _jid.resource;

        RenderMember(member, tag);
        end;
end;

{---------------------------------------}
function TfrmRoom.AddMember(member: TRoomMember): TTreeNode;
begin
    // add a node
    Result := treeRoster.Items.AddChild(nil, member.Nick);
    RenderMember(member, nil);
    treeRoster.AlphaSort(false);
end;

{---------------------------------------}
procedure TfrmRoom.RenderMember(member: TRoomMember; tag: TXMLTag);
var
    p: TJabberPres;
begin
    // show the member
    if member = nil then exit;
    if member.Node = nil then exit;

    if tag = nil then
        member.Node.ImageIndex := 1
    else begin
        p := TJabberPres.Create;
        p.parse(tag);

        if (member.show = sBlocked) then
           member.blockShow := p.Show
        else begin
            if p.Show = 'away' then member.Node.ImageIndex := 2
            else if p.Show = 'xa' then member.Node.ImageIndex := 10
            else if p.Show = 'dnd' then member.Node.ImageIndex := 3
            else if p.Show = 'chat' then member.Node.ImageIndex := 4
            else member.Node.ImageIndex := 1;

            member.show := p.Show;
            end;

        member.status := p.Status;
        end;

    if (member.show = '') then
        member.show := 'Available';

    member.Node.SelectedIndex := member.Node.ImageIndex;
    member.Node.Data := member;
end;

{---------------------------------------}
{
procedure TfrmRoom.ShowPresence(nick, msg: Widestring);
var
    txt: Widestring;
begin
    txt := '[' + formatdatetime('HH:MM',now) + '] ' + nick + msg;
    DisplayPresence(txt, MsgList);
end;
}

{---------------------------------------}
procedure TfrmRoom.RemoveMember(member: TRoomMember);
begin
    // delete this node
    if (member.Node <> nil) then
        member.Node.Free;
end;

{---------------------------------------}
procedure TfrmRoom.FormCreate(Sender: TObject);
var
    kw_list : TStringList;
    i : integer;
    e : Widestring;
    first : bool;
    re : bool;
begin
    inherited;

    // Create
    _callback := -1;
    _pcallback := -1;
    _scallback := -1;
    _roster := TStringList.Create;
    _roster.CaseSensitive := true;
    _isGC := true;
    _nick_prefix := '';
    _nick_idx := 0;
    _nick_start := 0;
    _hint_text := '';

    if (MainSession.Prefs.getInt('notify_keyword') <> 0) then begin
        kw_list := TStringList.Create();
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

    MyNick := '';
end;

{---------------------------------------}
procedure TfrmRoom.SetJID(sjid: Widestring);
begin
    // setup our callbacks
    if (_callback = -1) then begin
        _callback := MainSession.RegisterCallback(MsgCallback, '/packet/message[@type="groupchat"][@from="' + sjid + '*"]');
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
            for i := _nick_idx to treeRoster.Items.Count - 1 do begin
                nick := treeRoster.Items[i].Text;
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
    // else if ( (Key = #13) and not(Returns.Down)) then
    else if (Key = #13) then
        SendMsg()
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
var
    p: TJabberPres;
    i: integer;
begin
    // Unregister callbacks and send unavail pres.
    MainSession.UnRegisterCallback(_callback);
    MainSession.UnRegisterCallback(_pcallback);
    MainSession.UnRegisterCallback(_scallback);

    if ((MainSession <> nil) and (MainSession.Active)) then begin
        p := TJabberPres.Create();
        p.toJID := TJabberID.Create(jid);
        p.PresType := 'unavailable';
        MainSession.SendTag(p);
        end;

    _keywords.Free;
    i := room_list.IndexOf(jid);
    if (i >= 0) then
        room_list.Delete(i);
    Action := caFree;

    inherited;
end;

{---------------------------------------}
procedure TfrmRoom.treeRosterDblClick(Sender: TObject);
var
    rm: TRoomMember;
    tmp_jid: TJabberID;
    chat_win: TfrmChat;
begin
    // Chat w/ this person..
    rm := GetCurrentMember();
    if (rm <> nil) then begin
        tmp_jid := TJabberID.Create(rm.jid);
        chat_win := StartChat(tmp_jid.jid, tmp_jid.resource, true, rm.Nick);
        if (chat_win.TabSheet <> nil) then
            frmExodus.Tabs.ActivePage := chat_win.TabSheet;
        tmp_jid.Free();
        end;
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
    s: string;
begin
    // Change the subject
    s := lblSubject.Caption;
    if InputQuery(sRoomSubjPrompt, sRoomNewSubj, s) then begin
        changeSubject(s);
        end;
end;

{---------------------------------------}
procedure TfrmRoom.treeRosterDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := (Source = frmRosterWindow.treeRoster);
end;

{---------------------------------------}
procedure TfrmRoom.treeRosterDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    r, n: TTreeNode;
    ritem: TJabberRosterItem;
    i,j: integer;
    jids: TStringList;
begin
    if (Source = frmRosterWindow.treeRoster) then begin
        // We want to invite someone into this TC room
        jids := TStringList.Create;
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
procedure TfrmRoom.popClearClick(Sender: TObject);
begin
  inherited;
    MsgList.Lines.Clear;
end;

{---------------------------------------}
procedure TfrmRoom.popNickClick(Sender: TObject);
var
    new_nick: string;
    p: TJabberPres;
begin
  inherited;
    new_nick := myNick;
    if (InputQuery(sRoomNewNick, sRoomNewNick, new_nick)) then begin
        if (new_nick = myNick) then exit;
        p := TJabberPres.Create;
        p.toJID := TJabberID.Create(jid + '/' + new_nick);
        MainSession.SendTag(p);
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
    bm_name: string;
begin
  inherited;
    // bookmark this room..
    bm_name := Self.jid;

    if (inputQuery(sRoomBMPrompt, sRoomNewBookmark, bm_name)) then begin
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
    ShowInvite(Self.jid, nil);
end;

{---------------------------------------}
procedure TfrmRoom.MsgListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    cp: TPoint;
begin
  inherited;
    if Button = mbRight then begin
        GetCursorPos(cp);
        popRoom.Popup(cp.x, cp.y);
        end;
end;

{---------------------------------------}
procedure TfrmRoom.treeRosterMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
    n: TTreeNode;
    m: TRoomMember;
begin
  inherited;
    // setup _hint_text

    n := treeRoster.GetNodeAt(x,y);
    if (n = nil) then
        _hint_text := ''
    else begin
        m := TRoomMember(n.Data);
        if (m = nil) then
            _hint_text := ''
        else begin
            _hint_text := m.show;
            if (m.status <> '') then
                _hint_text := _hint_text + ': ' + m.status;
            end;
        end;
end;

{---------------------------------------}
function TfrmRoom.GetNick(rjid: Widestring): Widestring;
var
    i: integer;
begin
    //
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
    rm := GetCurrentMember();
    if (rm <> nil) then begin
       if (rm.show = sBlocked) then begin
          //unblock
          rm.show := rm.blockShow;

          if rm.Show = 'away' then rm.Node.ImageIndex := 2
          else if rm.Show = 'xa' then rm.Node.ImageIndex := 10
          else if rm.Show = 'dnd' then rm.Node.ImageIndex := 3
          else if rm.Show = 'chat' then rm.Node.ImageIndex := 4
          else rm.Node.ImageIndex := 1;

          rm.Node.SelectedIndex := rm.Node.ImageIndex;
          end
       else begin
          //block
          rm.blockShow := rm.show;
          rm.show := sBlocked;
          rm.Node.ImageIndex := 25;
          rm.Node.SelectedIndex := rm.Node.ImageIndex;
          end;
       end;
end;

{---------------------------------------}
procedure TfrmRoom.popRoomRosterPopup(Sender: TObject);
var
    rm: TRoomMember;
begin
  rm := GetCurrentMember();
  if (rm <> nil) then begin
     if (rm.show = sBlocked) then
        popRosterBlock.Caption := sUnblock
     else
        popRosterBlock.Caption := sBlock;
     end;
  inherited;
end;

{---------------------------------------}
function TfrmRoom.GetCurrentMember(): TRoomMember;
var
    i: integer;
    rm: TRoomMember;
    node: TTreeNode;
    sel_nick: Widestring;
begin
    result := nil;
    node := treeRoster.Selected;
    if node = nil then exit;

    sel_nick := node.Text;
    for i := 0 to _roster.Count - 1 do begin
        rm := TRoomMember(_roster.Objects[i]);
        if (rm.Nick = sel_nick) then begin
           result := rm;
           exit;
           end;
        end;
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
    btnClose.Visible := Docked;
end;

initialization
    room_list := TStringlist.Create();

finalization
    room_list.Free();

end.
