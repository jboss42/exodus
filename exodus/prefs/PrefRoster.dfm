inherited frmPrefRoster: TfrmPrefRoster
  Left = 253
  Top = 161
  Caption = 'frmPrefRoster'
  ClientHeight = 244
  ClientWidth = 344
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label21: TTntLabel
    Left = 0
    Top = 125
    Width = 164
    Height = 13
    Caption = 'When I double click a contact, do:'
  end
  object chkShowUnsubs: TTntCheckBox
    Left = 0
    Top = 33
    Width = 337
    Height = 17
    Caption = 'Show contacts which I do not have a subscription to.'
    TabOrder = 0
  end
  object chkHideBlocked: TTntCheckBox
    Left = 0
    Top = 68
    Width = 337
    Height = 17
    Caption = 'Hide blocked contacts '
    TabOrder = 2
  end
  object chkPresErrors: TTntCheckBox
    Left = 0
    Top = 86
    Width = 337
    Height = 17
    Caption = 'Detect contacts which are unreachable or no longer exist'
    TabOrder = 3
  end
  object chkShowPending: TTntCheckBox
    Left = 0
    Top = 50
    Width = 337
    Height = 17
    Caption = 'Show contacts I have asked to add as "Pending"'
    TabOrder = 1
  end
  object cboDblClick: TTntComboBox
    Left = 24
    Top = 141
    Width = 201
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    Items.WideStrings = (
      'A new one to one chat window'
      'An instant message window'
      'A new or existing chat window')
  end
  object chkRosterUnicode: TTntCheckBox
    Left = 0
    Top = 103
    Width = 337
    Height = 17
    Caption = 'Allow Unicode characters in the roster (requires 2000, ME, XP).'
    TabOrder = 4
  end
  object chkInlineStatus: TTntCheckBox
    Left = 0
    Top = 176
    Width = 241
    Height = 17
    Caption = 'Show status in the roster: Joe <Meeting>'
    TabOrder = 6
    OnClick = chkInlineStatusClick
  end
  object cboInlineStatus: TColorBox
    Left = 24
    Top = 195
    Width = 201
    Height = 22
    DefaultColorColor = clBlue
    Selected = clBlue
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
    DropDownCount = 12
    ItemHeight = 16
    TabOrder = 7
  end
  object StaticText4: TTntPanel
    Left = 0
    Top = 0
    Width = 344
    Height = 24
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Roster Options'
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
