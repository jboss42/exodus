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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  buttonFrame, StdCtrls;

type
  TfrmJoinRoom = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    txtRoom: TEdit;
    txtServer: TEdit;
    txtNick: TEdit;
    frameButtons1: TframeButtons;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmJoinRoom: TfrmJoinRoom;

procedure StartJoinRoom;

implementation
uses
    Session,
    Room;
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
        Show;
        end;
end;

procedure TfrmJoinRoom.frameButtons1btnOKClick(Sender: TObject);
begin
    // join this room
    StartRoom(txtRoom.Text + '@' + txtServer.Text, txtNick.Text);

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

end.
