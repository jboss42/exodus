unit RTFMsgList;
{
    Copyright 2004, Peter Millard

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
    TntMenus, JabberMsg,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, BaseMsgList, StdCtrls, ComCtrls, RichEdit2, ExRichEdit;

type
  TfRTFMsgList = class(TfBaseMsgList)
    MsgList: TExRichEdit;
    procedure MsgListEnter(Sender: TObject);
    procedure MsgListKeyPress(Sender: TObject; var Key: Char);
    procedure MsgListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MsgListURLClick(Sender: TObject; URL: String);
  private
    { Private declarations }

  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;

    procedure Invalidate(); override;
    procedure CopyAll(); override;
    procedure Copy(); override;
    procedure ScrollToBottom(); override;
    procedure Clear(); override;
    procedure setContextMenu(popup: TTntPopupMenu); override;
    procedure setDragOver(event: TDragOverEvent); override;
    procedure setDragDrop(event: TDragDropEvent); override;
    procedure DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true); override;
    procedure DisplayPresence(txt: string); override;
    function  getHandle(): THandle; override;
    function  getObject(): TObject; override;
    function  empty(): boolean; override;
    function  getHistory(): Widestring; override;
    procedure Save(fn: string); override;
    procedure populate(history: Widestring); override;
    procedure setupPrefs(); override;
  end;

var
  fRTFMsgList: TfRTFMsgList;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ExUtils, Session, MsgDisplay, ShellAPI, BaseChat, Jabber1;

{$R *.dfm}

{---------------------------------------}
constructor TfRTFMsgList.Create(Owner: TComponent);
begin
    inherited Create(Owner);
end;

{---------------------------------------}
procedure TfRTFMsgList.Invalidate();
begin
    inherited;
    MsgList.invalidate();
end;

{---------------------------------------}
procedure TfRTFMsgList.CopyAll();
begin
    inherited;

    MsgList.SelectAll;
    MsgList.CopyToClipboard;
end;

{---------------------------------------}
procedure TfRTFMsgList.Clear();
begin
    MsgList.Clear();
end;

{---------------------------------------}
procedure TfRTFMsgList.Copy();
begin
    inherited;
    MsgList.CopyToClipboard();
end;

{---------------------------------------}
procedure TfRTFMsgList.ScrollToBottom();
var
    vis_l: integer;
    top_c, bot_c: integer;
    top_l, bot_l: integer;
    p: TPoint;
begin
    inherited;
    with MsgList do begin
        p := Point(0, 0);
        top_c := Perform(EM_CHARFROMPOS, 0, Integer(@P));
        top_l := Perform(EM_LINEFROMCHAR, top_c, 0);
        p := Point(0, ClientHeight);
        bot_c := Perform(EM_CHARFROMPOS, 0, Integer(@P));
        bot_l := Perform(EM_LINEFROMCHAR, bot_c, 0);
        vis_l := bot_l - top_l;
        Perform(EM_LINESCROLL, 0, Lines.Count - vis_l + 1);
        Invalidate();
    end;
end;

{---------------------------------------}
procedure TfRTFMsgList.setContextMenu(popup: TTntPopupMenu);
begin
    MsgList.PopupMenu := popup;
end;

{---------------------------------------}
procedure TfRTFMsgList.MsgListEnter(Sender: TObject);
var
    bc: TfrmBaseChat;
begin
    bc := TfrmBaseChat(_base);
    if (frmExodus.ActiveChat <> bc) then
        bc.FormActivate(bc);
    inherited;
end;

{---------------------------------------}
procedure TfRTFMsgList.MsgListKeyPress(Sender: TObject; var Key: Char);
var
    bc: TfrmBaseChat;
begin
  inherited;
    // If typing starts on the MsgList, then bump it to the outgoing
    // text box.
    bc := TfrmBaseChat(_base);

    if (not bc.Visible) then exit;
    if (Ord(key) < 32) then exit;

    if (bc.pnlInput.Visible) then begin
        bc.MsgOut.SetFocus();
        bc.MsgOut.WideSelText := Key;
    end;

