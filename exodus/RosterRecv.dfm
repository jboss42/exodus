inherited frmRosterRecv: TfrmRosterRecv
  Left = 228
  Top = 192
  Caption = 'Receiving Contacts'
  ClientHeight = 287
  ClientWidth = 374
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 83
    Width = 374
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 253
    Width = 374
    Height = 34
    Align = alBottom
    TabOrder = 0
    TabStop = True
    ExplicitTop = 253
    ExplicitWidth = 374
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 374
      Height = 34
      ExplicitWidth = 374
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 374
        ExplicitWidth = 374
      end
      inherited Panel1: TPanel
        Left = 214
        Height = 29
        ExplicitLeft = 214
        ExplicitHeight = 29
        inherited btnOK: TTntButton
          Caption = 'Add Contacts'
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          Caption = 'Close'
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object pnlFrom: TTntPanel
    Left = 0
    Top = 0
    Width = 374
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 1
    object StaticText1: TTntStaticText
      Left = 2
      Top = 2
      Width = 51
      Height = 17
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
    object txtFrom: TTntStaticText
      Left = 53
      Top = 2
      Width = 32
      Height = 17
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
  object txtMsg: TExRichEdit
    Left = 0
    Top = 22
    Width = 374
    Height = 61
    Align = alTop
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
    ShowSelectionBar = False
    TabOrder = 2
    URLColor = clBlue
    URLCursor = crHandPoint
    InputFormat = ifRTF
    OutputFormat = ofRTF
    SelectedInOut = False
    PlainRTF = False
    UndoLimit = 0
    AllowInPlace = False
  end
  object lvContacts: TTntListView
    Left = 0
    Top = 115
    Width = 374
    Height = 138
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Nickname'
        Width = 100
      end
      item
        Caption = 'Jabber ID'
        Width = 150
      end>
    SmallImages = frmExodus.ImageList2
    TabOrder = 3
    ViewStyle = vsReport
  end
  object Panel1: TTntPanel
    Left = 0
    Top = 86
    Width = 374
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      374
      29)
    object Label2: TTntLabel
      Left = 3
      Top = 7
      Width = 127
      Height = 13
      Caption = 'Add contacts to this group:'
    end
    object cboGroup: TTntComboBox
      Left = 144
      Top = 3
      Width = 209
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 0
      Sorted = True
      TabOrder = 0
    end
  end
end
