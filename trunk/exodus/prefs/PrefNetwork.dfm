inherited frmPrefNetwork: TfrmPrefNetwork
  Left = 270
  Top = 426
  Caption = 'frmPrefNetwork'
  ClientHeight = 326
  ClientWidth = 343
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 343
    Caption = 'Connection Options'
    TabOrder = 2
  end
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
    end
    object txtReconnectTries: TTntEdit
      Left = 200
      Top = 16
      Width = 33
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object spnAttempts: TUpDown
      Left = 233
      Top = 16
      Width = 16
      Height = 21
      Associate = txtReconnectTries
      TabOrder = 1
    end
    object txtReconnectTime: TTntEdit
      Left = 200
      Top = 48
      Width = 33
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object spnTime: TUpDown
      Left = 233
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
    Height = 186
    Caption = 'HTTP Proxy'
    TabOrder = 1
    object lblProxyHost: TTntLabel
      Left = 5
      Top = 55
      Width = 25
      Height = 13
      Caption = 'Host:'
      Enabled = False
    end
    object lblProxyPort: TTntLabel
      Left = 5
      Top = 81
      Width = 22
      Height = 13
      Caption = 'Port:'
      Enabled = False
    end
    object lblProxyUsername: TTntLabel
      Left = 5
      Top = 129
      Width = 51
      Height = 13
      Caption = 'Username:'
      Enabled = False
    end
    object lblProxyPassword: TTntLabel
      Left = 5
      Top = 152
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
      Left = 107
      Top = 51
      Width = 130
      Height = 21
      Enabled = False
      TabOrder = 1
    end
    object txtProxyPort: TTntEdit
      Left = 107
      Top = 77
      Width = 39
      Height = 21
      Enabled = False
      TabOrder = 2
    end
    object chkProxyAuth: TTntCheckBox
      Left = 107
      Top = 102
      Width = 135
      Height = 17
      Caption = 'Authentication Required'
      Enabled = False
      TabOrder = 3
      OnClick = chkProxyAuthClick
    end
    object txtProxyUsername: TTntEdit
      Left = 107
      Top = 124
      Width = 130
      Height = 21
      Enabled = False
      TabOrder = 4
    end
    object txtProxyPassword: TTntEdit
      Left = 107
      Top = 150
      Width = 130
      Height = 21
      Enabled = False
      PasswordChar = '*'
      TabOrder = 5
    end
    object cboProxyApproach: TTntComboBox
      Left = 107
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
end
