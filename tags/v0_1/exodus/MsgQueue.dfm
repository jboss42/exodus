inherited frmMsgQueue: TfrmMsgQueue
  Left = 283
  Top = 131
  Width = 438
  Height = 335
  Caption = 'Messages'
  OldCreateOrder = True
  Position = poDesigned
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
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 430
    Height = 150
    Align = alTop
    Columns = <
      item
        Width = 20
      end
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
    TabOrder = 0
    ViewStyle = vsReport
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 153
    Width = 430
    Height = 132
    Align = alClient
    Lines.Strings = (
      'RichEdit1')
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 285
    Width = 430
    Height = 19
    Panels = <>
    SimplePanel = False
  end
end
