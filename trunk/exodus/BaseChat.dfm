object frmBaseChat: TfrmBaseChat
  Left = 762
  Top = 389
  Width = 390
  Height = 315
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 255
    Width = 382
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Beveled = True
  end
  object Panel3: TPanel
    Left = 0
    Top = 22
    Width = 382
    Height = 233
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'pnlMsgs'
    TabOrder = 0
    object MsgList: TExRichEdit
      Left = 4
      Top = 4
      Width = 374
      Height = 225
      Align = alClient
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      OnURLClick = MsgListURLClick
    end
  end
  object pnlInput: TPanel
    Left = 0
    Top = 258
    Width = 382
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 1
    object MsgOut: TMemo
      Left = 2
      Top = 2
      Width = 378
      Height = 24
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      PopupMenu = popOut
      TabOrder = 0
      WantReturns = False
      OnKeyPress = MsgOutKeyPress
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 382
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 2
  end
  object popOut: TPopupMenu
    Left = 16
    Top = 184
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
      ShortCut = 16453
      OnClick = Emoticons1Click
    end
  end
end
