unit JoinRoom;
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
    JabberID, XMLTag, Unicode,   
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls, TntStdCtrls, ComCtrls, TntComCtrls, ExtCtrls,
  TntExtCtrls;

type
  TfrmJoinRoom = class(TForm)
    frameButtons1: TframeButtons;
    Panel1: TPanel;
    Label2: TTntLabel;
    Label1: TTntLabel;
    lblPassword: TTntLabel;
    Label3: TTntLabel;
    txtServer: TTntComboBox;
    txtRoom: TTntEdit;
    txtPassword: TTntEdit;
    txtNick: TTntEdit;
    lblFetch: TTntLabel;
    lstRooms: TTntListBox;
    TntSplitter1: TTntSplitter;
    aniSearch: TAnimate;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lblFetchClick(Sender: TObject);
    procedure lstRoomsClick(Sender: TObject);
    procedure lstRoomsDblClick(Sender: TObject);
    procedure lstRoomsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    _cb: integer;

    procedure _addRoomJid(tmp: TJabberID);

  published
    procedure EntityCallback(event: string; tag: TXMLTag);

  public
    { Public declarations }
    procedure populateServers();
  end;

var
  frmJoinRoom: TfrmJoinRoom;

procedure StartJoinRoom; overload;
procedure StartJoinRoom(room_jid: TJabberID; nick, password: WideString); overload; 

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Entity, EntityCache, ExUtils, GnuGetText, Jabber1, Session, Room;

const
    sInvalidNick = 'You must enter a nickname';
    sInvalidRoomJID = 'The Room Address you entered is invalid. It must be valid Jabber ID.';

{$R *.DFM}

{---------------------------------------}
procedure StartJoinRoom;
var
    f: TfrmJoinRoom;
begin
    f := TfrmJoinRoom.Create(Application);
    with f do begin
        txtRoom.Text := MainSession.Prefs.getString('tc_lastroom');
        txtServer.Text := MainSession.Prefs.getString('tc_lastserver');
        txtNick.Text := MainSession.Prefs.getString('tc_lastnick');
        if (txtNick.Text = '') then
            txtNick.Text := MainSession.Prefs.getString('default_nick');
        if (txtNick.Text = '') then
            txtNick.Text := MainSession.Username;
        populateServers();
        Show;
    end;
end;

{---------------------------------------}
procedure StartJoinRoom(room_jid: TJabberID; nick, password: WideString); overload;
var
    f: TfrmJoinRoom;
begin
    f := TfrmJoinRoom.Create(Application);
    with f do begin
        txtRoom.Text := room_jid.user;
        txtServer.Text := room_jid.domain;
        txtNick.Text := nick;

        if (txtNick.Text = '') then
            txtNick.Text := MainSession.Username;

        populateServers();
        Show;
    end;
end;

{---------------------------------------}
procedure TfrmJoinRoom.populateServers();
var
    l: TWidestringlist;
    i: integer;
    tmp: TJabberID;
    ce: TJabberEntity;
begin
    txtServer.Items.Clear();
    l := TWidestringlist.Create();
    jEntityCache.getByFeature(FEAT_GROUPCHAT, l);
    for i := 0 to l.Count - 1 do begin
        tmp := TJabberID.Create(l[i]);
        if (tmp.user <> '') then
            _addRoomJid(tmp)
        else begin
            ce := jEntityCache.getByJid(l[i]);
            if (not ce.hasItems) then begin
                ce.walk(MainSession);
                aniSearch.Visible := true;
                aniSearch.Active := true;
            end;
        end;
    end;
    l.Free();

    if (lstRooms.Items.Count > 0) then
        lstRooms.ItemIndex := 0;
end;

{---------------------------------------}
procedure TfrmJoinRoom._addRoomJid(tmp: TJabberID);
var
    tmps, n: Widestring;
    idx: integer;
    tj: TJabberID;
begin
    n := tmp.User;
    idx := lstRooms.Items.IndexOf(n);
    if (idx = -1) then
        lstRooms.Items.AddObject(n, tmp)
    else begin
        // we have a conflict
        tj := TJabberID(lstRooms.Items.Objects[idx]);
        if (tj.domain = tmp.domain) then exit;

        tmps := n + ' (' + tmp.domain + ')';
        lstRooms.Items.AddObject(tmps, tmp);
    end;

