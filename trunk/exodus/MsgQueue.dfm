object frmMsgQueue: TfrmMsgQueue
  Left = 247
  Top = 194
  Caption = 'Events'
  ClientHeight = 276
  ClientWidth = 446
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnEndDock = FormEndDock
  PixelsPerInch = 96
  TextHeight = 13
  object splitRoster: TSplitter
    Left = 130
    Top = 0
    Height = 276
    ResizeStyle = rsUpdate
    OnMoved = splitRosterMoved
    ExplicitLeft = 125
    ExplicitTop = 1
  end
  object pnlRoster: TPanel
    Left = 0
    Top = 0
    Width = 130
    Height = 276
    Align = alLeft
    Caption = 'pnlRoster'
    TabOrder = 0
    Visible = False
  end
  object pnlMsgQueue: TPanel
    Left = 133
    Top = 0
    Width = 313
    Height = 276
    Align = alClient
    Caption = 'pnlMsgQueue'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 1
      Top = 121
      Width = 311
      Height = 4
      Cursor = crVSplit
      Align = alTop
      ResizeStyle = rsUpdate
      ExplicitLeft = 6
      ExplicitTop = 131
    end
    object lstEvents: TTntListView
      Left = 1
      Top = 26
      Width = 311
      Height = 95
      Align = alTop
      Columns = <
        item
          Caption = 'From'
          Width = 100
        end
        item
          Caption = 'Date/Time'
          Width = 125
        end
        item
          Caption = 'Subject'
          Width = 200
        end>
      ColumnClick = False
      MultiSelect = True
      OwnerData = True
      ReadOnly = True
      RowSelect = True
      PopupMenu = PopupMenu1
      SmallImages = frmExodus.ImageList2
      TabOrder = 0
      ViewStyle = vsReport
      OnChange = lstEventsChange
      OnData = lstEventsData
      OnDblClick = lstEventsDblClick
      OnEnter = lstEventsEnter
      OnKeyDown = lstEventsKeyDown
    end
    object txtMsg: TExRichEdit
      Left = 1
      Top = 125
      Width = 311
      Height = 150
      Align = alClient
      AutoURLDetect = adDefault
      CustomURLs = <
        item
          Name = 'e-mail'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'http'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'file'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'mailto'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'ftp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'https'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'gopher'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'nntp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'prospero'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'telnet'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'news'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'wais'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end>
      LangOptions = [loAutoFont]
      Language = 1033
      ReadOnly = True
      ScrollBars = ssVertical
      ShowSelectionBar = False
      TabOrder = 1
      URLColor = clBlue
      URLCursor = crHandPoint
      OnURLClick = txtMsgURLClick
      InputFormat = ifUnicode
      OutputFormat = ofRTF
      SelectedInOut = False
      PlainRTF = False
      UndoLimit = 0
      AllowInPlace = False
    end
    object pnlButton: TPanel
      Left = 1
      Top = 1
      Width = 311
      Height = 25
      Align = alTop
      BevelEdges = []
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        311
        25)
      object btnClose: TSpeedButton
        Left = 288
        Top = 2
        Width = 23
        Height = 20
        Anchors = [akTop, akRight]
        Caption = 'X'
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = btnCloseClick
      end
    end
  end
  object PopupMenu1: TTntPopupMenu
    Left = 152
    Top = 176
    object D1: TTntMenuItem
      Caption = 'Delete'
      OnClick = D1Click
    end
  end
end
