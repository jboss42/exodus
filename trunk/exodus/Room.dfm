object frmRoom: TfrmRoom
  Left = 230
  Top = 472
  Width = 441
  Height = 347
  Caption = 'Conference Room'
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = popRoom
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 0
    Top = 279
    Width = 433
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ResizeStyle = rsUpdate
  end
  object Panel3: TPanel
    Left = 0
    Top = 18
    Width = 433
    Height = 261
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'pnlMsgs'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 321
      Top = 4
      Width = 3
      Height = 253
      Cursor = crHSplit
      Align = alRight
      ResizeStyle = rsUpdate
    end
    object Panel6: TPanel
      Left = 324
      Top = 4
      Width = 105
      Height = 253
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 1
      Caption = '`'
      TabOrder = 0
      object treeRoster: TTreeView
        Left = 1
        Top = 1
        Width = 103
        Height = 251
        Align = alClient
        Images = frmRosterWindow.ImageList1
        Indent = 19
        ReadOnly = True
        ShowLines = False
        ShowRoot = False
        SortType = stText
        TabOrder = 0
        OnDblClick = treeRosterDblClick
        OnDragDrop = treeRosterDragDrop
        OnDragOver = treeRosterDragOver
      end
    end
    object MsgList: TExRichEdit
      Left = 4
      Top = 4
      Width = 317
      Height = 253
      Align = alClient
      PopupMenu = popRoom
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 1
      OnURLClick = MsgListURLClick
    end
  end
  object pnlInput: TPanel
    Left = 0
    Top = 282
    Width = 433
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 2
    Caption = 'pnlInput'
    TabOrder = 1
    object MsgOut: TMemo
      Left = 2
      Top = 2
      Width = 429
      Height = 27
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      WantReturns = False
      WantTabs = True
      OnKeyPress = MsgOutKeyPress
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 0
    Width = 433
    Height = 18
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 2
    object Panel2: TPanel
      Left = 2
      Top = 2
      Width = 429
      Height = 14
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblSubject: TLabel
        Left = 39
        Top = 0
        Width = 390
        Height = 14
        Align = alClient
        ParentShowHint = False
        ShowHint = True
      end
      object lblSubjectURL: TLabel
        Left = 0
        Top = 0
        Width = 39
        Height = 14
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
  end
  object popRoom: TPopupMenu
    Left = 24
    Top = 40
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
    end
    object popNick: TMenuItem
      Caption = 'Change Nickname'
      OnClick = popNickClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popClose: TMenuItem
      Caption = 'Close Room'
      OnClick = popCloseClick
    end
  end
end
