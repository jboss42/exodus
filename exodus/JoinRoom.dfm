object frmJoinRoom: TfrmJoinRoom
  Left = 235
  Top = 158
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Join Room'
  ClientHeight = 299
  ClientWidth = 364
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TTntLabel
    Left = 24
    Top = 82
    Width = 62
    Height = 13
    Caption = 'Room Name:'
  end
  object Label2: TTntLabel
    Left = 24
    Top = 114
    Width = 65
    Height = 13
    Caption = 'Room Server:'
  end
  object Label3: TTntLabel
    Left = 8
    Top = 9
    Width = 51
    Height = 13
    Caption = 'Nickname:'
  end
  object lblPassword: TTntLabel
    Left = 8
    Top = 33
    Width = 49
    Height = 13
    Caption = 'Password:'
  end
  object txtRoom: TTntEdit
    Left = 115
    Top = 79
    Width = 200
    Height = 21
    TabOrder = 0
  end
  object txtNick: TTntEdit
    Left = 115
    Top = 6
    Width = 200
    Height = 21
    TabOrder = 2
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 265
    Width = 364
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 4
    inherited Panel2: TPanel
      Width = 364
      Height = 34
      inherited Bevel1: TBevel
        Width = 364
      end
      inherited Panel1: TPanel
        Left = 204
        Height = 29
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object txtServer: TTntComboBox
    Left = 115
    Top = 110
    Width = 200
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'txtServer'
  end
  object txtPassword: TTntEdit
    Left = 115
    Top = 30
    Width = 200
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object optSpecify: TTntRadioButton
    Left = 8
    Top = 57
    Width = 281
    Height = 17
    Caption = 'Specify the room and server to use'
    Checked = True
    TabOrder = 5
    TabStop = True
    OnClick = optSpecifyClick
  end
  object optList: TTntRadioButton
    Left = 8
    Top = 137
    Width = 281
    Height = 17
    Caption = 'Pick a room from this list'
    TabOrder = 6
    OnClick = optSpecifyClick
  end
  object lstRooms: TTntListBox
    Left = 24
    Top = 160
    Width = 289
    Height = 89
    Enabled = False
    ItemHeight = 13
    Sorted = True
    TabOrder = 7
    OnDblClick = lstRoomsDblClick
  end
end
