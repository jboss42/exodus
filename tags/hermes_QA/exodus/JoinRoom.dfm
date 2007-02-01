inherited frmJoinRoom: TfrmJoinRoom
  Left = 249
  Top = 151
  BorderStyle = bsSizeable
  Caption = 'Join Room'
  ClientHeight = 372
  ClientWidth = 408
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 416
  ExplicitHeight = 405
  PixelsPerInch = 96
  TextHeight = 13
  inherited TntPanel1: TTntPanel
    Top = 331
    Width = 408
    TabOrder = 2
    ExplicitTop = 331
    ExplicitWidth = 408
    inherited Bevel1: TBevel
      Width = 408
      ExplicitWidth = 408
    end
    inherited Panel3: TPanel
      Left = 151
      ExplicitLeft = 151
      inherited btnBack: TTntButton
        OnClick = btnBackClick
      end
      inherited btnNext: TTntButton
        Default = True
        OnClick = btnNextClick
      end
      inherited btnCancel: TTntButton
        OnClick = btnCancelClick
      end
    end
  end
  inherited Panel1: TPanel
    Width = 408
    ExplicitWidth = 408
    inherited Bevel2: TBevel
      Width = 408
      ExplicitWidth = 408
    end
    inherited lblWizardTitle: TTntLabel
      Width = 219
      Caption = 'Join or Browse for a Conference Room'
      ExplicitWidth = 219
    end
    inherited lblWizardDetails: TTntLabel
      Caption = 'Specify or browse for a conference room to join or create.'
    end
    inherited Image1: TImage
      Left = 367
      Picture.Data = {00}
      ExplicitLeft = 367
    end
  end
  inherited Tabs: TPageControl
    Width = 408
    Height = 271
    TabOrder = 0
    ExplicitWidth = 408
    ExplicitHeight = 271
    inherited TabSheet1: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 27
      ExplicitWidth = 400
      ExplicitHeight = 240
      object Label2: TTntLabel
        Left = 25
        Top = 131
        Width = 123
        Height = 13
        Caption = 'Conference Room Server:'
      end
      object Label1: TTntLabel
        Left = 25
        Top = 159
        Width = 120
        Height = 13
        Caption = 'Conference Room Name:'
      end
      object lblPassword: TTntLabel
        Left = 25
        Top = 188
        Width = 49
        Height = 13
        Caption = 'Password:'
      end
      object Label3: TTntLabel
        Left = 6
        Top = 8
        Width = 68
        Height = 13
        Caption = 'My Nickname:'
      end
      object TntLabel1: TTntLabel
        Left = 8
        Top = 58
        Width = 344
        Height = 13
        Caption = 
          'If a new conference room is created you may be prompted to confi' +
          'gure it.'
      end
      object Bevel3: TBevel
        Left = 4
        Top = 98
        Width = 391
        Height = 5
        Shape = bsTopLine
      end
      object txtServer: TTntComboBox
        Left = 162
        Top = 128
        Width = 190
        Height = 21
        Hint = 'Select the conference room server to use.'
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Text = 'txtServer'
      end
      object txtRoom: TTntEdit
        Left = 162
        Top = 157
        Width = 190
        Height = 21
        TabOrder = 5
      end
      object txtPassword: TTntEdit
        Left = 162
        Top = 186
        Width = 190
        Height = 21
        PasswordChar = '*'
        TabOrder = 6
      end
      object txtNick: TTntEdit
        Left = 131
        Top = 6
        Width = 190
        Height = 21
        TabOrder = 0
      end
      object optSpecify: TTntRadioButton
        Left = 4
        Top = 109
        Width = 400
        Height = 17
        Caption = 'Join or Create the following conference room:'
        Checked = True
        TabOrder = 3
        TabStop = True
        OnClick = optSpecifyClick
      end
      object optBrowse: TTntRadioButton
        Left = 3
        Top = 217
        Width = 377
        Height = 17
        Caption = 'Browse servers for a conference room to join'
        TabOrder = 7
        OnClick = optSpecifyClick
      end
      object chkDefaultConfig: TTntCheckBox
        Left = 25
        Top = 73
        Width = 340
        Height = 20
        Caption = 'Always accept default conference room configuration.'
        TabOrder = 2
        WordWrap = True
      end
      object chkUseRegisteredNickname: TTntCheckBox
        Left = 25
        Top = 34
        Width = 355
        Height = 17
        Caption = 'Use registered nickname if available.'
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object lstRooms: TTntListView
        Left = 0
        Top = 56
        Width = 400
        Height = 184
        Align = alClient
        Columns = <
          item
            Caption = 'Conference Room'
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
        RowSelect = True
        SortType = stText
        TabOrder = 1
        ViewStyle = vsReport
        OnChange = lstRoomsChange
        OnColumnClick = lstRoomsColumnClick
        OnData = lstRoomsData
        OnDataFind = lstRoomsDataFind
        OnDblClick = lstRoomsDblClick
        OnKeyPress = lstRoomsKeyPress
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 400
        Height = 56
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblFetch: TTntLabel
          Left = 2
          Top = 4
          Width = 211
          Height = 13
          Cursor = crHandPoint
          Caption = 'Show conference rooms found on this server'
        end
        object aniWait: TAnimate
          Left = 294
          Top = 4
          Width = 80
          Height = 50
          CommonAVI = aviFindFolder
          StopFrame = 29
          Visible = False
        end
        object txtServerFilter: TTntComboBox
          Left = 19
          Top = 20
          Width = 262
          Height = 21
          Hint = 'Select the conference room server to use.'
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
          Caption = 'Fetch Conference Rooms'
          TabOrder = 1
          OnClick = btnFetchClick
        end
      end
    end
  end
end
