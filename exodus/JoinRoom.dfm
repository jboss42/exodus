inherited frmJoinRoom: TfrmJoinRoom
  Left = 249
  Top = 151
  Caption = 'Join Room'
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited TntPanel1: TTntPanel
    inherited btnBack: TTntButton
      OnClick = btnBackClick
    end
    inherited btnNext: TTntButton
      OnClick = btnNextClick
    end
    inherited btnCancel: TTntButton
      OnClick = btnCancelClick
    end
  end
  inherited Panel1: TPanel
    inherited lblWizardTitle: TTntLabel
      Width = 150
      Caption = 'Join or Browse for a Room'
    end
    inherited lblWizardDetails: TTntLabel
      Caption = 'Specify or browse for a room to join or create.'
    end
  end
  inherited Tabs: TPageControl
    ActivePage = TabSheet2
    inherited TabSheet1: TTabSheet
      object Label2: TTntLabel
        Left = 22
        Top = 74
        Width = 65
        Height = 13
        Caption = 'Room Server:'
      end
      object Label1: TTntLabel
        Left = 22
        Top = 102
        Width = 62
        Height = 13
        Caption = 'Room Name:'
      end
      object lblPassword: TTntLabel
        Left = 22
        Top = 131
        Width = 49
        Height = 13
        Caption = 'Password:'
      end
      object Label3: TTntLabel
        Left = 6
        Top = 8
        Width = 51
        Height = 13
        Caption = 'Nickname:'
      end
      object txtServer: TTntComboBox
        Left = 131
        Top = 71
        Width = 190
        Height = 21
        Hint = 'Select the room server to use.'
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'txtServer'
      end
      object txtRoom: TTntEdit
        Left = 131
        Top = 100
        Width = 190
        Height = 21
        TabOrder = 1
      end
      object txtPassword: TTntEdit
        Left = 131
        Top = 129
        Width = 190
        Height = 21
        PasswordChar = '*'
        TabOrder = 2
      end
      object txtNick: TTntEdit
        Left = 131
        Top = 6
        Width = 190
        Height = 21
        TabOrder = 3
      end
      object optSpecify: TTntRadioButton
        Left = 1
        Top = 52
        Width = 400
        Height = 17
        Caption = 'Join or Create the following room:'
        Checked = True
        TabOrder = 4
        TabStop = True
        OnClick = optSpecifyClick
      end
      object optBrowse: TTntRadioButton
        Left = 0
        Top = 160
        Width = 377
        Height = 17
        Caption = 'Browse servers for a room to join'
        TabOrder = 5
        OnClick = optSpecifyClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object lstRooms: TTntListView
        Left = 0
        Top = 49
        Width = 410
        Height = 178
        Align = alClient
        Columns = <
          item
            Caption = 'Room'
            Width = 150
          end
          item
            Caption = 'Server'
            Width = 150
          end
          item
            Caption = 'Description'
            Width = 100
          end>
        OwnerData = True
        ReadOnly = True
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lstRoomsChange
        OnColumnClick = lstRoomsColumnClick
        OnData = lstRoomsData
        OnDblClick = lstRoomsDblClick
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 410
        Height = 49
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object lblFetch: TTntLabel
          Left = 2
          Top = 4
          Width = 154
          Height = 13
          Cursor = crHandPoint
          Caption = 'Show rooms found on this server'
        end
        object txtServerFilter: TTntComboBox
          Left = 19
          Top = 20
          Width = 262
          Height = 21
          Hint = 'Select the room server to use.'
          ItemHeight = 13
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = txtServerFilterChange
          OnKeyPress = txtServerFilterKeyPress
          OnSelect = txtServerFilterSelect
        end
        object btnFetch: TTntButton
          Left = 296
          Top = 18
          Width = 105
          Height = 25
          Caption = 'Fetch Rooms'
          TabOrder = 1
          OnClick = btnFetchClick
        end
      end
    end
  end
end
