object frmLogin: TfrmLogin
  Left = 239
  Top = 211
  Width = 250
  Height = 247
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 51
    Height = 13
    Caption = 'Username:'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 49
    Height = 13
    Caption = 'Password:'
  end
  object Label3: TLabel
    Left = 8
    Top = 80
    Width = 34
    Height = 13
    Caption = 'Server:'
  end
  object Label4: TLabel
    Left = 8
    Top = 104
    Width = 49
    Height = 13
    Caption = 'Resource:'
  end
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Profile:'
  end
  object Label6: TLabel
    Left = 8
    Top = 128
    Width = 34
    Height = 13
    Caption = 'Priority:'
  end
  object lblNewProfile: TLabel
    Left = 4
    Top = 155
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
    Top = 155
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
  object txtUsername: TEdit
    Left = 98
    Top = 28
    Width = 130
    Height = 21
    TabOrder = 0
  end
  object txtPassword: TEdit
    Left = 98
    Top = 52
    Width = 130
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object cboServer: TComboBox
    Left = 98
    Top = 76
    Width = 131
    Height = 21
    ItemHeight = 13
    TabOrder = 2
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
    Top = 176
    Width = 242
    Height = 37
    Align = alBottom
    AutoScroll = False
    TabOrder = 5
    inherited Bevel1: TBevel
      Width = 242
    end
    inherited Panel1: TPanel
      Left = 80
      Width = 162
      Height = 32
      inherited btnOK: TButton
        Default = True
      end
      inherited btnCancel: TButton
        Cancel = True
      end
    end
  end
  object cboProfiles: TComboBox
    Left = 98
    Top = 4
    Width = 131
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnChange = cboProfilesChange
    Items.Strings = (
      'Default Profile')
  end
  object txtPriority: TEdit
    Left = 98
    Top = 124
    Width = 39
    Height = 21
    TabOrder = 6
    Text = '0'
  end
  object spnPriority: TUpDown
    Left = 137
    Top = 124
    Width = 15
    Height = 21
    Associate = txtPriority
    Min = 0
    Max = 1000
    Position = 0
    TabOrder = 7
    Wrap = False
  end
end
