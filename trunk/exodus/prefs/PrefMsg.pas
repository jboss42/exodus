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
    chkEmoticons: TTntCheckBox;
    chkTimestamp: TTntCheckBox;
    chkLog: TTntCheckBox;
    txtLogPath: TTntEdit;
    btnLogBrowse: TTntButton;
    chkMsgQueue: TTntCheckBox;
    chkLogRooms: TTntCheckBox;
    cboMsgOptions: TTntComboBox;
    btnLogClearAll: TTntButton;
    txtSpoolPath: TTntEdit;
    btnSpoolBrowse: TTntButton;
    cboInviteOptions: TTntComboBox;
    chkBlockNonRoster: TTntCheckBox;
    OpenDialog1: TOpenDialog;
    txtTimestampFmt: TTntComboBox;
    chkLogRoster: TTntCheckBox;
    chkQueueDNDChats: TTntCheckBox;
    chkQueueOffline: TTntCheckBox;
    procedure btnLogBrowseClick(Sender: TObject);
    procedure btnLogClearAllClick(Sender: TObject);
    procedure btnSpoolBrowseClick(Sender: TObject);
    procedure chkLogClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefMsg: TfrmPrefMsg;

const
    sPrefsLogDir = 'Select log directory';

implementation
{$WARN UNIT_PLATFORM OFF}
{$R *.dfm}
uses
    ExUtils, FileCtrl, Session;

procedure TfrmPrefMsg.LoadPrefs();
begin
    inherited;
    chkLogClick(self);
end;

procedure TfrmPrefMsg.SavePrefs();
begin
    inherited;
end;


procedure TfrmPrefMsg.btnLogBrowseClick(Sender: TObject);
var
    tmps: string;
begin
    tmps := txtLogPath.Text;
    if SelectDirectory(sPrefsLogDir, '', tmps) then
        txtLogPath.Text := tmps;
end;

procedure TfrmPrefMsg.btnLogClearAllClick(Sender: TObject);
begin
  inherited;
    ClearAllLogs();
end;

procedure TfrmPrefMsg.btnSpoolBrowseClick(Sender: TObject);
begin
    OpenDialog1.FileName := txtSpoolPath.Text;
    if (OpenDialog1.Execute) then
        txtSpoolPath.Text := OpenDialog1.FileName;
end;

procedure TfrmPrefMsg.chkLogClick(Sender: TObject);
begin
  inherited;
    chkLogRooms.Enabled := chkLog.Checked;
    txtLogPath.Enabled := chkLog.Checked;
    btnLogBrowse.Enabled := chkLog.Checked;
end;

end.
