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
  Dialogs, PrefPanel, StdCtrls, ComCtrls;

type
  TfrmPrefAway = class(TfrmPrefPanel)
    txtAwayTime: TEdit;
    spnAway: TUpDown;
    txtXATime: TEdit;
    spnXA: TUpDown;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    chkAutoAway: TCheckBox;
    txtAway: TEdit;
    txtXA: TEdit;
    chkAAReducePri: TCheckBox;
    StaticText7: TStaticText;
  private
    { Private declarations }
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
        spnAway.Position := getInt('away_time');
        spnXA.Position := getInt('xa_time');
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
        setInt('away_time', spnAway.Position);
        setInt('xa_time', spnXA.Position);
        setString('away_status', txtAway.Text);
        setString('xa_status', txtXA.Text);
    end;
end;

end.
