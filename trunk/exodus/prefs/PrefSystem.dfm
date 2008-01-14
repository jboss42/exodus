inherited frmPrefSystem: TfrmPrefSystem
  Left = 259
  Top = 156
  ActiveControl = chkAutoStart
  Caption = 'frmPrefSystem'
  ClientHeight = 632
  ClientWidth = 381
  OldCreateOrder = True
  ExplicitWidth = 393
  ExplicitHeight = 644
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 381
    Font.Style = [fsBold]
    TabOrder = 1
    ExplicitWidth = 381
    inherited lblHeader: TTntLabel
      Width = 150
      Caption = 'System Preferences'
      ExplicitTop = 3
      ExplicitWidth = 150
    end
  end
  object gbParentGroup: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 33
    Width = 329
    Height = 593
    Margins.Left = 0
    Margins.Top = 6
    Margins.Right = 0
    Margins.Bottom = 6
    Align = alLeft
    TabOrder = 0
    TabStop = True
    AutoHide = True
    object ExGroupBox2: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 6
      Width = 329
      Height = 42
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      TabOrder = 0
      TabStop = True
      AutoHide = True
      Caption = 'When I start my computer:'
      object chkAutoStart: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 17
        Width = 326
        Height = 25
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Start Exodus'
        TabOrder = 0
      end
    end
    object gbOnStart: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 60
      Width = 329
      Height = 106
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 4
      Align = alTop
      AutoSize = True
      TabOrder = 1
      TabStop = True
      AutoHide = True
      Caption = 'When I start Exodus:'
      object chkAutoLogin: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 17
        Width = 326
        Height = 22
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Automatically login with the last active profile'
        TabOrder = 0
      end
      object chkStartMin: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 39
        Width = 326
        Height = 23
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Start &minimized to the System Tray'
        TabOrder = 1
      end
      object chkRestoreDesktop: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 62
        Width = 326
        Height = 22
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Restore desktop to previous state'
        TabOrder = 2
      end
      object chkDebug: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 84
        Width = 326
        Height = 22
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Show the debug &window'
        TabOrder = 3
      end
    end
    object ExGroupBox4: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 176
      Width = 329
      Height = 133
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      TabOrder = 2
      TabStop = True
      AutoHide = True
      Caption = 'Other:'
      object chkSaveWindowState: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 17
        Width = 326
        Height = 22
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Save window &positions'
        TabOrder = 0
      end
      object pnlDockPref: TTntPanel
        AlignWithMargins = True
        Left = 0
        Top = 42
        Width = 326
        Height = 57
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object lblDockPref: TTntLabel
          Left = 3
          Top = 0
          Width = 108
          Height = 16
          Caption = 'Show all windows:'
          FocusControl = rbDocked
        end
        object rbDocked: TTntRadioButton
          Left = 17
          Top = 19
          Width = 310
          Height = 17
          Caption = '&Docked'
          TabOrder = 0
          TabStop = True
        end
        object rbUndocked: TTntRadioButton
          Left = 17
          Top = 38
          Width = 310
          Height = 19
          Caption = '&Undocked'
          TabOrder = 1
          TabStop = True
        end
      end
      object ExBrandPanel1: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 105
        Width = 326
        Height = 25
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 3
        TabStop = True
        AutoHide = True
        ExplicitTop = 102
        ExplicitWidth = 329
        object btnPlugins: TTntButton
          Left = 3
          Top = 0
          Width = 120
          Height = 25
          Caption = 'Manage Plugins...'
          TabOrder = 0
          OnClick = btnPluginsClick
        end
      end
    end
    object ExGroupBox3: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 321
      Width = 329
      Height = 213
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      TabOrder = 3
      TabStop = True
      AutoHide = True
      Caption = 'Advanced system preferences:'
      ExplicitTop = 290
      object chkToolbox: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 61
        Width = 326
        Height = 22
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Small title&bar for main window'
        TabOrder = 2
      end
      object chkCloseMin: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 17
        Width = 326
        Height = 22
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Close button minimizes to the System Tray'
        TabOrder = 0
      end
      object chkSingleInstance: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 39
        Width = 326
        Height = 22
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Only allow a single, running instance'
        TabOrder = 1
      end
      object chkOnTop: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 83
        Width = 326
        Height = 23
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Always on &top'
        TabOrder = 3
        Visible = False
      end
      object pnlAutoUpdates: TTntPanel
        AlignWithMargins = True
        Left = 0
        Top = 109
        Width = 326
        Height = 33
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        object chkAutoUpdate: TTntCheckBox
          Left = 3
          Top = 5
          Width = 242
          Height = 22
          Caption = 'Chec&k for updates automatically'
          TabOrder = 0
        end
        object btnUpdateCheck: TTntButton
          Left = 229
          Top = 0
          Width = 98
          Height = 33
          Caption = 'Check &Now'
          TabOrder = 1
          OnClick = btnUpdateCheckClick
          OnMouseUp = btnUpdateCheckMouseUp
        end
      end
      object pnlLocale: TTntPanel
        AlignWithMargins = True
        Left = 0
        Top = 148
        Width = 326
        Height = 62
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 5
        object lblLang: TTntLabel
          Left = 3
          Top = 0
          Width = 120
          Height = 16
          Caption = '&Language file to use:'
          FocusControl = cboLocale
        end
        object lblLangScan: TTntLabel
          Left = 3
          Top = 46
          Width = 155
          Height = 16
          Cursor = crHandPoint
          Caption = 'Scan for language catalo&gs'
          OnClick = lblLangScanClick
        end
        object cboLocale: TTntComboBox
          Left = 3
          Top = 18
          Width = 225
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 0
          Items.Strings = (
            'English (American)')
        end
      end
    end
  end
end
