inherited frmChat: TfrmChat
  Left = 251
  Top = 168
  Height = 305
  ActiveControl = MsgOut
  Caption = 'Chat Window'
  Font.Charset = ANSI_CHARSET
  OldCreateOrder = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Top = 240
  end
  inherited pnlMsgList: TPanel
    Top = 32
    Height = 208
  end
  inherited pnlInput: TPanel
    Top = 243
    inherited MsgOut: TExRichEdit
      WantReturns = False
      OnChange = MsgOutChange
    end
  end
  inherited Panel1: TPanel
    Height = 32
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
      Height = 28
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object imgStatus: TPaintBox
        Tag = 1
        Left = 0
        Top = 0
        Width = 20
        Height = 28
        Align = alLeft
        ParentShowHint = False
        ShowHint = True
        OnPaint = imgStatusPaint
      end
      object lblNick: TTntLabel
        Left = 20
        Top = 0
        Width = 39
        Height = 28
        Align = alLeft
        Caption = ' Foo '#32072#32073#32074#32075' '
        Layout = tlCenter
        Caption_UTF7 = ' Foo +fUh9SX1KfUs '
      end
      object lblJID: TTntLabel
        Left = 59
        Top = 0
        Width = 28
        Height = 28
        Cursor = crHandPoint
        Align = alLeft
        Caption = '<JID>'
        Layout = tlCenter
        OnClick = lblJIDClick
      end
      object imgAvatar: TPaintBox
        Left = 316
        Top = 0
        Width = 35
        Height = 28
        Align = alRight
        OnMouseMove = imgAvatarMouseMove
        OnPaint = imgAvatarPaint
      end
    end
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
