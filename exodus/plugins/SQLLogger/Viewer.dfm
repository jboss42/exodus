object frmView: TfrmView
  Left = 247
  Top = 149
  Width = 499
  Height = 580
  BorderWidth = 5
  Caption = 'frmView'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MsgList: TExRichEdit
    Left = 197
    Top = 41
    Width = 284
    Height = 499
    Align = alClient
    AutoURLDetect = adNone
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
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Unicode MS'
    Font.Style = []
    LangOptions = [loAutoFont]
    Language = 1033
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    ShowSelectionBar = False
    TabOrder = 0
    URLColor = clBlue
    URLCursor = crHandPoint
    InputFormat = ifUnicode
    OutputFormat = ofRTF
    SelectedInOut = False
    PlainRTF = False
    UndoLimit = 0
    AllowInPlace = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 481
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 197
    Height = 499
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    object pnlCal: TPanel
      Left = 0
      Top = 0
      Width = 197
      Height = 189
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial Unicode MS'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object TntPanel1: TTntPanel
        Left = 1
        Top = 163
        Width = 195
        Height = 25
        Align = alBottom
        Caption = 'Today: 4/30/2004'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        DesignSize = (
          195
          25)
        object btnPrevMonth: TSpeedButton
          Left = 4
          Top = 5
          Width = 23
          Height = 15
          Flat = True
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
            DADAADADADADADADADADDADADADADADADADAADADADADADADADADDADADADAD1DA
            DADAADADADAD11ADADADDADADAD111DADADAADADAD1111ADADADDADAD11111DA
            DADAADADAD1111ADADADDADADAD111DADADAADADADAD11ADADADDADADADAD1DA
            DADAADADADADADADADADDADADADADADADADAADADADADADADADAD}
          OnClick = btnNextMonthClick
        end
        object btnNextMonth: TSpeedButton
          Left = 168
          Top = 5
          Width = 23
          Height = 15
          Anchors = [akTop, akRight]
          Flat = True
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
            DADAADADADADADADADADDADADADADADADADAADADADADADADADADDADADA1ADADA
            DADAADADAD11ADADADADDADADA111ADADADAADADAD1111ADADADDADADA11111A
            DADAADADAD1111ADADADDADADA111ADADADAADADAD11ADADADADDADADA1ADADA
            DADAADADADADADADADADDADADADADADADADAADADADADADADADAD}
          OnClick = btnNextMonthClick
        end
      end
      object pnlCalHeader: TTntPanel
        Left = 1
        Top = 1
        Width = 195
        Height = 25
        Align = alTop
        Caption = 'April, 2004'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial Unicode MS'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object gridCal: TTntStringGrid
        Left = 1
        Top = 26
        Width = 195
        Height = 137
        Align = alClient
        BorderStyle = bsNone
        ColCount = 7
        DefaultColWidth = 27
        DefaultRowHeight = 17
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 7
        Options = [goFixedHorzLine]
        ScrollBars = ssNone
        TabOrder = 2
        OnDrawCell = gridCalDrawCell
        OnSelectCell = gridCalSelectCell
      end
    end
  end
end
