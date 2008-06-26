inherited frmPrefHotkeys: TfrmPrefHotkeys
  Left = 259
  Top = 156
  Caption = 'frmPrefHotkeys'
  ClientHeight = 384
  ClientWidth = 307
  OldCreateOrder = True
  OnDestroy = FormDestroy
  ExplicitWidth = 319
  ExplicitHeight = 396
  PixelsPerInch = 96
  TextHeight = 13
  object TntLabel1: TTntLabel [0]
    Left = 8
    Top = 32
    Width = 220
    Height = 13
    Caption = 'Pressing a Hotkey enters associated message.'
  end
  inherited pnlHeader: TTntPanel
    Width = 307
    Caption = 'Hotkeys'
    ExplicitWidth = 307
  end
  object btnRemoveHotkeys: TTntButton
    Left = 224
    Top = 191
    Width = 75
    Height = 25
    Caption = 'Remove'
    Enabled = False
    TabOrder = 3
    OnClick = btnRemoveHotkeysClick
  end
  object btnAddHotkeys: TTntButton
    Left = 143
    Top = 191
    Width = 75
    Height = 25
    Caption = 'Add...'
    TabOrder = 2
    OnClick = btnAddHotkeysClick
  end
  object lstHotkeys: TTntListView
    Left = 8
    Top = 51
    Width = 291
    Height = 134
    Columns = <
      item
        Caption = 'Hotkey'
      end
      item
        Caption = 'Message'
        Width = 230
      end>
    SortType = stData
    TabOrder = 1
    ViewStyle = vsReport
    OnSelectItem = lstHotkeysSelectItem
  end
  object btnModifyHotkeys: TTntButton
    Left = 62
    Top = 191
    Width = 75
    Height = 25
    Caption = 'Modify...'
    Enabled = False
    TabOrder = 4
    OnClick = btnModifyHotkeysClick
  end
end
