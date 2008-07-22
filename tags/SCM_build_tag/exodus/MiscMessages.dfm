inherited frmSimpleDisplay: TfrmSimpleDisplay
  Caption = 'Simple Message'
  ClientHeight = 219
  ClientWidth = 357
  ExplicitWidth = 365
  ExplicitHeight = 253
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlDock: TTntPanel
    Width = 357
    TabOrder = 1
    ExplicitWidth = 357
    inherited pnlDockTopContainer: TTntPanel
      Width = 355
      ExplicitWidth = 355
      inherited tbDockBar: TToolBar
        Left = 306
        ExplicitLeft = 306
      end
      inherited pnlDockTop: TTntPanel
        Width = 303
        ExplicitWidth = 303
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 355
      ExplicitLeft = 1
      ExplicitTop = 29
      ExplicitWidth = 355
      ExplicitHeight = 25
    end
  end
  object pnlMsgDisplay: TTntPanel
    Left = 0
    Top = 55
    Width = 357
    Height = 164
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
