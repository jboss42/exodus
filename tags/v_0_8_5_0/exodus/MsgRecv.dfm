object frmMsgRecv: TfrmMsgRecv
  Left = 249
  Top = 170
  Width = 385
  Height = 416
  Caption = 'Message'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnEndDock = FormEndDock
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 192
    Width = 377
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object pnlReply: TPanel
    Left = 0
    Top = 195
    Width = 377
    Height = 192
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 2
    Visible = False
    inline frameButtons2: TframeButtons
      Left = 3
      Top = 155
      Width = 371
      Height = 34
      Align = alBottom
      AutoScroll = False
      TabOrder = 1
      inherited Panel2: TPanel
        Width = 371
        Height = 34
        inherited Bevel1: TBevel
          Width = 371
        end
        inherited Panel1: TPanel
          Left = 211
          Height = 29
          inherited btnCancel: TButton [0]
            OnClick = frameButtons2btnCancelClick
          end
          inherited btnOK: TButton [1]
            Caption = '&Send'
            OnClick = frameButtons2btnOKClick
          end
        end
      end
    end
    object MsgOut: TExRichEdit
      Left = 3
      Top = 3
      Width = 371
      Height = 152
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
      PopupMenu = popClipboard
      ShowSelectionBar = False
      TabOrder = 0
      URLColor = clBlue
      URLCursor = crHandPoint
      OnKeyDown = MsgOutKeyDown
      OnKeyPress = MsgOutKeyPress
      OnKeyUp = MsgOutKeyUp
      OnURLClick = txtMsgURLClick
      InputFormat = ifUnicode
      OutputFormat = ofRTF
      SelectedInOut = False
      PlainRTF = False
      UndoLimit = 0
      AllowInPlace = False
    end
  end
  object txtMsg: TExRichEdit
    Left = 0
    Top = 76
    Width = 377
    Height = 86
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
    PopupMenu = popClipboard
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
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 377
    Height = 76
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object pnlHeader: TPanel
      Left = 41
      Top = 0
      Width = 336
      Height = 76
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object pnlSendSubject: TPanel
        Left = 0
        Top = 22
        Width = 336
        Height = 24
        Align = alTop
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 0
        Visible = False
        object lblSubject1: TLabel
          Left = 2
          Top = 2
          Width = 64
          Height = 20
          Align = alLeft
          Caption = 'Subject:    '
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
        end
        object txtSendSubject: TTntMemo
          Left = 66
          Top = 2
          Width = 268
          Height = 20
          Align = alClient
          TabOrder = 0
          WantReturns = False
          WordWrap = False
        end
      end
      object pnlSubject: TPanel
        Left = 0
        Top = 46
        Width = 336
        Height = 22
        Align = alTop
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 1
        object txtSubject: TTntLabel
          Left = 53
          Top = 2
          Width = 281
          Height = 18
          Align = alClient
          Caption = 'txtSubject'
        end
        object lblSubject2: TStaticText
          Left = 2
          Top = 2
          Width = 51
          Height = 18
          Align = alLeft
          Caption = 'Subject:'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 0
        end
      end
      object pnlFrom: TPanel
        Left = 0
        Top = 0
        Width = 336
        Height = 22
        Align = alTop
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 2
        object btnClose: TSpeedButton
          Left = 310
          Top = 2
          Width = 23
          Height = 20
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
        object txtFrom: TTntLabel
          Left = 53
          Top = 2
          Width = 41
          Height = 18
          Cursor = crHandPoint
          Align = alLeft
          Caption = 'txtFrom'
          Color = clBtnFace
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial Unicode MS'
          Font.Style = [fsUnderline]
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = txtFromClick
        end
        object lblFrom: TStaticText
          Left = 2
          Top = 2
          Width = 51
          Height = 18
          Align = alLeft
          Caption = 'From:    '
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object pnlError: TPanel
      Left = 0
      Top = 0
      Width = 41
      Height = 76
      Align = alLeft
      BevelOuter = bvNone
      BorderWidth = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Visible = False
      object Image1: TImage
        Left = 3
        Top = 3
        Width = 32
        Height = 38
        Picture.Data = {
          055449636F6E0000010001002020100000000000E80200001600000028000000
          2000000040000000010004000000000080020000000000000000000000000000
          0000000000000000000080000080000000808000800000008000800080800000
          C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
          FFFFFF0000000888888888888888888888888800000088888888888888888888
          888888800030000000000000000000000008888803BBBBBBBBBBBBBBBBBBBBBB
          BB7088883BBBBBBBBBBBBBBBBBBBBBBBBBB708883BBBBBBBBBBBBBBBBBBBBBBB
          BBBB08883BBBBBBBBBBBB7007BBBBBBBBBBB08803BBBBBBBBBBBB0000BBBBBBB
          BBB7088003BBBBBBBBBBB0000BBBBBBBBBB0880003BBBBBBBBBBB7007BBBBBBB
          BB708800003BBBBBBBBBBBBBBBBBBBBBBB088000003BBBBBBBBBBB0BBBBBBBBB
          B70880000003BBBBBBBBB707BBBBBBBBB08800000003BBBBBBBBB303BBBBBBBB
          7088000000003BBBBBBBB000BBBBBBBB0880000000003BBBBBBB70007BBBBBB7
          08800000000003BBBBBB30003BBBBBB088000000000003BBBBBB00000BBBBB70
          880000000000003BBBBB00000BBBBB08800000000000003BBBBB00000BBBB708
          8000000000000003BBBB00000BBBB0880000000000000003BBBB00000BBB7088
          00000000000000003BBB70007BBB088000000000000000003BBBBBBBBBB70880
          000000000000000003BBBBBBBBB08800000000000000000003BBBBBBBB708800
          0000000000000000003BBBBBBB0880000000000000000000003BBBBBB7088000
          00000000000000000003BBBBB088000000000000000000000003BBBB70800000
          000000000000000000003BB70000000000000000000000000000033300000000
          00000000F8000003F0000001C000000080000000000000000000000000000001
          000000018000000380000003C0000007C0000007E000000FE000000FF000001F
          F000001FF800003FF800003FFC00007FFC00007FFE0000FFFE0000FFFF0001FF
          FF0001FFFF8003FFFF8003FFFFC007FFFFC007FFFFE00FFFFFE01FFFFFF07FFF
          FFF8FFFF}
      end
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 162
    Width = 377
    Height = 30
    Align = alBottom
    AutoScroll = False
    TabOrder = 3
    inherited Panel2: TPanel
      Width = 377
      Height = 30
      inherited Bevel1: TBevel
        Width = 377
      end
      inherited Panel1: TPanel
        Left = 217
        Height = 25
        inherited btnOK: TButton
          Caption = 'Reply'
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TButton
          Caption = 'Close'
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object popContact: TPopupMenu
    Left = 32
    Top = 192
    object mnuHistory: TMenuItem
      Caption = 'Show History'
      OnClick = mnuHistoryClick
    end
    object popClearHistory: TMenuItem
      Caption = 'Clear History'
      OnClick = popClearHistoryClick
    end
    object mnuProfile: TMenuItem
      Caption = 'Show Profile'
      OnClick = mnuProfileClick
    end
    object C1: TMenuItem
      Caption = 'Client Info'
      object mnuVersionRequest: TMenuItem
        Caption = 'Version Request'
        OnClick = mnuVersionRequestClick
      end
      object mnuTimeRequest: TMenuItem
        Caption = 'Time Request'
        OnClick = mnuVersionRequestClick
      end
      object mnuLastActivity: TMenuItem
        Caption = 'Last Activity'
        OnClick = mnuVersionRequestClick
      end
    end
    object mnuBlock: TMenuItem
      Caption = 'Block Contact'
      OnClick = mnuBlockClick
    end
    object mnuSendFile: TMenuItem
      Caption = 'Send File'
      OnClick = mnuSendFileClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuResources: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Resources'
      object TMenuItem
      end
    end
    object N2: TMenuItem
      Caption = '-'
    end
  end
  object popClipboard: TPopupMenu
    OnPopup = popClipboardPopup
    Left = 72
    Top = 192
    object popCopy: TMenuItem
      Caption = 'Copy'
      OnClick = popCopyClick
    end
    object popPaste: TMenuItem
      Caption = 'Paste'
      OnClick = popPasteClick
    end
  end
end
