object frmSelContact: TfrmSelContact
  Left = 344
  Top = 310
  Width = 227
  Height = 321
  Caption = 'Select Contact'
  Color = clBtnFace
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
    Top = 259
    Width = 219
    Height = 33
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 219
    end
    inherited Panel1: TPanel
      Left = 59
      Height = 28
    end
  end
  inline frameTreeRoster1: TframeTreeRoster
    Left = 0
    Top = 0
    Width = 219
    Height = 259
    Align = alClient
    TabOrder = 1
    inherited treeRoster: TTreeView
      Width = 219
      Height = 259
      PopupMenu = PopupMenu1
      OnDblClick = frameTreeRoster1treeRosterDblClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 16
    Top = 56
    object ShowOnlineOnly1: TMenuItem
      Caption = 'Show Online Only'
      OnClick = ShowOnlineOnly1Click
    end
  end
end
