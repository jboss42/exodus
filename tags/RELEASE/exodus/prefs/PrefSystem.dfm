inherited frmPrefSystem: TfrmPrefSystem
  Left = 259
  Top = 156
  Caption = 'frmPrefSystem'
  ClientHeight = 384
  ClientWidth = 307
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object lblLang: TTntLabel [0]
    Left = 8
    Top = 186
    Width = 133
    Height = 13
    Caption = 'Exodus language file to use:'
  end
  object lblLangScan: TTntLabel [1]
    Left = 30
    Top = 226
    Width = 130
    Height = 13
    Cursor = crHandPoint
    Caption = 'Scan for language catalogs'
    OnClick = lblLangScanClick
  end
  object lblDefaultNick: TTntLabel [2]
    Left = 8
    Top = 251
    Width = 111
    Height = 13
    Caption = 'My default nickname is:'
  end
  inherited pnlHeader: TTntPanel
    Width = 307
    Caption = 'System Options'
    TabOrder = 12
  end
  object chkAutoUpdate: TTntCheckBox
    Left = 8
    Top = 161
    Width = 185
    Height = 17
    Caption = 'Check for updates automatically'
    TabOrder = 7
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
    TabOrder = 0
  end
  object chkCloseMin: TTntCheckBox
    Left = 8
    Top = 123
    Width = 233
    Height = 17
    Caption = 'Close button minimizes to the tray'
    TabOrder = 5
  end
  object chkAutoStart: TTntCheckBox
    Left = 8
    Top = 50
    Width = 233
    Height = 17
    Caption = 'Run Exodus when windows starts'
    TabOrder = 1
  end
  object chkOnTop: TTntCheckBox
    Left = 0
    Top = 352
    Width = 169
    Height = 17
    Caption = 'Exodus is always on top'
    TabOrder = 11
    Visible = False
  end
  object chkToolbox: TTntCheckBox
    Left = 8
    Top = 105
    Width = 217
    Height = 17
    Caption = 'Small Titlebar for Exodus window'
    TabOrder = 4
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
    TabOrder = 6
  end
  object chkStartMin: TTntCheckBox
    Left = 8
    Top = 86
    Width = 225
    Height = 17
    Caption = 'Start minimized to the system tray'
    TabOrder = 3
  end
  object cboLocale: TTntComboBox
    Left = 29
    Top = 202
    Width = 188
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 9
    Items.WideStrings = (
      'English (American)')
  end
  object txtDefaultNick: TTntEdit
    Left = 29
    Top = 267
    Width = 188
    Height = 21
    TabOrder = 10
  end
end
