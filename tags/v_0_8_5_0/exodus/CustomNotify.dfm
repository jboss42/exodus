object frmCustomNotify: TfrmCustomNotify
  Left = 240
  Top = 208
  Width = 334
  Height = 298
  BorderWidth = 4
  Caption = 'Custom Notification Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 192
    Width = 146
    Height = 13
    Cursor = crHandPoint
    Caption = 'Reset to default preferences ...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label1Click
  end
  object chkNotify: TCheckListBox
    Left = 16
    Top = 8
    Width = 257
    Height = 65
    ItemHeight = 13
    TabOrder = 0
    OnClick = chkNotifyClick
  end
  object optNotify: TGroupBox
    Left = 16
    Top = 85
    Width = 257
    Height = 97
    Caption = 'Notify Options'
    TabOrder = 1
    object chkFlash: TCheckBox
      Left = 8
      Top = 48
      Width = 209
      Height = 17
      Caption = 'Flash Taskbar button, or highlight tab'
      TabOrder = 1
      OnClick = chkToastClick
    end
    object chkToast: TCheckBox
      Left = 8
      Top = 24
      Width = 153
      Height = 17
      Caption = 'Show a "Toast" popup'
      TabOrder = 0
      OnClick = chkToastClick
    end
    object chkTrayNotify: TCheckBox
      Left = 8
      Top = 71
      Width = 209
      Height = 17
      Caption = 'Flash tray icon'
      TabOrder = 2
      OnClick = chkToastClick
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 231
    Width = 318
    Height = 30
    Align = alBottom
    AutoScroll = False
    TabOrder = 2
    inherited Bevel1: TBevel
      Width = 318
    end
    inherited Panel1: TPanel
      Left = 158
    end
  end
end
