inherited ManageBlockDlg: TManageBlockDlg
  BorderStyle = bsDialog
  Caption = 'Manage Blocked Contacts'
  ClientHeight = 440
  ClientWidth = 639
  ParentFont = True
  OnCreate = TntFormCreate
  ExplicitWidth = 645
  ExplicitHeight = 478
  PixelsPerInch = 120
  TextHeight = 16
  object ExBrandPanel1: TExBrandPanel
    Left = 0
    Top = 0
    Width = 639
    Height = 392
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    AutoHide = False
    object lblBlockIns: TTntLabel
      AlignWithMargins = True
      Left = 3
      Top = 9
      Width = 633
      Height = 32
      Margins.Top = 9
      Align = alTop
      Caption = 
        'Enter in the Jabber Addresses (JIDs) of the contacts you wish to' +
        ' block. All messages from these contacts will be blocked.'
      WordWrap = True
      ExplicitWidth = 625
    end
    object memBlocks: TTntMemo
      AlignWithMargins = True
      Left = 3
      Top = 47
      Width = 633
      Height = 342
      Align = alClient
      TabOrder = 0
      ExplicitTop = 53
      ExplicitHeight = 336
    end
  end
  object btnOK: TTntButton
    Left = 440
    Top = 398
    Width = 91
    Height = 30
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TTntButton
    Left = 536
    Top = 398
    Width = 90
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
