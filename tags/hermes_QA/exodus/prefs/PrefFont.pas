unit PrefFont;
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
  Dialogs, PrefPanel, StdCtrls, ComCtrls, RichEdit2, ExRichEdit, ExtCtrls,
  TntStdCtrls, TntExtCtrls, TntComCtrls;

type
  TfrmPrefFont = class(TfrmPrefPanel)
    lblRoster: TTntLabel;
    lblChat: TTntLabel;
    lblBackgroundColor: TTntLabel;
    lblFontColor: TTntLabel;
    Label5: TTntLabel;
    clrBoxBG: TColorBox;
    clrBoxFont: TColorBox;
    btnFont: TTntButton;
    colorChat: TExRichEdit;
    FontDialog1: TFontDialog;
    lblColor: TTntLabel;
    colorRoster: TTntTreeView;
    OpenDialog1: TOpenDialog;
    chkRTEnabled: TTntCheckBox;
    gbAllowedFontStyles: TTntGroupBox;
    chkAllowFontFamily: TTntCheckBox;
    chkAllowFontSize: TTntCheckBox;
    chkAllowFontColor: TTntCheckBox;
    lblChatWindowElement: TTntLabel;
    cboChatWindowElement: TTntComboBox;
    procedure btnFontClick(Sender: TObject);
    procedure clrBoxBGChange(Sender: TObject);
    procedure clrBoxFontChange(Sender: TObject);
    procedure colorRosterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure cboMsgListChange(Sender: TObject);
    procedure colorChatSelectionChange(Sender: TObject);
    procedure colorChatMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkRTEnabledClick(Sender: TObject);
    procedure chkAllowFontFamilyClick(Sender: TObject);
    procedure cboChatWindowElementChange(Sender: TObject);
  private
    { Private declarations }
    _clr_control: TControl;
    _clr_font_color: string;
    _clr_font: string;
    _clr_bg: string;
    _color_me: integer;
    _color_other: integer;
    _color_action: integer;
    _color_server: integer;
    _font_color: integer;
    _color_time: integer;
    _color_priority: integer;
    _color_bg: integer;
    _roster_bg: integer;
    _roster_font_color: integer;
    _lastAllowFont: boolean;
    _lastAllowSize: boolean;
    _lastAllowColor: boolean;

    type TRange = record
       Min: Integer;
       Max: Integer;
    end;

    type _ranges = array of TRange;

    var _time_ranges: _ranges;
    var _other_ranges: _ranges;
    var _me_ranges: _ranges;
    var _action_ranges: _ranges;
    var _server_ranges: _ranges;
    var _font_ranges: _ranges;
    var _priority_ranges: _ranges;


    procedure redrawChat();
    procedure loadAllowedFontProps();
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefFont: TfrmPrefFont;

const
    sRosterFontLabel = 'Contact List Window Colors';
    sChatFontLabel = 'Chat Window Colors';
    sActionText = 'Action text';
    sMessageLabelMe = 'Messages from me';
    sMessageLabelOthers = 'Messages from others';
    sMessagePriority = 'Message priority';
    sMessageText = 'Message text';
    sSystemMessages = 'System messages';
    sTimestamp = 'Timestamp';


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.dfm}
uses
    ShellAPI,
    PrefFile,
    PrefController,
    JabberUtils, ExUtils,  GnuGetText, JabberMsg, MsgDisplay, Session, Dateutils, TypInfo;

{---------------------------------------}
procedure TfrmPrefFont.LoadPrefs();
var
    n: TTntTreeNode;
    s: TPrefState;
    tstr: WideString;
