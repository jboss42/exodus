inherited frmPrefDialogs: TfrmPrefDialogs
  Left = 257
  Top = 156
  Caption = 'frmPrefDialogs'
  ClientHeight = 384
  ClientWidth = 294
  OldCreateOrder = True
  ExplicitWidth = 306
  ExplicitHeight = 396
  PixelsPerInch = 96
  TextHeight = 13
  object lblMem1: TTntLabel [0]
    Left = 8
    Top = 199
    Width = 197
    Height = 13
    Caption = 'Minutes to keep chat windows in memory:'
  end
  object lblMem2: TTntLabel [1]
    Left = 8
    Top = 213
    Width = 241
    Height = 13
    Caption = 'Use 0 minutes to destroy chat windows immediately'
  end
  object lblToastDuration: TTntLabel [2]
    Left = 39
    Top = 131
    Width = 120
    Height = 13
    Caption = 'Toast duration (seconds):'
  end
  object lblClose: TTntLabel [3]
    Left = 8
    Top = 296
    Width = 234
    Height = 13
    Caption = 'Use this hotkey sequence to close chat windows:'
  end
  object chkRosterAlpha: TTntCheckBox [4]
    Left = 8
    Top = 32
    Width = 209
    Height = 17
    Caption = 'Use Alpha Blending for Contact List'
    TabOrder = 8
    OnClick = chkRosterAlphaClick
  end
  object trkRosterAlpha: TTrackBar [5]
    Left = 32
    Top = 56
    Width = 137
    Height = 18
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
    Left = 168
    Top = 54
    Width = 57
    Height = 25
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 3
    Text = '255'
    Min = 100
    Max = 255
    OnChange = txtRosterAlphaChange
    DesignSize = (
      57
      25)
  end
  inherited pnlHeader: TTntPanel
    Width = 294
    Caption = 'Windows'
    TabOrder = 5
    ExplicitWidth = 294
  end
  object chkToastAlpha: TTntCheckBox
    Left = 8
    Top = 80
    Width = 273
    Height = 17
    Caption = 'Use Alpha Blending for Toast Notifications'
    TabOrder = 6
    OnClick = chkToastAlphaClick
  end
  object trkToastAlpha: TTrackBar
    Left = 32
    Top = 104
    Width = 137
    Height = 19
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
    Left = 168
    Top = 102
    Width = 57
    Height = 25
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
    Text = '255'
    Min = 100
    Max = 255
    OnChange = txtToastAlphaChange
    DesignSize = (
      57
      25)
  end
  object chkSnap: TTntCheckBox
    Left = 8
    Top = 152
    Width = 273
    Height = 17
    Caption = 'Make the main window snap to screen edges'
    TabOrder = 10
    OnClick = chkSnapClick
  end
  object txtSnap: TExNumericEdit
    Left = 168
    Top = 174
    Width = 57
    Height = 25
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 1
    Text = '15'
    Min = 10
    Max = 120
    OnChange = txtSnapChange
    DesignSize = (
      57
      25)
  end
  object chkBusy: TTntCheckBox
    Left = 8
    Top = 256
    Width = 305
    Height = 17
    Caption = 'Warn when trying to close busy chat windows'
    TabOrder = 15
  end
  object txtToastDuration: TTntEdit
    Left = 168
    Top = 127
    Width = 49
    Height = 21
    TabOrder = 9
  end
  object txtChatMemory: TExNumericEdit
    Left = 168
    Top = 228
    Width = 57
    Height = 25
    BevelOuter = bvNone
    TabOrder = 0
    Text = '60'
    Min = 0
    Max = 360
    OnChange = txtChatMemoryChange
    DesignSize = (
      57
      25)
  end
  object txtCloseHotkey: THotKey
    Left = 32
    Top = 315
    Width = 145
    Height = 19
    HotKey = 57431
    InvalidKeys = []
    Modifiers = [hkShift, hkCtrl, hkAlt]
    TabOrder = 13
  end
  object chkEscClose: TTntCheckBox
    Left = 8
    Top = 276
    Width = 297
    Height = 17
    Caption = 'Use ESC key to close chat windows'
    TabOrder = 17
  end
  object trkSnap: TTrackBar
    Left = 30
    Top = 176
    Width = 137
    Height = 19
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
    Left = 30
    Top = 230
    Width = 137
    Height = 19
    Max = 120
    PageSize = 15
    Frequency = 15
    Position = 60
    TabOrder = 12
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = trkChatMemoryChange
  end
  object chkSaveWindowState: TTntCheckBox
    Left = 8
    Top = 337
    Width = 169
    Height = 17
    Caption = 'Save window positions'
    TabOrder = 14
  end
  object chkRestoreDesktop: TTntCheckBox
    Left = 8
    Top = 355
    Width = 97
    Height = 17
    Caption = 'Restore desktop'
    TabOrder = 16
  end
end
