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
    Top = 172
    Width = 150
    Height = 13
    Caption = 'Group to be used for Gateways:'
  end
  object Label1: TTntLabel
    Left = 0
    Top = 220
    Width = 69
    Height = 13
    Caption = 'Default Group:'
  end
  object lblFilter: TTntLabel
    Left = 2
    Top = 113
    Width = 183
    Height = 24
    AutoSize = False
    Caption = 
      'When showing only online contacts, visible contacts must be at l' +
      'east:'
    WordWrap = True
  end
  object StaticText1: TTntStaticText
    Left = 0
    Top = 0
    Width = 274
    Height = 20
    Align = alTop
    Alignment = taCenter
    Caption = 'Roster Groups'
    Color = clHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clCaptionText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
  end
  object txtGatewayGrp: TTntComboBox
    Left = 20
    Top = 188
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 1
  end
  object txtDefaultGrp: TTntComboBox
    Left = 20
    Top = 236
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 2
  end
  object chkSort: TTntCheckBox
    Left = 0
    Top = 24
    Width = 193
    Height = 17
    Caption = 'Sort Contacts by their availability'
    TabOrder = 3
  end
  object cboVisible: TTntComboBox
    Left = 20
    Top = 141
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.WideStrings = (
      'Do Not Disturb'
      'Ext. Away'
      'Away'
      'Available')
  end
  object chkCollapsed: TTntCheckBox
    Left = 0
    Top = 40
    Width = 200
    Height = 17
    Caption = 'Collapse all roster groups initially.'
    TabOrder = 5
  end
  object chkGroupCounts: TTntCheckBox
    Left = 0
    Top = 56
    Width = 217
    Height = 17
    Caption = 'Show group counts in roster (eg, 5/10)'
    TabOrder = 6
  end
  object chkOfflineGrp: TTntCheckBox
    Left = 0
    Top = 72
    Width = 217
    Height = 17
    Caption = 'Show offline contacts in an Offline group'
    TabOrder = 7
    OnClick = chkOfflineGrpClick
  end
  object chkOnlineOnly: TTntCheckBox
    Left = 0
    Top = 88
    Width = 217
    Height = 17
    Caption = 'Only show online contacts'
    TabOrder = 8
  end
end
