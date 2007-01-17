object frmAdd: TfrmAdd
  Left = 252
  Top = 233
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Add Contact'
  ClientHeight = 214
  ClientWidth = 251
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TTntLabel
    Left = 8
    Top = 41
    Width = 54
    Height = 13
    Caption = 'Contact ID:'
  end
  object Label2: TTntLabel
    Left = 8
    Top = 73
    Width = 51
    Height = 13
    Caption = 'Nickname:'
  end
  object Label3: TTntLabel
    Left = 8
    Top = 102
    Width = 32
    Height = 13
    Caption = 'Group:'
  end
  object lblAddGrp: TTntLabel
    Left = 94
    Top = 125
    Width = 83
    Height = 13
    Cursor = crHandPoint
    Caption = 'Add a new Group'
    Color = clBtnFace
    ParentColor = False
    OnClick = lblAddGrpClick
  end
  object Label4: TTntLabel
    Left = 8
    Top = 9
    Width = 67
    Height = 13
    Caption = 'Contact Type:'
  end
  object lblGateway: TTntLabel
    Left = 8
    Top = 153
    Width = 79
    Height = 13
    Caption = 'Gateway Server:'
    Enabled = False
  end
  object txtJID: TTntEdit
    Left = 94
    Top = 38
    Width = 139
    Height = 21
    TabOrder = 0
    OnExit = txtJIDExit
  end
  object txtNickname: TTntEdit
    Left = 94
    Top = 70
    Width = 139
    Height = 21
    TabOrder = 1
    OnChange = txtNicknameChange
  end
  object cboGroup: TTntComboBox
    Left = 94
    Top = 101
    Width = 142
    Height = 21
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 180
    Width = 251
    Height = 34
    Align = alBottom
    TabOrder = 3
    TabStop = True
    ExplicitTop = 180
    ExplicitWidth = 251
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 251
      Height = 34
      ExplicitWidth = 251
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 251
        ExplicitWidth = 251
      end
      inherited Panel1: TPanel
        Left = 91
        Height = 29
        ExplicitLeft = 91
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
  object cboType: TTntComboBox
    Left = 94
    Top = 8
    Width = 142
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = cboTypeChange
  end
  object txtGateway: TTntEdit
    Left = 94
    Top = 150
    Width = 139
    Height = 21
    Enabled = False
    TabOrder = 5
    OnExit = txtJIDExit
  end
end
