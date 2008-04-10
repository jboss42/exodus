unit PrefAway;
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
  Dialogs, PrefPanel, StdCtrls, ComCtrls, TntStdCtrls, ExtCtrls,
  TntExtCtrls, ExNumericEdit, ExGroupBox, ExCheckGroupBox, TntForms, ExFrame,
  ExBrandPanel;

type
  TfrmPrefAway = class(TfrmPrefPanel)
    pnlContainer: TExBrandPanel;
    chkAutoAway: TExCheckGroupBox;
    pnlAwayTime: TExBrandPanel;
    lblAwayTime: TTntLabel;
    txtAwayTime: TExNumericEdit;
    chkAAReducePri: TTntCheckBox;
    chkAwayAutoResponse: TTntCheckBox;
    ExBrandPanel2: TExBrandPanel;
    lblAwayStatus: TTntLabel;
    txtAway: TTntEdit;
    chkAutoXA: TExCheckGroupBox;
    ExBrandPanel3: TExBrandPanel;
    lblXATime: TTntLabel;
    txtXATime: TExNumericEdit;
    ExBrandPanel4: TExBrandPanel;
    lblXAStatus: TTntLabel;
    txtXA: TTntEdit;
    chkAutoDisconnect: TExCheckGroupBox;
    lblDisconnectTime: TTntLabel;
    txtDisconnectTime: TExNumericEdit;
    procedure chkAutoAwayCheckChanged(Sender: TObject);
  private
    _lastAutoXA: boolean;
    _lastAutoDisconnect: boolean;
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs();override;
  end;

var
  frmPrefAway: TfrmPrefAway;

implementation
{$R *.dfm}
uses
    Session, PrefFile, PrefController;

procedure TfrmPrefAway.LoadPrefs();
begin
    inherited;

    //set the initial visible, enabled states of the check group boxes
    chkAutoAway.CanEnabled := (getPrefState('auto_away') <> psReadOnly);
    chkAutoXA.CanEnabled := (getPrefState('auto_xa') <> psReadOnly);
    chkAutoDisconnect.CanEnabled := (getPrefState('auto_disconnect') <> psReadOnly);

    pnlContainer.captureChildStates();
    pnlContainer.checkAutoHide();

    _lastAutoXA := chkAutoXA.Checked;
    _lastAutoDisconnect := chkAutoDisconnect.Checked;

    //fire the autoaway check click event to get initial states correct
    chkAutoAway.chkBoxClick(Self);
end;

procedure TfrmPrefAway.SavePrefs();
var
    tb1, tb2: boolean;
begin
    //make sure disabled xa and disconnect have the correct values before save
    tb1 := chkAutoXA.Checked;
    tb2 := chkAutoDisconnect.Checked;
    chkAutoXA.Checked := _lastAutoXA;
    chkAutoDisconnect.Checked := _lastAutoDisconnect;

    inherited;

    //and set them back (in case of apply)
    chkAutoXA.Checked := tb1;
    chkAutoDisconnect.Checked := tb2;

end;

{
procedure TfrmPrefAway.DoEnables();
var
    aro, xro, e, xa, dis: boolean;
    s: TPrefState;
begin
    e := chkAutoAway.Checked;
    if (e) then begin
        xa := chkAutoXA.Checked;
        dis := chkAutoDisconnect.Checked;
    end
    else begin
        xa := false;
        dis := false;
    end;

    aro := txtAway.ReadOnly;
    xro := txtXA.ReadOnly;

    s := PrefController.getPrefState('aa_reduce_pri');
    chkAAReducePri.Enabled := e and (s <> psReadOnly) and (s <> psInvisible);
    s := PrefController.getPrefState('auto_xa');
    chkAutoXA.Enabled := e and (s <> psReadOnly) and (s <> psInvisible);
    s := PrefController.getPrefState('auto_disconnect');
    chkAutoDisconnect.Enabled := e and (s <> psReadOnly) and (s <> psInvisible);

    s := PrefController.getPrefState('away_time');
    txtAwayTime.Enabled := e and (s <> psReadOnly) and (s <> psInvisible);
    lblAwayTime.Enabled := e and (s <> psReadOnly) and (s <> psInvisible);
    s := PrefController.getPrefState('away_status');
    lblAwayStatus.Enabled := e and (s <> psReadOnly) and (s <> psInvisible);
    s := PrefController.getPrefState('xa_time');
    txtXATime.Enabled := xa and (s <> psReadOnly) and (s <> psInvisible);
    lblXATime.Enabled := xa and (s <> psReadOnly) and (s <> psInvisible);
    s := PrefController.getPrefState('xa_status');
    lblXAStatus.Enabled := xa and (s <> psReadOnly) and (s <> psInvisible);
    s := PrefController.getPrefState('disconnect_time');
    txtDisconnectTime.Enabled := dis and (s <> psReadOnly) and (s <> psInvisible);
    lblDisconnectTime.Enabled := dis and (s <> psReadOnly) and (s <> psInvisible);

    txtAway.Enabled := e and (not aro);
    txtXA.Enabled := xa and (not xro);
end;
}

procedure TfrmPrefAway.chkAutoAwayCheckChanged(Sender: TObject);
begin
    if (not chkAutoAway.Checked) then begin
        _lastAutoXA := chkAutoXA.Checked;
        _lastAutoDisconnect := chkAutoDisconnect.Checked;

        chkAutoXA.Checked := false;
        chkAutoDisconnect.Checked := false;
    end
    else begin
        chkAutoXA.Checked := _lastAutoXA;
        chkAutoDisconnect.Checked := _lastAutoDisconnect;
    end;

    Self.chkAutoXA.Enabled := chkAutoAway.Checked;
    Self.chkAutoDisconnect.Enabled := chkAutoAway.Checked;
end;

end.