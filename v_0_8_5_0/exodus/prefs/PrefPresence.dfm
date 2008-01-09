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
  object lstCustomPres: TListBox
    Left = 0
    Top = 113
    Width = 329
    Height = 102
    Align = alTop
    ItemHeight = 13
    TabOrder = 0
    OnClick = lstCustomPresClick
  end
  object StaticText10: TStaticText
    Left = 0
    Top = 0
    Width = 329
    Height = 20
    Align = alTop
    Alignment = taCenter
    Caption = 'Presence Options'
    Color = clHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clCaptionText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    Transparent = False
  end
  object pnlCustomPresButtons: TPanel
    Left = 0
    Top = 215
    Width = 329
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object btnCustomPresAdd: TButton
      Left = 4
      Top = 4
      Width = 60
      Height = 25
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnCustomPresAddClick
    end
    object btnCustomPresRemove: TButton
      Left = 68
      Top = 4
      Width = 60
      Height = 25
      Caption = 'Remove'
      TabOrder = 1
      OnClick = btnCustomPresRemoveClick
    end
    object btnCustomPresClear: TButton
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
    Top = 249
    Width = 329
    Height = 119
    Align = alTop
    Caption = 'Properties'
    TabOrder = 3
    object Label11: TLabel
      Left = 6
      Top = 23
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object Label12: TLabel
      Left = 6
      Top = 47
      Width = 33
      Height = 13
      Caption = 'Status:'
    end
    object Label13: TLabel
      Left = 5
      Top = 71
      Width = 27
      Height = 13
      Caption = 'Type:'
    end
    object Label14: TLabel
      Left = 177
      Top = 73
      Width = 34
      Height = 13
      Caption = 'Priority:'
    end
    object lblHotkey: TLabel
      Left = 5
      Top = 94
      Width = 38
      Height = 13
      Caption = 'HotKey:'
    end
    object txtCPTitle: TEdit
      Left = 48
      Top = 20
      Width = 225
      Height = 21
      TabOrder = 0
      OnChange = txtCPTitleChange
    end
    object txtCPStatus: TEdit
      Left = 48
      Top = 44
      Width = 225
      Height = 21
      TabOrder = 1
      OnChange = txtCPTitleChange
    end
    object cboCPType: TComboBox
      Left = 48
      Top = 68
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = txtCPTitleChange
      Items.Strings = (
        'Chat'
        'Available'
        'Away'
        'Ext. Away'
        'Do Not Disturb')
    end
    object txtCPPriority: TEdit
      Left = 218
      Top = 69
      Width = 39
      Height = 21
      TabOrder = 3
      Text = '0'
      OnChange = txtCPTitleChange
    end
    object spnPriority: TUpDown
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
    Top = 20
    Width = 329
    Height = 93
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object Label8: TLabel
      Left = 5
      Top = 28
      Width = 126
      Height = 13
      Caption = 'Presence tracking in chats'
    end
    object Label1: TLabel
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
    object chkPresenceSync: TCheckBox
      Left = 4
      Top = 4
      Width = 273
      Height = 17
      Caption = 'Synchronize presence of multiple copies of Exodus'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object cboPresTracking: TComboBox
      Left = 15
      Top = 44
      Width = 207
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'Track all presence changes'
        'Show only last presence change'
        'Don'#39't show presence changes')
    end
  end
end
