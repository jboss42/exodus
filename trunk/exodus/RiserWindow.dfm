object frmRiser: TfrmRiser
  Left = 308
  Top = 212
  AlphaBlendValue = 235
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 45
  ClientWidth = 184
  Color = clBtnFace
  TransparentColorValue = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  OnClick = Panel2Click
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 184
    Height = 45
    Align = alClient
    Brush.Style = bsClear
    Pen.Color = clBackground
    Pen.Width = 3
    OnMouseDown = Shape1MouseDown
  end
  object Image1: TImage
    Left = 4
    Top = 5
    Width = 30
    Height = 32
    Center = True
    Transparent = True
    OnClick = Panel2Click
  end
  object Label1: TTntLabel
    Left = 35
    Top = 6
    Width = 127
    Height = 28
    Alignment = taCenter
    Caption = 'Peter Millard is now online.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    WordWrap = True
    OnClick = Panel2Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 136
    Top = 8
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer2Timer
    Left = 104
    Top = 8
  end
end
