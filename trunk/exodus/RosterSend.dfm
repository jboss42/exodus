inherited frmRosterSend: TfrmRosterSend
  Left = 270
  Top = 235
  Width = 362
  Height = 284
  Caption = 'Send Contacts'
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 83
    Width = 354
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object pnlFrom: TPanel
    Left = 0
    Top = 0
    Width = 354
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 0
    object StaticText1: TStaticText
      Left = 2
      Top = 2
      Width = 31
      Height = 18
      Align = alLeft
      Caption = 'To:  '
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
    object txtTO: TStaticText
      Left = 33
      Top = 2
      Width = 319
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
  object txtMsg: TExRichEdit
    Left = 0
    Top = 22
    Width = 354
    Height = 61
    Align = alTop
    Lines.Strings = (
      'This message contains 1 or more contacts.')
    TabOrder = 1
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 216
    Width = 354
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 2
    inherited Bevel1: TBevel
      Width = 354
    end
    inherited Panel1: TPanel
      Left = 194
      Height = 29
      inherited btnOK: TButton
        Caption = 'Send'
      end
      inherited btnCancel: TButton
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object lvContacts: TListView
    Left = 0
    Top = 86
    Width = 354
    Height = 130
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Nickname'
        Width = 80
      end
      item
        Caption = 'Group'
        Width = 80
      end
      item
        Caption = 'Jabber ID'
        Width = 150
      end>
    SortType = stData
    TabOrder = 3
    ViewStyle = vsReport
    OnColumnClick = lvContactsColumnClick
    OnCompare = lvContactsCompare
  end
end
