inherited frmSubscribe: TfrmSubscribe
  Left = 250
  Top = 165
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  BorderWidth = 3
  Caption = 'Subscription Request'
  ClientHeight = 265
  ClientWidth = 404
  Position = poMainFormCenter
  OnClose = FormClose
  ExplicitWidth = 416
  ExplicitHeight = 309
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TTntLabel
    Left = 0
    Top = 43
    Width = 404
    Height = 32
    Align = alTop
    Caption = 
      'This person or agent would like to see your online presence and ' +
      'add you to their contact list.'
    WordWrap = True
    ExplicitWidth = 396
  end
  object Bevel1: TBevel
    Left = 0
    Top = 41
    Width = 404
    Height = 2
    Align = alTop
  end
  object chkSubscribe: TTntCheckBox
    Left = 10
    Top = 85
    Width = 267
    Height = 21
    Caption = 'Add this person to my contact list'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = chkSubscribeClick
  end
  object boxAdd: TGroupBox
    Left = 30
    Top = 108
    Width = 355
    Height = 100
    TabOrder = 1
    object lblNickname: TTntLabel
      Left = 10
      Top = 20
      Width = 60
      Height = 16
      Caption = 'Nickname:'
    end
    object lblGroup: TTntLabel
      Left = 10
      Top = 59
      Width = 39
      Height = 16
      Caption = 'Group:'
    end
    object txtNickname: TTntEdit
      Left = 86
      Top = 17
      Width = 246
      Height = 24
      TabOrder = 0
    end
    object cboGroup: TTntComboBox
      Left = 86
      Top = 54
      Width = 246
      Height = 24
      ItemHeight = 16
      Sorted = True
      TabOrder = 1
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 220
    Width = 404
    Height = 45
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    TabStop = True
    ExplicitTop = 220
    ExplicitWidth = 404
    ExplicitHeight = 45
    inherited Panel2: TPanel
      Width = 404
      Height = 45
      ExplicitWidth = 404
      ExplicitHeight = 45
      inherited Bevel1: TBevel
        Width = 404
        Height = 6
        ExplicitWidth = 404
        ExplicitHeight = 6
      end
      inherited Panel1: TPanel
        Left = 207
        Top = 6
        Width = 197
        Height = 39
        ExplicitLeft = 207
        ExplicitTop = 6
        ExplicitWidth = 197
        ExplicitHeight = 39
        inherited btnOK: TTntButton
          Left = 5
          Width = 92
          Height = 31
          Caption = 'Accept'
          OnClick = frameButtons1btnOKClick
          ExplicitLeft = 5
          ExplicitWidth = 92
          ExplicitHeight = 31
        end
        inherited btnCancel: TTntButton
          Left = 101
          Width = 92
          Height = 31
          Caption = 'Deny'
          OnClick = frameButtons1btnCancelClick
          ExplicitLeft = 101
          ExplicitWidth = 92
          ExplicitHeight = 31
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 404
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    object imgIdent: TImage
      Left = 0
      Top = 0
      Width = 41
      Height = 41
      Align = alLeft
      Center = True
      Transparent = True
    end
    object lblJID: TTntLabel
      Left = 41
      Top = 0
      Width = 363
      Height = 41
      Cursor = crHandPoint
      Align = alClient
      AutoSize = False
      Caption = 'lblJID'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -17
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
  end
end
