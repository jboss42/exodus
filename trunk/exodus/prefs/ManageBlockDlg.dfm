inherited ManageBlockDlg: TManageBlockDlg
  Caption = 'Manage Blocked Contacts'
  ClientHeight = 368
  ClientWidth = 535
  OnCreate = TntFormCreate
  ExplicitWidth = 543
  ExplicitHeight = 408
  PixelsPerInch = 120
  TextHeight = 16
  object ExBrandPanel1: TExBrandPanel
    Left = 0
    Top = 0
    Width = 535
    Height = 329
    Align = alTop
    TabOrder = 0
    TabStop = True
    AutoHide = False
    object lblBlockIns: TTntLabel
      AlignWithMargins = True
      Left = 3
      Top = 9
      Width = 529
      Height = 32
      Margins.Top = 9
      Align = alTop
      Caption = 
        'Enter in the Jabber Addresses (JIDs) of the contacts you wish to' +
        ' block. All messages from these contacts will be blocked.'
      WordWrap = True
      ExplicitWidth = 516
    end
    object memBlocks: TTntMemo
      AlignWithMargins = True
      Left = 3
      Top = 47
      Width = 529
      Height = 279
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 102
      ExplicitWidth = 568
      ExplicitHeight = 367
    end
  end
  object btnOK: TTntButton
    Left = 371
    Top = 335
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TTntButton
    Left = 452
    Top = 335
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
