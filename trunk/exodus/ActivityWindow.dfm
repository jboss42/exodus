object frmActivityWindow: TfrmActivityWindow
  Left = 0
  Top = 0
  Caption = 'frmActivityWindow'
  ClientHeight = 394
  ClientWidth = 187
  Color = 13681583
  DockSite = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlListBase: TExGradientPanel
    Left = 0
    Top = 0
    Width = 187
    Height = 394
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    GradientProperites.startColor = 13681583
    GradientProperites.endColor = 12495763
    GradientProperites.orientation = gdHorizontal
    object pnlListScrollUp: TExGradientPanel
      Left = 0
      Top = 25
      Width = 187
      Height = 22
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      OnClick = pnlListScrollUpClick
      GradientProperites.startColor = 12891033
      GradientProperites.endColor = 10848873
      GradientProperites.orientation = gdHorizontal
      object imgScrollUp: TImage
        Left = 73
        Top = 2
        Width = 16
        Height = 16
        Align = alCustom
        Anchors = [akTop]
        Transparent = True
        OnClick = pnlListScrollUpClick
        ExplicitLeft = 75
      end
      object ScrollUpBevel: TBevel
        Left = 0
        Top = 17
        Width = 187
        Height = 5
        Align = alBottom
        Shape = bsBottomLine
        Visible = False
        ExplicitLeft = 1
        ExplicitTop = 30
        ExplicitWidth = 183
      end
    end
    object pnlListScrollDown: TExGradientPanel
      Left = 0
      Top = 372
      Width = 187
      Height = 22
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      OnClick = pnlListScrollDownClick
      GradientProperites.startColor = 12891033
      GradientProperites.endColor = 10848873
      GradientProperites.orientation = gdHorizontal
      ExplicitTop = 333
      object imgScrollDown: TImage
        Left = 73
        Top = 4
        Width = 16
        Height = 16
        Align = alCustom
        Anchors = [akBottom]
        Transparent = True
        OnClick = pnlListScrollDownClick
        ExplicitLeft = 75
        ExplicitTop = 2
      end
      object ScrollDownBevel: TBevel
        Left = 0
        Top = 0
        Width = 187
        Height = 5
        Align = alTop
        Shape = bsTopLine
        Visible = False
        ExplicitLeft = 1
        ExplicitTop = 30
        ExplicitWidth = 183
      end
    end
    object pnlList: TExGradientPanel
      Left = 0
      Top = 47
      Width = 187
      Height = 325
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      TabStop = True
      GradientProperites.startColor = 12891033
      GradientProperites.endColor = 10848873
      GradientProperites.orientation = gdHorizontal
      ExplicitTop = 45
      object ListLeftSpacer: TBevel
        Left = 0
        Top = 0
        Width = 5
        Height = 325
        Align = alLeft
        Shape = bsSpacer
        ExplicitTop = 322
        ExplicitHeight = 189
      end
      object ListRightSpacer: TBevel
        Left = 187
        Top = 0
        Width = 0
        Height = 325
        Align = alRight
        Shape = bsSpacer
        ExplicitLeft = 184
        ExplicitHeight = 327
      end
    end
    object pnlListSort: TExGradientPanel
      Left = 0
      Top = 0
      Width = 187
      Height = 25
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      OnClick = pnlListSortClick
      GradientProperites.startColor = 13681583
      GradientProperites.endColor = 13681583
      GradientProperites.orientation = gdHorizontal
      object SortBevel: TBevel
        Left = 0
        Top = 20
        Width = 187
        Height = 5
        Align = alBottom
        Shape = bsBottomLine
        ExplicitLeft = 1
        ExplicitTop = 30
        ExplicitWidth = 183
      end
      object lblSort: TTntLabel
        Left = 0
        Top = 5
        Width = 187
        Height = 15
        Align = alClient
        Alignment = taCenter
        Caption = 'Sort By:  Alpha'
        Transparent = True
        OnClick = pnlListSortClick
        ExplicitWidth = 72
        ExplicitHeight = 13
      end
      object SortTopSpacer: TBevel
        Left = 0
        Top = 0
        Width = 187
        Height = 5
        Align = alTop
        Shape = bsSpacer
        ExplicitLeft = 1
        ExplicitTop = 30
        ExplicitWidth = 183
      end
    end
  end
  object timSetActivePanel: TTimer
    Enabled = False
    Interval = 100
    OnTimer = timSetActivePanelTimer
    Left = 72
    Top = 144
  end
  object popAWSort: TTntPopupMenu
    Left = 104
    Top = 144
    object mnuAlphaSort: TTntMenuItem
      Caption = 'Alpha'
      OnClick = mnuAlphaSortClick
    end
    object mnuRecentSort: TTntMenuItem
      Caption = 'Most Recent Activity'
      OnClick = mnuRecentSortClick
    end
    object mnuTypeSort: TTntMenuItem
      Caption = 'Type'
      OnClick = mnuTypeSortClick
    end
    object mnuUnreadSort: TTntMenuItem
      Caption = 'Unread Messages'
      OnClick = mnuUnreadSortClick
    end
  end
end
