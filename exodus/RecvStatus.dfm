object fRecvStatus: TfRecvStatus
  Left = 0
  Top = 0
  Width = 486
  Height = 43
  TabOrder = 0
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 155
    Height = 43
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 0
    object lblFile: TTntLabel
      Left = 2
      Top = 15
      Width = 151
      Height = 26
      Align = alClient
      Caption = 'lblFile'
      Transparent = False
      Layout = tlCenter
    end
    object lblFrom: TTntLabel
      Left = 2
      Top = 2
      Width = 151
      Height = 13
      Align = alTop
      Caption = 'lblFrom'
      Transparent = False
    end
  end
  object Panel2: TPanel
    Left = 155
    Top = 0
    Width = 162
    Height = 43
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 7
    TabOrder = 1
    object lblStatus: TTntLabel
      Left = 7
      Top = 7
      Width = 148
      Height = 13
      Align = alTop
      Caption = 'Status...'
    end
    object Bar1: TProgressBar
      Left = 7
      Top = 20
      Width = 148
      Height = 17
      Align = alTop
      TabOrder = 0
    end
  end
  object Panel1: TPanel
    Left = 317
    Top = 0
    Width = 169
    Height = 43
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object btnRecv: TButton
      Left = 8
      Top = 11
      Width = 75
      Height = 26
      Caption = 'Receive'
      TabOrder = 0
      OnClick = btnRecvClick
    end
    object btnCancel: TButton
      Left = 88
      Top = 10
      Width = 75
      Height = 26
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object httpClient: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
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
    Left = 224
  end
  object tcpClient: TIdTCPClient
    IOHandler = SocksHandler
    MaxLineAction = maException
    ReadTimeout = 0
    Port = 0
    Left = 256
  end
  object SaveDialog1: TSaveDialog
    Left = 192
  end
  object SocksHandler: TIdIOHandlerSocket
    SocksInfo = IdSocksInfo1
    UseNagle = False
    Left = 288
  end
  object IdSocksInfo1: TIdSocksInfo
    Version = svSocks5
    Left = 320
  end
end
