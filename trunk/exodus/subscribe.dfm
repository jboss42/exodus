object frmSubscribe: TfrmSubscribe
  Left = 250
  Top = 165
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  BorderWidth = 3
  Caption = 'Subscription Request'
  ClientHeight = 218
  ClientWidth = 322
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TTntLabel
    Left = 0
    Top = 35
    Width = 322
    Height = 26
    Align = alTop
    Caption = 
      'This person or agent would like to see your online presence and ' +
      'add you to their roster.'
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 0
    Top = 33
    Width = 322
    Height = 2
    Align = alTop
  end
  object chkSubscribe: TTntCheckBox
    Left = 8
    Top = 69
    Width = 217
    Height = 17
    Caption = 'Add this person to my roster'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = chkSubscribeClick
  end
  object boxAdd: TGroupBox
    Left = 24
    Top = 88
    Width = 289
    Height = 81
    TabOrder = 1
    object lblNickname: TTntLabel
      Left = 8
      Top = 16
      Width = 51
      Height = 13
      Caption = 'Nickname:'
    end
    object lblGroup: TTntLabel
      Left = 8
      Top = 48
      Width = 32
      Height = 13
      Caption = 'Group:'
    end
    object txtNickname: TTntEdit
      Left = 70
      Top = 14
      Width = 200
      Height = 21
      TabOrder = 0
    end
    object cboGroup: TTntComboBox
      Left = 70
      Top = 44
      Width = 200
      Height = 21
      ItemHeight = 13
      Sorted = True
      TabOrder = 1
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 182
    Width = 322
    Height = 36
    Align = alBottom
    TabOrder = 2
    TabStop = True
    ExplicitTop = 182
    ExplicitWidth = 322
    ExplicitHeight = 36
    inherited Panel2: TPanel
      Width = 322
      Height = 36
      ExplicitWidth = 322
      ExplicitHeight = 36
      inherited Bevel1: TBevel
        Width = 322
        ExplicitWidth = 322
      end
      inherited Panel1: TPanel
        Left = 162
        Height = 31
        ExplicitLeft = 162
        ExplicitHeight = 31
        inherited btnOK: TTntButton
          Caption = 'Accept'
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          Caption = 'Deny'
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 322
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object imgIdent: TImage
      Left = 0
      Top = 0
      Width = 33
      Height = 33
      Align = alLeft
      Center = True
      Transparent = True
    end
    object lblJID: TTntLabel
      Left = 33
      Top = 0
      Width = 289
      Height = 33
      Cursor = crHandPoint
      Align = alClient
      AutoSize = False
      Caption = 'lblJID'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      OnClick = lblJIDClick
    end
  end
  object PopupMenu1: TTntPopupMenu
    Left = 208
    Top = 56
    object mnuProfile: TTntMenuItem
      Caption = 'Show Profile'
      OnClick = mnuProfileClick
    end
    object mnuChat: TTntMenuItem
      Caption = 'Start Chat'
      OnClick = mnuChatClick
    end
    object mnuMessage: TTntMenuItem
      Caption = 'Send Message'
      OnClick = mnuMessageClick
    end
  end
end
