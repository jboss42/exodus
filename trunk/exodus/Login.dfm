object frmLogin: TfrmLogin
  Left = 651
  Top = 159
  Width = 246
  Height = 268
  Caption = 'Jabber Login'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 41
    Top = 32
    Width = 51
    Height = 13
    Alignment = taRightJustify
    Caption = 'Username:'
  end
  object Label2: TLabel
    Left = 43
    Top = 56
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'Password:'
  end
  object Label3: TLabel
    Left = 58
    Top = 80
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Server:'
  end
  object Label4: TLabel
    Left = 43
    Top = 104
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'Resource:'
  end
  object Label5: TLabel
    Left = 60
    Top = 8
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Profile:'
  end
  object Label6: TLabel
    Left = 58
    Top = 129
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Priority:'
  end
  object lblNewProfile: TLabel
    Left = 4
    Top = 176
    Width = 94
    Height = 13
    Cursor = crHandPoint
    Caption = 'Create a new profile'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblNewProfileClick
  end
  object lblDelete: TLabel
    Left = 147
    Top = 176
    Width = 81
    Height = 13
    Cursor = crHandPoint
    Caption = 'Delete this profile'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblDeleteClick
  end
  object Label8: TLabel
    Left = 8
    Top = 153
    Width = 84
    Height = 13
    Alignment = taRightJustify
    Caption = 'Connection Type:'
  end
  object txtUsername: TEdit
    Left = 98
    Top = 28
    Width = 130
    Height = 21
    TabOrder = 1
  end
  object txtPassword: TEdit
    Left = 98
    Top = 52
    Width = 130
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object cboServer: TComboBox
    Left = 98
    Top = 76
    Width = 131
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'jabber.org'
    Items.Strings = (
      'jabber.org'
      'jabber.com')
  end
  object cboResource: TComboBox
    Left = 98
    Top = 100
    Width = 131
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = 'exodus'
    Items.Strings = (
      'home'
      'work'
      'exodus')
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 202
    Width = 238
    Height = 37
    Align = alBottom
    AutoScroll = False
    TabOrder = 7
    inherited Bevel1: TBevel
      Width = 238
    end
    inherited Panel1: TPanel
      Left = 76
      Width = 162
      Height = 32
    end
  end
  object cboProfiles: TComboBox
    Left = 98
    Top = 4
    Width = 131
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cboProfilesChange
    Items.Strings = (
      'Default Profile')
  end
  object txtPriority: TEdit
    Left = 98
    Top = 125
    Width = 49
    Height = 21
    TabOrder = 5
    Text = '0'
  end
  object spnPriority: TUpDown
    Left = 147
    Top = 125
    Width = 15
    Height = 21
    Associate = txtPriority
    Min = 0
    Max = 1000
    Position = 0
    TabOrder = 6
    Wrap = False
  end
  object chkInvisible: TCheckBox
    Left = 168
    Top = 128
    Width = 58
    Height = 15
    Caption = 'Invisible'
    TabOrder = 8
  end
  object cboConnection: TComboBox
    Left = 98
    Top = 151
    Width = 66
    Height = 21
    Style = csOwnerDrawFixed
    DropDownCount = 2
    ItemHeight = 15
    ItemIndex = 0
    TabOrder = 9
    Text = 'Normal'
    Items.Strings = (
      'Normal'
      'HTTP')
  end
  object btnDetails: TButton
    Left = 169
    Top = 151
    Width = 58
    Height = 21
    Caption = 'Details...'
    TabOrder = 10
    OnClick = btnDetailsClick
  end
end
