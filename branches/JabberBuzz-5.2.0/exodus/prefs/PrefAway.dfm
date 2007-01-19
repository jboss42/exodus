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
  object txtAwayTime: TExNumericEdit [5]
    Left = 232
    Top = 119
    Width = 49
    Height = 25
    BevelOuter = bvNone
    TabOrder = 2
    Text = '5'
    Min = 1
    Max = 600
    DesignSize = (
      49
      25)
  end
  inherited pnlHeader: TTntPanel
    Width = 300
    Caption = 'Auto-Away'
    TabOrder = 7
    ExplicitWidth = 300
  end
  object txtXATime: TExNumericEdit
    Left = 232
    Top = 143
    Width = 49
    Height = 25
    BevelOuter = bvNone
    TabOrder = 1
    Text = '30'
    Min = 1
    Max = 600
    DesignSize = (
      49
      25)
  end
  object chkAutoAway: TTntCheckBox
    Left = 8
    Top = 32
    Width = 270
    Height = 17
    Caption = 'Enable Auto Away'
    TabOrder = 3
    OnClick = chkAutoAwayClick
  end
  object txtAway: TTntEdit
    Left = 80
    Top = 199
    Width = 201
    Height = 21
    TabOrder = 10
  end
  object txtXA: TTntEdit
    Left = 80
    Top = 223
    Width = 201
    Height = 21
    TabOrder = 8
  end
  object chkAAReducePri: TTntCheckBox
    Left = 8
    Top = 81
    Width = 273
    Height = 17
    Caption = 'Reduce priority to 0 during auto-away.'
    TabOrder = 6
  end
  object chkAutoXA: TTntCheckBox
    Left = 8
    Top = 48
    Width = 270
    Height = 17
    Caption = 'Enable Auto Extended Away'
    TabOrder = 4
    OnClick = chkAutoAwayClick
  end
  object chkAutoDisconnect: TTntCheckBox
    Left = 8
    Top = 64
    Width = 270
    Height = 17
    Caption = 'Enable Auto Disconnect'
    TabOrder = 5
    OnClick = chkAutoAwayClick
  end
  object txtDisconnectTime: TExNumericEdit
    Left = 232
    Top = 167
    Width = 49
    Height = 25
    BevelOuter = bvNone
    TabOrder = 0
    Text = '60'
    Min = 1
    Max = 600
    DesignSize = (
      49
      25)
  end
  object chkAwayAutoResponse: TTntCheckBox
    Left = 8
    Top = 98
    Width = 273
    Height = 17
    Caption = 'Send auto response message when away'
    TabOrder = 9
  end
end
