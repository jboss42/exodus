object frmChat: TfrmChat
  Left = 249
  Top = 209
  ActiveControl = MsgOut
  AutoScroll = False
  Caption = 'Chat Window'
  ClientHeight = 267
  ClientWidth = 392
  Color = clBtnFace
  Constraints.MinHeight = 285
  Constraints.MinWidth = 285
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 233
    Width = 392
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Beveled = True
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 392
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel7: TPanel
      Left = 0
      Top = 0
      Width = 392
      Height = 25
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 2
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object pnlFrom: TPanel
        Left = 2
        Top = 2
        Width = 388
        Height = 23
        Align = alTop
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 0
        object imgStatus: TPaintBox
          Tag = 1
          Left = 2
          Top = 2
          Width = 20
          Height = 19
          Align = alLeft
          OnPaint = imgStatusPaint
        end
        object lblJID: TStaticText
          Left = 50
          Top = 2
          Width = 38
          Height = 19
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
          Height = 19
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
          OnClick = lblJIDClick
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 25
    Width = 392
    Height = 208
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'pnlMsgs'
    TabOrder = 1
    object MsgList: TExRichEdit
      Left = 4
      Top = 4
      Width = 384
      Height = 200
      Align = alClient
      PopupMenu = popContact
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      OnURLClick = MsgListURLClick
    end
  end
  object pnlInput: TPanel
    Left = 0
    Top = 236
    Width = 392
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 2
    object MsgOut: TMemo
      Left = 2
      Top = 2
      Width = 388
      Height = 27
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      PopupMenu = PopupMenu1
      TabOrder = 0
      WantReturns = False
      OnChange = MsgOutChange
      OnKeyDown = MsgOutKeyDown
      OnKeyPress = MsgOutKeyPress
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 16
    Top = 152
    object Copy1: TMenuItem
      Caption = 'Copy'
    end
    object CopyAll1: TMenuItem
      Caption = 'Copy All'
    end
    object Clear1: TMenuItem
      Caption = 'Clear'
    end
    object Emoticons1: TMenuItem
      Caption = 'Emoticons'
      OnClick = Emoticons1Click
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'html'
    Filter = 'HTML Files|*.html|All Files|*.*'
    Left = 48
    Top = 152
  end
  object popContact: TPopupMenu
    Left = 16
    Top = 120
    object mnuHistory: TMenuItem
      Caption = 'Show History'
      OnClick = btnHistoryClick
    end
    object mnuProfile: TMenuItem
      Caption = 'Show Profile'
      OnClick = btnProfileClick
    end
    object mnuAdd: TMenuItem
      Caption = 'Add Contact to Roster'
      OnClick = btnAddRosterClick
    end
    object mnuBlock: TMenuItem
      Caption = 'Block Contact'
    end
    object mnuSendFile: TMenuItem
      Caption = 'Send File'
      OnClick = mnuSendFileClick
    end
    object mnuSave: TMenuItem
      Caption = 'Save Conversation'
    end
    object N1: TMenuItem
      Caption = '-'
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
    Top = 120
  end
end