begin
    tstr := MainSession.Prefs.getString('richtext_ignored_font_styles');
    _lastAllowFont := Pos('font-family;', tstr) = 0;
    _lastAllowSize := Pos('font-size;', tstr) = 0;
    _lastAllowColor := Pos('color;', tstr) = 0;

    inherited; //ingherited will set rtenabled, which will end up using _last* vars

    n := colorRoster.Items.AddChild(nil, _('Sample Group'));
    colorRoster.Items.AddChild(n, _('Peter M.'));
    colorRoster.Items.AddChild(n, _('Cowboy Neal'));

    with MainSession.Prefs do begin
        _color_me := getInt('color_me');
        _color_other := getInt('color_other');
        _color_action := getInt('color_action');
        _color_server := getInt('color_server');
        _font_color := getInt('font_color');
        _color_time := getInt('color_time');
        _color_priority := getInt('color_priority');
        _color_bg := getInt('color_bg');
        _roster_bg := getInt('roster_bg');
        _roster_font_color := getInt('roster_font_color');

        with colorChat do begin
            Font.Name := getString('font_name');
            Font.Size := getInt('font_size');
            Font.Color := TColor(_font_color);
            Font.Charset := getInt('font_charset');
            if (Font.Charset = 0) then Font.Charset := 1;

            Font.Style := [];
            if (getBool('font_bold')) then Font.Style := Font.Style + [fsBold];
            if (getBool('font_italic')) then Font.Style := Font.Style + [fsItalic];
            if (getBool('font_underline')) then Font.Style := Font.Style + [fsUnderline];
            Color := TColor(_color_bg);
            Self.redrawChat();
        end;

        with colorRoster do begin
            Items[0].Expand(true);
            Color := TColor(_roster_bg);
            Font.Color := TColor(_roster_font_color);
            Font.Name := getString('roster_font_name');
            Font.Size := getInt('roster_font_size');
            Font.Charset := getInt('roster_font_charset');
            if (Font.Charset = 0) then Font.Charset := 1;
            Font.Style := [];
        end;
        lblColor.Caption := _(sRosterFontLabel);
        _clr_font := 'roster_font';
        _clr_font_color := 'roster_font_color';
        _clr_bg := 'roster_bg';
        _clr_control := colorRoster;

        btnFont.Enabled := true;
        clrBoxBG.Selected := TColor(_color_bg);
        clrBoxFont.Selected := TColor(_font_color);

        //don't show font props if rt is disabl;ed and locked down
        s := PrefController.getPrefState('richtext_enabled');
        if ((not GetBool('richtext_enabled')) and ((s = psInvisible) or ( s = psReadOnly))) then begin
            chkAllowFontFamily.visible := false;
            chkAllowFontSize.visible := false;
            chkAllowFontColor.visible := false;
            gbAllowedFontStyles.visible := false;
        end
        else loadAllowedFontProps();
    end;
end;

{---------------------------------------}
procedure TfrmPrefFont.SavePrefs();
var
    tstr: WideString;
begin
    inherited;

    MainSession.Prefs.setInt('color_me', _color_me);
    MainSession.Prefs.setInt('color_other', _color_other);
    MainSession.Prefs.setInt('color_action', _color_action);
    MainSession.Prefs.setInt('color_server', _color_server);
    MainSession.Prefs.setInt('font_color', _font_color);
    MainSession.Prefs.setInt('color_time', _color_time);
    MainSession.Prefs.setInt('color_priority', _color_priority);
    MainSession.Prefs.setInt('color_bg', _color_bg);
    MainSession.Prefs.setInt('roster_bg', _roster_bg);
    MainSession.Prefs.setInt('roster_font_color', _roster_font_color);
    tstr := ' ';
    if (not _lastAllowFont) then
        tstr := tstr + 'font-family;';
    if (not _lastAllowSize) then
        tstr := tstr + 'font-size;';
    if (not _lastAllowColor) then
        tstr := tstr + 'color;';
    MainSession.Prefs.setString('richtext_ignored_font_styles', tstr);
end;

procedure TfrmPrefFont.loadAllowedFontProps();
var
    s: TprefState;
begin
    if (chkRTEnabled.Checked) then begin
        s := PrefController.getPrefState('richtext_ignored_font_styles');

        chkAllowFontFamily.visible := (s <> psInvisible);
        chkAllowFontFamily.enabled := (s <> psInvisible) or (s <> psReadOnly);
        chkAllowFontSize.visible := (s <> psInvisible);
        chkAllowFontSize.enabled := (s <> psInvisible) or (s <> psReadOnly);
        chkAllowFontColor.visible := (s <> psInvisible);
        chkAllowFontColor.enabled := (s <> psInvisible) or (s <> psReadOnly);
        gbAllowedFontStyles.visible := (s <> psInvisible);
        gbAllowedFontStyles.enabled := (s <> psInvisible) or (s <> psReadOnly);
        
        chkAllowFontFamily.Checked := _lastAllowFont;
        chkAllowFontSize.Checked := _lastAllowSize;
        chkAllowFontColor.Checked := _lastAllowColor;
    end
    else begin
        gbAllowedFontStyles.enabled := false;
        chkAllowFontFamily.enabled := false;
        chkAllowFontSize.enabled := false;
        chkAllowFontColor.enabled := false;
        chkAllowFontFamily.Checked := false;
        chkAllowFontSize.Checked := false;
        chkAllowFontColor.Checked := false;
    end;
