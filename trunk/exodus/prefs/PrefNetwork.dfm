inherited frmPrefNetwork: TfrmPrefNetwork
  Left = 270
  Top = 426
  Caption = 'frmPrefNetwork'
  ClientHeight = 326
  ClientWidth = 343
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 3
    Top = 29
    Width = 294
    Height = 97
    Caption = 'Reconnect Options'
    TabOrder = 0
    object Label2: TTntLabel
      Left = 8
      Top = 20
      Width = 121
      Height = 13
      Caption = '# of Reconnect attempts:'
    end
    object Label3: TTntLabel
      Left = 8
      Top = 52
      Width = 141
      Height = 13
      Caption = 'Time lapse between attempts:'
    end
    object Label4: TTntLabel
      Left = 9
      Top = 71
      Width = 240
      Height = 13
      Caption = 'Time is in seconds. Use 0 for a random time period.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object txtReconnectTries: TTntEdit
      Left = 168
      Top = 16
      Width = 33
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object spnAttempts: TUpDown
      Left = 201
      Top = 16
      Width = 16
      Height = 21
      Associate = txtReconnectTries
      TabOrder = 1
    end
    object txtReconnectTime: TTntEdit
      Left = 168
      Top = 48
      Width = 33
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object spnTime: TUpDown
      Left = 201
      Top = 48
      Width = 16
      Height = 21
      Associate = txtReconnectTime
      Max = 3600
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 3
    Top = 135
    Width = 294
    Height = 172
    Caption = 'HTTP Proxy'
    TabOrder = 1
    object lblProxyHost: TTntLabel
      Left = 5
      Top = 53
      Width = 25
      Height = 13
      Caption = 'Host:'
      Enabled = False
    end
    object lblProxyPort: TTntLabel
      Left = 5
      Top = 76
      Width = 22
      Height = 13
      Caption = 'Port:'
      Enabled = False
    end
    object lblProxyUsername: TTntLabel
      Left = 5
      Top = 121
      Width = 51
      Height = 13
      Caption = 'Username:'
      Enabled = False
    end
    object lblProxyPassword: TTntLabel
      Left = 5
      Top = 144
      Width = 49
      Height = 13
      Caption = 'Password:'
      Enabled = False
    end
    object Label28: TLabel
      Left = 5
      Top = 28
      Width = 49
      Height = 13
      Caption = 'Approach:'
    end
    object txtProxyHost: TTntEdit
      Left = 59
      Top = 49
      Width = 130
      Height = 21
      Enabled = False
      TabOrder = 1
    end
    object txtProxyPort: TTntEdit
      Left = 59
      Top = 72
      Width = 39
      Height = 21
      Enabled = False
      TabOrder = 2
    end
    object chkProxyAuth: TTntCheckBox
      Left = 59
      Top = 94
      Width = 135
      Height = 17
      Caption = 'Authentication Required'
      Enabled = False
      TabOrder = 3
      OnClick = chkProxyAuthClick
    end
    object txtProxyUsername: TTntEdit
      Left = 59
      Top = 116
      Width = 130
      Height = 21
      Enabled = False
      TabOrder = 4
    end
    object txtProxyPassword: TTntEdit
      Left = 59
      Top = 142
      Width = 130
      Height = 21
      Enabled = False
      PasswordChar = '*'
      TabOrder = 5
    end
    object cboProxyApproach: TTntComboBox
      Left = 59
      Top = 24
      Width = 130
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 0
      Text = 'Use IE settings'
      OnChange = cboProxyApproachChange
      Items.WideStrings = (
        'Use IE settings'
        'Direct Connection'
        'Custom')
    end
  end
  object StaticText4: TTntPanel
    Left = 0
    Top = 0
    Width = 343
    Height = 24
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Connection Options'
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
  end
end
