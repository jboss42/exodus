inherited frmChat: TfrmChat
  Left = 432
  Top = 384
  ActiveControl = MsgOut
  Caption = 'Chat Window'
  ClientHeight = 416
  ClientWidth = 492
  OldCreateOrder = True
  ExplicitWidth = 500
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Top = 347
    Width = 484
    ExplicitLeft = 4
    ExplicitTop = 347
    ExplicitWidth = 486
  end
  inherited pnlDock: TTntPanel
    Width = 492
    ExplicitWidth = 492
    inherited pnlDockTopContainer: TTntPanel
      Width = 490
      AutoSize = True
      ExplicitWidth = 490
      inherited tbDockBar: TToolBar
        Left = 441
        ExplicitLeft = 441
      end
      inherited pnlDockTop: TTntPanel
        Width = 438
        ExplicitWidth = 438
        inherited pnlChatTop: TTntPanel
          Width = 438
          ExplicitWidth = 438
          object pnlJID: TPanel
            Left = 0
            Top = 0
            Width = 351
            Height = 28
            Align = alLeft
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            object lblNick: TTntLabel
              AlignWithMargins = True
              Left = 53
              Top = 0
              Width = 45
              Height = 28
              Cursor = crHandPoint
              Margins.Left = 6
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Nickname'
              ParentShowHint = False
              ShowHint = True
              Layout = tlCenter
              OnClick = lblJIDClick
              ExplicitHeight = 13
            end
            object imgAvatar: TPaintBox
              AlignWithMargins = True
              Left = 4
              Top = 0
              Width = 35
              Height = 28
              Margins.Left = 4
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              OnClick = imgAvatarClick
              OnPaint = imgAvatarPaint
              ExplicitLeft = 3
              ExplicitHeight = 34
            end
            object Panel3: TPanel
              Left = 39
              Top = 0
              Width = 8
              Height = 28
              Align = alLeft
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
            end
          end
        end
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 490
      ExplicitWidth = 490
    end
  end
  inherited pnlMsgList: TPanel
    Width = 492
    Height = 292
    Constraints.MinHeight = 25
    ExplicitWidth = 492
    ExplicitHeight = 292
  end
  inherited pnlInput: TPanel
    Top = 351
    Width = 488
    ExplicitTop = 351
    ExplicitWidth = 488
    inherited MsgOut: TExRichEdit
      Width = 484
      WantReturns = False
      OnChange = MsgOutChange
    end
    inherited pnlToolbar: TPanel
      Width = 484
      ExplicitWidth = 484
      inherited tbMsgOutToolbar: TTntToolBar
        inherited cmbPriority: TTntComboBox
          Hint = 'Priority'
        end
      end
      inherited pnlControlSite: TPanel
        Width = 163
        ExplicitWidth = 163
      end
    end
  end
  inherited popMsgList: TTntPopupMenu
    object Print1: TTntMenuItem
      Caption = 'Print...'
      OnClick = Print1Click
    end
  end
  object SaveDialog1: TSaveDialog [5]
    DefaultExt = 'html'
    Filter = 'RTF Files|*.rtf|All Files|*.*'
    Left = 48
    Top = 184
  end
  inherited AppEvents: TApplicationEvents
    Left = 112
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
    object mnuViewHistory: TTntMenuItem
      Caption = 'View History...'
      OnClick = mnuViewHistoryClick
    end
    object mnuHistory: TTntMenuItem
      Caption = 'Show History (Plugin)...'
      OnClick = doHistory
    end
    object popClearHistory: TTntMenuItem
      Caption = 'Clear History (Plugin)'
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
      OnClick = popResourcesClick
    end
    object mnuProperties: TTntMenuItem
      Caption = 'Properties...'
      OnClick = doProfile
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
    object mnuBlock: TTntMenuItem
      Caption = 'Block Contact'
      OnClick = mnuBlockClick
    end
    object N1: TTntMenuItem
      Caption = '-'
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