end;


{---------------------------------------}
procedure TfrmPrefFont.btnFontClick(Sender: TObject);
begin
  inherited;
    // Change the roster font
    with FontDialog1 do begin
        if (_clr_control = colorRoster) then
            Font.Assign(colorRoster.Font)
        else
            Font.Assign(colorChat.Font);

        if Execute then begin
            if (_clr_control = colorRoster) then
                colorRoster.Font.Assign(Font)
            else begin
                colorChat.Font.Assign(Font);
            end;

            with MainSession.prefs do begin
                setString(_clr_font + '_name', Font.Name);
                setInt(_clr_font + '_charset', Font.Charset);
                setInt(_clr_font + '_size', Font.Size);
                setBool(_clr_font + '_bold', (fsBold in Font.Style));
                setBool(_clr_font + '_italic', (fsItalic in Font.Style));
                setBool(_clr_font + '_underline', (fsUnderline in Font.Style));
            end;

            if (_clr_control <> colorRoster) then
                redrawChat();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmPrefFont.redrawChat();
var
    m: TJabberMessage;
    n: TDateTime;
    dl : integer;
    my_nick: WideString;
begin
    SetLength(_time_ranges, 4);
    SetLength(_me_ranges, 1);
    SetLength(_other_ranges, 1);    
    SetLength(_action_ranges, 1);
    SetLength(_server_ranges, 1);
    SetLength(_font_ranges, 1);
    SetLength(_priority_ranges, 2);



    n := Now();
    dl := length(FormatDateTime(MainSession.Prefs.getString('timestamp_format'), n)) + 2;
    my_nick := MainSession.getDisplayUsername();

    with colorChat do begin
        Lines.Clear;

        _time_ranges[0].Min := 0;
        _time_ranges[0].Max := _time_ranges[0].Min + dl - 1;


        m := TJabberMessage.Create();
        with m do begin
            Body := _('Some text from me');
            isMe := true;
            Nick := my_nick;
            Time := n;
            Priority := High;
        end;

        _priority_ranges[0].Min := _time_ranges[0].Max + 1;
        _priority_ranges[0].Max := _priority_ranges[0].Min + length(GetDisplayPriority(m.Priority)) + 2 - 1;
        _me_ranges[0].Min := _priority_ranges[0].Max + 1;
        _me_ranges[0].Max := _me_ranges[0].Min + length(my_nick) + 2 - 1;
        DisplayRTFMsg(colorChat, m, true, _color_time, _color_priority, _color_server, _color_action, _color_me, _color_other, _font_color);
        m.Free();

        _time_ranges[1].Min := Length(WideLines.Text) - WideLines.Count;
        _time_ranges[1].Max :=  _time_ranges[1].Min + dl - 1;


        m := TJabberMessage.Create();
        with m do begin
            Body := _('Some reply text');
            isMe := false;
            Nick := _('Friend');
            Time := n;
            Priority := High;
        end;

        _priority_ranges[1].Min := _time_ranges[1].Max + 1;
        _priority_ranges[1].Max := _priority_ranges[1].Min + length(GetDisplayPriority(m.Priority)) + 2 - 1;
        _other_ranges[0].Min := _priority_ranges[1].Max + 1;
        _other_ranges[0].Max :=  _other_ranges[0].Min + length(_('Friend')) + 2 - 1;
        DisplayRTFMsg(colorChat, m, true, _color_time, _color_priority, _color_server, _color_action, _color_me, _color_other, _font_color);
        m.Free();

        _time_ranges[2].Min := Length(WideLines.Text) - WideLines.Count;
        _time_ranges[2].Max := _time_ranges[2].Min + dl - 1;

        _action_ranges[0].Min := _time_ranges[2].Max + 1;

        m := TJabberMessage.Create();
        with m do begin
            Body := _('/me does action');
            Nick := my_nick;
            Time := n;
        end;
        DisplayRTFMsg(colorChat, m, true, _color_time, _color_priority, _color_server, _color_action, _color_me, _color_other, _font_color);
        m.Free();

        _action_ranges[0].Max := Length(WideLines.Text) - WideLines.Count;
        _time_ranges[3].Min :=_action_ranges[0].Max + 1;
        _time_ranges[3].Max := _time_ranges[3].Min + dl - 1;

        m := TJabberMessage.Create();
        _server_ranges[0].Min := _time_ranges[3].Max + 1;
        with m do begin
            Body := _('Server says something');
            Nick := '';
            Time := n;
        end;
        DisplayRTFMsg(colorChat, m, true, _color_time, _color_priority, _color_server, _color_action, _color_me, _color_other, _font_color);
        _server_ranges[0].Max := Length(WideLines.Text) - WideLines.Count;
        m.Free();
    end;
