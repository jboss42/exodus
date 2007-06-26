object frmException: TfrmException
  Left = 249
  Top = 204
  Width = 401
  Height = 361
  Caption = 'frmException'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object mmLog: TMemo
    Left = 0
    Top = 0
    Width = 393
    Height = 297
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 297
    Width = 393
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 1
    inherited Panel2: TPanel
      Width = 393
      inherited Bevel1: TBevel
        Width = 393
      end
      inherited Panel1: TPanel
        Left = 233
        inherited btnOK: TTntButton
          Visible = False
        end
        inherited btnCancel: TTntButton
          Caption = 'Close'
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
end
