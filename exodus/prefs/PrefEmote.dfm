inherited frmPrefEmote: TfrmPrefEmote
  Left = 263
  Top = 185
  Caption = 'frmPrefEmote'
  ClientHeight = 216
  ClientWidth = 330
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 330
    Caption = 'Emoticon Options'
  end
  object pnlCustomPresButtons: TPanel
    Left = 0
    Top = 172
    Width = 330
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btnEmoteAdd: TTntButton
      Left = 4
      Top = 4
      Width = 60
      Height = 25
      Caption = 'Add'
      TabOrder = 0
    end
    object btnEmoteRemove: TTntButton
      Left = 68
      Top = 4
      Width = 60
      Height = 25
      Caption = 'Remove'
      TabOrder = 1
    end
    object btnEmoteClear: TTntButton
      Left = 132
      Top = 4
      Width = 60
      Height = 25
      Caption = 'Clear'
      TabOrder = 2
    end
    object btnEmoteDefault: TTntButton
      Left = 196
      Top = 4
      Width = 60
      Height = 25
      Caption = 'Defaults'
      TabOrder = 3
    end
  end
  object lstEmotes: TTntListBox
    Left = 0
    Top = 70
    Width = 330
    Height = 102
    Align = alTop
    ItemHeight = 13
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 330
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Label1: TTntLabel
      Left = 0
      Top = 26
      Width = 123
      Height = 13
      Caption = 'Emoticon Resource DLL'#39's'
    end
    object chkEmoticons: TTntCheckBox
      Left = 2
      Top = 5
      Width = 300
      Height = 17
      Caption = 'Auto detect Emoticons in messages'
      TabOrder = 0
    end
  end
  object EmoteOpen: TOpenDialog
    Filter = 'Resource Files|*.dll|All Files|*.*'
    Left = 248
    Top = 34
  end
end
