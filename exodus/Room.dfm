inherited frmRoom: TfrmRoom
  Left = 255
  Top = 250
  Caption = 'Conference Room'
  OldCreateOrder = True
  OnClose = FormClose
  OnEndDock = FormEndDock
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel3: TPanel
    Top = 23
    Height = 227
    object Splitter2: TSplitter [0]
      Left = 270
      Top = 4
      Width = 3
      Height = 219
      Cursor = crHSplit
      Align = alRight
      ResizeStyle = rsUpdate
    end
    inherited MsgList: TExRichEdit
      Width = 266
      Height = 219
      PopupMenu = popRoom
      OnDragDrop = treeRosterDragDrop
      OnDragOver = treeRosterDragOver
      OnMouseUp = MsgListMouseUp
    end
    object Panel6: TPanel
      Left = 273
      Top = 4
      Width = 105
      Height = 219
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 1
      Caption = '`'
      TabOrder = 1
      object treeRoster: TTreeView
        Left = 1
        Top = 1
        Width = 103
        Height = 217
        Align = alClient
        Images = frmRosterWindow.ImageList1
        Indent = 19
        ParentShowHint = False
        PopupMenu = popRoomRoster
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
    Height = 23
    BorderWidth = 1
    object btnClose: TSpeedButton
      Left = 356
      Top = 2
      Width = 23
      Height = 20
      Caption = 'X'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
      OnClick = btnCloseClick
    end
    object pnlSubj: TPanel
      Left = 1
      Top = 1
      Width = 352
      Height = 21
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblSubjectURL: TLabel
        Left = 0
        Top = 0
        Width = 39
        Height = 21
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
      object lblSubject: TTntEdit
        Left = 42
        Top = 0
        Width = 47
        Height = 17
        AutoSelect = False
        BorderStyle = bsNone
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object popRoom: TPopupMenu
    Left = 48
    Top = 184
    object popClear: TMenuItem
      Caption = 'Clear Window'
      OnClick = popClearClick
    end
    object popShowHistory: TMenuItem
      Caption = 'Show History'
      OnClick = popShowHistoryClick
    end
    object popClearHistory: TMenuItem
      Caption = 'Clear History'
      OnClick = popClearHistoryClick
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
  object popRoomRoster: TPopupMenu
    OnPopup = popRoomRosterPopup
    Left = 80
    Top = 184
    object popRosterChat: TMenuItem
      Caption = 'Chat'
      OnClick = treeRosterDblClick
    end
    object popRosterBlock: TMenuItem
      Caption = 'Block'
      OnClick = popRosterBlockClick
    end
  end
end
