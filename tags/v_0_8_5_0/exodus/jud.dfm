inherited frmJUD: TfrmJUD
  Left = 341
  Top = 213
  Width = 435
  Height = 371
  BorderWidth = 3
  Caption = 'Search for Contacts'
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 217
    Top = 0
    Width = 3
    Height = 336
    Cursor = crHSplit
  end
  object pnlLeft: TPanel [1]
    Left = 0
    Top = 0
    Width = 217
    Height = 336
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object lblInstructions: TLabel
      Left = 0
      Top = 70
      Width = 217
      Height = 13
      Align = alTop
      Caption = 'Fill in the search criteria to find contacts on.'
      Visible = False
      WordWrap = True
    end
    object lblSelect: TLabel
      Left = 0
      Top = 0
      Width = 217
      Height = 26
      Align = alTop
      Caption = 
        'Select the user database or enter in the Jabber ID of the search' +
        ' agent to use:'
      WordWrap = True
    end
    object lblWait: TLabel
      Left = 0
      Top = 57
      Width = 217
      Height = 13
      Align = alTop
      Caption = 'Please wait. Contacting search agent:'
      Visible = False
      WordWrap = True
    end
    object Panel1: TPanel
      Left = 0
      Top = 26
      Width = 217
      Height = 31
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object cboJID: TComboBox
        Left = 0
        Top = 4
        Width = 145
        Height = 21
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
      end
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 302
      Width = 217
      Height = 34
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object btnAction: TButton
        Left = 2
        Top = 4
        Width = 75
        Height = 25
        Caption = 'Search'
        Default = True
        TabOrder = 0
        OnClick = btnActionClick
      end
      object btnClose: TButton
        Left = 82
        Top = 4
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Close'
        TabOrder = 1
        OnClick = btnCloseClick
      end
    end
    object aniWait: TAnimate
      Left = 0
      Top = 83
      Width = 217
      Height = 50
      Align = alTop
      Active = False
      CommonAVI = aviFindFolder
      StopFrame = 29
      Visible = False
    end
    object pnlResults: TPanel
      Left = 0
      Top = 133
      Width = 217
      Height = 104
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      Visible = False
      object Label1: TLabel
        Left = 0
        Top = 80
        Width = 64
        Height = 13
        Cursor = crHandPoint
        Caption = 'Search Again'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = Label1Click
      end
      object Label3: TLabel
        Left = 1
        Top = 11
        Width = 128
        Height = 13
        Caption = 'Add Contacts to this group:'
      end
      object lblAddGrp: TLabel
        Left = 1
        Top = 50
        Width = 83
        Height = 13
        Cursor = crHandPoint
        Caption = 'Add a new Group'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        OnClick = lblAddGrpClick
      end
      object cboGroup: TComboBox
        Left = 0
        Top = 26
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
      end
    end
    object pnlFields: TScrollBox
      Left = 0
      Top = 237
      Width = 217
      Height = 65
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 4
    end
  end
  object lstContacts: TListView [2]
    Left = 220
    Top = 0
    Width = 201
    Height = 336
    Align = alClient
    Columns = <
      item
      end
      item
      end
      item
      end>
    HideSelection = False
    MultiSelect = True
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = lstContactsColumnClick
    OnContextPopup = lstContactsContextPopup
    OnData = lstContactsData
    OnDataFind = lstContactsDataFind
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 32
    object popAdd: TMenuItem
      Caption = 'Add Contact'
      OnClick = popAddClick
    end
    object popProfile: TMenuItem
      Caption = 'View Profile'
      OnClick = popProfileClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popChat: TMenuItem
      Caption = 'Start Chat'
      OnClick = popChatClick
    end
    object popMessage: TMenuItem
      Caption = 'Send Message'
      OnClick = popMessageClick
    end
  end
end
