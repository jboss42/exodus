object frmXData: TfrmXData
  Left = 262
  Top = 249
  Width = 537
  Height = 243
  BorderWidth = 5
  Caption = 'x:data Form'
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object insBevel: TBevel
    Left = 0
    Top = 13
    Width = 519
    Height = 8
    Align = alTop
    Shape = bsTopLine
  end
  object lblIns: TTntLabel
    Left = 0
    Top = 0
    Width = 519
    Height = 13
    Align = alTop
    Caption = 'lblIns'
    WordWrap = True
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 167
    Width = 519
    Height = 32
    Align = alBottom
    AutoScroll = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    inherited Panel2: TPanel
      Width = 519
      Height = 32
      inherited Bevel1: TBevel
        Width = 519
      end
      inherited Panel1: TPanel
        Left = 359
        Height = 27
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object box: TScrollBox
    Left = 0
    Top = 21
    Width = 519
    Height = 146
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 1
  end
end