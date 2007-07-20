unit PrefDialogs;
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
    Menus,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, PrefPanel, ComCtrls, StdCtrls, jpeg, ExtCtrls, TntStdCtrls,
    TntComCtrls, TntExtCtrls, ExNumericEdit;

type
  TfrmPrefDialogs = class(TfrmPrefPanel)
    lblMem1: TTntLabel;
    lblMem2: TTntLabel;
    lblToastDuration: TTntLabel;
    chkRosterAlpha: TTntCheckBox;
    trkRosterAlpha: TTrackBar;
    txtRosterAlpha: TExNumericEdit;
    chkToastAlpha: TTntCheckBox;
    trkToastAlpha: TTrackBar;
    txtToastAlpha: TExNumericEdit;
    chkSnap: TTntCheckBox;
    txtSnap: TExNumericEdit;
    chkBusy: TTntCheckBox;
    txtToastDuration: TTntEdit;
    txtChatMemory: TExNumericEdit;
    lblClose: TTntLabel;
    txtCloseHotkey: THotKey;
    chkEscClose: TTntCheckBox;
    trkSnap: TTrackBar;
    trkChatMemory: TTrackBar;
    chkSaveWindowState: TTntCheckBox;
    chkRestoreDesktop: TTntCheckBox;
    procedure chkRosterAlphaClick(Sender: TObject);
    procedure chkToastAlphaClick(Sender: TObject);
    procedure trkRosterAlphaChange(Sender: TObject);
    procedure trkToastAlphaChange(Sender: TObject);
    procedure chkSnapClick(Sender: TObject);
    procedure txtRosterAlphaChange(Sender: TObject);
    procedure txtToastAlphaChange(Sender: TObject);
    procedure trkSnapChange(Sender: TObject);
    procedure trkChatMemoryChange(Sender: TObject);
    procedure txtSnapChange(Sender: TObject);
    procedure txtChatMemoryChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefDialogs: TfrmPrefDialogs;

implementation
{$R *.dfm}
uses
    Session, XMLUtils;

procedure TfrmPrefDialogs.LoadPrefs();
begin
    //
    inherited;
    trkRosterAlpha.Visible := chkRosterAlpha.Visible;
    txtRosterAlpha.Visible := chkRosterAlpha.Visible;
    if (chkRosterAlpha.Visible) then
      chkRosterAlphaClick(Self);

    trkToastAlpha.Visible := chkToastAlpha.Visible;
    txtToastAlpha.Visible := chkToastAlpha.Visible;
    if (chkToastAlpha.Visible) then
      chkToastAlphaClick(Self);

    trkSnap.Visible := chkSnap.Visible;
    txtSnap.Visible := chkSnap.Visible;
    if (chkSnap.Visible) then
      chkSnapClick(Self);


end;

procedure TfrmPrefDialogs.SavePrefs();
begin
    inherited;
end;
    

procedure TfrmPrefDialogs.chkRosterAlphaClick(Sender: TObject);
begin
  inherited;
    trkRosterAlpha.Enabled := chkRosterAlpha.Checked;
    txtRosterAlpha.Enabled := chkRosterAlpha.Checked;

end;

procedure TfrmPrefDialogs.chkToastAlphaClick(Sender: TObject);
begin
  inherited;
    trkToastAlpha.Enabled := chkToastAlpha.Checked;
    txtToastAlpha.Enabled := chkToastAlpha.Checked;
end;

procedure TfrmPrefDialogs.trkRosterAlphaChange(Sender: TObject);
begin
  inherited;
    txtRosterAlpha.Text := IntToStr(trkRosterAlpha.Position);
end;

procedure TfrmPrefDialogs.trkToastAlphaChange(Sender: TObject);
begin
  inherited;
    txtToastAlpha.Text := IntToStr(trkToastAlpha.Position);
end;

procedure TfrmPrefDialogs.chkSnapClick(Sender: TObject);
begin
  inherited;
    txtSnap.Enabled := chkSnap.Checked;
    trkSnap.Enabled := chkSnap.Checked;
end;

procedure TfrmPrefDialogs.txtRosterAlphaChange(Sender: TObject);
begin
  inherited;
    try
        trkRosterAlpha.Position := StrToInt(txtRosterAlpha.Text);
    except
    end;

end;

procedure TfrmPrefDialogs.txtToastAlphaChange(Sender: TObject);
begin
  inherited;
    try
        trkToastAlpha.Position := StrToInt(txtToastAlpha.Text);
    except
    end;
end;

procedure TfrmPrefDialogs.trkSnapChange(Sender: TObject);
begin
  inherited;
    txtSnap.Text := IntToStr(trkSnap.Position);
end;

procedure TfrmPrefDialogs.trkChatMemoryChange(Sender: TObject);
begin
  inherited;
    txtChatMemory.Text := IntToStr(trkChatMemory.Position);
end;

procedure TfrmPrefDialogs.txtSnapChange(Sender: TObject);
begin
  inherited;
    try
        trkSnap.Position := StrToInt(txtSnap.Text);
    except
    end;
end;

procedure TfrmPrefDialogs.txtChatMemoryChange(Sender: TObject);
begin
  inherited;
    try
        trkChatMemory.Position := StrToInt(txtChatMemory.Text);
    except
    end;
end;

end.