end;

{---------------------------------------}
procedure TfrmPrefFont.clrBoxBGChange(Sender: TObject);
begin
  inherited;
    // change in the bg color
    if (_clr_control = colorChat) then begin
        _color_bg := Integer(clrBoxBG.Selected);
        colorChat.Color := clrBoxBG.Selected
    end
    else begin
        _roster_bg := Integer(clrBoxBG.Selected);
        colorRoster.Color := clrBoxBG.Selected;
    end;
end;

{---------------------------------------}
procedure TfrmPrefFont.clrBoxFontChange(Sender: TObject);
begin
  inherited;
    // change the font color
    if (_clr_font_color = 'color_me') then begin
        _color_me := integer(clrBoxFont.Selected);
    end
    else if (_clr_font_color = 'color_other') then begin
        _color_other := integer(clrBoxFont.Selected);
    end
    else if (_clr_font_color = 'color_action') then begin
        _color_action := integer(clrBoxFont.Selected);
    end
    else if (_clr_font_color = 'color_server') then begin
        _color_server := integer(clrBoxFont.Selected);
    end
    else if (_clr_font_color = 'font_color') then begin
        _font_color := integer(clrBoxFont.Selected);
    end
    else if (_clr_font_color =  'color_time') then begin
        _color_time := integer(clrBoxFont.Selected);
    end
    else if (_clr_font_color =  'color_priority') then begin
        _color_priority := integer(clrBoxFont.Selected);
    end
    else if(_clr_font_color = 'roster_font_color') then begin
        _roster_font_color := Integer(clrBoxFont.Selected);
    end;

    if (_clr_control = colorChat) then begin
        redrawChat();
    end
    else begin
        colorRoster.Font.Color := clrBoxFont.Selected;
    end;
end;

{---------------------------------------}
procedure TfrmPrefFont.colorRosterMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
    // find the "thing" that we clicked on in the window..
    lblColor.Caption := _(sRosterFontLabel);
    _clr_font := 'roster_font';
    _clr_font_color := 'roster_font_color';
    _clr_bg := 'roster_bg';
    _clr_control := colorRoster;

    btnFont.Enabled := true;
    clrBoxBG.Selected := TColor(_roster_bg);
    clrBoxFont.Selected := TColor(_roster_font_color);
    lblRoster.Font.Style := [fsBold];
    lblChat.Font.Style := [];
    lblChatWindowElement.Enabled := false;
    cboChatWindowElement.Enabled := false;
    lblBackgroundColor.Enabled := true;
    clrBoxBG.Enabled := true;
    lblFontColor.Enabled := true;
    clrBoxFont.Enabled := true
end;

{---------------------------------------}
procedure TfrmPrefFont.FormCreate(Sender: TObject);
begin
  inherited;
    AssignUnicodeFont(lblRoster.Font, 9);
    AssignUnicodeFont(lblChat.Font, 9);
    AssignUnicodeFont(lblColor.Font, 9);
    lblColor.Font.Style := [fsBold];

    cboChatWindowElement.AddItem(sActionText, nil);
    cboChatWindowElement.AddItem(sMessageLabelMe, nil);
    cboChatWindowElement.AddItem(sMessageLabelOthers, nil);
    cboChatWindowElement.AddItem(sMessagePriority, nil);
    cboChatWindowElement.AddItem(sMessageText, nil);
    cboChatWindowElement.AddItem(sSystemMessages, nil);
    cboChatWindowElement.AddItem(sTimestamp, nil);
