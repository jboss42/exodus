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
    procedure MsgListKeyPress(Sender: TObject; var Key: Char);
    procedure MsgListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MsgListURLClick(Sender: TObject; URL: String);
  private
    { Private declarations }
    _presence_last : boolean;
    _composing: integer;

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
    procedure DisplayPresence(txt: string; timestamp: string); override;
    function  getHandle(): THandle; override;
    function  getObject(): TObject; override;
    function  empty(): boolean; override;
    function  getHistory(): Widestring; override;
    procedure Save(fn: string); override;
    procedure populate(history: Widestring); override;
    procedure setupPrefs(); override;
    procedure DisplayComposing(msg: Widestring); override;
    procedure HideComposing(); override;
    function  isComposing(): boolean; override;
  end;

var
  fRTFMsgList: TfRTFMsgList;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    Emote,
    XMLTag, 
    JabberUtils, ExUtils,  Session, MsgDisplay, ShellAPI, BaseChat, Jabber1;

{$R *.dfm}

{---------------------------------------}
constructor TfRTFMsgList.Create(Owner: TComponent);
begin
    inherited Create(Owner);
    _presence_last := false;
    _composing := -1;
end;

{---------------------------------------}
procedure TfRTFMsgList.Invalidate();
begin
    inherited;
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
var
 i: Integer;
begin
    MsgList.Clear();
    for i := 0 to MsgList.Lines.Count - 1 do begin
         MsgList.Lines[i] := '';
    end;

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
procedure TfRTFMsgList.MsgListKeyPress(Sender: TObject; var Key: Char);
var
    bc: TfrmBaseChat;
begin
    // If typing starts on the MsgList, then bump it to the outgoing
    // text box.
    bc := TfrmBaseChat(_base);
    if (not bc.MsgOut.Enabled) then
        Exit;

    if (not bc.Visible) then exit;

    if (Ord(key) = 22) then begin
        // paste, Ctrl-V
        if (bc.MsgOut.Visible and bc.MsgOut.Enabled) then begin
            bc.MsgOut.SetFocus();
            bc.MsgOut.PasteFromClipboard();
        end;
        Key := #0;
        exit;
    end;

   if ((MainSession.Prefs.getBool('esc_close')) and (Ord(key) = 27)) then begin
      if (Self.Parent <> nil) then
        if (Self.Parent.Parent <> nil) then
          SendMessage(Self.Parent.Parent.Handle, WM_CLOSE, 0, 0);
          exit;
   end;

    if (Ord(key) < 32) then exit;

    if (bc.pnlInput.Visible) then begin
        if (bc.MsgOut.Visible and bc.MsgOut.Enabled) then begin
            bc.MsgOut.SetFocus();
            bc.MsgOut.WideSelText := Key;
        end;
    end;

    Key := #0;
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
    Screen.Cursor := crHourGlass;
    ShellExecute(Application.Handle, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
    Screen.Cursor := crDefault;
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
    _presence_last := false;
    DisplayRTFMsg(MsgList, Msg, AutoScroll);
end;

{---------------------------------------}
procedure TfRTFMsgList.DisplayPresence(txt: string; timestamp: string);
var
    pt : integer;
    at_bottom: boolean;
    c : TColor;
begin
    at_bottom := MsgList.atBottom;
    c := TColor(MainSession.Prefs.getInt('color_time'));
    pt := MainSession.Prefs.getInt('pres_tracking');
    if (pt = 2) then exit;
    with MsgList do begin
        if (pt = 1) then begin
            if (_presence_last) then
                WideLines.Delete(WideLines.Count-1);
        end;

        SelStart := Length(WideLines.Text);
        SelLength := 0;

        // TODO: Use newfangled RTF madness
        SelAttributes.Color := c;
        Paragraph.Alignment := taLeft;
        if timestamp <> '' then
            txt := '[' + timestamp + '] ' + txt;

        WideSelText := txt + #13#10;
    end;

    _presence_last := true;
    if (at_bottom) then MsgList.ScrollToBottom();
end;

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
    MsgList.Clear();
    MsgList.SelStart := 0;
    MsgList.RTFSelText := history;
    MsgList.Lines.Delete(MsgList.Lines.Count - 1);
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
    Result := (MsgList.Lines.Count = 0);
end;

{---------------------------------------}
function TfRTFMsgList.getHistory(): Widestring;
var
    ss, sl: integer;
begin
    MsgList.BeginUpdate();
    ss := MsgList.SelStart;
    sl := MsgList.SelLength;
    MsgList.SelectAll();
    Result := MsgList.RTFSelText;
    MsgList.SelStart := ss;
    MsgList.SelLength := sl;
    MsgList.EndUpdate();
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

{---------------------------------------}
procedure TfRTFMsgList.DisplayComposing(msg: Widestring);
begin
    HideComposing();
    _composing := MsgList.WideLines.Count;
    MsgList.SelStart := Length(MsgList.WideLines.Text);
    MsgList.SelLength := 0;
    MsgList.SelAttributes.Color := TColor(MainSession.Prefs.getInt('color_action'));
    MsgList.Paragraph.Alignment := taCenter;
    MsgList.WideSelText := msg + #13#10;
end;

{---------------------------------------}
procedure TfRTFMsgList.HideComposing();
begin
    //
    if (_composing = -1) then exit;

    MsgList.WideLines.Delete(_composing);
    _composing := -1;
end;

{---------------------------------------}
function TfRTFMsgList.isComposing(): boolean;
begin
    Result := (_composing >= 0);
end;

end.
