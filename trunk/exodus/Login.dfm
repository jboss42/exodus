object frmLogin: TfrmLogin
  Left = 260
  Top = 270
  Width = 372
  Height = 145
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
    364
    116)
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
  object cboProfiles: TTntComboBox
    Left = 66
    Top = 4
    Width = 209
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
    Left = 278
    Top = 4
    Width = 76
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '&Details...'
    TabOrder = 2
    OnClick = btnDetailsClick
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 82
    Width = 364
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 3
    inherited Bevel1: TBevel
      Width = 364
    end
    inherited Panel1: TPanel
      Left = 204
    end
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
