inherited frmJoinRoom: TfrmJoinRoom
  Left = 249
  Top = 151
  BorderStyle = bsSizeable
  Caption = 'Join Room'
  ClientHeight = 458
  ClientWidth = 502
  DefaultMonitor = dmMainForm
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  ExplicitWidth = 510
  ExplicitHeight = 498
  PixelsPerInch = 120
  TextHeight = 16
  inherited TntPanel1: TTntPanel
    Top = 407
    Width = 502
    TabOrder = 2
    ExplicitTop = 407
    ExplicitWidth = 502
    inherited Bevel1: TBevel
      Width = 502
      ExplicitWidth = 502
    end
    inherited Panel3: TPanel
      Left = 185
      Height = 45
      ExplicitLeft = 185
      inherited btnBack: TTntButton
        Enabled = False
        OnClick = btnBackClick
      end
      inherited btnNext: TTntButton
        Default = True
        Enabled = False
        OnClick = btnNextClick
      end
      inherited btnCancel: TTntButton
        OnClick = btnCancelClick
      end
    end
  end
  inherited Panel1: TPanel
    Width = 502
    ExplicitWidth = 502
    inherited Bevel2: TBevel
      Width = 502
      ExplicitWidth = 502
    end
    inherited lblWizardTitle: TTntLabel
      Width = 270
      Caption = 'Join or Browse for a Conference Room'
      ExplicitWidth = 270
    end
    inherited lblWizardDetails: TTntLabel
      Caption = 'Specify or browse for a conference room to join or create.'
    end
    inherited Image1: TImage
      Left = 451
      ExplicitLeft = 452
    end
  end
  inherited Tabs: TPageControl
    Width = 502
    Height = 333
    ActivePage = TabSheet2
    TabOrder = 0
    ExplicitWidth = 502
    ExplicitHeight = 333
    inherited TabSheet1: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 30
      ExplicitWidth = 494
      ExplicitHeight = 299
      object Label2: TTntLabel
        Left = 31
        Top = 161
        Width = 149
        Height = 16
        Caption = 'Conference Room Server:'
      end
      object Label1: TTntLabel
        Left = 31
        Top = 196
        Width = 144
        Height = 16
        Caption = 'Conference Room Name:'
      end
      object lblPassword: TTntLabel
        Left = 31
        Top = 231
        Width = 197
        Height = 16
        Caption = 'Password to join room if required:'
      end
      object Label3: TTntLabel
        Left = 7
        Top = 10
        Width = 80
        Height = 16
        Caption = 'My Nickname:'
      end
      object TntLabel1: TTntLabel
        Left = 10
        Top = 71
        Width = 424
        Height = 16
        Caption = 
          'If a new conference room is created you may be prompted to confi' +
          'gure it.'
      end
      object Bevel3: TBevel
        Left = 5
        Top = 121
        Width = 481
        Height = 6
        Shape = bsTopLine
      end
      object txtServer: TTntComboBox
        Left = 234
        Top = 162
        Width = 234
        Height = 24
        Hint = 'Select the conference room server to use.'
        ItemHeight = 16
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Text = 'txtServer'
        OnChange = txtServerChange
      end
      object txtRoom: TTntEdit
        Left = 234
        Top = 196
        Width = 234
        Height = 24
        TabOrder = 5
        OnChange = txtRoomChange
      end
      object txtPassword: TTntEdit
        Left = 234
        Top = 229
        Width = 234
        Height = 24
        PasswordChar = '*'
        TabOrder = 6
      end
      object txtNick: TTntEdit
        Left = 161
        Top = 7
        Width = 234
        Height = 24
        TabOrder = 0
        OnChange = txtNickChange
      end
      object optSpecify: TTntRadioButton
        Left = 5
        Top = 134
        Width = 492
        Height = 21
        Caption = 'Join or Create the following conference room:'
        Checked = True
        TabOrder = 3
        TabStop = True
        OnClick = optSpecifyClick
      end
      object optBrowse: TTntRadioButton
        Left = 4
        Top = 267
        Width = 464
        Height = 21
        Caption = 'Browse servers for a conference room to join'
        TabOrder = 7
        OnClick = optSpecifyClick
      end
      object chkDefaultConfig: TTntCheckBox
        Left = 31
        Top = 90
        Width = 418
        Height = 24
        Caption = 'Always accept default conference room configuration.'
        TabOrder = 2
        WordWrap = True
      end
      object chkUseRegisteredNickname: TTntCheckBox
        Left = 31
        Top = 42
        Width = 437
        Height = 21
        Caption = 'Use registered nickname if available.'
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object lstRooms: TTntListView
        Left = 0
        Top = 69
        Width = 494
        Height = 230
        Align = alClient
        Columns = <
          item
            Caption = 'Conference Room'
            Width = 185
          end
          item
            Caption = 'Server'
            Width = 185
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
        Width = 494
        Height = 69
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblFetch: TTntLabel
          Left = 2
          Top = 5
          Width = 257
          Height = 16
          Cursor = crHandPoint
          Caption = 'Show conference rooms found on this server'
        end
        object aniWait: TAnimate
          Left = 362
          Top = 5
          Width = 80
          Height = 50
          CommonAVI = aviFindFolder
          StopFrame = 29
          Visible = False
        end
        object txtServerFilter: TTntComboBox
          Left = 23
          Top = 25
          Width = 323
          Height = 24
          Hint = 'Select the conference room server to use.'
          ItemHeight = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnKeyPress = txtServerFilterKeyPress
          OnSelect = txtServerFilterSelect
        end
        object btnFetch: TTntButton
          Left = 364
          Top = 22
          Width = 130
          Height = 31
          Caption = 'Refresh'
          TabOrder = 1
          OnClick = btnFetchClick
        end
      end
    end
  end
end
