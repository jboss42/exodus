object frmMsgQueue: TfrmMsgQueue
  Left = 271
  Top = 207
  Width = 436
  Height = 328
  Caption = 'Events'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 150
    Width = 428
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object lstEvents: TListView
    Left = 0
    Top = 0
    Width = 428
    Height = 150
    Align = alTop
    Columns = <
      item
        Caption = 'From'
        Width = 100
      end
      item
        Caption = 'Date/Time'
        Width = 100
      end
      item
        Caption = 'Subject'
        Width = 200
      end>
    ColumnClick = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    SmallImages = frmExodus.ImageList2
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lstEventsChange
    OnDblClick = lstEventsDblClick
    OnKeyDown = lstEventsKeyDown
  end
  object txtMsg: TRichEdit
    Left = 0
    Top = 153
    Width = 428
    Height = 122
    Align = alClient
    ReadOnly = True
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 275
    Width = 428
    Height = 19
    Panels = <>
    SimplePanel = False
  end
end
