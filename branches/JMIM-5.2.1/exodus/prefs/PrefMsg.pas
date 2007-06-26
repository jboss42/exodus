unit PrefMsg;
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls;

type
  TfrmPrefMsg = class(TfrmPrefPanel)
    lblTimestampFmt: TTntLabel;
    lblMsgOptions: TTntLabel;
    lblSpoolPath: TTntLabel;
    lblInviteOptions: TTntLabel;
    chkTimestamp: TTntCheckBox;
    chkMsgQueue: TTntCheckBox;
    cboMsgOptions: TTntComboBox;
    txtSpoolPath: TTntEdit;
    btnSpoolBrowse: TTntButton;
    cboInviteOptions: TTntComboBox;
    chkBlockNonRoster: TTntCheckBox;
    OpenDialog1: TOpenDialog;
    txtTimestampFmt: TTntComboBox;
    chkQueueDNDChats: TTntCheckBox;
    chkQueueNotAvail: TTntCheckBox;
    chkChatAvatars: TTntCheckBox;
    chkShowPriority: TTntCheckBox;
    chkQueueOffline: TTntCheckBox;
    procedure btnSpoolBrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefMsg: TfrmPrefMsg;

implementation
{$WARN UNIT_PLATFORM OFF}
{$R *.dfm}
uses
    JabberUtils, ExUtils,  FileCtrl, Session, Unicode,
    PrefFile, PrefController;

procedure TfrmPrefMsg.LoadPrefs();
var
  date_time_formats: TWideStringList;
  s: TPrefState;
begin
    inherited;
    date_time_formats := TWideStringList.Create;
    MainSession.Prefs.fillStringlist('date_time_formats', date_time_formats);
    if (date_time_formats.Count > 0) then begin
       AssignTntStrings(date_time_formats, txtTimestampFmt.Items);
    end;

    chkShowPriority.Visible := MainSession.Prefs.getBool('branding_priority_notifications');
    if (MainSession.Prefs.getBool('branding_queue_not_available_msgs') = true) then begin
       chkQueueDNDChats.Visible  := false;
       chkQueueOffline.Visible := false;
       s := PrefController.getPrefState('queue_not_avail');
       chkQueueNotAvail.Visible := (s <> psInvisible);
       chkQueueNotAvail.Top :=  chkQueueDNDChats.Top;
       chkQueueNotAvail.Left :=  chkQueueDNDChats.Left;
    end
    else begin
       s := PrefController.getPrefState('queue_dnd_chats');
       chkQueueDNDChats.Visible  := (s <> psInvisible);
       s := PrefController.getPrefState('queue_offline');
       chkQueueOffline.Visible := (s <> psInvisible);
       chkQueueNotAvail.Visible := false;
    end;

end;

procedure TfrmPrefMsg.SavePrefs();
begin
    if (Trim(txtTimestampFmt.Text) <> '') then
       if (txtTimestampFmt.Items.IndexOf(txtTimestampFmt.Text) < 0) then
         txtTimestampFmt.Items.Add(txtTimestampFmt.Text);
    MainSession.Prefs.setStringList('date_time_formats', txtTimestampFmt.Items);
    inherited;
end;

procedure TfrmPrefMsg.btnSpoolBrowseClick(Sender: TObject);
begin
    OpenDialog1.FileName := txtSpoolPath.Text;
    if (OpenDialog1.Execute) then
        txtSpoolPath.Text := OpenDialog1.FileName;
end;

end.
