inherited frmCommandWizard: TfrmCommandWizard
  Left = 500
  Top = 195
  Height = 312
  BorderStyle = bsSizeable
  Caption = 'frmCommandWizard'
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited TntPanel1: TTntPanel
    Top = 237
    inherited Panel3: TPanel
      inherited btnBack: TTntButton
        OnClick = btnBackClick
      end
      inherited btnNext: TTntButton
        OnClick = btnNextClick
      end
      inherited btnCancel: TTntButton
        OnClick = btnCancelClick
      end
    end
  end
  inherited Panel1: TPanel
    inherited lblWizardTitle: TTntLabel
      Width = 140
      Caption = 'Jabber Command Wizard'
    end
    inherited lblWizardDetails: TTntLabel
      Caption = ''
    end
  end
  inherited Tabs: TPageControl
    Height = 177
    ActivePage = tbsExecute
    inherited TabSheet1: TTabSheet
      object TntLabel1: TTntLabel
        Left = 0
        Top = 0
        Width = 402
        Height = 13
        Align = alTop
        Caption = 'Select or enter the jabber id of the entity to execute.'
      end
      object TntLabel2: TTntLabel
        Left = 8
        Top = 40
        Width = 49
        Height = 13
        Caption = 'Jabber ID:'
      end
      object txtJid: TTntComboBox
        Left = 104
        Top = 37
        Width = 233
        Height = 21
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object tbsSelect: TTabSheet
      Caption = 'tbsSelect'
      ImageIndex = 1
      object TntLabel3: TTntLabel
        Left = 0
        Top = 0
        Width = 402
        Height = 13
        Align = alTop
        Caption = 'Select the specific command to execute.'
      end
      object TntLabel4: TTntLabel
        Left = 8
        Top = 40
        Width = 50
        Height = 13
        Caption = 'Command:'
      end
      object txtCommand: TTntComboBox
        Left = 104
        Top = 37
        Width = 233
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object tbsExecute: TTabSheet
      Caption = 'tbsExecute'
      ImageIndex = 2
      object xdataBox: TScrollBox
        Left = 0
        Top = 0
        Width = 402
        Height = 146
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
      end
    end
    object tbsResults: TTabSheet
      Caption = 'tbsResults'
      ImageIndex = 3
    end
    object tbsWait: TTabSheet
      Caption = 'tbsWait'
      ImageIndex = 4
      object lblWait: TTntLabel
        Left = 0
        Top = 0
        Width = 63
        Height = 13
        Align = alTop
        Caption = 'Please wait...'
      end
    end
  end
end
