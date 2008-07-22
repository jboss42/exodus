inherited frmJud: TfrmJud
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = 'Jabber Search'
  ClientHeight = 512
  ClientWidth = 606
  OldCreateOrder = True
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 16
  inherited TntPanel1: TTntPanel
    Top = 462
    Width = 606
    ExplicitTop = 462
    ExplicitWidth = 606
    inherited Bevel1: TBevel
      Width = 606
      ExplicitWidth = 606
    end
    inherited btnBack: TTntButton
      Left = 308
      Anchors = [akTop, akRight]
      Cancel = True
      OnClick = btnBackClick
      ExplicitLeft = 308
    end
    inherited btnNext: TTntButton
      Left = 401
      Anchors = [akTop, akRight]
      Default = True
      OnClick = btnNextClick
      ExplicitLeft = 401
    end
    inherited btnCancel: TTntButton
      Left = 505
      Anchors = [akTop, akRight]
      OnClick = btnCancelClick
      ExplicitLeft = 505
    end
  end
  inherited Tabs: TPageControl
    Width = 606
    Height = 365
    ActivePage = TabSheet4
    ExplicitWidth = 606
    ExplicitHeight = 365
    inherited TabSheet1: TTabSheet
      OnEnter = TabSheet1Enter
      ExplicitWidth = 598
      ExplicitHeight = 331
      object lblSelect: TTntLabel
        Left = 0
        Top = 0
        Width = 598
        Height = 16
        Align = alTop
        Caption = 'Select the user database for the search agent to use:'
        WordWrap = True
        ExplicitWidth = 306
      end
      object cboJID: TTntComboBox
        Left = 20
        Top = 41
        Width = 286
        Height = 24
        ItemHeight = 16
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
        Width = 598
        Height = 16
        Align = alTop
        Caption = 'Please wait. Contacting search agent:'
        WordWrap = True
        ExplicitWidth = 216
      end
      object aniWait: TAnimate
        Left = 0
        Top = 16
        Width = 598
        Height = 50
        Align = alTop
        CommonAVI = aviFindFolder
        StopFrame = 29
      end
    end
    object TabFields: TTabSheet
      Caption = 'TabFields'
      ImageIndex = 2
      object lblInstructions: TTntLabel
        Left = 0
        Top = 0
        Width = 598
        Height = 16
        Align = alTop
        Caption = 'Fill in the search criteria to find contacts on.'
        WordWrap = True
        ExplicitWidth = 251
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
      object Panel2: TPanel
        Left = 0
        Top = 259
        Width = 598
        Height = 72
        Align = alBottom
        BevelOuter = bvNone
        BorderWidth = 2
        ParentColor = True
        TabOrder = 0
        object Label3: TTntLabel
          Left = 2
          Top = 2
          Width = 156
          Height = 16
          Caption = 'Add Contacts to this group:'
        end
        object lblCount: TTntLabel
          Left = 397
          Top = 2
          Width = 79
          Height = 16
          Alignment = taRightJustify
          Caption = 'N items found'
        end
        object lblGroup: TTntLabel
          Left = 8
          Top = 32
          Width = 4
          Height = 16
        end
        object btnContacts: TButton
          Left = 255
          Top = 26
          Width = 134
          Height = 31
          Caption = 'Add Contacts'
          TabOrder = 0
          OnClick = popAddClick
        end
        object btnChat: TButton
          Left = 395
          Top = 26
          Width = 134
          Height = 31
          Caption = 'Chat'
          TabOrder = 1
          OnClick = OnChatClick
        end
        object btnBroadcastMsg: TButton
          Left = 535
          Top = 26
          Width = 135
          Height = 31
          Caption = 'Message'
          TabOrder = 2
          OnClick = btnBroadcastMsgClick
        end
      end
      object lstContacts: TTntListView
        Left = 0
        Top = 0
        Width = 598
        Height = 259
        Align = alClient
        Columns = <
          item
            Width = 62
          end
          item
            Width = 62
          end
          item
            Width = 62
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
      end
    end
    object TabXData: TTabSheet
      Caption = 'TabXData'
      ImageIndex = 4
      inline xdataBox: TframeXData
        Left = 0
        Top = 0
        Width = 598
        Height = 331
        Align = alClient
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        ExplicitWidth = 598
        ExplicitHeight = 331
        inherited Panel1: TPanel
          Width = 598
          Height = 331
          ExplicitWidth = 598
          ExplicitHeight = 331
          inherited ScrollBox1: TScrollBox
            Width = 588
            Height = 321
            ExplicitWidth = 588
            ExplicitHeight = 321
          end
        end
      end
    end
  end
  inherited pnlDock: TTntPanel
    Width = 606
    inherited pnlDockTopContainer: TTntPanel
      Width = 606
      inherited tbDockBar: TToolBar
        Left = 556
        ExplicitLeft = 556
      end
      inherited pnlDockTop: TTntPanel
        Width = 552
        ExplicitWidth = 552
        inherited Panel1: TPanel
          Width = 550
          ExplicitWidth = 550
          inherited lblWizardTitle: TTntLabel
            Width = 155
            Caption = 'Jabber Search Wizard'
            ExplicitWidth = 155
          end
          inherited lblWizardDetails: TTntLabel
            Caption = ''
          end
          inherited Image1: TImage
            Left = 500
            Picture.Data = {00}
            ExplicitLeft = 491
          end
        end
        inherited pnlBevel: TTntPanel
          Width = 550
          inherited Bevel2: TBevel
            Width = 550
            ExplicitWidth = 542
          end
        end
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 606
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
