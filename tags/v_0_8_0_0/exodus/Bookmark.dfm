object frmBookmark: TfrmBookmark
  Left = 927
  Top = 177
  Width = 288
  Height = 192
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
    Top = 61
    Width = 49
    Height = 13
    Caption = 'Jabber ID:'
  end
  object Label4: TLabel
    Left = 8
    Top = 93
    Width = 82
    Height = 13
    Caption = 'Room Nickname:'
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 124
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
      Height = 29
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
    Left = 104
    Top = 32
    Width = 145
    Height = 21
    TabOrder = 2
  end
  object txtJID: TEdit
    Left = 104
    Top = 56
    Width = 145
    Height = 21
    TabOrder = 3
  end
  object txtNick: TEdit
    Left = 104
    Top = 88
    Width = 145
    Height = 21
    TabOrder = 4
  end
end
