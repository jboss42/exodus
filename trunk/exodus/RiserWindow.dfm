object frmRiser: TfrmRiser
  Left = 1024
  Top = 167
  AlphaBlendValue = 235
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 52
  ClientWidth = 184
  Color = clBtnFace
  TransparentColorValue = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 184
    Height = 52
    Align = alClient
    Brush.Style = bsClear
    Pen.Color = clBackground
    Pen.Width = 3
  end
  object Image1: TImage
    Left = 4
    Top = 5
    Width = 30
    Height = 42
    Center = True
    Transparent = True
    OnClick = Panel2Click
  end
  object Label1: TLabel
    Left = 35
    Top = 6
    Width = 133
    Height = 32
    Alignment = taCenter
    Caption = 'Peter Millard is now online.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
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
