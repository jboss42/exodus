object frmXData: TfrmXData
  Left = 514
  Top = 642
  Width = 527
  Height = 229
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
    Top = 23
    Width = 509
    Height = 8
    Align = alTop
    Shape = bsTopLine
  end
  object lblIns: TExodusLabel
    Left = 0
    Top = 0
    Width = 509
    Height = 23
    Align = alTop
    Caption = 'lblIns'
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 153
    Width = 509
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
      Width = 509
      Height = 32
      inherited Bevel1: TBevel
        Width = 509
      end
      inherited Panel1: TPanel
        Left = 349
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
    Top = 31
    Width = 509
    Height = 122
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 1
  end
end
