inherited frmPrefDialogs: TfrmPrefDialogs
  Left = 257
  Top = 156
  Caption = 'frmPrefDialogs'
  ClientHeight = 472
  ClientWidth = 361
  OldCreateOrder = True
  ExplicitWidth = 373
  ExplicitHeight = 484
  PixelsPerInch = 120
  TextHeight = 16
  object lblMem1: TTntLabel [0]
    Left = 9
    Top = 245
    Width = 242
    Height = 16
    Caption = 'Minutes to keep chat windows in memory:'
  end
  object lblMem2: TTntLabel [1]
    Left = 9
    Top = 263
    Width = 297
    Height = 16
    Caption = 'Use 0 minutes to destroy chat windows immediately'
  end
  object lblToastDuration: TTntLabel [2]
    Left = 48
    Top = 161
    Width = 148
    Height = 16
    Caption = 'Toast duration (seconds):'
  end
  object lblClose: TTntLabel [3]
    Left = 9
    Top = 364
    Width = 279
    Height = 16
    Caption = 'Use this hotkey sequence to close chat windows:'
  end
  object chkRosterAlpha: TTntCheckBox [4]
    Left = 9
    Top = 40
    Width = 258
    Height = 20
    Caption = 'Use Alpha Blending'
    TabOrder = 8
    OnClick = chkRosterAlphaClick
  end
  object trkRosterAlpha: TTrackBar [5]
    Left = 40
    Top = 69
    Width = 168
    Height = 22
    Enabled = False
    Max = 255
    Min = 100
    PageSize = 15
    Frequency = 15
    Position = 255
    TabOrder = 4
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = trkRosterAlphaChange
  end
  object txtRosterAlpha: TExNumericEdit [6]
    Left = 207
    Top = 67
    Width = 70
    Height = 29
    BevelOuter = bvNone
    Enabled = False
    ParentColor = True
    TabOrder = 3
    Text = '255'
    Min = 100
    Max = 255
    OnChange = txtRosterAlphaChange
    DesignSize = (
      70
      29)
  end
  inherited pnlHeader: TTntPanel
    Width = 361
    Caption = 'Windows'
    TabOrder = 5
    ExplicitWidth = 361
  end
  object chkToastAlpha: TTntCheckBox
    Left = 9
    Top = 99
    Width = 336
    Height = 21
    Caption = 'Use Alpha Blending for Toast Notifications'
    TabOrder = 6
    OnClick = chkToastAlphaClick
  end
  object trkToastAlpha: TTrackBar
    Left = 40
    Top = 128
    Width = 168
    Height = 24
    Enabled = False
    Max = 255
    Min = 100
    PageSize = 15
    Frequency = 15
    Position = 255
    TabOrder = 7
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = trkToastAlphaChange
  end
  object txtToastAlpha: TExNumericEdit
    Left = 207
    Top = 125
    Width = 70
    Height = 29
    BevelOuter = bvNone
    Enabled = False
    ParentColor = True
    TabOrder = 2
    Text = '255'
    Min = 100
    Max = 255
    OnChange = txtToastAlphaChange
    DesignSize = (
      70
      29)
  end
  object chkSnap: TTntCheckBox
    Left = 9
    Top = 187
    Width = 336
    Height = 21
    Caption = 'Make the main window snap to screen edges'
    TabOrder = 10
    OnClick = chkSnapClick
  end
  object txtSnap: TExNumericEdit
    Left = 207
    Top = 215
    Width = 70
    Height = 29
    BevelOuter = bvNone
    Enabled = False
    ParentColor = True
    TabOrder = 1
    Text = '15'
    Min = 10
    Max = 120
    OnChange = txtSnapChange
    DesignSize = (
      70
      29)
  end
  object chkBusy: TTntCheckBox
    Left = 9
    Top = 315
    Width = 376
    Height = 21
    Caption = 'Warn when trying to close busy chat windows'
    TabOrder = 14
  end
  object txtToastDuration: TTntEdit
    Left = 207
    Top = 156
    Width = 60
    Height = 24
    TabOrder = 9
  end
  object txtChatMemory: TExNumericEdit
    Left = 207
    Top = 280
    Width = 70
    Height = 29
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    Text = '60'
    Min = 0
    Max = 360
    OnChange = txtChatMemoryChange
    DesignSize = (
      70
      29)
  end
  object txtCloseHotkey: THotKey
    Left = 40
    Top = 388
    Width = 177
    Height = 23
    HotKey = 57431
    InvalidKeys = []
    Modifiers = [hkShift, hkCtrl, hkAlt]
    TabOrder = 13
  end
  object chkEscClose: TTntCheckBox
    Left = 9
    Top = 340
    Width = 367
    Height = 20
    Caption = 'Use ESC key to close chat windows'
    TabOrder = 15
  end
  object trkSnap: TTrackBar
    Left = 37
    Top = 216
    Width = 168
    Height = 24
    Enabled = False
    Max = 120
    Min = 10
    PageSize = 15
    Frequency = 15
    Position = 15
    TabOrder = 11
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = trkSnapChange
  end
  object trkChatMemory: TTrackBar
    Left = 37
    Top = 283
    Width = 168
    Height = 24
    Max = 120
    PageSize = 15
    Frequency = 15
    Position = 60
    TabOrder = 12
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = trkChatMemoryChange
  end
end
