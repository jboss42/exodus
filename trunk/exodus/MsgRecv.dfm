object frmMsgRecv: TfrmMsgRecv
  Left = 267
  Top = 170
  Width = 531
  Height = 410
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
    Top = 186
    Width = 523
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 152
    Width = 523
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 523
    end
    inherited Panel1: TPanel
      Left = 363
      Height = 29
      inherited btnOK: TButton
        Top = 0
        Caption = 'Reply'
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        Top = 0
        Caption = 'Close'
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object pnlFrom: TPanel
    Left = 0
    Top = 0
    Width = 523
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 1
    object StaticText1: TStaticText
      Left = 2
      Top = 2
      Width = 51
      Height = 18
      Align = alLeft
      Caption = 'From:    '
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
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
      Width = 468
      Height = 18
      Align = alClient
      Caption = '<JID>'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
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
    Width = 523
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 2
    object StaticText3: TStaticText
      Left = 2
      Top = 2
      Width = 51
      Height = 18
      Align = alLeft
      Caption = 'Subject:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
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
      Width = 468
      Height = 18
      Align = alClient
      Caption = '<JID>'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
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
    Top = 189
    Width = 523
    Height = 192
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 3
    Visible = False
    object MsgOut: TRichEdit
      Left = 3
      Top = 3
      Width = 517
      Height = 152
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 0
      WantTabs = True
    end
    inline frameButtons2: TframeButtons
      Left = 3
      Top = 155
      Width = 517
      Height = 34
      Align = alBottom
      AutoScroll = False
      TabOrder = 1
      inherited Bevel1: TBevel
        Width = 517
      end
      inherited Panel1: TPanel
        Left = 357
        Height = 29
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
    Width = 523
    Height = 84
    Align = alClient
    TabOrder = 4
    OnURLClick = txtMsgURLClick
  end
  object pnlSendSubject: TPanel
    Left = 0
    Top = 44
    Width = 523
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 5
    Visible = False
    object Label1: TLabel
      Left = 2
      Top = 2
      Width = 64
      Height = 20
      Align = alLeft
      Caption = 'Subject:    '
      Color = clBtnFace
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
      Width = 455
      Height = 20
      Align = alClient
      TabOrder = 0
      WantReturns = False
    end
  end
end
