object frmXData: TfrmXData
  Left = 879
  Top = 474
  Width = 328
  Height = 413
  BorderWidth = 5
  Caption = 'x:data Form'
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblIns: TLabel
    Left = 0
    Top = 0
    Width = 310
    Height = 13
    Align = alTop
    Caption = 'lblIns'
    WordWrap = True
  end
  object insBevel: TBevel
    Left = 0
    Top = 13
    Width = 310
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 337
    Width = 310
    Height = 32
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 310
    end
    inherited Panel1: TPanel
      Left = 150
      inherited btnOK: TButton
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object lstReport: TListView
    Left = 0
    Top = 187
    Width = 310
    Height = 150
    Align = alBottom
    Columns = <>
    TabOrder = 1
    ViewStyle = vsReport
  end
  object box: TScrollBox
    Left = 0
    Top = 15
    Width = 310
    Height = 172
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 2
  end
end
