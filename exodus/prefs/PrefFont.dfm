inherited frmPrefFont: TfrmPrefFont
  Left = 320
  Top = 256
  Caption = 'frmPrefFont'
  ClientHeight = 401
  ClientWidth = 511
  OldCreateOrder = True
  ShowHint = True
  ExplicitWidth = 523
  ExplicitHeight = 413
  PixelsPerInch = 96
  TextHeight = 13
  object lblRoster: TTntLabel [0]
    Left = 8
    Top = 56
    Width = 98
    Height = 13
    Caption = 'Contact List Window'
  end
  object lblChat: TTntLabel [1]
    Left = 150
    Top = 56
    Width = 69
    Height = 13
    Caption = 'Chat Windows'
  end
  object lblBackgroundColor: TTntLabel [2]
    Left = 8
    Top = 208
    Width = 88
    Height = 13
    Caption = 'Background Color:'
    Enabled = False
  end
  object lblFontColor: TTntLabel [3]
    Left = 8
    Top = 236
    Width = 51
    Height = 13
    Caption = 'Font Color:'
    Enabled = False
  end
  object Label5: TTntLabel [4]
    Left = 8
    Top = 32
    Width = 283
    Height = 13
    Caption = 'Click on the appropriate font or window to change elements.'
  end
  object lblColor: TTntLabel [5]
    Left = 8
    Top = 161
    Width = 69
    Height = 13
    Caption = 'Element Name'
  end
  object lblChatWindowElement: TTntLabel [6]
    Left = 8
    Top = 181
    Width = 108
    Height = 13
    Caption = 'Chat Window Element:'
    Enabled = False
  end
  object clrBoxBG: TColorBox [7]
    Left = 150
    Top = 205
    Width = 170
    Height = 22
    DefaultColorColor = clBlue
    Selected = clBlue
    Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
    DropDownCount = 12
    Enabled = False
    ItemHeight = 16
    TabOrder = 2
    OnChange = clrBoxBGChange
  end
  object clrBoxFont: TColorBox [8]
    Left = 150
    Top = 233
    Width = 170
    Height = 22
    DefaultColorColor = clBlue
    Selected = clBlue
    Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
    DropDownCount = 12
    Enabled = False
    ItemHeight = 16
    TabOrder = 3
    OnChange = clrBoxFontChange
  end
  object btnFont: TTntButton [9]
    Left = 150
    Top = 260
    Width = 90
    Height = 25
    Caption = 'Change Font'
    TabOrder = 4
    OnClick = btnFontClick
  end
  object colorChat: TExRichEdit [10]
    Left = 150
    Top = 71
    Width = 353
    Height = 89
    AutoURLDetect = adNone
    CustomURLs = <
      item
        Name = 'e-mail'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'http'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'file'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'mailto'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'ftp'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'https'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'gopher'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'nntp'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'prospero'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'telnet'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'news'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'wais'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end>
    LangOptions = [loAutoFont]
    Language = 1033
    ReadOnly = True
    ScrollBars = ssBoth
    ShowSelectionBar = False
    TabOrder = 1
    URLColor = clBlue
    URLCursor = crHandPoint
    WordWrap = False
    OnMouseDown = colorChatMouseDown
    OnSelectionChange = colorChatSelectionChange
    InputFormat = ifRTF
    OutputFormat = ofRTF
    SelectedInOut = False
    PlainRTF = False
    UndoLimit = 0
    AllowInPlace = False
  end
  inherited pnlHeader: TTntPanel
    Width = 511
    Caption = 'Fonts, Colors'
    TabOrder = 5
    ExplicitWidth = 511
  end
  object colorRoster: TTntTreeView
    Left = 8
    Top = 71
    Width = 121
    Height = 89
    BevelWidth = 10
    Indent = 19
    ReadOnly = True
    ShowButtons = False
    ShowLines = False
    TabOrder = 0
    OnMouseDown = colorRosterMouseDown
  end
  object chkRTEnabled: TTntCheckBox
    Left = 8
    Top = 287
    Width = 197
    Height = 17
    Hint = 'Send and display messages with different fonts, colors etc.'
    Caption = 'Use formatted messages'
    TabOrder = 6
    OnClick = chkRTEnabledClick
  end
  object gbAllowedFontStyles: TTntGroupBox
    Left = 8
    Top = 305
    Width = 218
    Height = 85
    Caption = 'Messages may include:'
    Enabled = False
    TabOrder = 7
    object chkAllowFontFamily: TTntCheckBox
      Left = 6
      Top = 18
      Width = 97
      Height = 17
      Caption = 'Multiple fonts'
      TabOrder = 0
      OnClick = chkAllowFontFamilyClick
    end
    object chkAllowFontSize: TTntCheckBox
      Left = 6
      Top = 39
      Width = 116
      Height = 17
      Caption = 'Different sized text'
      TabOrder = 1
      OnClick = chkAllowFontFamilyClick
    end
    object chkAllowFontColor: TTntCheckBox
      Left = 6
      Top = 61
      Width = 127
      Height = 17
      Caption = 'Different colored text'
      TabOrder = 2
      OnClick = chkAllowFontFamilyClick
    end
  end
  object cboChatWindowElement: TTntComboBox
    Left = 150
    Top = 178
    Width = 170
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    TabOrder = 8
    OnChange = cboChatWindowElementChange
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = []
    Left = 301
    Top = 27
  end
  object OpenDialog1: TOpenDialog
    Filter = 'CSS Stylesheets|*.css|All Files|*.*'
    Left = 336
    Top = 28
  end
end
