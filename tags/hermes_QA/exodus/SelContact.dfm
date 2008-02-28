inherited frmSelContact: TfrmSelContact
  Left = 344
  Top = 310
  Caption = 'Select Contact'
  ClientHeight = 287
  ClientWidth = 219
  DefaultMonitor = dmDesktop
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 227
  ExplicitHeight = 321
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 254
    Width = 219
    Height = 33
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    TabStop = True
    ExplicitTop = 254
    ExplicitWidth = 219
    ExplicitHeight = 33
    inherited Panel2: TPanel
      Width = 219
      Height = 33
      ExplicitWidth = 219
      ExplicitHeight = 33
      inherited Bevel1: TBevel
        Width = 219
        ExplicitWidth = 219
      end
      inherited Panel1: TPanel
        Left = 59
        Height = 28
        ExplicitLeft = 59
        ExplicitHeight = 28
      end
    end
  end
  inline frameTreeRoster1: TframeTreeRoster
    Left = 0
    Top = 0
    Width = 219
    Height = 223
    Align = alClient
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    TabStop = True
    ExplicitWidth = 219
    ExplicitHeight = 223
    inherited treeRoster: TTreeView
      Width = 219
      Height = 223
      PopupMenu = PopupMenu1
      OnChange = frameTreeRoster1treeRosterChange
      OnDblClick = frameTreeRoster1treeRosterDblClick
      ExplicitWidth = 219
      ExplicitHeight = 223
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 223
    Width = 219
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    DesignSize = (
      219
      31)
    object Label1: TTntLabel
      Left = 5
      Top = 7
      Width = 51
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
