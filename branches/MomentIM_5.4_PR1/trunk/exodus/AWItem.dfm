inherited fAWItem: TfAWItem
  Width = 185
  Height = 27
  ParentShowHint = False
  ShowHint = True
  OnClick = TntFrameClick
  ExplicitWidth = 185
  ExplicitHeight = 27
  object pnlAWItemGPanel: TExGradientPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 27
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    ParentShowHint = False
    PopupMenu = AWItemPopupMenu
    ShowHint = True
    TabOrder = 0
    OnClick = pnlAWItemGPanelClick
    GradientProperites.startColor = 13746091
    GradientProperites.endColor = 12429970
    GradientProperites.orientation = gdHorizontal
    object lblName: TTntLabel
      AlignWithMargins = True
      Left = 29
      Top = 3
      Width = 136
      Height = 16
      Align = alClient
      AutoSize = False
      Caption = 'item name'
      EllipsisPosition = epEndEllipsis
      Transparent = True
      Layout = tlCenter
      OnClick = lblNameClick
      ExplicitLeft = 24
      ExplicitWidth = 146
      ExplicitHeight = 15
    end
    object lblCount: TTntLabel
      Left = 173
      Top = 0
      Width = 7
      Height = 22
      Align = alRight
      Alignment = taRightJustify
      Caption = '0'
      Transparent = True
      Layout = tlCenter
      OnClick = lblCountClick
      ExplicitHeight = 16
    end
    object imgPresence: TImage
      Left = 0
      Top = 3
      Width = 16
      Height = 16
      Align = alCustom
      Anchors = [akLeft]
      Transparent = True
      OnClick = imgPresenceClick
      ExplicitTop = 5
    end
    object LeftSpacer: TBevel
      Left = 5
      Top = 0
      Width = 21
      Height = 22
      Align = alLeft
      Shape = bsSpacer
      ExplicitLeft = 0
      ExplicitHeight = 19
    end
    object RightLBLSpacer: TBevel
      Left = 168
      Top = 0
      Width = 5
      Height = 22
      Align = alRight
      Shape = bsSpacer
      ExplicitLeft = 16
      ExplicitHeight = 19
    end
    object FarRightSpacer: TBevel
      Left = 180
      Top = 0
      Width = 5
      Height = 22
      Align = alRight
      Shape = bsSpacer
      ExplicitLeft = 184
      ExplicitTop = 3
    end
    object FarLeftSpacer: TBevel
      Left = 0
      Top = 0
      Width = 5
      Height = 22
      Align = alLeft
      Shape = bsSpacer
    end
    object AWItemBevel: TColorBevel
      Left = 0
      Top = 22
      Width = 185
      Height = 5
      Align = alBottom
      Shape = bsBottomLine
      HighLight = clBtnHighlight
      Shadow = clBtnShadow
      FrameColor = frUser
      ExplicitTop = -23
    end
  end
  object AWItemPopupMenu: TTntPopupMenu
    OnPopup = AWItemPopupMenuPopup
    Left = 136
    object mnuCloseWindow: TTntMenuItem
      Caption = 'Close Window'
      OnClick = mnuCloseWindowClick
    end
    object mnuDockWindow: TTntMenuItem
      Caption = 'Dock Window'
      OnClick = mnuDockWindowClick
    end
    object mnuFloatWindow: TTntMenuItem
      Caption = 'Undock Window'
      OnClick = mnuFloatWindowClick
    end
    object N1: TTntMenuItem
      Caption = '-'
    end
    object mnuAWItem_CloseAll: TTntMenuItem
      Caption = 'Close All Windows'
      OnClick = mnuAWItem_CloseAllClick
    end
    object mnuAWItem_DockAll: TTntMenuItem
      Caption = 'Dock All Windows'
      OnClick = mnuAWItem_DockAllClick
    end
    object mnuAWItem_FloatAll: TTntMenuItem
      Caption = 'Undock All Windows'
      OnClick = mnuAWItem_FloatAllClick
    end
  end
end
