inherited frmPrefEmote: TfrmPrefEmote
  Left = 263
  Top = 185
  Caption = 'frmPrefEmote'
  ClientHeight = 401
  ClientWidth = 449
  OldCreateOrder = True
  ExplicitWidth = 461
  ExplicitHeight = 413
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 449
    Caption = 'Emoticons'
    ExplicitWidth = 449
  end
  object pageEmotes: TTntPageControl
    Left = 0
    Top = 27
    Width = 449
    Height = 374
    ActivePage = TntTabSheet2
    Align = alClient
    TabOrder = 1
    object TntTabSheet1: TTntTabSheet
      Caption = 'Emoticon Packages'
      object pnlCustomPresButtons: TPanel
        Left = 0
        Top = 301
        Width = 441
        Height = 42
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object btnEmoteAdd: TTntButton
          Left = 5
          Top = 5
          Width = 92
          Height = 31
          Caption = 'Add'
          TabOrder = 0
          OnClick = btnEmoteAddClick
        end
        object btnEmoteRemove: TTntButton
          Left = 103
          Top = 5
          Width = 93
          Height = 31
          Caption = 'Remove'
          TabOrder = 1
          OnClick = btnEmoteRemoveClick
        end
        object btnEmoteClear: TTntButton
          Left = 202
          Top = 5
          Width = 92
          Height = 31
          Caption = 'Clear'
          TabOrder = 2
          OnClick = btnEmoteClearClick
        end
        object btnEmoteDefault: TTntButton
          Left = 302
          Top = 5
          Width = 92
          Height = 31
          Caption = 'Defaults'
          TabOrder = 3
          OnClick = btnEmoteDefaultClick
        end
      end
      object lstEmotes: TTntListBox
        Left = 0
        Top = 0
        Width = 441
        Height = 301
        Align = alClient
        ItemHeight = 16
        TabOrder = 1
      end
    end
    object TntTabSheet2: TTntTabSheet
      Caption = 'Custom Emoticons'
      object Panel2: TPanel
        Left = 0
        Top = 234
        Width = 441
        Height = 42
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object btnCustomEmoteAdd: TTntButton
          Left = 5
          Top = 5
          Width = 92
          Height = 31
          Caption = 'Add ...'
          TabOrder = 0
          OnClick = btnCustomEmoteAddClick
        end
        object btnCustomEmoteRemove: TTntButton
          Left = 202
          Top = 5
          Width = 92
          Height = 31
          Caption = 'Remove'
          Enabled = False
          TabOrder = 1
          OnClick = btnCustomEmoteRemoveClick
        end
        object btnCustomEmoteEdit: TTntButton
          Left = 103
          Top = 5
          Width = 93
          Height = 31
          Caption = 'Edit ...'
          Enabled = False
          TabOrder = 2
          OnClick = btnCustomEmoteEditClick
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 276
        Width = 441
        Height = 67
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object TntLabel3: TTntLabel
          Left = 2
          Top = 10
          Width = 235
          Height = 16
          Caption = 'Filename of custom emoticon definitions:'
        end
        object txtCustomEmoteFilename: TTntEdit
          Left = 20
          Top = 27
          Width = 306
          Height = 24
          TabOrder = 0
        end
        object btnCustomEmoteBrowse: TTntButton
          Left = 332
          Top = 25
          Width = 93
          Height = 30
          Caption = 'Browse'
          TabOrder = 1
          OnClick = btnCustomEmoteBrowseClick
        end
      end
      object lstCustomEmotes: TTntListView
        Left = 0
        Top = 0
        Width = 441
        Height = 234
        Align = alClient
        Columns = <>
        IconOptions.AutoArrange = True
        LargeImages = imagesCustom
        MultiSelect = True
        ReadOnly = True
        ShowWorkAreas = True
        TabOrder = 2
        OnAdvancedCustomDrawItem = lstCustomEmotesAdvancedCustomDrawItem
        OnDblClick = btnCustomEmoteEditClick
        OnSelectItem = lstCustomEmotesSelectItem
      end
    end
  end
  object EmoteOpen: TOpenDialog
    Filter = 'Resource Files|*.dll|All Files|*.*'
    Left = 224
    Top = 34
  end
  object XMLDialog1: TOpenDialog
    Filter = 'XML Files|*.xml|All Files|*.*'
    Left = 256
    Top = 34
  end
  object imagesCustom: TImageList
    BlendColor = clWindow
    BkColor = 15857655
    Height = 32
    Width = 32
    Left = 288
    Top = 34
  end
end
