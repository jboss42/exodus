inherited frmDockable: TfrmDockable
  Caption = 'frmDockable'
  ClientWidth = 204
  DragKind = dkDock
  DragMode = dmAutomatic
  OnDragDrop = OnDockedDragDrop
  OnDragOver = OnDockedDragOver
  OnKeyDown = FormKeyDown
  ExplicitWidth = 212
  ExplicitHeight = 201
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDockTop: TPanel
    Left = 0
    Top = 0
    Width = 204
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object tbDockBar: TToolBar
      AlignWithMargins = True
      Left = 155
      Top = 3
      Width = 46
      Height = 26
      Align = alRight
      AutoSize = True
      DockSite = True
      EdgeInner = esNone
      EdgeOuter = esNone
      HideClippedButtons = True
      Images = frmExodus.ImageList2
      TabOrder = 0
      Transparent = True
      Wrapable = False
      object btnDockToggle: TToolButton
        AlignWithMargins = True
        Left = 0
        Top = 0
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        AutoSize = True
        Caption = 'btnDockToggle'
        ImageIndex = 82
        OnClick = btnDockToggleClick
      end
      object btnCloseDock: TToolButton
        AlignWithMargins = True
        Left = 23
        Top = 0
        Hint = 'Close this tab'
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        AutoSize = True
        Caption = 'btnCloseDock'
        ImageIndex = 83
        OnClick = btnCloseDockClick
      end
    end
  end
end
