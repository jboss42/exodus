object frmJoinRoom: TfrmJoinRoom
  Left = 235
  Top = 158
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Join Room'
  ClientHeight = 177
  ClientWidth = 241
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
    Left = 8
    Top = 9
    Width = 62
    Height = 13
    Caption = 'Room Name:'
  end
  object Label2: TLabel
    Left = 8
    Top = 41
    Width = 65
    Height = 13
    Caption = 'Room Server:'
  end
  object Label3: TLabel
    Left = 8
    Top = 73
    Width = 51
    Height = 13
    Caption = 'Nickname:'
  end
  object lblPassword: TLabel
    Left = 8
    Top = 105
    Width = 49
    Height = 13
    Caption = 'Password:'
  end
  object txtRoom: TEdit
    Left = 91
    Top = 6
    Width = 139
    Height = 21
    TabOrder = 0
  end
  object txtNick: TEdit
    Left = 91
    Top = 70
    Width = 139
    Height = 21
    TabOrder = 2
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 143
    Width = 241
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 4
    inherited Bevel1: TBevel
      Width = 241
    end
    inherited Panel1: TPanel
      Left = 81
      inherited btnOK: TButton
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object txtServer: TComboBox
    Left = 91
    Top = 37
    Width = 140
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'txtServer'
  end
  object txtPassword: TEdit
    Left = 91
    Top = 102
    Width = 139
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
end
