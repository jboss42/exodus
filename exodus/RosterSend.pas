unit RosterSend;
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
  Dialogs, Dockable, ComCtrls, buttonFrame, ExtCtrls, StdCtrls,
  OLERichEdit, ExRichEdit;

type
  TRosterSortMode = (sort_nick, sort_grp, sort_jid);
  
  TfrmRosterSend = class(TfrmDockable)
    pnlFrom: TPanel;
    StaticText1: TStaticText;
    txtTO: TStaticText;
    txtMsg: TExRichEdit;
    Splitter1: TSplitter;
    frameButtons1: TframeButtons;
    lvContacts: TListView;
    procedure FormCreate(Sender: TObject);
    procedure lvContactsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvContactsColumnClick(Sender: TObject; Column: TListColumn);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    _sort_mode: TRosterSortMode;
  public
    { Public declarations }
  end;

var
  frmRosterSend: TfrmRosterSend;

procedure SendRoster(recip: string);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    Roster, Session;

{---------------------------------------}
procedure SendRoster(recip: string);
var
    f: TfrmRosterSend;
begin
    // Send contacts to the recip
    f := TfrmRosterSend.Create(nil);
    f.ShowDefault();
end;


{---------------------------------------}
procedure TfrmRosterSend.FormCreate(Sender: TObject);
var
    grps: TStringList;
    ritem: TJabberRosterItem;
    l: TListItem;
    i: integer;
begin
  inherited;
    // Fill the treeview with a current roster snapshot
    grps := TStringList.Create();
    _sort_mode := sort_nick;

    lvContacts.Items.BeginUpdate();
    with MainSession do begin
        for i := 0 to Roster.Count - 1 do begin
            ritem := Roster.Items[i];
            l := lvContacts.Items.Add();
            l.Caption := ritem.nickname;
            if (ritem.Groups.Count > 0) then
                l.SubItems.Add(ritem.Groups[0])
            else
                l.SubItems.Add('');
            l.SubItems.Add(ritem.jid.full);
            l.Data := ritem;
            end;
        end;
    grps.Free;

    lvContacts.Items.EndUpdate();
end;

{---------------------------------------}
procedure TfrmRosterSend.lvContactsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
    r1, r2: TJabberRosterItem;
    s1, s2: string;
begin
  inherited;
    // sort procedure

    r1 := TJabberRosterItem(Item1.Data);
    r2 := TJabberRosterItem(Item2.Data);

    case _sort_mode of
    sort_nick: begin
        s1 := r1.nickname;
        s2 := r2.nickname;
        end;
    sort_grp: begin
        if (r1.Groups.Count > 0) then s1 := r1.Groups[0] else s1 := '';
        if (r2.Groups.Count > 0) then s2 := r2.Groups[0] else s2 := '';
        end;
    sort_jid: begin
        s1 := r1.jid.full;
        s2 := r2.jid.full;
        end;
    end;

    Compare := AnsiCompareText(s1, s2);
end;

{---------------------------------------}
procedure TfrmRosterSend.lvContactsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  inherited;
    if (Column.Index = 1) then
        _sort_mode := sort_grp
    else if Column.Index = 2 then
        _sort_mode := sort_jid
    else
        _sort_mode := sort_nick;

    lvContacts.AlphaSort();
end;

{---------------------------------------}
procedure TfrmRosterSend.frameButtons1btnCancelClick(Sender: TObject);
begin
  inherited;
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRosterSend.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
    Action := caFree;
end;

end.
