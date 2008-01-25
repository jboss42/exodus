unit PrefDisplay;
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
  TntStdCtrls, TntExtCtrls, TntComCtrls, ExGroupBox, TntForms, ExFrame,
  ExBrandPanel, ExNumericEdit;

type
  TfrmPrefDisplay = class(TfrmPrefPanel)
    FontDialog1: TFontDialog;
    pnlContainer: TExBrandPanel;
    gbContactList: TExGroupBox;
    gbActivityWindow: TExGroupBox;
    gbOtherPrefs: TExGroupBox;
    chkRTEnabled: TTntCheckBox;
    gbAdvancedPrefs: TExGroupBox;
    pnlAdvancedLeft: TExBrandPanel;
    gbRTIncludes: TExGroupBox;
    chkAllowFontFamily: TTntCheckBox;
    chkAllowFontSize: TTntCheckBox;
    chkAllowFontColor: TTntCheckBox;
    pnlTimeStamp: TExBrandPanel;
    chkTimestamp: TTntCheckBox;
    lblTimestampFmt: TTntLabel;
    txtTimestampFmt: TTntComboBox;
    chkShowPriority: TTntCheckBox;
    chkChatAvatars: TTntCheckBox;
    pnlSnapTo: TExBrandPanel;
    chkSnap: TTntCheckBox;
    trkSnap: TTrackBar;
    txtSnap: TExNumericEdit;
    gbChatOptions: TExGroupBox;
    chkBusy: TTntCheckBox;
    chkEscClose: TTntCheckBox;
    pnlChatHotkey: TExBrandPanel;
    lblClose: TTntLabel;
    txtCloseHotkey: THotKey;
    pnlChatMemory: TExBrandPanel;
    lblMem1: TTntLabel;
    trkChatMemory: TTrackBar;
    txtChatMemory: TExNumericEdit;
    pnlEmoticons: TExBrandPanel;
    chkEmoticons: TTntCheckBox;
    btnEmoSettings: TTntButton;
    lblRosterBG: TTntLabel;
    cbRosterBG: TColorBox;
    lblRosterFG: TTntLabel;
    cbRosterFont: TColorBox;
    btnRosterFont: TTntButton;
    colorRoster: TTntTreeView;
    lblRosterPreview: TTntLabel;
    lblChatPreview: TTntLabel;
    colorChat: TExRichEdit;
    Label5: TTntLabel;
    lblChatBG: TTntLabel;
    cbChatBG: TColorBox;
    lblChatWindowElement: TTntLabel;
    cboChatElement: TTntComboBox;
    btnChatFont: TTntButton;
    cbChatFont: TColorBox;
    lblChatFG: TTntLabel;
    procedure btnEmoSettingsClick(Sender: TObject);
    procedure chkEmoticonsClick(Sender: TObject);
    procedure txtChatMemoryChange(Sender: TObject);
    procedure trkChatMemoryChange(Sender: TObject);
    procedure txtSnapChange(Sender: TObject);
    procedure trkSnapChange(Sender: TObject);
    procedure chkSnapClick(Sender: TObject);
    procedure btnRosterFontClick(Sender: TObject);
    procedure cbChatFontChange(Sender: TObject);
    procedure cbChatBGChange(Sender: TObject);
    procedure cbRosterFontChange(Sender: TObject);
    procedure cbRosterBGChange(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboMsgListChange(Sender: TObject);
    procedure colorChatSelectionChange(Sender: TObject);
    procedure colorChatMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkRTEnabledClick(Sender: TObject);
    procedure chkAllowFontFamilyClick(Sender: TObject);
    procedure cboChatElementChange(Sender: TObject);
  private
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

    function getChatElementSelection(): WideString;
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;


const
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
    Unicode,
    PrefEmoteDlg,
    JabberUtils, ExUtils,  GnuGetText, JabberMsg, MsgDisplay, Session, Dateutils, TypInfo;

{---------------------------------------}
procedure TfrmPrefDisplay.LoadPrefs();
var
    n: TTntTreeNode;
    s: TPrefState;
    tstr: WideString;
    date_time_formats: TWideStringList;
begin
    cboChatElement.AddItem(sActionText, nil);
    cboChatElement.AddItem(sMessageLabelMe, nil);
    cboChatElement.AddItem(sMessageLabelOthers, nil);
    cboChatElement.AddItem(sMessagePriority, nil);
    cboChatElement.AddItem(sMessageText, nil);
    cboChatElement.AddItem(sSystemMessages, nil);
    cboChatElement.AddItem(sTimestamp, nil);

    tstr := MainSession.Prefs.getString('richtext_ignored_font_styles');
    _lastAllowFont := Pos('font-family;', tstr) = 0;
    _lastAllowSize := Pos('font-size;', tstr) = 0;
    _lastAllowColor := Pos('color;', tstr) = 0;

    inherited; //inherited will set rtenabled, which will end up using _last* vars

    date_time_formats := TWideStringList.Create;
    MainSession.Prefs.fillStringlist('date_time_formats', date_time_formats);
    if (date_time_formats.Count > 0) then begin
       AssignTntStrings(date_time_formats, txtTimestampFmt.Items);
    end;
    date_time_formats.free();



    n := colorRoster.Items.AddChild(nil, _('Sample Group'));
    colorRoster.Items.AddChild(n, _('Peter M.'));
    colorRoster.Items.AddChild(n, _('Cowboy Neal'));

    //hide/disable entire contact or activity groups if needed
    s := GetPrefState('roster_font_name');
    gbContactList.Visible:= (s <> psInvisible);
    gbContactList.CanShow := (s <> psInvisible);
    gbContactList.Enabled := (s <> psReadOnly);
    gbContactList.CanEnabled := (s <> psReadOnly);

    s := GetPrefState('font_name');
    gbActivityWindow.Visible:= (s <> psInvisible);
    gbActivityWindow.CanShow := (s <> psInvisible);
    gbActivityWindow.Enabled := (s <> psReadOnly);
    gbActivityWindow.CanEnabled := (s <> psReadOnly);
    
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

        btnChatFont.Enabled := true;
        cbChatBG.Selected := TColor(_color_bg);
        cbChatFont.Selected := TColor(_font_color);

        //don't show font props if rt is disabl;ed and locked down
        s := PrefController.getPrefState('richtext_enabled');
        if ((not GetBool('richtext_enabled')) and
           ((s = psInvisible) or ( s = psReadOnly))) then begin
            chkAllowFontFamily.visible := false;
            chkAllowFontSize.visible := false;
            chkAllowFontColor.visible := false;
        end
        else loadAllowedFontProps();

        cbRosterBG.Selected := _roster_bg;
        cbRosterFont.Selected := _roster_font_color;
        
        chkShowPriority.Visible := getBool('branding_priority_notifications');
    end;
//    colorChatSelectionChange(nil);
    cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sMessageText);
    cboChatElement.Text := sMessageText;
    cboChatElementChange(nil);

    trkSnap.Visible := chkSnap.Visible;
    txtSnap.Visible := chkSnap.Visible;
    if (chkSnap.Visible) then
      chkSnapClick(Self);

    s := GetPrefState('custom_icondefs');
    btnEmoSettings.Visible := ((s <> psInvisible) and chkEmoticons.Visible);
    btnEmoSettings.enabled := ((s <> psReadOnly) and chkEmoticons.enabled);

    pnlContainer.captureChildStates();
    btnEmoSettings.Enabled := btnEmoSettings.Enabled and chkEmoticons.Checked;
    pnlContainer.checkAutoHide();
