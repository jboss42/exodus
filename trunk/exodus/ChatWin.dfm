inherited frmChat: TfrmChat
  Left = 311
  Top = 370
  Caption = 'Chat Window'
  OldCreateOrder = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnEndDock = FormEndDock
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel3: TPanel
    Top = 24
    Height = 224
    inherited MsgList: TExRichEdit
      Height = 216
      PlainRTF = True
    end
  end
  inherited pnlInput: TPanel
    inherited MsgOut: TExRichEdit
      WantReturns = False
    end
  end
  inherited Panel1: TPanel
    Height = 24
    object btnClose: TSpeedButton
      Left = 354
      Top = 2
      Width = 23
      Height = 20
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
      object lblJID: TTntStaticText
        Left = 42
        Top = 0
        Width = 32
        Height = 20
        Cursor = crHandPoint
        Align = alLeft
        Caption = '<JID>'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        OnClick = lblJIDClick
      end
      object lblNick: TTntStaticText
        Left = 20
        Top = 0
        Width = 22
        Height = 20
        Cursor = crHandPoint
        Align = alLeft
        Caption = 'Foo'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
      end
    end
  end
  object popContact: TPopupMenu [5]
    Left = 16
    Top = 152
    object mnuHistory: TMenuItem
      Caption = 'Show History'
      OnClick = doHistory
    end
    object popClearHistory: TMenuItem
      Caption = 'Clear History'
      OnClick = popClearHistoryClick
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
end
