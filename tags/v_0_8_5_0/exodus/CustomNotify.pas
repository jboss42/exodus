unit CustomNotify;
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
  Dialogs, buttonFrame, StdCtrls, CheckLst;

type
  TfrmCustomNotify = class(TForm)
    chkNotify: TCheckListBox;
    optNotify: TGroupBox;
    chkFlash: TCheckBox;
    chkToast: TCheckBox;
    chkTrayNotify: TCheckBox;
    frameButtons1: TframeButtons;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure chkNotifyClick(Sender: TObject);
    procedure chkToastClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
    _no_notify_update: boolean;
    _vals: array of integer;
    _defs: array of integer;
  public
    { Public declarations }
    function getVal(idx: integer): integer;
    procedure setVal(idx, value: integer);
    procedure setDefault(idx, value: integer);

    procedure addItem(itm: Widestring);
  end;

var
  frmCustomNotify: TfrmCustomNotify;

implementation

uses
    GnuGetText, PrefController;

{
0 Contact is online
1 Contact is offline
2 New chat session
3 Normal Messages
4 Subscription Requests
5 Conference Invites
6 Keywords (Conf. Rooms)
7 Chat window activity
8 Conf. Room activity
9 File Transfers
10 Auto Response generated
}


procedure TfrmCustomNotify.addItem(itm: Widestring);
begin
    chkNotify.Items.Add(itm);
end;

{$R *.dfm}

procedure TfrmCustomNotify.FormCreate(Sender: TObject);
begin
    TranslateProperties(Self);
    SetLength(_vals, 20);
    SetLength(_defs, 20);
end;

procedure TfrmCustomNotify.chkNotifyClick(Sender: TObject);
var
    e: boolean;
    i: integer;
begin
    // Show this item's options in the optNotify box.
    i := chkNotify.ItemIndex;

    _no_notify_update := true;

    e := chkNotify.Checked[i];
    chkToast.Enabled := e;
    chkFlash.Enabled := e;
    chkTrayNotify.Enabled := e;

    if chkToast.Enabled then begin
        chkToast.Checked := ((_vals[i] and notify_toast) > 0);
        chkFlash.Checked := ((_vals[i] and notify_flash) > 0);
        chkTrayNotify.Checked := ((_vals[i] and notify_tray) > 0);
    end
    else begin
        chkToast.Checked := false;
        chkFlash.Checked := false;
        chkTrayNotify.Checked := false;
        _vals[i] := 0;
    end;

    _no_notify_update := false;
    
end;

procedure TfrmCustomNotify.chkToastClick(Sender: TObject);
var
    i: integer;
begin
    // update the current notify selection
    if (_no_notify_update) then exit;

    i := chkNotify.ItemIndex;

    if (i < 0) then exit;
    if (i >= chkNotify.Items.Count) then exit;

    _vals[i] := 0;
    if (chkToast.Checked) then _vals[i] := _vals[i] + notify_toast;
    if (chkFlash.Checked) then _vals[i] := _vals[i] + notify_flash;
    if (chkTrayNotify.Checked) then _vals[i] := _vals[i] + notify_tray;

end;

function TfrmCustomNotify.getVal(idx: integer): integer;
begin
    result := _vals[idx];
end;

procedure TfrmCustomNotify.setVal(idx, value: integer);
begin
    if (Length(_vals) <= idx) then begin
        SetLength(_vals, idx + 5);
        SetLength(_defs, idx + 5);
    end;

    _vals[idx] := value;
    _defs[idx] := value;

    if (idx < chkNotify.Items.Count) then
        chkNotify.Checked[idx] := (_vals[idx] > 0);

end;

procedure TfrmCustomNotify.setDefault(idx, value: integer);
begin
    if (Length(_defs) <= idx) then
        SetLength(_defs, idx + 5);

    _defs[idx] := value;
end;

procedure TfrmCustomNotify.FormShow(Sender: TObject);
begin
    if (chkNotify.Items.Count > 0) then begin
        chkNotify.ItemIndex := 0;
        chkNotifyClick(Self);
    end;
end;

procedure TfrmCustomNotify.Label1Click(Sender: TObject);
var
    i: integer;
begin
    // restore _vals to _defs..
    for i := 0 to chkNotify.Items.Count - 1 do begin
        _vals[i] := _defs[i];
        chkNotify.Checked[i] := (_vals[i] > 0);
    end;
    chkToastClick(Self);
end;

end.
