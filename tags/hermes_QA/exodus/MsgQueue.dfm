inherited frmMsgQueue: TfrmMsgQueue
  Left = 247
  Top = 194
  Caption = 'Messages'
  ClientHeight = 276
  ClientWidth = 446
  OldCreateOrder = True
  OnClose = FormClose
  ExplicitWidth = 454
  ExplicitHeight = 310
  PixelsPerInch = 96
  TextHeight = 13
  object splitRoster: TSplitter [0]
    Left = 0
    Top = 32
    Height = 244
    ResizeStyle = rsUpdate
    ExplicitLeft = 125
    ExplicitTop = 1
    ExplicitHeight = 276
  end
  inherited pnlDockTop: TPanel
    Width = 446
    TabOrder = 1
    ExplicitWidth = 446
    inherited tbDockBar: TToolBar
      Left = 397
      ExplicitLeft = 397
    end
  end
  object pnlMsgQueue: TPanel
    Left = 3
    Top = 32
    Width = 443
    Height = 244
    Align = alClient
    Caption = 'pnlMsgQueue'
    TabOrder = 0
    ExplicitLeft = 133
    ExplicitWidth = 313
    object Splitter1: TSplitter
      Left = 1
      Top = 96
      Width = 441
      Height = 4
      Cursor = crVSplit
      Align = alTop
      ResizeStyle = rsUpdate
      ExplicitLeft = 6
      ExplicitTop = 131
      ExplicitWidth = 311
    end
    object lstEvents: TTntListView
      Left = 1
      Top = 1
      Width = 441
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
      ExplicitWidth = 311
    end
    object txtMsg: TExRichEdit
      Left = 1
      Top = 100
      Width = 441
      Height = 143
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
