inherited ExGroupBox: TExGroupBox
  AlignWithMargins = True
  Margins.Left = 0
  object pnlTop: TTntPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 17
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object lblCaption: TTntLabel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 67
      Height = 17
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      Caption = 'ExGroupBox'
      ExplicitHeight = 16
    end
    object pnlBevel: TTntPanel
      Left = 67
      Top = 0
      Width = 253
      Height = 17
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      DesignSize = (
        253
        17)
      object TntBevel1: TTntBevel
        Left = 3
        Top = 9
        Width = 247
        Height = 2
        Anchors = [akLeft, akTop, akRight]
        Shape = bsTopLine
        ExplicitWidth = 235
      end
    end
  end
end
