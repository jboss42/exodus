object frmLogin: TfrmLogin
  Left = 258
  Top = 268
  Width = 376
  Height = 121
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Login'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial Unicode MS'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    368
    92)
  PixelsPerInch = 96
  TextHeight = 16
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
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 55
    Width = 368
    Height = 37
    Align = alBottom
    AutoScroll = False
    TabOrder = 3
    inherited Bevel1: TBevel
      Width = 368
    end
    inherited Panel1: TPanel
      Left = 206
      Width = 162
      Height = 32
    end
  end
  object cboProfiles: TTntComboBox
    Left = 66
    Top = 4
    Width = 213
    Height = 24
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 15
    ItemHeight = 16
    TabOrder = 0
    OnChange = cboProfilesChange
    Items.WideStrings = (
      'Default Profile')
  end
  object chkInvisible: TCheckBox
    Left = 66
    Top = 32
    Width = 97
    Height = 15
    Caption = 'In&visible'
    TabOrder = 1
  end
  object btnDetails: TButton
    Left = 287
    Top = 3
    Width = 75
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '&Details...'
    TabOrder = 2
    OnClick = btnDetailsClick
  end
  object popProfiles: TPopupMenu
    Left = 16
    Top = 24
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
