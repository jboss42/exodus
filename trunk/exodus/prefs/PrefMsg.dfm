inherited frmPrefMsg: TfrmPrefMsg
  Left = 231
  Top = 151
  Caption = 'frmPrefMsg'
  ClientHeight = 399
  ClientWidth = 406
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label19: TLabel
    Left = 26
    Top = 109
    Width = 35
    Height = 13
    Caption = 'Format:'
  end
  object Label7: TLabel
    Left = 5
    Top = 197
    Width = 170
    Height = 13
    Caption = 'Simple message (non-chat) handling'
  end
  object Label16: TLabel
    Left = 5
    Top = 283
    Width = 85
    Height = 13
    Caption = 'Event Queue File:'
  end
  object Label17: TLabel
    Left = 5
    Top = 237
    Width = 153
    Height = 13
    Caption = 'Text Conference invite handling:'
  end
  object chkEmoticons: TCheckBox
    Left = 5
    Top = 24
    Width = 241
    Height = 17
    Caption = 'Auto detect Emoticons in messages'
    TabOrder = 0
  end
  object chkTimestamp: TCheckBox
    Left = 5
    Top = 89
    Width = 156
    Height = 17
    Caption = 'Timestamp messages'
    TabOrder = 1
  end
  object chkLog: TCheckBox
    Left = 5
    Top = 130
    Width = 97
    Height = 17
    Caption = 'Log Messages'
    TabOrder = 2
    OnClick = chkLogClick
  end
  object txtLogPath: TEdit
    Left = 26
    Top = 148
    Width = 207
    Height = 21
    TabOrder = 3
  end
  object StaticText11: TStaticText
    Left = 0
    Top = 0
    Width = 406
    Height = 20
    Align = alTop
    Alignment = taCenter
    Caption = 'Message Options'
    Color = clHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clCaptionText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 4
    Transparent = False
  end
  object txtTimestampFmt: TEdit
    Left = 69
    Top = 106
    Width = 164
    Height = 21
    TabOrder = 5
  end
  object btnLogBrowse: TButton
    Left = 243
    Top = 146
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 6
    OnClick = btnLogBrowseClick
  end
  object chkMsgQueue: TCheckBox
    Left = 5
    Top = 40
    Width = 284
    Height = 17
    Caption = 'Messages, Events always goto the Events Window'
    TabOrder = 7
  end
  object chkLogRooms: TCheckBox
    Left = 26
    Top = 172
    Width = 151
    Height = 17
    Caption = 'Log conference rooms'
    TabOrder = 8
  end
  object cboMsgOptions: TComboBox
    Left = 26
    Top = 213
    Width = 207
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 9
    Items.Strings = (
      'Use default message handling'
      'Treat all messages as chats'
      'Put messages into existing chats')
  end
  object btnLogClearAll: TButton
    Left = 243
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Clear All Logs'
    TabOrder = 10
    OnClick = btnLogClearAllClick
  end
  object chkCloseQueue: TCheckBox
    Left = 5
    Top = 56
    Width = 276
    Height = 17
    Caption = 'Close the Event window going to Compressed Mode'
    TabOrder = 11
  end
  object txtSpoolPath: TEdit
    Left = 26
    Top = 299
    Width = 207
    Height = 21
    TabOrder = 12
  end
  object btnSpoolBrowse: TButton
    Left = 243
    Top = 297
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 13
    OnClick = btnSpoolBrowseClick
  end
  object cboInviteOptions: TComboBox
    Left = 26
    Top = 253
    Width = 207
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 14
    Items.Strings = (
      'Treat as a normal event'
      'Always popup window'
      'Auto-Accept all invites')
  end
  object chkBlockNonRoster: TCheckBox
    Left = 5
    Top = 72
    Width = 252
    Height = 17
    Caption = 'Block messages from people not on my roster'
    TabOrder = 15
  end
  object OpenDialog1: TOpenDialog
    Filter = 'XML|*.xml'
    Options = [ofHideReadOnly, ofNoValidate, ofPathMustExist, ofEnableSizing]
    Title = 'Select a spool file'
    Left = 284
    Top = 28
  end
end
