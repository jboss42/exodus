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
    Top = 121
    Width = 35
    Height = 13
    Caption = 'Format:'
  end
  object lblMsgOptions: TTntLabel [1]
    Left = 5
    Top = 257
    Width = 170
    Height = 13
    Caption = 'Simple message (non-chat) handling'
  end
  object lblSpoolPath: TTntLabel [2]
    Left = 5
    Top = 343
    Width = 128
    Height = 13
    Caption = 'Store Unread messages to:'
  end
  object lblInviteOptions: TTntLabel [3]
    Left = 5
    Top = 297
    Width = 198
    Height = 13
    Caption = 'When I get invited to a chat room, do this:'
  end
  object chkTimestamp: TTntCheckBox [4]
    Left = 5
    Top = 101
    Width = 300
    Height = 17
    Caption = 'Timestamp messages'
    TabOrder = 2
  end
  object chkLog: TTntCheckBox [5]
    Left = 5
    Top = 142
    Width = 97
    Height = 17
    Caption = 'Log Messages'
    TabOrder = 4
    OnClick = chkLogClick
  end
  object txtLogPath: TTntEdit [6]
    Left = 26
    Top = 160
    Width = 207
    Height = 21
    TabOrder = 5
  end
  object btnLogBrowse: TTntButton [7]
    Left = 243
    Top = 158
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 6
    OnClick = btnLogBrowseClick
  end
  object chkMsgQueue: TTntCheckBox [8]
    Left = 5
    Top = 28
    Width = 300
    Height = 17
    Caption = 'Instant Messages never popup a new window'
    TabOrder = 0
  end
  object chkLogRooms: TTntCheckBox [9]
    Left = 26
    Top = 184
    Width = 287
    Height = 17
    Caption = 'Log conference rooms'
    TabOrder = 7
  end
  object cboMsgOptions: TTntComboBox [10]
    Left = 26
    Top = 273
    Width = 207
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 10
    Items.WideStrings = (
      'Use default message handling'
      'Treat all messages as chats'
      'Put messages into existing chats')
  end
  object btnLogClearAll: TTntButton [11]
    Left = 26
    Top = 220
    Width = 102
    Height = 25
    Caption = 'Clear All Logs'
    TabOrder = 9
    OnClick = btnLogClearAllClick
  end
  object txtSpoolPath: TTntEdit [12]
    Left = 26
    Top = 359
    Width = 207
    Height = 21
    TabOrder = 12
  end
  object btnSpoolBrowse: TTntButton [13]
    Left = 243
    Top = 357
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 13
    OnClick = btnSpoolBrowseClick
  end
  object cboInviteOptions: TTntComboBox [14]
    Left = 26
    Top = 313
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
  object chkBlockNonRoster: TTntCheckBox [15]
    Left = 5
    Top = 44
    Width = 300
    Height = 17
    Caption = 'Block messages from people not on my roster'
    TabOrder = 1
  end
  object txtTimestampFmt: TTntComboBox [16]
    Left = 72
    Top = 118
    Width = 161
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'h:mm am/pm'
    Items.WideStrings = (
      'h:mm am/pm'
      'hh:mm'
      't'
      'tt')
  end
  object chkLogRoster: TTntCheckBox [17]
    Left = 26
    Top = 200
    Width = 287
    Height = 17
    Caption = 'Only log messages from people in my roster'
    TabOrder = 8
  end
  inherited pnlHeader: TTntPanel
    Width = 348
    Caption = 'Message Options'
    TabOrder = 14
  end
  object chkQueueDNDChats: TTntCheckBox
    Left = 5
    Top = 60
    Width = 300
    Height = 17
    Caption = 'Queue chat messages when in DND mode.'
    TabOrder = 15
  end
  object chkQueueOffline: TTntCheckBox
    Left = 5
    Top = 76
    Width = 300
    Height = 17
    Caption = 'Queue all offline messages (even chats)'
    TabOrder = 16
  end
  object OpenDialog1: TOpenDialog
    Filter = 'XML|*.xml'
    Options = [ofHideReadOnly, ofNoValidate, ofPathMustExist, ofEnableSizing]
    Title = 'Select a spool file'
    Left = 284
    Top = 28
  end
end
