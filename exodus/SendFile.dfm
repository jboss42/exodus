inherited frmSendFile: TfrmSendFile
  Left = 233
  Top = 223
  Width = 279
  Height = 207
  BorderWidth = 2
  Caption = 'Send A File'
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 136
    Width = 267
    Height = 36
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Panel2: TPanel
      Width = 267
      inherited Bevel1: TBevel
        Width = 267
      end
      inherited Panel1: TPanel
        Left = 107
        inherited btnOK: TTntButton
          Caption = 'Send'
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object pnlFrom: TPanel
    Left = 0
    Top = 0
    Width = 267
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 1
    object lblFrom: TTntLabel
      Left = 0
      Top = 0
      Width = 20
      Height = 13
      Caption = 'To:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTo: TTntLabel
      Left = 50
      Top = 0
      Width = 23
      Height = 13
      Caption = 'lblTo'
      ParentShowHint = False
      ShowHint = True
    end
    object lblFile: TTntLabel
      Left = 50
      Top = 16
      Width = 52
      Height = 13
      Caption = 'lblFilename'
      ParentShowHint = False
      ShowHint = True
    end
    object Label5: TTntLabel
      Left = 0
      Top = 16
      Width = 25
      Height = 13
      Caption = 'File:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDesc: TTntLabel
      Left = 0
      Top = 40
      Width = 84
      Height = 13
      Caption = 'Enter Description:'
    end
  end
  object txtMsg: TExRichEdit
    Left = 0
    Top = 57
    Width = 267
    Height = 79
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
    ShowSelectionBar = False
    TabOrder = 2
    URLColor = clBlue
    URLCursor = crHandPoint
    InputFormat = ifRTF
    OutputFormat = ofRTF
    SelectedInOut = False
    PlainRTF = False
    UndoLimit = 0
    AllowInPlace = False
  end
  object OpenDialog1: TOpenDialog
    Left = 128
  end
  object TCPServer: TIdTCPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 0
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 160
  end
  object SocksInfo: TIdSocksInfo
    Left = 192
  end
  object httpServer: TIdHTTPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 5280
    Greeting.NumericCode = 0
    ListenQueue = 1
    MaxConnectionReply.NumericCode = 0
    OnConnect = httpServerConnect
    OnDisconnect = httpServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    OnCommandGet = httpServerCommandGet
    Left = 224
  end
  object httpClient: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 96
  end
end
