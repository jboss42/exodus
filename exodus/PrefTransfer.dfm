inherited frmPrefTransfer: TfrmPrefTransfer
  Left = 316
  Top = 320
  Caption = 'frmPrefTransfer'
  ClientHeight = 240
  ClientWidth = 313
  PixelsPerInch = 96
  TextHeight = 13
  object Label15: TLabel
    Left = 0
    Top = 35
    Width = 149
    Height = 13
    Caption = 'File transfer download directory:'
  end
  object Label1: TLabel
    Left = 0
    Top = 83
    Width = 160
    Height = 13
    Caption = 'Port to use for HTTP file transfers:'
  end
  object Label2: TLabel
    Left = 0
    Top = 184
    Width = 184
    Height = 13
    Cursor = crHandPoint
    Caption = 'Reset all file transfer options to defaults'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label2Click
  end
  object StaticText7: TStaticText
    Left = 0
    Top = 0
    Width = 313
    Height = 20
    Align = alTop
    Alignment = taCenter
    Caption = 'File Transfer Options'
    Color = clHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clCaptionText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    Transparent = False
  end
  object txtXFerPath: TEdit
    Left = 21
    Top = 51
    Width = 188
    Height = 21
    TabOrder = 1
  end
  object btnTransferBrowse: TButton
    Left = 214
    Top = 49
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 2
    OnClick = btnTransferBrowseClick
  end
  object chkIP: TCheckBox
    Left = 0
    Top = 136
    Width = 249
    Height = 17
    Caption = 'Use a custom IP address for HTTP transfers'
    TabOrder = 3
    OnClick = chkIPClick
  end
  object txtPort: TEdit
    Left = 21
    Top = 99
    Width = 140
    Height = 21
    TabOrder = 4
  end
  object txtIP: TEdit
    Left = 21
    Top = 155
    Width = 140
    Height = 21
    TabOrder = 5
  end
end
