object frameTopLabel: TframeTopLabel
  Left = 0
  Top = 0
  Width = 151
  Height = 41
  TabOrder = 0
  OnResize = FrameResize
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 151
    Height = 41
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 0
    object lbl: TLabel
      Left = 3
      Top = 3
      Width = 145
      Height = 13
      Align = alTop
      Caption = 'Some Text label'
    end
    object txtData: TEdit
      Left = 2
      Top = 18
      Width = 145
      Height = 21
      TabOrder = 0
    end
  end
end
