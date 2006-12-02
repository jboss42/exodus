object Options: TOptions
  Left = 0
  Top = 0
  Caption = 'Options'
  ClientHeight = 137
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 257
    Height = 113
    Caption = 'Select Lastname Field'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 26
      Width = 223
      Height = 26
      Caption = 
        'In order for QuickChat to search properly you must select the la' +
        'st name field.'
      WordWrap = True
    end
    object ComboBox1: TComboBox
      Left = 16
      Top = 71
      Width = 193
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 284
    Top = 96
    Width = 113
    Height = 25
    Caption = 'Clear QuickChat List'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 284
    Top = 17
    Width = 113
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 284
    Top = 48
    Width = 113
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = Button3Click
  end
end
