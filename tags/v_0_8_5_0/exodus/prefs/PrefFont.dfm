inherited frmPrefFont: TfrmPrefFont
  Left = 248
  Top = 329
  Caption = 'frmPrefFont'
  ClientHeight = 349
  ClientWidth = 403
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label22: TLabel
    Left = 8
    Top = 56
    Width = 87
    Height = 13
    Caption = 'Roster Window'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label23: TLabel
    Left = 136
    Top = 56
    Width = 82
    Height = 13
    Caption = 'Chat Windows'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label24: TLabel
    Left = 8
    Top = 186
    Width = 88
    Height = 13
    Caption = 'Background Color:'
  end
  object Label25: TLabel
    Left = 8
    Top = 210
    Width = 51
    Height = 13
    Caption = 'Font Color:'
  end
  object Label5: TLabel
    Left = 8
    Top = 32
    Width = 283
    Height = 13
    Caption = 'Click on the appropriate font or window to change elements.'
  end
  object Bevel2: TBevel
    Left = 0
    Top = 264
    Width = 401
    Height = 4
    Anchors = [akLeft, akTop, akRight]
  end
  object lblColor: TLabel
    Left = 8
    Top = 168
    Width = 82
    Height = 13
    Caption = 'Element Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StaticText3: TStaticText
    Left = 0
    Top = 0
    Width = 403
    Height = 20
    Align = alTop
    Alignment = taCenter
    Caption = 'Font && Color options'
    Color = clHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clCaptionText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    Transparent = False
  end
  object colorRoster: TTreeView
    Left = 8
    Top = 72
    Width = 121
    Height = 90
    Indent = 19
    ReadOnly = True
    ShowButtons = False
    ShowLines = False
    TabOrder = 1
    OnMouseDown = colorRosterMouseDown
    Items.Data = {
      01000000200000001B0000001B00000000000000FFFFFFFF0000000002000000
      0747726F7570203121000000010000000100000000000000FFFFFFFF00000000
      00000000085065746572204D2E24000000000000000000000000000000FFFFFF
      FF00000000000000000B436F77626F79204E65616C}
  end
  object clrBoxBG: TColorBox
    Left = 135
    Top = 183
    Width = 170
    Height = 22
    DefaultColorColor = clBlue
    Selected = clBlue
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
    DropDownCount = 12
    ItemHeight = 16
    TabOrder = 2
    OnChange = clrBoxBGChange
  end
  object clrBoxFont: TColorBox
    Left = 135
    Top = 207
    Width = 170
    Height = 22
    DefaultColorColor = clBlue
    Selected = clBlue
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
    DropDownCount = 12
    ItemHeight = 16
    TabOrder = 3
    OnChange = clrBoxFontChange
  end
  object btnFont: TButton
    Left = 135
    Top = 234
    Width = 90
    Height = 25
    Caption = 'Change Font'
    TabOrder = 4
    OnClick = btnFontClick
  end
  object colorChat: TExRichEdit
    Left = 136
    Top = 72
    Width = 225
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
    TabOrder = 5
    URLColor = clBlue
    URLCursor = crHandPoint
    WordWrap = False
    OnMouseUp = colorChatMouseUp
    InputFormat = ifRTF
    OutputFormat = ofRTF
    SelectedInOut = False
    PlainRTF = False
    UndoLimit = 0
    AllowInPlace = False
  end
  object chkInlineStatus: TCheckBox
    Left = 8
    Top = 275
    Width = 241
    Height = 17
    Caption = 'Show status in the roster: Joe <Meeting>'
    TabOrder = 6
    OnClick = chkInlineStatusClick
  end
  object cboInlineStatus: TColorBox
    Left = 32
    Top = 294
    Width = 201
    Height = 22
    DefaultColorColor = clBlue
    Selected = clBlue
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
    DropDownCount = 12
    ItemHeight = 16
    TabOrder = 7
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
end
