object frmPrefSystem: TfrmPrefSystem
  Left = 259
  Top = 156
  Width = 327
  Height = 430
  BorderWidth = 6
  Caption = 'frmPrefSystem'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TTntLabel
    Left = 8
    Top = 186
    Width = 133
    Height = 13
    Caption = 'Exodus language file to use:'
  end
  object lblPluginScan: TTntLabel
    Left = 30
    Top = 226
    Width = 130
    Height = 13
    Cursor = crHandPoint
    Caption = 'Scan for language catalogs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblPluginScanClick
  end
  object Label15: TTntLabel
    Left = 8
    Top = 251
    Width = 111
    Height = 13
    Caption = 'My default nickname is:'
  end
  object StaticText4: TTntPanel
    Left = 0
    Top = 0
    Width = 307
    Height = 24
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'System Options'
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
  object chkAutoUpdate: TTntCheckBox
    Left = 8
    Top = 161
    Width = 185
    Height = 17
    Caption = 'Check for updates automatically'
    TabOrder = 1
  end
  object chkDebug: TTntCheckBox
    Left = 8
    Top = 68
    Width = 169
    Height = 17
    Caption = 'Start with Debug visible'
    TabOrder = 2
  end
  object chkAutoLogin: TTntCheckBox
    Left = 8
    Top = 32
    Width = 241
    Height = 17
    Caption = 'Automatically login with last profile'
    TabOrder = 3
  end
  object chkCloseMin: TTntCheckBox
    Left = 8
    Top = 123
    Width = 233
    Height = 17
    Caption = 'Close button minimizes to the tray'
    TabOrder = 4
  end
  object chkAutoStart: TTntCheckBox
    Left = 8
    Top = 50
    Width = 233
    Height = 17
    Caption = 'Run Exodus when windows starts'
    TabOrder = 5
  end
  object chkOnTop: TTntCheckBox
    Left = 0
    Top = 352
    Width = 169
    Height = 17
    Caption = 'Exodus is always on top'
    TabOrder = 6
    Visible = False
  end
  object chkToolbox: TTntCheckBox
    Left = 8
    Top = 105
    Width = 217
    Height = 17
    Caption = 'Small Titlebar for Exodus window'
    TabOrder = 7
  end
  object btnUpdateCheck: TTntButton
    Left = 222
    Top = 157
    Width = 75
    Height = 25
    Caption = 'Check Now'
    TabOrder = 8
    OnClick = btnUpdateCheckClick
    OnMouseUp = btnUpdateCheckMouseUp
  end
  object chkSingleInstance: TTntCheckBox
    Left = 8
    Top = 142
    Width = 209
    Height = 17
    Caption = 'Only allow a single instance of Exodus'
    TabOrder = 9
  end
  object chkStartMin: TTntCheckBox
    Left = 8
    Top = 86
    Width = 225
    Height = 17
    Caption = 'Start minimized to the system tray'
    TabOrder = 10
  end
  object cboLocale: TTntComboBox
    Left = 29
    Top = 202
    Width = 188
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 11
    Items.WideStrings = (
      'English (American)')
  end
  object txtDefaultNick: TTntEdit
    Left = 29
    Top = 267
    Width = 188
    Height = 21
    TabOrder = 12
  end
end
