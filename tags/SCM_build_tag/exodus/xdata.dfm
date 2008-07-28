inherited frmXData: TfrmXData
  Left = 273
  Top = 154
  Caption = 'Jabber Form'
  ClientHeight = 512
  ClientWidth = 606
  OldCreateOrder = True
  ExplicitWidth = 614
  ExplicitHeight = 545
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlDock: TTntPanel
    Width = 606
    TabOrder = 2
    ExplicitWidth = 606
    inherited pnlDockTopContainer: TTntPanel
      Width = 606
      ExplicitWidth = 606
      inherited tbDockBar: TToolBar
        Left = 556
        ExplicitLeft = 556
        inherited btnCloseDock: TToolButton
          Visible = False
        end
      end
      inherited pnlDockTop: TTntPanel
        Width = 552
        ExplicitWidth = 552
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 606
      ExplicitWidth = 606
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 470
    Width = 606
    Height = 42
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    TabStop = True
    ExplicitTop = 470
    ExplicitWidth = 606
    ExplicitHeight = 42
    inherited Panel2: TPanel
      Width = 606
      Height = 42
      ExplicitWidth = 606
      ExplicitHeight = 42
      inherited Bevel1: TBevel
        Width = 606
        Height = 6
        ExplicitWidth = 606
        ExplicitHeight = 6
      end
      inherited Panel1: TPanel
        Left = 409
        Top = 6
        Width = 197
        Height = 36
        ExplicitLeft = 409
        ExplicitTop = 6
        ExplicitWidth = 197
        ExplicitHeight = 36
        inherited btnOK: TTntButton
          Left = 5
          Width = 92
          Height = 31
          OnClick = frameButtons1btnOKClick
          ExplicitLeft = 5
          ExplicitWidth = 92
          ExplicitHeight = 31
        end
        inherited btnCancel: TTntButton
          Left = 101
          Width = 92
          Height = 31
          OnClick = frameButtons1btnCancelClick
          ExplicitLeft = 101
          ExplicitWidth = 92
          ExplicitHeight = 31
        end
      end
    end
  end
  inline frameXData: TframeXData
    Left = 0
    Top = 97
    Width = 606
    Height = 373
    Align = alClient
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    TabStop = True
    ExplicitTop = 97
    ExplicitWidth = 606
    ExplicitHeight = 373
    inherited Panel1: TPanel
      Width = 606
      Height = 373
      ExplicitWidth = 606
      ExplicitHeight = 373
      inherited ScrollBox1: TScrollBox
        Width = 596
        Height = 363
        ExplicitLeft = 6
        ExplicitTop = 4
        ExplicitWidth = 596
        ExplicitHeight = 363
      end
    end
  end
end
