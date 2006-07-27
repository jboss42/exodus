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
    Emote, Dockable, ActiveX, ComObj, BaseMsgList,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, ExRichEdit, RichEdit2,
    TntStdCtrls, TntMenus, Unicode;

const
    WM_THROB = WM_USER + 5400;

type

  TfrmBaseChat = class(TfrmDockable)
    pnlMsgList: TPanel;
    pnlInput: TPanel;
    Panel1: TPanel;
    popMsgList: TTntPopupMenu;
    popOut: TTntPopupMenu;
    MsgOut: TExRichEdit;
    timWinFlash: TTimer;
    Clear1: TTntMenuItem;
    CopyAll1: TTntMenuItem;
    Copy1: TTntMenuItem;
    emot_sep: TTntMenuItem;
    Emoticons2: TTntMenuItem;
    N2: TTntMenuItem;
    Paste2: TTntMenuItem;
    Copy3: TTntMenuItem;
    Copy2: TTntMenuItem;
    Splitter1: TSplitter;

    procedure Emoticons1Click(Sender: TObject);
    procedure MsgOutKeyPress(Sender: TObject; var Key: Char);
    procedure MsgOutKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure CopyAll1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure Copy3Click(Sender: TObject);
    procedure MsgOutKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure timWinFlashTimer(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);

  private
    { Private declarations }
    _msgHistory : TWideStringList;
    _pending : WideString;
    _lastMsg : integer;

  protected
    _embed_returns: boolean;        // Put CR/LF's into message
    _wrap_input: boolean;           // Wrap text input
    _scroll: boolean;               // Should we scroll
    _esc: boolean;                  // Does ESC close
    _close_key: Word;               // Normal Hot-key to use to close
    _close_shift: TShiftState;
    _msgframe: TObject;

    procedure _scrollBottom();
    function getMsgList(): TfBaseMsgList;

  public
    { Public declarations }
    AutoScroll: boolean;

    procedure SetEmoticon(e: TEmoticon);
    procedure SendMsg(); virtual;
    procedure HideEmoticons();
    procedure Flash;
    procedure pluginMenuClick(Sender: TObject); virtual; abstract;
    procedure gotActivate; override;
    property MsgList: TfBaseMsgList read getMsgList;
  end;

var
  frmBaseChat: TfrmBaseChat;

implementation

{$R *.dfm}
uses
    RTFMsgList, ClipBrd, Session, MsgDisplay, ShellAPI, Emoticons, Jabber1, ExUtils;

{---------------------------------------}
procedure TfrmBaseChat.Emoticons1Click(Sender: TObject);
var
    r: TRect;
    m, w, h, l, t: integer;
    cp: TPoint;
begin
  inherited;
    // Show the emoticons form
    GetCaretPos(cp);
    l := MsgOut.ClientOrigin.x + cp.X;
    m := Screen.MonitorFromWindow(Self.Handle).MonitorNum;

    r := Screen.Monitors[m].WorkAreaRect;
    w := Abs(r.Right - r.Left);
    h := Abs(r.Bottom - r.Top);

    if ((l + frmEmoticons.Width) > w) then
        l := w - frmEmoticons.Width - 5;

    frmEmoticons.Left := l + 10;

    if (Self.Docked) then begin
        t := frmExodus.Top + frmExodus.ClientHeight - 10;
    end
    else begin
        t := Self.Top + Self.ClientHeight - 10;
    end;

    if ((t + frmEmoticons.Height) > h) then
        t := h - frmEmoticons.Height;

    frmEmoticons.Top := t;
    frmEmoticons.ChatWindow := Self;
    frmEmoticons.Show;
end;

{---------------------------------------}
procedure TfrmBaseChat.SetEmoticon(e: TEmoticon);
var
    l: integer;
    etxt: Widestring;
begin
    // Setup some Emoticon
    etxt := EmoticonList.getText(e);
    if (etxt = '') then exit;

    l := Length(MsgOut.Text);
    if ((l > 0) and (MsgOut.Text[l] <> ' ')) then
        MsgOut.SelText := ' ';
    MsgOut.SelText := etxt;
end;

