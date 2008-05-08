inherited frmSimpleDisplay: TfrmSimpleDisplay
  Caption = 'Simple Message'
  ClientHeight = 219
  ClientWidth = 357
  ExplicitWidth = 365
  ExplicitHeight = 247
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlDockTop: TPanel
    Width = 357
    Height = 28
    TabOrder = 1
    ExplicitWidth = 357
    ExplicitHeight = 28
    inherited tbDockBar: TToolBar
      Left = 308
      Height = 22
      ExplicitLeft = 308
      ExplicitHeight = 22
    end
  end
  object pnlMsgDisplay: TTntPanel
    Left = 0
    Top = 28
    Width = 357
    Height = 191
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    ParentColor = True
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 31
    ExplicitWidth = 351
    ExplicitHeight = 185
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
