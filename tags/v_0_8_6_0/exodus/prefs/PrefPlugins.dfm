inherited frmPrefPlugins: TfrmPrefPlugins
  Left = 232
  Top = 142
  Caption = 'frmPrefPlugins'
  ClientHeight = 372
  ClientWidth = 353
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TTntLabel
    Left = 6
    Top = 239
    Width = 191
    Height = 13
    Caption = 'Plugin Directory (automatically scanned):'
  end
  object lblPluginScan: TTntLabel
    Left = 16
    Top = 284
    Width = 155
    Height = 13
    Cursor = crHandPoint
    Caption = 'Re-Scan this directory for plugins'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblPluginScanClick
  end
  object btnAddPlugin: TTntButton
    Left = 6
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Add'
    Enabled = False
    TabOrder = 0
  end
  object btnConfigPlugin: TTntButton
    Left = 90
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Configure'
    Enabled = False
    TabOrder = 1
    OnClick = btnConfigPluginClick
  end
  object btnRemovePlugin: TTntButton
    Left = 174
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Remove'
    Enabled = False
    TabOrder = 2
  end
  object txtPluginDir: TTntEdit
    Left = 8
    Top = 260
    Width = 225
    Height = 21
    TabOrder = 3
  end
  object btnBrowsePluginPath: TTntButton
    Left = 239
    Top = 258
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 4
    OnClick = btnBrowsePluginPathClick
  end
  object lstPlugins: TTntListView
    Left = 0
    Top = 24
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
    TabOrder = 5
    ViewStyle = vsReport
  end
  object StaticText4: TTntPanel
    Left = 0
    Top = 0
    Width = 353
    Height = 24
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Application Plugins'
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 6
  end
end
