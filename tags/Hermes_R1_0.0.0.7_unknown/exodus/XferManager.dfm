inherited frmXferManager: TfrmXferManager
  Left = 251
  Top = 229
  Width = 444
  Caption = 'File Transfer Manager'
  OldCreateOrder = True
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object box: TScrollBox
    Left = 0
    Top = 33
    Width = 436
    Height = 164
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 436
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    object btnClose: TSpeedButton
      Left = 410
      Top = 5
      Width = 23
      Height = 21
      Caption = 'X'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
      OnClick = btnCloseClick
    end
    object pnlCaption: TTntPanel
      Left = 3
      Top = 4
      Width = 403
      Height = 26
      BevelOuter = bvLowered
      Caption = 'File Transfers'
      Color = clHighlight
      ParentBackground = False
      TabOrder = 0
    end
  end
  object httpServer: TIdHTTPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 5280
    Greeting.NumericCode = 0
    ListenQueue = 1
    MaxConnectionReply.NumericCode = 0
    OnDisconnect = httpServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    OnCommandGet = httpServerCommandGet
    Left = 40
    Top = 40
  end
  object tcpServer: TIdTCPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 5347
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = tcpServerConnect
    OnExecute = tcpServerExecute
    OnDisconnect = tcpServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 72
    Top = 40
  end
  object OpenDialog1: TOpenDialog
    Filter = 'All Files|*.*'
    Left = 8
    Top = 40
  end
end
