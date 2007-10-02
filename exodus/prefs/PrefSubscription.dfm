inherited frmPrefSubscription: TfrmPrefSubscription
  Left = 250
  Top = 222
  Caption = 'frmPrefSubscription'
  ClientHeight = 180
  ClientWidth = 324
  OldCreateOrder = True
  ExplicitWidth = 336
  ExplicitHeight = 192
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 324
    Caption = 'Subscriptions'
    ExplicitWidth = 324
  end
  object chkIncomingS10nAdd: TTntCheckBox
    Left = 16
    Top = 159
    Width = 300
    Height = 17
    Caption = 'Add requestor to default contact list group when accepted'
    TabOrder = 1
  end
  object optIncomingS10n: TTntRadioGroup
    Left = 8
    Top = 32
    Width = 313
    Height = 121
    Caption = 'Incoming Behavior'
    Items.Strings = (
      'Ask me for all requests'
      'Auto-Accept requests from people in my contact list'
      'Auto-Accept all requests'
      'Auto-Deny all requests')
    TabOrder = 2
  end
end
