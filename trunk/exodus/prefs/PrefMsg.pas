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
    chkQueueOffline: TTntCheckBox;
    chkChatAvatars: TTntCheckBox;
    chkShowPriority: TTntCheckBox;
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
    JabberUtils, ExUtils,  FileCtrl, Session;

procedure TfrmPrefMsg.LoadPrefs();
begin
    inherited;
    chkShowPriority.Visible := MainSession.Prefs.getBool('branding_priority_notifications');
end;

procedure TfrmPrefMsg.SavePrefs();
begin
    inherited;
end;

procedure TfrmPrefMsg.btnSpoolBrowseClick(Sender: TObject);
begin
    OpenDialog1.FileName := txtSpoolPath.Text;
    if (OpenDialog1.Execute) then
        txtSpoolPath.Text := OpenDialog1.FileName;
end;

end.
