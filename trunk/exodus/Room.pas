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
    Dialogs, BaseChat, ComCtrls, StdCtrls, Menus, OLERichEdit, ExRichEdit,
    ExtCtrls;

type
  TRoomMember = class
  public
    Nick: string;
    jid: string;
    Node: TTreeNode;
  end;

  TfrmRoom = class(TfrmBaseChat)
    lblSubject: TLabel;
    lblSubjectURL: TLabel;
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
  private
    { Private declarations }
    jid: string;                // jid of the conf. room
    _roster: TStringlist;       // roster for this room
    _isGC: boolean;
    _callback: integer;         // Message Callback
    _pcallback: integer;        // Presence Callback
    _scallback: integer;        // Session callback
    _nick_prefix: string;       // stuff for nick completion:
    _nick_idx: integer;
    _nick_len: integer;
    _nick_start: integer;
    _keywords: TRegExpr;     // list of keywords to monitor for

    procedure SetJID(sjid: string);
    procedure ShowMsg(tag: TXMLTag);
    procedure SendMsg;
    procedure RemoveMember(member: TRoomMember);
    function  AddMember(member: TRoomMember): TTreeNode;
    function  checkCommand(txt: string): boolean;
    // procedure ShowPresence(nick, msg: string);
    procedure RenderMember(member: TRoomMember; tag: TXMLTag);
    procedure changeSubject(subj: string);
  published
    procedure MsgCallback(event: string; tag: TXMLTag);
    procedure PresCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);

  public
    { Public declarations }
    mynick: string;
  end;

var
  frmRoom: TfrmRoom;
  room_list: TStringList;

function StartRoom(rjid, rnick: string): TfrmRoom;

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
    JabberMsg, Jabber1;

{$R *.DFM}

{---------------------------------------}
function StartRoom(rjid, rnick: string): TfrmRoom;
var
    f: TfrmRoom;
    p: TJabberPres;
    tmp_jid: TJabberID;
begin
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
        //treeRoster.Font.Assign(MsgList.Font);
        Caption := tmp_jid.user + ' Room';
        Show;
        end;

    if f.TabSheet <> nil then
        frmJabber.Tabs.ActivePage := f.TabSheet;

    tmp_jid.Free();
    room_list.Add(rjid);
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
    from: string;
    tmp_jid: TJabberID;
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
        end
    else begin
        Msg.Nick := TRoomMember(_roster.Objects[i]).Nick;
        Msg.IsMe := (Msg.Nick = MyNick);
        end;

    if (Msg.Body <> '') then
        DisplayMsg(Msg, MsgList);

    if Msg.Subject <> '' then begin
        lblSubject.Caption := '  ' + Msg.Subject;
        lblSubject.Hint := Msg.Subject;
        end;

    // check for keywords
    if ((not Application.Active) and (not MainSession.IsPaused) and (_keywords <> nil)) then begin
        if (_keywords.Exec(Msg.Body)) then begin
            ShowRiserWindow('Keyword in ' + Self.Caption + ': ' + _keywords.Match[1], 12);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.SendMsg;
var
    txt: string;
    msg: TJabberMessage;
begin
    // Send the actual message out
    txt := MsgOut.Text;
    if (Trim(txt) = '') then exit;

    if (txt[1] = '/') then begin
        if (checkCommand(txt)) then exit;
        end;
    msg := TJabberMessage.Create(jid, 'groupchat', MsgOut.Text, '');
    msg.nick := MyNick;
    msg.isMe := true;
    MainSession.SendTag(msg.Tag);
    MsgOut.Text := '';
    MsgOut.SetFocus;
end;

{---------------------------------------}
function TfrmRoom.checkCommand(txt: string): boolean;
var
    l, i: integer;
    c, tmps, tok: string;
    p: TJabberPres;
begin
    // check for various / commands
    result := false;
    tmps := Lowercase(trim(txt));
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
        DisplayPresence('You have been disconnected', MsgList);

        MainSession.UnRegisterCallback(_callback);
        MainSession.UnRegisterCallback(_pcallback);
        // MainSession.UnRegisterCallback(_scallback);

        _callback := 0;
        _pcallback := 0;
        _scallback := 0;
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
    ptype, from: string;
    _jid: TJabberID;
    i: integer;
    member: TRoomMember;
begin
    // We are getting presence
    from := tag.getAttribute('from');
    ptype := tag.getAttribute('type');
    _jid := TJabberID.Create(from);
    i := _roster.indexOf(from);
    if ptype = 'unavailable' then begin
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

        if p.Show = 'away' then member.Node.ImageIndex := 2
        else if p.Show = 'xa' then member.Node.ImageIndex := 10
        else if p.Show = 'dnd' then member.Node.ImageIndex := 3
        else if p.Show = 'chat' then member.Node.ImageIndex := 4
        else member.Node.ImageIndex := 1;
        end;

    member.Node.SelectedIndex := member.Node.ImageIndex;
end;

{---------------------------------------}
{
procedure TfrmRoom.ShowPresence(nick, msg: string);
var
    txt: string;
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
    e : string;
    first : bool;
    re : bool;
begin
    // Create
    _callback := -1;
    _pcallback := -1;
    _scallback := -1;
    _roster := TStringList.Create;
    _isGC := true;
    _nick_prefix := '';
    _nick_idx := 0;
    _nick_start := 0;

    kw_list := MainSession.Prefs.getStringlist('keywords');
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

    MyNick := '';
end;

{---------------------------------------}
procedure TfrmRoom.SetJID(sjid: string);
begin
    // setup our callbacks
    if (_callback < 0) then begin
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
    tmps: string;
    prefix: string;
    i: integer;
    found, exloop: boolean;
    nick: string;
begin
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
    if (_callback >= 0) then begin
        p := TJabberPres.Create();
        p.toJID := TJabberID.Create(jid);
        p.PresType := 'unavailable';
        MainSession.SendTag(p);
        MainSession.UnRegisterCallback(_callback);
        MainSession.UnRegisterCallback(_pcallback);
        MainSession.UnRegisterCallback(_scallback);
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
    i: integer;
    rm: TRoomMember;
    node: TTreeNode;
    tmp_jid: TJabberID;
    sel_nick: string;
begin
    // Chat w/ this person..
    node := treeRoster.Selected;
    if node = nil then exit;

    sel_nick := node.Text;
    for i := 0 to _roster.Count - 1 do begin
        rm := TRoomMember(_roster.Objects[i]);
        if (rm.Nick = sel_nick) then begin
            tmp_jid := TJabberID.Create(rm.jid);
            StartChat(tmp_jid.jid, tmp_jid.resource, true, sel_nick);
            tmp_jid.Free();
            end;
        end;
end;

procedure TfrmRoom.changeSubject(subj: string);
var
    msg: TJabberMessage;
begin
    // send the msg out
    msg := TJabberMessage.Create(jid,
                                 'groupchat',
                                 '/me changed the subject to: ' + subj,
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
    if InputQuery('Change Room Subject', 'New Subject', s) then begin
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
    if (InputQuery('Nickname', 'New Nickname', new_nick)) then begin
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

    if (inputQuery('Bookmark Room', 'Enter Bookmark Name: ', bm_name)) then begin
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

initialization
    room_list := TStringlist.Create();

finalization
    room_list.Free();

end.
