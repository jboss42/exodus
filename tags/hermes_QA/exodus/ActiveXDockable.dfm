inherited frmActiveXDockable: TfrmActiveXDockable
  Left = 414
  Top = 474
  ClientHeight = 260
  ClientWidth = 415
  OnDestroy = FormDestroy
  ExplicitWidth = 423
  ExplicitHeight = 294
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlDockTop: TPanel
    Width = 415
    TabOrder = 1
    ExplicitWidth = 415
    inherited tbDockBar: TToolBar
      Left = 366
      ExplicitLeft = 366
    end
    object pnlChatTop: TPanel
      Left = 0
      Top = 0
      Width = 363
      Height = 33
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
    end
  end
  object pnlMsgList: TPanel
    Left = 0
    Top = 33
    Width = 415
    Height = 227
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    ParentColor = True
    TabOrder = 0
  end
end
