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
    Caption = 'Use Alpha Blending for Roster'
    TabOrder = 0
    OnClick = chkRosterAlphaClick
  end
  object trkRosterAlpha: TTrackBar [5]
    Left = 32
    Top = 56
    Width = 137
    Height = 18
    Enabled = False
    Max = 255
    Min = 10
    PageSize = 15
    Frequency = 15
    Position = 255
    TabOrder = 1
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = trkRosterAlphaChange
  end
  object txtRosterAlpha: TTntEdit [6]
    Left = 168
    Top = 54
    Width = 49
    Height = 21
    Enabled = False
    TabOrder = 2
    Text = '255'
    OnChange = txtRosterAlphaChange
  end
  object spnRosterAlpha: TTntUpDown [7]
    Left = 217
    Top = 54
    Width = 16
    Height = 21
    Associate = txtRosterAlpha
    Enabled = False
    Min = 10
    Max = 255
    Position = 255
    TabOrder = 3
  end
  object chkToastAlpha: TTntCheckBox [8]
    Left = 8
    Top = 80
    Width = 273
    Height = 17
    Caption = 'Use Alpha Blending for Toast Notifications'
    TabOrder = 4
    OnClick = chkToastAlphaClick
  end
  object trkToastAlpha: TTrackBar [9]
    Left = 32
    Top = 104
    Width = 137
    Height = 19
    Enabled = False
    Max = 255
    Min = 10
    PageSize = 15
    Frequency = 15
    Position = 255
    TabOrder = 5
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = trkToastAlphaChange
  end
  object txtToastAlpha: TTntEdit [10]
    Left = 168
    Top = 102
    Width = 49
    Height = 21
    Enabled = False
    TabOrder = 6
    Text = '255'
    OnChange = txtToastAlphaChange
  end
  object spnToastAlpha: TTntUpDown [11]
    Left = 217
    Top = 102
    Width = 16
    Height = 21
    Associate = txtToastAlpha
    Enabled = False
    Min = 10
    Max = 255
    Position = 255
    TabOrder = 7
  end
  object chkSnap: TTntCheckBox [12]
    Left = 8
    Top = 152
    Width = 273
    Height = 17
    Caption = 'Make the main window snap to screen edges'
    TabOrder = 9
    OnClick = chkSnapClick
  end
  object txtSnap: TTntEdit [13]
    Left = 168
    Top = 174
    Width = 49
    Height = 21
    Enabled = False
    TabOrder = 11
    Text = '15'
    OnChange = txtSnapChange
  end
  object spnSnap: TTntUpDown [14]
    Left = 217
    Top = 174
    Width = 16
    Height = 21
    Associate = txtSnap
    Enabled = False
    Min = 10
    Max = 120
    Position = 15
    TabOrder = 12
  end
  object chkBusy: TTntCheckBox [15]
    Left = 8
    Top = 256
    Width = 305
    Height = 17
    Caption = 'Warn when trying to close busy chat windows'
    TabOrder = 16
  end
  object txtToastDuration: TTntEdit [16]
    Left = 168
    Top = 127
    Width = 49
    Height = 21
    TabOrder = 8
  end
  object txtChatMemory: TTntEdit [17]
    Left = 168
    Top = 228
    Width = 49
    Height = 21
    TabOrder = 14
    Text = '60'
    OnChange = txtChatMemoryChange
  end
  object spnChatMemory: TTntUpDown [18]
    Left = 217
    Top = 228
    Width = 16
    Height = 21
    Associate = txtChatMemory
    Max = 360
    Increment = 5
    Position = 60
    TabOrder = 15
  end
  object txtCloseHotkey: THotKey [19]
    Left = 32
    Top = 315
    Width = 145
    Height = 19
    HotKey = 57431
    InvalidKeys = []
    Modifiers = [hkShift, hkCtrl, hkAlt]
    TabOrder = 18
  end
  object chkEscClose: TTntCheckBox [20]
    Left = 8
    Top = 276
    Width = 297
    Height = 17
    Caption = 'Use ESC key to close chat windows'
    TabOrder = 17
  end
  object trkSnap: TTrackBar [21]
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
    TabOrder = 10
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = trkSnapChange
  end
  object trkChatMemory: TTrackBar [22]
    Left = 30
    Top = 230
    Width = 137
    Height = 19
    Max = 120
    PageSize = 15
    Frequency = 15
    Position = 60
    TabOrder = 13
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = trkChatMemoryChange
  end
  inherited pnlHeader: TTntPanel
    Width = 294
    Caption = 'Window Options'
    TabOrder = 19
    ExplicitWidth = 294
  end
  object chkSaveWindowState: TTntCheckBox
    Left = 8
    Top = 337
    Width = 169
    Height = 17
    Caption = 'Save window positions'
    TabOrder = 20
  end
  object chkRestoreDesktop: TTntCheckBox
    Left = 8
    Top = 355
    Width = 97
    Height = 17
    Caption = 'Restore desktop'
    TabOrder = 21
  end
end
