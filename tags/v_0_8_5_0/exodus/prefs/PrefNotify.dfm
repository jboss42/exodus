inherited frmPrefNotify: TfrmPrefNotify
  Left = 267
  Top = 154
  Caption = 'frmPrefNotify'
  ClientHeight = 346
  ClientWidth = 338
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object lblConfigSounds: TLabel
    Left = 169
    Top = 32
    Width = 93
    Height = 13
    Cursor = crHandPoint
    Hint = 'Open Sounds Control Panel'
    Caption = 'Configure Sounds...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = lblConfigSoundsClick
  end
  object chkNotify: TCheckListBox
    Left = 8
    Top = 112
    Width = 257
    Height = 97
    ItemHeight = 13
    Items.Strings = (
      'Contact is online'
      'Contact is offline'
      'New chat session'
      'Normal Messages'
      'Subscription Requests'
      'Conference Invites'
      'Keywords (Conf. Rooms)'
      'Chat window activity'
      'Conf. Room activity'
      'File Transfers'
      'Auto Response generated')
    TabOrder = 4
    OnClick = chkNotifyClick
  end
  object optNotify: TGroupBox
    Left = 8
    Top = 216
    Width = 257
    Height = 103
    Caption = 'Notify Options'
    TabOrder = 5
    object chkFlash: TCheckBox
      Left = 8
      Top = 36
      Width = 209
      Height = 17
      Caption = 'Flash Taskbar button, or highlight tab'
      TabOrder = 1
      OnClick = chkToastClick
    end
    object chkToast: TCheckBox
      Left = 8
      Top = 16
      Width = 153
      Height = 17
      Caption = 'Show a "Toast" popup'
      TabOrder = 0
      OnClick = chkToastClick
    end
    object chkTrayNotify: TCheckBox
      Left = 8
      Top = 56
      Width = 209
      Height = 17
      Caption = 'Flash tray icon'
      TabOrder = 2
      OnClick = chkToastClick
    end
    object chkFront: TCheckBox
      Left = 8
      Top = 76
      Width = 209
      Height = 17
      Caption = 'Bring window to front'
      TabOrder = 3
      OnClick = chkToastClick
    end
  end
  object StaticText6: TStaticText
    Left = 0
    Top = 0
    Width = 338
    Height = 20
    Align = alTop
    Alignment = taCenter
    Caption = 'Notification Options'
    Color = clHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clCaptionText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 6
    Transparent = False
  end
  object chkSound: TCheckBox
    Left = 8
    Top = 32
    Width = 145
    Height = 17
    Caption = 'Use sound notifications'
    TabOrder = 0
    OnClick = chkSoundClick
  end
  object chkNotifyActive: TCheckBox
    Left = 8
    Top = 48
    Width = 249
    Height = 17
    Hint = 
      'NOTE: Notifications always occur when Exodus is in the backgroun' +
      'd.'
    Caption = 'Perform notifications when Exodus has focus'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object chkFlashInfinite: TCheckBox
    Left = 8
    Top = 82
    Width = 289
    Height = 17
    Caption = 'Flash taskbar continuously until the window gets focus.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object chkNotifyActiveWindow: TCheckBox
    Left = 8
    Top = 65
    Width = 209
    Height = 17
    Caption = 'Perform notifications for current window'
    TabOrder = 2
  end
end
