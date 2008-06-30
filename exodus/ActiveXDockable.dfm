inherited frmActiveXDockable: TfrmActiveXDockable
  Left = 414
  Top = 474
  ClientHeight = 320
  ClientWidth = 511
  OnDestroy = FormDestroy
  ExplicitWidth = 519
  ExplicitHeight = 353
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlDock: TTntPanel
    Width = 511
    TabOrder = 1
    ExplicitWidth = 511
    inherited pnlDockTopContainer: TTntPanel
      Width = 511
      ExplicitWidth = 511
      inherited tbDockBar: TToolBar
        Left = 461
        ExplicitLeft = 461
      end
      inherited pnlDockTop: TTntPanel
        Width = 457
        Caption = 'pnlDockTop'
        ExplicitWidth = 457
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 511
      ExplicitWidth = 511
    end
  end
  object pnlMsgList: TPanel
    Left = 0
    Top = 97
    Width = 511
    Height = 223
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    ParentColor = True
    TabOrder = 0
  end
end
