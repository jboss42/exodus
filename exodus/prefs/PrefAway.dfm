inherited frmPrefAway: TfrmPrefAway
  Left = 252
  Top = 255
  Caption = 'frmPrefAway'
  ClientHeight = 212
  ClientWidth = 300
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TTntLabel
    Left = 8
    Top = 72
    Width = 213
    Height = 13
    Caption = 'Minutes to wait before setting status to Away:'
  end
  object Label3: TTntLabel
    Left = 8
    Top = 96
    Width = 201
    Height = 13
    Caption = 'Minutes to wait before setting status to XA:'
  end
  object Label4: TTntLabel
    Left = 8
    Top = 128
    Width = 62
    Height = 13
    Caption = 'Away Status:'
  end
  object Label9: TTntLabel
    Left = 8
    Top = 152
    Width = 50
    Height = 13
    Caption = 'XA Status:'
  end
  object txtAwayTime: TTntEdit
    Left = 232
    Top = 70
    Width = 33
    Height = 21
    TabOrder = 0
    Text = '5'
  end
  object spnAway: TUpDown
    Left = 265
    Top = 70
    Width = 16
    Height = 21
    Associate = txtAwayTime
    Min = 1
    Max = 600
    Position = 5
    TabOrder = 1
  end
  object txtXATime: TTntEdit
    Left = 232
    Top = 94
    Width = 33
    Height = 21
    TabOrder = 2
    Text = '30'
  end
  object spnXA: TUpDown
    Left = 265
    Top = 94
    Width = 16
    Height = 21
    Associate = txtXATime
    Min = 1
    Max = 600
    Position = 30
    TabOrder = 3
  end
  object chkAutoAway: TTntCheckBox
    Left = 8
    Top = 32
    Width = 177
    Height = 17
    Caption = 'Enable Auto Away'
    TabOrder = 4
  end
  object txtAway: TTntEdit
    Left = 80
    Top = 126
    Width = 201
    Height = 21
    TabOrder = 5
  end
  object txtXA: TTntEdit
    Left = 80
    Top = 150
    Width = 201
    Height = 21
    TabOrder = 6
  end
  object chkAAReducePri: TTntCheckBox
    Left = 8
    Top = 48
    Width = 273
    Height = 17
    Caption = 'Reduce priority to 0 during auto-away.'
    TabOrder = 7
  end
  object StaticText4: TTntPanel
    Left = 0
    Top = 0
    Width = 300
    Height = 24
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Auto Away Options'
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 8
  end
end