end;

{---------------------------------------}
procedure TfrmPrefFont.cboChatWindowElementChange(Sender: TObject);
var
    index: integer;
begin
  inherited;

    index := cboChatWindowElement.ItemIndex;

    if (index = cboChatWindowElement.Items.IndexOf(sTimestamp)) then begin
        _clr_font_color := 'color_time';
        _clr_font := '';
        clrBoxFont.Selected := TColor(_color_time);
        btnFont.Enabled := (_clr_font <> '');
    end
    else if(index = cboChatWindowElement.Items.IndexOf(sMessageLabelMe)) then begin
        // on <pgm>, color-me
        _clr_font_color := 'color_me';
        _clr_font := '';
        clrBoxFont.Selected := TColor(_color_me);
        btnFont.Enabled := (_clr_font <> '');
    end
    else if(index = cboChatWindowElement.Items.IndexOf(sMessagePriority)) then begin
        // on <pgm>, color-me
        _clr_font_color := 'color_priority';
        _clr_font := '';
        clrBoxFont.Selected := TColor(_color_priority);
        btnFont.Enabled := (_clr_font <> '');
    end
    else if(index = cboChatWindowElement.Items.IndexOf(sMessageLabelOthers)) then begin
        _clr_font_color := 'color_other';
        _clr_font := '';
        clrBoxFont.Selected := TColor(_color_other);
        btnFont.Enabled := (_clr_font <> '');
    end
    else if(index = cboChatWindowElement.Items.IndexOf(sActionText)) then begin
        _clr_font_color := 'color_action';
        _clr_font := '';
        clrBoxFont.Selected := TColor(_color_action);
        btnFont.Enabled := (_clr_font <> '');
    end
    else if(index = cboChatWindowElement.Items.IndexOf(sSystemMessages)) then begin
        _clr_font_color := 'color_server';
        _clr_font := '';
        clrBoxFont.Selected := TColor(_color_server);
        btnFont.Enabled := (_clr_font <> '');
    end
    else if(index = cboChatWindowElement.Items.IndexOf(sMessageText)) then begin
        // normal window, font_color
       _clr_font_color := 'font_color';
       _clr_font := 'font';
       clrBoxFont.Selected := TColor(_font_color);
       btnFont.Enabled := (_clr_font <> '');
    end;
end;

procedure TfrmPrefFont.cboMsgListChange(Sender: TObject);
var
    idx: integer;
begin
  inherited;
    // When we use IE, disable the color & font stuff
    // idx := cboMsgList.ItemIndex;
    idx := 0;

    // Richedit stuff
    colorChat.Enabled := (idx = 0);
    clrBoxBG.Enabled := (idx = 0);
    clrBoxFont.Enabled := (idx = 0);
    btnFont.Enabled := (idx = 0);

    // IE stuff
    {
    cboIEStylesheet.Enabled := (idx = 1);
    btnCSSBrowse.Enabled := (idx = 1);
    btnCSSEdit.Enabled := (idx = 1);
    }
end;

procedure TfrmPrefFont.chkAllowFontFamilyClick(Sender: TObject);
begin
    inherited;
    if (sender.InheritsFrom(TWinControl) and (TWinControl(Sender).Enabled)) then begin
        if (sender = chkAllowFontFamily) then
            _lastAllowFont := chkAllowFontFamily.Checked
        else if (sender = chkAllowFontSize) then
            _lastAllowSize := chkAllowFontSize.Checked
        else if (sender = chkAllowFontColor) then
            _lastAllowColor := chkAllowFontColor.Checked;
    end;
end;

procedure TfrmPrefFont.chkRTEnabledClick(Sender: TObject);
begin
    inherited;
    loadAllowedFontProps();
end;

{---------------------------------------}
procedure TfrmPrefFont.colorChatMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
    // find the "thing" that we clicked on in the window..
    lblColor.Caption := _(sChatFontLabel);
    lblRoster.Font.Style := [];
    lblChat.Font.Style := [fsBold];
    lblChatWindowElement.Enabled := true;
    cboChatWindowElement.Enabled := true;
    lblBackgroundColor.Enabled := true;
    clrBoxBG.Enabled := true;
    lblFontColor.Enabled := true;
    clrBoxFont.Enabled := true;

    btnFont.Enabled := false;
    clrBoxBG.Selected := TColor(_color_bg);
    clrBoxFont.Selected := TColor(_font_color);
    _clr_bg := 'color_bg';
    _clr_control := colorChat;
    colorChatSelectionChange(nil);
