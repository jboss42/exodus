inherited frmDockWindow: TfrmDockWindow
  Caption = 'frmDockWindow'
  ClientHeight = 507
  ClientWidth = 785
  DockSite = True
  ParentFont = False
  OnDockDrop = FormDockDrop
  OnHide = FormHide
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 793
  ExplicitHeight = 540
  PixelsPerInch = 120
  TextHeight = 16
  object splAW: TTntSplitter
    Left = 228
    Top = 0
    Height = 507
    ResizeStyle = rsUpdate
  end
  object AWTabControl: TPageControl
    Left = 231
    Top = 0
    Width = 554
    Height = 507
    Align = alClient
    DockSite = True
    OwnerDraw = True
    Style = tsButtons
    TabOrder = 0
    TabStop = False
    OnDockDrop = AWTabControlDockDrop
    OnUnDock = AWTabControlUnDock
  end
  object pnlActivityList: TPanel
    Left = 0
    Top = 0
    Width = 228
    Height = 507
    Align = alLeft
    BevelOuter = bvNone
    Constraints.MinWidth = 37
    ParentColor = True
    TabOrder = 1
    OnDockDrop = FormDockDrop
  end
end