end;

{---------------------------------------}
procedure TfRTFMsgList.MsgListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    cp: TPoint;
begin
    if ((Button = mbRight) and (MsgList.PopupMenu <> nil)) then begin
        GetCursorPos(cp);
        MsgList.PopupMenu.Popup(cp.x, cp.y);
    end;
end;

{---------------------------------------}
procedure TfRTFMsgList.MsgListURLClick(Sender: TObject; URL: String);
begin
  inherited;
    ShellExecute(Application.Handle, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

{---------------------------------------}
function TfRTFMsgList.getHandle(): THandle;
begin
    Result := MsgList.Handle;
end;

{---------------------------------------}
function TfRTFMsgList.getObject(): TObject;
begin
    Result := MsgList;
end;

{---------------------------------------}
procedure TfRTFMsgList.DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true);
begin
    DisplayRTFMsg(MsgList, Msg, AutoScroll);
end;

{---------------------------------------}
procedure TfRTFMsgList.DisplayPresence(txt: string);
var
    pt : integer;
    at_bottom: boolean;
begin
    at_bottom := MsgList.atBottom;
    pt := MainSession.Prefs.getInt('pres_tracking');
    if (pt = 2) then exit;
    with MsgList do begin
        if (pt = 1) then begin
            MsgList.SelStart := Length(MsgList.Lines.Text) - 3;
            MsgList.SelLength := 1;
            if (MsgList.SelAttributes.Color = clGray) then
                MsgList.WideLines.Delete(MsgList.Lines.Count-1);
        end;

        SelStart := Length(Lines.Text);
        SelLength := 0;

        SelAttributes.Color := clGray;
        WideSelText := txt + #13#10;
    end;

    if (at_bottom) then MsgList.ScrollToBottom();
end;

(*
{---------------------------------------}
function atBottom(RichEdit: TExRichEdit): boolean;
var
    si: TSCROLLINFO;
begin
    si.cbSize := SizeOf(TScrollInfo);
    si.fMask := SIF_ALL;
    GetScrollInfo(RichEdit.Handle, SB_VERT, si);
    if (si.nMax = -1) then
        Result := true
    else
        Result := ((si.nPos + integer(si.nPage)) >= si.nMax);
end;
*)

{---------------------------------------}
procedure TfRTFMsgList.Save(fn: string);
var
    ext: widestring;
    fmt: TOutputFormat;
begin
    ext := ExtractFileExt(fn);
    fmt := MsgList.OutputFormat;

    if (ext = '.rtf') then
        MsgList.OutputFormat := ofRTF
    else if (ext = '.txt') then
        MsgList.OutputFormat := ofUnicode;

    MsgList.WideLines.SaveToFile(fn);
    MsgList.OutputFormat := fmt;
end;

{---------------------------------------}
procedure TfRTFMsgList.populate(history: Widestring);
begin
    with MsgList do begin
        // repopulate history..
        InputFormat := ifRTF;
        SelStart := 0;
        SelLength := Length(Lines.Text);
        RTFSelText := history;
        InputFormat := ifUnicode;

        // always remove the last line..
        Lines.Delete(Lines.Count - 1);
    end;
end;

{---------------------------------------}
procedure TfRTFMsgList.setupPrefs();
begin
    AssignDefaultFont(MsgList.Font);
    MsgList.Color := TColor(MainSession.Prefs.getInt('color_bg'));
end;

{---------------------------------------}
function TfRTFMsgList.empty(): boolean;
begin
    Result := MsgList.Lines.Count > 0;
end;

{---------------------------------------}
function TfRTFMsgList.getHistory(): Widestring;
begin
    MsgList.Visible := false;
    MsgList.SelectAll();
    Result := MsgList.RTFSelText;
end;

{---------------------------------------}
procedure TfRTFMsgList.setDragOver(event: TDragOverEvent);
begin
    MsgList.OnDragOver := event;
end;

{---------------------------------------}
procedure TfRTFMsgList.setDragDrop(event: TDragDropEvent);
begin
    MsgList.onDragDrop := event;
end;


end.