end;

{---------------------------------------}
procedure TfrmPrefFont.colorChatSelectionChange(Sender: TObject);
var
    start: integer;
    idx: integer;
//    priorityUsed: boolean;
begin
    inherited;
//    priorityUsed := MainSession.Prefs.getBool('show_priority');
    // Select the chat window
    lblColor.Caption := _(sChatFontLabel);
    _clr_control := colorChat;
    _clr_bg := 'color_bg';
    clrBoxBG.Selected := TColor(_color_bg);

    start := colorChat.SelStart;

    for idx := 0 to Length(_time_ranges) - 1 do begin
      if ((start >= _time_ranges[idx].Min) and (start <= _time_ranges[idx].Max)) then
        begin
          _clr_font_color := 'color_time';
          _clr_font := '';
          clrBoxFont.Selected := TColor(_color_time);
          btnFont.Enabled := (_clr_font <> '');
          cboChatWindowElement.ItemIndex := cboChatWindowElement.Items.IndexOf(sTimestamp);
          exit;
        end;
    end;

    for idx := 0 to Length(_me_ranges) - 1 do begin
      if ((start >= _me_ranges[idx].Min) and (start <= _me_ranges[idx].Max)) then
        begin
          // on <pgm>, color-me
          _clr_font_color := 'color_me';
          _clr_font := '';
          clrBoxFont.Selected := TColor(_color_me);
          btnFont.Enabled := (_clr_font <> '');
          cboChatWindowElement.ItemIndex := cboChatWindowElement.Items.IndexOf(sMessageLabelMe);
          exit;
        end;
    end;

    for idx := 0 to Length(_priority_ranges) - 1 do begin
      if ((start >= _priority_ranges[idx].Min) and (start <= _priority_ranges[idx].Max)) then
        begin
          // on <pgm>, color-me
          _clr_font_color := 'color_priority';
          _clr_font := '';
          clrBoxFont.Selected := TColor(_color_priority);
          btnFont.Enabled := (_clr_font <> '');
          cboChatWindowElement.ItemIndex := cboChatWindowElement.Items.IndexOf(sMessagePriority);
          exit;
        end;
     end;


    for idx := 0 to Length(_other_ranges) - 1 do begin
      if ((start >= _other_ranges[idx].Min) and (start <= _other_ranges[idx].Max)) then
        begin
          _clr_font_color := 'color_other';
          _clr_font := '';
          clrBoxFont.Selected := TColor(_color_other);
          btnFont.Enabled := (_clr_font <> '');
          cboChatWindowElement.ItemIndex := cboChatWindowElement.Items.IndexOf(sMessageLabelOthers);
          exit;
        end;
    end;

    for idx := 0 to Length(_action_ranges) - 1 do begin
      if ((start >= _action_ranges[idx].Min) and (start <= _action_ranges[idx].Max)) then
        begin
          _clr_font_color := 'color_action';
          _clr_font := '';
          clrBoxFont.Selected := TColor(_color_action);
          btnFont.Enabled := (_clr_font <> '');
          cboChatWindowElement.ItemIndex := cboChatWindowElement.Items.IndexOf(sActionText);
          exit;
        end;
    end;

    for idx := 0 to Length(_server_ranges) - 1 do begin
      if ((start >= _server_ranges[idx].Min) and (start <= _server_ranges[idx].Max)) then
        begin
          _clr_font_color := 'color_server';
          _clr_font := '';
          clrBoxFont.Selected := TColor(_color_server);
          btnFont.Enabled := (_clr_font <> '');
          cboChatWindowElement.ItemIndex := cboChatWindowElement.Items.IndexOf(sSystemMessages);
          exit;
        end;
    end;

    // normal window, font_color
   _clr_font_color := 'font_color';
   _clr_font := 'font';
   clrBoxFont.Selected := TColor(_font_color);
   btnFont.Enabled := (_clr_font <> '');
   cboChatWindowElement.ItemIndex := cboChatWindowElement.Items.IndexOf(sMessageText);
end;

end.
