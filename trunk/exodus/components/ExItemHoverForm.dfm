inherited ExItemHoverForm: TExItemHoverForm
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Display Name'
  ClientHeight = 237
  ClientWidth = 320
  Visible = True
  OnCreate = TntFormCreate
  OnDestroy = TntFormDestroy
  OnMouseEnter = TntFormMouseEnter
  OnMouseLeave = TntFormMouseLeave
  ExplicitWidth = 326
  ExplicitHeight = 265
  PixelsPerInch = 120
  TextHeight = 16
  object HoverHide: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = HoverHideTimer
    Left = 232
    Top = 216
  end
  object HoverReenter: TTimer
    Enabled = False
    Interval = 500
    OnTimer = HoverReenterTimer
    Left = 192
    Top = 216
  end
end