end;

{---------------------------------------}
procedure TfrmPrefDisplay.SavePrefs();
var
    tstr: WideString;
begin
    if (Trim(txtTimestampFmt.Text) <> '') then
       if (txtTimestampFmt.Items.IndexOf(txtTimestampFmt.Text) < 0) then
         txtTimestampFmt.Items.Add(txtTimestampFmt.Text);
    MainSession.Prefs.setStringList('date_time_formats', txtTimestampFmt.Items);

    inherited;
    with MainSession.prefs do begin
        setInt('color_me', _color_me);
        setInt('color_other', _color_other);
        setInt('color_action', _color_action);
        setInt('color_server', _color_server);
        setInt('font_color', _font_color);
        setInt('color_time', _color_time);
        setInt('color_priority', _color_priority);
        setInt('color_bg', _color_bg);

        setInt('roster_bg', _roster_bg);
        setInt('roster_font_color', _roster_font_color);
        tstr := ' ';
        if (not _lastAllowFont) then
            tstr := tstr + 'font-family;';
        if (not _lastAllowSize) then
            tstr := tstr + 'font-size;';
        if (not _lastAllowColor) then
            tstr := tstr + 'color;';
        setString('richtext_ignored_font_styles', tstr);


        setString('roster_font_name', colorRoster.Font.Name);
        setInt('roster_font_charset', colorRoster.Font.Charset);
        setInt('roster_font_size', colorRoster.Font.Size);
        setBool('roster_font_bold', (fsBold in colorRoster.Font.Style));
        setBool('roster_font_italic', (fsItalic in colorRoster.Font.Style));
        setBool('roster_font_underline', (fsUnderline in colorRoster.Font.Style));
        
        setString('font_name', colorChat.Font.Name);
        setInt('font_charset', colorChat.Font.Charset);
        setInt('font_size', colorChat.Font.Size);
        setBool('font_bold', (fsBold in colorChat.Font.Style));
        setBool('font_italic', (fsItalic in colorChat.Font.Style));
        setBool('font_underline', (fsUnderline in colorChat.Font.Style));
    end;

