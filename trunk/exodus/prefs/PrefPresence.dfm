inherited frmPrefPresence: TfrmPrefPresence
  Left = 229
  Top = 143
  Caption = 'frmPrefPresence'
  ClientHeight = 392
  ClientWidth = 329
  OldCreateOrder = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lstCustomPres: TTntListBox
    Left = 0
    Top = 117
    Width = 329
    Height = 102
    Align = alTop
    ItemHeight = 13
    TabOrder = 0
    OnClick = lstCustomPresClick
  end
  object pnlCustomPresButtons: TPanel
    Left = 0
    Top = 219
    Width = 329
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
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
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 253
    Width = 329
    Height = 119
    Align = alTop
    Caption = 'Properties'
    TabOrder = 2
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
      Left = 177
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
      Left = 48
      Top = 20
      Width = 225
      Height = 21
      TabOrder = 0
      OnChange = txtCPTitleChange
    end
    object txtCPStatus: TTntEdit
      Left = 48
      Top = 44
      Width = 225
      Height = 21
      TabOrder = 1
      OnChange = txtCPTitleChange
    end
    object cboCPType: TTntComboBox
      Left = 48
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
      Left = 218
      Top = 69
      Width = 39
      Height = 21
      TabOrder = 3
      Text = '0'
      OnChange = txtCPTitleChange
    end
    object spnPriority: TTntUpDown
      Left = 257
      Top = 69
      Width = 16
      Height = 21
      Associate = txtCPPriority
      Max = 1000
      TabOrder = 4
    end
    object txtCPHotkey: THotKey
      Left = 48
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
    Top = 24
    Width = 329
    Height = 93
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Label8: TTntLabel
      Left = 5
      Top = 28
      Width = 126
      Height = 13
      Caption = 'Presence tracking in chats'
    end
    object Label1: TTntLabel
      Left = 0
      Top = 75
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
      Top = 44
      Width = 207
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Items.WideStrings = (
        'Track all presence changes'
        'Show only last presence change'
        'Don'#39't show presence changes')
    end
  end
  object StaticText4: TTntPanel
    Left = 0
    Top = 0
    Width = 329
    Height = 24
    Align = alTop
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 4
    object TntLabel1: TTntLabel
      Left = 1
      Top = 1
      Width = 327
      Height = 22
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 'Presence Options'
      Color = clHighlight
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
  end
end
