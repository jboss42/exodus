object frmLogin: TfrmLogin
  Left = 320
  Top = 428
  Width = 372
  Height = 145
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Login'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
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
  TextHeight = 13
  object lblProfile: TTntLabel
    Left = 9
    Top = 9
    Width = 32
    Height = 13
    Cursor = crHandPoint
    Caption = 'Profile:'
    OnClick = lblProfileClick
  end
  object lblJID: TTntLabel
    Left = 66
    Top = 32
    Width = 110
    Height = 13
    Caption = 'foo@bar.com/resource'
  end
  object cboProfiles: TTntComboBox
    Left = 66
    Top = 4
    Width = 209
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 15
    ItemHeight = 13
    TabOrder = 0
    OnChange = cboProfilesChange
    Items.WideStrings = (
      'Default Profile')
  end
  object chkInvisible: TTntCheckBox
    Left = 66
    Top = 57
    Width = 97
    Height = 14
    Caption = 'In&visible'
    TabOrder = 1
  end
  object btnDetails: TTntButton
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
    Top = 81
    Width = 364
    Height = 35
    Align = alBottom
    AutoScroll = False
    TabOrder = 3
    inherited Panel2: TPanel
      Width = 364
      Height = 35
      inherited Bevel1: TBevel
        Width = 364
      end
      inherited Panel1: TPanel
        Left = 204
        Height = 30
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
