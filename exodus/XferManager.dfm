inherited frmXferManager: TfrmXferManager
  Left = 251
  Top = 229
  Caption = 'File Transfer Manager'
  ClientWidth = 455
  OldCreateOrder = True
  OnClose = FormClose
  OnDestroy = FormDestroy
  ExplicitWidth = 463
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlDockTop: TPanel
    Width = 455
    TabOrder = 1
    ExplicitWidth = 436
    inherited tbDockBar: TToolBar
      Left = 406
      ExplicitLeft = 387
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 403
      Height = 32
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 1
      ExplicitTop = -1
      ExplicitWidth = 436
      ExplicitHeight = 33
      object pnlCaption: TTntPanel
        Left = 5
        Top = 5
        Width = 393
        Height = 22
        Align = alClient
        BevelOuter = bvLowered
        Caption = 'File Transfers'
        Color = clHighlight
        ParentBackground = False
        TabOrder = 0
        ExplicitLeft = 3
        ExplicitTop = 4
        ExplicitWidth = 403
        ExplicitHeight = 26
      end
    end
  end
  object box: TScrollBox
    Left = 0
    Top = 32
    Width = 455
    Height = 135
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
    ExplicitTop = 65
    ExplicitWidth = 436
    ExplicitHeight = 102
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
