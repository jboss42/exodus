object frmTransfer: TfrmTransfer
  Left = 252
  Top = 175
  Width = 267
  Height = 207
  ActiveControl = frameButtons1.btnOK
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFrom: TPanel
    Left = 0
    Top = 0
    Width = 259
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 0
    object lblFrom: TLabel
      Left = 0
      Top = 0
      Width = 32
      Height = 13
      Caption = 'From:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object txtFrom: TLabel
      Left = 50
      Top = 0
      Width = 34
      Height = 13
      Caption = 'txtFrom'
      ParentShowHint = False
      ShowHint = True
    end
    object lblFile: TLabel
      Left = 50
      Top = 16
      Width = 32
      Height = 13
      Caption = 'Label3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = lblFileClick
    end
    object Label5: TLabel
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
    object lblDesc: TLabel
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
    Width = 259
    Height = 62
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
    TabOrder = 1
    URLColor = clBlue
    URLCursor = crHandPoint
    OnKeyDown = txtMsgKeyDown
    InputFormat = ifRTF
    OutputFormat = ofRTF
    SelectedInOut = False
    PlainRTF = False
    UndoLimit = 0
    AllowInPlace = False
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 144
    Width = 259
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 2
    inherited Panel2: TPanel
      Width = 259
      Height = 34
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
  end
  object pnlProgress: TPanel
    Left = 0
    Top = 119
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
      TabOrder = 0
    end
  end
  object httpClient: TIdHTTP
    OnStatus = httpClientStatus
    MaxLineAction = maException
    ReadTimeout = 0
    OnDisconnected = httpClientDisconnected
    OnWork = httpClientWork
    OnWorkBegin = httpClientWorkBegin
    OnWorkEnd = httpClientWorkEnd
    OnConnected = httpClientConnected
    AllowCookies = False
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = 0
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 168
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    Left = 136
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    Left = 104
    Top = 8
  end
end