{---------------------------------------}
procedure TfrmBaseChat.gotActivate;
begin
    OutputDebugString('frmBaseChat.gotActivate');
    if (timWinFlash.Enabled) then
        timWinFlash.Enabled := false;
    frmExodus.ActiveChat := Self;
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgOutKeyPress(Sender: TObject; var Key: Char);
begin
    if (key <> #0) then
        inherited;
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgOutKeyUp(Sender: TObject;
                                   var Key: Word;
                                   Shift: TShiftState);
    procedure newText(m: WideString);
    begin
        MsgOut.WideText := m;
        MsgOut.SelStart := length(m);
        MsgOut.SetFocus();
    end;

begin
    // for now.
    // TODO: use the message history that's in MsgList
    if ((Key = VK_UP) and (Shift = [ssCtrl])) then begin
        if (_lastMsg >= _msgHistory.Count) then
            _pending := getInputText(MsgOut);

        dec(_lastMsg);
        if (_lastMsg < 0) then begin
            _lastMsg := 0;
            exit;
        end;
        newText(_msgHistory[_lastMsg]);
    end
    else if ((Key = VK_DOWN) and (Shift = [ssCtrl])) then begin
        if (_lastMsg >= _msgHistory.Count) then begin
            if (_pending <> '') then
                newText(_pending);
            exit;
        end;

        inc(_lastMsg);
        if (_lastMsg >= _msgHistory.Count) then begin
            if (_pending <> '') then
                newText(_pending);
            exit;
        end;
        newText(_msgHistory[_lastMsg]);
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

    // handle close window/tab hotkeys
    else if ((Key = _close_key) and (Shift = _close_shift)) then
        Self.Close()
    else if ((_esc) and (Key = 27)) then
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
    end

    // magic debug key sequence Ctrl-Shift-H to dump the HTML or RTF to debug.
    else if ((chr(Key) = 'H') and  (Shift = [ssCtrl, ssShift])) then begin
        DebugMsg(getMsgList.getHistory());
    end;
end;

{---------------------------------------}
procedure TfrmBaseChat.SendMsg();
begin
    _msgHistory.Add(getInputText(MsgOut));
    _lastMsg := _msgHistory.Count;
    _pending := '';

    MsgOut.Lines.Clear();
    MsgOut.SetFocus;
end;

{---------------------------------------}
procedure TfrmBaseChat.FormCreate(Sender: TObject);
var
    ht: integer;
    sc: TShortcut;
begin
    AutoScroll := true;

    _msgHistory := TWideStringList.Create();
    _pending := '';
    _lastMsg := -1;
    _esc := false;

    // Pick which frame to build
    //ms := MainSession.prefs.getInt('msglist_type');
    //if (ms = 0) then
    _msgframe := TfRTFMsgList.Create(Self);

    with MsgList do begin
        Name := 'msg_list_frame';
        Parent := pnlMsgList;
        Align := alClient;
        Visible := true;
        setContextMenu(popMsgList);
        ready();
    end;

    inherited;

    if (MainSession <> nil) then begin
        ht := MainSession.Prefs.getInt('chat_textbox');
        if (ht <> 0) then
            pnlInput.Height := ht
        else
            MainSession.prefs.setInt('chat_textbox', pnlInput.Height);
        _esc := MainSession.Prefs.getBool('esc_close');

        sc := TextToShortcut(MainSession.Prefs.getString('close_hotkey'));
        ShortCutToKey(sc, _close_key, _close_shift);
    end;

    _scroll := true;
end;

{---------------------------------------}
procedure TfrmBaseChat.FormDestroy(Sender: TObject);
begin
    if (frmExodus <> nil) then
        frmExodus.ActiveChat := nil;
    TfBaseMsgList(_msgframe).Free();
    _msgHistory.Free();
    inherited;
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
    MsgList.CopyAll();
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
    MsgList.Copy();
end;

{---------------------------------------}
procedure TfrmBaseChat.Paste1Click(Sender: TObject);
begin
    inherited;
    MsgOut.PasteFromClipboard();
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
procedure TfrmBaseChat._scrollBottom();
begin
    OutputDebugString('_scrollBottom');
    MsgList.ScrollToBottom();
end;

{---------------------------------------}
procedure TfrmBaseChat.timWinFlashTimer(Sender: TObject);
begin
    // Flash the window
    OutputDebugString('timWinFlashTimer');
    FlashWindow(Self.Handle, true);
end;

{---------------------------------------}
procedure TfrmBaseChat.Flash;
begin
    if Self.Active then exit;

    OutputDebugString('Flash');
    if MainSession.Prefs.getBool('notify_flasher') then begin
        timWinFlash.Enabled := true;
    end
    else begin
        timWinFlash.Enabled := false;
        timWinFlashTimer(Self);
    end;
end;

{---------------------------------------}
procedure TfrmBaseChat.FormEndDock(Sender, Target: TObject; X, Y: Integer);
begin
    if (Target = nil) then exit;

    inherited;
    if timWinFlash.Enabled then
        timWinFlash.Enabled := false;
    MsgList.refresh();
end;


{---------------------------------------}
function TfrmBaseChat.getMsgList(): TfBaseMsgList;
begin
    Result := TfBaseMsgList(_msgframe);
end;

end.
