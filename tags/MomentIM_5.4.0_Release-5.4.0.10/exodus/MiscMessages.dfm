inherited frmSimpleDisplay: TfrmSimpleDisplay
  Caption = 'Simple Message'
  ClientHeight = 270
  ClientWidth = 439
  ExplicitWidth = 447
  ExplicitHeight = 303
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlDock: TTntPanel
    Width = 439
    TabOrder = 1
    ExplicitWidth = 439
    inherited pnlDockTopContainer: TTntPanel
      Width = 439
      ExplicitWidth = 439
      inherited tbDockBar: TToolBar
        Left = 389
        ExplicitLeft = 389
      end
      inherited pnlDockTop: TTntPanel
        Width = 385
        Caption = 'pnlDockTop'
        ExplicitWidth = 385
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 439
      ExplicitWidth = 439
    end
  end
  object pnlMsgDisplay: TTntPanel
    Left = 0
    Top = 97
    Width = 439
    Height = 173
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    ParentColor = True
    TabOrder = 0
  end
  object mnuSimplePopup: TTntPopupMenu
    Left = 8
    Top = 32
    object mnuCopy: TTntMenuItem
      Caption = 'Copy'
      OnClick = mnuClick
    end
    object mnuCopyAll: TTntMenuItem
      Caption = 'Copy All'
      OnClick = mnuClick
    end
    object mnuClear: TTntMenuItem
      Caption = 'Clear'
      OnClick = mnuClick
    end
  end
end
