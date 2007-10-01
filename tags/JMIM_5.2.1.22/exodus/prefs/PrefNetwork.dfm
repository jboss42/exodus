inherited frmPrefNetwork: TfrmPrefNetwork
  Left = 254
  Top = 159
  Caption = 'frmPrefNetwork'
  ClientHeight = 326
  ClientWidth = 343
  OldCreateOrder = True
  ExplicitWidth = 355
  ExplicitHeight = 338
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 343
    Caption = 'Network'
    TabOrder = 2
    ExplicitWidth = 343
  end
  object GroupBox1: TTntGroupBox
    Left = 3
    Top = 29
    Width = 294
    Height = 97
    Caption = 'Reconnect Options'
    TabOrder = 0
    object lblAttempts: TTntLabel
      Left = 8
      Top = 20
      Width = 121
      Height = 13
      Caption = '# of Reconnect attempts:'
      Transparent = False
    end
    object lblTime: TTntLabel
      Left = 8
      Top = 52
      Width = 141
      Height = 13
      Caption = 'Time lapse between attempts:'
      Transparent = False
    end
    object lblTime2: TTntLabel
      Left = 9
      Top = 71
      Width = 240
      Height = 13
      Caption = 'Time is in seconds. Use 0 for a random time period.'
      Transparent = False
    end
    object txtAttempts: TExNumericEdit
      Left = 200
      Top = 16
      Width = 49
      Height = 25
      BevelOuter = bvNone
      TabOrder = 1
      Text = '0'
      Min = 0
      Max = 1000000
      DesignSize = (
        49
        25)
    end
    object txtTime: TExNumericEdit
      Left = 200
      Top = 48
      Width = 49
      Height = 25
      BevelOuter = bvNone
      TabOrder = 0
      Text = '0'
      Min = 0
      Max = 3600
      DesignSize = (
        49
        25)
    end
  end
  object GroupBox2: TTntGroupBox
    Left = 3
    Top = 135
    Width = 294
    Height = 178
    Caption = 'HTTP Proxy'
    TabOrder = 1
    object lblProxyHost: TTntLabel
      Left = 5
      Top = 48
      Width = 25
      Height = 13
      Caption = 'Host:'
      Enabled = False
      Transparent = False
    end
    object lblProxyPort: TTntLabel
      Left = 5
      Top = 74
      Width = 22
      Height = 13
      Caption = 'Port:'
      Enabled = False
      Transparent = False
    end
    object lblProxyUsername: TTntLabel
      Left = 5
      Top = 122
      Width = 51
      Height = 13
      Caption = 'Username:'
      Enabled = False
      Transparent = False
    end
    object lblProxyPassword: TTntLabel
      Left = 5
      Top = 145
      Width = 49
      Height = 13
      Caption = 'Password:'
      Enabled = False
      Transparent = False
    end
    object lblProxyApproach: TLabel
      Left = 5
      Top = 21
      Width = 49
      Height = 13
      Caption = 'Approach:'
      Transparent = False
    end
    object txtProxyHost: TTntEdit
      Left = 107
      Top = 44
      Width = 130
      Height = 21
      Enabled = False
      TabOrder = 1
    end
    object txtProxyPort: TTntEdit
      Left = 107
      Top = 70
      Width = 39
      Height = 21
      Enabled = False
      TabOrder = 2
    end
    object chkProxyAuth: TTntCheckBox
      Left = 107
      Top = 95
      Width = 174
      Height = 17
      Caption = 'Authentication Required'
      Enabled = False
      TabOrder = 3
      OnClick = chkProxyAuthClick
    end
    object txtProxyUsername: TTntEdit
      Left = 107
      Top = 117
      Width = 130
      Height = 21
      Enabled = False
      TabOrder = 4
    end
    object txtProxyPassword: TTntEdit
      Left = 107
      Top = 143
      Width = 130
      Height = 21
      Enabled = False
      PasswordChar = '*'
      TabOrder = 5
    end
    object cboProxyApproach: TTntComboBox
      Left = 107
      Top = 17
      Width = 130
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cboProxyApproachChange
      Items.Strings = (
        'Use IE Settings'
        'No HTTP Proxy'
        'Custom HTTP Proxy')
    end
  end
end
