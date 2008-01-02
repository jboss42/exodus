object ExGroupBox: TExGroupBox
  Left = 0
  Top = 0
  Width = 311
  Height = 228
  Color = 13681583
  ParentColor = False
  TabOrder = 0
  TabStop = True
  object pnlTop: TTntPanel
    Left = 0
    Top = 0
    Width = 311
    Height = 17
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object lblCaption: TTntLabel
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 67
      Height = 17
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      Caption = 'ExGroupBox'
      ExplicitLeft = 24
      ExplicitHeight = 16
    end
    object pnlBevel: TTntPanel
      Left = 70
      Top = 0
      Width = 241
      Height = 17
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      ExplicitLeft = 91
      ExplicitWidth = 220
      DesignSize = (
        241
        17)
      object TntBevel1: TTntBevel
        Left = 3
        Top = 9
        Width = 229
        Height = 2
        Anchors = [akLeft, akTop, akRight]
        Shape = bsTopLine
      end
    end
  end
end
