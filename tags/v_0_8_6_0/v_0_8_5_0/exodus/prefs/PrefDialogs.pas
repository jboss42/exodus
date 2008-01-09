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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, ComCtrls, StdCtrls;

type
  TfrmPrefDialogs = class(TfrmPrefPanel)
    Label26: TLabel;
    Label27: TLabel;
    Label29: TLabel;
    StaticText5: TStaticText;
    chkRosterAlpha: TCheckBox;
    trkRosterAlpha: TTrackBar;
    txtRosterAlpha: TEdit;
    spnRosterAlpha: TUpDown;
    chkToastAlpha: TCheckBox;
    trkToastAlpha: TTrackBar;
    txtToastAlpha: TEdit;
    spnToastAlpha: TUpDown;
    chkSnap: TCheckBox;
    txtSnap: TEdit;
    spnSnap: TUpDown;
    txtChatMemory: TEdit;
    spnChatMemory: TUpDown;
    chkBusy: TCheckBox;
    txtToastDuration: TEdit;
    procedure chkRosterAlphaClick(Sender: TObject);
    procedure chkToastAlphaClick(Sender: TObject);
    procedure trkRosterAlphaChange(Sender: TObject);
    procedure trkToastAlphaChange(Sender: TObject);
    procedure chkSnapClick(Sender: TObject);
    procedure txtRosterAlphaChange(Sender: TObject);
    procedure txtToastAlphaChange(Sender: TObject);
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
    with MainSession.Prefs do begin
        // Dialog Options
        chkRosterAlpha.Checked := getBool('roster_alpha');
        chkToastAlpha.Checked := getBool('toast_alpha');
        chkSnap.Checked := getBool('snap_on');
        chkBusy.Checked := getBool('warn_closebusy');
        chkRosterAlphaClick(Self);
        if chkRosterAlpha.Checked then begin
            trkRosterAlpha.Position := getInt('roster_alpha_val');
            spnRosterAlpha.Position := trkRosterAlpha.Position;
        end
        else begin
            trkRosterAlpha.Position := 255;
            spnRosterAlpha.Position := 255;
        end;

        chkToastAlphaClick(Self);
        if chkToastAlpha.Checked then begin
            trkToastAlpha.Position := getInt('toast_alpha_val');
            spnToastAlpha.Position := trkToastAlpha.Position;
        end
        else begin
            trkToastAlpha.Position := 255;
            spnToastAlpha.Position := 255;
        end;

        txtToastDuration.Text := IntToStr(getInt('toast_duration'));

        chkSnapClick(Self);
        if (chkSnap.Checked) then
            spnSnap.Position := getInt('edge_snap')
        else
            spnSnap.Position := 10;

        spnChatMemory.Position := getInt('chat_memory');
    end;
end;

procedure TfrmPrefDialogs.SavePrefs();
begin
    //
    with MainSession.Prefs do begin
        // Dialog Prefs
        setBool('roster_alpha', chkRosterAlpha.Checked);
        setInt('roster_alpha_val', trkRosterAlpha.Position);
        setBool('toast_alpha', chkToastAlpha.Checked);
        setInt('toast_alpha_val', trkToastAlpha.Position);
        setInt('toast_duration', SafeInt(txtToastDuration.Text));

        setBool('snap_on', chkSnap.Checked);
        setBool('warn_closebusy', chkBusy.Checked);
        setInt('edge_snap', spnSnap.Position);
        setInt('chat_memory', spnChatMemory.Position);
    end;
end;
    

procedure TfrmPrefDialogs.chkRosterAlphaClick(Sender: TObject);
begin
  inherited;
    trkRosterAlpha.Enabled := chkRosterAlpha.Checked;
    spnRosterAlpha.Enabled := chkRosterAlpha.Checked;
    txtRosterAlpha.Enabled := chkRosterAlpha.Checked;

end;

procedure TfrmPrefDialogs.chkToastAlphaClick(Sender: TObject);
begin
  inherited;
    trkToastAlpha.Enabled := chkToastAlpha.Checked;
    spnToastAlpha.Enabled := chkToastAlpha.Checked;
    txtToastAlpha.Enabled := chkToastAlpha.Checked;
end;

procedure TfrmPrefDialogs.trkRosterAlphaChange(Sender: TObject);
begin
  inherited;
    spnRosterAlpha.Position := trkRosterAlpha.Position;
end;

procedure TfrmPrefDialogs.trkToastAlphaChange(Sender: TObject);
begin
  inherited;
    spnToastAlpha.Position := trkToastAlpha.Position;
end;

procedure TfrmPrefDialogs.chkSnapClick(Sender: TObject);
begin
  inherited;
    spnSnap.Enabled := chkSnap.Checked;
    txtSnap.Enabled := chkSnap.Checked;
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

end.
