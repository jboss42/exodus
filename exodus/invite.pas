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
  Dialogs, StdCtrls, CheckLst, ExtCtrls, buttonFrame, ComCtrls;

type
  TfrmInvite = class(TForm)
    frameButtons1: TframeButtons;
    Panel1: TPanel;
    Label1: TLabel;
    lblJID: TLabel;
    Label2: TLabel;
    memReason: TMemo;
    Splitter1: TSplitter;
    lstJIDS: TListView;
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInvite: TfrmInvite;

procedure ShowInvite(room_jid: string; jids: TStringList);

implementation
uses
    XMLTag, 
    Session, 
    RosterWindow,
    Roster;

{$R *.dfm}

procedure ShowInvite(room_jid: string; jids: TStringList);
var
    i: integer;
    ritem: TJabberRosterItem;
    n: TListItem;
    f: TfrmInvite;
begin
    f := TfrmInvite.Create(nil);
    f.lblJID.Caption := room_jid;
    for i := 0 to MainSession.roster.Count - 1 do begin
        ritem := TJabberRosterItem(MainSession.roster.Objects[i]);
        n := f.lstJIDS.Items.Add;
        n.Caption := ritem.nickname;
        n.SubItems.Add(ritem.jid.jid);
        n.Checked := (jids.IndexOf(ritem.jid.jid) >= 0);
        end;

    f.Show;
end;

procedure TfrmInvite.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmInvite.frameButtons1btnOKClick(Sender: TObject);
var
    i: integer;
    msg: TXMLTag;
begin
    // Send out invites.
    for i := 0 to lstJIDS.Items.Count - 1 do begin
        if lstJIDS.Items[i].Checked then begin
            msg := TXMLTag.Create('message');
            msg.PutAttribute('to', lstJIDS.Items[i].SubItems[0]);
            with msg.AddTag('x') do begin
                putAttribute('xmlns', 'jabber:x:conference');
                putAttribute('jid', lblJID.Caption);
                end;
            msg.AddBasicTag('body', memReason.Lines.Text);
            MainSession.SendTag(msg);
            end;
        end;
    Self.Close;
end;

end.
