inherited frmPrefSubscription: TfrmPrefSubscription
  Left = 250
  Top = 222
  Caption = 'frmPrefSubscription'
  ClientHeight = 183
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Caption = 'Subscription Options'
    TabOrder = 1
  end
  object optIncomingS10n: TRadioGroup
    Left = 8
    Top = 32
    Width = 257
    Height = 105
    Caption = 'Incoming Behavior '
    ItemIndex = 0
    Items.Strings = (
      'Ask me for all requests'
      'Auto-Accept requests from people in my roster.'
      'Auto-Accept all requests'
      'Auto-Deny all requests')
    TabOrder = 0
  end
end
