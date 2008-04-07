inherited frmInviteReceived: TfrmInviteReceived
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Conference Room Invitation'
  ClientHeight = 168
  ClientWidth = 537
  Position = poDefault
  OnCreate = TntFormCreate
  OnDestroy = TntFormDestroy
  OnShow = TntFormShow
  ExplicitWidth = 543
  ExplicitHeight = 206
  PixelsPerInch = 120
  TextHeight = 16
  object pnlHeader: TFlowPanel
    AlignWithMargins = True
    Left = 3
    Top = 9
    Width = 531
    Height = 19
    Margins.Top = 9
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object lblInvitor: TTntLabel
      AlignWithMargins = True
      Left = 6
      Top = 0
      Width = 69
      Height = 16
      Margins.Left = 6
      Margins.Top = 0
      Align = alLeft
      Caption = '<<Name>>'
      ParentShowHint = False
      ShowHint = True
      OnClick = lblInvitorClick
    end
    object lblFiller1: TTntLabel
      Left = 78
      Top = 0
      Width = 155
      Height = 16
      Align = alLeft
      Caption = ' has invited you to join the '
    end
    object lblRoom: TTntLabel
      Left = 233
      Top = 0
      Width = 69
      Height = 16
      Align = alLeft
      Caption = '<<Room>>'
      Constraints.MaxWidth = 535
      ParentShowHint = False
      ShowAccelChar = False
      ShowHint = True
    end
    object TntLabel1: TTntLabel
      Left = 302
      Top = 0
      Width = 105
      Height = 16
      Caption = ' conference room.'
    end
  end
  object TntPanel4: TTntPanel
    AlignWithMargins = True
    Left = 3
    Top = 137
    Width = 531
    Height = 25
    Margins.Top = 12
    Margins.Bottom = 6
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object btnAccept: TTntButton
      Left = 288
      Top = 0
      Width = 75
      Height = 25
      Caption = '&Join'
      Default = True
      TabOrder = 0
      OnClick = btnAcceptClick
    end
    object btnDecline: TTntButton
      Left = 369
      Top = 0
      Width = 75
      Height = 25
      Caption = '&Decline'
      TabOrder = 1
      OnClick = btnDeclineClick
    end
    object btnIgnore: TTntButton
      Left = 450
      Top = 0
      Width = 76
      Height = 25
      Caption = '&Ignore'
      TabOrder = 2
      OnClick = btnIgnoreClick
    end
  end
  object ExGroupBox1: TExGroupBox
    AlignWithMargins = True
    Left = 24
    Top = 40
    Width = 489
    Height = 34
    Margins.Left = 24
    Margins.Top = 9
    Margins.Right = 24
    Margins.Bottom = 9
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'Invitation message:'
    ParentColor = True
    TabOrder = 2
    AutoHide = False
    object lblInviteMessage: TTntLabel
      Left = 0
      Top = 18
      Width = 489
      Height = 16
      Align = alTop
      Caption = 'No message was specified'
      Transparent = True
      WordWrap = True
      ExplicitWidth = 151
    end
  end
  object ExGroupBox2: TExGroupBox
    AlignWithMargins = True
    Left = 24
    Top = 83
    Width = 489
    Height = 42
    Margins.Left = 24
    Margins.Top = 0
    Margins.Right = 24
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = '&Reason for declining:'
    ParentColor = True
    TabOrder = 3
    AutoHide = False
    object txtReason: TTntEdit
      Left = 0
      Top = 18
      Width = 489
      Height = 24
      Margins.Left = 24
      Margins.Right = 24
      Align = alTop
      AutoSize = False
      Color = clCaptionText
      TabOrder = 1
      Text = 'Sorry, I'#39'm not interested in joining right now.'
    end
  end
end
