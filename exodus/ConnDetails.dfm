object frmConnDetails: TfrmConnDetails
  Left = 249
  Top = 169
  Width = 304
  Height = 307
  ActiveControl = txtUsername
  Caption = 'Connection Details'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 241
    Width = 296
    Height = 32
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Panel2: TPanel
      Width = 296
      Height = 32
      inherited Bevel1: TBevel
        Width = 296
      end
      inherited Panel1: TPanel
        Left = 136
        Height = 27
        inherited btnOK: TTntButton
          ModalResult = 0
          OnClick = frameButtons1btnOKClick
        end
      end
    end
  end
  object PageControl1: TTntPageControl
    Left = 0
    Top = 0
    Width = 296
    Height = 241
    ActivePage = tbsProfile
    Align = alClient
    TabOrder = 1
    object tbsProfile: TTntTabSheet
      Caption = 'Profile'
      ImageIndex = -1
      object lblUsername: TTntLabel
        Left = 2
        Top = 8
        Width = 51
        Height = 13
        Caption = 'Username:'
        Transparent = True
      end
      object Label10: TTntLabel
        Left = 2
        Top = 151
        Width = 49
        Height = 13
        Caption = 'Password:'
        Transparent = True
      end
      object Label11: TTntLabel
        Left = 2
        Top = 71
        Width = 34
        Height = 13
        Caption = 'Server:'
        Transparent = True
      end
      object Label12: TTntLabel
        Left = 2
        Top = 120
        Width = 49
        Height = 13
        Caption = 'Resource:'
        Transparent = True
      end
      object lblServerList: TTntLabel
        Left = 100
        Top = 93
        Width = 121
        Height = 13
        Cursor = crHandPoint
        Caption = 'Download a list of servers'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = lblServerListClick
      end
      object Label13: TTntLabel
        Left = 100
        Top = 32
        Width = 170
        Height = 29
        AutoSize = False
        Caption = 'Enter desired username for new accounts.'
        WordWrap = True
      end
      object cboServer: TTntComboBox
        Left = 100
        Top = 67
        Width = 170
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        OnKeyPress = txtUsernameKeyPress
        Items.WideStrings = (
          'jabber.org'
          'jabber.com')
      end
      object chkSavePasswd: TTntCheckBox
        Left = 100
        Top = 173
        Width = 170
        Height = 17
        Caption = 'Save pass&word'
        TabOrder = 4
      end
      object txtUsername: TTntEdit
        Left = 100
        Top = 5
        Width = 170
        Height = 21
        TabOrder = 0
        OnKeyPress = txtUsernameKeyPress
      end
      object txtPassword: TTntEdit
        Left = 100
        Top = 148
        Width = 170
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
      end
      object cboResource: TTntComboBox
        Left = 100
        Top = 117
        Width = 170
        Height = 21
        ItemHeight = 13
        TabOrder = 2
        OnKeyPress = txtUsernameKeyPress
      end
      object chkRegister: TTntCheckBox
        Left = 100
        Top = 190
        Width = 181
        Height = 17
        Caption = 'This is a new account'
        TabOrder = 5
      end
    end
    object tbsConn: TTntTabSheet
      Caption = 'Connection'
      ImageIndex = -1
      object Label8: TTntLabel
        Left = 2
        Top = 9
        Width = 27
        Height = 13
        Caption = 'Type:'
        Transparent = True
      end
      object Label6: TTntLabel
        Left = 2
        Top = 38
        Width = 34
        Height = 13
        Caption = 'Priority:'
        Transparent = True
      end
      object cboConnection: TTntComboBox
        Left = 75
        Top = 7
        Width = 191
        Height = 21
        Style = csOwnerDrawFixed
        DropDownCount = 2
        ItemHeight = 15
        ItemIndex = 0
        TabOrder = 0
        Text = 'Normal'
        OnChange = cboConnectionChange
        Items.WideStrings = (
          'Normal'
          'HTTP')
      end
      object txtPriority: TTntEdit
        Left = 75
        Top = 34
        Width = 46
        Height = 21
        TabOrder = 1
        Text = '0'
      end
      object spnPriority: TUpDown
        Left = 121
        Top = 34
        Width = 16
        Height = 21
        Associate = txtPriority
        Max = 1000
        TabOrder = 2
      end
      object chkSRV: TTntCheckBox
        Left = 4
        Top = 74
        Width = 269
        Height = 17
        Caption = 'Automatically discover host and port'
        TabOrder = 3
        OnClick = chkSRVClick
      end
      object boxHost: TTntGroupBox
        Left = 7
        Top = 92
        Width = 225
        Height = 81
        TabOrder = 4
        object Label4: TTntLabel
          Left = 6
          Top = 17
          Width = 25
          Height = 13
          Caption = 'Host:'
          Transparent = True
        end
        object Label7: TTntLabel
          Left = 6
          Top = 44
          Width = 22
          Height = 13
          Caption = 'Port:'
          Transparent = True
        end
        object txtHost: TTntEdit
          Left = 55
          Top = 13
          Width = 158
          Height = 21
          TabOrder = 0
        end
        object txtPort: TTntEdit
          Left = 55
          Top = 41
          Width = 46
          Height = 21
          TabOrder = 1
          Text = '5222'
        end
      end
    end
    object tbsSSL: TTntTabSheet
      Caption = 'SSL'
      object TntLabel1: TTntLabel
        Left = 1
        Top = 9
        Width = 73
        Height = 13
        Caption = 'SSL Certificate:'
        Transparent = True
      end
      object txtSSLCert: TTntEdit
        Left = 18
        Top = 29
        Width = 190
        Height = 21
        TabOrder = 0
      end
      object btnCertBrowse: TTntButton
        Left = 213
        Top = 28
        Width = 72
        Height = 25
        Caption = 'Browse'
        TabOrder = 1
        OnClick = btnCertBrowseClick
      end
      object optSSL: TRadioGroup
        Left = 8
        Top = 72
        Width = 273
        Height = 81
        Items.Strings = (
          'Use StartTLS whenever the server allows it.'
          'Only allow connections which use StartTLS.'
          'Use SSL immediately when connected.')
        TabOrder = 2
        OnClick = optSSLClick
      end
    end
    object tbsSocket: TTntTabSheet
      Caption = 'Proxy'
      ImageIndex = -1
      object lblSocksHost: TTntLabel
        Left = 5
        Top = 38
        Width = 25
        Height = 13
        Caption = 'Host:'
        Enabled = False
        Transparent = True
      end
      object lblSocksPort: TTntLabel
        Left = 5
        Top = 65
        Width = 22
        Height = 13
        Caption = 'Port:'
        Enabled = False
        Transparent = True
      end
      object lblSocksType: TTntLabel
        Left = 5
        Top = 13
        Width = 27
        Height = 13
        Caption = 'Type:'
        Transparent = True
      end
      object lblSocksUsername: TTntLabel
        Left = 5
        Top = 112
        Width = 51
        Height = 13
        Caption = 'Username:'
        Enabled = False
        Transparent = True
      end
      object lblSocksPassword: TTntLabel
        Left = 5
        Top = 140
        Width = 49
        Height = 13
        Caption = 'Password:'
        Enabled = False
        Transparent = True
      end
      object chkSocksAuth: TTntCheckBox
        Left = 91
        Top = 85
        Width = 190
        Height = 17
        Caption = 'Authentication Required'
        Enabled = False
        TabOrder = 3
        OnClick = chkSocksAuthClick
      end
      object txtSocksHost: TTntEdit
        Left = 91
        Top = 34
        Width = 130
        Height = 21
        Enabled = False
        TabOrder = 1
      end
      object txtSocksPort: TTntEdit
        Left = 91
        Top = 61
        Width = 39
        Height = 21
        Enabled = False
        TabOrder = 2
      end
      object cboSocksType: TComboBox
        Left = 91
        Top = 8
        Width = 130
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 0
        OnChange = cboSocksTypeChange
        Items.Strings = (
          'None'
          'Version 4'
          'Version 4a'
          'Version 5'
          'HTTP')
      end
      object txtSocksUsername: TTntEdit
        Left = 90
        Top = 108
        Width = 130
        Height = 21
        Enabled = False
        TabOrder = 4
      end
      object txtSocksPassword: TTntEdit
        Left = 90
        Top = 136
        Width = 130
        Height = 21
        Enabled = False
        PasswordChar = '*'
        TabOrder = 5
      end
    end
    object tbsHttp: TTntTabSheet
      BorderWidth = 2
      Caption = 'HTTP Polling'
      ImageIndex = -1
      object Label1: TTntLabel
        Left = 1
        Top = 5
        Width = 25
        Height = 13
        Caption = 'URL:'
        Transparent = True
      end
      object Label2: TTntLabel
        Left = 1
        Top = 38
        Width = 46
        Height = 13
        Caption = 'Poll Time:'
        Transparent = True
      end
      object Label5: TTntLabel
        Left = 140
        Top = 39
        Width = 40
        Height = 13
        Caption = 'seconds'
      end
      object Label9: TTntLabel
        Left = 1
        Top = 73
        Width = 48
        Height = 13
        Caption = '# of Keys:'
        Transparent = True
      end
      object lblNote: TTntLabel
        Left = 0
        Top = 97
        Width = 284
        Height = 112
        Align = alBottom
        AutoSize = False
        Caption = 
          'NOTE: You must use the URL of your jabber server'#39's HTTP tunnelli' +
          'ng proxy. You can not use some "standard" HTTP proxy for this to' +
          ' work. Contact your server administrator for additional informat' +
          'ion.'
        WordWrap = True
      end
      object txtURL: TTntEdit
        Left = 76
        Top = 2
        Width = 197
        Height = 21
        TabOrder = 0
      end
      object txtTime: TTntEdit
        Left = 76
        Top = 35
        Width = 53
        Height = 21
        TabOrder = 1
      end
      object txtKeys: TTntEdit
        Left = 76
        Top = 68
        Width = 53
        Height = 21
        TabOrder = 2
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'pem'
    Filter = 'SSL Key Files|*.pem|All Files|*.*'
    Left = 8
    Top = 288
  end
end
