unit JoinRoom;
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
    JabberID, XMLTag, Unicode, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Wizard, ComCtrls, TntComCtrls, StdCtrls, TntStdCtrls, ExtCtrls,
    TntExtCtrls;

type
  TfrmJoinRoom = class(TfrmWizard)
    Label2: TTntLabel;
    Label1: TTntLabel;
    lblPassword: TTntLabel;
    Label3: TTntLabel;
    txtServer: TTntComboBox;
    txtRoom: TTntEdit;
    txtPassword: TTntEdit;
    txtNick: TTntEdit;
    optSpecify: TTntRadioButton;
    optBrowse: TTntRadioButton;
    TabSheet2: TTabSheet;
    lstRooms: TTntListView;
    Panel2: TPanel;
    lblFetch: TTntLabel;
    txtServerFilter: TTntComboBox;
    btnFetch: TTntButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNextClick(Sender: TObject);
    procedure btnFetchClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure optSpecifyClick(Sender: TObject);
    procedure txtServerFilterKeyPress(Sender: TObject; var Key: Char);
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
{$R *.DFM}
uses
    Entity, EntityCache, ExUtils, GnuGetText, Jabber1, Session, Room;

const
    sInvalidNick = 'You must enter a nickname';
    sInvalidRoomJID = 'The Room Address you entered is invalid. It must be valid Jabber ID.';

{---------------------------------------}
procedure StartJoinRoom;
var
    jr: TfrmJoinRoom;
begin
    jr := TfrmJoinRoom.Create(Application);
    with jr do begin
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
    jr: TfrmJoinRoom;
begin
    jr := TfrmJoinRoom.Create(Application);
    with jr do begin
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
    tmp := TJabberID.Create('');
    for i := 0 to l.Count - 1 do begin
        tmp.ParseJID(l[i]);
        if (tmp.user <> '') then
            _addRoomJid(tmp)
        else begin
            txtServer.Items.Add(l[i]);
            txtServerFilter.Items.Add(l[i]);
            ce := jEntityCache.getByJid(l[i]);
            if (not ce.hasItems) then begin
                ce.walk(MainSession);
            end;
        end;
    end;
    tmp.Free();
    l.Free();
end;

{---------------------------------------}
procedure TfrmJoinRoom.FormCreate(Sender: TObject);
begin
    tabSheet1.TabVisible := false;
    tabSheet2.TabVisible := false;
    Tabs.ActivePage := tabSheet1;

    AssignUnicodeFont(Self);
    TranslateComponent(Self);
    _cb := MainSession.RegisterCallback(EntityCallback, '/session/entity/info');
end;

{---------------------------------------}
procedure TfrmJoinRoom.FormDestroy(Sender: TObject);
begin
    {
    for i := 0 to lstRooms.Items.Count - 1 do
        TJabberID(lstRooms.Items.Objects[i]).Free();
    }
    if (MainSession <> nil) then
        MainSession.UnRegisterCallback(_cb);
end;

{---------------------------------------}
procedure TfrmJoinRoom.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmJoinRoom.btnNextClick(Sender: TObject);
var
    pass: Widestring;
    rjid: Widestring;
    li: TTntListItem;
begin
    if ((Tabs.ActivePage = tabSheet1) and (optBrowse.Checked)) then begin
        // change tabs if they selected browse
        Tabs.ActivePage := tabSheet2;
        btnBack.Enabled := true;
        btnNext.Caption := _('Finish');
        exit;
    end;

    // otherwise, just join..
    if (Tabs.ActivePage = tabSheet1) then begin
        rjid := txtRoom.Text + '@' + txtServer.Text;
        if (not isValidJid(rjid)) then begin
            MessageDlgW(_(sInvalidRoomJID), mtError, [mbOK], 0);
            exit;
        end;
    end
    else begin
        li := lstRooms.Selected;
        if (li = nil) then exit;
        rjid := li.Caption + '@' + li.SubItems[0];
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
    exit;

end;

{---------------------------------------}
procedure TfrmJoinRoom.btnFetchClick(Sender: TObject);
begin
    jEntityCache.fetch(txtServerFilter.Text, MainSession, false);
end;

{---------------------------------------}
procedure TfrmJoinRoom._addRoomJid(tmp: TJabberID);
var
    tmps, n: Widestring;
    li: TTntListItem;
begin
    n := tmp.User;
    tmps := tmp.Domain;
    li := lstRooms.Items.Add();
    li.Caption := n;
    li.SubItems.Add(tmps);
end;

{---------------------------------------}
procedure TfrmJoinRoom.EntityCallback(event: string; tag: TXMLTag);
var
    tmp: TJabberID;
    ce: TJabberEntity;
begin
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
    tmp.Free();
end;

{---------------------------------------}
procedure TfrmJoinRoom.btnBackClick(Sender: TObject);
begin
    if (Tabs.ActivePage = tabSheet2) then begin
        Tabs.ActivePage := tabSheet1;
        btnNext.Caption := _('Next >');
        btnBack.Enabled := false;
    end;
end;

{---------------------------------------}
procedure TfrmJoinRoom.btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

{---------------------------------------}
procedure TfrmJoinRoom.optSpecifyClick(Sender: TObject);
begin
    txtServer.Enabled := optSpecify.Checked;
    txtRoom.Enabled := optSpecify.Checked;
    txtPassword.Enabled := optSpecify.Checked;
end;

procedure TfrmJoinRoom.txtServerFilterKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
    if (Key = Chr(13)) then begin
        jEntityCache.fetch(txtServerFilter.Text, MainSession, false);
    end;
end;

end.
