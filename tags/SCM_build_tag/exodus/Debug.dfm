inherited frmDebug: TfrmDebug
  Left = 318
  Top = 199
  Caption = 'Debug'
  ClientHeight = 468
  ClientWidth = 492
  ExplicitWidth = 500
  ExplicitHeight = 501
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlDock: TTntPanel
    Width = 492
    TabOrder = 1
    inherited pnlDockTopContainer: TTntPanel
      Width = 492
      inherited tbDockBar: TToolBar
        Left = 442
      end
      inherited pnlDockTop: TTntPanel
        Width = 438
        ExplicitWidth = 438
        object pnlTop: TPanel
          Left = 1
          Top = 1
          Width = 436
          Height = 42
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object lblJID: TTntLabel
            Left = 87
            Top = 11
            Width = 85
            Height = 16
            Cursor = crHandPoint
            Caption = '(Disconnected)'
            OnClick = lblJIDClick
          end
          object lblLabel: TTntLabel
            Left = 7
            Top = 11
            Width = 77
            Height = 16
            Caption = 'Current JID:  '
          end
        end
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 492
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 97
    Width = 492
    Height = 371
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'Panel2'
    Constraints.MinHeight = 62
    ParentColor = True
    TabOrder = 0
    OnResize = Panel2Resize
    object Splitter1: TSplitter
      Left = 4
      Top = 312
      Width = 484
      Height = 6
      Cursor = crVSplit
      Align = alBottom
      ExplicitLeft = 5
      ExplicitTop = 367
      ExplicitWidth = 482
    end
    object MsgDebug: TExRichEdit
      Left = 4
      Top = 4
      Width = 484
      Height = 308
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
      ImeMode = imDisable
      LangOptions = [loAutoFont]
      Language = 1033
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
      Top = 318
      Width = 484
      Height = 49
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
      LangOptions = [loAutoFont]
      Language = 1033
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
  object PopupMenu1: TTntPopupMenu
    AutoHotkeys = maManual
    Left = 48
    Top = 136
    object Clear1: TTntMenuItem
      Caption = 'Clear '
      ShortCut = 16430
      OnClick = Clear1Click
    end
    object SendXML1: TTntMenuItem
      Caption = 'Send XML'
      ShortCut = 16397
      OnClick = btnSendRawClick
    end
    object Find1: TTntMenuItem
      Caption = 'Find'
      ShortCut = 49222
      OnClick = Find1Click
    end
    object WordWrap1: TTntMenuItem
      Caption = 'Word Wrap'
      Checked = True
      ShortCut = 49239
      OnClick = WordWrap1Click
    end
    object N1: TTntMenuItem
      Caption = '-'
    end
    object popMsg: TTntMenuItem
      Caption = 'Message'
      OnClick = popMsgClick
    end
    object popIQGet: TTntMenuItem
      Caption = 'IQ Get'
      OnClick = popMsgClick
    end
    object popIQSet: TTntMenuItem
      Caption = 'IQ Set'
      OnClick = popMsgClick
    end
    object popPres: TTntMenuItem
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
