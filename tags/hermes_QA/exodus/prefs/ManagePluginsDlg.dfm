inherited frmPrefPlugins: TfrmPrefPlugins
  Left = 232
  Top = 142
  BorderStyle = bsDialog
  Caption = 'Plugins'
  ClientHeight = 374
  ClientWidth = 436
  OldCreateOrder = True
  OnCreate = TntFormCreate
  ExplicitWidth = 442
  ExplicitHeight = 412
  PixelsPerInch = 120
  TextHeight = 16
  object Label6: TTntLabel
    Left = 3
    Top = 262
    Width = 239
    Height = 16
    Caption = 'Plug-in Directory (automatically scanned):'
  end
  object lblPluginScan: TTntLabel
    Left = 3
    Top = 318
    Width = 193
    Height = 16
    Cursor = crHandPoint
    Caption = 'Re-scan this directory for plug-ins'
    OnClick = lblPluginScanClick
  end
  object btnConfigPlugin: TTntButton
    Left = 3
    Top = 228
    Width = 75
    Height = 25
    Caption = 'Configure'
    Enabled = False
    TabOrder = 1
    OnClick = btnConfigPluginClick
  end
  object txtPluginDir: TTntEdit
    Left = 3
    Top = 286
    Width = 342
    Height = 24
    TabOrder = 2
  end
  object btnBrowsePluginPath: TTntButton
    Left = 353
    Top = 286
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 3
    OnClick = btnBrowsePluginPathClick
  end
  object lstPlugins: TTntListView
    AlignWithMargins = True
    Left = 3
    Top = 9
    Width = 430
    Height = 213
    Margins.Top = 9
    Align = alTop
    BevelWidth = 0
    Checkboxes = True
    Columns = <
      item
        Caption = 'Plugin'
        Width = 123
      end
      item
        Caption = 'Description'
        Width = 185
      end
      item
        Caption = 'Filename'
        Width = 98
      end>
    TabOrder = 0
    ViewStyle = vsReport
    OnSelectItem = lstPluginsSelectItem
  end
  object btnCancel: TTntButton
    Left = 353
    Top = 341
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object btnOK: TTntButton
    Left = 272
    Top = 341
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
    OnClick = btnOKClick
  end
end
