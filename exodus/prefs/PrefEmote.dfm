inherited frmPrefEmote: TfrmPrefEmote
  Left = 263
  Top = 185
  Caption = 'frmPrefEmote'
  ClientHeight = 326
  ClientWidth = 308
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 308
    Caption = 'Emoticon Options'
  end
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 308
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object chkEmoticons: TTntCheckBox
      Left = 2
      Top = 5
      Width = 300
      Height = 17
      Caption = 'Auto detect Emoticons in messages'
      TabOrder = 0
    end
  end
  object pageEmotes: TTntPageControl
    Left = 0
    Top = 52
    Width = 308
    Height = 274
    ActivePage = TntTabSheet1
    Align = alClient
    TabOrder = 2
    object TntTabSheet1: TTntTabSheet
      Caption = 'Emoticon Packages'
      object pnlCustomPresButtons: TPanel
        Left = 0
        Top = 212
        Width = 300
        Height = 34
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object btnEmoteAdd: TTntButton
          Left = 4
          Top = 4
          Width = 60
          Height = 25
          Caption = 'Add'
          TabOrder = 0
          OnClick = btnEmoteAddClick
        end
        object btnEmoteRemove: TTntButton
          Left = 68
          Top = 4
          Width = 60
          Height = 25
          Caption = 'Remove'
          TabOrder = 1
          OnClick = btnEmoteRemoveClick
        end
        object btnEmoteClear: TTntButton
          Left = 132
          Top = 4
          Width = 60
          Height = 25
          Caption = 'Clear'
          TabOrder = 2
          OnClick = btnEmoteClearClick
        end
        object btnEmoteDefault: TTntButton
          Left = 196
          Top = 4
          Width = 60
          Height = 25
          Caption = 'Defaults'
          TabOrder = 3
          OnClick = btnEmoteDefaultClick
        end
      end
      object lstEmotes: TTntListBox
        Left = 0
        Top = 0
        Width = 300
        Height = 212
        Align = alClient
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object TntTabSheet2: TTntTabSheet
      Caption = 'Custom Emoticons'
      object lstCustomEmote: TTntListBox
        Left = 0
        Top = 0
        Width = 300
        Height = 97
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 0
        Top = 97
        Width = 300
        Height = 34
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object btnCustomEmoteAdd: TTntButton
          Left = 4
          Top = 4
          Width = 60
          Height = 25
          Caption = 'Add'
          TabOrder = 0
          OnClick = btnEmoteAddClick
        end
        object btnCustomEmoteRemove: TTntButton
          Left = 68
          Top = 4
          Width = 60
          Height = 25
          Caption = 'Remove'
          TabOrder = 1
          OnClick = btnEmoteRemoveClick
        end
        object btnCustomEmoteClear: TTntButton
          Left = 132
          Top = 4
          Width = 60
          Height = 25
          Caption = 'Clear'
          TabOrder = 2
          OnClick = btnEmoteClearClick
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 131
        Width = 300
        Height = 115
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object TntLabel1: TTntLabel
          Left = 2
          Top = 17
          Width = 77
          Height = 13
          Caption = 'Image Filename:'
        end
        object TntLabel2: TTntLabel
          Left = 2
          Top = 41
          Width = 57
          Height = 13
          Caption = 'Text Match:'
        end
        object TntLabel3: TTntLabel
          Left = 2
          Top = 72
          Width = 190
          Height = 13
          Caption = 'Filename of custom emoticon definitions:'
        end
        object txtEmoteFilename: TTntEdit
          Left = 120
          Top = 9
          Width = 173
          Height = 21
          TabOrder = 0
        end
        object txtEmoteText: TTntEdit
          Left = 120
          Top = 33
          Width = 173
          Height = 21
          TabOrder = 1
        end
        object txtCustomEmoteFilename: TTntEdit
          Left = 16
          Top = 86
          Width = 201
          Height = 21
          TabOrder = 2
        end
        object btnCustomEmoteBrowse: TTntButton
          Left = 222
          Top = 84
          Width = 75
          Height = 25
          Caption = 'Browse'
          TabOrder = 3
        end
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
end
