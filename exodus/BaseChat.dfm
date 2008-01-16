inherited frmBaseChat: TfrmBaseChat
  Left = 414
  Top = 474
  ClientHeight = 240
  ClientWidth = 383
  OnDestroy = FormDestroy
  ExplicitWidth = 391
  ExplicitHeight = 274
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 181
    Width = 383
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Beveled = True
    OnMoved = Splitter1Moved
    ExplicitTop = 210
  end
  inherited pnlDockTop: TPanel
    Width = 383
    TabOrder = 2
    ExplicitWidth = 383
    inherited tbDockBar: TToolBar
      Left = 334
      ExplicitLeft = 334
    end
    object pnlChatTop: TPanel
      Left = 0
      Top = 0
      Width = 331
      Height = 30
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
    end
  end
  object pnlMsgList: TPanel
    Left = 0
    Top = 30
    Width = 383
    Height = 151
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    ParentColor = True
    TabOrder = 0
  end
  object pnlInput: TPanel
    Left = 0
    Top = 214
    Width = 383
    Height = 26
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 1
    object MsgOut: TExRichEdit
      Left = 2
      Top = 2
      Width = 379
      Height = 22
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
      OnSelectionChange = MsgOutSelectionChange
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
    Top = 185
    Width = 383
    Height = 29
    Align = alBottom
    ButtonWidth = 25
    Images = frmExodus.ImageList2
    TabOrder = 3
    object ChatToolbarButtonBold: TTntToolButton
      Left = 0
      Top = 0
      Hint = 'Bold'
      AllowAllUp = True
      Caption = 'Bold'
      ImageIndex = 70
      Style = tbsCheck
      OnClick = ChatToolbarButtonBoldClick
    end
    object ChatToolbarButtonUnderline: TTntToolButton
      Left = 25
      Top = 0
      Hint = 'Underline'
      AllowAllUp = True
      Caption = 'Underline'
      ImageIndex = 71
      Style = tbsCheck
      OnClick = ChatToolbarButtonUnderlineClick
    end
    object ChatToolbarButtonItalics: TTntToolButton
      Left = 50
      Top = 0
      Hint = 'Italics'
      AllowAllUp = True
      Caption = 'Color'
      ImageIndex = 72
      Style = tbsCheck
      Visible = False
      OnClick = ItalicsClick
    end
    object ChatToolbarButtonColors: TTntToolButton
      Left = 75
      Top = 0
      AllowAllUp = True
      Caption = 'Color'
      ImageIndex = 84
      OnClick = ChatToolbarButtonColorsClick
    end
    object ChatToolbarButtonSeperator1: TTntToolButton
      Left = 100
      Top = 0
      Width = 8
      Caption = 'ChatToolbarButtonSeperator1'
      Style = tbsSeparator
    end
    object ChatToolbarButtonCut: TTntToolButton
      Left = 108
      Top = 0
      Hint = 'Cut'
      Caption = 'Cut'
      ImageIndex = 73
      OnClick = Copy2Click
    end
    object ChatToolbarButtonCopy: TTntToolButton
      Left = 133
      Top = 0
      Hint = 'Copy'
      Caption = 'Copy'
      ImageIndex = 74
      OnClick = Copy3Click
    end
    object ChatToolbarButtonPaste: TTntToolButton
      Left = 158
      Top = 0
      Hint = 'Paste'
      Caption = 'Paste'
      ImageIndex = 75
      OnClick = Paste1Click
    end
    object ChatToolbarButtonSeperator2: TTntToolButton
      Left = 183
      Top = 0
      Width = 8
      Caption = 'ChatToolbarButtonSeperator2'
      Style = tbsSeparator
    end
    object ChatToolbarButtonEmoticons: TTntToolButton
      Left = 191
      Top = 0
      Hint = 'Emoticons'
      Caption = 'Emoticons'
      ImageIndex = 76
      OnClick = Emoticons1Click
    end
    object ChatToolbarButtonHotkeys: TTntToolButton
      Left = 216
      Top = 0
      Hint = 'Hotkeys'
      Caption = 'Hotkeys'
      ImageIndex = 77
      PopupMenu = popHotkeys
      OnClick = ChatToolbarButtonHotkeysClick
    end
    object TntToolButton1: TTntToolButton
      Left = 241
      Top = 0
      Width = 8
      Caption = 'TntToolButton1'
      Style = tbsSeparator
    end
    object cmbPriority: TTntComboBox
      Left = 249
      Top = 0
      Width = 72
      Height = 21
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
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
  object AppEvents: TApplicationEvents
    OnShortCut = AppEventsShortCut
    Left = 104
    Top = 120
  end
end
