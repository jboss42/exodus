inherited frmJUD: TfrmJUD
  Left = 271
  Top = 166
  Width = 437
  Height = 442
  BorderWidth = 3
  Caption = 'Search for Contacts'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 164
    Height = 407
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object lblInstructions: TLabel
      Left = 0
      Top = 96
      Width = 164
      Height = 26
      Align = alTop
      Caption = 'Fill in the search criteria to find contacts on.'
      Visible = False
      WordWrap = True
    end
    object lblSelect: TLabel
      Left = 0
      Top = 0
      Width = 164
      Height = 39
      Align = alTop
      Caption = 
        'Select the user database or enter in the Jabber ID of the search' +
        ' agent to use:'
      WordWrap = True
    end
    object lblWait: TLabel
      Left = 0
      Top = 70
      Width = 164
      Height = 26
      Align = alTop
      Caption = 'Please wait. Contacting search agent:'
      Visible = False
      WordWrap = True
    end
    object Panel1: TPanel
      Left = 0
      Top = 39
      Width = 164
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
        TabOrder = 0
      end
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 373
      Width = 164
      Height = 34
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object btnAction: TButton
        Left = 2
        Top = 4
        Width = 75
        Height = 25
        Caption = 'Search'
        TabOrder = 0
        OnClick = btnActionClick
      end
      object btnClose: TButton
        Left = 82
        Top = 4
        Width = 75
        Height = 25
        Caption = 'Close'
        TabOrder = 1
        OnClick = btnCloseClick
      end
    end
    object pnlFields: TPanel
      Left = 0
      Top = 276
      Width = 164
      Height = 97
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
    object aniWait: TAnimate
      Left = 0
      Top = 122
      Width = 164
      Height = 50
      Align = alTop
      Active = False
      CommonAVI = aviFindFolder
      StopFrame = 29
      Visible = False
    end
    object pnlResults: TPanel
      Left = 0
      Top = 172
      Width = 164
      Height = 104
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
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
        TabOrder = 0
      end
    end
  end
  object lstContacts: TListView
    Left = 164
    Top = 0
    Width = 259
    Height = 407
    Align = alClient
    Columns = <>
    MultiSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 1
    ViewStyle = vsReport
    OnContextPopup = lstContactsContextPopup
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
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popChat: TMenuItem
      Caption = 'Start Chat'
    end
    object popMessage: TMenuItem
      Caption = 'Send Message'
    end
  end
end
