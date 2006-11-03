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
    Prefs, Emote, Dockable, ActiveX, ComObj, BaseMsgList,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, ExRichEdit, RichEdit2,
    TntStdCtrls, TntMenus, Unicode, ToolWin, TntComCtrls, ImgList, XMLTag, XMLUtils,
  Buttons;

const
    WM_THROB = WM_USER + 5400;

    sPref_Hotkeys_Keys = 'hotkeys_keys';
    sPref_Hotkeys_Text = 'hotkeys_text';

type

  TfrmBaseChat = class(TfrmDockable)
    pnlMsgList: TPanel;
    pnlInput: TPanel;
    popMsgList: TTntPopupMenu;
    popOut: TTntPopupMenu;
    MsgOut: TExRichEdit;
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
    tbMsgOutToolbar: TTntToolBar;
    ChatToolbarButtonBold: TTntToolButton;
    ChatToolbarButtonUnderline: TTntToolButton;
    ChatToolbarButtonItalics: TTntToolButton;
    ChatToolbarButtonSeperator1: TTntToolButton;
    ChatToolbarButtonCut: TTntToolButton;
    ChatToolbarButtonCopy: TTntToolButton;
    ChatToolbarButtonPaste: TTntToolButton;
    ChatToolbarButtonSeperator2: TTntToolButton;
    ChatToolbarButtonEmoticons: TTntToolButton;
    ChatToolbarButtonHotkeys: TTntToolButton;
    popHotkeys: TTntPopupMenu;
    popHotkeys_sep1: TTntMenuItem;
    Customize1: TTntMenuItem;
    pnlChatTop: TPanel;

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
    procedure BoldClick(Sender: TObject);
    procedure UnderlineClick(Sender: TObject);
    procedure ItalicsClick(Sender: TObject);
    procedure ChatToolbarButtonHotkeysClick(Sender: TObject);
    procedure OnHotkeysClick(Sender: TObject);
    procedure Customize1Click(Sender: TObject);
    procedure MsgOutOnEnter(Sender: TObject);

  private
    { Private declarations }
    _msgHistory : TWideStringList;
    _pending : WideString;
    _lastMsg : integer;
    _hotkey_menu_items : TWideStringList;
    _hotkeys_keys_stringlist : TWideStringList;
    _hotkeys_text_stringlist : TWideStringList;

  protected
    _embed_returns: boolean;        // Put CR/LF's into message
    _wrap_input: boolean;           // Wrap text input
    _scroll: boolean;               // Should we scroll
    _esc: boolean;                  // Does ESC close
    _close_key: Word;               // Normal Hot-key to use to close
    _close_shift: TShiftState;
    _msgframe: TObject;
    _session_chat_toolbar_callback: integer;
    _session_close_all_callback: integer;

    procedure _scrollBottom();
    function getMsgList(): TfBaseMsgList;

  public
    { Public declarations }
    AutoScroll: boolean;

    procedure SetEmoticon(e: TEmoticon);
    procedure SendMsg(); virtual;
    procedure HideEmoticons();
    procedure pluginMenuClick(Sender: TObject); virtual; abstract;
    property MsgList: TfBaseMsgList read getMsgList;
    procedure OnSessionCallback(event: string; tag: TXMLTag);

    {
        Event fired when docking is complete.

        Docked property will be true, tabsheet will be assigned. This event
        is fired after all other docking events are complete.
    }
    procedure OnDocked();override;

    {
        Event fired when a float (undock) is complete.

        Docked property will be false, tabsheet will be nil. This event
        is fired after all other floating events are complete.
    }
    procedure OnFloat();override;

    procedure gotActivate();override;
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

procedure TfrmBaseChat.MsgOutOnEnter(Sender: TObject);
begin
    _hotkeys_keys_stringlist.Clear();
    _hotkeys_text_stringlist.Clear();
    MainSession.Prefs.fillStringlist(sPref_Hotkeys_Keys, _hotkeys_keys_stringlist);
    MainSession.Prefs.fillStringlist(sPref_Hotkeys_Text, _hotkeys_text_stringlist);
end;

{---------------------------------------}
procedure TfrmBaseChat.MsgOutKeyDown(Sender: TObject; var Key: Word;
                                     Shift: TShiftState);
var
    hotkeyidx: integer;
begin
    if (Key = 0) then exit;
    // handle Ctrl-Tab to switch tabs
    if ((Key = VK_TAB) and (ssCtrl in Shift) and (self.Docked))then begin
        GetDockManager().SelectNext(not (ssShift in Shift));
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
    end
    else if ((Key >= VK_F1) and (Key <= VK_F12) and (Shift <> [ssCtrl, ssShift])) then begin
        case Key of
            VK_F1: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F01');
            VK_F2: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F02');
            VK_F3: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F03');
            VK_F4: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F04');
            VK_F5: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F05');
            VK_F6: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F06');
            VK_F7: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F07');
            VK_F8: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F08');
            VK_F9: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F09');
            VK_F10: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F10');
            VK_F11: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F11');
            VK_F12: hotkeyidx := _hotkeys_keys_stringlist.IndexOf('F12');
            else
                hotkeyidx := -1;
        end;
        if (hotkeyidx >= 0) then
            MsgOut.SelText := _hotkeys_text_stringlist.Strings[hotkeyidx];
    end
    else inherited;
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
procedure TfrmBaseChat.gotActivate();
begin
    inherited;
    frmExodus.ActiveChat := Self;

    if (MsgOut.Visible and MsgOut.Enabled) then
        MsgOut.SetFocus();
