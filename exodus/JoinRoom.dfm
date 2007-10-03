object frmJoinRoom: TfrmJoinRoom
  Left = 250
  Top = 168
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  BorderWidth = 2
  Caption = 'Join Room'
  ClientHeight = 192
  ClientWidth = 439
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
  object Splitter1: TSplitter
    Left = 267
    Top = 0
    Height = 158
    Align = alRight
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 158
    Width = 439
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 2
    inherited Panel2: TPanel
      Width = 439
      Height = 34
      inherited Bevel1: TBevel
        Width = 439
      end
      inherited Panel1: TPanel
        Left = 279
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
  object treeRooms: TTntTreeView
    Left = 270
    Top = 0
    Width = 169
    Height = 158
    Align = alRight
    AutoExpand = True
    HideSelection = False
    Indent = 19
    MultiSelectStyle = []
    ShowLines = False
    SortType = stText
    TabOrder = 1
    OnChange = treeRoomsChange
    OnDblClick = treeRoomsDblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 267
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
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = lblFetchClick
    end
    object txtServer: TTntComboBox
      Left = 115
      Top = 87
      Width = 143
      Height = 21
      ItemHeight = 13
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
  end
end
