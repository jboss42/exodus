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
    JabberID, XMLTag,  
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls, TntStdCtrls;

type
  TfrmJoinRoom = class(TForm)
    Label1: TTntLabel;
    Label2: TTntLabel;
    Label3: TTntLabel;
    txtRoom: TTntEdit;
    txtNick: TTntEdit;
    frameButtons1: TframeButtons;
    txtServer: TTntComboBox;
    txtPassword: TTntEdit;
    lblPassword: TTntLabel;
    optSpecify: TTntRadioButton;
    optList: TTntRadioButton;
    lstRooms: TTntListBox;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure optSpecifyClick(Sender: TObject);
    procedure lstRoomsDblClick(Sender: TObject);
  private
    { Private declarations }
    _cb: integer;
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

resourcestring
    sInvalidNick = 'You must enter a nickname';

implementation
uses
    Entity, EntityCache, ExUtils, GnuGetText, Jabber1, Session, Room, Unicode;
{$R *.DFM}

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

    tmp := TJabberID.Create('');
    for i := 0 to l.Count - 1 do begin
        tmp.ParseJID(l[i]);
        if (tmp.user = '') then begin
            txtServer.Items.Add(l[i]);
            ce := jEntityCache.getByJid(l[i]);
            if (not ce.hasItems) then
                ce.walk(MainSession);
        end
        else
            lstRooms.Items.Add(l[i]);
    end;
    tmp.Free();
    l.Free();
end;

procedure TfrmJoinRoom.EntityCallback(event: string; tag: TXMLTag);
var
    tmp: TJabberID;
    ce: TJabberEntity;
begin
    tmp := TJabberID.Create(tag.getAttribute('from'));
    if (tmp.user = '') then exit;

    ce := jEntityCache.getByJid(tmp.full);
    if (ce = nil) then exit;

    if (ce.hasFeature(FEAT_GROUPCHAT)) then
        lstRooms.Items.Add(tmp.full);
    tmp.Free();
end;

procedure TfrmJoinRoom.frameButtons1btnOKClick(Sender: TObject);
var
    pass: Widestring;
    rjid: Widestring;
    tmp: TJabberID;
begin
    // join this room
    if (optList.Checked) then begin
        tmp := TJabberID.Create(lstRooms.Items[lstRooms.ItemIndex]);
        txtRoom.Text := tmp.user;
        txtServer.Text := tmp.domain;
    end;

    rjid := txtRoom.Text + '@' + txtServer.Text;
    if (not isValidJid(rjid)) then begin
        MessageDlg(sInvalidRoomJID, mtError, [mbOK], 0);
        exit;
    end;

    if (txtNick.Text = '') then begin
        MessageDlg(sInvalidNick, mtError, [mbOK], 0);
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

procedure TfrmJoinRoom.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmJoinRoom.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmJoinRoom.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
    _cb := MainSession.RegisterCallback(EntityCallback, '/session/entity/info');
end;

procedure TfrmJoinRoom.FormDestroy(Sender: TObject);
begin
    if (MainSession <> nil) then
        MainSession.UnRegisterCallback(_cb);
end;

procedure TfrmJoinRoom.optSpecifyClick(Sender: TObject);
begin
    txtServer.Enabled := optSpecify.Checked;
    txtRoom.Enabled := optSpecify.Checked;
    lstRooms.Enabled := optList.Checked;
end;

procedure TfrmJoinRoom.lstRoomsDblClick(Sender: TObject);
begin
    frameButtons1btnOKClick(Self);
end;

end.
