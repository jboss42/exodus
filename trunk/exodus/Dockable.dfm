object frmDockable: TfrmDockable
  Left = 293
  Top = 219
  Width = 265
  Height = 258
  Caption = 'frmDockable'
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnEndDock = FormEndDock
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object timFlasher: TTimer
    Enabled = False
    OnTimer = timFlasherTimer
    Left = 8
    Top = 8
  end
end
