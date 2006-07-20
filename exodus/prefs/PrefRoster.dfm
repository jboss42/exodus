inherited frmPrefRoster: TfrmPrefRoster
  Left = 254
  Top = 162
  Caption = 'frmPrefRoster'
  ClientHeight = 349
  ClientWidth = 342
  OldCreateOrder = True
  ExplicitWidth = 354
  ExplicitHeight = 361
  PixelsPerInch = 96
  TextHeight = 13
  object lblDblClick: TTntLabel [0]
    Left = 0
    Top = 139
    Width = 143
    Height = 13
    Caption = 'When I double click a contact'
  end
  object TntLabel1: TTntLabel [1]
    Left = 24
    Top = 264
    Width = 144
    Height = 13
    Caption = 'Seperator for nested groups is:'
  end
  object chkShowUnsubs: TTntCheckBox [2]
    Left = 0
    Top = 33
    Width = 337
    Height = 17
    Caption = 'Show contacts which I do not have a subscription to.'
    TabOrder = 0
  end
  object chkHideBlocked: TTntCheckBox [3]
    Left = 0
    Top = 68
    Width = 337
    Height = 17
    Caption = 'Hide blocked contacts '
    TabOrder = 2
  end
  object chkPresErrors: TTntCheckBox [4]
    Left = 0
    Top = 86
    Width = 337
    Height = 17
    Caption = 'Detect contacts which are unreachable or no longer exist'
    TabOrder = 3
  end
  object chkShowPending: TTntCheckBox [5]
    Left = 0
    Top = 50
    Width = 337
    Height = 17
    Caption = 'Show contacts I have asked to add as "Pending"'
    TabOrder = 1
  end
  object cboDblClick: TTntComboBox [6]
    Left = 24
    Top = 155
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
  object chkRosterUnicode: TTntCheckBox [7]
    Left = 0
    Top = 103
    Width = 337
    Height = 17
    Caption = 'Allow Unicode characters in the roster (requires 2000, ME, XP).'
    TabOrder = 4
  end
  object chkInlineStatus: TTntCheckBox [8]
    Left = 0
    Top = 190
    Width = 241
    Height = 17
    Caption = 'Show contact status in the roster'
    TabOrder = 6
    OnClick = chkInlineStatusClick
  end
  object cboInlineStatus: TColorBox [9]
    Left = 24
    Top = 209
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
    Width = 342
    Caption = 'Roster Item Options'
    TabOrder = 8
    ExplicitWidth = 342
  end
  object chkNestedGrps: TTntCheckBox
    Left = 0
    Top = 246
    Width = 241
    Height = 17
    Caption = 'Use nested groups'
    TabOrder = 9
    OnClick = chkNestedGrpsClick
  end
  object txtGrpSeperator: TTntEdit
    Left = 24
    Top = 281
    Width = 201
    Height = 21
    TabOrder = 10
  end
  object chkRosterAvatars: TTntCheckBox
    Left = 0
    Top = 120
    Width = 337
    Height = 17
    Caption = 'Show Avatars in the roster'
    TabOrder = 11
  end
end