end;

{---------------------------------------}
procedure TfrmJoinRoom.EntityCallback(event: string; tag: TXMLTag);
var
    tmp: TJabberID;
    ce: TJabberEntity;
begin
    aniSearch.Visible := false;
    aniSearch.Active := false;
    tmp := TJabberID.Create(tag.getAttribute('from'));
    if (tmp.user = '') then begin
        tmp.Free();
        exit;
    end;

    ce := jEntityCache.getByJid(tmp.full);
    if (ce = nil) then begin
        tmp.Free();
        exit;
    end;

    if (ce.hasFeature(FEAT_GROUPCHAT)) then
        _addRoomJid(tmp);
end;

{---------------------------------------}
procedure TfrmJoinRoom.frameButtons1btnOKClick(Sender: TObject);
var
    pass: Widestring;
    rjid: Widestring;
begin
    // join this room
    rjid := txtRoom.Text + '@' + txtServer.Text;
    if (not isValidJid(rjid)) then begin
        MessageDlgW(_(sInvalidRoomJID), mtError, [mbOK], 0);
        exit;
    end;

    if (txtNick.Text = '') then begin
        MessageDlgW(_(sInvalidNick), mtError, [mbOK], 0);
        exit;
    end;

    pass := Trim(txtPassword.Text);
    StartRoom(rjid, txtNick.Text, pass);

    with MainSession.Prefs do begin
        setString('tc_lastroom', txtRoom.Text);
        setString('tc_lastserver', txtServer.Text);
        setString('tc_lastnick', txtNick.Text);
    end;

    Self.Close;
end;

{---------------------------------------}
procedure TfrmJoinRoom.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmJoinRoom.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmJoinRoom.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self);
    AssignUnicodeURL(lblFetch.Font, 8);
    TranslateComponent(Self);
    _cb := MainSession.RegisterCallback(EntityCallback, '/session/entity/info');
end;

{---------------------------------------}
procedure TfrmJoinRoom.FormDestroy(Sender: TObject);
var
    i: integer;
begin
    for i := 0 to lstRooms.Items.Count - 1 do
        TJabberID(lstRooms.Items.Objects[i]).Free();

    if (MainSession <> nil) then
        MainSession.UnRegisterCallback(_cb);
end;

{---------------------------------------}
procedure TfrmJoinRoom.lblFetchClick(Sender: TObject);
begin
    // Walk this server.
    aniSearch.Visible := true;
    aniSearch.Active := true;
    jEntityCache.fetch(txtServer.Text, MainSession, false);
end;

{---------------------------------------}
procedure TfrmJoinRoom.lstRoomsClick(Sender: TObject);
var
    i: integer;
    j: TJabberID;
begin
    i := lstRooms.ItemIndex;
    if (i = -1) then exit;
    j := TJabberID(lstRooms.Items.Objects[i]);
    txtServer.Text := j.domain;
    txtRoom.Text := j.user;
end;

{---------------------------------------}
procedure TfrmJoinRoom.lstRoomsDblClick(Sender: TObject);
var
    i: integer;
    j: TJabberID;
begin
    i := lstRooms.ItemIndex;
    if (i = -1) then exit;

    j := TJabberID(lstRooms.Items.Objects[i]);
    txtServer.Text := j.domain;
    txtRoom.Text := j.user;

    frameButtons1btnOKClick(Self);    
end;

{---------------------------------------}
procedure TfrmJoinRoom.lstRoomsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
    tmps: Widestring;
    p: TPoint;
    i: integer;
    j: TJabberID;
begin
    p.X := X;
    p.Y := Y;
    i := lstRooms.ItemAtPos(p, true);
    if (i = -1) then
        tmps := ''
    else begin
        j := TJabberID(lstRooms.Items.Objects[i]);
        tmps := j.full;
    end;

    if (tmps <> lstRooms.Hint) then begin
        lstRooms.Hint := tmps;
        Application.CancelHint;
    end;
end;

end.
