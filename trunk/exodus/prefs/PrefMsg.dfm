inherited frmPrefMsg: TfrmPrefMsg
  Left = 277
  Top = 150
  Caption = 'frmPrefMsg'
  ClientHeight = 399
  ClientWidth = 348
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label19: TLabel
    Left = 26
    Top = 93
    Width = 35
    Height = 13
    Caption = 'Format:'
  end
  object Label7: TLabel
    Left = 5
    Top = 181
    Width = 170
    Height = 13
    Caption = 'Simple message (non-chat) handling'
  end
  object Label16: TLabel
    Left = 5
    Top = 267
    Width = 128
    Height = 13
    Caption = 'Store Unread messages to:'
  end
  object Label17: TLabel
    Left = 5
    Top = 221
    Width = 198
    Height = 13
    Caption = 'When I get invited to a chat room, do this:'
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
    Top = 73
    Width = 156
    Height = 17
    Caption = 'Timestamp messages'
    TabOrder = 1
  end
  object chkLog: TCheckBox
    Left = 5
    Top = 114
    Width = 97
    Height = 17
    Caption = 'Log Messages'
    TabOrder = 2
    OnClick = chkLogClick
  end
  object txtLogPath: TEdit
    Left = 26
    Top = 132
    Width = 207
    Height = 21
    TabOrder = 3
  end
  object StaticText11: TStaticText
    Left = 0
    Top = 0
    Width = 348
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
  object btnLogBrowse: TButton
    Left = 243
    Top = 130
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 5
    OnClick = btnLogBrowseClick
  end
  object chkMsgQueue: TCheckBox
    Left = 5
    Top = 40
    Width = 284
    Height = 17
    Caption = 'Instant Messages never popup a new window'
    TabOrder = 6
  end
  object chkLogRooms: TCheckBox
    Left = 26
    Top = 156
    Width = 151
    Height = 17
    Caption = 'Log conference rooms'
    TabOrder = 7
  end
  object cboMsgOptions: TComboBox
    Left = 26
    Top = 197
    Width = 207
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
    Items.Strings = (
      'Use default message handling'
      'Treat all messages as chats'
      'Put messages into existing chats')
  end
  object btnLogClearAll: TButton
    Left = 243
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Clear All Logs'
    TabOrder = 9
    OnClick = btnLogClearAllClick
  end
  object txtSpoolPath: TEdit
    Left = 26
    Top = 283
    Width = 207
    Height = 21
    TabOrder = 10
  end
  object btnSpoolBrowse: TButton
    Left = 243
    Top = 281
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 11
    OnClick = btnSpoolBrowseClick
  end
  object cboInviteOptions: TComboBox
    Left = 26
    Top = 237
    Width = 207
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 12
    Items.Strings = (
      'Treat as a normal instant message'
      'Always popup the invitation'
      'Automatically join the room.')
  end
  object chkBlockNonRoster: TCheckBox
    Left = 5
    Top = 56
    Width = 252
    Height = 17
    Caption = 'Block messages from people not on my roster'
    TabOrder = 13
  end
  object txtTimestampFmt: TComboBox
    Left = 72
    Top = 90
    Width = 161
    Height = 21
    ItemHeight = 13
    TabOrder = 14
    Text = 'h:mm am/pm'
    Items.Strings = (
      'h:mm am/pm'
      'hh:mm'
      't'
      'tt')
  end
  object OpenDialog1: TOpenDialog
    Filter = 'XML|*.xml'
    Options = [ofHideReadOnly, ofNoValidate, ofPathMustExist, ofEnableSizing]
    Title = 'Select a spool file'
    Left = 284
    Top = 28
  end
end
