inherited frmXferManager: TfrmXferManager
  Left = 238
  Top = 254
  Width = 444
  Caption = 'File Transfer Manager'
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object box: TScrollBox
    Left = 0
    Top = 0
    Width = 436
    Height = 216
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    TabOrder = 0
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
    Left = 40
    Top = 48
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
    Left = 8
    Top = 48
  end
  object OpenDialog1: TOpenDialog
    Left = 104
    Top = 48
  end
  object IdServerIOHandlerSocket1: TIdServerIOHandlerSocket
    Left = 72
    Top = 49
  end
end
