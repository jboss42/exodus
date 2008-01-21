inherited frmPrefPresence: TfrmPrefPresence
  AlignWithMargins = True
  Left = 367
  Top = 167
  Margins.Left = 0
  Caption = 'd'
  ClientHeight = 517
  ClientWidth = 495
  OldCreateOrder = True
  OnDestroy = FormDestroy
  ExplicitWidth = 507
  ExplicitHeight = 529
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 495
    ExplicitWidth = 495
    inherited lblHeader: TTntLabel
      Width = 164
      Caption = 'Presence Preferences'
      ExplicitWidth = 164
    end
  end
  object ExBrandPanel1: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 30
    Width = 492
    Height = 72
    Margins.Left = 0
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    TabOrder = 1
    TabStop = True
    AutoHide = False
    object chkClientCaps: TTntCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 489
      Height = 21
      Margins.Left = 0
      Margins.Bottom = 0
      Align = alTop
      Caption = 'S&end client capabilities in presence'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chkRoomJoins: TTntCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 27
      Width = 489
      Height = 21
      Margins.Left = 0
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Show enter and leave messages in conference room &windows.'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chkPresenceSync: TTntCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 51
      Width = 489
      Height = 21
      Margins.Left = 0
      Margins.Bottom = 0
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
    Top = 105
    Width = 492
    Height = 77
    Margins.Left = 0
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    TabOrder = 2
    TabStop = True
    AutoHide = True
    Caption = 'Presence tracking in chat windows:'
    object rbAllPres: TTntRadioButton
      AlignWithMargins = True
      Left = 3
      Top = 20
      Width = 486
      Height = 17
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Trac&k all presence changes'
      TabOrder = 1
    end
    object rbLastPres: TTntRadioButton
      AlignWithMargins = True
      Left = 3
      Top = 40
      Width = 486
      Height = 17
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Show only &last presence change'
      TabOrder = 2
    end
    object rbNoPres: TTntRadioButton
      AlignWithMargins = True
      Left = 3
      Top = 60
      Width = 486
      Height = 17
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Do &not show any presence changes'
      TabOrder = 3
    end
  end
  object ExGroupBox2: TExGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 185
    Width = 492
    Height = 300
    Margins.Left = 0
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    TabOrder = 3
    TabStop = True
    AutoHide = True
    Caption = 'Custom presence entries:'
    object lstCustomPres: TTntListBox
      AlignWithMargins = True
      Left = 0
      Top = 21
      Width = 385
      Height = 122
      Margins.Left = 0
      Margins.Bottom = 0
      ItemHeight = 16
      TabOrder = 1
      OnClick = lstCustomPresClick
    end
    object btnCustomPresAdd: TTntButton
      Left = 391
      Top = 21
      Width = 87
      Height = 26
      Caption = '&Add'
      TabOrder = 2
      OnClick = btnCustomPresAddClick
    end
    object btnCustomPresRemove: TTntButton
      Left = 391
      Top = 53
      Width = 87
      Height = 26
      Caption = '&Remove'
      TabOrder = 3
      OnClick = btnCustomPresRemoveClick
    end
    object btnCustomPresClear: TTntButton
      Left = 391
      Top = 85
      Width = 87
      Height = 26
      Caption = '&Clear All'
      TabOrder = 4
      OnClick = btnCustomPresClearClick
    end
    object btnDefaults: TTntButton
      Left = 391
      Top = 117
      Width = 87
      Height = 26
      Caption = '&Defaults'
      TabOrder = 5
      OnClick = btnDefaultsClick
    end
    object pnlProperties: TExBrandPanel
      AlignWithMargins = True
      Left = 6
      Top = 155
      Width = 332
      Height = 142
      Margins.Left = 6
      AutoSize = True
      TabOrder = 6
      TabStop = True
      AutoHide = False
      object Label11: TTntLabel
        Left = 0
        Top = 3
        Width = 38
        Height = 16
        Caption = '&Name:'
        FocusControl = txtCPTitle
        Transparent = False
      end
      object Label12: TTntLabel
        Left = 0
        Top = 33
        Width = 41
        Height = 16
        Caption = '&Status:'
        FocusControl = txtCPStatus
        Transparent = False
      end
      object Label13: TTntLabel
        Left = 0
        Top = 63
        Width = 33
        Height = 16
        Caption = '&Type:'
        FocusControl = cboCPType
        Transparent = False
      end
      object Label14: TTntLabel
        Left = 0
        Top = 97
        Width = 45
        Height = 16
        Caption = '&Priority:'
        FocusControl = txtCPPriority
        Transparent = False
      end
      object lblHotkey: TTntLabel
        Left = 0
        Top = 122
        Width = 44
        Height = 16
        Caption = '&HotKey:'
        FocusControl = txtCPHotkey
        Transparent = False
      end
      object txtCPTitle: TTntEdit
        Left = 52
        Top = 0
        Width = 277
        Height = 24
        TabOrder = 0
        OnChange = txtCPTitleChange
      end
      object txtCPStatus: TTntEdit
        Left = 52
        Top = 30
        Width = 277
        Height = 24
        TabOrder = 1
        OnChange = txtCPTitleChange
      end
      object cboCPType: TTntComboBox
        Left = 52
        Top = 60
        Width = 280
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 2
        OnChange = txtCPTitleChange
        Items.Strings = (
          'Free to Chat'
          'Available'
          'Away'
          'Xtended Away'
          'Do Not Disturb')
      end
      object txtCPPriority: TExNumericEdit
        Left = 52
        Top = 90
        Width = 91
        Height = 31
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
          91
          31)
      end
      object txtCPHotkey: THotKey
        Left = 52
        Top = 118
        Width = 120
        Height = 24
        HotKey = 32833
        TabOrder = 4
        OnChange = txtCPTitleChange
      end
    end
  end
end
