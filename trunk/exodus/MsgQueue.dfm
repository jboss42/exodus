inherited frmMsgQueue: TfrmMsgQueue
  Left = 283
  Top = 213
  Width = 438
  Height = 335
  Caption = 'Events'
  OldCreateOrder = True
  Position = poDesigned
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 150
    Width = 430
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object lstEvents: TListView
    Left = 0
    Top = 0
    Width = 430
    Height = 150
    Align = alTop
    Checkboxes = True
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
    ReadOnly = True
    RowSelect = True
    SmallImages = Exodus.ImageList2
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lstEventsChange
    OnDblClick = lstEventsDblClick
    OnKeyDown = lstEventsKeyDown
  end
  object txtMsg: TRichEdit
    Left = 0
    Top = 153
    Width = 430
    Height = 129
    Align = alClient
    ReadOnly = True
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 282
    Width = 430
    Height = 19
    Panels = <>
    SimplePanel = False
  end
end
