inherited frmPrefNetwork: TfrmPrefNetwork
  Left = 254
  Top = 159
  Caption = 'frmPrefNetwork'
  ClientHeight = 766
  ClientWidth = 395
  OldCreateOrder = True
  ExplicitWidth = 407
  ExplicitHeight = 778
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 395
    ExplicitWidth = 422
    inherited lblHeader: TTntLabel
      Width = 146
      Caption = 'Profile Preferences'
      ExplicitWidth = 146
    end
  end
  object pnlContainer: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 30
    Width = 393
    Height = 733
    Margins.Left = 0
    Align = alLeft
    TabOrder = 1
    TabStop = True
    AutoHide = True
    object gbReconnect: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 390
      Height = 84
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      TabOrder = 0
      TabStop = True
      AutoHide = True
      Caption = 'Reconnect options:'
      ExplicitWidth = 416
      object pnlAttempts: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 387
        Height = 29
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 1
        TabStop = True
        AutoHide = True
        ExplicitTop = 17
        ExplicitWidth = 398
        object lblAttempts: TTntLabel
          Left = 0
          Top = 0
          Width = 179
          Height = 16
          Caption = 'Number of reconnect attempts:'
          Transparent = False
        end
        object txtAttempts: TExNumericEdit
          Left = 253
          Top = 0
          Width = 60
          Height = 29
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '0'
          Min = 0
          Max = 1000000
          DesignSize = (
            60
            29)
        end
      end
      object pnlTime: TExBrandPanel
        Left = 0
        Top = 52
        Width = 390
        Height = 32
        Align = alTop
        AutoSize = True
        TabOrder = 2
        TabStop = True
        AutoHide = True
        ExplicitWidth = 416
        object lblTime: TTntLabel
          Left = 0
          Top = 0
          Width = 175
          Height = 16
          Caption = 'Time lapse between attempts:'
          Transparent = False
        end
        object lblTime2: TTntLabel
          Left = 0
          Top = 16
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
          Left = 319
          Top = 2
          Width = 48
          Height = 16
          Caption = 'Seconds'
        end
        object txtTime: TExNumericEdit
          Left = 253
          Top = 0
          Width = 60
          Height = 29
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '0'
          Min = 0
          Max = 3600
          DesignSize = (
            60
            29)
        end
      end
    end
    object gbProxy: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 93
      Width = 390
      Height = 243
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      TabOrder = 1
      TabStop = True
      AutoHide = True
      Caption = 'Proxy type:'
      ExplicitWidth = 416
      object rbIE: TTntRadioButton
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 387
        Height = 17
        Margins.Left = 0
        Align = alTop
        Caption = 'Use IE settings'
        TabOrder = 1
        OnClick = rbIEClick
        ExplicitLeft = 72
        ExplicitTop = 184
        ExplicitWidth = 113
      end
      object rbNone: TTntRadioButton
        AlignWithMargins = True
        Left = 0
        Top = 43
        Width = 387
        Height = 17
        Margins.Left = 0
        Align = alTop
        Caption = 'No HTTP proxy'
        TabOrder = 2
        OnClick = rbIEClick
        ExplicitLeft = 56
        ExplicitTop = 88
        ExplicitWidth = 113
      end
      object rbCustom: TTntRadioButton
        AlignWithMargins = True
        Left = 0
        Top = 66
        Width = 387
        Height = 17
        Margins.Left = 0
        Align = alTop
        Caption = 'rbCustom'
        TabOrder = 3
        OnClick = rbIEClick
        ExplicitWidth = 113
      end
      object pnlProxyInfo: TExBrandPanel
        AlignWithMargins = True
        Left = 6
        Top = 95
        Width = 381
        Height = 54
        Margins.Left = 6
        Margins.Top = 9
        Align = alTop
        AutoSize = True
        TabOrder = 4
        TabStop = True
        AutoHide = True
        ExplicitLeft = 0
        ExplicitTop = 89
        ExplicitWidth = 413
        object lblProxyHost: TTntLabel
          Left = 0
          Top = 3
          Width = 64
          Height = 16
          Caption = 'Proxy host:'
          Transparent = False
        end
        object lblProxyPort: TTntLabel
          Left = 0
          Top = 33
          Width = 63
          Height = 16
          Caption = 'Proxy port:'
          Transparent = True
        end
        object txtProxyHost: TTntEdit
          Left = 70
          Top = 0
          Width = 184
          Height = 24
          TabOrder = 0
        end
        object txtProxyPort: TTntEdit
          Left = 72
          Top = 30
          Width = 53
          Height = 24
          TabOrder = 1
        end
      end
      object pnlAuthInfo: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 161
        Width = 387
        Height = 79
        Margins.Left = 0
        Margins.Top = 9
        Align = alTop
        AutoSize = True
        TabOrder = 5
        TabStop = True
        AutoHide = True
        ExplicitTop = 155
        ExplicitWidth = 413
        object lblProxyUsername: TTntLabel
          Left = 27
          Top = 28
          Width = 67
          Height = 16
          Caption = 'User name:'
          Transparent = False
        end
        object lblProxyPassword: TTntLabel
          Left = 27
          Top = 58
          Width = 60
          Height = 16
          Caption = 'Password:'
          Transparent = False
        end
        object chkProxyAuth: TTntCheckBox
          Left = 6
          Top = 0
          Width = 214
          Height = 21
          Caption = 'Authentication requested'
          Enabled = False
          TabOrder = 0
          OnClick = chkProxyAuthClick
        end
        object txtProxyUsername: TTntEdit
          Left = 100
          Top = 25
          Width = 160
          Height = 24
          TabOrder = 1
        end
        object txtProxyPassword: TTntEdit
          Left = 100
          Top = 55
          Width = 160
          Height = 24
          PasswordChar = '*'
          TabOrder = 2
        end
      end
    end
  end
end
