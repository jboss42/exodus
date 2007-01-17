inherited frmPrefPresence: TfrmPrefPresence
  Left = 367
  Top = 167
  Caption = 'frmPrefPresence'
  ClientHeight = 433
  ClientWidth = 349
  OldCreateOrder = True
  OnDestroy = FormDestroy
  ExplicitWidth = 361
  ExplicitHeight = 445
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 349
    Caption = 'Presence Options'
    TabOrder = 4
    ExplicitWidth = 349
  end
  object lstCustomPres: TTntListBox
    Left = 0
    Top = 145
    Width = 349
    Height = 102
    Align = alTop
    ItemHeight = 13
    TabOrder = 1
    OnClick = lstCustomPresClick
  end
  object pnlCustomPresButtons: TPanel
    Left = 0
    Top = 247
    Width = 349
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object btnCustomPresAdd: TTntButton
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnCustomPresAddClick
    end
    object btnCustomPresRemove: TTntButton
      Left = 84
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Remove'
      TabOrder = 1
      OnClick = btnCustomPresRemoveClick
    end
    object btnCustomPresClear: TTntButton
      Left = 164
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 2
      OnClick = btnCustomPresClearClick
    end
    object btnDefaults: TTntButton
      Left = 244
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Defaults'
      TabOrder = 3
      OnClick = btnDefaultsClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 349
    Height = 119
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblPresTracking: TTntLabel
      Left = 5
      Top = 59
      Width = 165
      Height = 13
      Caption = 'Presence tracking in chat windows'
    end
    object Label1: TTntLabel
      Left = 0
      Top = 102
      Width = 118
      Height = 13
      Caption = 'Custom Presence Entries'
    end
    object chkPresenceSync: TTntCheckBox
      Left = 4
      Top = 4
      Width = 273
      Height = 17
      Caption = 'Synchronize presence across multiple instances'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object cboPresTracking: TTntComboBox
      Left = 15
      Top = 75
      Width = 306
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'Track all presence changes'
        'Show only last presence change'
        'Don'#39't show any presence changes')
    end
    object chkClientCaps: TTntCheckBox
      Left = 4
      Top = 21
      Width = 273
      Height = 17
      Caption = 'Send client capabilities in presence.'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chkRoomJoins: TTntCheckBox
      Left = 4
      Top = 39
      Width = 273
      Height = 17
      Caption = 'Show enter and leave messages in conference room windows.'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object GroupBox1: TTntGroupBox
    Left = 0
    Top = 281
    Width = 349
    Height = 147
    Align = alTop
    Caption = 'Properties'
    TabOrder = 3
    object Label11: TTntLabel
      Left = 6
      Top = 23
      Width = 31
      Height = 13
      Caption = 'Name:'
      Transparent = False
    end
    object Label12: TTntLabel
      Left = 6
      Top = 47
      Width = 33
      Height = 13
      Caption = 'Status:'
      Transparent = False
    end
    object Label13: TTntLabel
      Left = 5
      Top = 71
      Width = 27
      Height = 13
      Caption = 'Type:'
      Transparent = False
    end
    object Label14: TTntLabel
      Left = 6
      Top = 97
      Width = 34
      Height = 13
      Caption = 'Priority:'
      Transparent = False
    end
    object lblHotkey: TTntLabel
      Left = 5
      Top = 120
      Width = 38
      Height = 13
      Caption = 'HotKey:'
      Transparent = False
    end
    object txtCPTitle: TTntEdit
      Left = 88
      Top = 20
      Width = 225
      Height = 21
      TabOrder = 0
      OnChange = txtCPTitleChange
    end
    object txtCPStatus: TTntEdit
      Left = 88
      Top = 44
      Width = 225
      Height = 21
      TabOrder = 1
      OnChange = txtCPTitleChange
    end
    object cboCPType: TTntComboBox
      Left = 88
      Top = 68
      Width = 227
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
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
      Left = 88
      Top = 93
      Width = 74
      Height = 25
      Hint = 'Priority of -1 uses current priority.'
      BevelOuter = bvNone
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '0'
      Min = -128
      Max = 127
      OnChange = txtCPTitleChange
      DesignSize = (
        74
        25)
    end
    object txtCPHotkey: THotKey
      Left = 88
      Top = 118
      Width = 97
      Height = 19
      HotKey = 32833
      TabOrder = 5
      OnChange = txtCPTitleChange
    end
  end
end
