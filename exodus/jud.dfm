inherited frmJud: TfrmJud
  Width = 417
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = 'Jabber Search'
  OldCreateOrder = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited TntPanel1: TTntPanel
    Width = 409
    inherited Bevel1: TBevel
      Width = 409
    end
    inherited btnBack: TTntButton
      Left = 167
      Anchors = [akTop, akRight]
      OnClick = btnBackClick
    end
    inherited btnNext: TTntButton
      Left = 243
      Anchors = [akTop, akRight]
      OnClick = btnNextClick
    end
    inherited btnCancel: TTntButton
      Left = 327
      Anchors = [akTop, akRight]
      OnClick = btnCancelClick
    end
  end
  inherited Panel1: TPanel
    Width = 409
    inherited Bevel2: TBevel
      Width = 409
    end
    inherited lblWizardTitle: TTntLabel
      Width = 126
      Caption = 'Jabber Search Wizard'
    end
    inherited lblWizardDetails: TTntLabel
      Caption = ''
    end
    inherited Image1: TImage
      Left = 368
    end
  end
  inherited Tabs: TPageControl
    Width = 409
    inherited TabSheet1: TTabSheet
      object lblSelect: TTntLabel
        Left = 0
        Top = 0
        Width = 401
        Height = 13
        Align = alTop
        Caption = 
          'Select the user database or enter in the Jabber ID of the search' +
          ' agent to use:'
        WordWrap = True
      end
      object cboJID: TTntComboBox
        Left = 16
        Top = 33
        Width = 233
        Height = 21
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object lblWait: TTntLabel
        Left = 0
        Top = 0
        Width = 179
        Height = 13
        Align = alTop
        Caption = 'Please wait. Contacting search agent:'
        WordWrap = True
      end
      object aniWait: TAnimate
        Left = 0
        Top = 13
        Width = 401
        Height = 50
        Align = alTop
        CommonAVI = aviFindFolder
        StopFrame = 29
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      object lblInstructions: TTntLabel
        Left = 0
        Top = 0
        Width = 204
        Height = 13
        Align = alTop
        Caption = 'Fill in the search criteria to find contacts on.'
        WordWrap = True
      end
      object pnlFields: TScrollBox
        Left = 0
        Top = 13
        Width = 401
        Height = 214
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
      object Panel2: TPanel
        Left = 0
        Top = 168
        Width = 401
        Height = 59
        Align = alBottom
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 0
        object Label3: TTntLabel
          Left = 6
          Top = 2
          Width = 128
          Height = 13
          Caption = 'Add Contacts to this group:'
        end
        object lblAddGrp: TTntLabel
          Left = 6
          Top = 43
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
        object cboGroup: TTntComboBox
          Left = 5
          Top = 17
          Width = 225
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          Sorted = True
          TabOrder = 0
        end
        object Button1: TButton
          Left = 256
          Top = 16
          Width = 145
          Height = 25
          Caption = 'Add Contacts'
          TabOrder = 1
          OnClick = popAddClick
        end
      end
      object lstContacts: TTntListView
        Left = 0
        Top = 0
        Width = 401
        Height = 168
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
        TabOrder = 1
        ViewStyle = vsReport
        OnColumnClick = lstContactsColumnClick
        OnContextPopup = lstContactsContextPopup
        OnData = lstContactsData
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 296
    Top = 16
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
