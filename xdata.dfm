inherited frmXData: TfrmXData
  Left = 273
  Top = 154
  Width = 363
  Height = 315
  Caption = 'Jabber Form'
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 251
    Width = 355
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Panel2: TPanel
      Width = 355
      Height = 34
      inherited Bevel1: TBevel
        Width = 355
      end
      inherited Panel1: TPanel
        Left = 195
        Height = 29
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  inline frameXData: TframeXData
    Left = 0
    Top = 0
    Width = 355
    Height = 251
    Align = alClient
    TabOrder = 1
    inherited Panel1: TPanel
      Width = 355
      Height = 251
      inherited ScrollBox1: TScrollBox
        Width = 345
        Height = 241
      end
    end
  end
end
