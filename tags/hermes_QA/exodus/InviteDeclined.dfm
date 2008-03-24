inherited FrmInviteDeclined: TFrmInviteDeclined
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Declined Room Invitation'
  ClientHeight = 125
  ClientWidth = 406
  OnCreate = TntFormCreate
  OnDestroy = TntFormDestroy
  ExplicitWidth = 412
  ExplicitHeight = 163
  PixelsPerInch = 120
  TextHeight = 16
  object lblDeclined: TTntLabel
    AlignWithMargins = True
    Left = 15
    Top = 9
    Width = 376
    Height = 32
    Margins.Left = 15
    Margins.Top = 9
    Margins.Right = 15
    Align = alTop
    Caption = 
      'Your invitation to <<USER>> to join the room <<ROOM>> was declin' +
      'ed.'
    WordWrap = True
    ExplicitWidth = 370
  end
  object lblReason: TTntLabel
    AlignWithMargins = True
    Left = 15
    Top = 53
    Width = 376
    Height = 16
    Margins.Left = 15
    Margins.Top = 9
    Margins.Right = 15
    Align = alTop
    Caption = 'Reason for declining: Sorry, not interested.'
    WordWrap = True
    ExplicitWidth = 247
  end
  object TntPanel1: TTntPanel
    AlignWithMargins = True
    Left = 3
    Top = 81
    Width = 400
    Height = 41
    Margins.Top = 9
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 88
    ExplicitTop = 96
    ExplicitWidth = 185
    object TntButton1: TTntButton
      Left = 325
      Top = 14
      Width = 72
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = TntButton1Click
    end
  end
end
