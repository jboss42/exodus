inherited frmChat: TfrmChat
  Left = 432
  Top = 384
  ActiveControl = MsgOut
  Caption = 'Chat Window'
  ClientHeight = 384
  ClientWidth = 454
  OldCreateOrder = True
  ExplicitWidth = 500
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 12
  inherited Splitter1: TSplitter
    Top = 325
    Width = 454
    ExplicitTop = 354
    ExplicitWidth = 454
  end
  inherited pnlDockTop: TPanel
    Width = 454
    ExplicitWidth = 454
    inherited tbDockBar: TToolBar
      Left = 443
      ExplicitLeft = 443
    end
    inherited pnlChatTop: TPanel
      Width = 406
      ExplicitWidth = 406
      object pnlJID: TPanel
        Left = 0
        Top = 0
        Width = 324
        Height = 30
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object lblNick: TTntLabel
          Left = 40
          Top = 0
          Width = 44
          Height = 12
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
          Width = 32
          Height = 30
          Align = alLeft
          OnClick = imgAvatarClick
          OnPaint = imgAvatarPaint
        end
        object Panel3: TPanel
          Left = 32
          Top = 0
          Width = 8
          Height = 30
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
        end
      end
    end
  end
  inherited pnlMsgList: TPanel
    Width = 454
    Height = 295
    ExplicitWidth = 454
    ExplicitHeight = 295
  end
  inherited pnlInput: TPanel
    Top = 358
    Width = 454
    ExplicitTop = 358
    ExplicitWidth = 454
    inherited MsgOut: TExRichEdit
      Width = 450
      WantReturns = False
      OnChange = MsgOutChange
    end
  end
  inherited tbMsgOutToolbar: TTntToolBar
    Top = 329
    Width = 454
    ExplicitTop = 329
    ExplicitWidth = 454
  end
  object SaveDialog1: TSaveDialog [5]
    DefaultExt = 'html'
    Filter = 'RTF Files|*.rtf|All Files|*.*'
    Left = 48
    Top = 184
  end
  inherited popMsgList: TTntPopupMenu
    object Print1: TTntMenuItem
      Caption = 'Print...'
      OnClick = Print1Click
    end
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
  object popContact: TTntPopupMenu
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
      Caption = 'Add to Contact List ...'
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
end
