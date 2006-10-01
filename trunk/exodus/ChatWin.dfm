inherited frmChat: TfrmChat
  Left = 432
  Top = 384
  ActiveControl = MsgOut
  Caption = 'Chat Window'
  ClientHeight = 267
  ClientWidth = 383
  Font.Charset = ANSI_CHARSET
  OldCreateOrder = True
  OnClose = FormClose
  OnResize = FormResize
  ExplicitWidth = 391
  ExplicitHeight = 301
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Top = 234
    Width = 383
    ExplicitTop = 239
    ExplicitWidth = 383
  end
  inherited pnlMsgList: TPanel
    Top = 32
    Width = 383
    Height = 173
    ExplicitTop = 32
    ExplicitWidth = 383
    ExplicitHeight = 173
  end
  inherited pnlInput: TPanel
    Top = 239
    Width = 383
    ExplicitTop = 239
    ExplicitWidth = 383
    inherited MsgOut: TExRichEdit
      Width = 379
      WantReturns = False
      OnChange = MsgOutChange
    end
  end
  inherited Panel1: TPanel
    Width = 383
    Height = 32
    ExplicitWidth = 383
    ExplicitHeight = 32
    object btnClose: TSpeedButton
      Left = 354
      Top = 2
      Width = 23
      Height = 21
      Caption = 'X'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
      OnClick = btnCloseClick
      OnMouseDown = btnCloseMouseDown
    end
    object pnlJID: TPanel
      Left = 2
      Top = 2
      Width = 351
      Height = 28
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblNick: TTntLabel
        Left = 43
        Top = 0
        Width = 48
        Height = 13
        Cursor = crHandPoint
        Align = alLeft
        Caption = 'Nickname'
        ParentShowHint = False
        ShowHint = True
        Layout = tlCenter
        OnClick = lblJIDClick
      end
      object imgAvatar: TPaintBox
        Left = 0
        Top = 0
        Width = 35
        Height = 28
        Align = alLeft
        OnClick = imgAvatarClick
        OnPaint = imgAvatarPaint
      end
      object Panel3: TPanel
        Left = 35
        Top = 0
        Width = 8
        Height = 28
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
  end
  inherited tbMsgOutToolbar: TTntToolBar
    Top = 205
    Width = 383
    ExplicitTop = 205
    ExplicitWidth = 383
  end
  object popContact: TTntPopupMenu [5]
    Left = 16
    Top = 152
    object mnuSave: TTntMenuItem
      Caption = 'Save Conversation'
      OnClick = mnuSaveClick
    end
    object mnuHistory: TTntMenuItem
      Caption = 'Show History ...'
      OnClick = doHistory
    end
    object popClearHistory: TTntMenuItem
      Caption = 'Clear History'
      OnClick = popClearHistoryClick
    end
    object PrintHistory1: TTntMenuItem
      Caption = 'Print ...'
      OnClick = PrintHistory1Click
    end
    object N5: TTntMenuItem
      Caption = '-'
    end
    object popResources: TTntMenuItem
      AutoHotkeys = maManual
      Caption = 'Resources'
    end
    object N4: TTntMenuItem
      Caption = '-'
    end
    object mnuSendFile: TTntMenuItem
      Caption = 'Send File ...'
      OnClick = mnuSendFileClick
    end
    object popAddContact: TTntMenuItem
      Caption = 'Add to roster ...'
      OnClick = doAddToRoster
    end
    object mnuProfile: TTntMenuItem
      Caption = 'Show Profile ...'
      OnClick = doProfile
    end
    object C1: TTntMenuItem
      Caption = 'Contact Info'
      object mnuVersionRequest: TTntMenuItem
        Caption = 'Version Request'
        OnClick = CTCPClick
      end
      object mnuTimeRequest: TTntMenuItem
        Caption = 'Time Request'
        OnClick = CTCPClick
      end
      object mnuLastActivity: TTntMenuItem
        Caption = 'Last Activity'
        OnClick = CTCPClick
      end
    end
    object mnuBlock: TTntMenuItem
      Caption = 'Block Contact'
      OnClick = mnuBlockClick
    end
    object N1: TTntMenuItem
      Caption = '-'
    end
    object NotificationOptions1: TTntMenuItem
      Caption = 'Notification Options ...'
      OnClick = NotificationOptions1Click
    end
    object mnuOnTop: TTntMenuItem
      Caption = 'Always on Top'
      OnClick = mnuOnTopClick
    end
    object mnuReturns: TTntMenuItem
      Caption = 'Embed Returns'
      OnClick = mnuReturnsClick
    end
    object mnuWordwrap: TTntMenuItem
      Caption = 'Word Wrap Input'
      OnClick = mnuWordwrapClick
    end
  end
  object SaveDialog1: TSaveDialog [6]
    DefaultExt = 'html'
    Filter = 'RTF Files|*.rtf|All Files|*.*'
    Left = 48
    Top = 184
  end
  object timBusy: TTimer
    Enabled = False
    Interval = 800
    OnTimer = timBusyTimer
    Left = 48
    Top = 152
  end
  object PrintDialog1: TPrintDialog
    Options = [poSelection]
    Left = 80
    Top = 184
  end
end
