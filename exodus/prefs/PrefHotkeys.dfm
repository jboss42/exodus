inherited frmPrefHotkeys: TfrmPrefHotkeys
  Left = 259
  Top = 156
  Caption = 'frmPrefHotkeys'
  ClientHeight = 473
  ClientWidth = 482
  OldCreateOrder = True
  OnDestroy = FormDestroy
  ExplicitWidth = 494
  ExplicitHeight = 485
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 482
    ExplicitWidth = 482
    inherited lblHeader: TTntLabel
      Width = 61
      Caption = 'Hotkeys'
      ExplicitWidth = 61
    end
  end
  object pnlContainer: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 33
    Width = 479
    Height = 259
    Margins.Left = 0
    Margins.Top = 6
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    TabOrder = 1
    TabStop = True
    AutoHide = True
    object TntLabel1: TTntLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 473
      Height = 16
      Align = alTop
      Caption = '&Pressing a hotkey will enter the associated message'
      FocusControl = lstHotkeys
      ExplicitWidth = 298
    end
    object lstHotkeys: TTntListView
      AlignWithMargins = True
      Left = 3
      Top = 25
      Width = 473
      Height = 205
      Align = alTop
      Columns = <
        item
          Caption = 'Hotkey'
          Width = 62
        end
        item
          Caption = 'Message'
          Width = 410
        end>
      RowSelect = True
      SortType = stData
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = lstHotkeysSelectItem
    end
    object btnModifyHotkeys: TTntButton
      Left = 84
      Top = 236
      Width = 75
      Height = 23
      Caption = '&Edit...'
      Enabled = False
      TabOrder = 2
      OnClick = btnModifyHotkeysClick
    end
    object btnAddHotkeys: TTntButton
      Left = 3
      Top = 236
      Width = 75
      Height = 23
      Caption = '&Add...'
      TabOrder = 1
      OnClick = btnAddHotkeysClick
    end
    object btnRemoveHotkeys: TTntButton
      Left = 165
      Top = 236
      Width = 75
      Height = 23
      Caption = '&Remove'
      Enabled = False
      TabOrder = 3
      OnClick = btnRemoveHotkeysClick
    end
    object btnClearAll: TTntButton
      Left = 246
      Top = 236
      Width = 75
      Height = 23
      Caption = '&Clear All'
      TabOrder = 4
      OnClick = btnClearAllClick
    end
  end
end
