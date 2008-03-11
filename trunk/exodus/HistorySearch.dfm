inherited frmHistorySearch: TfrmHistorySearch
  Caption = 'History'
  ClientHeight = 428
  ClientWidth = 545
  ParentFont = False
  OnCreate = FormCreate
  OnResize = FormResize
  ExplicitWidth = 553
  ExplicitHeight = 462
  PixelsPerInch = 96
  TextHeight = 13
  object pnlSearchBar: TTntPanel
    Left = 0
    Top = 0
    Width = 545
    Height = 150
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    ExplicitWidth = 500
    object pnlBasicSearchBar: TTntPanel
      Left = 0
      Top = 0
      Width = 545
      Height = 150
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 498
      ExplicitHeight = 35
      object pnlBasicSearchHistoryFor: TTntPanel
        Left = 0
        Top = 0
        Width = 250
        Height = 150
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        ExplicitLeft = 1
        ExplicitTop = 1
        ExplicitHeight = 33
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
          TabOrder = 0
        end
      end
      object pnlBasicSearchKeywordSearch: TTntPanel
        Left = 295
        Top = 0
        Width = 250
        Height = 150
        Align = alRight
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 1
        ExplicitLeft = 247
        ExplicitTop = 1
        ExplicitHeight = 33
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
      Width = 545
      Height = 150
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      Visible = False
      ExplicitTop = -1
      ExplicitWidth = 744
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
          Width = 160
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Enter one keyword per line'
        end
        object txtKeywords: TTntEdit
          Left = 5
          Top = 42
          Width = 160
          Height = 59
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          TabOrder = 0
        end
        object chkExact: TTntCheckBox
          Left = 5
          Top = 111
          Width = 160
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Exact Match'
          TabOrder = 1
        end
      end
      object grpJID: TTntGroupBox
        Left = 364
        Top = 9
        Width = 170
        Height = 135
        Caption = 'JIDs'
        TabOrder = 2
        DesignSize = (
          170
          135)
        object btnAddJID: TTntButton
          Left = 5
          Top = 107
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Add...'
          TabOrder = 0
        end
        object btnRemoveJID: TTntButton
          Left = 90
          Top = 107
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Remove'
          TabOrder = 1
        end
        object lstJids: TTntListBox
          Left = 5
          Top = 19
          Width = 160
          Height = 82
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 2
        end
      end
    end
  end
  object pnlResults: TTntPanel
    Left = 0
    Top = 185
    Width = 545
    Height = 243
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    ExplicitTop = 156
    ExplicitWidth = 500
    ExplicitHeight = 272
    object Splitter1: TSplitter
      Left = 0
      Top = 89
      Width = 545
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
      Width = 545
      Height = 89
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 500
      object TntListView1: TTntListView
        Left = 0
        Top = 0
        Width = 545
        Height = 89
        Align = alClient
        Columns = <
          item
            Width = 25
          end
          item
            Caption = 'JID'
            Width = 200
          end
          item
            Caption = 'Date'
            Width = 200
          end>
        Constraints.MinHeight = 50
        GridLines = True
        Items.ItemData = {
          01A20000000300000000000000FFFFFFFFFFFFFFFF0200000000000000036100
          620063000364006500660003680069006A0000000000FFFFFFFFFFFFFFFF0200
          00000000000003310032003300033400350036000337003800390000000000FF
          FFFFFFFFFFFFFF02000000000000000568006F00770064007900046400750064
          0065000C7400680069007300200069007300200063006F006F006C00FFFFFFFF
          FFFFFFFFFFFFFFFF}
        TabOrder = 0
        ViewStyle = vsReport
        ExplicitTop = -3
        ExplicitWidth = 500
      end
    end
    object pnlResultsHistory: TTntPanel
      Left = 0
      Top = 92
      Width = 545
      Height = 151
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 216
      ExplicitTop = 168
      ExplicitWidth = 185
      ExplicitHeight = 41
    end
  end
  object pnlControlBar: TTntPanel
    Left = 0
    Top = 150
    Width = 545
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    ExplicitTop = 193
    ExplicitWidth = 500
    DesignSize = (
      545
      35)
    object btnSerach: TTntButton
      Left = 461
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Search'
      TabOrder = 0
      ExplicitLeft = 416
    end
    object btnAdvBasicSwitch: TTntButton
      Left = 380
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Advanced'
      TabOrder = 1
      OnClick = btnAdvBasicSwitchClick
      ExplicitLeft = 335
    end
  end
end
