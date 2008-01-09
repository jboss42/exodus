object frmDebug: TfrmDebug
  Left = 263
  Top = 202
  Width = 408
  Height = 414
  Caption = 'Debug'
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnEndDock = FormEndDock
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 25
    Width = 400
    Height = 355
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 4
      Top = 306
      Width = 392
      Height = 5
      Cursor = crVSplit
      Align = alBottom
    end
    object MsgDebug: TExRichEdit
      Left = 4
      Top = 4
      Width = 392
      Height = 302
      Align = alClient
      AutoURLDetect = adNone
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
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Unicode MS'
      Font.Style = []
      ImeMode = imDisable
      LangOptions = [loAutoFont]
      Language = 1033
      ParentFont = False
      ScrollBars = ssVertical
      ShowSelectionBar = False
      TabOrder = 1
      URLColor = clBlue
      URLCursor = crHandPoint
      OnKeyPress = MsgDebugKeyPress
      InputFormat = ifUnicode
      OutputFormat = ofRTF
      SelectedInOut = False
      PlainRTF = False
      UndoLimit = 0
      AllowInPlace = False
    end
    object MemoSend: TExRichEdit
      Left = 4
      Top = 311
      Width = 392
      Height = 40
      Align = alBottom
      AutoURLDetect = adNone
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
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      LangOptions = [loAutoFont]
      Language = 1033
      ParentFont = False
      PopupMenu = PopupMenu1
      ScrollBars = ssVertical
      ShowSelectionBar = False
      TabOrder = 0
      URLColor = clBlue
      URLCursor = crHandPoint
      OnKeyDown = MemoSendKeyDown
      InputFormat = ifRTF
      OutputFormat = ofRTF
      SelectedInOut = False
      PlainRTF = False
      UndoLimit = 0
      AllowInPlace = False
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      400
      25)
    object btnClose: TSpeedButton
      Left = 375
      Top = 2
      Width = 23
      Height = 20
      Anchors = [akTop, akRight]
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
    object lblJID: TLabel
      Left = 66
      Top = 6
      Width = 72
      Height = 13
      Cursor = crHandPoint
      Caption = '(Disconnected)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = lblJIDClick
    end
    object Label1: TLabel
      Left = 6
      Top = 6
      Width = 56
      Height = 13
      Caption = 'Current JID:'
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 40
    Top = 136
    object Clear1: TMenuItem
      Caption = 'Clear '
      ShortCut = 16430
      OnClick = Clear1Click
    end
    object SendXML1: TMenuItem
      Caption = 'Send XML'
      OnClick = btnSendRawClick
    end
    object Find1: TMenuItem
      Caption = 'Find'
      ShortCut = 49222
      OnClick = Find1Click
    end
    object WordWrap1: TMenuItem
      Caption = 'Word Wrap'
      Checked = True
      ShortCut = 49239
      OnClick = WordWrap1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popMsg: TMenuItem
      Caption = 'Message'
      OnClick = popMsgClick
    end
    object popIQGet: TMenuItem
      Caption = 'IQ Get'
      OnClick = popMsgClick
    end
    object popIQSet: TMenuItem
      Caption = 'IQ Set'
      OnClick = popMsgClick
    end
    object popPres: TMenuItem
      Caption = 'Presence'
      OnClick = popMsgClick
    end
  end
  object FindDialog1: TFindDialog
    Options = [frDown, frHideUpDown]
    OnFind = FindDialog1Find
    Left = 80
    Top = 136
  end
end
