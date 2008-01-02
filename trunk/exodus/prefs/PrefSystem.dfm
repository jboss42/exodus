inherited frmPrefSystem: TfrmPrefSystem
  Left = 259
  Top = 156
  Caption = 'frmPrefSystem'
  ClientHeight = 502
  ClientWidth = 401
  OldCreateOrder = True
  ExplicitWidth = 413
  ExplicitHeight = 514
  PixelsPerInch = 120
  TextHeight = 17
  inherited pnlHeader: TTntPanel
    Width = 401
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = ' System Preferences'
    Color = 14460499
    Font.Color = clWhite
    Font.Height = -15
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ExplicitWidth = 401
    ExplicitHeight = 22
  end
  object ExGroupBox1: TExGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 33
    Width = 322
    Height = 44
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    TabStop = True
    Caption = 'When I start my computer:'
    BoxStyle = gbsLabel
    AutoHide = False
    Checked = False
    object chkAutoStart: TTntCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 16
      Width = 97
      Height = 25
      Caption = 'Start Exodus'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object ExGroupBox2: TExGroupBox
    Left = 2
    Top = 192
    Width = 320
    Height = 302
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    TabStop = True
    Caption = 'Advanced system options:'
    BoxStyle = gbsLabel
    AutoHide = False
    Checked = False
    object lblDefaultNick: TTntLabel
      Left = 3
      Top = 120
      Width = 127
      Height = 14
      Caption = 'My default nickname is:'
    end
    object lblLang: TTntLabel
      Left = 3
      Top = 173
      Width = 115
      Height = 14
      Caption = 'Language file to use:'
    end
    object lblLangScan: TTntLabel
      Left = 5
      Top = 225
      Width = 146
      Height = 14
      Cursor = crHandPoint
      Caption = 'Scan for language catalogs'
      OnClick = lblLangScanClick
    end
    object chkToolbox: TTntCheckBox
      Left = 3
      Top = 18
      Width = 284
      Height = 22
      Caption = 'Small Titlebar for main window'
      TabOrder = 1
    end
    object chkCloseMin: TTntCheckBox
      Left = 3
      Top = 43
      Width = 305
      Height = 22
      Caption = 'Close button minimizes to the tray'
      TabOrder = 2
    end
    object chkSingleInstance: TTntCheckBox
      Left = 3
      Top = 68
      Width = 274
      Height = 22
      Caption = 'Only allow a single, running instance'
      TabOrder = 3
    end
    object chkAutoUpdate: TTntCheckBox
      Left = 3
      Top = 92
      Width = 242
      Height = 22
      Caption = 'Check for updates automatically'
      TabOrder = 4
    end
    object btnUpdateCheck: TTntButton
      Left = 219
      Top = 86
      Width = 98
      Height = 33
      Caption = 'Check Now'
      TabOrder = 5
      OnClick = btnUpdateCheckClick
      OnMouseUp = btnUpdateCheckMouseUp
    end
    object txtDefaultNick: TTntEdit
      Left = 3
      Top = 142
      Width = 246
      Height = 22
      TabOrder = 6
    end
    object cboLocale: TTntComboBox
      Left = 3
      Top = 195
      Width = 246
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 7
      Items.Strings = (
        'English (American)')
    end
    object chkOnTop: TTntCheckBox
      Left = 3
      Top = 247
      Width = 221
      Height = 23
      Caption = 'Always on top'
      TabOrder = 8
      Visible = False
    end
    object chkDebug: TTntCheckBox
      Left = 3
      Top = 271
      Width = 221
      Height = 22
      Caption = 'Start with Debug visible'
      TabOrder = 9
    end
  end
  object ExGroupBox3: TExGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 90
    Width = 320
    Height = 96
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 3
    TabStop = True
    Caption = 'When I start Exodus'
    BoxStyle = gbsLabel
    AutoHide = False
    Checked = False
    object chkAutoLogin: TTntCheckBox
      Left = 3
      Top = 20
      Width = 264
      Height = 22
      Caption = 'Automatically login with last active profile'
      TabOrder = 1
    end
    object chkStartMin: TTntCheckBox
      Left = 3
      Top = 42
      Width = 295
      Height = 23
      Caption = 'Start minimized to the System Tray'
      TabOrder = 2
    end
    object CheckBox1: TCheckBox
      Left = 3
      Top = 68
      Width = 97
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 3
    end
  end
end
