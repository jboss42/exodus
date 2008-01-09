object frmActivityWindow: TfrmActivityWindow
  Left = 0
  Top = 0
  Caption = 'frmActivityWindow'
  ClientHeight = 398
  ClientWidth = 191
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
    Width = 191
    Height = 398
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
      Width = 191
      Height = 22
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      Visible = False
      OnClick = pnlListScrollUpClick
      GradientProperites.startColor = 13681583
      GradientProperites.endColor = 12495763
      GradientProperites.orientation = gdHorizontal
      object imgScrollUp: TImage
        Left = 75
        Top = 2
        Width = 16
        Height = 16
        Align = alCustom
        Anchors = [akTop]
        Transparent = True
        OnClick = pnlListScrollUpClick
      end
      object ScrollUpBevel: TBevel
        Left = 0
        Top = 17
        Width = 191
        Height = 5
        Align = alBottom
        Shape = bsBottomLine
        ExplicitLeft = 1
        ExplicitTop = 30
        ExplicitWidth = 183
      end
    end
    object pnlListScrollDown: TExGradientPanel
      Left = 0
      Top = 376
      Width = 191
      Height = 22
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      Visible = False
      OnClick = pnlListScrollDownClick
      GradientProperites.startColor = 13681583
      GradientProperites.endColor = 12495763
      GradientProperites.orientation = gdHorizontal
      object imgScrollDown: TImage
        Left = 75
        Top = 4
        Width = 16
        Height = 16
        Align = alCustom
        Anchors = [akBottom]
        Transparent = True
        OnClick = pnlListScrollDownClick
        ExplicitTop = 2
      end
      object ScrollDownBevel: TBevel
        Left = 0
        Top = 0
        Width = 191
        Height = 5
        Align = alTop
        Shape = bsTopLine
        ExplicitLeft = 1
        ExplicitTop = 30
        ExplicitWidth = 183
      end
    end
    object pnlList: TExGradientPanel
      Left = 0
      Top = 47
      Width = 191
      Height = 329
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      TabStop = True
      GradientProperites.startColor = 13681583
      GradientProperites.endColor = 12495763
      GradientProperites.orientation = gdHorizontal
    end
    object pnlListSort: TExGradientPanel
      Left = 0
      Top = 0
      Width = 191
      Height = 25
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      OnClick = pnlListSortClick
      GradientProperites.startColor = 13681583
      GradientProperites.endColor = 12495763
      GradientProperites.orientation = gdHorizontal
      object SortBevel: TBevel
        Left = 0
        Top = 20
        Width = 191
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
        Width = 72
        Height = 13
        Align = alClient
        Alignment = taCenter
        Caption = 'Sort By:  Alpha'
        Transparent = True
        OnClick = pnlListSortClick
      end
      object SortTopSpacer: TBevel
        Left = 0
        Top = 0
        Width = 191
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
    Top = 112
  end
  object popAWSort: TTntPopupMenu
    Left = 32
    Top = 112
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
