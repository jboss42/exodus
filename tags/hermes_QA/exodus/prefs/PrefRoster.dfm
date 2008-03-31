inherited frmPrefRoster: TfrmPrefRoster
  Left = 254
  Top = 162
  Caption = 'frmPrefRoster'
  ClientHeight = 680
  ClientWidth = 372
  OldCreateOrder = True
  OnDestroy = TntFormDestroy
  ExplicitWidth = 384
  ExplicitHeight = 692
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 372
    ExplicitWidth = 372
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 75
      Caption = 'Contact List'
      ExplicitLeft = 6
      ExplicitWidth = 75
    end
  end
  object ExGroupBox1: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 26
    Width = 353
    Height = 654
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    AutoHide = True
    object pnlRosterPrefs: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 60
      Width = 353
      Height = 94
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      AutoHide = True
      object chkInlineStatus: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 350
        Height = 16
        Margins.Left = 0
        Margins.Top = 0
        Align = alTop
        Caption = 'Show &contact status'
        TabOrder = 0
      end
      object chkUseProfileDN: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 19
        Width = 350
        Height = 16
        Margins.Left = 0
        Margins.Top = 0
        Align = alTop
        Caption = 'Get &display name from contact profile'
        TabOrder = 1
      end
      object chkHideBlocked: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 38
        Width = 350
        Height = 17
        Margins.Left = 0
        Margins.Top = 0
        Align = alTop
        Caption = '&Hide blocked contacts '
        TabOrder = 2
      end
      object chkGroupCounts: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 58
        Width = 350
        Height = 15
        Margins.Left = 0
        Margins.Top = 0
        Align = alTop
        Caption = 
          'Show group &members online status at group level (i.e. 5 of 10 o' +
          'nline)'
        TabOrder = 3
      end
      object chkOnlineOnly: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 76
        Width = 350
        Height = 15
        Margins.Left = 0
        Margins.Top = 0
        Align = alTop
        Caption = 'Show &offline contacts'
        TabOrder = 4
      end
    end
    object pnlManageBtn: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 157
      Width = 350
      Height = 21
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 3
      AutoHide = True
      object btnManageBlocked: TTntButton
        Left = 17
        Top = 0
        Width = 158
        Height = 21
        Caption = 'Manage &Blocked Contacts...'
        TabOrder = 0
        OnClick = btnManageBlockedClick
      end
    end
    object grpAdvanced: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 187
      Width = 353
      Height = 99
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Advanced contact list preferences'
      ParentColor = True
      TabOrder = 4
      AutoHide = True
      object pnlStatusColor: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 21
        Width = 350
        Height = 22
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        DesignSize = (
          350
          22)
        object lblStatusColor: TTntLabel
          Left = 0
          Top = 2
          Width = 101
          Height = 13
          Caption = 'Contact s&tatus color:'
        end
        object cboStatusColor: TColorBox
          Left = 149
          Top = 0
          Width = 182
          Height = 22
          DefaultColorColor = clBlue
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 12
          ItemHeight = 16
          TabOrder = 0
        end
      end
      object pnlDNFields: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 46
        Width = 350
        Height = 21
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        DesignSize = (
          350
          21)
        object lblDNProfileMap: TTntLabel
          Left = 0
          Top = 2
          Width = 128
          Height = 13
          Caption = 'Display name &profile fields:'
        end
        object txtDNProfileMap: TTntEdit
          Left = 149
          Top = 0
          Width = 182
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
      object chkShowPending: TTntCheckBox
        Left = 0
        Top = 67
        Width = 353
        Height = 16
        Align = alTop
        Caption = 'Show contacts I have asked to add as "Pending"'
        TabOrder = 3
      end
      object chkObservers: TTntCheckBox
        Left = 0
        Top = 83
        Width = 353
        Height = 16
        Align = alTop
        Caption = 'Show observers'
        TabOrder = 4
      end
    end
    object gbDepricated: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 295
      Width = 353
      Height = 278
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Depricated preferences (may not be supported)'
      ParentColor = True
      TabOrder = 5
      AutoHide = True
      object chkSort: TTntCheckBox
        Left = 0
        Top = 18
        Width = 353
        Height = 16
        Align = alTop
        Caption = 'Sort Contacts by their availability'
        TabOrder = 1
      end
      object chkOfflineGrp: TTntCheckBox
        Left = 0
        Top = 34
        Width = 353
        Height = 15
        Align = alTop
        Caption = 'Show offline contacts in an Offline group'
        TabOrder = 2
      end
      object pnlMinStatus: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 144
        Width = 350
        Height = 41
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        AutoHide = True
        object lblFilter: TTntLabel
          Left = 0
          Top = 2
          Width = 43
          Height = 39
          Caption = '"Online" minimum status: '
          WordWrap = True
        end
        object cboVisible: TTntComboBox
          Left = 143
          Top = 0
          Width = 155
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          Items.Strings = (
            'Do Not Disturb'
            'Ext. Away'
            'Away'
            'Available')
        end
      end
      object pnlGatewayGroup: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 191
        Width = 350
        Height = 21
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        AutoHide = True
        object lblGatewayGrp: TTntLabel
          Left = 0
          Top = 2
          Width = 78
          Height = 13
          Caption = 'Gateway group:'
        end
        object txtGatewayGrp: TTntComboBox
          Left = 143
          Top = 0
          Width = 155
          Height = 21
          ItemHeight = 13
          TabOrder = 0
        end
      end
      object chkPresErrors: TTntCheckBox
        Left = 0
        Top = 95
        Width = 353
        Height = 16
        Align = alTop
        Caption = 'Detect contacts which are unreachable or no longer exist'
        TabOrder = 5
        Visible = False
      end
      object chkShowUnsubs: TTntCheckBox
        Left = 0
        Top = 127
        Width = 353
        Height = 14
        Align = alTop
        Caption = 'Show contacts which I do not have a subscription to'
        TabOrder = 6
      end
      object chkRosterUnicode: TTntCheckBox
        Left = 0
        Top = 64
        Width = 353
        Height = 15
        Align = alTop
        Caption = 
          'Allow Unicode characters in the contact list (requires 2000, ME,' +
          ' XP).'
        TabOrder = 7
      end
      object chkRosterAvatars: TTntCheckBox
        Left = 0
        Top = 111
        Width = 353
        Height = 16
        Align = alTop
        Caption = 'Show Avatars in the contact list'
        TabOrder = 8
      end
      object pnlDblClickAction: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 218
        Width = 350
        Height = 21
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 9
        AutoHide = True
        object lblDblClick: TTntLabel
          Left = 0
          Top = 2
          Width = 107
          Height = 13
          Caption = 'Default dblclick action:'
        end
        object cboDblClick: TTntComboBox
          Left = 143
          Top = 0
          Width = 155
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          Items.Strings = (
            'A new one to one chat window'
            'An instant message window'
            'A new or existing chat window')
        end
      end
      object pnlGroupSeparator: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 245
        Width = 350
        Height = 21
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 10
        AutoHide = True
        object lblGrpSeparator: TTntLabel
          Left = 0
          Top = 2
          Width = 119
          Height = 13
          Caption = 'Nested group seperator:'
        end
        object txtGrpSeparator: TTntEdit
          Left = 143
          Top = 0
          Width = 155
          Height = 21
          TabOrder = 0
        end
      end
      object pnlAlpha: TExBrandPanel
        Left = 0
        Top = 269
        Width = 353
        Height = 45
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 11
        AutoHide = True
        object chkRosterAlpha: TTntCheckBox
          Left = 0
          Top = 0
          Width = 194
          Height = 15
          Caption = 'Use Alpha Blending'
          TabOrder = 1
          OnClick = chkRosterAlphaClick
        end
        object trkRosterAlpha: TTrackBar
          Left = 7
          Top = 23
          Width = 132
          Height = 16
          Enabled = False
          Max = 255
          Min = 100
          PageSize = 15
          Frequency = 15
          Position = 255
          TabOrder = 2
          ThumbLength = 15
          TickStyle = tsNone
          OnChange = trkRosterAlphaChange
        end
        object txtRosterAlpha: TExNumericEdit
          Left = 143
          Top = 20
          Width = 53
          Height = 25
          BevelOuter = bvNone
          Enabled = False
          ParentColor = True
          TabOrder = 0
          Text = '255'
          Min = 100
          Max = 255
          OnChange = txtRosterAlphaChange
          DesignSize = (
            53
            25)
        end
      end
      object chkCollapsed: TTntCheckBox
        Left = 0
        Top = 49
        Width = 353
        Height = 15
        Align = alTop
        Caption = 'Collapse &all contact groups initially'
        TabOrder = 12
      end
      object chkNestedGrps: TTntCheckBox
        Left = 0
        Top = 79
        Width = 353
        Height = 16
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Use nested groups'
        TabOrder = 13
      end
    end
    object pnlDefaultNIck: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 6
      Width = 350
      Height = 21
      Margins.Left = 0
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      AutoHide = True
      DesignSize = (
        350
        21)
      object lblDefaultNick: TTntLabel
        Left = 0
        Top = 3
        Width = 132
        Height = 13
        Margins.Left = 0
        Caption = 'Default &nickname for chats:'
        FocusControl = txtDefaultNick
      end
      object txtDefaultNick: TTntEdit
        Left = 161
        Top = 0
        Width = 170
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
    end
    object pnlDefaultGroup: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 33
      Width = 350
      Height = 21
      Margins.Left = 0
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      AutoHide = True
      DesignSize = (
        350
        21)
      object lblDefaultGrp: TTntLabel
        Left = 0
        Top = 3
        Width = 154
        Height = 13
        Caption = 'Default &group for new contacts:'
        FocusControl = txtDefaultGrp
      end
      object txtDefaultGrp: TTntComboBox
        Left = 161
        Top = 0
        Width = 170
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 0
      end
    end
  end
end
