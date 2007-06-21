object frmRemove: TfrmRemove
  Left = 276
  Top = 147
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  BorderWidth = 2
  Caption = 'Delete Contact'
  ClientHeight = 165
  ClientWidth = 371
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
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 131
    Width = 371
    Height = 34
    Align = alBottom
    TabOrder = 0
    TabStop = True
    ExplicitTop = 131
    ExplicitWidth = 371
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 371
      Height = 34
      ExplicitWidth = 371
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 371
        ExplicitWidth = 328
      end
      inherited Panel1: TPanel
        Left = 211
        Height = 29
        ExplicitLeft = 211
        ExplicitHeight = 29
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object optMove: TTntRadioButton
    Left = 8
    Top = 23
    Width = 355
    Height = 17
    Caption = 'Delete this contact from this group'
    TabOrder = 1
    OnClick = optRemoveClick
  end
  object optRemove: TTntRadioButton
    Left = 8
    Top = 47
    Width = 233
    Height = 17
    Caption = 'Delete this contact from my contact list.'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = optRemoveClick
  end
  object chkRemove1: TTntCheckBox
    Left = 24
    Top = 71
    Width = 217
    Height = 17
    Caption = 'Delete this person from my contact list.'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object chkRemove2: TTntCheckBox
    Left = 24
    Top = 95
    Width = 289
    Height = 17
    Caption = 'Force this person to delete me from their contact list'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object lblJid: TEdit
    Left = 8
    Top = 0
    Width = 305
    Height = 21
    AutoSize = False
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 5
    Text = 'lblJid'
  end
end
