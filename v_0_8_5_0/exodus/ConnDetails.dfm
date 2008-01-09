object frmConnDetails: TfrmConnDetails
  Left = 253
  Top = 168
  Width = 304
  Height = 305
  ActiveControl = txtUsername
  Caption = 'Connection Details'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial Unicode MS'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
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
    ActivePage = tbsProfile
    Align = alClient
    TabOrder = 1
    object tbsProfile: TTabSheet
      Caption = 'Profile'
      ImageIndex = -1
      object Label3: TLabel
        Left = 9
        Top = 8
        Width = 61
        Height = 16
        Caption = '&Username:'
      end
      object Label10: TLabel
        Left = 8
        Top = 151
        Width = 57
        Height = 16
        Caption = '&Password:'
      end
      object Label11: TLabel
        Left = 9
        Top = 71
        Width = 39
        Height = 16
        Caption = '&Server:'
      end
      object Label12: TLabel
        Left = 9
        Top = 120
        Width = 56
        Height = 16
        Caption = '&Resource:'
      end
      object lblServerList: TLabel
        Left = 82
        Top = 93
        Width = 126
        Height = 15
        Cursor = crHandPoint
        Caption = 'Download a list of servers'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = lblServerListClick
      end
      object Label13: TLabel
        Left = 83
        Top = 32
        Width = 160
        Height = 29
        AutoSize = False
        Caption = 'Enter desired username for new accounts'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object cboServer: TTntComboBox
        Left = 82
        Top = 67
        Width = 152
        Height = 24
        ItemHeight = 16
        TabOrder = 1
        OnKeyPress = txtUsernameKeyPress
        Items.WideStrings = (
          'jabber.org'
          'jabber.com')
      end
      object chkSavePasswd: TCheckBox
        Left = 82
        Top = 173
        Width = 127
        Height = 17
        Caption = 'Save pass&word'
        TabOrder = 4
      end
      object txtUsername: TTntEdit
        Left = 82
        Top = 5
        Width = 152
        Height = 24
        TabOrder = 0
        OnKeyPress = txtUsernameKeyPress
      end
      object txtPassword: TTntEdit
        Left = 82
        Top = 148
        Width = 152
        Height = 24
        PasswordChar = '*'
        TabOrder = 3
      end
      object cboResource: TTntComboBox
        Left = 82
        Top = 117
        Width = 152
        Height = 24
        ItemHeight = 16
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
        Width = 28
        Height = 16
        Caption = 'Host:'
      end
      object Label7: TLabel
        Left = 2
        Top = 65
        Width = 25
        Height = 16
        Caption = 'Port:'
      end
      object Label8: TLabel
        Left = -1
        Top = 9
        Width = 30
        Height = 16
        Alignment = taRightJustify
        Caption = 'Type:'
      end
      object Label6: TLabel
        Left = 2
        Top = 94
        Width = 41
        Height = 16
        Alignment = taRightJustify
        Caption = 'Priority:'
      end
      object txtHost: TEdit
        Left = 59
        Top = 34
        Width = 190
        Height = 24
        TabOrder = 1
      end
      object txtPort: TEdit
        Left = 59
        Top = 62
        Width = 46
        Height = 24
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
        Height = 24
        TabOrder = 4
        Text = '0'
      end
      object spnPriority: TUpDown
        Left = 105
        Top = 90
        Width = 16
        Height = 24
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
        Width = 28
        Height = 16
        Caption = 'Host:'
        Enabled = False
      end
      object lblSocksPort: TLabel
        Left = 5
        Top = 65
        Width = 25
        Height = 16
        Caption = 'Port:'
        Enabled = False
      end
      object lblSocksType: TLabel
        Left = 5
        Top = 13
        Width = 30
        Height = 16
        Caption = 'Type:'
      end
      object lblSocksUsername: TLabel
        Left = 5
        Top = 112
        Width = 61
        Height = 16
        Caption = 'Username:'
        Enabled = False
      end
      object lblSocksPassword: TLabel
        Left = 5
        Top = 140
        Width = 57
        Height = 16
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
        Height = 24
        Enabled = False
        TabOrder = 1
      end
      object txtSocksPort: TEdit
        Left = 75
        Top = 61
        Width = 39
        Height = 24
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
        Height = 24
        Enabled = False
        TabOrder = 4
      end
      object txtSocksPassword: TEdit
        Left = 74
        Top = 136
        Width = 130
        Height = 24
        Enabled = False
        PasswordChar = '*'
        TabOrder = 5
      end
    end
    object tbsHttp: TTabSheet
      Caption = 'HTTP Polling'
      ImageIndex = -1
      object Label1: TLabel
        Left = 2
        Top = 3
        Width = 28
        Height = 16
        Alignment = taRightJustify
        Caption = 'URL:'
      end
      object Label2: TLabel
        Left = 2
        Top = 38
        Width = 55
        Height = 16
        Alignment = taRightJustify
        Caption = 'Poll Time:'
      end
      object Label5: TLabel
        Left = 130
        Top = 39
        Width = 46
        Height = 16
        Caption = 'seconds'
      end
      object Label9: TLabel
        Left = 2
        Top = 73
        Width = 53
        Height = 16
        Caption = '# of Keys:'
      end
      object Label14: TLabel
        Left = 4
        Top = 104
        Width = 249
        Height = 89
        AutoSize = False
        Caption = 
          'NOTE: You must use the URL of your jabber server'#39's HTTP tunnelli' +
          'ng proxy. You can not use some "standard" HTTP proxy for this to' +
          ' work. Contact your server administrator for additional informat' +
          'ion.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial Unicode MS'
        Font.Style = [fsItalic]
        ParentFont = False
        WordWrap = True
      end
      object txtURL: TEdit
        Left = 68
        Top = 2
        Width = 197
        Height = 24
        TabOrder = 0
      end
      object txtTime: TEdit
        Left = 68
        Top = 35
        Width = 53
        Height = 24
        TabOrder = 1
      end
      object txtKeys: TEdit
        Left = 68
        Top = 68
        Width = 53
        Height = 24
        TabOrder = 2
      end
    end
  end
end
