inherited frmRoom: TfrmRoom
  Left = 460
  Top = 394
  Caption = 'Conference Room'
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel3: TPanel
    Top = 20
    Height = 230
    object Splitter2: TSplitter [0]
      Left = 270
      Top = 4
      Width = 3
      Height = 222
      Cursor = crHSplit
      Align = alRight
      ResizeStyle = rsUpdate
    end
    inherited MsgList: TExRichEdit
      Width = 266
      Height = 222
      PopupMenu = popRoom
      OnDragDrop = treeRosterDragDrop
      OnDragOver = treeRosterDragOver
      OnMouseUp = MsgListMouseUp
    end
    object Panel6: TPanel
      Left = 273
      Top = 4
      Width = 105
      Height = 222
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 1
      Caption = '`'
      TabOrder = 1
      object treeRoster: TTreeView
        Left = 1
        Top = 1
        Width = 103
        Height = 220
        Align = alClient
        Images = frmRosterWindow.ImageList1
        Indent = 19
        ParentShowHint = False
        PopupMenu = popRoom
        ReadOnly = True
        ShowHint = True
        ShowLines = False
        ShowRoot = False
        SortType = stText
        TabOrder = 0
        OnDblClick = treeRosterDblClick
        OnDragDrop = treeRosterDragDrop
        OnDragOver = treeRosterDragOver
        OnMouseMove = treeRosterMouseMove
      end
    end
  end
  inherited Panel1: TPanel
    Height = 20
    object lblSubject: TLabel
      Left = 41
      Top = 2
      Width = 339
      Height = 16
      Align = alClient
      ParentShowHint = False
      ShowHint = True
    end
    object lblSubjectURL: TLabel
      Left = 2
      Top = 2
      Width = 39
      Height = 16
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Subject:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = lblSubjectURLClick
    end
  end
  object popRoom: TPopupMenu
    Left = 48
    Top = 184
    object popClear: TMenuItem
      Caption = 'Clear Window'
      OnClick = popClearClick
    end
    object popBookmark: TMenuItem
      Caption = 'Bookmark Room'
      OnClick = popBookmarkClick
    end
    object popInvite: TMenuItem
      Caption = 'Invite Contacts'
      OnClick = popInviteClick
    end
    object popNick: TMenuItem
      Caption = 'Change Nickname'
      OnClick = popNickClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuOnTop: TMenuItem
      Caption = 'Always on Top'
      OnClick = mnuOnTopClick
    end
    object popClose: TMenuItem
      Caption = 'Close Room'
      OnClick = popCloseClick
    end
  end
end
