object frmHttpDetails: TfrmHttpDetails
  Left = 798
  Top = 185
  Width = 218
  Height = 300
  Caption = 'HTTP Details'
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
  object Label1: TLabel
    Left = 41
    Top = 10
    Width = 25
    Height = 13
    Alignment = taRightJustify
    Caption = 'URL:'
  end
  object Label2: TLabel
    Left = 20
    Top = 37
    Width = 46
    Height = 13
    Alignment = taRightJustify
    Caption = 'Poll Time:'
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 234
    Width = 210
    Height = 37
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 210
    end
    inherited Panel1: TPanel
      Left = 48
      Width = 162
      Height = 32
    end
  end
  object txtURL: TEdit
    Left = 68
    Top = 8
    Width = 130
    Height = 21
    TabOrder = 1
  end
  object txtTime: TEdit
    Left = 68
    Top = 34
    Width = 50
    Height = 21
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 57
    Width = 198
    Height = 170
    Caption = 'HTTP Proxy'
    TabOrder = 3
    object lblProxyHost: TLabel
      Left = 30
      Top = 53
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = 'Host:'
      Enabled = False
    end
    object lblProxyPort: TLabel
      Left = 33
      Top = 76
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = 'Port:'
      Enabled = False
    end
    object lblProxyUsername: TLabel
      Left = 4
      Top = 121
      Width = 51
      Height = 13
      Alignment = taRightJustify
      Caption = 'Username:'
      Enabled = False
    end
    object lblProxyPassword: TLabel
      Left = 6
      Top = 144
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'Password:'
      Enabled = False
    end
    object Label3: TLabel
      Left = 6
      Top = 28
      Width = 49
      Height = 13
      Alignment = taRightJustify
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
      Left = 58
      Top = 117
      Width = 130
      Height = 21
      Enabled = False
      TabOrder = 3
    end
    object txtProxyPassword: TEdit
      Left = 58
      Top = 140
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
