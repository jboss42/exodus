inherited frmPrefSubscription: TfrmPrefSubscription
  Left = 250
  Top = 222
  Caption = 'frmPrefSubscription'
  ClientHeight = 134
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object StaticText2: TStaticText
    Left = 0
    Top = 0
    Width = 272
    Height = 20
    Align = alTop
    Alignment = taCenter
    Caption = 'Subscription Options'
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
  object optIncomingS10n: TRadioGroup
    Left = 8
    Top = 32
    Width = 257
    Height = 81
    Caption = 'Incoming Behavior '
    ItemIndex = 0
    Items.Strings = (
      'Ask me for all requests'
      'Auto-Accept requests from people in my roster.'
      'Auto-Accept all requests')
    TabOrder = 1
  end
end
