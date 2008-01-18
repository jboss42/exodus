inherited frmPrefSystem: TfrmPrefSystem
  Left = 259
  Top = 156
  Width = 398
  Height = 685
  ActiveControl = chkAutoStart
  Caption = 'frmPrefSystem'
  OldCreateOrder = True
  ExplicitWidth = 398
  ExplicitHeight = 685
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 386
    Font.Style = [fsBold]
    TabOrder = 1
    ExplicitWidth = 386
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
    Top = 30
    Width = 377
    Height = 643
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alLeft
    AutoScroll = True
    TabOrder = 0
    TabStop = True
    AutoHide = True
    object ExGroupBox2: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 377
      Height = 42
      Margins.Left = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      TabOrder = 0
      TabStop = True
      AutoHide = True
      Caption = 'When I start my computer:'
      ExplicitTop = 0
      object chkAutoStart: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 17
        Width = 374
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
      Top = 51
      Width = 377
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
        Width = 374
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
        Width = 374
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
        Width = 374
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
        Width = 374
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
      Top = 167
      Width = 377
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
        Width = 374
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
        Width = 374
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
        Width = 374
        Height = 25
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 3
        TabStop = True
        AutoHide = True
        object btnPlugins: TTntButton
          Left = 3
          Top = 0
          Width = 120
          Height = 25
          Caption = 'Manage Plu&gins...'
          TabOrder = 0
          OnClick = btnPluginsClick
        end
      end
    end
    object ExGroupBox3: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 406
      Width = 377
      Height = 213
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      TabOrder = 4
      TabStop = True
      AutoHide = True
      Caption = 'Advanced system preferences:'
      ExplicitTop = 404
      object chkToolbox: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 61
        Width = 374
        Height = 22
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
        Top = 17
        Width = 374
        Height = 22
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
        Top = 39
        Width = 374
        Height = 22
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
        Top = 83
        Width = 374
        Height = 23
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
        Top = 109
        Width = 374
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
          Caption = 'Check for updates automatically'
          TabOrder = 0
        end
        object btnUpdateCheck: TTntButton
          Left = 229
          Top = 0
          Width = 98
          Height = 33
          Caption = 'Check Now'
          TabOrder = 1
          OnClick = btnUpdateCheckClick
          OnMouseUp = btnUpdateCheckMouseUp
        end
      end
      object pnlLocale: TTntPanel
        AlignWithMargins = True
        Left = 0
        Top = 148
        Width = 374
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
          Caption = 'Language file to use:'
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
    object gbReconnect: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 309
      Width = 374
      Height = 88
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      TabOrder = 3
      TabStop = True
      AutoHide = True
      Caption = 'Reconnect options:'
      object pnlAttempts: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 371
        Height = 31
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 1
        TabStop = True
        AutoHide = True
        object lblAttempts: TTntLabel
          Left = 0
          Top = 7
          Width = 179
          Height = 16
          Caption = 'Num&ber of reconnect attempts:'
          FocusControl = txtAttempts
          Transparent = False
        end
        object txtAttempts: TExNumericEdit
          Left = 229
          Top = 0
          Width = 60
          Height = 31
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '0'
          Min = 0
          Max = 1000000
          DesignSize = (
            60
            31)
        end
      end
      object pnlTime: TExBrandPanel
        Left = 0
        Top = 54
        Width = 374
        Height = 34
        Align = alTop
        AutoSize = True
        TabOrder = 2
        TabStop = True
        AutoHide = True
        object lblTime: TTntLabel
          Left = 0
          Top = 3
          Width = 175
          Height = 16
          Caption = 'Time &lapse between attempts:'
          FocusControl = txtTime
          Transparent = False
        end
        object lblTime2: TTntLabel
          Left = 0
          Top = 18
          Width = 186
          Height = 16
          Caption = 'Use 0 for a random time interval'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = cl3DDkShadow
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = False
        end
        object lblSeconds: TTntLabel
          Left = 295
          Top = 3
          Width = 48
          Height = 16
          Caption = 'Seconds'
        end
        object txtTime: TExNumericEdit
          Left = 229
          Top = 0
          Width = 60
          Height = 31
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '0'
          Min = 0
          Max = 3600
          DesignSize = (
            60
            31)
        end
      end
    end
  end
end
