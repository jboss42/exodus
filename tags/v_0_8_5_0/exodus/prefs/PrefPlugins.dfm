inherited frmPrefPlugins: TfrmPrefPlugins
  Left = 232
  Top = 142
  Caption = 'frmPrefPlugins'
  ClientHeight = 372
  ClientWidth = 353
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 6
    Top = 239
    Width = 191
    Height = 13
    Caption = 'Plugin Directory (automatically scanned):'
  end
  object lblPluginScan: TLabel
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
  object StaticText12: TStaticText
    Left = 0
    Top = 0
    Width = 353
    Height = 20
    Align = alTop
    Alignment = taCenter
    Caption = 'Plugins'
    Color = clHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clCaptionText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    Transparent = False
  end
  object btnAddPlugin: TButton
    Left = 6
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Add'
    Enabled = False
    TabOrder = 1
  end
  object btnConfigPlugin: TButton
    Left = 90
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Configure'
    Enabled = False
    TabOrder = 2
    OnClick = btnConfigPluginClick
  end
  object btnRemovePlugin: TButton
    Left = 174
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Remove'
    Enabled = False
    TabOrder = 3
  end
  object txtPluginDir: TEdit
    Left = 8
    Top = 260
    Width = 225
    Height = 21
    TabOrder = 4
  end
  object btnBrowsePluginPath: TButton
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
    Top = 20
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
    TabOrder = 6
    ViewStyle = vsReport
  end
end
