unit PrefPanel;
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
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, TntStdCtrls, TntExtCtrls;

type
  TfrmPrefPanel = class(TForm)
    pnlHeader: TTntPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); virtual;
    procedure SavePrefs(); virtual;
  end;

var
  frmPrefPanel: TfrmPrefPanel;

implementation

{$R *.dfm}

uses
    Session, PrefFile, PrefController, GnuGetText, ExUtils;

procedure TfrmPrefPanel.LoadPrefs();
var
    s: TPrefState;
    e, v, bval: boolean;
    ival: integer;
    p, sval: Widestring;
    c: TControl;
    i: integer;
begin
    // auto-load prefs based on controls and their types.
    for i := 0 to Self.ControlCount - 1 do begin
        c := Self.Controls[i];
        p := MainSession.Prefs.getPref(c.name);
        if (p = '') then continue;

        s := getPrefState(p);

        // XXX: lots more controls need to go here.
        if (c.inheritsFrom(TTntCheckBox)) then begin
            bval := MainSession.Prefs.getBool(p);
            TCheckBox(c).Checked := bval;
        end
        else if (c.inheritsFrom(TUpDown)) then begin
            ival := MainSession.Prefs.getInt(p);
            TUpDown(c).Position := ival;
        end
        else if (c.inheritsFrom(TTntEdit)) then begin
            sval := MainSession.Prefs.getString(p);
            TTntEdit(c).Text := sval;
        end;

        // Make sure to set state for this control
        if (s = psReadOnly) then begin
            c.enabled := false;
            if (c.inheritsFrom(TTntEdit)) then
                TTntEdit(c).ReadOnly := true;
        end
        else if (s = psInvisible) then
            c.visible := false;

    end;
end;

procedure TfrmPrefPanel.SavePrefs();
begin
    // XXX: save prefs using controls array
end;

procedure TfrmPrefPanel.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self, 8);
    AssignUnicodeHighlight(pnlHeader.Font, 10);
    TranslateComponent(Self);
    LoadPrefs();
end;

end.
