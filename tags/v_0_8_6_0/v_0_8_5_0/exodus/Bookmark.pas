unit Bookmark;
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
    Roster, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, buttonFrame, StdCtrls;

type
  TfrmBookmark = class(TForm)
    frameButtons1: TframeButtons;
    Label1: TLabel;
    cboType: TComboBox;
    Label2: TLabel;
    txtName: TEdit;
    Label3: TLabel;
    txtJID: TEdit;
    Label4: TLabel;
    txtNick: TEdit;
    chkAutoJoin: TCheckBox;
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    new: boolean;
    bm: TJabberBookmark;
  public
    { Public declarations }
  end;

var
  frmBookmark: TfrmBookmark;

function ShowBookmark(jid: string): TfrmBookmark;

implementation

{$R *.dfm}

uses
    GnuGetText, JabberID, Session, RosterWindow;

function ShowBookmark(jid: string): TfrmBookmark;
var
    i: integer;
begin
    Result := nil;

    if (jid <> '') then begin
        i := MainSession.Roster.Bookmarks.IndexOf(jid);
        if (i < 0) then exit;
    end
    else
        i := -1;

    Result := TfrmBookmark.Create(Application);

    with Result do begin
        cboType.ItemIndex := 0;
        if (i < 0) then begin
            new := true;
            txtNick.Text := MainSession.Profile.Username;
        end
        else begin
            new := false;
            bm := TJabberBookmark(MainSession.Roster.Bookmarks.Objects[i]);
            txtJID.Text := bm.jid.full;
            txtName.Text := bm.bmName;
            txtNick.Text := bm.nick;
            chkAutoJoin.Checked := bm.autoJoin;
        end;
        Show();
    end;
end;


procedure TfrmBookmark.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmBookmark.frameButtons1btnOKClick(Sender: TObject);
begin
    // Save any changes to the bookmark and resave
    if (new) then begin
        bm := TJabberBookmark.Create(nil);
        with bm do begin
            jid := TJabberID.Create(txtJID.Text);
            bmName := txtName.Text;
            nick := txtNick.Text;
            autoJoin := chkAutoJoin.Checked;
        end;
        MainSession.roster.AddBookmark(txtJID.Text, bm)
    end
    else with bm do begin
        bmName := txtName.Text;
        jid.ParseJID(txtJID.Text);
        nick := txtNick.Text;
        autoJoin := chkAutoJoin.Checked;
        MainSession.Roster.UpdateBookmark(bm);
    end;
    Self.Close;
end;

procedure TfrmBookmark.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmBookmark.FormCreate(Sender: TObject);
begin
    TranslateProperties(Self);
end;

end.
