object frmLogin: TfrmLogin
  Left = 320
  Top = 428
  Width = 373
  Height = 153
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
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 84
    Width = 365
    Height = 35
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Panel2: TPanel
      Width = 365
      Height = 35
      inherited Bevel1: TBevel
        Width = 365
      end
      inherited Panel1: TPanel
        Left = 205
        Height = 30
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 365
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 1
    DesignSize = (
      365
      81)
    object lblProfile: TTntLabel
      Left = 3
      Top = 9
      Width = 32
      Height = 13
      Cursor = crHandPoint
      Caption = 'Profile:'
      OnClick = lblProfileClick
    end
    object Panel2: TPanel
      Left = 282
      Top = 2
      Width = 81
      Height = 77
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        81
        77)
      object btnDetails: TTntButton
        Left = 3
        Top = 2
        Width = 76
        Height = 23
        Anchors = [akTop, akRight]
        Caption = '&Details...'
        TabOrder = 0
        OnClick = btnDetailsClick
      end
    end
    object cboProfiles: TTntComboBox
      Left = 60
      Top = 4
      Width = 205
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 15
      ItemHeight = 13
      TabOrder = 1
      OnChange = cboProfilesChange
      Items.WideStrings = (
        'Default Profile')
    end
    object chkInvisible: TTntCheckBox
      Left = 61
      Top = 62
      Width = 97
      Height = 14
      Caption = 'In&visible'
      TabOrder = 2
    end
    object lblJid: TTntStaticText
      Left = 60
      Top = 33
      Width = 27
      Height = 17
      Caption = 'lblJid'
      TabOrder = 3
    end
  end
  object popProfiles: TTntPopupMenu
    Left = 16
    Top = 24
    object CreateNew1: TTntMenuItem
      Caption = 'Create New Profile...'
      OnClick = CreateNew1Click
    end
    object Delete1: TTntMenuItem
      Caption = 'Delete Profile...'
      OnClick = Delete1Click
    end
  end
end
