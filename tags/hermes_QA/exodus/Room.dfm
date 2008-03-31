inherited frmRoom: TfrmRoom
  Left = 252
  Top = 264
  Caption = 'Conference Room'
  ClientHeight = 416
  ClientWidth = 492
  OldCreateOrder = True
  ExplicitWidth = 500
  ExplicitHeight = 444
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Top = 347
    Width = 492
    ExplicitTop = 352
    ExplicitWidth = 492
  end
  inherited pnlDockTop: TPanel
    Width = 492
    TabOrder = 1
    ExplicitWidth = 492
    inherited tbDockBar: TToolBar
      Left = 443
      ExplicitLeft = 443
    end
    inherited pnlChatTop: TPanel
      Width = 440
      ExplicitWidth = 440
      object pnlSubj: TPanel
        Left = 0
        Top = 0
        Width = 352
        Height = 33
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object lblSubject: TTntLabel
          Left = 27
          Top = 5
          Width = 289
          Height = 21
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
        object SpeedButton1: TSpeedButton
          Left = 1
          Top = 7
          Width = 20
          Height = 19
          Flat = True
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
            DADAAD77777777777777D000000000000007A0FBFBFBFB00FB07D0BFBFBFBF08
            0F07A0F0F0F0FB0B8007D0BFBFB00F000007A0FBFBF0B0FBFB07D0BFBFB0B0BF
            BF07A0FBFBF0BB0BFB07D0BFBFB0BB0FBF07A00000000BB0000DDADADADA0BB0
            DADAADADADADA0000DADDADADADAD0110ADAADADADADAD00ADAD}
          ParentShowHint = False
          ShowHint = True
          Transparent = False
          OnClick = lblSubjectURLClick
        end
      end
    end
  end
  inherited pnlMsgList: TPanel
    Width = 492
    Height = 314
    TabOrder = 2
    ExplicitWidth = 492
    ExplicitHeight = 314
    object Splitter2: TSplitter
      Left = 380
      Top = 4
      Width = 4
      Height = 306
      Align = alRight
      ResizeStyle = rsUpdate
      ExplicitHeight = 311
    end
    object Panel6: TPanel
      Left = 384
      Top = 4
      Width = 104
      Height = 306
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 1
      Caption = '`'
      TabOrder = 0
      object lstRoster: TTntListView
        Left = 1
        Top = 1
        Width = 102
        Height = 304
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
        SmallImages = frmExodus.ImageList1
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
        OnCustomDrawItem = lstRosterCustomDrawItem
        OnData = lstRosterData
        OnDblClick = lstRosterDblClick
        OnDragDrop = OnDockedDragDrop
        OnDragOver = OnDockedDragOver
        OnInfoTip = lstRosterInfoTip
        OnKeyPress = lstRosterKeyPress
      end
    end
  end
  inherited pnlInput: TPanel
    Top = 351
    Width = 492
    TabOrder = 0
    ExplicitTop = 351
    ExplicitWidth = 492
    inherited MsgOut: TExRichEdit
      Width = 488
    end
    inherited tbMsgOutToolbar: TTntToolBar
      Width = 488
      ExplicitWidth = 488
    end
  end
  inherited popMsgList: TTntPopupMenu
    AutoHotkeys = maManual
  end
  inherited popOut: TTntPopupMenu
    AutoHotkeys = maManual
  end
  inherited AppEvents: TApplicationEvents
    Left = 112
  end
  object popRoom: TTntPopupMenu
    AutoHotkeys = maManual
    Left = 16
    Top = 152
    object popCopy: TTntMenuItem
      Caption = 'Copy'
      OnClick = popCopyClick
    end
    object popCopyAll: TTntMenuItem
      Caption = 'Copy All'
      OnClick = popCopyAllClick
    end
    object Print1: TTntMenuItem
      Caption = 'Print ...'
      OnClick = Print1Click
    end
    object N8: TTntMenuItem
      Caption = '-'
    end
    object popClear: TTntMenuItem
      Caption = 'Clear Window'
      OnClick = popClearClick
    end
    object popBookmark: TTntMenuItem
      Caption = 'Bookmark Conference Room...'
      OnClick = popBookmarkClick
    end
    object popRegister: TTntMenuItem
      Caption = 'Register with Conference Room...'
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
        Caption = 'Configure Conference Room'
        OnClick = popConfigureClick
      end
      object popDestroy: TTntMenuItem
        Caption = 'Destroy Conference Room'
        OnClick = popDestroyClick
      end
    end
    object N1: TTntMenuItem
      Caption = '-'
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
      Caption = 'Add contact to my contact list'
      Enabled = False
      OnClick = popRosterSubscribeClick
    end
    object popRosterVCard: TTntMenuItem
      Caption = 'Contact'#39's Profile'
      Enabled = False
      OnClick = popRosterVCardClick
    end
    object popRosterBrowse: TTntMenuItem
      Caption = 'Browse contact'
      Enabled = False
      OnClick = popRosterBrowseClick
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
    Title = 'Save Conference Room Contents'
    Left = 49
    Top = 89
  end
  object PrintDialog1: TPrintDialog
    Options = [poSelection]
    Left = 80
    Top = 87
  end
end
