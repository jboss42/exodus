inherited frmPrefRoster: TfrmPrefRoster
  Left = 236
  Top = 161
  Caption = 'frmPrefRoster'
  ClientHeight = 201
  ClientWidth = 344
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label21: TLabel
    Left = 0
    Top = 141
    Width = 93
    Height = 13
    Caption = 'Double Click Action'
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
    Width = 209
    Height = 17
    Caption = 'Show unsubscribed contacts.'
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
    Width = 209
    Height = 17
    Caption = 'Detect invalid roster items'
    TabOrder = 3
  end
  object chkShowPending: TCheckBox
    Left = 0
    Top = 42
    Width = 161
    Height = 17
    Caption = 'Show pending contacts'
    TabOrder = 4
  end
  object chkMessenger: TCheckBox
    Left = 0
    Top = 94
    Width = 273
    Height = 17
    Caption = 'Roster && Msg Queue share a tab when expanded'
    TabOrder = 5
  end
  object cboDblClick: TComboBox
    Left = 24
    Top = 157
    Width = 201
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Items.Strings = (
      'A new one to one chat window'
      'An instant message window'
      'A new or existing chat window')
  end
  object chkRosterUnicode: TCheckBox
    Left = 0
    Top = 111
    Width = 328
    Height = 17
    Caption = 'Allow Unicode characters in the roster (requires 2000, ME, XP).'
    TabOrder = 7
  end
end
