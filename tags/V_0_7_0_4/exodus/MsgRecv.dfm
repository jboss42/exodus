object frmMsgRecv: TfrmMsgRecv
  Left = 246
  Top = 179
  Width = 333
  Height = 416
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
  OnEndDock = FormEndDock
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 187
    Width = 325
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 153
    Width = 325
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 325
    end
    inherited Panel1: TPanel
      Left = 165
      Height = 29
      inherited btnOK: TButton
        Left = 82
        Top = 1
        Caption = 'Reply'
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        Top = -152
        Caption = 'Close'
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object pnlFrom: TPanel
    Left = 0
    Top = 0
    Width = 325
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 1
    object btnClose: TSpeedButton
      Left = 302
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
      OnClick = btnCloseClick
    end
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
      Width = 244
      Height = 18
      Align = alLeft
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
    Width = 325
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
      Width = 270
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
    Top = 190
    Width = 325
    Height = 192
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 3
    Visible = False
    inline frameButtons2: TframeButtons
      Left = 3
      Top = 155
      Width = 319
      Height = 34
      Align = alBottom
      AutoScroll = False
      TabOrder = 0
      inherited Bevel1: TBevel
        Width = 319
      end
      inherited Panel1: TPanel
        Left = 159
        Height = 29
        inherited btnCancel: TButton [0]
          Visible = False
          OnClick = frameButtons2btnCancelClick
        end
        inherited btnOK: TButton [1]
          Left = 84
          Caption = '&Send'
          OnClick = frameButtons2btnOKClick
        end
      end
    end
    object MsgOut: TExRichEdit
      Left = 3
      Top = 3
      Width = 319
      Height = 152
      Align = alClient
      AutoURLDetect = adDefault
      CustomURLs = <
        item
          Name = 'e-mail'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'http'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'file'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'mailto'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'ftp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'https'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'gopher'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'nntp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'prospero'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'telnet'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'news'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'wais'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end>
      LangOptions = [loAutoFont]
      Language = 1033
      ShowSelectionBar = False
      TabOrder = 1
      URLColor = clBlue
      URLCursor = crHandPoint
      OnKeyUp = MsgOutKeyUp
      OnURLClick = txtMsgURLClick
      InputFormat = ifRTF
      OutputFormat = ofRTF
      SelectedInOut = False
      PlainRTF = False
      UndoLimit = 0
      AllowInPlace = False
    end
  end
  object txtMsg: TExRichEdit
    Left = 0
    Top = 68
    Width = 325
    Height = 85
    Align = alClient
    AutoURLDetect = adDefault
    CustomURLs = <
      item
        Name = 'e-mail'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'http'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'file'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'mailto'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'ftp'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'https'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'gopher'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'nntp'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'prospero'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'telnet'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'news'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end
      item
        Name = 'wais'
        Color = clWindowText
        Cursor = crDefault
        Underline = True
      end>
    LangOptions = [loAutoFont]
    Language = 1033
    ScrollBars = ssVertical
    ShowSelectionBar = False
    TabOrder = 4
    URLColor = clBlue
    URLCursor = crHandPoint
    OnURLClick = txtMsgURLClick
    InputFormat = ifRTF
    OutputFormat = ofRTF
    SelectedInOut = False
    PlainRTF = False
    UndoLimit = 0
    AllowInPlace = False
  end
  object pnlSendSubject: TPanel
    Left = 0
    Top = 44
    Width = 325
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
      Width = 257
      Height = 20
      Align = alClient
      TabOrder = 0
      WantReturns = False
    end
  end
end
