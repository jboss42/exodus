inherited frmPrefDialogs: TfrmPrefDialogs
  Left = 257
  Top = 156
  Caption = 'frmPrefDialogs'
  ClientHeight = 360
  ClientWidth = 362
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label26: TTntLabel
    Left = 8
    Top = 247
    Width = 197
    Height = 13
    Caption = 'Minutes to keep chat windows in memory:'
  end
  object Label27: TTntLabel
    Left = 8
    Top = 261
    Width = 244
    Height = 13
    Caption = 'Use 0 minutes to destroy chat windows immediately.'
  end
  object Label29: TTntLabel
    Left = 39
    Top = 131
    Width = 120
    Height = 13
    Caption = 'Toast duration (seconds):'
  end
  object chkRosterAlpha: TTntCheckBox
    Left = 8
    Top = 32
    Width = 209
    Height = 17
    Caption = 'Use Alpha Blending for Roster '
    TabOrder = 0
    OnClick = chkRosterAlphaClick
  end
  object trkRosterAlpha: TTrackBar
    Left = 32
    Top = 56
    Width = 137
    Height = 18
    Enabled = False
    Max = 255
    Min = 10
    Frequency = 5
    Position = 255
    TabOrder = 1
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = trkRosterAlphaChange
  end
  object txtRosterAlpha: TTntEdit
    Left = 168
    Top = 54
    Width = 49
    Height = 21
    Enabled = False
    TabOrder = 2
    Text = '255'
    OnChange = txtRosterAlphaChange
  end
  object spnRosterAlpha: TTntUpDown
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
  object chkToastAlpha: TTntCheckBox
    Left = 8
    Top = 80
    Width = 273
    Height = 17
    Caption = 'Use Alpha Blending for Toast Notifications'
    TabOrder = 4
    OnClick = chkToastAlphaClick
  end
  object trkToastAlpha: TTrackBar
    Left = 32
    Top = 104
    Width = 137
    Height = 19
    Enabled = False
    Max = 255
    Min = 10
    Frequency = 5
    Position = 255
    TabOrder = 5
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = trkToastAlphaChange
  end
  object txtToastAlpha: TTntEdit
    Left = 168
    Top = 102
    Width = 49
    Height = 21
    Enabled = False
    TabOrder = 6
    Text = '255'
    OnChange = txtToastAlphaChange
  end
  object spnToastAlpha: TTntUpDown
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
  object chkSnap: TTntCheckBox
    Left = 8
    Top = 152
    Width = 273
    Height = 17
    Caption = 'Make the main window snap to screen edges'
    TabOrder = 8
    OnClick = chkSnapClick
  end
  object txtSnap: TTntEdit
    Left = 32
    Top = 174
    Width = 49
    Height = 21
    Enabled = False
    TabOrder = 9
    Text = '255'
  end
  object spnSnap: TTntUpDown
    Left = 81
    Top = 174
    Width = 16
    Height = 21
    Associate = txtSnap
    Enabled = False
    Min = 10
    Max = 255
    Position = 255
    TabOrder = 10
  end
  object chkBusy: TTntCheckBox
    Left = 8
    Top = 208
    Width = 265
    Height = 17
    Caption = 'Warn when trying to close busy chat windows.'
    TabOrder = 11
  end
  object txtToastDuration: TTntEdit
    Left = 168
    Top = 127
    Width = 49
    Height = 21
    TabOrder = 12
  end
  object txtChatMemory: TTntEdit
    Left = 32
    Top = 277
    Width = 49
    Height = 21
    TabOrder = 13
    Text = '60'
  end
  object spnChatMemory: TTntUpDown
    Left = 81
    Top = 277
    Width = 16
    Height = 21
    Associate = txtChatMemory
    Max = 360
    Increment = 5
    Position = 60
    TabOrder = 14
  end
  object StaticText4: TTntPanel
    Left = 0
    Top = 0
    Width = 362
    Height = 24
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Window Options'
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 15
  end
  object chkEscClose: TTntCheckBox
    Left = 8
    Top = 226
    Width = 265
    Height = 17
    Caption = 'Pressing the ESC key closes windows.'
    TabOrder = 16
  end
end
