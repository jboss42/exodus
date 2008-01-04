inherited frmPrefDialogs: TfrmPrefDialogs
  Left = 257
  Top = 156
  Caption = 'frmPrefDialogs'
  ClientHeight = 502
  ClientWidth = 384
  OldCreateOrder = True
  ExplicitWidth = 396
  ExplicitHeight = 514
  PixelsPerInch = 120
  TextHeight = 17
  object lblMem1: TTntLabel [0]
    Left = 10
    Top = 260
    Width = 258
    Height = 17
    Caption = 'Minutes to keep chat windows in memory:'
  end
  object lblMem2: TTntLabel [1]
    Left = 10
    Top = 279
    Width = 317
    Height = 17
    Caption = 'Use 0 minutes to destroy chat windows immediately'
  end
  object lblToastDuration: TTntLabel [2]
    Left = 51
    Top = 171
    Width = 158
    Height = 17
    Caption = 'Toast duration (seconds):'
  end
  object lblClose: TTntLabel [3]
    Left = 10
    Top = 387
    Width = 299
    Height = 17
    Caption = 'Use this hotkey sequence to close chat windows:'
  end
  object chkRosterAlpha: TTntCheckBox [4]
    Left = 10
    Top = 42
    Width = 274
    Height = 22
    Caption = 'Use Alpha Blending'
    TabOrder = 8
    OnClick = chkRosterAlphaClick
  end
  object trkRosterAlpha: TTrackBar [5]
    Left = 42
    Top = 73
    Width = 179
    Height = 24
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
    Left = 220
    Top = 71
    Width = 74
    Height = 41
    BevelOuter = bvNone
    Enabled = False
    ParentColor = True
    TabOrder = 3
    Text = '255'
    Min = 100
    Max = 255
    OnChange = txtRosterAlphaChange
    DesignSize = (
      74
      41)
  end
  inherited pnlHeader: TTntPanel
    Width = 384
    Caption = 'Windows'
    TabOrder = 5
    ExplicitTop = 2
    ExplicitWidth = 384
  end
  object chkToastAlpha: TTntCheckBox
    Left = 10
    Top = 105
    Width = 357
    Height = 22
    Caption = 'Use Alpha Blending for Toast Notifications'
    TabOrder = 6
    OnClick = chkToastAlphaClick
  end
  object trkToastAlpha: TTrackBar
    Left = 42
    Top = 136
    Width = 179
    Height = 25
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
    Left = 220
    Top = 133
    Width = 74
    Height = 41
    BevelOuter = bvNone
    Enabled = False
    ParentColor = True
    TabOrder = 2
    Text = '255'
    Min = 100
    Max = 255
    OnChange = txtToastAlphaChange
    DesignSize = (
      74
      41)
  end
  object chkSnap: TTntCheckBox
    Left = 10
    Top = 199
    Width = 357
    Height = 22
    Caption = 'Make the main window snap to screen edges'
    TabOrder = 10
    OnClick = chkSnapClick
  end
  object txtSnap: TExNumericEdit
    Left = 220
    Top = 228
    Width = 74
    Height = 41
    BevelOuter = bvNone
    Enabled = False
    ParentColor = True
    TabOrder = 1
    Text = '15'
    Min = 10
    Max = 120
    OnChange = txtSnapChange
    DesignSize = (
      74
      41)
  end
  object chkBusy: TTntCheckBox
    Left = 10
    Top = 335
    Width = 399
    Height = 22
    Caption = 'Warn when trying to close busy chat windows'
    TabOrder = 14
  end
  object txtToastDuration: TTntEdit
    Left = 220
    Top = 166
    Width = 64
    Height = 25
    TabOrder = 9
  end
  object txtChatMemory: TExNumericEdit
    Left = 220
    Top = 298
    Width = 74
    Height = 41
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    Text = '60'
    Min = 0
    Max = 360
    OnChange = txtChatMemoryChange
    DesignSize = (
      74
      41)
  end
  object txtCloseHotkey: THotKey
    Left = 42
    Top = 412
    Width = 189
    Height = 25
    HotKey = 57431
    InvalidKeys = []
    Modifiers = [hkShift, hkCtrl, hkAlt]
    TabOrder = 13
  end
  object chkEscClose: TTntCheckBox
    Left = 10
    Top = 361
    Width = 389
    Height = 22
    Caption = 'Use ESC key to close chat windows'
    TabOrder = 15
  end
  object trkSnap: TTrackBar
    Left = 39
    Top = 230
    Width = 179
    Height = 25
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
    Left = 39
    Top = 301
    Width = 179
    Height = 25
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
