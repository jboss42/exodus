inherited frmPrefRoster: TfrmPrefRoster
  Left = 254
  Top = 162
  Caption = 'frmPrefRoster'
  ClientHeight = 394
  ClientWidth = 396
  OldCreateOrder = True
  ExplicitWidth = 408
  ExplicitHeight = 406
  PixelsPerInch = 96
  TextHeight = 13
  object lblDblClick: TTntLabel [0]
    Left = 0
    Top = 127
    Width = 143
    Height = 13
    Caption = 'When I double click a contact'
  end
  object lblNestedGrpSeparator: TTntLabel [1]
    Left = 24
    Top = 322
    Width = 144
    Height = 13
    Caption = 'Seperator for nested groups is:'
  end
  object lblDNProfileMap: TTntLabel [2]
    Left = 24
    Top = 250
    Width = 106
    Height = 13
    Caption = 'Use these profile fields'
  end
  object chkShowUnsubs: TTntCheckBox [3]
    Left = 0
    Top = 104
    Width = 337
    Height = 17
    Caption = 'Show contacts which I do not have a subscription to'
    TabOrder = 0
  end
  object chkHideBlocked: TTntCheckBox [4]
    Left = 0
    Top = 50
    Width = 337
    Height = 17
    Caption = 'Hide blocked contacts '
    TabOrder = 2
  end
  object chkPresErrors: TTntCheckBox [5]
    Left = 0
    Top = 369
    Width = 337
    Height = 17
    Caption = 'Detect contacts which are unreachable or no longer exist'
    TabOrder = 3
    Visible = False
  end
  object chkShowPending: TTntCheckBox [6]
    Left = 0
    Top = 32
    Width = 337
    Height = 17
    Caption = 'Show contacts I have asked to add as "Pending"'
    TabOrder = 1
  end
  object cboDblClick: TTntComboBox [7]
    Left = 24
    Top = 143
    Width = 201
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    Items.Strings = (
      'A new one to one chat window'
      'An instant message window'
      'A new or existing chat window')
  end
  object chkRosterUnicode: TTntCheckBox [8]
    Left = 0
    Top = 68
    Width = 361
    Height = 17
    Caption = 
      'Allow Unicode characters in the contact list (requires 2000, ME,' +
      ' XP).'
    TabOrder = 4
  end
  object chkInlineStatus: TTntCheckBox [9]
    Left = 0
    Top = 172
    Width = 241
    Height = 17
    Caption = 'Show contact status in the contact list'
    TabOrder = 6
    OnClick = chkInlineStatusClick
  end
  object cboInlineStatus: TColorBox [10]
    Left = 24
    Top = 191
    Width = 201
    Height = 22
    DefaultColorColor = clBlue
    Selected = clBlue
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
    DropDownCount = 12
    ItemHeight = 16
    TabOrder = 7
  end
  inherited pnlHeader: TTntPanel
    Width = 396
    Caption = 'Contact List'
    TabOrder = 8
    ExplicitWidth = 396
  end
  object chkNestedGrps: TTntCheckBox
    Left = 0
    Top = 304
    Width = 241
    Height = 17
    Caption = 'Use nested groups'
    TabOrder = 9
    OnClick = chkNestedGrpsClick
  end
  object txtGrpSeperator: TTntEdit
    Left = 24
    Top = 339
    Width = 201
    Height = 21
    TabOrder = 10
  end
  object chkRosterAvatars: TTntCheckBox
    Left = 0
    Top = 86
    Width = 337
    Height = 17
    Caption = 'Show Avatars in the contact list'
    TabOrder = 11
  end
  object chkUseProfileDN: TTntCheckBox
    Left = 0
    Top = 232
    Width = 207
    Height = 17
    Caption = 'Get display name from contact'#39's profile'
    TabOrder = 12
    OnClick = chkUseProfileDNClick
  end
  object txtDNProfileMap: TTntEdit
    Left = 24
    Top = 269
    Width = 201
    Height = 21
    TabOrder = 13
  end
end
