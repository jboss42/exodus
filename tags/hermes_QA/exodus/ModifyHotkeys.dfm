inherited frmModifyHotkeys: TfrmModifyHotkeys
  BorderStyle = bsDialog
  Caption = 'Modify Hotkey'
  ClientHeight = 107
  ClientWidth = 277
  PixelsPerInch = 96
  TextHeight = 13
  object TntLabel1: TTntLabel
    Left = 8
    Top = 8
    Width = 38
    Height = 13
    Caption = 'Hotkey:'
  end
  object TntLabel2: TTntLabel
    Left = 8
    Top = 35
    Width = 46
    Height = 13
    Caption = 'Message:'
  end
  object btnOK: TTntButton
    Left = 111
    Top = 71
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TTntButton
    Left = 192
    Top = 71
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object txtHotkeyMessage: TTntEdit
    Left = 93
    Top = 32
    Width = 174
    Height = 21
    MaxLength = 80
    TabOrder = 1
    OnChange = txtHotkeyMessageChange
  end
  object cbhotkey: TTntComboBox
    Left = 93
    Top = 5
    Width = 60
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
  end
end
