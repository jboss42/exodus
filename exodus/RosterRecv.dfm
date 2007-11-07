inherited frmRosterRecv: TfrmRosterRecv
  Left = 228
  Top = 192
  Caption = 'Receiving Contacts'
  ClientHeight = 287
  ClientWidth = 374
  ExplicitWidth = 382
  ExplicitHeight = 321
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 93
    Width = 374
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 83
  end
  inherited pnlDockTop: TPanel
    Width = 374
    TabOrder = 4
    ExplicitWidth = 374
    inherited tbDockBar: TToolBar
      Left = 325
      ExplicitLeft = 325
      inherited btnCloseDock: TToolButton
        Visible = False
      end
    end
    object pnlFrom: TTntPanel
      Left = 0
      Top = 0
      Width = 322
      Height = 32
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 2
      ParentColor = True
      TabOrder = 1
      object StaticText1: TTntStaticText
        Left = 2
        Top = 2
        Width = 44
        Height = 28
        Align = alLeft
        Caption = 'From:    '
        TabOrder = 0
      end
      object txtFrom: TTntStaticText
        Left = 46
        Top = 2
        Width = 274
        Height = 28
        Align = alClient
        Caption = '<JID>'
        TabOrder = 1
        ExplicitLeft = 53
        ExplicitWidth = 267
      end
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 253
    Width = 374
    Height = 34
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
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
  object txtMsg: TExRichEdit
    Left = 0
    Top = 32
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
    TabOrder = 1
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
    Top = 125
    Width = 374
    Height = 128
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
    TabOrder = 2
    ViewStyle = vsReport
  end
  object Panel1: TTntPanel
    Left = 0
    Top = 96
    Width = 374
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    DesignSize = (
      374
      29)
    object Label2: TTntLabel
      Left = 3
      Top = 7
      Width = 131
      Height = 13
      Caption = 'Add contacts to this group:'
    end
    object cboGroup: TTntComboBox
      Left = 144
      Top = 3
      Width = 209
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
    end
  end
end
