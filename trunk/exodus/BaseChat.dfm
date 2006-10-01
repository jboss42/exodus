inherited frmBaseChat: TfrmBaseChat
  Left = 414
  Top = 474
  ClientHeight = 260
  ClientWidth = 355
  OnDestroy = FormDestroy
  ExplicitWidth = 363
  ExplicitHeight = 294
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 227
    Width = 355
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Beveled = True
    OnMoved = Splitter1Moved
    ExplicitTop = 192
  end
  inherited pnlDockTop: TPanel
    Width = 355
    TabOrder = 3
    ExplicitWidth = 355
    inherited tbDockBar: TToolBar
      Left = 306
      ExplicitLeft = 306
    end
    object pnlChatTop: TPanel
      Left = 0
      Top = 0
      Width = 303
      Height = 32
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 50
      ExplicitTop = 3
      ExplicitWidth = 185
      ExplicitHeight = 41
    end
  end
  object pnlMsgList: TPanel
    Left = 0
    Top = 32
    Width = 355
    Height = 166
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    ExplicitTop = 72
    ExplicitHeight = 126
  end
  object pnlInput: TPanel
    Left = 0
    Top = 232
    Width = 355
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 2
    object MsgOut: TExRichEdit
      Left = 2
      Top = 2
      Width = 351
      Height = 24
      Align = alClient
      AutoURLDetect = adNone
      Ctl3D = True
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
      ParentCtl3D = False
      PopupMenu = popOut
      ScrollBars = ssVertical
      ShowSelectionBar = False
      TabOrder = 0
      URLColor = clBlue
      URLCursor = crHandPoint
      WantTabs = True
      WordWrap = False
      OnEnter = MsgOutOnEnter
      OnKeyDown = MsgOutKeyDown
      OnKeyPress = MsgOutKeyPress
      OnKeyUp = MsgOutKeyUp
      AutoVerbMenu = False
      InputFormat = ifUnicode
      OutputFormat = ofUnicode
      SelectedInOut = False
      PlainRTF = False
      UndoLimit = 0
      AllowInPlace = False
    end
  end
  object tbMsgOutToolbar: TTntToolBar
    Left = 0
    Top = 198
    Width = 355
    Height = 29
    Align = alBottom
    ButtonHeight = 25
    ButtonWidth = 25
    Images = frmExodus.ImageList2
    TabOrder = 1
    object ChatToolbarButtonBold: TTntToolButton
      Left = 0
      Top = 0
      Caption = 'Bold'
      ImageIndex = 70
      OnClick = BoldClick
    end
    object ChatToolbarButtonUnderline: TTntToolButton
      Left = 25
      Top = 0
      Caption = 'Underline'
      ImageIndex = 71
      OnClick = UnderlineClick
    end
    object ChatToolbarButtonItalics: TTntToolButton
      Left = 50
      Top = 0
      Caption = 'Italics'
      ImageIndex = 72
      Visible = False
      OnClick = ItalicsClick
    end
    object ChatToolbarButtonSeperator1: TTntToolButton
      Left = 75
      Top = 0
      Width = 8
      Caption = 'ChatToolbarButtonSeperator1'
      Style = tbsSeparator
    end
    object ChatToolbarButtonCut: TTntToolButton
      Left = 83
      Top = 0
      Caption = 'Cut'
      ImageIndex = 73
      OnClick = Copy2Click
    end
    object ChatToolbarButtonCopy: TTntToolButton
      Left = 108
      Top = 0
      Caption = 'Copy'
      ImageIndex = 74
      OnClick = Copy3Click
    end
    object ChatToolbarButtonPaste: TTntToolButton
      Left = 133
      Top = 0
      Caption = 'Paste'
      ImageIndex = 75
      OnClick = Paste1Click
    end
    object ChatToolbarButtonSeperator2: TTntToolButton
      Left = 158
      Top = 0
      Width = 8
      Caption = 'ChatToolbarButtonSeperator2'
      Style = tbsSeparator
    end
    object ChatToolbarButtonEmoticons: TTntToolButton
      Left = 166
      Top = 0
      Caption = 'Emoticons'
      ImageIndex = 76
      OnClick = Emoticons1Click
    end
    object ChatToolbarButtonHotkeys: TTntToolButton
      Left = 191
      Top = 0
      Caption = 'Hotkeys'
      ImageIndex = 77
      PopupMenu = popHotkeys
      OnClick = ChatToolbarButtonHotkeysClick
    end
  end
  object popMsgList: TTntPopupMenu
    Left = 16
    Top = 120
    object Copy1: TTntMenuItem
      Caption = 'Copy'
      OnClick = Copy1Click
    end
    object CopyAll1: TTntMenuItem
      Caption = 'Copy All'
      OnClick = CopyAll1Click
    end
    object Clear1: TTntMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click
    end
  end
  object popOut: TTntPopupMenu
    Left = 48
    Top = 120
    object Copy2: TTntMenuItem
      Caption = 'Cut'
      OnClick = Copy2Click
    end
    object Copy3: TTntMenuItem
      Caption = 'Copy'
      OnClick = Copy3Click
    end
    object Paste2: TTntMenuItem
      Caption = 'Paste '
      OnClick = Paste1Click
    end
    object N2: TTntMenuItem
      Caption = '-'
    end
    object Emoticons2: TTntMenuItem
      Caption = 'Emoticons'
      ShortCut = 16453
      OnClick = Emoticons1Click
    end
    object emot_sep: TTntMenuItem
      Caption = '-'
    end
  end
  object popHotkeys: TTntPopupMenu
    Left = 80
    Top = 120
    object popHotkeys_sep1: TTntMenuItem
      Caption = '-'
    end
    object Customize1: TTntMenuItem
      Caption = 'Customize...'
      OnClick = Customize1Click
    end
  end
end
