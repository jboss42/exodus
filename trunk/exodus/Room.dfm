inherited frmRoom: TfrmRoom
  Left = 260
  Top = 271
  Width = 395
  Height = 305
  Caption = 'Conference Room'
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Top = 244
    Width = 387
  end
  inherited Panel3: TPanel
    Top = 23
    Width = 387
    Height = 221
    TabOrder = 1
    object Splitter2: TSplitter [0]
      Left = 275
      Top = 4
      Height = 213
      Align = alRight
      ResizeStyle = rsUpdate
    end
    inherited MsgList: TExRichEdit
      Width = 271
      Height = 213
      Font.Name = 'Arial'
      ParentFont = False
      PopupMenu = popRoom
      OnDragDrop = lstRosterDragDrop
      OnDragOver = lstRosterDragOver
      PlainRTF = True
    end
    object Panel6: TPanel
      Left = 278
      Top = 4
      Width = 105
      Height = 213
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 1
      Caption = '`'
      TabOrder = 1
      object lstRoster: TTntListView
        Left = 1
        Top = 1
        Width = 103
        Height = 211
        Align = alClient
        Columns = <
          item
            AutoSize = True
            Caption = 'foo'
          end>
        IconOptions.Arrangement = iaLeft
        IconOptions.WrapText = False
        MultiSelect = True
        OwnerData = True
        OwnerDraw = True
        ReadOnly = True
        ParentShowHint = False
        PopupMenu = popRoomRoster
        ShowColumnHeaders = False
        ShowWorkAreas = True
        ShowHint = True
        SmallImages = frmExodus.ImageList2
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
        OnCustomDrawItem = lstRosterCustomDrawItem
        OnData = lstRosterData
        OnDblClick = lstRosterDblClick
        OnDragDrop = lstRosterDragDrop
        OnDragOver = lstRosterDragOver
        OnInfoTip = lstRosterInfoTip
        OnKeyPress = lstRosterKeyPress
      end
    end
  end
  inherited pnlInput: TPanel
    Top = 247
    Width = 387
    AutoSize = True
    TabOrder = 0
    inherited MsgOut: TExRichEdit
      Width = 383
    end
  end
  inherited Panel1: TPanel
    Width = 387
    Height = 23
    BorderWidth = 1
    object btnClose: TSpeedButton
      Left = 356
      Top = 2
      Width = 23
      Height = 20
      Caption = 'X'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
      OnClick = btnCloseClick
    end
    object pnlSubj: TPanel
      Left = 1
      Top = 1
      Width = 352
      Height = 21
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblSubjectURL: TTntLabel
        Left = 0
        Top = 0
        Width = 39
        Height = 21
        Cursor = crHandPoint
        Align = alLeft
        Caption = 'Subject:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        Layout = tlCenter
        OnClick = lblSubjectURLClick
      end
      object lblSubject: TTntLabel
        Left = 39
        Top = 0
        Width = 314
        Height = 21
        Align = alLeft
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoSize = False
        Caption = ' lblSubject'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Layout = tlCenter
      end
    end
  end
  inherited popMsgList: TTntPopupMenu
    AutoHotkeys = maManual
  end
  inherited popOut: TTntPopupMenu
    AutoHotkeys = maManual
  end
  object popRoom: TTntPopupMenu
    AutoHotkeys = maManual
    Left = 16
    Top = 152
    object popClear: TTntMenuItem
      Caption = 'Clear Window'
      OnClick = popClearClick
    end
    object popShowHistory: TTntMenuItem
      Caption = 'Show History'
      OnClick = popShowHistoryClick
    end
    object popClearHistory: TTntMenuItem
      Caption = 'Clear History'
      OnClick = popClearHistoryClick
    end
    object popBookmark: TTntMenuItem
      Caption = 'Bookmark Room...'
      OnClick = popBookmarkClick
    end
    object popRegister: TTntMenuItem
      Caption = 'Register with Room...'
      OnClick = popRegisterClick
    end
    object popInvite: TTntMenuItem
      Caption = 'Invite Contacts...'
      OnClick = popInviteClick
    end
    object popNick: TTntMenuItem
      Caption = 'Change Nickname...'
      OnClick = popNickClick
    end
    object S1: TTntMenuItem
      Caption = 'Save As...'
      OnClick = S1Click
    end
    object popAdmin: TTntMenuItem
      Caption = 'Admin'
      Enabled = False
      object popVoiceList: TTntMenuItem
        Caption = 'Edit Voice List'
        OnClick = popVoiceListClick
      end
      object popBanList: TTntMenuItem
        Caption = 'Edit Ban List'
        OnClick = popVoiceListClick
      end
      object popMemberList: TTntMenuItem
        Caption = 'Edit Member List'
        OnClick = popVoiceListClick
      end
      object popModeratorList: TTntMenuItem
        Caption = 'Edit Moderator List'
        OnClick = popVoiceListClick
      end
      object N4: TTntMenuItem
        Caption = '-'
      end
      object popAdminList: TTntMenuItem
        Caption = 'Edit Admin List'
        OnClick = popVoiceListClick
      end
      object popOwnerList: TTntMenuItem
        Caption = 'Edit Owner List'
        OnClick = popVoiceListClick
      end
      object N5: TTntMenuItem
        Caption = '-'
      end
      object popConfigure: TTntMenuItem
        Caption = 'Configure Room'
        OnClick = popConfigureClick
      end
      object popDestroy: TTntMenuItem
        Caption = 'Destroy Room'
        OnClick = popDestroyClick
      end
    end
    object N1: TTntMenuItem
      Caption = '-'
    end
    object NotificationOptions1: TTntMenuItem
      Caption = 'Notification Options ...'
      OnClick = NotificationOptions1Click
    end
    object mnuWordwrap: TTntMenuItem
      Caption = 'Word Wrap Input'
      OnClick = mnuWordwrapClick
    end
    object mnuOnTop: TTntMenuItem
      Caption = 'Always on Top'
      OnClick = mnuOnTopClick
    end
    object popClose: TTntMenuItem
      Caption = 'Close Room'
      OnClick = popCloseClick
    end
    object N6: TTntMenuItem
      Caption = '-'
    end
  end
  object popRoomRoster: TTntPopupMenu
    AutoHotkeys = maManual
    OnPopup = popRoomRosterPopup
    Left = 48
    Top = 152
    object popRosterMsg: TTntMenuItem
      Caption = 'Message'
      OnClick = popRosterMsgClick
    end
    object popRosterChat: TTntMenuItem
      Caption = 'Chat'
      OnClick = lstRosterDblClick
    end
    object popRosterSendJID: TTntMenuItem
      Caption = 'Send my JID'
      OnClick = popRosterSendJIDClick
    end
    object popRosterBlock: TTntMenuItem
      Caption = 'Block'
      OnClick = popRosterBlockClick
    end
    object N7: TTntMenuItem
      Caption = '-'
    end
    object popRosterSubscribe: TTntMenuItem
      Caption = 'Add contact to my roster'
      Enabled = False
      OnClick = popRosterSubscribeClick
    end
    object popRosterVCard: TTntMenuItem
      Caption = 'Lookup vCard'
      Enabled = False
      OnClick = popRosterVCardClick
    end
    object N3: TTntMenuItem
      Caption = '-'
    end
    object popKick: TTntMenuItem
      Caption = 'Kick'
      Enabled = False
      OnClick = popKickClick
    end
    object popBan: TTntMenuItem
      Caption = 'Ban'
      Enabled = False
      OnClick = popKickClick
    end
    object popVoice: TTntMenuItem
      Caption = 'Toggle Voice'
      Enabled = False
      OnClick = popVoiceClick
    end
    object popModerator: TTntMenuItem
      Caption = 'Make Moderator'
      Enabled = False
      OnClick = popKickClick
    end
    object popAdministrator: TTntMenuItem
      Caption = 'Make Administrator'
      Enabled = False
      OnClick = popKickClick
    end
  end
  object dlgSave: TSaveDialog
    DefaultExt = '.rtf'
    Filter = 'RTF (*.rtf)|*.rtf|Text (*.txt)|*.txt'
    FilterIndex = 0
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save Room Contents'
    Left = 49
    Top = 89
  end
end
