inherited frmPrefGroups: TfrmPrefGroups
  Left = 271
  Top = 196
  Caption = 'frmPrefGroups'
  ClientHeight = 301
  ClientWidth = 274
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label18: TTntLabel
    Left = 0
    Top = 180
    Width = 150
    Height = 13
    Caption = 'Group to be used for Gateways:'
  end
  object Label1: TTntLabel
    Left = 0
    Top = 228
    Width = 69
    Height = 13
    Caption = 'Default Group:'
  end
  object lblFilter: TTntLabel
    Left = 2
    Top = 121
    Width = 183
    Height = 24
    AutoSize = False
    Caption = 
      'When showing only online contacts, visible contacts must be at l' +
      'east:'
    WordWrap = True
  end
  object txtGatewayGrp: TTntComboBox
    Left = 20
    Top = 196
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object txtDefaultGrp: TTntComboBox
    Left = 20
    Top = 244
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 1
  end
  object chkSort: TTntCheckBox
    Left = 0
    Top = 32
    Width = 193
    Height = 17
    Caption = 'Sort Contacts by their availability'
    TabOrder = 2
  end
  object cboVisible: TTntComboBox
    Left = 20
    Top = 149
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.WideStrings = (
      'Do Not Disturb'
      'Ext. Away'
      'Away'
      'Available')
  end
  object chkCollapsed: TTntCheckBox
    Left = 0
    Top = 48
    Width = 200
    Height = 17
    Caption = 'Collapse all roster groups initially.'
    TabOrder = 4
  end
  object chkGroupCounts: TTntCheckBox
    Left = 0
    Top = 64
    Width = 217
    Height = 17
    Caption = 'Show group counts in roster (eg, 5/10)'
    TabOrder = 5
  end
  object chkOfflineGrp: TTntCheckBox
    Left = 0
    Top = 80
    Width = 217
    Height = 17
    Caption = 'Show offline contacts in an Offline group'
    TabOrder = 6
    OnClick = chkOfflineGrpClick
  end
  object chkOnlineOnly: TTntCheckBox
    Left = 0
    Top = 96
    Width = 217
    Height = 17
    Caption = 'Only show online contacts'
    TabOrder = 7
  end
  object StaticText4: TTntPanel
    Left = 0
    Top = 0
    Width = 274
    Height = 24
    Align = alTop
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 8
    object TntLabel1: TTntLabel
      Left = 1
      Top = 1
      Width = 272
      Height = 22
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 'Roster Group Options'
      Color = clHighlight
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
  end
end