end;

procedure TfrmPrefDisplay.trkChatMemoryChange(Sender: TObject);
begin
    inherited;
    txtChatMemory.Text := IntToStr(trkChatMemory.Position);
end;

procedure TfrmPrefDisplay.trkSnapChange(Sender: TObject);
begin
    inherited;
    txtSnap.Text := IntToStr(trkSnap.Position);
end;

procedure TfrmPrefDisplay.txtChatMemoryChange(Sender: TObject);
begin
    inherited;
    try
        trkChatMemory.Position := StrToInt(txtChatMemory.Text);
    except
    end;
end;

procedure TfrmPrefDisplay.txtSnapChange(Sender: TObject);
begin
    inherited;
    try
        trkSnap.Position := StrToInt(txtSnap.Text);
    except
    end;
end;

procedure TfrmPrefDisplay.loadAllowedFontProps();
var
    s: TprefState;
begin
    if (chkRTEnabled.Checked) then begin
        s := PrefController.getPrefState('richtext_ignored_font_styles');

        chkAllowFontFamily.visible := (s <> psInvisible);
        chkAllowFontFamily.enabled := (s <> psReadOnly);
        chkAllowFontSize.visible := (s <> psInvisible);
        chkAllowFontSize.enabled := (s <> psReadOnly);
        chkAllowFontColor.visible := (s <> psInvisible);
        chkAllowFontColor.enabled := (s <> psReadOnly);

        chkAllowFontFamily.Checked := _lastAllowFont;
        chkAllowFontSize.Checked := _lastAllowSize;
        chkAllowFontColor.Checked := _lastAllowColor;
    end
    else begin
        chkAllowFontFamily.enabled := false;
        chkAllowFontSize.enabled := false;
        chkAllowFontColor.enabled := false;
        chkAllowFontFamily.Checked := false;
        chkAllowFontSize.Checked := false;
        chkAllowFontColor.Checked := false;
    end;
end;


{---------------------------------------}
procedure TfrmPrefDisplay.btnEmoSettingsClick(Sender: TObject);
var
    tdlg: TfrmPrefEmoteDlg;
begin
    inherited;
    tdlg := TfrmPrefEmoteDlg.Create(Self);
    tdlg.ShowModal();
    tdlg.Free();
end;

procedure TfrmPrefDisplay.btnFontClick(Sender: TObject);
begin
  inherited;
    // Change the roster font
    with FontDialog1 do begin
        Font.Assign(colorChat.Font);

        if Execute then begin
            colorChat.Font.Assign(Font);
            redrawChat();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmPrefDisplay.redrawChat();
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
procedure TfrmPrefDisplay.FormCreate(Sender: TObject);
begin

    inherited;

    AssignUnicodeFont(Self);
