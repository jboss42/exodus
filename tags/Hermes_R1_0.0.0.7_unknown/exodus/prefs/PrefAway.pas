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
  TntExtCtrls;

type
  TfrmPrefAway = class(TfrmPrefPanel)
    txtAwayTime: TTntEdit;
    spnAway: TUpDown;
    txtXATime: TTntEdit;
    spnXA: TUpDown;
    Label2: TTntLabel;
    Label3: TTntLabel;
    lblAwayStatus: TTntLabel;
    lblXAStatus: TTntLabel;
    chkAutoAway: TTntCheckBox;
    txtAway: TTntEdit;
    txtXA: TTntEdit;
    chkAAReducePri: TTntCheckBox;
    chkAutoXA: TTntCheckBox;
    chkAutoDisconnect: TTntCheckBox;
    TntLabel1: TTntLabel;
    txtDisconnectTime: TTntEdit;
    spnDisconnect: TUpDown;
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
    Session;

procedure TfrmPrefAway.LoadPrefs();
begin
    inherited;
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

    chkAAReducePri.Enabled := e;
    chkAutoXA.Enabled := e;
    chkAutoDisconnect.Enabled := e;

    txtAwayTime.Enabled := e;
    txtXATime.Enabled := xa;
    txtDisconnectTime.Enabled := dis;
    txtAway.Enabled := e and (not aro);
    txtXA.Enabled := xa and (not xro);
    spnAway.Enabled := e;
    spnXA.Enabled := xa;
    spnDisconnect.Enabled := dis;
end;


end.
