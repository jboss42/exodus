object frmRoom: TfrmRoom
  Left = 302
  Top = 278
  Width = 443
  Height = 349
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
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 0
    Top = 281
    Width = 435
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ResizeStyle = rsUpdate
  end
  object Panel3: TPanel
    Left = 0
    Top = 26
    Width = 435
    Height = 255
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'pnlMsgs'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 323
      Top = 4
      Width = 3
      Height = 247
      Cursor = crHSplit
      Align = alRight
      ResizeStyle = rsUpdate
    end
    object Panel6: TPanel
      Left = 326
      Top = 4
      Width = 105
      Height = 247
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 1
      Caption = '`'
      TabOrder = 0
      object treeRoster: TTreeView
        Left = 1
        Top = 1
        Width = 103
        Height = 245
        Align = alClient
        Images = frmRosterWindow.ImageList1
        Indent = 19
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
      Width = 319
      Height = 247
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 1
      OnURLClick = MsgListURLClick
    end
  end
  object pnlInput: TPanel
    Left = 0
    Top = 284
    Width = 435
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 2
    Caption = 'pnlInput'
    TabOrder = 1
    object MsgOut: TMemo
      Left = 2
      Top = 2
      Width = 402
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
    object Panel5: TPanel
      Left = 404
      Top = 2
      Width = 29
      Height = 27
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnSend: TSpeedButton
        Left = 4
        Top = 3
        Width = 23
        Height = 22
        Hint = 'Send'
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555775777777
          57705557757777775FF7555555555555000755555555555F777F555555555550
          87075555555555F7577F5555555555088805555555555F755F75555555555033
          805555555555F755F75555555555033B05555555555F755F75555555555033B0
          5555555555F755F75555555555033B05555555555F755F75555555555033B055
          55555555F755F75555555555033B05555555555F755F75555555555033B05555
          555555F75FF75555555555030B05555555555F7F7F75555555555000B0555555
          5555F777F7555555555501900555555555557777755555555555099055555555
          5555777755555555555550055555555555555775555555555555}
        NumGlyphs = 2
        OnClick = btnSendClick
      end
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 0
    Width = 435
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 2
    object Panel1: TPanel
      Left = 402
      Top = 2
      Width = 31
      Height = 22
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnClose: TSpeedButton
        Left = 2
        Top = 1
        Width = 23
        Height = 21
        Hint = 'Close this chat window'
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000CE0E0000C40E00001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888898888898888888888888899988888889888889998888889
          8888888999888899888888889998899888888888899999888888888888999888
          8888888889999988888888889998898888888899998888998888899998888889
          9888899888888888998888888888888888888888888888888888}
        OnClick = btnCloseClick
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 2
      Width = 400
      Height = 22
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object lblSubject: TLabel
        Left = 39
        Top = 0
        Width = 361
        Height = 22
        Align = alClient
      end
      object lblSubjectURL: TLabel
        Left = 0
        Top = 0
        Width = 39
        Height = 22
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
end
