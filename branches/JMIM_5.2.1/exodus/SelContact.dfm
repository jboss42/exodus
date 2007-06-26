object frmSelContact: TfrmSelContact
  Left = 344
  Top = 310
  Width = 227
  Height = 321
  Caption = 'Select Contact'
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 257
    Width = 219
    Height = 33
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Panel2: TPanel
      Width = 219
      Height = 33
      inherited Bevel1: TBevel
        Width = 219
      end
      inherited Panel1: TPanel
        Left = 59
        Height = 28
      end
    end
  end
  inline frameTreeRoster1: TframeTreeRoster
    Left = 0
    Top = 0
    Width = 219
    Height = 226
    Align = alClient
    TabOrder = 1
    inherited treeRoster: TTreeView
      Width = 219
      Height = 226
      PopupMenu = PopupMenu1
      OnChange = frameTreeRoster1treeRosterChange
      OnDblClick = frameTreeRoster1treeRosterDblClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 226
    Width = 219
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      219
      31)
    object Label1: TTntLabel
      Left = 5
      Top = 7
      Width = 49
      Height = 13
      Caption = 'Jabber ID:'
    end
    object txtJID: TTntEdit
      Left = 63
      Top = 4
      Width = 150
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
  end
  object PopupMenu1: TTntPopupMenu
    Left = 16
    Top = 56
    object ShowOnlineOnly1: TTntMenuItem
      Caption = 'Show Online Only'
      OnClick = ShowOnlineOnly1Click
    end
  end
end
