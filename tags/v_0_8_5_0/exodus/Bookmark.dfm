object frmBookmark: TfrmBookmark
  Left = 514
  Top = 169
  Width = 288
  Height = 216
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Bookmark Properties'
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
    Left = 8
    Top = 8
    Width = 90
    Height = 13
    Caption = 'Type of Bookmark:'
  end
  object Label2: TLabel
    Left = 8
    Top = 37
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object Label3: TLabel
    Left = 8
    Top = 66
    Width = 49
    Height = 13
    Caption = 'Jabber ID:'
  end
  object Label4: TLabel
    Left = 8
    Top = 95
    Width = 82
    Height = 13
    Caption = 'Room Nickname:'
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 153
    Width = 280
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 280
    end
    inherited Panel1: TPanel
      Left = 120
      inherited btnOK: TButton
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object cboType: TComboBox
    Left = 105
    Top = 5
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'Conference Room')
  end
  object txtName: TEdit
    Left = 105
    Top = 33
    Width = 145
    Height = 21
    TabOrder = 2
  end
  object txtJID: TEdit
    Left = 105
    Top = 62
    Width = 145
    Height = 21
    TabOrder = 3
  end
  object txtNick: TEdit
    Left = 105
    Top = 91
    Width = 145
    Height = 21
    TabOrder = 4
  end
  object chkAutoJoin: TCheckBox
    Left = 105
    Top = 120
    Width = 97
    Height = 17
    Caption = 'Join on login'
    TabOrder = 5
  end
end
