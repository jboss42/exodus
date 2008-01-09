unit BaseChat;
{
    Copyright 2002, Peter Millard

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
    Dockable, ActiveX, ComObj,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, ExRichEdit, RichEdit2,
    TntStdCtrls;

const
    WM_THROB = WM_USER + 5400;

type
  TfrmBaseChat = class(TfrmDockable)
    Panel3: TPanel;
    MsgList: TExRichEdit;
    Splitter1: TSplitter;
    pnlInput: TPanel;
    Panel1: TPanel;
    popMsgList: TPopupMenu;
    Copy1: TMenuItem;
    CopyAll1: TMenuItem;
    Clear1: TMenuItem;
    popOut: TPopupMenu;
    Copy2: TMenuItem;
    Copy3: TMenuItem;
    Paste2: TMenuItem;
    N2: TMenuItem;
    Emoticons2: TMenuItem;
    MsgOut: TExRichEdit;
    timWinFlash: TTimer;
    emot_sep: TMenuItem;

    procedure Emoticons1Click(Sender: TObject);
    procedure MsgListURLClick(Sender: TObject; url: String);
    procedure FormActivate(Sender: TObject);
    procedure MsgOutKeyPress(Sender: TObject; var Key: Char);
    procedure MsgOutKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MsgListKeyPress(Sender: TObject; var Key: Char);
    procedure Splitter1Moved(Sender: TObject);
    procedure CopyAll1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure Copy3Click(Sender: TObject);
    procedure MsgListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MsgOutKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure timWinFlashTimer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure MsgListEnter(Sender: TObject);
    procedure MsgOutEnter(Sender: TObject);
    procedure MsgOutMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    _msgHistory : TStringList;
    _lastMsg : integer;

  protected
    _embed_returns: boolean;
    _wrap_input: boolean;
    _scroll: boolean;

    procedure _scrollBottom();
    procedure WMThrob(var msg: TMessage); message WM_THROB;
    procedure WMVScroll(var msg: TMessage); message WM_VSCROLL;

  public
    { Public declarations }
    AutoScroll: boolean;

    procedure SetEmoticon(msn: boolean; imgIndex: integer);
    procedure SendMsg(); virtual;
    procedure HideEmoticons();
    procedure Flash;
    procedure pluginMenuClick(Sender: TObject); virtual; abstract;

  end;

var
  frmBaseChat: TfrmBaseChat;

implementation

{$R *.dfm}
uses
    ClipBrd, Session, MsgDisplay, ShellAPI, Emoticons, Jabber1;

{---------------------------------------}
procedure TfrmBaseChat.Emoticons1Click(Sender: TObject);
var
    l, t: integer;
    cp: TPoint;
begin
  inherited;
    // Show the emoticons form
    GetCaretPos(cp);
    l := MsgOut.ClientOrigin.x + cp.X;

    if (Self.Docked) then begin
        t := frmExodus.Top + frmExodus.ClientHeight - 10;
        frmEmoticons.Left := l + 10;
    end
    else begin
        t := Self.Top + Self.ClientHeight - 10;
        frmEmoticons.Left := l + 10;
    end;

    if ((t + frmEmoticons.Height) > Screen.Height) then
        t := Screen.Height - frmEmoticons.Height;

    frmEmoticons.Top := t;
    frmEmoticons.ChatWindow := Self;
    frmEmoticons.Show;
end;

{---------------------------------------}
procedure TfrmBaseChat.SetEmoticon(msn: boolean; imgIndex: integer);
var
    l, i, m: integer;
    eo: TEmoticon;
begin
    // Setup some Emoticon
    m := -1;

    if (emoticon_list.Count = 0) then
        ConfigEmoticons();

    for i := 0 to emoticon_list.Count - 1 do begin
        eo := TEmoticon(emoticon_list.Objects[i]);
        if (((msn) and (eo.il = frmExodus.imgMSNEmoticons)) or
        ((not msn) and (eo.il = frmExodus.imgYahooEmoticons))) then begin
            // the image lists match
            if (eo.idx = imgIndex) then begin
                m := i;
                break;
            end;
        end;
    end;

    if (m >= 0) then begin
        l := length(MsgOut.Text);
        if ((l > 0) and ((MsgOut.Text[l]) <> ' ')) then
            MsgOut.SelText := ' ';
        MsgOut.SelText := emoticon_list[m];
    end;
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgListURLClick(Sender: TObject; url: String);
begin
    ShellExecute(0, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

{---------------------------------------}
procedure TfrmBaseChat.FormActivate(Sender: TObject);
begin
    if (timWinFlash.Enabled) then
        timWinFlash.Enabled := false;

    frmExodus.ActiveChat := Self;

    if ((frmEmoticons <> nil) and (frmEmoticons.Visible)) then
        frmEmoticons.Hide;

    if (Self.Visible) and (pnlInput.Visible) then begin
        MsgList.Invalidate();
        MsgOut.SetFocus;
    end;

    inherited;
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgOutKeyPress(Sender: TObject; var Key: Char);
begin
    // I don't agree with this hotkey... it can be "bad"
    {
    if ( Key = #27 ) then
        Close();
    }
    if (key <> #0) then
        inherited;
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgOutKeyUp(Sender: TObject;
                                   var Key: Word;
                                   Shift: TShiftState);
var
    m : string;
begin
// for now.
// TODO: use the message history that's in MsgList
    if ((Key = VK_UP) and (Shift = [ssCtrl])) then begin
        dec(_lastMsg);
        if (_lastMsg < 0) then begin
            _lastMsg := 0;
            exit;
        end;
        m := _msgHistory[_lastMsg];
        MsgOut.Text := m;
        MsgOut.SelStart := length(m);
        MsgOut.SetFocus();
    end
    else if ((Key = VK_DOWN) and (Shift = [ssCtrl])) then begin
        if (_lastMsg = _msgHistory.Count) then exit;
        inc(_lastMsg);
        if (_lastMsg >= _msgHistory.Count) then begin
            _lastMsg := _msgHistory.Count - 1;
            exit;
        end;
        m := _msgHistory[_lastMsg];
        MsgOut.Text := m;
        MsgOut.SelStart := length(m);
        MsgOut.SetFocus();
    end
    else
        inherited;
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgOutKeyDown(Sender: TObject; var Key: Word;
                                     Shift: TShiftState);
begin
    if (Key = 0) then exit;

    // handle Ctrl-Tab to switch tabs
    if ((Key = VK_TAB) and (ssCtrl in Shift) and (self.Docked))then begin
        Self.TabSheet.PageControl.SelectNextPage(not (ssShift in Shift));
        Key := 0;
    end

    // handle Ctrl-W to close tab
    else if ((Key = Ord('W')) and (ssCtrl in Shift)) then
        Self.Close()

    // handle Ctrl-ENTER and ENTER to send msgs
    else if (Key = VK_RETURN) then begin
        if ((Shift = []) and (not _embed_returns)) then begin
            Key := 0;
            SendMsg();
        end
        else if (Shift = [ssCtrl]) then begin
            Key := 0;
            SendMsg()
        end;
    end;
end;

{---------------------------------------}
procedure TfrmBaseChat.SendMsg();
begin
    _msgHistory.Add(MsgOut.Text);
    _lastMsg := _msgHistory.Count;

    MsgOut.Lines.Clear();
    MsgOut.SetFocus;
end;

{---------------------------------------}
procedure TfrmBaseChat.FormCreate(Sender: TObject);
var
    ht: integer;
begin
    AutoScroll := true;

    _msgHistory := TStringList.Create();
    _lastMsg := -1;

    if (MainSession <> nil) then begin
        ht := MainSession.Prefs.getInt('chat_textbox');
        if (ht <> 0) then
            pnlInput.Height := ht
        else
            MainSession.prefs.setInt('chat_textbox', pnlInput.Height);
    end;

    _scroll := true;

    inherited;
end;

{---------------------------------------}
procedure TfrmBaseChat.FormDestroy(Sender: TObject);
begin
    frmExodus.ActiveChat := nil;
    _msgHistory.Free();

    inherited;
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgListKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
    // If typing starts on the MsgList, then bump it to the outgoing
    // text box.
    if (not Self.Visible) then exit;
    if (Ord(key) < 32) then exit;

    if (pnlInput.Visible) then begin
        MsgOut.SetFocus();
        MsgOut.SelText := Key;
    end;
end;

{---------------------------------------}
procedure TfrmBaseChat.Splitter1Moved(Sender: TObject);
begin
  inherited;
    // save the new position to use on all new windows
    MainSession.prefs.setInt('chat_textbox', pnlInput.Height);
end;

{---------------------------------------}
procedure TfrmBaseChat.CopyAll1Click(Sender: TObject);
begin
  inherited;
  MsgList.SelectAll;
  MsgList.CopyToClipboard;
end;

{---------------------------------------}
procedure TfrmBaseChat.Clear1Click(Sender: TObject);
begin
    inherited;
    MsgList.Clear();
    _msgHistory.Clear();
end;

{---------------------------------------}
procedure TfrmBaseChat.Copy1Click(Sender: TObject);
begin
    inherited;
    MsgList.CopyToClipboard();
end;

{---------------------------------------}
procedure TfrmBaseChat.Paste1Click(Sender: TObject);
begin
    inherited;
    MsgOut.PasteFromClipboard();
end;

{---------------------------------------}
procedure TfrmBaseChat.FormResize(Sender: TObject);
begin
  inherited;
    if (timWinFlash.Enabled) then
        timWinFlash.Enabled := false;

    MsgList.Repaint();
end;

{---------------------------------------}
procedure TfrmBaseChat.HideEmoticons();
begin
    if frmEmoticons.Visible then
        frmEmoticons.Hide();
end;

{---------------------------------------}
procedure TfrmBaseChat.Copy2Click(Sender: TObject);
begin
  inherited;
    MsgOut.CopyToClipboard();
    MsgOut.SelText := '';
end;

{---------------------------------------}
procedure TfrmBaseChat.Copy3Click(Sender: TObject);
begin
  inherited;
    MsgOut.CopyToClipboard();
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgListMouseUp(Sender: TObject;
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
procedure TfrmBaseChat._scrollBottom();
var
    vis_l: integer;
    top_c, bot_c: integer;
    top_l, bot_l: integer;
    p: TPoint;

begin
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
procedure TfrmBaseChat.timWinFlashTimer(Sender: TObject);
begin
    // Flash the window
    FlashWindow(Self.Handle, true);
end;

{---------------------------------------}
procedure TfrmBaseChat.Flash;
begin
    if Self.Active then exit;

    if MainSession.Prefs.getBool('notify_flasher') then begin
        if (not timWinFlash.Enabled) then
            PostMessage(Self.Handle, WM_THROB, 0, 0);
        end
    else begin
        timWinFlash.Enabled := false;
        timWinFlashTimer(Self);
    end;
end;

{---------------------------------------}
procedure TfrmBaseChat.FormPaint(Sender: TObject);
begin
  inherited;
    if timWinFlash.Enabled then begin
        timWinFlash.Enabled := false;
        FlashWindow(Self.Handle, false);
    end;
end;

{---------------------------------------}
procedure TfrmBaseChat.FormEndDock(Sender, Target: TObject; X, Y: Integer);
begin
  inherited;
    if timWinFlash.Enabled then
        timWinFlash.Enabled := false;
end;

{---------------------------------------}
procedure TfrmBaseChat.WMThrob(var msg: TMessage);
begin
    // Enable the flash timer
    timWinFlash.Enabled := false;
    timWinFlash.Enabled := true;
end;

{---------------------------------------}
procedure TfrmBaseChat.WMVScroll(var msg: TMessage);
begin
    //
    if (msg.WParamLo = SB_THUMBPOSITION) then begin
        _scroll := true;
    end
    else if (msg.WParamLo = SB_THUMBTRACK) then begin
        _scroll := false;
    end;
    inherited;
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgListEnter(Sender: TObject);
begin
    if (frmExodus.ActiveChat <> Self) then
        Self.FormActivate(Self);
  inherited;
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgOutEnter(Sender: TObject);
begin
    if (frmExodus.ActiveChat <> Self) then
        Self.FormActivate(Self);
  inherited;
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgOutMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if (frmExodus.ActiveChat <> Self) then
        Self.FormActivate(Self);
  inherited;
end;

end.
