object frmLogin: TfrmLogin
  Left = 262
  Top = 419
  Width = 246
  Height = 262
  Caption = 'Login'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 32
    Width = 51
    Height = 13
    Caption = '&Username:'
  end
  object Label2: TLabel
    Left = 9
    Top = 56
    Width = 49
    Height = 13
    Caption = '&Password:'
  end
  object Label3: TLabel
    Left = 9
    Top = 80
    Width = 34
    Height = 13
    Caption = '&Server:'
  end
  object Label4: TLabel
    Left = 9
    Top = 104
    Width = 49
    Height = 13
    Caption = '&Resource:'
  end
  object Label5: TLabel
    Left = 9
    Top = 8
    Width = 32
    Height = 13
    Cursor = crHandPoint
    Caption = 'Profile:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label5Click
  end
  object cboServer: TTntComboBox
    Left = 66
    Top = 76
    Width = 150
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'jabber.org'
    Items.WideStrings = (
      'jabber.org'
      'jabber.com')
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 196
    Width = 238
    Height = 37
    Align = alBottom
    AutoScroll = False
    TabOrder = 8
    inherited Bevel1: TBevel
      Width = 238
    end
    inherited Panel1: TPanel
      Left = 76
      Width = 162
      Height = 32
    end
  end
  object cboProfiles: TTntComboBox
    Left = 66
    Top = 4
    Width = 150
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cboProfilesChange
    Items.WideStrings = (
      'Default Profile')
  end
  object chkInvisible: TCheckBox
    Left = 66
    Top = 144
    Width = 97
    Height = 15
    Caption = 'In&visible'
    TabOrder = 6
  end
  object btnDetails: TButton
    Left = 65
    Top = 162
    Width = 75
    Height = 23
    Caption = '&Details...'
    TabOrder = 7
    OnClick = btnDetailsClick
  end
  object chkSavePasswd: TCheckBox
    Left = 66
    Top = 125
    Width = 127
    Height = 17
    Caption = 'Save pass&word'
    TabOrder = 5
  end
  object txtUsername: TTntEdit
    Left = 66
    Top = 29
    Width = 151
    Height = 21
    TabOrder = 1
  end
  object txtPassword: TTntEdit
    Left = 66
    Top = 53
    Width = 151
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object cboResource: TTntComboBox
    Left = 65
    Top = 101
    Width = 152
    Height = 21
    ItemHeight = 13
    TabOrder = 4
  end
  object popProfiles: TPopupMenu
    Left = 8
    Top = 160
    object CreateNew1: TMenuItem
      Caption = 'Create New Profile...'
      OnClick = CreateNew1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete Profile...'
      OnClick = Delete1Click
    end
  end
end
