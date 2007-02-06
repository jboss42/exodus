inherited frmPrefGroups: TfrmPrefGroups
  Left = 274
  Top = 199
  Caption = 'frmPrefGroups'
  ClientHeight = 299
  ClientWidth = 272
  OldCreateOrder = True
  ExplicitWidth = 284
  ExplicitHeight = 311
  PixelsPerInch = 96
  TextHeight = 13
  object lblGatewayGrp: TTntLabel [0]
    Left = 0
    Top = 193
    Width = 150
    Height = 13
    Caption = 'Group to be used for Gateways:'
  end
  object lblDefaultGrp: TTntLabel [1]
    Left = 0
    Top = 241
    Width = 69
    Height = 13
    Caption = 'Default Group:'
  end
  object lblFilter: TTntLabel [2]
    Left = 2
    Top = 121
    Width = 250
    Height = 26
    Caption = 
      'When showing only online contacts, visible contacts must be at l' +
      'east:'
    WordWrap = True
  end
  object txtGatewayGrp: TTntComboBox [3]
    Left = 20
    Top = 209
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 6
  end
  object txtDefaultGrp: TTntComboBox [4]
    Left = 20
    Top = 257
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 7
  end
  object chkSort: TTntCheckBox [5]
    Left = 0
    Top = 32
    Width = 193
    Height = 17
    Caption = 'Sort Contacts by their availability'
    TabOrder = 0
  end
  object cboVisible: TTntComboBox [6]
    Left = 20
    Top = 162
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    Items.Strings = (
      'Do Not Disturb'
      'Ext. Away'
      'Away'
      'Available')
  end
  object chkCollapsed: TTntCheckBox [7]
    Left = 0
    Top = 48
    Width = 200
    Height = 17
    Caption = 'Collapse all contact list groups initially.'
    TabOrder = 1
  end
  object chkGroupCounts: TTntCheckBox [8]
    Left = 0
    Top = 64
    Width = 217
    Height = 17
    Caption = 'Show group counts in contact list (eg, 5/10)'
    TabOrder = 2
  end
  object chkOfflineGrp: TTntCheckBox [9]
    Left = 0
    Top = 80
    Width = 217
    Height = 17
    Caption = 'Show offline contacts in an Offline group'
    TabOrder = 3
    OnClick = chkOfflineGrpClick
  end
  object chkOnlineOnly: TTntCheckBox [10]
    Left = 0
    Top = 96
    Width = 217
    Height = 17
    Caption = 'Only show online contacts'
    TabOrder = 4
    OnClick = chkOfflineGrpClick
  end
  inherited pnlHeader: TTntPanel
    Width = 272
    Caption = 'Groups'
    TabOrder = 8
    ExplicitWidth = 272
  end
end
