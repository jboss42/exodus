object fSendStatus: TfSendStatus
  Left = 0
  Top = 0
  Width = 402
  Height = 46
  TabOrder = 0
  object Panel1: TPanel
    Left = 313
    Top = 0
    Width = 89
    Height = 46
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object btnCancel: TButton
      Left = 8
      Top = 11
      Width = 75
      Height = 26
      Caption = 'Cancel'
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 155
    Top = 0
    Width = 158
    Height = 46
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 7
    TabOrder = 1
    object lblStatus: TTntLabel
      Left = 7
      Top = 7
      Width = 144
      Height = 13
      Align = alTop
      Caption = 'Status...'
    end
    object Bar1: TProgressBar
      Left = 7
      Top = 20
      Width = 144
      Height = 17
      Align = alTop
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 155
    Height = 46
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 2
    object lblFile: TTntLabel
      Left = 2
      Top = 15
      Width = 151
      Height = 29
      Align = alClient
      Caption = 'lblFile'
      Transparent = False
      Layout = tlCenter
    end
    object lblTo: TTntLabel
      Left = 2
      Top = 2
      Width = 151
      Height = 13
      Align = alTop
      Caption = 'lblTo'
      Transparent = False
    end
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
    Left = 248
  end
  object tcpClient: TIdTCPClient
    IOHandler = SocksHandler
    MaxLineAction = maException
    ReadTimeout = 0
    Port = 0
    Left = 216
  end
  object SocksHandler: TIdIOHandlerSocket
    SocksInfo = IdSocksInfo1
    UseNagle = False
    Left = 184
  end
  object IdSocksInfo1: TIdSocksInfo
    Version = svSocks5
    Left = 280
  end
end
