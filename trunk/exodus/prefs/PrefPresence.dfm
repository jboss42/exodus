inherited frmPrefPresence: TfrmPrefPresence
  Left = 253
  Top = 148
  Caption = 'frmPrefPresence'
  ClientHeight = 433
  ClientWidth = 349
  OldCreateOrder = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 349
    Caption = 'Presence Options'
    TabOrder = 4
  end
  object lstCustomPres: TTntListBox
    Left = 0
    Top = 147
    Width = 349
    Height = 102
    Align = alTop
    ItemHeight = 13
    TabOrder = 1
    OnClick = lstCustomPresClick
  end
  object pnlCustomPresButtons: TPanel
    Left = 0
    Top = 249
    Width = 349
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object btnCustomPresAdd: TTntButton
      Left = 4
      Top = 4
      Width = 60
      Height = 25
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnCustomPresAddClick
    end
    object btnCustomPresRemove: TTntButton
      Left = 68
      Top = 4
      Width = 60
      Height = 25
      Caption = 'Remove'
      TabOrder = 1
      OnClick = btnCustomPresRemoveClick
    end
    object btnCustomPresClear: TTntButton
      Left = 132
      Top = 4
      Width = 60
      Height = 25
      Caption = 'Clear'
      TabOrder = 2
      OnClick = btnCustomPresClearClick
    end
    object btnDefaults: TTntButton
      Left = 196
      Top = 4
      Width = 60
      Height = 25
      Caption = 'Defaults'
      TabOrder = 3
      OnClick = btnDefaultsClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 283
    Width = 349
    Height = 119
    Align = alTop
    Caption = 'Properties'
    TabOrder = 3
    object Label11: TTntLabel
      Left = 6
      Top = 23
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object Label12: TTntLabel
      Left = 6
      Top = 47
      Width = 33
      Height = 13
      Caption = 'Status:'
    end
    object Label13: TTntLabel
      Left = 5
      Top = 71
      Width = 27
      Height = 13
      Caption = 'Type:'
    end
    object Label14: TTntLabel
      Left = 217
      Top = 73
      Width = 34
      Height = 13
      Caption = 'Priority:'
    end
    object lblHotkey: TTntLabel
      Left = 5
      Top = 94
      Width = 38
      Height = 13
      Caption = 'HotKey:'
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
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = txtCPTitleChange
      Items.WideStrings = (
        'Chat'
        'Available'
        'Away'
        'Ext. Away'
        'Do Not Disturb')
    end
    object txtCPPriority: TTntEdit
      Left = 258
      Top = 69
      Width = 39
      Height = 21
      Hint = 'Priority of -1 uses current priority.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '0'
      OnChange = txtCPTitleChange
    end
    object spnPriority: TTntUpDown
      Left = 297
      Top = 69
      Width = 16
      Height = 21
      Hint = 'Priority of -1 uses current priority.'
      Associate = txtCPPriority
      Min = -1
      Max = 1000
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object txtCPHotkey: THotKey
      Left = 88
      Top = 92
      Width = 97
      Height = 19
      HotKey = 32833
      TabOrder = 5
      OnChange = txtCPTitleChange
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 349
    Height = 121
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label8: TTntLabel
      Left = 5
      Top = 52
      Width = 217
      Height = 13
      Caption = 'Presence tracking in chat windows and rooms'
    end
    object Label1: TTntLabel
      Left = 0
      Top = 99
      Width = 118
      Height = 13
      Caption = 'Custom Presence Entries'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object chkPresenceSync: TTntCheckBox
      Left = 4
      Top = 4
      Width = 273
      Height = 17
      Caption = 'Synchronize presence of multiple copies of Exodus'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object cboPresTracking: TTntComboBox
      Left = 15
      Top = 68
      Width = 258
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Items.WideStrings = (
        'Track all presence changes'
        'Show only last presence change'
        'Don'#39't show any presence changes')
    end
    object chkClientCaps: TTntCheckBox
      Left = 4
      Top = 24
      Width = 273
      Height = 17
      Caption = 'Send client capabilities in presence.'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
end
