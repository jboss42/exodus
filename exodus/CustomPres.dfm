object frmCustomPres: TfrmCustomPres
  Left = 269
  Top = 122
  Width = 323
  Height = 172
  Caption = 'Custom Presence'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 75
    Height = 13
    Caption = 'Presence Type:'
  end
  object Label2: TLabel
    Left = 8
    Top = 43
    Width = 33
    Height = 13
    Caption = 'Status:'
  end
  object Label3: TLabel
    Left = 8
    Top = 75
    Width = 31
    Height = 13
    Caption = 'Priority'
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 104
    Width = 315
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 315
    end
    inherited Panel1: TPanel
      Left = 155
    end
  end
  object cboType: TComboBox
    Left = 96
    Top = 8
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'Chat'
      'Available'
      'Away'
      'Ext. Away'
      'Do Not Disturb')
  end
  object txtStatus: TEdit
    Left = 96
    Top = 40
    Width = 209
    Height = 21
    TabOrder = 2
  end
  object txtPriority: TEdit
    Left = 96
    Top = 72
    Width = 33
    Height = 21
    TabOrder = 3
    Text = '0'
  end
end
