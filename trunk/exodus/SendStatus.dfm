object fSendStatus: TfSendStatus
  Left = 0
  Top = 0
  Width = 402
  Height = 34
  TabOrder = 0
  object Panel1: TPanel
    Left = 313
    Top = 0
    Width = 89
    Height = 34
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object btnCancel: TButton
      Left = 8
      Top = 4
      Width = 75
      Height = 26
      Caption = 'Cancel'
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 120
    Top = 0
    Width = 193
    Height = 34
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 7
    TabOrder = 1
    object ProgressBar1: TProgressBar
      Left = 8
      Top = 8
      Width = 289
      Height = 17
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 120
    Height = 34
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 2
    object lblFile: TLabel
      Left = 2
      Top = 15
      Width = 116
      Height = 17
      Align = alClient
      Caption = 'Sending foo.bmp'
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 2
      Top = 2
      Width = 116
      Height = 13
      Align = alTop
      Caption = 'lblTo'
    end
  end
end
