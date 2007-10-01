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
  TntExtCtrls, ExNumericEdit;

type
  TfrmPrefAway = class(TfrmPrefPanel)
    txtAwayTime: TExNumericEdit;
    txtXATime: TExNumericEdit;
    lblAwayTime: TTntLabel;
    lblXATime: TTntLabel;
    lblAwayStatus: TTntLabel;
    lblXAStatus: TTntLabel;
    chkAutoAway: TTntCheckBox;
    txtAway: TTntEdit;
    txtXA: TTntEdit;
    chkAAReducePri: TTntCheckBox;
    chkAutoXA: TTntCheckBox;
    chkAutoDisconnect: TTntCheckBox;
    lblDisconnectTime: TTntLabel;
    txtDisconnectTime: TExNumericEdit;
    chkAwayAutoResponse: TTntCheckBox;
    procedure chkAutoAwayClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoEnables();

  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
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
    doEnables();
end;

procedure TfrmPrefAway.SavePrefs();
begin
    inherited;
end;

procedure TfrmPrefAway.chkAutoAwayClick(Sender: TObject);
begin
  inherited;
    DoEnables();
end;

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


end.
