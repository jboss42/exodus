object frmConnDetails: TfrmConnDetails
  Left = 245
  Top = 199
  Width = 260
  Height = 366
  Caption = 'Connection Details'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 252
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label8: TLabel
      Left = 8
      Top = 9
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = 'Connection Type:'
    end
    object Label6: TLabel
      Left = 10
      Top = 41
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Priority:'
    end
    object Bevel1: TBevel
      Left = 0
      Top = 60
      Width = 252
      Height = 5
      Align = alBottom
      Shape = bsBottomLine
    end
    object cboConnection: TComboBox
      Left = 98
      Top = 7
      Width = 103
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
      Left = 98
      Top = 37
      Width = 46
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object spnPriority: TUpDown
      Left = 144
      Top = 37
      Width = 16
      Height = 21
      Associate = txtPriority
      Min = 0
      Max = 1000
      Position = 0
      TabOrder = 2
      Wrap = False
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 300
    Width = 252
    Height = 32
    Align = alBottom
    AutoScroll = False
    TabOrder = 1
    inherited Bevel1: TBevel
      Width = 252
    end
    inherited Panel1: TPanel
      Left = 92
      inherited btnOK: TButton
        ModalResult = 0
        OnClick = frameButtons1btnOKClick
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 65
    Width = 252
    Height = 235
    ActivePage = tbsSocket
    Align = alClient
    Style = tsFlatButtons
    TabIndex = 0
    TabOrder = 2
    object tbsSocket: TTabSheet
      Caption = 'tbsSocket'
      object Label4: TLabel
        Left = 6
        Top = 6
        Width = 25
        Height = 13
        Caption = 'Host:'
      end
      object Label7: TLabel
        Left = 6
        Top = 30
        Width = 22
        Height = 13
        Caption = 'Port:'
      end
      object txtHost: TEdit
        Left = 43
        Top = 2
        Width = 190
        Height = 21
        TabOrder = 0
      end
      object txtPort: TEdit
        Left = 43
        Top = 27
        Width = 39
        Height = 21
        TabOrder = 1
        Text = '5222'
      end
      object chkSSL: TCheckBox
        Left = 100
        Top = 31
        Width = 93
        Height = 17
        Caption = 'Use SSL'
        TabOrder = 2
        OnClick = chkSSLClick
      end
      object GroupBox2: TGroupBox
        Left = 6
        Top = 53
        Width = 225
        Height = 169
        Caption = 'SOCKS'
        TabOrder = 3
        object lblSocksHost: TLabel
          Left = 5
          Top = 46
          Width = 25
          Height = 13
          Caption = 'Host:'
          Enabled = False
        end
        object lblSocksPort: TLabel
          Left = 5
          Top = 71
          Width = 22
          Height = 13
          Caption = 'Port:'
          Enabled = False
        end
        object lblSocksType: TLabel
          Left = 5
          Top = 21
          Width = 27
          Height = 13
          Caption = 'Type:'
        end
        object lblSocksUsername: TLabel
          Left = 5
          Top = 116
          Width = 51
          Height = 13
          Caption = 'Username:'
          Enabled = False
        end
        object lblSocksPassword: TLabel
          Left = 5
          Top = 141
          Width = 49
          Height = 13
          Caption = 'Password:'
          Enabled = False
        end
        object chkSocksAuth: TCheckBox
          Left = 59
          Top = 89
          Width = 135
          Height = 17
          Caption = 'Authentication Required'
          Enabled = False
          TabOrder = 3
          OnClick = chkSocksAuthClick
        end
        object txtSocksHost: TEdit
          Left = 59
          Top = 42
          Width = 130
          Height = 21
          Enabled = False
          TabOrder = 1
        end
        object txtSocksPort: TEdit
          Left = 59
          Top = 67
          Width = 39
          Height = 21
          Enabled = False
          TabOrder = 2
        end
        object cboSocksType: TComboBox
          Left = 59
          Top = 16
          Width = 130
          Height = 22
          Style = csOwnerDrawFixed
          ItemHeight = 16
          ItemIndex = 0
          TabOrder = 0
          Text = 'None'
          OnChange = cboSocksTypeChange
          Items.Strings = (
            'None'
            'Version 4'
            'Version 4a'
            'Version 5')
        end
        object txtSocksUsername: TEdit
          Left = 58
          Top = 112
          Width = 130
          Height = 21
          Enabled = False
          TabOrder = 4
        end
        object txtSocksPassword: TEdit
          Left = 58
          Top = 137
          Width = 130
          Height = 21
          Enabled = False
          PasswordChar = '*'
          TabOrder = 5
        end
      end
    end
    object tbsHttp: TTabSheet
      Caption = 'tbsHttp'
      ImageIndex = 1
      object Label1: TLabel
        Left = 6
        Top = 3
        Width = 25
        Height = 13
        Alignment = taRightJustify
        Caption = 'URL:'
      end
      object Label2: TLabel
        Left = 6
        Top = 30
        Width = 46
        Height = 13
        Alignment = taRightJustify
        Caption = 'Poll Time:'
      end
      object Label5: TLabel
        Left = 122
        Top = 31
        Width = 40
        Height = 13
        Caption = 'seconds'
      end
      object txtURL: TEdit
        Left = 68
        Top = 2
        Width = 130
        Height = 21
        TabOrder = 0
      end
      object txtTime: TEdit
        Left = 68
        Top = 27
        Width = 50
        Height = 21
        TabOrder = 1
      end
      object GroupBox1: TGroupBox
        Left = 6
        Top = 53
        Width = 214
        Height = 172
        Caption = 'HTTP Proxy'
        TabOrder = 2
        object lblProxyHost: TLabel
          Left = 5
          Top = 53
          Width = 25
          Height = 13
          Caption = 'Host:'
          Enabled = False
        end
        object lblProxyPort: TLabel
          Left = 5
          Top = 76
          Width = 22
          Height = 13
          Caption = 'Port:'
          Enabled = False
        end
        object lblProxyUsername: TLabel
          Left = 5
          Top = 121
          Width = 51
          Height = 13
          Caption = 'Username:'
          Enabled = False
        end
        object lblProxyPassword: TLabel
          Left = 5
          Top = 144
          Width = 49
          Height = 13
          Caption = 'Password:'
          Enabled = False
        end
        object Label3: TLabel
          Left = 5
          Top = 28
          Width = 49
          Height = 13
          Caption = 'Approach:'
        end
        object txtProxyHost: TEdit
          Left = 59
          Top = 49
          Width = 130
          Height = 21
          Enabled = False
          TabOrder = 0
        end
        object txtProxyPort: TEdit
          Left = 59
          Top = 72
          Width = 39
          Height = 21
          Enabled = False
          TabOrder = 1
        end
        object chkProxyAuth: TCheckBox
          Left = 59
          Top = 94
          Width = 135
          Height = 17
          Caption = 'Authentication Required'
          Enabled = False
          TabOrder = 2
          OnClick = chkProxyAuthClick
        end
        object txtProxyUsername: TEdit
          Left = 59
          Top = 116
          Width = 130
          Height = 21
          Enabled = False
          TabOrder = 3
        end
        object txtProxyPassword: TEdit
          Left = 59
          Top = 142
          Width = 130
          Height = 21
          Enabled = False
          PasswordChar = '*'
          TabOrder = 4
        end
        object cboProxyApproach: TComboBox
          Left = 59
          Top = 24
          Width = 130
          Height = 22
          Style = csOwnerDrawFixed
          ItemHeight = 16
          ItemIndex = 0
          TabOrder = 5
          Text = 'Use IE settings'
          OnChange = cboProxyApproachChange
          Items.Strings = (
            'Use IE settings'
            'Direct Connection'
            'Custom')
        end
      end
    end
  end
end
