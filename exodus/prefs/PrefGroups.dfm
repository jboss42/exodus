inherited frmPrefGroups: TfrmPrefGroups
  Left = 271
  Top = 196
  Caption = 'frmPrefGroups'
  ClientHeight = 240
  ClientWidth = 257
  PixelsPerInch = 96
  TextHeight = 13
  object Label18: TLabel
    Left = 0
    Top = 148
    Width = 150
    Height = 13
    Caption = 'Group to be used for Gateways:'
  end
  object Label1: TLabel
    Left = 0
    Top = 196
    Width = 69
    Height = 13
    Caption = 'Default Group:'
  end
  object Label2: TLabel
    Left = 0
    Top = 100
    Width = 154
    Height = 13
    Caption = 'Visible contacts must be at least:'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 0
    Width = 257
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
    Transparent = False
  end
  object txtGatewayGrp: TTntComboBox
    Left = 24
    Top = 164
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 1
  end
  object txtDefaultGrp: TTntComboBox
    Left = 24
    Top = 212
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 2
  end
  object chkSort: TCheckBox
    Left = 0
    Top = 24
    Width = 193
    Height = 17
    Caption = 'Sort Contacts by their availability'
    TabOrder = 3
  end
  object cboVisible: TTntComboBox
    Left = 24
    Top = 116
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.WideStrings = (
      'Offline (Show all)'
      'Do Not Disturb'
      'Ext. Away'
      'Away'
      'Available')
  end
  object chkCollapsed: TCheckBox
    Left = 0
    Top = 40
    Width = 200
    Height = 17
    Caption = 'Collapse all roster groups initially.'
    TabOrder = 5
  end
  object chkGroupCounts: TCheckBox
    Left = 0
    Top = 56
    Width = 217
    Height = 17
    Caption = 'Show group counts in roster (eg, 5/10)'
    TabOrder = 6
  end
  object chkOfflineGrp: TCheckBox
    Left = 0
    Top = 72
    Width = 217
    Height = 17
    Caption = 'Show offline contacts in the Offline group'
    TabOrder = 7
  end
end
