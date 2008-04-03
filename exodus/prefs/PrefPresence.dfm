inherited frmPrefPresence: TfrmPrefPresence
  Left = 367
  Top = 167
  Margins.Left = 0
  Caption = 'd'
  ClientHeight = 524
  ClientWidth = 518
  OldCreateOrder = True
  OnDestroy = FormDestroy
  ExplicitWidth = 530
  ExplicitHeight = 536
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 518
    ExplicitWidth = 518
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 69
      Height = 19
      Caption = 'Presence'
      ExplicitLeft = 7
      ExplicitWidth = 69
    end
  end
  object ExBrandPanel1: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 31
    Width = 515
    Height = 68
    Margins.Left = 0
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    AutoHide = False
    object chkClientCaps: TTntCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 512
      Height = 20
      Margins.Left = 0
      Margins.Top = 0
      Align = alTop
      Caption = 'S&end client capabilities in presence'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chkRoomJoins: TTntCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 23
      Width = 512
      Height = 20
      Margins.Left = 0
      Margins.Top = 0
      Align = alTop
      Caption = 'Show enter and leave messages in conference room &windows'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chkPresenceSync: TTntCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 46
      Width = 512
      Height = 19
      Margins.Left = 0
      Margins.Top = 0
      Align = alTop
      Caption = 'Synchronize presence across multiple instances'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object ExGroupBox1: TExGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 102
    Width = 515
    Height = 75
    Margins.Left = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'Presence tracking in chat windows'
    ParentColor = True
    TabOrder = 2
    AutoHide = True
    object rbAllPres: TTntRadioButton
      AlignWithMargins = True
      Left = 3
      Top = 18
      Width = 509
      Height = 16
      Margins.Top = 0
      Align = alTop
      Caption = 'Trac&k all presence changes'
      TabOrder = 1
    end
    object rbLastPres: TTntRadioButton
      AlignWithMargins = True
      Left = 3
      Top = 37
      Width = 509
      Height = 16
      Margins.Top = 0
      Align = alTop
      Caption = 'Show only &last presence change'
      TabOrder = 2
    end
    object rbNoPres: TTntRadioButton
      AlignWithMargins = True
      Left = 3
      Top = 56
      Width = 509
      Height = 16
      Margins.Top = 0
      Align = alTop
      Caption = 'Do &not show any presence changes'
      TabOrder = 3
    end
  end
  object ExGroupBox2: TExGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 183
    Width = 515
    Height = 274
    Margins.Left = 0
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'Custom presence entries'
    ParentColor = True
    TabOrder = 3
    AutoHide = True
    object lstCustomPres: TTntListBox
      AlignWithMargins = True
      Left = 0
      Top = 20
      Width = 356
      Height = 112
      Margins.Left = 0
      Margins.Bottom = 0
      ItemHeight = 16
      TabOrder = 1
      OnClick = lstCustomPresClick
    end
    object btnCustomPresAdd: TTntButton
      Left = 363
      Top = 20
      Width = 81
      Height = 23
      Caption = '&Add'
      TabOrder = 2
      OnClick = btnCustomPresAddClick
    end
    object btnCustomPresRemove: TTntButton
      Left = 363
      Top = 49
      Width = 81
      Height = 24
      Caption = '&Remove'
      TabOrder = 3
      OnClick = btnCustomPresRemoveClick
    end
    object btnCustomPresClear: TTntButton
      Left = 363
      Top = 79
      Width = 81
      Height = 23
      Caption = '&Clear All'
      TabOrder = 4
      OnClick = btnCustomPresClearClick
    end
    object btnDefaults: TTntButton
      Left = 363
      Top = 108
      Width = 81
      Height = 24
      Caption = '&Defaults'
      TabOrder = 5
      OnClick = btnDefaultsClick
    end
    object pnlProperties: TExBrandPanel
      AlignWithMargins = True
      Left = 6
      Top = 139
      Width = 347
      Height = 132
      Margins.Left = 6
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 6
      AutoHide = False
      object Label11: TTntLabel
        Left = 0
        Top = 2
        Width = 38
        Height = 16
        Margins.Left = 6
        Caption = '&Name:'
        FocusControl = txtCPTitle
        Transparent = False
      end
      object Label12: TTntLabel
        Left = 0
        Top = 31
        Width = 41
        Height = 16
        Margins.Left = 6
        Caption = '&Status:'
        FocusControl = txtCPStatus
        Transparent = False
      end
      object Label13: TTntLabel
        Left = 0
        Top = 58
        Width = 33
        Height = 16
        Margins.Left = 6
        Caption = '&Type:'
        FocusControl = cboCPType
        Transparent = False
      end
      object Label14: TTntLabel
        Left = 0
        Top = 90
        Width = 45
        Height = 16
        Margins.Left = 6
        Caption = '&Priority:'
        FocusControl = txtCPPriority
        Transparent = False
      end
      object lblHotkey: TTntLabel
        Left = 0
        Top = 113
        Width = 44
        Height = 16
        Margins.Left = 6
        Caption = '&HotKey:'
        FocusControl = txtCPHotkey
        Transparent = False
      end
      object txtCPTitle: TTntEdit
        Left = 89
        Top = 0
        Width = 256
        Height = 24
        TabOrder = 0
        OnChange = txtCPTitleChange
      end
      object txtCPStatus: TTntEdit
        Left = 89
        Top = 28
        Width = 256
        Height = 24
        TabOrder = 1
        OnChange = txtCPTitleChange
      end
      object cboCPType: TTntComboBox
        Left = 89
        Top = 55
        Width = 258
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 2
        OnChange = txtCPTitleChange
        Items.Strings = (
          'Free to Chat'
          'Available'
          'Away'
          'Extended Away'
          'Do Not Disturb')
      end
      object txtCPPriority: TExNumericEdit
        Left = 89
        Top = 84
        Width = 83
        Height = 37
        Hint = 'Priority of -1 uses current priority.'
        BevelOuter = bvNone
        ParentColor = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        TabStop = True
        Text = '0'
        Min = -128
        Max = 127
        OnChange = txtCPTitleChange
        DesignSize = (
          83
          37)
      end
      object txtCPHotkey: THotKey
        Left = 89
        Top = 110
        Width = 110
        Height = 22
        HotKey = 32833
        TabOrder = 4
        OnChange = txtCPTitleChange
      end
    end
  end
end
