object frmMsgQueue: TfrmMsgQueue
  Left = 233
  Top = 238
  Width = 432
  Height = 324
  Caption = 'Events'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 150
    Width = 424
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object lstEvents: TListView
    Left = 0
    Top = 0
    Width = 424
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
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    SmallImages = frmExodus.ImageList2
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lstEventsChange
    OnData = lstEventsData
    OnDblClick = lstEventsDblClick
    OnKeyDown = lstEventsKeyDown
  end
  object txtMsg: TRichEdit
    Left = 0
    Top = 153
    Width = 424
    Height = 137
    Align = alClient
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
