inherited frmPrefPlugins: TfrmPrefPlugins
  Left = 232
  Top = 142
  Caption = 'frmPrefPlugins'
  ClientHeight = 372
  ClientWidth = 353
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TTntLabel [0]
    Left = 6
    Top = 239
    Width = 191
    Height = 13
    Caption = 'Plugin Directory (automatically scanned):'
  end
  object lblPluginScan: TTntLabel [1]
    Left = 16
    Top = 284
    Width = 155
    Height = 13
    Cursor = crHandPoint
    Caption = 'Re-Scan this directory for plugins'
    OnClick = lblPluginScanClick
  end
  inherited pnlHeader: TTntPanel
    Width = 353
    Caption = 'Application Plugins'
    TabOrder = 6
  end
  object btnAddPlugin: TTntButton
    Left = 6
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Add'
    Enabled = False
    TabOrder = 1
  end
  object btnConfigPlugin: TTntButton
    Left = 90
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Configure'
    Enabled = False
    TabOrder = 2
    OnClick = btnConfigPluginClick
  end
  object btnRemovePlugin: TTntButton
    Left = 174
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Remove'
    Enabled = False
    TabOrder = 3
  end
  object txtPluginDir: TTntEdit
    Left = 8
    Top = 260
    Width = 225
    Height = 21
    TabOrder = 4
  end
  object btnBrowsePluginPath: TTntButton
    Left = 239
    Top = 258
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 5
    OnClick = btnBrowsePluginPathClick
  end
  object lstPlugins: TTntListView
    Left = 0
    Top = 26
    Width = 353
    Height = 173
    Align = alTop
    BevelWidth = 0
    Checkboxes = True
    Columns = <
      item
        Caption = 'Plugin'
        Width = 100
      end
      item
        Caption = 'Description'
        Width = 150
      end
      item
        Caption = 'Filename'
        Width = 80
      end>
    TabOrder = 0
    ViewStyle = vsReport
  end
end
