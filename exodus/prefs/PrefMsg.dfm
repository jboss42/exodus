inherited frmPrefMsg: TfrmPrefMsg
  Left = 282
  Top = 230
  Caption = 'frmPrefMsg'
  ClientHeight = 426
  ClientWidth = 348
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object lblTimestampFmt: TTntLabel [0]
    Left = 26
    Top = 98
    Width = 35
    Height = 13
    Caption = 'Format:'
  end
  object lblMsgOptions: TTntLabel [1]
    Left = 5
    Top = 234
    Width = 170
    Height = 13
    Caption = 'Simple message (non-chat) handling'
  end
  object lblSpoolPath: TTntLabel [2]
    Left = 5
    Top = 320
    Width = 128
    Height = 13
    Caption = 'Store Unread messages to:'
  end
  object lblInviteOptions: TTntLabel [3]
    Left = 5
    Top = 274
    Width = 198
    Height = 13
    Caption = 'When I get invited to a chat room, do this:'
  end
  object chkEmoticons: TTntCheckBox [4]
    Left = 5
    Top = 29
    Width = 300
    Height = 17
    Caption = 'Auto detect Emoticons in messages'
    TabOrder = 0
  end
  object chkTimestamp: TTntCheckBox [5]
    Left = 5
    Top = 78
    Width = 300
    Height = 17
    Caption = 'Timestamp messages'
    TabOrder = 3
  end
  object chkLog: TTntCheckBox [6]
    Left = 5
    Top = 119
    Width = 97
    Height = 17
    Caption = 'Log Messages'
    TabOrder = 5
    OnClick = chkLogClick
  end
  object txtLogPath: TTntEdit [7]
    Left = 26
    Top = 137
    Width = 207
    Height = 21
    TabOrder = 6
  end
  object btnLogBrowse: TTntButton [8]
    Left = 243
    Top = 135
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 7
    OnClick = btnLogBrowseClick
  end
  object chkMsgQueue: TTntCheckBox [9]
    Left = 5
    Top = 45
    Width = 300
    Height = 17
    Caption = 'Instant Messages never popup a new window'
    TabOrder = 1
  end
  object chkLogRooms: TTntCheckBox [10]
    Left = 26
    Top = 161
    Width = 287
    Height = 17
    Caption = 'Log conference rooms'
    TabOrder = 8
  end
  object cboMsgOptions: TTntComboBox [11]
    Left = 26
    Top = 250
    Width = 207
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 11
    Items.WideStrings = (
      'Use default message handling'
      'Treat all messages as chats'
      'Put messages into existing chats')
  end
  object btnLogClearAll: TTntButton [12]
    Left = 26
    Top = 197
    Width = 102
    Height = 25
    Caption = 'Clear All Logs'
    TabOrder = 10
    OnClick = btnLogClearAllClick
  end
  object txtSpoolPath: TTntEdit [13]
    Left = 26
    Top = 336
    Width = 207
    Height = 21
    TabOrder = 13
  end
  object btnSpoolBrowse: TTntButton [14]
    Left = 243
    Top = 334
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 14
    OnClick = btnSpoolBrowseClick
  end
  object cboInviteOptions: TTntComboBox [15]
    Left = 26
    Top = 290
    Width = 207
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 12
    Items.WideStrings = (
      'Treat as a normal instant message'
      'Always popup the invitation'
      'Automatically join the room.')
  end
  object chkBlockNonRoster: TTntCheckBox [16]
    Left = 5
    Top = 61
    Width = 300
    Height = 17
    Caption = 'Block messages from people not on my roster'
    TabOrder = 2
  end
  object txtTimestampFmt: TTntComboBox [17]
    Left = 72
    Top = 95
    Width = 161
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = 'h:mm am/pm'
    Items.WideStrings = (
      'h:mm am/pm'
      'hh:mm'
      't'
      'tt')
  end
  object chkLogRoster: TTntCheckBox [18]
    Left = 26
    Top = 177
    Width = 287
    Height = 17
    Caption = 'Only log messages from people in my roster'
    TabOrder = 9
  end
  inherited pnlHeader: TTntPanel
    Width = 348
    Caption = 'Message Options'
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