end;

procedure TfrmBaseChat.FormCreate(Sender: TObject);
var
    ht: integer;
    sc: TShortcut;
begin
    AutoScroll := true;

    _hotkey_menu_items := TWideStringList.Create();
    _hotkeys_keys_stringlist := TWideStringList.Create();
    _hotkeys_text_stringlist := TWideStringList.Create();

    MainSession.Prefs.fillStringlist(sPref_Hotkeys_Keys, _hotkeys_keys_stringlist);
    MainSession.Prefs.fillStringlist(sPref_Hotkeys_Text, _hotkeys_text_stringlist);


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

    tbMsgOutToolbar.Visible := MainSession.Prefs.getBool('chat_toolbar');

    _session_chat_toolbar_callback := MainSession.RegisterCallback(OnSessionCallback, '/session/prefs');
    _session_close_all_callback := MainSession.RegisterCallback(OnSessionCallback, '/session/close-all-windows');
end;

{---------------------------------------}
procedure TfrmBaseChat.OnSessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/prefs') then begin
        tbMsgOutToolbar.Visible := MainSession.Prefs.getBool('chat_toolbar');
        _hotkeys_keys_stringlist.Clear();
        _hotkeys_text_stringlist.Clear();
        MainSession.Prefs.fillStringlist('hotkeys_keys', _hotkeys_keys_stringlist);
        MainSession.Prefs.fillStringlist('hotkeys_text', _hotkeys_text_stringlist);
    end
    else if (event = '/session/close-all-windows') then begin
        Self.Close();
        Application.ProcessMessages();
    end;
end;

{---------------------------------------}
procedure TfrmBaseChat.FormDestroy(Sender: TObject);
begin
    _hotkey_menu_items.Free();
    _hotkeys_keys_stringlist.Free();
    _hotkeys_text_stringlist.Free();

    MainSession.UnRegisterCallback(_session_chat_toolbar_callback);
    MainSession.UnRegisterCallback(_session_close_all_callback);
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

procedure TfrmBaseChat.Customize1Click(Sender: TObject);
begin
    Prefs.StartPrefs(pref_hotkeys);
end;

{---------------------------------------}
procedure TfrmBaseChat.BoldClick(Sender: TObject);
begin
  inherited;

  if (Length(MsgOut.SelText) = 0) then
    MsgOut.SelText := '*'
  else
    MsgOut.SelText := '*' + MsgOut.SelText + '*';

end;

procedure TfrmBaseChat.ChatToolbarButtonHotkeysClick(Sender: TObject);
var
    i: integer;
    m: TTntMenuItem;
    cp: TPoint;
begin
    // cleanup old items
    for i := 0 to _hotkey_menu_items.Count - 1 do begin
        if (_hotkey_menu_items.Objects[i] <> nil) then begin
            popHotkeys.Items.Delete(0);
            _hotkey_menu_items.Objects[i] := nil;
        end;
    end;
    _hotkey_menu_items.Clear();
    _hotkeys_keys_stringlist.Clear();
    _hotkeys_text_stringlist.Clear();

    // get the strings from prefs
    MainSession.Prefs.fillStringlist(sPref_Hotkeys_Keys, _hotkeys_keys_stringlist);
    MainSession.Prefs.fillStringlist(sPref_Hotkeys_Text, _hotkeys_text_stringlist);

    // Should the button be displayed.
    if (_hotkeys_keys_stringlist.Count > 0) then begin
        // add strings to popup
        for i := _hotkeys_keys_stringlist.Count - 1 downto 0 do begin
            m := TTntMenuItem.Create(Self);
            m.Caption := _hotkeys_text_stringlist.Strings[i] + Tabulator
                        + _hotkeys_keys_stringlist.Strings[i];
            m.OnClick := Self.OnHotkeysClick;
            popHotkeys.Items.Insert(0, m);
            _hotkey_menu_items.AddObject(m.Caption, m);
        end;
    end;

    // show popup
    GetCursorPos(cp);
    popHotkeys.Popup(cp.x, cp.y);
end;

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

procedure TfrmBaseChat.ItalicsClick(Sender: TObject);
begin
  inherited;

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


procedure TfrmBaseChat.UnderlineClick(Sender: TObject);
begin
  inherited;

  if (Length(MsgOut.SelText) = 0) then
    MsgOut.SelText := '_'
  else
    MsgOut.SelText := '_' + MsgOut.SelText + '_';

end;

{---------------------------------------}
function TfrmBaseChat.getMsgList(): TfBaseMsgList;
begin
    Result := TfBaseMsgList(_msgframe);
end;

{
    Event fired when docking is complete.

    Docked property will be true, tabsheet will be assigned. This event
    is fired after all other docking events are complete.
}
procedure TfrmBaseChat.OnDocked();
begin
    inherited;
    MsgList.refresh();
end;

{
    Event fired when a float (undock) is complete.

    Docked property will be false, tabsheet will be nil. This event
    is fired after all other floating events are complete.
}
procedure TfrmBaseChat.OnFloat();
begin
    inherited;
    MsgList.refresh();
end;

procedure TfrmBaseChat.OnHotkeysClick(Sender: TObject);
var
    idx: integer;
begin
    idx := _hotkey_menu_items.IndexOfObject(Sender);
    if (idx <> -1) then begin
        MsgOut.SelText := _hotkeys_text_stringlist.Strings[
                                    _hotkeys_text_stringlist.Count - 1 - idx];
    end;
end;

end.

