object frmChat: TfrmChat
  Left = 292
  Top = 206
  ActiveControl = MsgOut
  AutoScroll = False
  Caption = 'Chat Window'
  ClientHeight = 260
  ClientWidth = 326
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
    Top = 226
    Width = 326
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Beveled = True
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 326
    Height = 43
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel7: TPanel
      Left = 0
      Top = 0
      Width = 295
      Height = 43
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
        Width = 291
        Height = 22
        Align = alTop
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 0
        object StaticText1: TStaticText
          Left = 2
          Top = 2
          Width = 59
          Height = 18
          Align = alLeft
          Caption = 'Chat:     '
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 0
        end
        object lblJID: TStaticText
          Left = 89
          Top = 2
          Width = 200
          Height = 18
          Cursor = crHandPoint
          Align = alClient
          Caption = '<JID>'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentColor = False
          ParentFont = False
          TabOrder = 1
          OnClick = lblJIDClick
        end
        object lblNick: TStaticText
          Left = 61
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
          TabOrder = 2
          OnClick = lblJIDClick
        end
      end
      object pnlSubject: TPanel
        Left = 2
        Top = 24
        Width = 291
        Height = 22
        Align = alTop
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 1
        object StaticText3: TStaticText
          Left = 2
          Top = 2
          Width = 60
          Height = 18
          Align = alLeft
          Caption = 'Subject:'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 0
        end
        object lblSubject: TStaticText
          Left = 62
          Top = 2
          Width = 227
          Height = 18
          Align = alClient
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
      end
    end
    object pnlClose: TPanel
      Left = 295
      Top = 0
      Width = 31
      Height = 43
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnClose: TSpeedButton
        Left = 2
        Top = 1
        Width = 23
        Height = 21
        Hint = 'Close this chat window'
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000CE0E0000C40E00001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888898888898888888888888899988888889888889998888889
          8888888999888899888888889998899888888888899999888888888888999888
          8888888889999988888888889998898888888899998888998888899998888889
          9888899888888888998888888888888888888888888888888888}
        OnClick = btnCloseClick
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 43
    Width = 326
    Height = 183
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'pnlMsgs'
    TabOrder = 1
    object MsgList: TExRichEdit
      Left = 4
      Top = 4
      Width = 318
      Height = 175
      Align = alClient
      PopupMenu = popContact
      ScrollBars = ssBoth
      TabOrder = 0
      OnURLClick = MsgListURLClick
    end
  end
  object pnlInput: TPanel
    Left = 0
    Top = 229
    Width = 326
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 2
    object MsgOut: TMemo
      Left = 2
      Top = 2
      Width = 293
      Height = 27
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      WantReturns = False
      OnKeyDown = MsgOutKeyDown
      OnKeyPress = MsgOutKeyPress
    end
    object Panel5: TPanel
      Left = 295
      Top = 2
      Width = 29
      Height = 27
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnSend: TSpeedButton
        Left = 4
        Top = 3
        Width = 23
        Height = 22
        Hint = 'Send'
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555775777777
          57705557757777775FF7555555555555000755555555555F777F555555555550
          87075555555555F7577F5555555555088805555555555F755F75555555555033
          805555555555F755F75555555555033B05555555555F755F75555555555033B0
          5555555555F755F75555555555033B05555555555F755F75555555555033B055
          55555555F755F75555555555033B05555555555F755F75555555555033B05555
          555555F75FF75555555555030B05555555555F7F7F75555555555000B0555555
          5555F777F7555555555501900555555555557777755555555555099055555555
          5555777755555555555550055555555555555775555555555555}
        NumGlyphs = 2
        OnClick = btnSendClick
      end
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
end
