object frmInputPass: TfrmInputPass
  Left = 234
  Top = 143
  Width = 268
  Height = 132
  ActiveControl = txtPassword
  Caption = 'Exodus Password'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 76
    Height = 13
    Caption = 'Enter password:'
  end
  object txtPassword: TEdit
    Left = 8
    Top = 27
    Width = 217
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 66
    Width = 260
    Height = 32
    Align = alBottom
    AutoScroll = False
    TabOrder = 1
    inherited Bevel1: TBevel
      Width = 260
    end
    inherited Panel1: TPanel
      Left = 100
    end
  end
end
