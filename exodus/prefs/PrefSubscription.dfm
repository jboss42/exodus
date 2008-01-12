inherited frmPrefSubscription: TfrmPrefSubscription
  Left = 250
  Top = 222
  Caption = 'frmPrefSubscription'
  ClientHeight = 222
  ClientWidth = 399
  OldCreateOrder = True
  ExplicitWidth = 411
  ExplicitHeight = 234
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 399
    Caption = 'Subscriptions'
    ExplicitWidth = 399
  end
  object chkIncomingS10nAdd: TTntCheckBox
    Left = 20
    Top = 196
    Width = 369
    Height = 21
    Caption = 'Add requestor to default contact list group when accepted'
    TabOrder = 1
  end
  object optIncomingS10n: TTntRadioGroup
    Left = 6
    Top = 41
    Width = 385
    Height = 149
    Caption = 'Incoming Behavior'
    Items.Strings = (
      'Ask me for all requests'
      'Auto-Accept requests from people in my contact list'
      'Auto-Accept all requests'
      'Auto-Deny all requests')
    TabOrder = 2
  end
end
