inherited frmJud: TfrmJud
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = 'Jabber Search'
  ClientHeight = 416
  ClientWidth = 563
  OldCreateOrder = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  ExplicitWidth = 571
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  inherited TntPanel1: TTntPanel
    Top = 375
    Width = 563
    ExplicitTop = 375
    ExplicitWidth = 492
    inherited Bevel1: TBevel
      Width = 563
      ExplicitWidth = 492
    end
    inherited Panel3: TPanel
      Left = 306
      ExplicitLeft = 235
      inherited btnBack: TTntButton
        Anchors = [akTop, akRight]
        Cancel = True
        OnClick = btnBackClick
      end
      inherited btnNext: TTntButton
        Anchors = [akTop, akRight]
        Default = True
        OnClick = btnNextClick
      end
      inherited btnCancel: TTntButton
        Anchors = [akTop, akRight]
        OnClick = btnCancelClick
      end
    end
  end
  inherited Panel1: TPanel
    Width = 563
    ExplicitWidth = 492
    inherited Bevel2: TBevel
      Width = 563
      ExplicitWidth = 492
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
      Left = 522
      ExplicitLeft = 406
    end
  end
  inherited Tabs: TPageControl
    Width = 563
    Height = 315
    ActivePage = TabSheet4
    ExplicitWidth = 492
    ExplicitHeight = 315
    inherited TabSheet1: TTabSheet
      OnEnter = TabSheet1Enter
      ExplicitWidth = 484
      ExplicitHeight = 284
      object lblSelect: TTntLabel
        Left = 0
        Top = 0
        Width = 555
        Height = 13
        Align = alTop
        Caption = 'Select the user database for the search agent to use:'
        WordWrap = True
        ExplicitWidth = 259
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
      ExplicitWidth = 484
      object lblWait: TTntLabel
        Left = 0
        Top = 0
        Width = 555
        Height = 13
        Align = alTop
        Caption = 'Please wait. Contacting search agent:'
        WordWrap = True
        ExplicitWidth = 183
      end
      object aniWait: TAnimate
        Left = 0
        Top = 13
        Width = 555
        Height = 50
        Align = alTop
        CommonAVI = aviFindFolder
        StopFrame = 29
        ExplicitWidth = 484
      end
    end
    object TabFields: TTabSheet
      Caption = 'TabFields'
      ImageIndex = 2
      ExplicitWidth = 484
      object lblInstructions: TTntLabel
        Left = 0
        Top = 0
        Width = 555
        Height = 13
        Align = alTop
        Caption = 'Fill in the search criteria to find contacts on.'
        WordWrap = True
        ExplicitWidth = 210
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
      ExplicitWidth = 484
      object Panel2: TPanel
        Left = 0
        Top = 225
        Width = 555
        Height = 59
        Align = alBottom
        BevelOuter = bvNone
        BorderWidth = 2
        ParentColor = True
        TabOrder = 0
        ExplicitWidth = 484
        object Label3: TTntLabel
          Left = 2
          Top = 2
          Width = 133
          Height = 13
          Caption = 'Add Contacts to this group:'
        end
        object lblCount: TTntLabel
          Left = 321
          Top = 2
          Width = 66
          Height = 13
          Alignment = taRightJustify
          Caption = 'N items found'
        end
        object lblGroup: TTntLabel
          Left = 7
          Top = 26
          Width = 3
          Height = 13
        end
        object btnContacts: TButton
          Left = 207
          Top = 21
          Width = 109
          Height = 25
          Caption = 'Add Contacts'
          TabOrder = 0
          OnClick = popAddClick
        end
        object btnChat: TButton
          Left = 321
          Top = 21
          Width = 109
          Height = 25
          Caption = 'Chat'
          TabOrder = 1
          OnClick = OnChatClick
        end
        object btnBroadcastMsg: TButton
          Left = 435
          Top = 21
          Width = 109
          Height = 25
          Caption = 'Message'
          TabOrder = 2
          OnClick = btnBroadcastMsgClick
        end
      end
      object lstContacts: TTntListView
        Left = 0
        Top = 0
        Width = 555
        Height = 225
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
        OnMouseUp = lstContactsMouseUp
        ExplicitWidth = 484
      end
    end
    object TabXData: TTabSheet
      Caption = 'TabXData'
      ImageIndex = 4
      ExplicitWidth = 484
      inline xdataBox: TframeXData
        Left = 0
        Top = 0
        Width = 555
        Height = 284
        Align = alClient
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        ExplicitWidth = 484
        ExplicitHeight = 284
        inherited Panel1: TPanel
          Width = 555
          Height = 284
          ExplicitWidth = 484
          ExplicitHeight = 284
          inherited ScrollBox1: TScrollBox
            Width = 545
            Height = 274
            ExplicitWidth = 474
            ExplicitHeight = 274
          end
        end
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
  end
end
