inherited frmChat: TfrmChat
  Left = 315
  Top = 397
  Caption = 'Chat Window'
  Font.Charset = ANSI_CHARSET
  Font.Height = -13
  Font.Name = 'Arial Unicode MS'
  OldCreateOrder = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  inherited Panel3: TPanel
    Top = 24
    Height = 229
    inherited MsgList: TExRichEdit
      Height = 221
      PlainRTF = True
    end
  end
  inherited pnlInput: TPanel
    inherited MsgOut: TExRichEdit
      WantReturns = False
      OnChange = MsgOutChange
    end
  end
  inherited Panel1: TPanel
    Height = 24
    object btnClose: TSpeedButton
      Left = 354
      Top = 2
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
      OnMouseDown = btnCloseMouseDown
    end
    object pnlJID: TPanel
      Left = 2
      Top = 2
      Width = 351
      Height = 20
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object imgStatus: TPaintBox
        Tag = 1
        Left = 0
        Top = 0
        Width = 20
        Height = 20
        Align = alLeft
        ParentShowHint = False
        ShowHint = True
        OnPaint = imgStatusPaint
      end
      object lblNick: TTntLabel
        Left = 20
        Top = 0
        Width = 86
        Height = 20
        Align = alLeft
        Caption = ' Foo '#32072#32073#32074#32075' '
        Caption_UTF7 = ' Foo +fUh9SX1KfUs '
      end
      object lblJID: TTntLabel
        Left = 106
        Top = 0
        Width = 35
        Height = 20
        Cursor = crHandPoint
        Align = alLeft
        Caption = '<JID>'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        OnClick = lblJIDClick
      end
    end
  end
  object popContact: TPopupMenu [5]
    Left = 16
    Top = 152
    object mnuHistory: TMenuItem
      Caption = 'Show History ...'
      OnClick = doHistory
    end
    object popClearHistory: TMenuItem
      Caption = 'Clear History'
      OnClick = popClearHistoryClick
    end
    object mnuProfile: TMenuItem
      Caption = 'Show Profile ...'
      OnClick = doProfile
    end
    object C1: TMenuItem
      Caption = 'Client Info'
      object mnuVersionRequest: TMenuItem
        Caption = 'Version Request'
        OnClick = CTCPClick
      end
      object mnuTimeRequest: TMenuItem
        Caption = 'Time Request'
        OnClick = CTCPClick
      end
      object mnuLastActivity: TMenuItem
        Caption = 'Last Activity'
        OnClick = CTCPClick
      end
    end
    object popAddContact: TMenuItem
      Caption = 'Add to roster ...'
      OnClick = doAddToRoster
    end
    object mnuBlock: TMenuItem
      Caption = 'Block Contact'
      OnClick = mnuBlockClick
    end
    object mnuSendFile: TMenuItem
      Caption = 'Send File ...'
      OnClick = mnuSendFileClick
    end
    object mnuSave: TMenuItem
      Caption = 'Save Conversation'
      OnClick = mnuSaveClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object NotificationOptions1: TMenuItem
      Caption = 'Notification Options ...'
      OnClick = NotificationOptions1Click
    end
    object mnuOnTop: TMenuItem
      Caption = 'Always on Top'
      OnClick = mnuOnTopClick
    end
    object mnuReturns: TMenuItem
      Caption = 'Embed Returns'
      OnClick = mnuReturnsClick
    end
    object mnuWordwrap: TMenuItem
      Caption = 'Word Wrap Input'
      OnClick = mnuWordwrapClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
  end
  object timFlash: TTimer [6]
    Enabled = False
    Interval = 500
    OnTimer = timFlashTimer
    Left = 48
    Top = 152
  end
  object SaveDialog1: TSaveDialog [7]
    DefaultExt = 'html'
    Filter = 'RTF Files|*.rtf|All Files|*.*'
    Left = 48
    Top = 184
  end
  object timBusy: TTimer
    Enabled = False
    Interval = 800
    OnTimer = timBusyTimer
    Left = 80
    Top = 152
  end
end
