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
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 150
    Width = 446
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object lstEvents: TTntListView
    Left = 0
    Top = 0
    Width = 446
    Height = 150
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
    Left = 0
    Top = 153
    Width = 446
    Height = 123
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
  object PopupMenu1: TTntPopupMenu
    Left = 64
    Top = 80
    object D1: TTntMenuItem
      Caption = 'Delete'
      OnClick = D1Click
    end
  end
end
