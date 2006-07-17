object frmDockable: TfrmDockable
  Left = 524
  Top = 255
  Caption = 'frmDockable'
  ClientHeight = 197
  ClientWidth = 241
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ScreenSnap = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDragDrop = OnDockedDragDrop
  OnDragOver = OnDockedDragOver
  OnEndDock = FormEndDock
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
end
