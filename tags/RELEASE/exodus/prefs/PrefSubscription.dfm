inherited frmPrefSubscription: TfrmPrefSubscription
  Left = 250
  Top = 222
  Caption = 'frmPrefSubscription'
  ClientHeight = 173
  ClientWidth = 324
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 324
    Caption = 'Subscription Options'
  end
  object optIncomingS10n: TTntRadioGroup
    Left = 8
    Top = 32
    Width = 313
    Height = 121
    Caption = 'Incoming Behavior'
    Items.WideStrings = (
      'Ask me for all requests'
      'Auto-Accept requests from people in my roster.'
      'Auto-Accept all requests'
      'Auto-Deny all requests')
    TabOrder = 1
  end
end