end;

{---------------------------------------}
procedure TfrmPrefDisplay.btnRosterFontClick(Sender: TObject);
begin
  inherited;
    with FontDialog1 do begin
        Font.Assign(colorRoster.Font);
        if Execute then begin
            colorRoster.Font.Assign(Font);
        end;
    end;
end;

procedure TfrmPrefDisplay.cbChatBGChange(Sender: TObject);
begin
    inherited;
    _color_bg := Integer(cbChatBG.Selected);
    colorChat.Color := cbChatBG.Selected;
    redrawChat();
end;

procedure TfrmPrefDisplay.cbChatFontChange(Sender: TObject);
var
    currElement: widestring;
begin
    inherited;
    // change the font color
    currElement := getChatElementSelection();
    if (currElement = 'color_me') then begin
        _color_me := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_other') then begin
        _color_other := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_action') then begin
        _color_action := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_server') then begin
        _color_server := integer(cbChatFont.Selected);
    end
    else if (currElement = 'font_color') then begin
        _font_color := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_time') then begin
        _color_time := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_priority') then begin
        _color_priority := integer(cbChatFont.Selected);
    end;
    redrawChat();
end;

function TfrmPrefDisplay.getChatElementSelection(): WideString;
var
    index: integer;
begin
    Result := '';
    index := cboChatElement.ItemIndex;
    if (index = cboChatElement.Items.IndexOf(sTimestamp)) then begin
        Result := 'color_time';
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageLabelMe)) then begin
        // on <pgm>, color-me
        Result := 'color_me';
    end
    else if(index = cboChatElement.Items.IndexOf(sMessagePriority)) then begin
        // on <pgm>, color-me
        Result := 'color_priority';
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageLabelOthers)) then begin
        Result := 'color_other';
    end
    else if(index = cboChatElement.Items.IndexOf(sActionText)) then begin
        Result := 'color_action';
    end
    else if(index = cboChatElement.Items.IndexOf(sSystemMessages)) then begin
        Result := 'color_server';
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageText)) then begin
        // normal window, font_color
       Result := 'font_color';
    end;
end;

procedure TfrmPrefDisplay.cboChatElementChange(Sender: TObject);
var
    index: integer;
begin
  inherited;

    index := cboChatElement.ItemIndex;
    btnChatFont.enabled := false;
    if (index = cboChatElement.Items.IndexOf(sTimestamp)) then begin
        cbChatFont.Selected := TColor(_color_time);
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageLabelMe)) then begin
        // on <pgm>, color-me
        cbChatFont.Selected := TColor(_color_me);
    end
    else if(index = cboChatElement.Items.IndexOf(sMessagePriority)) then begin
        // on <pgm>, color-me
        cbChatFont.Selected := TColor(_color_priority);
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageLabelOthers)) then begin
        cbChatFont.Selected := TColor(_color_other);
    end
    else if(index = cboChatElement.Items.IndexOf(sActionText)) then begin
        cbChatFont.Selected := TColor(_color_action);
    end
    else if(index = cboChatElement.Items.IndexOf(sSystemMessages)) then begin
        cbChatFont.Selected := TColor(_color_server);
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageText)) then begin
        // normal window, font_color
       cbChatFont.Selected := TColor(_font_color);
       btnChatFont.enabled := true;
    end;
end;

procedure TfrmPrefDisplay.cboMsgListChange(Sender: TObject);
var
    idx: integer;
begin
  inherited;
    // When we use IE, disable the color & font stuff
    // idx := cboMsgList.ItemIndex;
    idx := 0;

    // Richedit stuff
    colorChat.Enabled := (idx = 0);
//    cbChatBG.Enabled := (idx = 0);
//    cbChatFont.Enabled := (idx = 0);
    btnChatFont.Enabled := (idx = 0);

    // IE stuff
    {
    cboIEStylesheet.Enabled := (idx = 1);
    btnCSSBrowse.Enabled := (idx = 1);
    btnCSSEdit.Enabled := (idx = 1);
    }
end;

