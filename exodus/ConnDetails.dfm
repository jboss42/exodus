object frmConnDetails: TfrmConnDetails
  Left = 253
  Top = 168
  Width = 304
  Height = 305
  ActiveControl = txtURL
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
    Top = 244
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
        inherited btnOK: TButton
          ModalResult = 0
          OnClick = frameButtons1btnOKClick
        end
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 296
    Height = 244
    ActivePage = tbsHttp
    Align = alClient
    TabOrder = 1
    object tbsProfile: TTabSheet
      Caption = 'Profile'
      ImageIndex = -1
      object Label3: TLabel
        Left = 2
        Top = 8
        Width = 51
        Height = 13
        Caption = '&Username:'
      end
      object Label10: TLabel
        Left = 2
        Top = 151
        Width = 49
        Height = 13
        Caption = '&Password:'
      end
      object Label11: TLabel
        Left = 2
        Top = 71
        Width = 34
        Height = 13
        Caption = '&Server:'
      end
      object Label12: TLabel
        Left = 2
        Top = 120
        Width = 49
        Height = 13
        Caption = '&Resource:'
      end
      object lblServerList: TLabel
        Left = 90
        Top = 93
        Width = 121
        Height = 13
        Cursor = crHandPoint
        Caption = 'Download a list of servers'
        OnClick = lblServerListClick
      end
      object Label13: TLabel
        Left = 91
        Top = 32
        Width = 175
        Height = 29
        AutoSize = False
        Caption = 'Enter desired username for new accounts'
        WordWrap = True
      end
      object cboServer: TTntComboBox
        Left = 90
        Top = 67
        Width = 175
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        OnKeyPress = txtUsernameKeyPress
        Items.WideStrings = (
          'jabber.org'
          'jabber.com')
      end
      object chkSavePasswd: TCheckBox
        Left = 90
        Top = 173
        Width = 175
        Height = 17
        Caption = 'Save pass&word'
        TabOrder = 4
      end
      object txtUsername: TTntEdit
        Left = 90
        Top = 5
        Width = 175
        Height = 21
        TabOrder = 0
        OnKeyPress = txtUsernameKeyPress
      end
      object txtPassword: TTntEdit
        Left = 90
        Top = 148
        Width = 175
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
      end
      object cboResource: TTntComboBox
        Left = 90
        Top = 117
        Width = 175
        Height = 21
        ItemHeight = 0
        TabOrder = 2
        OnKeyPress = txtUsernameKeyPress
      end
    end
    object tbsConn: TTabSheet
      Caption = 'Connection'
      ImageIndex = -1
      object Label4: TLabel
        Left = 2
        Top = 38
        Width = 25
        Height = 13
        Caption = 'Host:'
      end
      object Label7: TLabel
        Left = 2
        Top = 65
        Width = 22
        Height = 13
        Caption = 'Port:'
      end
      object Label8: TLabel
        Left = 2
        Top = 9
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'Type:'
      end
      object Label6: TLabel
        Left = 2
        Top = 94
        Width = 34
        Height = 13
        Caption = 'Priority:'
      end
      object txtHost: TEdit
        Left = 59
        Top = 34
        Width = 190
        Height = 21
        TabOrder = 1
      end
      object txtPort: TEdit
        Left = 59
        Top = 62
        Width = 46
        Height = 21
        TabOrder = 2
        Text = '5222'
      end
      object chkSSL: TCheckBox
        Left = 131
        Top = 64
        Width = 93
        Height = 17
        Caption = 'Use SSL'
        TabOrder = 3
        OnClick = chkSSLClick
      end
      object cboConnection: TComboBox
        Left = 59
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
        Items.Strings = (
          'Normal'
          'HTTP')
      end
      object txtPriority: TEdit
        Left = 59
        Top = 90
        Width = 46
        Height = 21
        TabOrder = 4
        Text = '0'
      end
      object spnPriority: TUpDown
        Left = 105
        Top = 90
        Width = 16
        Height = 21
        Associate = txtPriority
        Max = 1000
        TabOrder = 5
      end
    end
    object tbsSocket: TTabSheet
      Caption = 'Proxy'
      ImageIndex = -1
      object lblSocksHost: TLabel
        Left = 5
        Top = 38
        Width = 25
        Height = 13
        Caption = 'Host:'
        Enabled = False
      end
      object lblSocksPort: TLabel
        Left = 5
        Top = 65
        Width = 22
        Height = 13
        Caption = 'Port:'
        Enabled = False
      end
      object lblSocksType: TLabel
        Left = 5
        Top = 13
        Width = 27
        Height = 13
        Caption = 'Type:'
      end
      object lblSocksUsername: TLabel
        Left = 5
        Top = 112
        Width = 51
        Height = 13
        Caption = 'Username:'
        Enabled = False
      end
      object lblSocksPassword: TLabel
        Left = 5
        Top = 140
        Width = 49
        Height = 13
        Caption = 'Password:'
        Enabled = False
      end
      object chkSocksAuth: TCheckBox
        Left = 75
        Top = 85
        Width = 182
        Height = 17
        Caption = 'Authentication Required'
        Enabled = False
        TabOrder = 3
        OnClick = chkSocksAuthClick
      end
      object txtSocksHost: TEdit
        Left = 75
        Top = 34
        Width = 130
        Height = 21
        Enabled = False
        TabOrder = 1
      end
      object txtSocksPort: TEdit
        Left = 75
        Top = 61
        Width = 39
        Height = 21
        Enabled = False
        TabOrder = 2
      end
      object cboSocksType: TComboBox
        Left = 75
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
      object txtSocksUsername: TEdit
        Left = 74
        Top = 108
        Width = 130
        Height = 21
        Enabled = False
        TabOrder = 4
      end
      object txtSocksPassword: TEdit
        Left = 74
        Top = 136
        Width = 130
        Height = 21
        Enabled = False
        PasswordChar = '*'
        TabOrder = 5
      end
    end
    object tbsHttp: TTabSheet
      BorderWidth = 2
      Caption = 'HTTP Polling'
      ImageIndex = -1
      object Label1: TLabel
        Left = 1
        Top = 5
        Width = 25
        Height = 13
        Caption = 'URL:'
      end
      object Label2: TLabel
        Left = 1
        Top = 38
        Width = 46
        Height = 13
        Caption = 'Poll Time:'
      end
      object Label5: TLabel
        Left = 140
        Top = 39
        Width = 40
        Height = 13
        Caption = 'seconds'
      end
      object Label9: TLabel
        Left = 1
        Top = 73
        Width = 48
        Height = 13
        Caption = '# of Keys:'
      end
      object lblNote: TLabel
        Left = 0
        Top = 100
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
      object txtURL: TEdit
        Left = 76
        Top = 2
        Width = 197
        Height = 21
        TabOrder = 0
      end
      object txtTime: TEdit
        Left = 76
        Top = 35
        Width = 53
        Height = 21
        TabOrder = 1
      end
      object txtKeys: TEdit
        Left = 76
        Top = 68
        Width = 53
        Height = 21
        TabOrder = 2
      end
    end
  end
end
