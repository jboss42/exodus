inherited frmChat: TfrmChat
  Left = 276
  Top = 166
  Caption = 'Chat Window'
  OldCreateOrder = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnEndDock = FormEndDock
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlInput: TPanel
    inherited MsgOut: TMemo
      OnChange = MsgOutChange
    end
  end
  inherited Panel1: TPanel
    object imgStatus: TPaintBox
      Tag = 1
      Left = 2
      Top = 2
      Width = 20
      Height = 18
      Align = alLeft
      ParentShowHint = False
      ShowHint = True
      OnPaint = imgStatusPaint
    end
    object lblJID: TStaticText
      Left = 50
      Top = 2
      Width = 38
      Height = 18
      Cursor = crHandPoint
      Align = alLeft
      Caption = '<JID>'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      OnClick = lblJIDClick
    end
    object lblNick: TStaticText
      Left = 22
      Top = 2
      Width = 28
      Height = 18
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Foo'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
  end
  object popContact: TPopupMenu
    Left = 16
    Top = 152
    object mnuHistory: TMenuItem
      Caption = 'Show History'
      OnClick = doHistory
    end
    object mnuProfile: TMenuItem
      Caption = 'Show Profile'
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
    object mnuBlock: TMenuItem
      Caption = 'Block Contact'
      OnClick = mnuBlockClick
    end
    object mnuSendFile: TMenuItem
      Caption = 'Send File'
      OnClick = mnuSendFileClick
    end
    object mnuSave: TMenuItem
      Caption = 'Save Conversation'
      OnClick = mnuSaveClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuOnTop: TMenuItem
      Caption = 'Always on Top'
      OnClick = mnuOnTopClick
    end
    object mnuReturns: TMenuItem
      Caption = 'Embed Returns'
      OnClick = mnuReturnsClick
    end
    object mnuEncrypt: TMenuItem
      Caption = 'Encrypt Conversation'
    end
  end
  object timFlash: TTimer
    Enabled = False
    Interval = 500
    OnTimer = timFlashTimer
    Left = 48
    Top = 152
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'html'
    Filter = 'RTF Files|*.rtf|All Files|*.*'
    Left = 48
    Top = 184
  end
end
