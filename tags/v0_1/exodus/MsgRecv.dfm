object frmMsgRecv: TfrmMsgRecv
  Left = 258
  Top = 213
  Width = 314
  Height = 412
  Caption = 'Message'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 183
    Width = 306
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 149
    Width = 306
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 306
    end
    inherited Panel1: TPanel
      Left = 146
      inherited btnOK: TButton
        Caption = 'Reply'
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        Caption = 'Close'
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object pnlFrom: TPanel
    Left = 0
    Top = 0
    Width = 306
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    Color = clHighlight
    TabOrder = 1
    object StaticText1: TStaticText
      Left = 2
      Top = 2
      Width = 51
      Height = 18
      Align = alLeft
      Caption = 'From:    '
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
    object txtFrom: TStaticText
      Left = 53
      Top = 2
      Width = 251
      Height = 18
      Align = alClient
      Caption = '<JID>'
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
  end
  object pnlSubject: TPanel
    Left = 0
    Top = 22
    Width = 306
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    Color = clHighlight
    TabOrder = 2
    object StaticText3: TStaticText
      Left = 2
      Top = 2
      Width = 51
      Height = 18
      Align = alLeft
      Caption = 'Subject:'
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
    object txtSubject: TStaticText
      Left = 53
      Top = 2
      Width = 251
      Height = 18
      Align = alClient
      Caption = '<JID>'
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
  end
  object pnlReply: TPanel
    Left = 0
    Top = 186
    Width = 306
    Height = 192
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 3
    Visible = False
    object MsgOut: TRichEdit
      Left = 3
      Top = 3
      Width = 300
      Height = 152
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 0
      WantTabs = True
    end
    inline frameButtons2: TframeButtons
      Left = 3
      Top = 155
      Width = 300
      Height = 34
      Align = alBottom
      AutoScroll = False
      TabOrder = 1
      inherited Bevel1: TBevel
        Width = 300
      end
      inherited Panel1: TPanel
        Left = 140
        inherited btnOK: TButton
          Caption = 'Send'
          OnClick = frameButtons2btnOKClick
        end
        inherited btnCancel: TButton
          OnClick = frameButtons2btnCancelClick
        end
      end
    end
  end
  object txtMsg: TExRichEdit
    Left = 0
    Top = 68
    Width = 306
    Height = 81
    Align = alClient
    TabOrder = 4
    OnURLClick = txtMsgURLClick
  end
  object pnlSendSubject: TPanel
    Left = 0
    Top = 44
    Width = 306
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    Color = clHighlight
    TabOrder = 5
    Visible = False
    object Label1: TLabel
      Left = 2
      Top = 2
      Width = 64
      Height = 20
      Align = alLeft
      Caption = 'Subject:    '
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object txtSendSubject: TMemo
      Left = 66
      Top = 2
      Width = 238
      Height = 20
      Align = alClient
      TabOrder = 0
      WantReturns = False
    end
  end
end
