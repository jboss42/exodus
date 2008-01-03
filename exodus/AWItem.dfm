inherited fAWItem: TfAWItem
  Width = 185
  Height = 24
  ParentShowHint = False
  ShowHint = True
  ExplicitWidth = 185
  ExplicitHeight = 24
  object pnlAWItemGPanel: TExGradientPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 24
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    GradientProperites.startColor = 13681583
    GradientProperites.endColor = 12495763
    GradientProperites.orientation = gdHorizontal
    object AWItemBevel: TBevel
      Left = 0
      Top = 19
      Width = 185
      Height = 5
      Align = alBottom
      Shape = bsBottomLine
      ExplicitLeft = 1
      ExplicitTop = 30
      ExplicitWidth = 183
    end
    object lblName: TTntLabel
      AlignWithMargins = True
      Left = 24
      Top = 3
      Width = 147
      Height = 13
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 'item name'
      EllipsisPosition = epEndEllipsis
      Transparent = True
      Layout = tlCenter
      OnClick = lblNameClick
      ExplicitLeft = 22
      ExplicitTop = 0
      ExplicitWidth = 142
    end
    object lblCount: TTntLabel
      Left = 179
      Top = 0
      Width = 6
      Height = 19
      Align = alRight
      Alignment = taRightJustify
      Caption = '0'
      Transparent = True
      Layout = tlCenter
      OnClick = lblCountClick
      ExplicitHeight = 13
    end
    object imgPresence: TImage
      Left = 0
      Top = 2
      Width = 16
      Height = 16
      Align = alCustom
      Anchors = [akLeft]
      Transparent = True
      OnClick = imgPresenceClick
      ExplicitTop = 5
    end
    object LeftSpacer: TBevel
      Left = 0
      Top = 0
      Width = 21
      Height = 19
      Align = alLeft
      Shape = bsSpacer
    end
    object RightSpacer: TBevel
      Left = 174
      Top = 0
      Width = 5
      Height = 19
      Align = alRight
      Shape = bsSpacer
      ExplicitLeft = 16
    end
  end
end