procedure TfrmPrefDisplay.cbRosterBGChange(Sender: TObject);
begin
  inherited;
  _roster_bg := Integer(cbRosterBG.Selected);
  colorRoster.Color := cbRosterBG.Selected;
end;

procedure TfrmPrefDisplay.cbRosterFontChange(Sender: TObject);
begin
    inherited;
    _roster_font_color := Integer(cbRosterFont.Selected);
    colorRoster.Font.Color := cbRosterFont.Selected;
end;

procedure TfrmPrefDisplay.chkAllowFontFamilyClick(Sender: TObject);
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

procedure TfrmPrefDisplay.chkEmoticonsClick(Sender: TObject);
begin
    inherited;
    if (btnEmoSettings.Visible) then begin
        btnEmoSettings.Enabled := chkEmoticons.Checked and
                                  (GetPrefState('custom_icondefs') <> psReadOnly);
    end;
end;

procedure TfrmPrefDisplay.chkRTEnabledClick(Sender: TObject);
begin
    inherited;
    loadAllowedFontProps();
end;

procedure TfrmPrefDisplay.chkSnapClick(Sender: TObject);
begin
    inherited;
    txtSnap.Enabled := chkSnap.Checked;
    trkSnap.Enabled := chkSnap.Checked;
end;

{---------------------------------------}
procedure TfrmPrefDisplay.colorChatMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
    // find the "thing" that we clicked on in the window..
//    lblChatWindowElement.Enabled := true;
//    cboChatElement.Enabled := true;
//    cbChatBG.Enabled := true;
//    cbChatFont.Enabled := true;

    btnChatFont.Enabled := false;
    cbChatBG.Selected := TColor(_color_bg);
    cbChatFont.Selected := TColor(_font_color);
    colorChatSelectionChange(nil);
end;

{---------------------------------------}
procedure TfrmPrefDisplay.colorChatSelectionChange(Sender: TObject);
var
    start: integer;
    idx: integer;
//    priorityUsed: boolean;
begin
    inherited;
//    priorityUsed := MainSession.Prefs.getBool('show_priority');
    // Select the chat window
    btnChatFont.Enabled := false;
    cbChatBG.Selected := TColor(_color_bg);

    start := colorChat.SelStart;

    for idx := 0 to Length(_time_ranges) - 1 do begin
      if ((start >= _time_ranges[idx].Min) and (start <= _time_ranges[idx].Max)) then
        begin
          cbChatFont.Selected := TColor(_color_time);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sTimestamp);
          exit;
        end;
    end;

    for idx := 0 to Length(_me_ranges) - 1 do begin
      if ((start >= _me_ranges[idx].Min) and (start <= _me_ranges[idx].Max)) then
        begin
          // on <pgm>, color-me
          cbChatFont.Selected := TColor(_color_me);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sMessageLabelMe);
          exit;
        end;
    end;

    for idx := 0 to Length(_priority_ranges) - 1 do begin
      if ((start >= _priority_ranges[idx].Min) and (start <= _priority_ranges[idx].Max)) then
        begin
          // on <pgm>, color-me
          cbChatFont.Selected := TColor(_color_priority);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sMessagePriority);
          exit;
        end;
     end;


    for idx := 0 to Length(_other_ranges) - 1 do begin
      if ((start >= _other_ranges[idx].Min) and (start <= _other_ranges[idx].Max)) then
        begin
          cbChatFont.Selected := TColor(_color_other);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sMessageLabelOthers);
          exit;
        end;
    end;

    for idx := 0 to Length(_action_ranges) - 1 do begin
      if ((start >= _action_ranges[idx].Min) and (start <= _action_ranges[idx].Max)) then
        begin
          cbChatFont.Selected := TColor(_color_action);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sActionText);
          exit;
        end;
    end;

    for idx := 0 to Length(_server_ranges) - 1 do begin
      if ((start >= _server_ranges[idx].Min) and (start <= _server_ranges[idx].Max)) then
        begin
          cbChatFont.Selected := TColor(_color_server);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sSystemMessages);
          exit;
        end;
    end;

    // normal window, font_color
   cbChatFont.Selected := TColor(_font_color);
   btnChatFont.Enabled := true;
   cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sMessageText);
end;

end.
