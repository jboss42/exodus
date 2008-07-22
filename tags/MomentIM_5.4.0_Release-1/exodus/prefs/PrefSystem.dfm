inherited frmPrefSystem: TfrmPrefSystem
  Left = 259
  Top = 156
  ActiveControl = chkAutoStart
  Caption = 'frmPrefSystem'
  ClientHeight = 674
  OldCreateOrder = True
  ExplicitHeight = 686
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Font.Style = [fsBold]
    TabOrder = 1
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 55
      Height = 19
      Caption = 'System'
      ExplicitLeft = 6
      ExplicitWidth = 55
    end
  end
  object gbParentGroup: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 31
    Width = 375
    Height = 643
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    AutoHide = True
    object ExGroupBox2: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 375
      Height = 42
      Margins.Left = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'When I start my computer'
      ParentColor = True
      TabOrder = 0
      AutoHide = True
      object chkAutoStart: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 372
        Height = 24
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
      Top = 51
      Width = 375
      Height = 101
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 4
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'When I start Exodus'
      ParentColor = True
      TabOrder = 1
      AutoHide = True
      object chkAutoLogin: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 372
        Height = 20
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
        Top = 38
        Width = 372
        Height = 22
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Start contact list &minimized to the System Tray'
        TabOrder = 1
      end
      object chkRestoreDesktop: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 60
        Width = 372
        Height = 20
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
        Top = 80
        Width = 372
        Height = 21
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
      Top = 162
      Width = 375
      Height = 125
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Other system preferences'
      ParentColor = True
      TabOrder = 2
      AutoHide = True
      object chkSaveWindowState: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 372
        Height = 20
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
        Top = 41
        Width = 372
        Height = 53
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object lblDockPref: TTntLabel
          Left = 4
          Top = 0
          Width = 108
          Height = 16
          Caption = 'Show all windows:'
          FocusControl = rbDocked
        end
        object rbDocked: TTntRadioButton
          Left = 16
          Top = 17
          Width = 286
          Height = 16
          Caption = '&Docked'
          TabOrder = 0
          TabStop = True
        end
        object rbUndocked: TTntRadioButton
          Left = 16
          Top = 36
          Width = 286
          Height = 17
          Caption = '&Undocked'
          TabOrder = 1
          TabStop = True
        end
      end
      object ExBrandPanel1: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 100
        Width = 372
        Height = 23
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        AutoHide = True
        object btnPlugins: TTntButton
          Left = 4
          Top = 0
          Width = 134
          Height = 23
          Caption = 'Manage Plu&g-ins...'
          TabOrder = 0
          OnClick = btnPluginsClick
        end
      end
    end
    object ExGroupBox3: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 405
      Width = 375
      Height = 196
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Advanced system preferences'
      ParentColor = True
      TabOrder = 4
      AutoHide = True
      object chkToolbox: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 59
        Width = 372
        Height = 19
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Small titlebar for main window'
        TabOrder = 2
      end
      object chkCloseMin: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 372
        Height = 20
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Close button minimizes to the System Tray'
        TabOrder = 0
      end
      object chkSingleInstance: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 38
        Width = 372
        Height = 21
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Only allow a single, running instance'
        TabOrder = 1
      end
      object chkOnTop: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 78
        Width = 372
        Height = 21
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Always on top'
        TabOrder = 3
        Visible = False
      end
      object pnlAutoUpdates: TTntPanel
        AlignWithMargins = True
        Left = 0
        Top = 102
        Width = 372
        Height = 26
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        object chkAutoUpdate: TTntCheckBox
          Left = 2
          Top = 5
          Width = 224
          Height = 20
          Caption = 'Check for updates automatically'
          TabOrder = 0
        end
        object btnUpdateCheck: TTntButton
          Left = 230
          Top = 0
          Width = 90
          Height = 26
          Caption = 'Check Now'
          TabOrder = 1
          OnClick = btnUpdateCheckClick
          OnMouseUp = btnUpdateCheckMouseUp
        end
      end
      object pnlLocale: TTntPanel
        AlignWithMargins = True
        Left = 0
        Top = 134
        Width = 372
        Height = 59
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 5
        object lblLang: TTntLabel
          Left = 2
          Top = 0
          Width = 120
          Height = 16
          Caption = 'Language file to use:'
          FocusControl = cboLocale
        end
        object lblLangScan: TTntLabel
          Left = 2
          Top = 43
          Width = 155
          Height = 16
          Cursor = crHandPoint
          Caption = 'Scan for language catalo&gs'
          OnClick = lblLangScanClick
        end
        object cboLocale: TTntComboBox
          Left = 2
          Top = 17
          Width = 208
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 0
          Items.Strings = (
            'English (American)')
        end
      end
    end
    object gbReconnect: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 296
      Width = 372
      Height = 100
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Reconnect options'
      Padding.Bottom = 6
      ParentColor = True
      TabOrder = 3
      AutoHide = True
      object pnlAttempts: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 21
        Width = 369
        Height = 31
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        object lblAttempts: TTntLabel
          Left = 0
          Top = 4
          Width = 179
          Height = 16
          Caption = 'Num&ber of reconnect attempts:'
          FocusControl = txtAttempts
          Transparent = False
        end
        object txtAttempts: TExNumericEdit
          Left = 210
          Top = 0
          Width = 56
          Height = 38
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '0'
          Min = 0
          Max = 1000000
          DesignSize = (
            56
            38)
        end
      end
      object pnlTime: TExBrandPanel
        Left = 0
        Top = 55
        Width = 372
        Height = 39
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        object lblTime: TTntLabel
          Left = 0
          Top = 4
          Width = 175
          Height = 16
          Caption = '&Time lapse between attempts:'
          FocusControl = txtTime
          Transparent = False
        end
        object lblTime2: TTntLabel
          Left = 0
          Top = 21
          Width = 213
          Height = 18
          Caption = 'Use 0 for a random time interval'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = False
        end
        object lblSeconds: TTntLabel
          Left = 274
          Top = 4
          Width = 48
          Height = 16
          Caption = 'Seconds'
        end
        object txtTime: TExNumericEdit
          Left = 210
          Top = 0
          Width = 56
          Height = 38
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '0'
          Min = 0
          Max = 3600
          DesignSize = (
            56
            38)
        end
      end
    end
  end
end
