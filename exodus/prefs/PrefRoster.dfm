inherited frmPrefRoster: TfrmPrefRoster
  Left = 265
  Top = 156
  Caption = 'frmPrefRoster'
  ClientHeight = 244
  ClientWidth = 344
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label21: TLabel
    Left = 0
    Top = 117
    Width = 164
    Height = 13
    Caption = 'When I double click a contact, do:'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 0
    Width = 344
    Height = 20
    Align = alTop
    Alignment = taCenter
    Caption = 'Roster Options'
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
  object chkShowUnsubs: TCheckBox
    Left = 0
    Top = 25
    Width = 265
    Height = 17
    Caption = 'Show contacts who can not see my presence'
    TabOrder = 1
  end
  object chkHideBlocked: TCheckBox
    Left = 0
    Top = 60
    Width = 201
    Height = 17
    Caption = 'Hide blocked contacts '
    TabOrder = 2
  end
  object chkPresErrors: TCheckBox
    Left = 0
    Top = 78
    Width = 321
    Height = 17
    Caption = 'Detect contacts which are unreachable or no longer exist'
    TabOrder = 3
  end
  object chkShowPending: TCheckBox
    Left = 0
    Top = 42
    Width = 289
    Height = 17
    Caption = 'Show contacts I have asked to add as "Pending"'
    TabOrder = 4
  end
  object cboDblClick: TComboBox
    Left = 24
    Top = 133
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
  object chkRosterUnicode: TCheckBox
    Left = 0
    Top = 95
    Width = 328
    Height = 17
    Caption = 'Allow Unicode characters in the roster (requires 2000, ME, XP).'
    TabOrder = 6
  end
  object chkInlineStatus: TCheckBox
    Left = 0
    Top = 168
    Width = 241
    Height = 17
    Caption = 'Show status in the roster: Joe <Meeting>'
    TabOrder = 7
    OnClick = chkInlineStatusClick
  end
  object cboInlineStatus: TColorBox
    Left = 24
    Top = 187
    Width = 201
    Height = 22
    DefaultColorColor = clBlue
    Selected = clBlue
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
    DropDownCount = 12
    ItemHeight = 16
    TabOrder = 8
  end
end
