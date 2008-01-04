inherited frmPrefRoster: TfrmPrefRoster
  Left = 254
  Top = 162
  Caption = 'frmPrefRoster'
  ClientHeight = 717
  ClientWidth = 518
  OldCreateOrder = True
  ExplicitWidth = 530
  ExplicitHeight = 729
  PixelsPerInch = 120
  TextHeight = 17
  inherited pnlHeader: TTntPanel
    Width = 518
    ExplicitWidth = 518
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
    Width = 460
    Height = 678
    Margins.Left = 0
    Margins.Top = 6
    Margins.Right = 0
    Margins.Bottom = 6
    Align = alLeft
    AutoSize = True
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    TabStop = True
    AutoHide = True
    ExplicitLeft = 1
    ExplicitHeight = 896
    object pnlRosterPrefs: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 66
      Width = 460
      Height = 134
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      Color = 13681583
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      TabStop = True
      AutoHide = True
      ExplicitTop = 78
      object chkInlineStatus: TTntCheckBox
        Left = 0
        Top = 0
        Width = 460
        Height = 22
        Align = alTop
        Caption = 'Show contact status'
        TabOrder = 0
      end
      object chkUseProfileDN: TTntCheckBox
        Left = 0
        Top = 22
        Width = 460
        Height = 23
        Align = alTop
        Caption = 'Get display name from contact profile'
        TabOrder = 1
      end
      object chkCollapsed: TTntCheckBox
        Left = 0
        Top = 45
        Width = 460
        Height = 22
        Align = alTop
        Caption = 'Collapse all contact groups initially'
        TabOrder = 2
      end
      object chkHideBlocked: TTntCheckBox
        Left = 0
        Top = 67
        Width = 460
        Height = 23
        Align = alTop
        Caption = 'Hide blocked contacts '
        TabOrder = 3
      end
      object chkGroupCounts: TTntCheckBox
        Left = 0
        Top = 90
        Width = 460
        Height = 22
        Align = alTop
        Caption = 'Show group members online status at group level (e.g., 5/10)'
        TabOrder = 4
      end
      object chkOnlineOnly: TTntCheckBox
        Left = 0
        Top = 112
        Width = 460
        Height = 22
        Align = alTop
        Caption = 'Show offline contacts'
        TabOrder = 5
      end
    end
    object pnlManageBtn: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 209
      Width = 457
      Height = 25
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      Color = 13681583
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      TabStop = True
      AutoHide = True
      ExplicitTop = 224
      ExplicitWidth = 460
      object btnManageBlocked: TTntButton
        Left = 26
        Top = 0
        Width = 214
        Height = 25
        Caption = 'Manage Blocked Contacts...'
        TabOrder = 0
      end
    end
    object grpAdvanced: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 240
      Width = 457
      Height = 103
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      Color = 13681583
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 3
      TabStop = True
      AutoHide = True
      Caption = 'Advanced Contact List Preferences'
      BoxStyle = gbsLabel
      Checked = False
      ExplicitTop = 243
      ExplicitWidth = 460
      object chkNestedGrps: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 78
        Width = 454
        Height = 22
        Margins.Left = 0
        Align = alTop
        Caption = 'Use nested groups'
        TabOrder = 1
        ExplicitWidth = 457
      end
      object pnlStatusColor: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 454
        Height = 22
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 2
        TabStop = True
        AutoHide = True
        ExplicitTop = 408
        ExplicitWidth = 403
        DesignSize = (
          454
          22)
        object lblStatusColor: TTntLabel
          Left = 0
          Top = 3
          Width = 118
          Height = 16
          Caption = 'Contact status color:'
        end
        object cboStatusColor: TColorBox
          Left = 203
          Top = 0
          Width = 216
          Height = 22
          DefaultColorColor = clBlue
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 12
          ItemHeight = 16
          TabOrder = 0
          ExplicitWidth = 219
        end
      end
      object pnlDNFields: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 48
        Width = 454
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 3
        TabStop = True
        AutoHide = True
        ExplicitLeft = 88
        ExplicitTop = 419
        ExplicitWidth = 518
        DesignSize = (
          454
          24)
        object lblDNProfileMap: TTntLabel
          Left = 0
          Top = 3
          Width = 155
          Height = 16
          Caption = 'Display name profile fields:'
        end
        object txtDNProfileMap: TTntEdit
          Left = 203
          Top = 0
          Width = 216
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          ExplicitWidth = 219
        end
      end
    end
    object gbDepricated: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 349
      Width = 457
      Height = 311
      Margins.Left = 0
      Align = alTop
      AutoScroll = True
      Color = 13681583
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 2
      TabStop = True
      AutoHide = True
      Caption = 'Depricated preferences (may not be supported)'
      BoxStyle = gbsLabel
      Checked = False
      ExplicitTop = 376
      ExplicitWidth = 460
      object chkSort: TTntCheckBox
        Left = 0
        Top = 17
        Width = 457
        Height = 22
        Align = alTop
        Caption = 'Sort Contacts by their availability'
        TabOrder = 1
        ExplicitWidth = 460
      end
      object chkOfflineGrp: TTntCheckBox
        Left = 0
        Top = 39
        Width = 457
        Height = 22
        Align = alTop
        Caption = 'Show offline contacts in an Offline group'
        TabOrder = 2
        ExplicitWidth = 460
      end
      object pnlMinStatus: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 175
        Width = 454
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 3
        TabStop = True
        AutoHide = True
        ExplicitTop = 178
        ExplicitWidth = 460
        object lblFilter: TTntLabel
          Left = 0
          Top = 3
          Width = 150
          Height = 16
          Caption = '"Online" minimum status: '
          WordWrap = True
        end
        object cboVisible: TTntComboBox
          Left = 203
          Top = 0
          Width = 219
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
        Top = 205
        Width = 454
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 4
        TabStop = True
        AutoHide = True
        ExplicitTop = 214
        ExplicitWidth = 460
        object lblGatewayGrp: TTntLabel
          Left = 0
          Top = 3
          Width = 91
          Height = 16
          Caption = 'Gateway group:'
        end
        object txtGatewayGrp: TTntComboBox
          Left = 203
          Top = 0
          Width = 219
          Height = 24
          ItemHeight = 16
          TabOrder = 0
        end
      end
      object chkPresErrors: TTntCheckBox
        Left = 0
        Top = 105
        Width = 457
        Height = 22
        Align = alTop
        Caption = 'Detect contacts which are unreachable or no longer exist'
        TabOrder = 5
        Visible = False
        ExplicitWidth = 460
      end
      object chkShowPending: TTntCheckBox
        Left = 0
        Top = 83
        Width = 457
        Height = 22
        Align = alTop
        Caption = 'Show contacts I have asked to add as "Pending"'
        TabOrder = 6
        ExplicitWidth = 460
      end
      object chkShowUnsubs: TTntCheckBox
        Left = 0
        Top = 150
        Width = 457
        Height = 22
        Align = alTop
        Caption = 'Show contacts which I do not have a subscription to'
        TabOrder = 7
        ExplicitWidth = 460
      end
      object chkRosterUnicode: TTntCheckBox
        Left = 0
        Top = 61
        Width = 457
        Height = 22
        Align = alTop
        Caption = 
          'Allow Unicode characters in the contact list (requires 2000, ME,' +
          ' XP).'
        TabOrder = 8
        ExplicitWidth = 460
      end
      object chkRosterAvatars: TTntCheckBox
        Left = 0
        Top = 127
        Width = 457
        Height = 23
        Align = alTop
        Caption = 'Show Avatars in the contact list'
        TabOrder = 9
        ExplicitWidth = 460
      end
      object pnlDblClickAction: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 235
        Width = 454
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 10
        TabStop = True
        AutoHide = True
        ExplicitTop = 250
        ExplicitWidth = 460
        object lblDblClick: TTntLabel
          Left = 0
          Top = 3
          Width = 128
          Height = 16
          Caption = 'Default dblclick action:'
        end
        object cboDblClick: TTntComboBox
          Left = 203
          Top = 0
          Width = 219
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
        Top = 265
        Width = 454
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 11
        TabStop = True
        AutoHide = True
        ExplicitTop = 283
        ExplicitWidth = 457
        object lblGrpSeperator: TTntLabel
          Left = 0
          Top = 3
          Width = 140
          Height = 16
          Caption = 'Nested group seperator:'
        end
        object txtGrpSeperator: TTntEdit
          Left = 203
          Top = 0
          Width = 219
          Height = 24
          TabOrder = 0
        end
      end
    end
    object pnlDefaultNIck: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 33
      Width = 457
      Height = 24
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      Color = 13681583
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 4
      TabStop = True
      AutoHide = True
      ExplicitTop = 3
      ExplicitWidth = 460
      DesignSize = (
        457
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
        Left = 203
        Top = 0
        Width = 216
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        ExplicitWidth = 219
      end
    end
    object pnlDefaultGroup: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 457
      Height = 24
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      Color = 13681583
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 5
      TabStop = True
      AutoHide = True
      ExplicitTop = 4
      ExplicitWidth = 460
      DesignSize = (
        457
        24)
      object lblDefaultGrp: TTntLabel
        Left = 0
        Top = 3
        Width = 196
        Height = 17
        AutoSize = False
        Caption = 'Default group for new contacts:'
        FocusControl = txtDefaultGrp
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object txtDefaultGrp: TTntComboBox
        Left = 203
        Top = 0
        Width = 219
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 16
        TabOrder = 0
      end
    end
  end
end
