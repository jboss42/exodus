object frmLogin: TfrmLogin
  Left = 210
  Top = 351
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
    114)
  PixelsPerInch = 96
  TextHeight = 15
  object Label5: TLabel
    Left = 8
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
    Left = 62
    Top = 30
    Width = 126
    Height = 15
    Caption = 'foo@bar.com/resource'
  end
  object cboProfiles: TTntComboBox
    Left = 62
    Top = 4
    Width = 196
    Height = 23
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 15
    ItemHeight = 15
    TabOrder = 0
    OnChange = cboProfilesChange
    Items.WideStrings = (
      'Default Profile')
  end
  object chkInvisible: TCheckBox
    Left = 62
    Top = 53
    Width = 91
    Height = 14
    Caption = 'In&visible'
    TabOrder = 1
  end
  object btnDetails: TButton
    Left = 261
    Top = 4
    Width = 71
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Details...'
    TabOrder = 2
    OnClick = btnDetailsClick
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 82
    Width = 364
    Height = 32
    Align = alBottom
    AutoScroll = False
    TabOrder = 3
    inherited Panel2: TPanel
      Width = 364
      Height = 32
      inherited Bevel1: TBevel
        Width = 364
      end
      inherited Panel1: TPanel
        Left = 214
        Width = 150
        Height = 27
        inherited btnOK: TButton
          Width = 70
          Height = 23
        end
        inherited btnCancel: TButton
          Left = 77
          Width = 70
          Height = 23
        end
      end
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
