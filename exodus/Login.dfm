object frmLogin: TfrmLogin
  Left = 258
  Top = 268
  Width = 376
  Height = 145
  BorderIcons = [biSystemMenu, biMinimize]
  BorderWidth = 1
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
    366
    114)
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
  object lblJID: TTntLabel
    Left = 66
    Top = 32
    Width = 125
    Height = 16
    Caption = 'foo@bar.com/resource'
  end
  object Bevel1: TBevel
    Left = 0
    Top = 75
    Width = 366
    Height = 2
    Align = alBottom
    Shape = bsTopLine
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 77
    Width = 366
    Height = 37
    Align = alBottom
    AutoScroll = False
    TabOrder = 3
    inherited Bevel1: TBevel
      Width = 366
      Height = 7
    end
    inherited Panel1: TPanel
      Left = 204
      Top = 7
      Width = 162
      Height = 30
    end
  end
  object cboProfiles: TTntComboBox
    Left = 66
    Top = 4
    Width = 211
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
    Top = 56
    Width = 97
    Height = 15
    Caption = 'In&visible'
    TabOrder = 1
  end
  object btnDetails: TButton
    Left = 285
    Top = 4
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
