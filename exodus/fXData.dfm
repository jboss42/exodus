object frameXData: TframeXData
  Left = 0
  Top = 0
  Width = 320
  Height = 132
  TabOrder = 0
  OnResize = FrameResize
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 132
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object ScrollBox1: TScrollBox
      Left = 5
      Top = 5
      Width = 310
      Height = 122
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
      object xGrid: TTntStringGrid
        Left = 0
        Top = 0
        Width = 310
        Height = 100
        Align = alTop
        BorderStyle = bsNone
        Color = clBtnFace
        ColCount = 2
        DefaultColWidth = 100
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = []
        ParentShowHint = False
        ScrollBars = ssNone
        ShowHint = True
        TabOrder = 0
        OnDrawCell = xGridDrawCell
      end
    end
  end
end
