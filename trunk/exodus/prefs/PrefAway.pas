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
    Label4: TTntLabel;
    Label9: TTntLabel;
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
    with MainSession.Prefs do begin
        // Autoaway options
        chkAutoAway.Checked := getBool('auto_away');
        chkAAReducePri.Checked := getBool('aa_reduce_pri');
        chkAutoXA.Checked := getBool('auto_xa');
        chkAutoDisconnect.Checked := getBool('auto_disconnect');

        spnAway.Position := getInt('away_time');
        spnXA.Position := getInt('xa_time');
        spnDisconnect.Position := getInt('disconnect_time');
        
        txtAway.Text := getString('away_status');
        txtXA.Text := getString('xa_status');
    end;
end;

procedure TfrmPrefAway.SavePrefs();
begin
    with MainSession.Prefs do begin
        // Autoaway options
        setBool('auto_away', chkAutoAway.Checked);
        setBool('aa_reduce_pri', chkAAReducePri.Checked);
        setBool('auto_xa', chkAutoXA.Checked);
        setBool('auto_disconnect', chkAutoDisconnect.Checked);

        setInt('away_time', spnAway.Position);
        setInt('xa_time', spnXA.Position);
        setInt('disconnect_time', spnDisconnect.Position);

        setString('away_status', txtAway.Text);
        setString('xa_status', txtXA.Text);
    end;
end;

procedure TfrmPrefAway.chkAutoAwayClick(Sender: TObject);
begin
  inherited;
    DoEnables();
end;

procedure TfrmPrefAway.DoEnables();
var
    e, xa, dis: boolean;
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

    chkAAReducePri.Enabled := e;
    chkAutoXA.Enabled := e;
    chkAutoDisconnect.Enabled := e;

    txtAwayTime.Enabled := e;
    txtXATime.Enabled := xa;
    txtDisconnectTime.Enabled := dis;
    txtAway.Enabled := e;
    txtXA.Enabled := xa;
    spnAway.Enabled := e;
    spnXA.Enabled := xa;
    spnDisconnect.Enabled := dis;
end;


end.
