inherited frmPrefTabs: TfrmPrefTabs
  Left = 232
  Top = 142
  BorderStyle = bsDialog
  Caption = 'Manage tabs'
  ClientHeight = 314
  ClientWidth = 517
  OldCreateOrder = True
  OnShow = TntFormShow
  ExplicitWidth = 523
  ExplicitHeight = 352
  PixelsPerInch = 120
  TextHeight = 16
  object lstTabs: TTntListView
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 514
    Height = 272
    Margins.Top = 9
    BevelWidth = 0
    Checkboxes = True
    Columns = <
      item
        AutoSize = True
        Caption = 'Tab Name'
      end
      item
        AutoSize = True
        Caption = 'Tab Description'
      end>
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btnCancel: TTntButton
    Left = 410
    Top = 278
    Width = 104
    Height = 31
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object btnOK: TTntButton
    Left = 298
    Top = 278
    Width = 103
    Height = 31
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
end
