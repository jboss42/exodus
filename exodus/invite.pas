unit Invite;
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls, buttonFrame, ComCtrls, Grids;

type
  TfrmInvite = class(TForm)
    frameButtons1: TframeButtons;
    pnlMain: TPanel;
    lstJIDS: TListView;
    Splitter1: TSplitter;
    Panel1: TPanel;
    btnRemove: TButton;
    Panel2: TPanel;
    memReason: TMemo;
    Label2: TLabel;
    pnl1: TPanel;
    cboRoom: TComboBox;
    Label1: TLabel;
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstJIDSDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lstJIDSDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnRemoveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddRecip(jid: string);
  end;

var
  frmInvite: TfrmInvite;

resourcestring
    sConfRoom = 'Conference Room:';

procedure ShowInvite(room_jid: string; jids: TStringList);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberID, 
    XMLTag,
    Session,
    Room, 
    RosterWindow,
    Roster;

{$R *.dfm}

{---------------------------------------}
procedure ShowInvite(room_jid: string; jids: TStringList);
var
    i: integer;
    f: TfrmInvite;
begin
    f := TfrmInvite.Create(Application);
    f.cboRoom.Text := room_jid;

    // Only add the jids selected
    if (jids <> nil) then begin
        for i := 0 to jids.Count - 1 do
            f.AddRecip(jids[i]);
        end;
    f.Show;
end;

{---------------------------------------}
procedure TfrmInvite.AddRecip(jid: string);
var
    i: integer;
    cap: string;
    ritem: TJabberRosterItem;
    n: TListItem;
begin
    ritem := MainSession.roster.Find(jid);
    if ritem <> nil then
        cap := ritem.nickname
    else
        cap := jid;

    // make sure we don't already have an item w/ this caption
    for i := 0 to lstJIDS.Items.Count - 1 do
        if (lstJIDS.Items[i].SubItems[0] = jid) then exit;

    n := lstJIDS.Items.Add();
    n.Caption := cap;
    n.SubItems.Add(jid);
end;

{---------------------------------------}
procedure TfrmInvite.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmInvite.frameButtons1btnOKClick(Sender: TObject);
var
    i: integer;
    msg: TXMLTag;
    room: string;
    room_idx: integer;
begin
    // Make sure we are actually in this room...
    room := cboRoom.Text;

    if (not isValidJID(room)) then begin
        MessageDlg(sInvalidRoomJID, mtError, [mbOK], 0);
        exit;
        end;

    room_idx := room_list.IndexOf(room);
    if (room_idx < 0) then
        StartRoom(room, MainSession.Username);

    // Send out invites.
    memReason.Lines.Add(sConfRoom + ' ' + room);
    for i := 0 to lstJIDS.Items.Count - 1 do begin
        msg := TXMLTag.Create('message');
        msg.PutAttribute('to', lstJIDS.Items[i].SubItems[0]);
        with msg.AddTag('x') do begin
            putAttribute('xmlns', 'jabber:x:conference');
            putAttribute('jid', room);
            end;
        msg.AddBasicTag('body', memReason.Lines.Text);
        MainSession.SendTag(msg);
        end;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmInvite.FormCreate(Sender: TObject);
begin
    // make the form the same width as the list view
    Self.ClientWidth := pnlMain.Width + 2;
    cboRoom.Items.Assign(room.room_list);
    pnlMain.Align := alClient;
end;

{---------------------------------------}
procedure TfrmInvite.lstJIDSDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    // accept roster items from the main roster as well
    // as the string grid on this form
    Accept := (Source = frmRosterWindow.treeRoster);
end;

{---------------------------------------}
procedure TfrmInvite.lstJIDSDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    r, n: TTreeNode;
    i,j: integer;
begin
    // dropping from main roster window
    with frmRosterWindow.treeRoster do begin
        for i := 0 to SelectionCount - 1 do begin
            n := Selections[i];
            if ((n.Data <> nil) and (TObject(n.Data) is TJabberRosterItem)) then
                // We have a roster item
                Self.AddRecip(TJabberRosterItem(n.Data).jid.jid)
            else if (n.Level = 0) then begin
                // we prolly have a grp
                for j := 0 to n.Count - 1 do begin
                    r := n.Item[j];
                    if ((r.Data <> nil) and (TObject(r.Data) is TJabberRosterItem)) then
                        Self.AddRecip(TJabberRosterItem(r.Data).jid.jid);
                    end;
                end;
            end;
        end;
end;

{---------------------------------------}
procedure TfrmInvite.btnRemoveClick(Sender: TObject);
var
    i: integer;
begin
    // Remove all the selected items
    for i := lstJIDS.Items.Count - 1 downto 0 do begin
        if lstJIDS.Items[i].Selected then
            lstJIDS.Items.Delete(i);
        end;
end;

procedure TfrmInvite.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

end.
