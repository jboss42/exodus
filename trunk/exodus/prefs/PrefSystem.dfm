object frmPrefSystem: TfrmPrefSystem
  Left = 343
  Top = 450
  Width = 327
  Height = 318
  BorderWidth = 6
  Caption = 'frmPrefSystem'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label15: TLabel
    Left = 8
    Top = 219
    Width = 149
    Height = 13
    Caption = 'File transfer download directory:'
  end
  object StaticText4: TStaticText
    Left = 0
    Top = 0
    Width = 307
    Height = 20
    Align = alTop
    Alignment = taCenter
    Caption = 'System Options'
    Color = clHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clCaptionText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
  end
  object chkAutoUpdate: TCheckBox
    Left = 8
    Top = 196
    Width = 233
    Height = 17
    Caption = 'Check for updates automatically'
    TabOrder = 1
  end
  object chkExpanded: TCheckBox
    Left = 8
    Top = 68
    Width = 169
    Height = 17
    Caption = 'Start in Expanded Mode'
    TabOrder = 2
  end
  object chkDebug: TCheckBox
    Left = 8
    Top = 86
    Width = 169
    Height = 17
    Caption = 'Start with Debug visible'
    TabOrder = 3
  end
  object chkAutoLogin: TCheckBox
    Left = 8
    Top = 32
    Width = 241
    Height = 17
    Caption = 'Automatically login with last profile'
    TabOrder = 4
  end
  object chkCloseMin: TCheckBox
    Left = 8
    Top = 158
    Width = 241
    Height = 17
    Caption = 'Close button minimizes to the tray'
    TabOrder = 5
  end
  object txtXFerPath: TEdit
    Left = 29
    Top = 237
    Width = 188
    Height = 21
    TabOrder = 6
  end
  object btnTransferBrowse: TButton
    Left = 222
    Top = 235
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 7
    OnClick = btnTransferBrowseClick
  end
  object chkAutoStart: TCheckBox
    Left = 8
    Top = 50
    Width = 233
    Height = 17
    Caption = 'Run Exodus when windows starts'
    TabOrder = 8
  end
  object chkOnTop: TCheckBox
    Left = 8
    Top = 122
    Width = 169
    Height = 17
    Caption = 'Exodus is always on top'
    TabOrder = 9
  end
  object chkToolbox: TCheckBox
    Left = 8
    Top = 140
    Width = 217
    Height = 17
    Caption = 'Small Titlebar for Exodus window'
    TabOrder = 10
  end
  object btnUpdateCheck: TButton
    Left = 222
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Check Now'
    TabOrder = 11
    OnClick = btnUpdateCheckClick
    OnMouseUp = btnUpdateCheckMouseUp
  end
  object chkSingleInstance: TCheckBox
    Left = 8
    Top = 177
    Width = 209
    Height = 17
    Caption = 'Only allow a single instance of Exodus'
    TabOrder = 12
  end
  object chkStartMin: TCheckBox
    Left = 8
    Top = 104
    Width = 225
    Height = 17
    Caption = 'Start minimized to the system tray'
    TabOrder = 13
  end
end
