object frmAdd: TfrmAdd
  Left = 252
  Top = 233
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Add Contact'
  ClientHeight = 214
  ClientWidth = 251
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 41
    Width = 54
    Height = 13
    Caption = 'Contact ID:'
  end
  object Label2: TLabel
    Left = 8
    Top = 73
    Width = 51
    Height = 13
    Caption = 'Nickname:'
  end
  object Label3: TLabel
    Left = 8
    Top = 102
    Width = 32
    Height = 13
    Caption = 'Group:'
  end
  object lblAddGrp: TLabel
    Left = 94
    Top = 125
    Width = 83
    Height = 13
    Cursor = crHandPoint
    Caption = 'Add a new Group'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    OnClick = lblAddGrpClick
  end
  object Label4: TLabel
    Left = 8
    Top = 9
    Width = 67
    Height = 13
    Caption = 'Contact Type:'
  end
  object lblGateway: TLabel
    Left = 8
    Top = 153
    Width = 79
    Height = 13
    Caption = 'Gateway Server:'
    Enabled = False
  end
  object txtJID: TEdit
    Left = 94
    Top = 38
    Width = 139
    Height = 21
    TabOrder = 0
    OnExit = txtJIDExit
  end
  object txtNickname: TEdit
    Left = 94
    Top = 70
    Width = 139
    Height = 21
    TabOrder = 1
  end
  object cboGroup: TComboBox
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
    AutoScroll = False
    TabOrder = 3
    inherited Panel2: TPanel
      Width = 251
      Height = 34
      inherited Bevel1: TBevel
        Width = 251
      end
      inherited Panel1: TPanel
        Left = 91
        Height = 29
        inherited btnOK: TButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object cboType: TComboBox
    Left = 94
    Top = 8
    Width = 142
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = cboTypeChange
    Items.Strings = (
      'Jabber'
      'MSN'
      'Yahoo'
      'AIM'
      'ICQ')
  end
  object txtGateway: TEdit
    Left = 94
    Top = 150
    Width = 139
    Height = 21
    Enabled = False
    TabOrder = 5
    OnExit = txtJIDExit
  end
end
