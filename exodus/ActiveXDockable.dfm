inherited frmActiveXDockable: TfrmActiveXDockable
  Left = 414
  Top = 474
  ClientHeight = 240
  ClientWidth = 383
  OnDestroy = FormDestroy
  ExplicitWidth = 391
  ExplicitHeight = 274
  PixelsPerInch = 96
  TextHeight = 12
  inherited pnlDockTop: TPanel
    Width = 383
    TabOrder = 1
    ExplicitWidth = 383
    inherited tbDockBar: TToolBar
      Left = 334
      ExplicitLeft = 334
    end
    object pnlChatTop: TPanel
      Left = 0
      Top = 0
      Width = 331
      Height = 30
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
    end
  end
  object pnlMsgList: TPanel
    Left = 0
    Top = 30
    Width = 383
    Height = 210
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    ParentColor = True
    TabOrder = 0
  end
end
