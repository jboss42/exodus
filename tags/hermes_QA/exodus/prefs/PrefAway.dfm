inherited frmPrefAway: TfrmPrefAway
  Left = 252
  Top = 255
  Caption = 'frmPrefAway'
  ClientHeight = 251
  ClientWidth = 300
  OldCreateOrder = True
  ExplicitWidth = 312
  ExplicitHeight = 263
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TTntLabel [0]
    Left = 8
    Top = 121
    Width = 213
    Height = 13
    Caption = 'Minutes to wait before setting status to Away:'
  end
  object Label3: TTntLabel [1]
    Left = 8
    Top = 145
    Width = 201
    Height = 13
    Caption = 'Minutes to wait before setting status to XA:'
  end
  object lblAwayStatus: TTntLabel [2]
    Left = 8
    Top = 201
    Width = 62
    Height = 13
    Caption = 'Away Status:'
  end
  object lblXAStatus: TTntLabel [3]
    Left = 8
    Top = 225
    Width = 50
    Height = 13
    Caption = 'XA Status:'
  end
  object TntLabel1: TTntLabel [4]
    Left = 8
    Top = 169
    Width = 178
    Height = 13
    Caption = 'Minutes to wait before Disconnecting:'
  end
  object txtAwayTime: TTntEdit [5]
    Left = 232
    Top = 119
    Width = 33
    Height = 21
    TabOrder = 4
    Text = '5'
  end
  object spnAway: TUpDown [6]
    Left = 265
    Top = 119
    Width = 16
    Height = 21
    Associate = txtAwayTime
    Min = 1
    Max = 600
    Position = 5
    TabOrder = 5
  end
  object txtXATime: TTntEdit [7]
    Left = 232
    Top = 143
    Width = 33
    Height = 21
    TabOrder = 6
    Text = '30'
  end
  object spnXA: TUpDown [8]
    Left = 265
    Top = 143
    Width = 16
    Height = 21
    Associate = txtXATime
    Min = 1
    Max = 600
    Position = 30
    TabOrder = 7
  end
  object chkAutoAway: TTntCheckBox [9]
    Left = 8
    Top = 32
    Width = 270
    Height = 17
    Caption = 'Enable Auto Away'
    TabOrder = 0
    OnClick = chkAutoAwayClick
  end
  object txtAway: TTntEdit [10]
    Left = 80
    Top = 199
    Width = 201
    Height = 21
    TabOrder = 10
  end
  object txtXA: TTntEdit [11]
    Left = 80
    Top = 223
    Width = 201
    Height = 21
    TabOrder = 11
  end
  object chkAAReducePri: TTntCheckBox [12]
    Left = 8
    Top = 81
    Width = 273
    Height = 17
    Caption = 'Reduce priority to 0 during auto-away.'
    TabOrder = 3
  end
  object chkAutoXA: TTntCheckBox [13]
    Left = 8
    Top = 48
    Width = 270
    Height = 17
    Caption = 'Enable Auto Extended Away'
    TabOrder = 1
    OnClick = chkAutoAwayClick
  end
  object chkAutoDisconnect: TTntCheckBox [14]
    Left = 8
    Top = 64
    Width = 270
    Height = 17
    Caption = 'Enable Auto Disconnect'
    TabOrder = 2
    OnClick = chkAutoAwayClick
  end
  object txtDisconnectTime: TTntEdit [15]
    Left = 232
    Top = 167
    Width = 33
    Height = 21
    TabOrder = 8
    Text = '60'
  end
  object spnDisconnect: TUpDown [16]
    Left = 265
    Top = 167
    Width = 16
    Height = 21
    Associate = txtDisconnectTime
    Min = 1
    Max = 600
    Position = 60
    TabOrder = 9
  end
  inherited pnlHeader: TTntPanel
    Width = 300
    Caption = 'Auto Away Options'
    TabOrder = 12
    ExplicitWidth = 300
  end
  object chkAwayAutoResponse: TTntCheckBox
    Left = 8
    Top = 98
    Width = 273
    Height = 17
    Caption = 'Send auto response message when away'
    TabOrder = 13
  end
end
