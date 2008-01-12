inherited frmPrefRoster: TfrmPrefRoster
  Left = 254
  Top = 162
  Caption = 'frmPrefRoster'
  ClientHeight = 747
  ClientWidth = 488
  OldCreateOrder = True
  OnDestroy = TntFormDestroy
  ExplicitWidth = 500
  ExplicitHeight = 759
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 488
    ExplicitWidth = 488
    inherited lblHeader: TTntLabel
      Width = 184
      Caption = 'Contact List Preferences'
      ExplicitWidth = 184
    end
  end
  object ExGroupBox1: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 33
    Width = 433
    Height = 708
    Margins.Left = 0
    Margins.Top = 6
    Margins.Right = 0
    Margins.Bottom = 6
    Align = alLeft
    AutoSize = True
    TabOrder = 1
    TabStop = True
    AutoHide = True
    ExplicitHeight = 944
    object pnlRosterPrefs: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 66
      Width = 433
      Height = 126
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      TabOrder = 0
      TabStop = True
      AutoHide = True
      ExplicitTop = 68
      object chkInlineStatus: TTntCheckBox
        Left = 0
        Top = 0
        Width = 433
        Height = 21
        Align = alTop
        Caption = 'Show contact status'
        TabOrder = 0
      end
      object chkUseProfileDN: TTntCheckBox
        Left = 0
        Top = 21
        Width = 433
        Height = 21
        Align = alTop
        Caption = 'Get display name from contact profile'
        TabOrder = 1
      end
      object chkCollapsed: TTntCheckBox
        Left = 0
        Top = 42
        Width = 433
        Height = 21
        Align = alTop
        Caption = 'Collapse all contact groups initially'
        TabOrder = 2
      end
      object chkHideBlocked: TTntCheckBox
        Left = 0
        Top = 63
        Width = 433
        Height = 22
        Align = alTop
        Caption = 'Hide blocked contacts '
        TabOrder = 3
      end
      object chkGroupCounts: TTntCheckBox
        Left = 0
        Top = 85
        Width = 433
        Height = 20
        Align = alTop
        Caption = 'Show group members online status at group level (e.g., 5/10)'
        TabOrder = 4
      end
      object chkOnlineOnly: TTntCheckBox
        Left = 0
        Top = 105
        Width = 433
        Height = 21
        Align = alTop
        Caption = 'Show offline contacts'
        TabOrder = 5
      end
    end
    object pnlManageBtn: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 201
      Width = 430
      Height = 24
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      TabOrder = 1
      TabStop = True
      AutoHide = True
      ExplicitTop = 203
      object btnManageBlocked: TTntButton
        Left = 24
        Top = 0
        Width = 202
        Height = 24
        Caption = 'Manage Blocked Contacts...'
        TabOrder = 0
        OnClick = btnManageBlockedClick
      end
    end
    object grpAdvanced: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 234
      Width = 433
      Height = 102
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      TabOrder = 3
      TabStop = True
      AutoHide = True
      Caption = 'Advanced Contact List Preferences'
      ExplicitTop = 236
      ExplicitHeight = 103
      object chkNestedGrps: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 78
        Width = 430
        Height = 21
        Margins.Left = 0
        Align = alTop
        Caption = 'Use nested groups'
        TabOrder = 1
        ExplicitTop = 79
      end
      object pnlStatusColor: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 430
        Height = 22
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 2
        TabStop = True
        AutoHide = True
        DesignSize = (
          430
          22)
        object lblStatusColor: TTntLabel
          Left = 0
          Top = 3
          Width = 118
          Height = 16
          Caption = 'Contact status color:'
        end
        object cboStatusColor: TColorBox
          Left = 191
          Top = 0
          Width = 203
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
        Top = 48
        Width = 430
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 3
        TabStop = True
        AutoHide = True
        DesignSize = (
          430
          24)
        object lblDNProfileMap: TTntLabel
          Left = 0
          Top = 3
          Width = 155
          Height = 16
          Caption = 'Display name profile fields:'
        end
        object txtDNProfileMap: TTntEdit
          Left = 191
          Top = 0
          Width = 203
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
    end
    object gbDepricated: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 348
      Width = 433
      Height = 370
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoScroll = True
      TabOrder = 2
      TabStop = True
      AutoHide = True
      Caption = 'Depricated preferences (may not be supported)'
      ExplicitTop = 351
      object chkSort: TTntCheckBox
        Left = 0
        Top = 17
        Width = 433
        Height = 21
        Align = alTop
        Caption = 'Sort Contacts by their availability'
        TabOrder = 1
      end
      object chkOfflineGrp: TTntCheckBox
        Left = 0
        Top = 38
        Width = 433
        Height = 20
        Align = alTop
        Caption = 'Show offline contacts in an Offline group'
        TabOrder = 2
      end
      object pnlMinStatus: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 166
        Width = 430
        Height = 35
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 3
        TabStop = True
        AutoHide = True
        object lblFilter: TTntLabel
          Left = 0
          Top = 3
          Width = 103
          Height = 32
          Caption = '"Online" minimum status: '
          WordWrap = True
        end
        object cboVisible: TTntComboBox
          Left = 191
          Top = 0
          Width = 206
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
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
        Top = 207
        Width = 430
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 4
        TabStop = True
        AutoHide = True
        object lblGatewayGrp: TTntLabel
          Left = 0
          Top = 3
          Width = 91
          Height = 16
          Caption = 'Gateway group:'
        end
        object txtGatewayGrp: TTntComboBox
          Left = 191
          Top = 0
          Width = 206
          Height = 24
          ItemHeight = 16
          TabOrder = 0
        end
      end
      object chkPresErrors: TTntCheckBox
        Left = 0
        Top = 100
        Width = 433
        Height = 21
        Align = alTop
        Caption = 'Detect contacts which are unreachable or no longer exist'
        TabOrder = 5
        Visible = False
      end
      object chkShowPending: TTntCheckBox
        Left = 0
        Top = 79
        Width = 433
        Height = 21
        Align = alTop
        Caption = 'Show contacts I have asked to add as "Pending"'
        TabOrder = 6
      end
      object chkShowUnsubs: TTntCheckBox
        Left = 0
        Top = 142
        Width = 433
        Height = 21
        Align = alTop
        Caption = 'Show contacts which I do not have a subscription to'
        TabOrder = 7
      end
      object chkRosterUnicode: TTntCheckBox
        Left = 0
        Top = 58
        Width = 433
        Height = 21
        Align = alTop
        Caption = 
          'Allow Unicode characters in the contact list (requires 2000, ME,' +
          ' XP).'
        TabOrder = 8
      end
      object chkRosterAvatars: TTntCheckBox
        Left = 0
        Top = 121
        Width = 433
        Height = 21
        Align = alTop
        Caption = 'Show Avatars in the contact list'
        TabOrder = 9
      end
      object pnlDblClickAction: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 237
        Width = 430
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 10
        TabStop = True
        AutoHide = True
        object lblDblClick: TTntLabel
          Left = 0
          Top = 3
          Width = 128
          Height = 16
          Caption = 'Default dblclick action:'
        end
        object cboDblClick: TTntComboBox
          Left = 191
          Top = 0
          Width = 206
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 0
          Items.Strings = (
            'A new one to one chat window'
            'An instant message window'
            'A new or existing chat window')
        end
      end
      object pnlGroupSeperator: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 267
        Width = 430
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 11
        TabStop = True
        AutoHide = True
        object lblGrpSeperator: TTntLabel
          Left = 0
          Top = 3
          Width = 140
          Height = 16
          Caption = 'Nested group seperator:'
        end
        object txtGrpSeperator: TTntEdit
          Left = 191
          Top = 0
          Width = 206
          Height = 24
          TabOrder = 0
        end
      end
      object pnlAlpha: TExBrandPanel
        Left = 0
        Top = 294
        Width = 433
        Height = 57
        Align = alTop
        AutoSize = True
        TabOrder = 12
        TabStop = True
        AutoHide = True
        object chkRosterAlpha: TTntCheckBox
          Left = 0
          Top = 0
          Width = 258
          Height = 20
          Caption = 'Use Alpha Blending'
          TabOrder = 1
          OnClick = chkRosterAlphaClick
        end
        object trkRosterAlpha: TTrackBar
          Left = 9
          Top = 30
          Width = 168
          Height = 22
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
          Left = 183
          Top = 26
          Width = 70
          Height = 31
          BevelOuter = bvNone
          Enabled = False
          ParentColor = True
          TabOrder = 0
          Text = '255'
          Min = 100
          Max = 255
          OnChange = txtRosterAlphaChange
          DesignSize = (
            70
            31)
        end
      end
    end
    object pnlDefaultNIck: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 33
      Width = 430
      Height = 24
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      TabOrder = 4
      TabStop = True
      AutoHide = True
      ExplicitTop = 34
      DesignSize = (
        430
        24)
      object lblDefaultNick: TTntLabel
        Left = 0
        Top = 3
        Width = 157
        Height = 16
        Margins.Left = 0
        Caption = 'Default nickname for chats:'
        FocusControl = txtDefaultNick
      end
      object txtDefaultNick: TTntEdit
        Left = 191
        Top = 0
        Width = 203
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
    end
    object pnlDefaultGroup: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 430
      Height = 24
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      TabOrder = 5
      TabStop = True
      AutoHide = True
      DesignSize = (
        430
        24)
      object lblDefaultGrp: TTntLabel
        Left = 0
        Top = 3
        Width = 184
        Height = 16
        AutoSize = False
        Caption = 'Default group for new contacts:'
        FocusControl = txtDefaultGrp
      end
      object txtDefaultGrp: TTntComboBox
        Left = 191
        Top = 0
        Width = 206
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 16
        TabOrder = 0
      end
    end
  end
end
