inherited frmJud: TfrmJud
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = 'Jabber Search'
  ClientHeight = 416
  ClientWidth = 492
  KeyPreview = True
  OldCreateOrder = True
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  inherited TntPanel1: TTntPanel
    Top = 375
    Width = 492
    ExplicitTop = 314
    ExplicitWidth = 553
    inherited Bevel1: TBevel
      Width = 492
      ExplicitWidth = 409
    end
    inherited btnBack: TTntButton
      Left = 250
      Anchors = [akTop, akRight]
      Cancel = True
      OnClick = btnBackClick
      ExplicitLeft = 311
    end
    inherited btnNext: TTntButton
      Left = 326
      Anchors = [akTop, akRight]
      Default = True
      OnClick = btnNextClick
      ExplicitLeft = 387
    end
    inherited btnCancel: TTntButton
      Left = 410
      Anchors = [akTop, akRight]
      OnClick = btnCancelClick
      ExplicitLeft = 471
    end
  end
  inherited Tabs: TPageControl
    Width = 492
    Height = 322
    ExplicitWidth = 553
    ExplicitHeight = 261
    inherited TabSheet1: TTabSheet
      OnEnter = TabSheet1Enter
      ExplicitLeft = 4
      ExplicitTop = 27
      ExplicitWidth = 545
      ExplicitHeight = 230
      object lblSelect: TTntLabel
        Left = 0
        Top = 0
        Width = 484
        Height = 13
        Align = alTop
        Caption = 'Select the user database for the search agent to use:'
        WordWrap = True
        ExplicitWidth = 365
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
      ExplicitWidth = 545
      ExplicitHeight = 230
      object lblWait: TTntLabel
        Left = 0
        Top = 0
        Width = 484
        Height = 13
        Align = alTop
        Caption = 'Please wait. Contacting search agent:'
        WordWrap = True
        ExplicitWidth = 179
      end
      object aniWait: TAnimate
        Left = 0
        Top = 13
        Width = 484
        Height = 50
        Align = alTop
        CommonAVI = aviFindFolder
        StopFrame = 29
        ExplicitWidth = 545
      end
    end
    object TabFields: TTabSheet
      Caption = 'TabFields'
      ImageIndex = 2
      ExplicitWidth = 545
      ExplicitHeight = 230
      object lblInstructions: TTntLabel
        Left = 0
        Top = 0
        Width = 484
        Height = 13
        Align = alTop
        Caption = 'Fill in the search criteria to find contacts on.'
        WordWrap = True
        ExplicitWidth = 204
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
      ExplicitWidth = 545
      ExplicitHeight = 230
      object Panel2: TPanel
        Left = 0
        Top = 232
        Width = 484
        Height = 59
        Align = alBottom
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 0
        ExplicitTop = 171
        ExplicitWidth = 545
        object Label3: TTntLabel
          Left = 2
          Top = 2
          Width = 128
          Height = 13
          Caption = 'Add Contacts to this group:'
        end
        object lblAddGrp: TTntLabel
          Left = 2
          Top = 43
          Width = 83
          Height = 13
          Cursor = crHandPoint
          Caption = 'Add a new Group'
          Color = clBtnFace
          ParentColor = False
          OnClick = lblAddGrpClick
        end
        object lblCount: TTntLabel
          Left = 322
          Top = 2
          Width = 65
          Height = 13
          Alignment = taRightJustify
          Caption = 'N items found'
        end
        object cboGroup: TTntComboBox
          Left = 5
          Top = 20
          Width = 196
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          Sorted = True
          TabOrder = 0
        end
        object btnContacts: TButton
          Left = 207
          Top = 21
          Width = 109
          Height = 25
          Caption = 'Add Contacts'
          TabOrder = 1
          OnClick = popAddClick
        end
        object btnChat: TButton
          Left = 321
          Top = 21
          Width = 109
          Height = 25
          Caption = 'Chat'
          TabOrder = 2
          OnClick = OnChatClick
        end
        object btnBroadcastMsg: TButton
          Left = 435
          Top = 21
          Width = 109
          Height = 25
          Caption = 'Message'
          TabOrder = 3
          OnClick = btnBroadcastMsgClick
        end
      end
      object lstContacts: TTntListView
        Left = 0
        Top = 0
        Width = 484
        Height = 232
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
        OnSelectItem = lstContactsSelectItem
        ExplicitWidth = 545
        ExplicitHeight = 171
      end
    end
    object TabXData: TTabSheet
      Caption = 'TabXData'
      ImageIndex = 4
      ExplicitWidth = 545
      ExplicitHeight = 230
      inline xdataBox: TframeXData
        Left = 0
        Top = 0
        Width = 484
        Height = 291
        Align = alClient
        TabOrder = 0
        TabStop = True
        ExplicitWidth = 545
        ExplicitHeight = 230
        inherited Panel1: TPanel
          Width = 484
          Height = 291
          ExplicitWidth = 545
          ExplicitHeight = 230
          inherited ScrollBox1: TScrollBox
            Width = 474
            Height = 281
            ExplicitWidth = 535
            ExplicitHeight = 220
          end
        end
      end
    end
  end
  inherited pnlDockTop: TPanel
    Width = 492
    ExplicitWidth = 553
    inherited tbDockBar: TToolBar
      Left = 443
      ExplicitLeft = 504
    end
    inherited Panel1: TPanel
      Width = 440
      ExplicitWidth = 501
      inherited Bevel2: TBevel
        Width = 440
        ExplicitWidth = 409
      end
      inherited lblWizardTitle: TTntLabel
        Width = 126
        Caption = 'Jabber Search Wizard'
        ExplicitWidth = 126
      end
      inherited lblWizardDetails: TTntLabel
        Caption = ''
      end
      inherited Image1: TImage
        Left = 399
        Picture.Data = {00}
        ExplicitLeft = 368
      end
    end
  end
  object PopupMenu1: TTntPopupMenu
    Left = 296
    Top = 16
    object popAdd: TTntMenuItem
      Caption = 'Add Contact'
      OnClick = popAddClick
    end
    object popProfile: TTntMenuItem
      Caption = 'View Profile'
      OnClick = popProfileClick
    end
    object N1: TTntMenuItem
      Caption = '-'
    end
    object popChat: TTntMenuItem
      Caption = 'Start Chat'
      OnClick = popChatClick
    end
    object popMessage: TTntMenuItem
      Caption = 'Send Message'
      OnClick = popMessageClick
    end
  end
end
