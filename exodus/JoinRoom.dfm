object frmJoinRoom: TfrmJoinRoom
  Left = 250
  Top = 168
  Width = 451
  Height = 230
  BorderIcons = [biSystemMenu]
  BorderWidth = 2
  Caption = 'Join Room'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 158
    Width = 439
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 1
    inherited Panel2: TPanel
      Width = 439
      inherited Bevel1: TBevel
        Width = 439
      end
      inherited Panel1: TPanel
        Left = 279
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 439
    Height = 158
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TTntLabel
      Left = 6
      Top = 90
      Width = 65
      Height = 13
      Caption = 'Room Server:'
    end
    object Label1: TTntLabel
      Left = 6
      Top = 62
      Width = 62
      Height = 13
      Caption = 'Room Name:'
    end
    object lblPassword: TTntLabel
      Left = 6
      Top = 35
      Width = 49
      Height = 13
      Caption = 'Password:'
    end
    object Label3: TTntLabel
      Left = 6
      Top = 8
      Width = 51
      Height = 13
      Caption = 'Nickname:'
    end
    object lblFetch: TTntLabel
      Left = 114
      Top = 112
      Width = 141
      Height = 13
      Cursor = crHandPoint
      Caption = 'Get room list from this server...'
      OnClick = lblFetchClick
    end
    object TntSplitter1: TTntSplitter
      Left = 269
      Top = 0
      Height = 158
      Align = alRight
      ResizeStyle = rsUpdate
    end
    object txtServer: TTntComboBox
      Left = 115
      Top = 87
      Width = 143
      Height = 21
      Hint = 'Select the room server to use.'
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = 'txtServer'
    end
    object txtRoom: TTntEdit
      Left = 115
      Top = 60
      Width = 140
      Height = 21
      TabOrder = 2
    end
    object txtPassword: TTntEdit
      Left = 115
      Top = 33
      Width = 140
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
    object txtNick: TTntEdit
      Left = 115
      Top = 6
      Width = 140
      Height = 21
      TabOrder = 0
    end
    object lstRooms: TTntListBox
      Left = 272
      Top = 0
      Width = 167
      Height = 158
      Hint = 'Join Room'
      Align = alRight
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      Sorted = True
      TabOrder = 4
      OnClick = lstRoomsClick
      OnDblClick = lstRoomsDblClick
      OnMouseMove = lstRoomsMouseMove
    end
  end
end
