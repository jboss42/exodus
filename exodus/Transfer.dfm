object frmTransfer: TfrmTransfer
  Left = 383
  Top = 358
  Width = 267
  Height = 207
  Caption = 'File Transfer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFrom: TPanel
    Left = 0
    Top = 0
    Width = 259
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 0
    object lblFrom: TStaticText
      Left = 2
      Top = 2
      Width = 63
      Height = 18
      Align = alLeft
      Caption = 'From:     '
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
    object txtFrom: TStaticText
      Left = 65
      Top = 2
      Width = 192
      Height = 18
      Align = alClient
      Caption = '<JID>'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
  end
  object txtMsg: TExRichEdit
    Left = 0
    Top = 22
    Width = 259
    Height = 92
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
    ShowSelectionBar = False
    TabOrder = 1
    URLColor = clBlue
    URLCursor = crHandPoint
    OnURLClick = txtMsgURLClick
    InputFormat = ifRTF
    OutputFormat = ofRTF
    SelectedInOut = False
    PlainRTF = False
    UndoLimit = 0
    AllowInPlace = False
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 139
    Width = 259
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 2
    inherited Bevel1: TBevel
      Width = 259
    end
    inherited Panel1: TPanel
      Left = 99
      Height = 29
      inherited btnOK: TButton
        Caption = 'Receive'
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object pnlProgress: TPanel
    Left = 0
    Top = 114
    Width = 259
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 3
    object Label1: TLabel
      Left = 3
      Top = 3
      Width = 53
      Height = 19
      Align = alLeft
      Alignment = taCenter
      Caption = 'Progress:   '
    end
    object bar1: TProgressBar
      Left = 56
      Top = 3
      Width = 200
      Height = 19
      Align = alClient
      Min = 0
      Max = 100
      TabOrder = 0
    end
  end
  object httpServer: TIdHTTPServer
    Bindings = <>
    DefaultPort = 5280
    OnConnect = httpServerConnect
    OnDisconnect = httpServerDisconnect
    OnCommandGet = httpServerCommandGet
    AutoStartSession = True
    Left = 184
    Top = 32
  end
  object httpClient: TIdHTTP
    OnWork = httpClientWork
    OnWorkBegin = httpClientWorkBegin
    OnWorkEnd = httpClientWorkEnd
    Request.Accept = 'text/html, */*'
    Request.ContentLength = 0
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ProxyPort = 0
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Left = 216
    Top = 32
  end
  object OpenDialog1: TOpenDialog
    Left = 144
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    Left = 112
    Top = 32
  end
end
