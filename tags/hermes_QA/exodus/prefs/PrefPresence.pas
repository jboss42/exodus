unit PrefPresence;
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
  Dialogs, PrefPanel, StdCtrls, ComCtrls, ExtCtrls, TntStdCtrls,
  TntComCtrls, TntExtCtrls, ExNumericEdit;

type
  TfrmPrefPresence = class(TfrmPrefPanel)
    lstCustomPres: TTntListBox;
    pnlCustomPresButtons: TPanel;
    btnCustomPresAdd: TTntButton;
    btnCustomPresRemove: TTntButton;
    btnCustomPresClear: TTntButton;
    Panel1: TPanel;
    chkPresenceSync: TTntCheckBox;
    lblPresTracking: TTntLabel;
    cboPresTracking: TTntComboBox;
    Label1: TTntLabel;
    chkClientCaps: TTntCheckBox;
    btnDefaults: TTntButton;
    GroupBox1: TTntGroupBox;
    Label11: TTntLabel;
    Label12: TTntLabel;
    Label13: TTntLabel;
    Label14: TTntLabel;
    lblHotkey: TTntLabel;
    txtCPTitle: TTntEdit;
    txtCPStatus: TTntEdit;
    cboCPType: TTntComboBox;
    txtCPPriority: TExNumericEdit;
    txtCPHotkey: THotKey;
    chkRoomJoins: TTntCheckBox;
    procedure FormDestroy(Sender: TObject);
    procedure lstCustomPresClick(Sender: TObject);
    procedure txtCPTitleChange(Sender: TObject);
    procedure btnCustomPresAddClick(Sender: TObject);
    procedure btnCustomPresRemoveClick(Sender: TObject);
    procedure btnCustomPresClearClick(Sender: TObject);
    procedure btnDefaultsClick(Sender: TObject);
  private
    { Private declarations }
    _pres_list: TList;
    _no_pres_change: boolean;

    procedure clearPresList();
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefPresence: TfrmPrefPresence;

const
    sPrefsDfltPres = 'Untitled Presence';
    sPrefsClearPres = 'Clear all custom presence entries?';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.dfm}
uses
    GnuGetText, Unicode, Menus, Presence, Session, XMLUtils, JabberUtils, ExUtils;

{---------------------------------------}
procedure TfrmPrefPresence.LoadPrefs();
var
    i: integer;
    ws: TWidestringlist;
    cp: TJabberCustomPres;
begin
    inherited;

    with MainSession.Prefs do begin
        // Custom Presence options
        lstCustomPres.Items.Clear();
        ws := getAllPresence();
        _pres_list := TList.Create();
        for i := 0 to ws.Count - 1 do begin
            cp := TJabberCustomPres(ws.Objects[i]);
            lstCustomPres.Items.Add(cp.title);
            _pres_list.Add(cp);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmPrefPresence.SavePrefs();
var
    i: integer;
    cp: TJabberCustomPres;
begin
    with MainSession.Prefs do begin
        // Custom presence list
        RemoveAllPresence();
        for i := 0 to _pres_list.Count - 1 do begin
            cp := TJabberCustomPres(_pres_list.Items[i]);
            if (Trim(cp.title) = '') then
                cp.title := sPrefsDfltPres;
            setPresence(cp);
        end;
    end;

    inherited;
end;

{---------------------------------------}
procedure TfrmPrefPresence.clearPresList();
var
    i: integer;
begin
  inherited;
    for i := 0 to _pres_list.Count - 1 do
        TJabberCustomPres(_pres_list[i]).Free();
    _pres_list.Clear();
end;

{---------------------------------------}
procedure TfrmPrefPresence.FormDestroy(Sender: TObject);
begin
  inherited;
    clearPresList();
    _pres_list.Free();
end;

{---------------------------------------}
procedure TfrmPrefPresence.lstCustomPresClick(Sender: TObject);
var
    e: boolean;
begin
    // show the props of this presence object
    _no_pres_change := true;

    e := ((lstCustomPres.Items.Count > 0) and (lstCustomPres.ItemIndex >= 0));
    txtCPTitle.Enabled := e;
    txtCPStatus.Enabled := e;
    txtCPPriority.Enabled := e;
    txtCPHotkey.Enabled := e;

    if (not e) then begin
        txtCPTitle.Text := '';
        txtCPStatus.Text := '';
        txtCPPriority.Text := '0';
    end
    else with TJabberCustomPres(_pres_list[lstCustomPres.ItemIndex]) do begin

        if (show = 'chat') then cboCPType.ItemIndex := 0
        else if (show = 'away') then cboCPType.Itemindex := 2
        else if (show = 'xa') then cboCPType.ItemIndex := 3
        else if (show = 'dnd') then cboCPType.ItemIndex := 4
        else
            cboCPType.ItemIndex := 1;

        txtCPTitle.Text := title;
        txtCPStatus.Text := status;
        txtCPPriority.Text := IntToStr(priority);
        txtCPHotkey.HotKey := TextToShortcut(hotkey);
    end;
    _no_pres_change := false;
end;

{---------------------------------------}
procedure TfrmPrefPresence.txtCPTitleChange(Sender: TObject);
var
    i: integer;
begin
    // something changed on the current custom pres object
    // automatically update it.
    if (lstCustomPres.ItemIndex < 0) then exit;
    if (_no_pres_change) then exit;

    i := lstCustomPres.ItemIndex;
    with  TJabberCustomPres(_pres_list[i]) do begin
        title := txtCPTitle.Text;
        status := txtCPStatus.Text;
        priority := SafeInt(txtCPPriority.Text);
        hotkey := ShortCutToText(txtCPHotkey.HotKey);
        case cboCPType.ItemIndex of
        0: show := 'chat';
        1: show := '';
        2: show := 'away';
        3: show := 'xa';
        4: show := 'dnd';
        end;
        if (title <> lstCustomPres.Items[i]) then
            lstCustomPres.Items[i] := title;
    end;
end;

{---------------------------------------}
procedure TfrmPrefPresence.btnCustomPresAddClick(Sender: TObject);
var
    cp: TJabberCustomPres;
begin
    // add a new custom pres
    cp := TJabberCustomPres.Create();
    cp.title := sPrefsDfltPres;
    cp.show := '';
    cp.Status := '';
    cp.priority := 0;
    cp.hotkey := '';
    _pres_list.Add(cp);
    lstCustompres.Items.Add(cp.title);
    lstCustompres.ItemIndex := lstCustompres.Items.Count - 1;
    lstCustompresClick(Self);
end;

{---------------------------------------}
procedure TfrmPrefPresence.btnCustomPresRemoveClick(Sender: TObject);
var
    cp: TJabberCustomPres;
begin
    // delete the current pres
    cp := TJabberCustomPres(_pres_list[lstCustomPres.ItemIndex]);
    _pres_list.Remove(cp);
    MainSession.Prefs.removePresence(cp);
    lstCustompres.Items.Delete(lstCustomPres.ItemIndex);
    lstCustompresClick(Self);
    cp.Free();
end;

{---------------------------------------}
procedure TfrmPrefPresence.btnCustomPresClearClick(Sender: TObject);
begin
    // clear all entries
    if MessageDlgW(_(sPrefsClearPres), mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;

    lstCustomPres.Items.Clear;
    clearPresList();
    lstCustompresClick(Self);
    MainSession.Prefs.removeAllPresence();
end;

{---------------------------------------}
procedure TfrmPrefPresence.btnDefaultsClick(Sender: TObject);
begin
    MainSession.Prefs.setupDefaultPresence();
    LoadPrefs();
end;

end.
