object FloatImage: TFloatImage
  Left = 491
  Top = 282
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'FloatingImage'
  ClientHeight = 177
  ClientWidth = 260
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 260
    Height = 177
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 1
    Caption = 'Panel1'
    TabOrder = 0
    object paintAvatar: TPaintBox
      Left = 3
      Top = 3
      Width = 254
      Height = 171
      Align = alClient
      OnPaint = paintAvatarPaint
    end
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 24
    Top = 88
  end
end
