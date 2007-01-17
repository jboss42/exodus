inherited frmPrefPlugins: TfrmPrefPlugins
  Left = 232
  Top = 142
  Caption = 'frmPrefPlugins'
  ClientHeight = 372
  ClientWidth = 353
  OldCreateOrder = True
  ExplicitWidth = 365
  ExplicitHeight = 384
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TTntLabel [0]
    Left = 0
    Top = 241
    Width = 191
    Height = 13
    Caption = 'Plugin Directory (automatically scanned):'
  end
  object lblPluginScan: TTntLabel [1]
    Left = 0
    Top = 287
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
    ExplicitWidth = 353
  end
  object btnAddPlugin: TTntButton
    Left = 116
    Top = 205
    Width = 75
    Height = 25
    Caption = 'Add'
    Enabled = False
    TabOrder = 1
    Visible = False
  end
  object btnConfigPlugin: TTntButton
    Left = 0
    Top = 205
    Width = 75
    Height = 25
    Caption = 'Configure'
    Enabled = False
    TabOrder = 2
    OnClick = btnConfigPluginClick
  end
  object btnRemovePlugin: TTntButton
    Left = 203
    Top = 205
    Width = 75
    Height = 25
    Caption = 'Remove'
    Enabled = False
    TabOrder = 3
    Visible = False
  end
  object txtPluginDir: TTntEdit
    Left = 0
    Top = 260
    Width = 265
    Height = 21
    TabOrder = 4
  end
  object btnBrowsePluginPath: TTntButton
    Left = 271
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
    OnSelectItem = lstPluginsSelectItem
  end
end
