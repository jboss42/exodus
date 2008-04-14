inherited frmHistorySearch: TfrmHistorySearch
  Caption = 'History'
  ClientHeight = 426
  ClientWidth = 718
  ParentFont = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseEnter = FormMouseEnter
  OnMouseLeave = FormMouseLeave
  OnResize = FormResize
  ExplicitWidth = 726
  ExplicitHeight = 460
  PixelsPerInch = 96
  TextHeight = 13
  object pnlSearchBar: TTntPanel
    Left = 0
    Top = 0
    Width = 718
    Height = 150
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    ExplicitWidth = 720
    object pnlBasicSearchBar: TTntPanel
      Left = 0
      Top = 0
      Width = 718
      Height = 150
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      ExplicitWidth = 720
      object pnlBasicSearchHistoryFor: TTntPanel
        Left = 0
        Top = 0
        Width = 250
        Height = 150
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        DesignSize = (
          250
          150)
        object lblBasicHistoryFor: TTntLabel
          Left = 8
          Top = 9
          Width = 57
          Height = 13
          Caption = 'History For:'
        end
        object txtBasicHistoryFor: TTntEdit
          Left = 71
          Top = 7
          Width = 169
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ParentColor = True
          ReadOnly = True
          TabOrder = 0
        end
      end
      object pnlBasicSearchKeywordSearch: TTntPanel
        Left = 468
        Top = 0
        Width = 250
        Height = 150
        Align = alRight
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 0
        ExplicitLeft = 470
        DesignSize = (
          250
          150)
        object lblBasicKeywordSearch: TTntLabel
          Left = 10
          Top = 9
          Width = 82
          Height = 13
          Caption = 'Keyword Search:'
        end
        object txtBasicKeywordSearch: TTntEdit
          Left = 98
          Top = 7
          Width = 143
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
    end
    object pnlAdvancedSearchBar: TTntPanel
      Left = 0
      Top = 0
      Width = 718
      Height = 150
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      Visible = False
      ExplicitWidth = 720
      object grpDate: TTntGroupBox
        Left = 8
        Top = 9
        Width = 170
        Height = 135
        Caption = 'Date'
        TabOrder = 0
        DesignSize = (
          170
          135)
        object lblFrom: TTntLabel
          Left = 19
          Top = 69
          Width = 28
          Height = 13
          Caption = 'From:'
        end
        object lblTo: TTntLabel
          Left = 19
          Top = 96
          Width = 16
          Height = 13
          Caption = 'To:'
        end
        object dateFrom: TTntDateTimePicker
          Left = 72
          Top = 65
          Width = 89
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Date = 39518.604981203700000000
          Time = 39518.604981203700000000
          TabOrder = 0
          OnChange = dateFromChange
        end
        object dateTo: TTntDateTimePicker
          Left = 72
          Top = 92
          Width = 89
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Date = 39518.605032743060000000
          Time = 39518.605032743060000000
          TabOrder = 1
          OnChange = dateToChange
        end
        object radioAll: TTntRadioButton
          Left = 7
          Top = 19
          Width = 160
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'All'
          Checked = True
          TabOrder = 2
          TabStop = True
          OnClick = radioAllClick
        end
        object radioRange: TTntRadioButton
          Left = 7
          Top = 42
          Width = 160
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Range'
          TabOrder = 3
          OnClick = radioRangeClick
        end
      end
      object grpKeyword: TTntGroupBox
        Left = 186
        Top = 9
        Width = 170
        Height = 135
        Caption = 'Keywords'
        TabOrder = 1
        DesignSize = (
          170
          135)
        object TntLabel3: TTntLabel
          Left = 5
          Top = 20
          Width = 129
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Enter one keyword per line'
        end
        object chkExact: TTntCheckBox
          Left = 5
          Top = 111
          Width = 160
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Exact Match'
          TabOrder = 0
        end
        object txtKeywords: TTntMemo
          Left = 5
          Top = 42
          Width = 160
          Height = 59
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          WordWrap = False
        end
      end
      object grpContacts: TTntGroupBox
        Left = 364
        Top = 9
        Width = 170
        Height = 135
        Caption = 'Contacts'
        TabOrder = 2
        DesignSize = (
          170
          135)
        object btnAddContact: TTntButton
          Left = 5
          Top = 104
          Width = 68
          Height = 28
          Anchors = [akTop, akRight]
          Caption = 'Add...'
          TabOrder = 0
          OnClick = btnAddContactClick
        end
        object btnRemoveContact: TTntButton
          Left = 97
          Top = 104
          Width = 68
          Height = 28
          Anchors = [akTop, akRight]
          Caption = 'Remove'
          TabOrder = 1
          OnClick = btnRemoveContactClick
        end
        object lstContacts: TTntListBox
          Left = 5
          Top = 19
          Width = 160
          Height = 82
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          MultiSelect = True
          TabOrder = 2
          OnClick = lstContactsClick
        end
      end
      object grpRooms: TTntGroupBox
        Left = 540
        Top = 9
        Width = 170
        Height = 135
        Caption = 'Rooms'
        TabOrder = 3
        DesignSize = (
          170
          135)
        object btnAddRoom: TTntButton
          Left = 4
          Top = 104
          Width = 68
          Height = 28
          Anchors = [akTop, akRight]
          Caption = 'Add...'
          TabOrder = 0
          OnClick = btnAddRoomClick
        end
        object btnRemoveRoom: TTntButton
          Left = 96
          Top = 104
          Width = 68
          Height = 28
          Anchors = [akTop, akRight]
          Caption = 'Remove'
          TabOrder = 1
          OnClick = btnRemoveRoomClick
        end
        object lstRooms: TTntListBox
          Left = 4
          Top = 19
          Width = 160
          Height = 82
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          MultiSelect = True
          TabOrder = 2
          OnClick = lstRoomsClick
        end
      end
    end
  end
  object pnlResults: TTntPanel
    Left = 0
    Top = 185
    Width = 718
    Height = 241
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    ExplicitWidth = 720
    ExplicitHeight = 243
    object Splitter1: TSplitter
      Left = 0
      Top = 89
      Width = 718
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ResizeStyle = rsUpdate
      ExplicitTop = 121
      ExplicitWidth = 145
    end
    object pnlResultsList: TTntPanel
      Left = 0
      Top = 0
      Width = 718
      Height = 89
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 720
      object lstResults: TTntListView
        Left = 0
        Top = 0
        Width = 718
        Height = 89
        Align = alClient
        Columns = <
          item
            Caption = 'To'
            Width = 150
          end
          item
            Caption = 'Date'
            Width = 100
          end
          item
            Caption = 'Message'
            Width = 215
          end>
        Constraints.MinHeight = 50
        GridLines = True
        IconOptions.Arrangement = iaLeft
        ReadOnly = True
        RowSelect = True
        SmallImages = frmExodus.ImageList1
        SortType = stBoth
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lstResultsChange
        OnColumnClick = lstResultsColumnClick
        OnCompare = lstResultsCompare
        OnCustomDrawItem = lstResultsCustomDrawItem
        ExplicitWidth = 720
      end
    end
    object pnlResultsHistory: TTntPanel
      Left = 0
      Top = 92
      Width = 718
      Height = 149
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 720
      ExplicitHeight = 151
    end
  end
  object pnlControlBar: TTntPanel
    Left = 0
    Top = 150
    Width = 718
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    ExplicitWidth = 720
    DesignSize = (
      718
      35)
    object TntBevel1: TTntBevel
      Left = 0
      Top = 0
      Width = 718
      Height = 50
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 144
      ExplicitTop = 8
      ExplicitWidth = 50
    end
    object btnSearch: TTntButton
      Left = 637
      Top = 6
      Width = 68
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'Search'
      TabOrder = 0
      OnClick = btnSearchClick
      ExplicitLeft = 639
    end
    object btnAdvBasicSwitch: TTntButton
      Left = 563
      Top = 6
      Width = 68
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'Advanced'
      TabOrder = 1
      OnClick = btnAdvBasicSwitchClick
      ExplicitLeft = 565
    end
    object btnPrint: TTntButton
      Left = 8
      Top = 6
      Width = 68
      Height = 28
      Caption = 'Print...'
      TabOrder = 2
      OnClick = bntPrintClick
    end
    object btnDelete: TTntButton
      Left = 82
      Top = 6
      Width = 68
      Height = 28
      Caption = 'Delete...'
      TabOrder = 3
      OnClick = btnDeleteClick
    end
  end
  object mnuResultHistoryPopup: TTntPopupMenu
    Left = 8
    Top = 288
    object popCopy: TTntMenuItem
      Caption = 'Copy'
      ShortCut = 16451
      OnClick = popCopyClick
    end
    object popCopyAll: TTntMenuItem
      Caption = 'Copy All'
      ShortCut = 16449
      OnClick = popCopyAllClick
    end
    object popPrint: TTntMenuItem
      Caption = 'Print...'
      ShortCut = 16464
      OnClick = popPrintClick
    end
    object popSaveAs: TTntMenuItem
      Caption = 'Save As...'
      ShortCut = 16467
      OnClick = popSaveAsClick
    end
  end
  object dlgSave: TTntSaveDialog
    Left = 40
    Top = 288
  end
  object dlgPrint: TPrintDialog
    Left = 72
    Top = 288
  end
end
