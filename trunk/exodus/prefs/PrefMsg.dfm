inherited frmPrefMsg: TfrmPrefMsg
  Left = 277
  Top = 150
  Caption = 'frmPrefMsg'
  ClientHeight = 366
  ClientWidth = 348
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label19: TTntLabel
    Left = 26
    Top = 93
    Width = 35
    Height = 13
    Caption = 'Format:'
  end
  object Label7: TTntLabel
    Left = 5
    Top = 229
    Width = 287
    Height = 13
    Caption = 'Simple message (non-chat) handling'
  end
  object Label16: TTntLabel
    Left = 5
    Top = 315
    Width = 287
    Height = 13
    Caption = 'Store Unread messages to:'
  end
  object Label17: TTntLabel
    Left = 5
    Top = 269
    Width = 287
    Height = 13
    Caption = 'When I get invited to a chat room, do this:'
  end
  object chkEmoticons: TTntCheckBox
    Left = 5
    Top = 24
    Width = 300
    Height = 17
    Caption = 'Auto detect Emoticons in messages'
    TabOrder = 0
  end
  object chkTimestamp: TTntCheckBox
    Left = 5
    Top = 73
    Width = 300
    Height = 17
    Caption = 'Timestamp messages'
    TabOrder = 1
  end
  object chkLog: TTntCheckBox
    Left = 5
    Top = 114
    Width = 97
    Height = 17
    Caption = 'Log Messages'
    TabOrder = 2
    OnClick = chkLogClick
  end
  object txtLogPath: TTntEdit
    Left = 26
    Top = 132
    Width = 207
    Height = 21
    TabOrder = 3
  end
  object btnLogBrowse: TTntButton
    Left = 243
    Top = 130
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 4
    OnClick = btnLogBrowseClick
  end
  object chkMsgQueue: TTntCheckBox
    Left = 5
    Top = 40
    Width = 300
    Height = 17
    Caption = 'Instant Messages never popup a new window'
    TabOrder = 5
  end
  object chkLogRooms: TTntCheckBox
    Left = 26
    Top = 156
    Width = 287
    Height = 17
    Caption = 'Log conference rooms'
    TabOrder = 6
  end
  object cboMsgOptions: TTntComboBox
    Left = 26
    Top = 245
    Width = 207
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    Items.WideStrings = (
      'Use default message handling'
      'Treat all messages as chats'
      'Put messages into existing chats')
  end
  object btnLogClearAll: TTntButton
    Left = 26
    Top = 192
    Width = 102
    Height = 25
    Caption = 'Clear All Logs'
    TabOrder = 8
    OnClick = btnLogClearAllClick
  end
  object txtSpoolPath: TTntEdit
    Left = 26
    Top = 331
    Width = 207
    Height = 21
    TabOrder = 9
  end
  object btnSpoolBrowse: TTntButton
    Left = 243
    Top = 329
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 10
    OnClick = btnSpoolBrowseClick
  end
  object cboInviteOptions: TTntComboBox
    Left = 26
    Top = 285
    Width = 207
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 11
    Items.WideStrings = (
      'Treat as a normal instant message'
      'Always popup the invitation'
      'Automatically join the room.')
  end
  object chkBlockNonRoster: TTntCheckBox
    Left = 5
    Top = 56
    Width = 300
    Height = 17
    Caption = 'Block messages from people not on my roster'
    TabOrder = 12
  end
  object txtTimestampFmt: TTntComboBox
    Left = 72
    Top = 90
    Width = 161
    Height = 21
    ItemHeight = 13
    TabOrder = 13
    Text = 'h:mm am/pm'
    Items.WideStrings = (
      'h:mm am/pm'
      'hh:mm'
      't'
      'tt')
  end
  object StaticText4: TTntPanel
    Left = 0
    Top = 0
    Width = 348
    Height = 24
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Message Options'
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 14
  end
  object chkLogRoster: TTntCheckBox
    Left = 26
    Top = 172
    Width = 287
    Height = 17
    Caption = 'Only log messages from people in my roster'
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
