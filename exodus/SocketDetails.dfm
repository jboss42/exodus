object frmSocketDetails: TfrmSocketDetails
  Left = 800
  Top = 420
  Width = 218
  Height = 300
  Caption = 'Socket Details'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 41
    Top = 40
    Width = 22
    Height = 13
    Alignment = taRightJustify
    Caption = 'Port:'
  end
  object Label1: TLabel
    Left = 38
    Top = 12
    Width = 25
    Height = 13
    Alignment = taRightJustify
    Caption = 'Host:'
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 234
    Width = 210
    Height = 37
    Align = alBottom
    AutoScroll = False
    TabOrder = 4
    inherited Bevel1: TBevel
      Width = 210
    end
    inherited Panel1: TPanel
      Left = 48
      Width = 162
      Height = 32
    end
  end
  object txtPort: TEdit
    Left = 67
    Top = 36
    Width = 39
    Height = 21
    TabOrder = 1
    Text = '5222'
  end
  object chkSSL: TCheckBox
    Left = 132
    Top = 37
    Width = 63
    Height = 17
    Caption = 'Use SSL'
    TabOrder = 2
    OnClick = chkSSLClick
  end
  object txtHost: TEdit
    Left = 67
    Top = 8
    Width = 130
    Height = 21
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 64
    Width = 197
    Height = 160
    Caption = 'SOCKS'
    TabOrder = 3
    object lblSocksHost: TLabel
      Left = 30
      Top = 42
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = 'Host:'
      Enabled = False
    end
    object lblSocksPort: TLabel
      Left = 33
      Top = 65
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = 'Port:'
      Enabled = False
    end
    object lblSocksType: TLabel
      Left = 28
      Top = 21
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Caption = 'Type:'
    end
    object lblSocksUsername: TLabel
      Left = 4
      Top = 110
      Width = 51
      Height = 13
      Alignment = taRightJustify
      Caption = 'Username:'
      Enabled = False
    end
    object lblSocksPassword: TLabel
      Left = 6
      Top = 133
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'Password:'
      Enabled = False
    end
    object chkSocksAuth: TCheckBox
      Left = 59
      Top = 83
      Width = 135
      Height = 17
      Caption = 'Authentication Required'
      Enabled = False
      TabOrder = 3
      OnClick = chkSocksAuthClick
    end
    object txtSocksHost: TEdit
      Left = 59
      Top = 38
      Width = 130
      Height = 21
      Enabled = False
      TabOrder = 1
    end
    object txtSocksPort: TEdit
      Left = 59
      Top = 61
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
      Top = 106
      Width = 130
      Height = 21
      Enabled = False
      TabOrder = 4
    end
    object txtSocksPassword: TEdit
      Left = 58
      Top = 129
      Width = 130
      Height = 21
      Enabled = False
      PasswordChar = '*'
      TabOrder = 5
    end
  end
end
