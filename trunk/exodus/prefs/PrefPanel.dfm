inherited frmPrefPanel: TfrmPrefPanel
  Left = 408
  Top = 423
  BorderStyle = bsNone
  BorderWidth = 6
  Caption = 'frmPrefPanel'
  ClientHeight = 394
  ClientWidth = 353
  OnCreate = FormCreate
  ExplicitWidth = 365
  ExplicitHeight = 406
  PixelsPerInch = 120
  TextHeight = 16
  object pnlHeader: TTntPanel
    AlignWithMargins = True
    Left = 0
    Top = 2
    Width = 353
    Height = 22
    Margins.Left = 0
    Margins.Top = 2
    Margins.Right = 0
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Color = 14460499
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object lblHeader: TTntLabel
      AlignWithMargins = True
      Left = 6
      Top = 1
      Width = 4
      Height = 18
      Margins.Left = 6
      Margins.Top = 1
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
